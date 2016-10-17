CREATE OR REPLACE FUNCTION plani.f_get_valor_parametro_valor (
  p_codigo_columna varchar,
  p_fecha date = now()
)
RETURNS numeric AS
$body$
DECLARE  
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_valor					numeric;
BEGIN
  v_nombre_funcion = 'plani.f_get_valor_parametro_valor';
  select pv.valor 
  into	v_valor 
  from plani.tparametro_valor pv
  where codigo = p_codigo_columna and estado_reg = 'activo' and 
                (fecha_fin is null or fecha_fin >= p_fecha);
  
  
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