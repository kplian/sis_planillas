CREATE OR REPLACE FUNCTION plani.f_tiene_incremento_escala (
  p_id_escala integer,
  p_gestion numeric
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
	v_nombre_funcion = 'plani.f_tiene_incremento_escala';
    v_fecha_ini = ('01/01/' || p_gestion)::date;
    v_fecha_fin = ('31/12/' || p_gestion)::date;
    
    select * into v_escala
    from orga.tescala_salarial
    where id_escala_salarial = p_id_escala;
    
    if (v_escala.fecha_ini between v_fecha_ini and v_fecha_fin) then
    	select * into v_escala_anterior
        from orga.tescala_salarial es
        where es.id_escala_padre = p_id_escala and es.fecha_fin = v_escala.fecha_ini  - interval '1 day';
        if (v_escala_anterior.haber_basico < v_escala.haber_basico) then
        	return true;
        else
        	return false;
        end if;
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