CREATE OR REPLACE FUNCTION plani.f_tiene_incremento_parametro (
  p_codigo varchar,
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
    v_parametro						record;
    v_parametro_anterior			record;
    
    
BEGIN
	v_nombre_funcion = 'plani.f_tiene_incremento_parametro';
    v_fecha_ini = ('01/01/' || p_gestion)::date;
    v_fecha_fin = ('31/12/' || p_gestion)::date;
    
    select distinct on (codigo) codigo,id_parametro_valor,fecha_ini,fecha_fin,valor into v_parametro
    from plani.tparametro_valor
    where codigo = p_codigo and estado_reg = 'activo'
    order by codigo,fecha_ini desc;
    
    if (v_parametro.fecha_ini between v_fecha_ini and v_fecha_fin) then
    	
    	select * into v_parametro_anterior
        from plani.tparametro_valor p
        where p.codigo = p_codigo and p.fecha_fin = v_parametro.fecha_ini  - interval '1 day';
        
        if (v_parametro_anterior.valor < v_parametro.valor) then
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