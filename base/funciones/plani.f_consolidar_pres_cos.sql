CREATE OR REPLACE FUNCTION plani.f_consolidar_pres_cos (
  p_id_planilla integer,
  p_tipo_generacion varchar,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
/*
    Autor: Guy Ribera Rojas
    Fecha: 28-09-2013
    Descripción:  calculo de prorrateo por centro de costo apra determinar el gasto de las planillas
 
  ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               28-09-2013        GUY BOA             Creacion 
 #1               22-02-2019        Rarteaga            Integracion con sistema de asistencias , hoja_calculo

*/
DECLARE
  v_registros		record;
  v_resp	            	varchar;
  v_nombre_funcion      	text;
  v_mensaje_error       	text;
  v_planilla				record;
  v_consulta				varchar;
  v_presupuesto				record;
  v_id_presupuesto			integer;
  v_count					integer;
  v_campo					varchar;
  v_id_prorrateo			integer;
  v_id_consolidado			integer;
  v_columnas				record;
  v_id_consolidado_columna	integer;
  v_valor_acumulado			numeric;
  v_valor_ejecutado			numeric;
  v_tipo_contrato			varchar;
  v_id_pres_adm				integer;
  v_suma_parcial           numeric;  --#1
BEGIN
	v_nombre_funcion = 'plani.f_consolidar_pres_cos';
	SELECT p.*,tp.tipo_presu_cc,tp.calculo_horas,id_gestion
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    where p.id_planilla = p_id_planilla;
    /*Verificar si se hara la consolidacion por presupuesto o por centro de costo*/
    if (p_tipo_generacion = 'presupuestos') then
        v_campo = 'pro.id_presupuesto';
    else
        v_campo = 'pro.id_cc';
    end if;    
    
    if (v_planilla.tipo_presu_cc = 'parametrizacion' and v_planilla.calculo_horas = 'si') then
    	v_tipo_contrato = 'ht.tipo_contrato';
        v_consulta = 'select ' || v_campo || ' as id_campo
    					from plani.tprorrateo pro
                        inner join plani.thoras_trabajadas ht on ht.id_horas_trabajadas = pro.id_horas_trabajadas
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = ht.id_funcionario_planilla
                        where id_planilla = ' || p_id_planilla || '
                        group by ' || v_campo ;
    --#1 adiciona hoja de calculo                    
    elsif (v_planilla.tipo_presu_cc IN('hoja_calculo','ultimo_activo_gestion_anterior','ultimo_activo_gestion','ultimo_activo_periodo', 'prorrateo_aguinaldo', 'retroactivo_sueldo' ,'retroactivo_asignaciones') ) then
    	
        v_tipo_contrato = 'pro.tipo_contrato';    	
        v_consulta = 'select ' || v_campo || ' as id_campo 
    					from plani.tprorrateo pro
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = pro.id_funcionario_planilla
                        where id_planilla = ' || p_id_planilla || '
                        group by ' || v_campo ;
    end if;
    --recorrer todos los presupuestos que hay en la planilla
    for v_registros in execute(v_consulta) loop
    	
            INSERT INTO 
          plani.tconsolidado
        (
          id_usuario_reg,
          fecha_reg,
          estado_reg,
          id_planilla,
          id_presupuesto,
          id_cc,
          tipo_consolidado
        ) 
        VALUES (
          p_id_usuario,
          now(),
          'activo',
          p_id_planilla,
          case when p_tipo_generacion = 'presupuestos' THEN
          	v_registros.id_campo
          else
          	NULL
          END,
          case when p_tipo_generacion = 'costos' THEN
          	v_registros.id_campo
          else
          	NULL
          END,
          p_tipo_generacion
        )RETURNING id_consolidado into v_id_consolidado;
        
        --#1  apra cacula el total de centro de costo o presupesuto
        
        v_consulta = 'select ' || v_tipo_contrato || ',cv.id_tipo_columna,cv.codigo_columna,sum(cv.valor*procol.porcentaje/100) as valor,procol.compromete, sum(cv.valor) as total_valor_cv
    					from plani.tprorrateo pro ';
                        
                        
    	if (v_planilla.tipo_presu_cc = 'parametrizacion' and v_planilla.calculo_horas = 'si') then
        	
            v_consulta = v_consulta || 'inner join plani.thoras_trabajadas ht on ht.id_horas_trabajadas = pro.id_horas_trabajadas
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = ht.id_funcionario_planilla
                        ';     
                        
        --#1 adiciona hoja de calculo                
        elsif (v_planilla.tipo_presu_cc IN  ('hoja_calculo','ultimo_activo_gestion','ultimo_activo_gestion_anterior','ultimo_activo_periodo','prorrateo_aguinaldo', 'retroactivo_sueldo' ,'retroactivo_asignaciones')) then
        	v_consulta = v_consulta || ' inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = pro.id_funcionario_planilla
                        ';
        end if;
        
        v_consulta = v_consulta || ' inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
                        inner join plani.tprorrateo_columna procol on procol.id_prorrateo = pro.id_prorrateo
                        											and procol.id_tipo_columna = cv.id_tipo_columna
                        where cv.valor > 0 and id_planilla = ' || p_id_planilla || ' and ' || v_campo || ' = ' || v_registros.id_campo || '
                        group by ' || v_tipo_contrato || ',cv.id_tipo_columna,cv.codigo_columna,procol.compromete';
                        
        v_suma_parcial = 0;                
        
        for v_columnas in execute (v_consulta) loop
        	if (p_tipo_generacion = 'costos' or 
            	(p_tipo_generacion = 'presupuestos' and v_columnas.compromete = 'si_contable')) then
            	v_valor_ejecutado = 0;
            else
            	v_valor_ejecutado = v_columnas.valor;
            end if;
        	
        	INSERT INTO 
              plani.tconsolidado_columna
            (
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              id_consolidado,
              id_tipo_columna,
              codigo_columna,
              valor,
              tipo_contrato,
              valor_ejecutado
            ) 
            VALUES (
              p_id_usuario,
              now(),
              'activo',
              v_id_consolidado,
              v_columnas.id_tipo_columna,
              v_columnas.codigo_columna,
              v_columnas.valor,
              v_columnas.tipo_contrato,
              v_valor_ejecutado
            )RETURNING id_consolidado_columna into v_id_consolidado_columna;
            
            v_suma_parcial =  v_suma_parcial + v_columnas.valor; 
            
            
            --calcular el ejecutado de las planillas que tienen la misma columna y q esten en estado finalizado
            if (v_planilla.tipo_presu_cc = 'ultimo_activo_aguinaldo') then
            	if (p_tipo_generacion = 'presupuestos') then            
                    select sum(concol.valor) into v_valor_acumulado
                    from plani.tplanilla p
                    inner join plani.tconsolidado con on con.id_planilla = p.id_planilla
                    inner join plani.tconsolidado_columna concol on con.id_consolidado = concol.id_consolidado
                    where p.estado = 'finalizado' and concol.codigo_columna = v_columnas.codigo_columna and 
                        id_gestion = v_planilla.id_gestion and con.id_presupuesto = v_registros.id_campo;
                else
                	select sum(concol.valor) into v_valor_acumulado
                    from plani.tplanilla p
                    inner join plani.tconsolidado con on con.id_planilla = p.id_planilla
                    inner join plani.tconsolidado_columna concol on con.id_consolidado = concol.id_consolidado
                    where p.estado = 'finalizado' and concol.codigo_columna = v_columnas.codigo_columna and 
                        id_gestion = v_planilla.id_gestion and con.id_cc = v_registros.id_campo;
                end if;
                    
                update plani.tconsolidado_columna
                set valor_ejecutado = v_valor_acumulado
                where id_consolidad_columna = v_id_consolidado_columna;                
               
            end if;
        
        end loop;
        
        --#1 el ultimo lo calcula por resta
       --  update plani.tconsolidado_columna
       --   set valor = v_columnas.total_valor_cv  - (v_suma_parcial - v_columnas.valor)
      --   where id_consolidado_columna = v_id_consolidado_columna; 
        
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
