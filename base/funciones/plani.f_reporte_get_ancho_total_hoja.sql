CREATE OR REPLACE FUNCTION plani.f_reporte_get_ancho_total_hoja (
  p_hoja varchar
)
RETURNS integer AS
$body$
DECLARE  
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_ancho_utilizado			integer;
  v_reg						record;
BEGIN
	v_nombre_funcion = 'plani.f_reporte_get_ancho_total_hoja';
	
	if (p_hoja = 'carta_horizontal') then
		return 249;
	elsif (p_hoja = 'carta_vertical') then
		return 186;
	elsif (p_hoja = 'oficio_vertical') then
		return 300;
  	else
  		return 186;
  	end if;  	
  
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