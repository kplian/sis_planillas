CREATE OR REPLACE FUNCTION plani.f_get_afp (
  p_id_funcionario integer,
  p_fecha date
)
RETURNS integer AS
$body$
	/*Obtiene la afp asignada a un empleado a la fecha indicada y devuelve el id_funcionario_afp*/
DECLARE
	
    v_id_afp				integer;
    v_nombre_empleado		text;
    v_resp	            	varchar;
    v_nombre_funcion      	text;
    v_mensaje_error       	text;
BEGIN
	v_nombre_funcion = 'plani.f_get_afp';
    
  	select fun.desc_funcionario1, id_funcionario_afp
    into v_nombre_empleado, v_id_afp
    from orga.vfuncionario fun
    left join plani.tfuncionario_afp fa on fun.id_funcionario = fa.id_funcionario 
    	and fa.fecha_ini <= p_fecha and 
    	(fa.fecha_fin is null or fa.fecha_fin >= p_fecha) and fa.estado_reg = 'activo'
    where fun.id_funcionario = p_id_funcionario; 
	
    if (v_id_afp is null) then
    	raise exception 'El empleado : % no tiene registrado la AFP correspondiente',v_nombre_empleado;
    end if;
	
    return v_id_afp;
    
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