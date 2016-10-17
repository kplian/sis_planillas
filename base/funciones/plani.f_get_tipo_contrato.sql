CREATE OR REPLACE FUNCTION plani.f_get_tipo_contrato (
  p_id_uo_funcionario integer
)
RETURNS varchar AS
$body$
	/*Obtiene la cuenta bancaria de un empleado a la fecha indicada y devuelve el id_funcionario_cuenta_bancaria*/
DECLARE
    v_tipo_contrato			varchar;
    v_nombre_empleado		text;
    v_resp	            	varchar;
    v_nombre_funcion      	text;
    v_mensaje_error       	text;
BEGIN
	v_nombre_funcion = 'plani.f_get_tipo_contrato';
    
  	select tc.codigo
    into v_tipo_contrato
    from orga.tuo_funcionario  uofun
    inner join orga.tcargo car
    	on car.id_cargo = uofun.id_cargo
    inner join orga.ttipo_contrato tc   
    	on tc.id_tipo_contrato= car.id_tipo_contrato 	
    where uofun.id_uo_funcionario = p_id_uo_funcionario; 
	
    return v_tipo_contrato;
    
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