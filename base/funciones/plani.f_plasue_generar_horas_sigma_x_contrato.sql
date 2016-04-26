CREATE OR REPLACE FUNCTION plani.f_plasue_generar_horas_sigma_x_contrato (
  p_id_planilla integer,
  p_id_usuario integer,
  p_id_funcionario_planilla integer = NULL::integer
)
RETURNS varchar AS
$body$
DECLARE
  v_empleados		record;
  v_asignacion		record;
  v_horas_contrato	integer;
  v_horas_total		integer;
  v_ultimo_id_uo_funcionario	integer;
  v_ultimo_id_mayor_uno		integer;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_cantidad_horas_mes		integer;
  v_planilla			record;
  v_filter				varchar;
  v_dia_fin				integer;
  v_mes_fin				integer;
  v_ano_fin				integer;
  v_horas_licencia		integer;
  v_horas_licencia_para_30 integer;
BEGIN
	v_nombre_funcion = 'plani.f_plasue_generar_horas_sigma_x_contrato';
	
	select id_tipo_planilla, per.id_periodo, fecha_ini, fecha_fin, id_uo, p.id_usuario_reg, 
    		((per.fecha_fin - per.fecha_ini) + 1) * 8 as horas_mes
    into v_planilla 
    from plani.tplanilla p
    inner join param.tperiodo per
    	on p.id_periodo = per.id_periodo
    where p.id_planilla = p_id_planilla;
    
    
    
    v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', v_planilla.fecha_ini)::integer;
    
    if (p_id_funcionario_planilla is not null) then
    	v_filter = ' where id_funcionario_planilla = ' || p_id_funcionario_planilla ;
    else
    	v_filter = ' where id_planilla = ' || p_id_planilla ;
    end if;
    
    for v_empleados in execute ('select * 
    					from plani.tfuncionario_planilla ' || v_filter) loop
                        
    	        
        for v_asignacion in (    	
            select
            uofun.id_uo_funcionario,
            (case when (uofun.fecha_asignacion < v_planilla.fecha_ini) then
                v_planilla.fecha_ini
            else
                uofun.fecha_asignacion
            end)::date as  fecha_ini_mes,
            (case when (uofun.fecha_finalizacion > v_planilla.fecha_fin or uofun.fecha_finalizacion is null) then
                v_planilla.fecha_fin
            else
                uofun.fecha_finalizacion
            end)::date as fecha_fin_mes,
            es.haber_basico,
            tc.codigo,
            fun.desc_funcionario1 as nombre_funcionario,
            ofi.zona_franca,
            ofi.frontera,
            es.id_escala_salarial,
            fun.id_funcionario
            from orga.tuo_funcionario uofun
            inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
            inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
            inner join orga.tescala_salarial es on car.id_escala_salarial = es.id_escala_salarial
            inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
            left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
            where uofun.fecha_asignacion <= v_planilla.fecha_fin and 
                (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= v_planilla.fecha_ini ) 
                AND uofun.estado_reg = 'activo' and uofun.tipo = 'oficial' and 
                tc.codigo in ('PLA', 'EVE') and uofun.id_uo_funcionario = v_empleados.id_uo_funcionario
            ) LOOP
            
        	v_dia_fin = extract(day from v_asignacion.fecha_fin_mes)::integer;
            
            if (v_dia_fin = 31) then
            	v_horas_licencia_para_30 = -8;
            elsif (v_dia_fin = 29) then
            	v_horas_licencia_para_30 = 8;
            elsif (v_dia_fin = 28) then
            	v_horas_licencia_para_30 = 16;
            end if;
            
            v_mes_fin = extract(month from v_asignacion.fecha_fin_mes)::integer;
            v_ano_fin = extract(year from v_asignacion.fecha_fin_mes)::integer;
            
            v_horas_contrato = ((v_asignacion.fecha_fin_mes - v_asignacion.fecha_ini_mes)*8) + (1*8);
            
             --obtener licencias para el empleado
            v_horas_licencia = 0;
            
            --las que estan dentro del rango
            v_horas_licencia = v_horas_licencia +
            coalesce((select sum((l.hasta - l.desde)* 8 + (1*8)) 
            from plani.tlicencia l
            where id_funcionario = v_asignacion.id_funcionario and
            l.estado_reg = 'activo' and l.desde >= v_asignacion.fecha_ini_mes AND
            l.hasta <= v_asignacion.fecha_fin_mes and l.estado = 'finalizado'),0);
            
            --las que estan inicio
            v_horas_licencia = v_horas_licencia +
            COALESCE((select sum((l.hasta - v_asignacion.fecha_ini_mes)* 8 + (1*8)) 
            from plani.tlicencia l
            where id_funcionario = v_asignacion.id_funcionario and
            l.estado_reg = 'activo' and l.desde < v_asignacion.fecha_ini_mes AND
            (l.hasta <= v_asignacion.fecha_fin_mes and l.hasta >= v_asignacion.fecha_ini_mes) and l.estado = 'finalizado'),0);
            
            --las que estan al final
            v_horas_licencia = v_horas_licencia +
            COALESCE((select sum((v_asignacion.fecha_fin_mes - l.desde)* 8 + (1*8)) + v_horas_licencia_para_30
            from plani.tlicencia l
            where id_funcionario = v_asignacion.id_funcionario and
            l.estado_reg = 'activo' and (l.desde >= v_asignacion.fecha_ini_mes AND l.desde <= v_asignacion.fecha_fin_mes) AND
            l.hasta > v_asignacion.fecha_fin_mes and l.estado = 'finalizado'),0);
            
            --las que van de lado a lado           
            v_horas_licencia = v_horas_licencia +
            COALESCE((select sum((v_asignacion.fecha_fin_mes - v_asignacion.fecha_ini_mes)* 8 + (1*8)) + v_horas_licencia_para_30
            from plani.tlicencia l
            where id_funcionario = v_asignacion.id_funcionario and
            l.estado_reg = 'activo' and l.desde < v_asignacion.fecha_ini_mes AND
            l.hasta > v_asignacion.fecha_fin_mes and l.estado = 'finalizado'),0);
            
            --Si la fecha fin es 31 se resta 8 horas
            if (v_dia_fin = 31) then
            	v_horas_contrato = v_horas_contrato - 8;
                if (v_horas_licencia > v_horas_contrato) then
                	v_horas_licencia = v_horas_contrato;
                end if;
            end if;
            
            --Si el dia fin es 29 y el mes fin es 2 se incrementa 8 horas
            if (v_dia_fin = 29 and v_mes_fin = 2) then
            	v_horas_contrato = v_horas_contrato + 8;
            end if;
            
            --Si el dia fin es 28 y el mes fin es 2 y el ano no es bisiesto se incrementa 16 horas
            if (v_dia_fin = 28 and v_mes_fin = 2 and pxp.isleapyear(v_ano_fin)= FALSE) then
            	v_horas_contrato = v_horas_contrato + 16;
            end if;
                                    
            
            if (v_horas_contrato > 0) then
               INSERT INTO 
                  plani.thoras_trabajadas
                (
                  id_usuario_reg,
                  id_uo_funcionario,
                  id_funcionario_planilla,
                  horas_normales,
                  horas_normales_contrato,
                  tipo_contrato,
                  sueldo,
                  fecha_ini,
                  fecha_fin,
                  zona_franca,
                  frontera
                ) 
                VALUES (
                  p_id_usuario,
                  v_asignacion.id_uo_funcionario,
                  v_empleados.id_funcionario_planilla,
                  v_horas_contrato - v_horas_licencia,
                  v_horas_contrato,
                  v_asignacion.codigo,
                  orga.f_get_haber_basico_a_fecha(v_asignacion.id_escala_salarial,v_planilla.fecha_ini),
                  v_asignacion.fecha_ini_mes,
                  v_asignacion.fecha_fin_mes,
                  v_asignacion.zona_franca,
                  v_asignacion.frontera
                ); 
            end if;           
        
        END LOOP;
       
    end loop; 
    return 'exito';

EXCEPTION
WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;		
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;