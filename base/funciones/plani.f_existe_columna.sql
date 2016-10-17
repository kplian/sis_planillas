CREATE OR REPLACE FUNCTION plani.f_existe_columna (
  p_codigo_columna varchar,
  p_id_tipo_planilla integer = NULL::integer,
  p_fecha date = now()
)
RETURNS boolean AS
$body$
DECLARE  
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
BEGIN
  v_nombre_funcion = 'plani.f_existe_columna';
  if (exists (	select 1 
  				from plani.tparametro_valor pv
  				where codigo = p_codigo_columna and estado_reg = 'activo' and (fecha_fin is null or fecha_fin >= p_fecha)))then
  		return true;		
  end if;
  
  if (exists (	select 1 
  				from plani.ttipo_columna tc
  				where codigo = p_codigo_columna and id_tipo_planilla = p_id_tipo_planilla 
                and estado_reg = 'activo'))then
  		return true;		
  end if;
  
  return false;
  
EXCEPTION
WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);		
END;
$body$
LANGUAGE 'plpgsql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;