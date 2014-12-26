CREATE OR REPLACE FUNCTION plani.f_fun_regreso_planilla_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   JRR
*  DESC:    funcion que actualiza los estados despues del registro de un anterior en planilla
*  Fecha:   17/10/2014
*
*/

DECLARE

	v_nombre_funcion   	 text;
    v_resp    			 varchar;
    v_mensaje 			 varchar;
    
    v_planilla 			 record;
    v_monto_ejecutar_mo  numeric;
    v_empleados			 record;
    v_columnas			 record;
    v_cantidad_horas_mes integer;
    v_suma_horas			integer;
    v_suma_sueldo			numeric;
    v_suma_porcentaje		numeric;
    v_id_horas_trabajadas	integer;
    v_registros				record;
   
	
    
BEGIN

	 v_nombre_funcion = 'plani.f_fun_regreso_planilla_wf';
    
     select pla.*, pe.fecha_ini, pe.fecha_fin
      into v_planilla
      from plani.tplanilla pla
      left join param.tperiodo pe on pe.id_periodo = pla.id_periodo 
      where id_proceso_wf = p_id_proceso_wf;
          
    -----------------------------------------------------------------------------------
    -- validacion del prorrateo--  (con el codigo actual de estado antes de cambiarlo)   
    -----------------------------------------------------------------------------------
          
     IF p_codigo_estado  in ('registro_funcionarios')  THEN 
     		update plani.tcolumna_valor
            set valor = 0,
            valor_generado = 0
            from plani.tfuncionario_planilla fp
            where fp.id_funcionario_planilla = plani.tcolumna_valor.id_funcionario_planilla and
            fp.id_planilla = v_planilla.id_planilla;     
                    
            delete from plani.thoras_trabajadas using plani.tfuncionario_planilla
  			where plani.tfuncionario_planilla.id_funcionario_planilla = plani.thoras_trabajadas.id_funcionario_planilla and
            plani.tfuncionario_planilla.id_planilla = v_planilla.id_planilla;
            
            update plani.tcolumna_valor
            set valor = 0,
            valor_generado = 0
            from plani.tfuncionario_planilla fp
            where fp.id_funcionario_planilla = plani.tcolumna_valor.id_funcionario_planilla and
            fp.id_planilla = v_planilla.id_planilla;
            
            update plani.tcolumna_detalle
            set valor = 0,
            valor_generado = 0
            from plani.tcolumna_valor cv, plani.tfuncionario_planilla fp
            where cv.id_columna_valor = plani.tcolumna_detalle.id_columna_valor and
            fp.id_funcionario_planilla = cv.id_funcionario_planilla and
            fp.id_planilla = v_planilla.id_planilla;
            
     ELSIF p_codigo_estado  in ('registro_horas')  THEN              
            update plani.tcolumna_valor
            set valor = 0,
            valor_generado = 0
            from plani.tfuncionario_planilla fp
            where fp.id_funcionario_planilla = plani.tcolumna_valor.id_funcionario_planilla and
            fp.id_planilla = v_planilla.id_planilla;
            
                 
     elsif (p_codigo_estado  in ('calculo_columnas')) then
      
     		for v_empleados in (select * 
            					from plani.tfuncionario_planilla 
                                where id_planilla = v_planilla.id_planilla) loop
            	for v_columnas in (	select db.id_descuento_bono
                					from plani.tcolumna_valor cv
                                    inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                                    inner join plani.tdescuento_bono db on tc.id_tipo_columna = db.id_tipo_columna and
                                    								db.id_funcionario = v_empleados.id_funcionario and db.estado_reg = 'activo'
                                    where cv.id_funcionario_planilla = v_empleados.id_funcionario_planilla and
                                    	tc.tipo_descuento_bono = 'cantidad_cuotas') loop
                	update plani.tdescuento_bono
                    	set monto_total = monto_total + valor_por_cuota
                    where id_descuento_bono = v_columnas.id_descuento_bono;
                end loop;
            end loop;
            
     elsif (p_codigo_estado  in ('calculo_validado')) then  
         
     	--eliminar prorrateo asociado al funcionario
        delete from plani.tprorrateo_columna using plani.tprorrateo,plani.tfuncionario_planilla
        where plani.tprorrateo_columna.id_prorrateo = plani.tprorrateo.id_prorrateo and 
        plani.tprorrateo.id_funcionario_planilla = plani.tfuncionario_planilla.id_funcionario_planilla and
        plani.tfuncionario_planilla.id_planilla = v_planilla.id_planilla;
  
        delete from plani.tprorrateo using plani.tfuncionario_planilla
        where plani.tprorrateo.id_funcionario_planilla = plani.tfuncionario_planilla.id_funcionario_planilla and
        id_planilla = v_planilla.id_planilla; 
        
        --eliminacion de consolidacion_columna
        delete from plani.tconsolidado_columna using plani.tconsolidado
        where plani.tconsolidado_columna.id_consolidado = plani.tconsolidado.id_consolidado and 
        plani.tconsolidado.id_planilla = v_planilla.id_planilla;
            
        --eliminacion de las consolidaciones
        delete from plani.tconsolidado
        where id_planilla = v_planilla.id_planilla;
     
     elsif (p_codigo_estado  in ('presupuestos_validado')) then    
     		         
     		--eliminacion de obligacion_columna
            delete from plani.tobligacion_columna using plani.tobligacion
            where plani.tobligacion_columna.id_obligacion = plani.tobligacion.id_obligacion and 
            plani.tobligacion.id_planilla = v_planilla.id_planilla;
            
            --eliminacion de detalle_transferencia
            delete from plani.tdetalle_transferencia using plani.tobligacion
            where plani.tdetalle_transferencia.id_obligacion = plani.tobligacion.id_obligacion and 
            plani.tobligacion.id_planilla = v_planilla.id_planilla;   
            
             --eliminacion de las obligaciones
            delete from plani.tobligacion
            where id_planilla = v_planilla.id_planilla;     	 
        	        
     END IF;     
      
    -- actualiza estado en la solicitud
    update plani.tplanilla  set 
       id_estado_wf =  p_id_estado_wf,
       estado = p_codigo_estado,
       id_usuario_mod=p_id_usuario,
       id_usuario_ai = p_id_usuario_ai,
       usuario_ai = p_usuario_ai,
       fecha_mod=now()                   
    where id_proceso_wf = p_id_proceso_wf;   

	RETURN   TRUE;

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