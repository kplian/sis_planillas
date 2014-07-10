CREATE OR REPLACE FUNCTION plani.f_get_cuenta_bancaria_empleado (
  p_id_funcionario integer,
  p_fecha date
)
RETURNS integer AS
$body$
	/*Obtiene la cuenta bancaria de un empleado a la fecha indicada y devuelve el id_funcionario_cuenta_bancaria*/
DECLARE
    v_id_cuenta				integer;
    v_nombre_empleado		text;
    v_resp	            	varchar;
    v_nombre_funcion      	text;
    v_mensaje_error       	text;
BEGIN
	v_nombre_funcion = 'plani.f_get_cuenta_bancaria_empleado';
    
  	select fc.id_funcionario_cuenta_bancaria
    into v_id_cuenta
    from orga.tfuncionario_cuenta_bancaria  fc    	
    where fc.id_funcionario = p_id_funcionario and fc.fecha_ini <= p_fecha and 
    	(fc.fecha_fin is null or fc.fecha_fin >= p_fecha) and fc.estado_reg = 'activo'; 
	
    return v_id_cuenta;
    
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