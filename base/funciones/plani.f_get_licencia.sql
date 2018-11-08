CREATE OR REPLACE FUNCTION plani.f_get_licencia (
  p_id_funcionario integer,
  p_fecha_fin date
)
RETURNS boolean AS
$body$
	/*Verifica si un funcionario tiene licencia para este periodo*/
DECLARE

    v_nombre_empleado		text;
    v_resp	            	varchar;
    v_nombre_funcion      	text;
    v_mensaje_error       	text;
    v_licencia_vigecia      record;
    v_vigente 				boolean;
BEGIN
	v_nombre_funcion = 'plani.f_get_licencia';

  	select tli.desde, tli.hasta
    into v_licencia_vigecia
    from plani.tlicencia tli
    where tli.id_funcionario = p_id_funcionario;

    v_vigente = p_fecha_fin between v_licencia_vigecia.desde and v_licencia_vigecia.hasta;

    return v_vigente;

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