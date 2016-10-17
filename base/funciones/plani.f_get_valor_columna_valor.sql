CREATE OR REPLACE FUNCTION plani.f_get_valor_columna_valor (
  p_codigo_columna varchar,
  p_id_funcionario_planilla integer
)
RETURNS numeric AS
$body$
DECLARE  
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_valor					numeric;
BEGIN
  v_nombre_funcion = 'plani.f_get_valor_columna_valor';
  --obtener id_tipo_columna
  
  SELECT
     cv.valor
  INTO
     v_valor
  FROM plani.tcolumna_valor cv
  WHERE cv.id_funcionario_planilla = p_id_funcionario_planilla and 
  cv.codigo_columna = p_codigo_columna;
  
  
  return v_valor;
  
  
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;