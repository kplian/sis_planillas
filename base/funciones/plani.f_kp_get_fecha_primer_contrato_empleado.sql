CREATE OR REPLACE FUNCTION plani.f_get_fecha_primer_contrato_empleado (
  p_id_uo_funcionario integer,
  p_id_funcionario integer,
  p_fecha_ini date
)
RETURNS date AS
$body$
DECLARE
  v_fecha_ini				date;
  v_id_uo_funcionario		integer;
  v_resp	            	varchar;
  v_nombre_funcion      	text;
  v_mensaje_error       	text;
BEGIN
  v_fecha_ini = null;
  v_nombre_funcion = 'plani.f_kp_get_fecha_primer_contrato_empleado';
  select uofun.id_uo_funcionario, uofun.fecha_asignacion
  into	v_id_uo_funcionario, v_fecha_ini
  from orga.tuo_funcionario uofun 
  where uofun.id_funcionario = p_id_funcionario and uofun.fecha_finalizacion = p_fecha_ini - interval '1 day'
  		and estado_reg != 'inactivo' and uofun.tipo = 'oficial';
  
  if (v_fecha_ini is not null) then
  	v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado(v_id_uo_funcionario, p_id_funcionario, v_fecha_ini);
  else
  	v_fecha_ini = p_fecha_ini;
  end if;
  return v_fecha_ini;
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