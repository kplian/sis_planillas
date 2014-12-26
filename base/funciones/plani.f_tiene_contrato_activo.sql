CREATE OR REPLACE FUNCTION plani.f_tiene_contrato_activo (
  p_id_funcionario integer,
  p_fecha date
)
RETURNS boolean AS
$body$
DECLARE
  	v_planilla						record;
    v_obligacion					record;
  	v_resp		            		varchar;
	v_nombre_funcion        		text;
	v_gestion						numeric;
    v_fecha_ini						date;
    v_fecha_fin						date;
    v_escala						record;
    v_escala_anterior				record;
    
    
BEGIN
	v_nombre_funcion = 'plani.f_tiene_contrato_activo';
    if exists(	select 1
    			from orga.tuo_funcionario uofun
                where uofun.fecha_asignacion <=  p_fecha and
                (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= p_fecha) and
                uofun.estado_reg = 'activo' and uofun.tipo = 'oficial') then
    	return true;
    else
    	return false;
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;