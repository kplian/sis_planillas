CREATE OR REPLACE FUNCTION plani.f_plasue_generar_horas (
  p_id_planilla integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
DECLARE
  v_empleados		record;
  v_asignacion		record;
  v_horas_contrato	integer;
  v_horas_total		integer;
  v_ultimo_id_uo_funcionario	integer;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_cantidad_horas_mes		integer;
  v_planilla			record;
BEGIN
	v_nombre_funcion = 'plani.f_plasue_generar_horas';
	
	select id_tipo_planilla, per.id_periodo, fecha_ini, fecha_fin, id_uo, p.id_usuario_reg, 
    		(per.fecha_fin - per.fecha_ini) + 1 as dias_mes
    into v_planilla 
    from plani.tplanilla p
    inner join param.tperiodo per
    	on p.id_periodo = per.id_periodo
    where p.id_planilla = p_id_planilla;
    
    v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', v_planilla.fecha_ini)::integer;
    
    for v_empleados in (select * 
    					from plani.tfuncionario_planilla 
                        where id_planilla = p_id_planilla) loop
    	v_horas_total = 0;
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
            ofi.frontera
            from orga.tuo_funcionario uofun
            inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
            inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
            inner join orga.tescala_salarial es on car.id_escala_salarial = es.id_escala_salarial
            inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
            left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
            where uofun.fecha_asignacion <= v_planilla.fecha_fin and 
                (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= v_planilla.fecha_ini ) 
                AND uofun.estado_reg = 'activo' and uofun.tipo = 'oficial' and 
                tc.codigo in ('PLA', 'EVE') and fun.id_funcionario = v_empleados.id_funcionario
            order by fecha_asignacion asc) LOOP
        	
            v_horas_contrato = ((v_asignacion.fecha_fin_mes - v_asignacion.fecha_ini_mes)*8) + (1*8);
            if (EXTRACT(DAY FROM v_asignacion.fecha_fin_mes) = 31 ) then
                v_horas_contrato = v_horas_contrato - (1*8);
            end if;
            v_horas_total = v_horas_total + v_horas_contrato;
            
           INSERT INTO 
              plani.thoras_trabajadas
            (
              id_usuario_reg,
              id_uo_funcionario,
              id_funcionario_planilla,
              horas_normales,
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
              v_horas_contrato,
              v_asignacion.codigo,
              v_asignacion.haber_basico,
              v_asignacion.fecha_ini_mes,
              v_asignacion.fecha_fin_mes,
              v_asignacion.zona_franca,
              v_asignacion.frontera
            );
            v_ultimo_id_uo_funcionario = v_asignacion.id_uo_funcionario;
        
        END LOOP;
        --si es el mes de febrero
        if(v_horas_total = v_planilla.dias_mes and v_horas_total < v_cantidad_horas_mes)THEN
        	       
            update plani.thoras_trabajadas
            set horas_normales = v_cantidad_horas_mes
            where id_uo_funcionario = v_ultimo_id_uo_funcionario and 
                id_funcionario_planilla = v_empleados.id_funcionario_planilla;
            
        end if; 
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