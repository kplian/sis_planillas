CREATE OR REPLACE FUNCTION plani.f_eliminar_funcionario_planilla (
  p_id_funcionario_planilla integer
)
RETURNS varchar AS
$body$
DECLARE
  v_registros			record;
  v_registros_2			record;
  v_resp	            varchar;
  v_nombre_funcion      text;
  v_mensaje_error       text;
BEGIN
	v_nombre_funcion = 'plani.f_eliminar_funcionario_planilla';
  
  --eliminar prorrateo asociado al funcionario
  delete from plani.tprorrateo_columna using plani.tprorrateo
  where plani.tprorrateo_columna.id_prorrateo = plani.tprorrateo.id_prorrateo and 
  plani.tprorrateo.id_funcionario_planilla = p_id_funcionario_planilla;
  
  delete from plani.tprorrateo
  where id_funcionario_planilla = p_id_funcionario_planilla;
  
  delete from plani.tcolumna_detalle using plani.thoras_trabajadas
  where plani.tcolumna_detalle.id_horas_trabajadas = plani.thoras_trabajadas.id_horas_trabajadas and 
  plani.thoras_trabajadas.id_funcionario_planilla = p_id_funcionario_planilla;
  
  
  delete from plani.thoras_trabajadas
  where id_funcionario_planilla = p_id_funcionario_planilla;
  
  delete from plani.tcolumna_valor
  where id_funcionario_planilla = p_id_funcionario_planilla;
     
  delete from plani.tfuncionario_planilla
  where id_funcionario_planilla = p_id_funcionario_planilla;
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