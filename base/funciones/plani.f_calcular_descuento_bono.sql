CREATE OR REPLACE FUNCTION plani.f_calcular_descuento_bono (
  p_id_funcionario integer,
  p_fecha_ini date,
  p_fecha_fin date,
  p_id_tipo_columna integer,
  p_tipo_descuento_bono varchar,
  p_formula text,
  p_id_funcionario_planilla integer,
  p_codigo_columna varchar,
  p_tipo_dato varchar,
  p_id_columna_valor integer
)
RETURNS numeric AS
$body$
/**************************************************************************
 PLANI
***************************************************************************
 SCRIPT:
 COMENTARIOS:
 AUTOR: Jaim Rivera (Kplian)
 DESCRIP: Calcula columnas de tipo descuento bono
 Fecha: 27/01/2014

*/
DECLARE
	v_resp	            	varchar;
  	v_nombre_funcion      	text;
  	v_mensaje_error       	text;	
	v_registros 			record;
	v_resultado				numeric; 
    v_tiene_descuento		INTEGER;   	
BEGIN
	v_nombre_funcion = 'plani.f_calcular_descuento_bono';
    if (p_tipo_descuento_bono = 'monto_fijo_indefinido') then
    	select db.valor_por_cuota,1 into v_resultado,v_tiene_descuento
        from plani.tdescuento_bono db
        where db.id_funcionario = p_id_funcionario and db.fecha_ini <= p_fecha_ini and 
        (db.fecha_fin > p_fecha_ini or db.fecha_fin is null) and
        db.id_tipo_columna = p_id_tipo_columna;
    elsif (p_tipo_descuento_bono = 'cantidad_cuotas') then
    	select db.valor_por_cuota,1 into v_resultado,v_tiene_descuento
        from plani.tdescuento_bono db
        where db.id_funcionario = p_id_funcionario and db.estado_reg = 'activo' and
        db.id_tipo_columna = p_id_tipo_columna and db.fecha_ini <= p_fecha_ini and 
        db.monto_total > 0;
    elsif (p_tipo_descuento_bono = 'monto_fijo_por_fechas') then
    	select db.valor_por_cuota,1 into v_resultado,v_tiene_descuento
        from plani.tdescuento_bono db
        where db.id_funcionario = p_id_funcionario and db.estado_reg = 'activo' and
        db.id_tipo_columna = p_id_tipo_columna and db.fecha_ini <= p_fecha_ini and 
        db.fecha_fin is not null and 
        db.fecha_fin > p_fecha_ini;
    end if;
    
    if (p_tipo_dato = 'basica' and v_tiene_descuento =1) then
    	v_resultado = plani.f_calcular_basica(p_id_funcionario_planilla, 
                        					p_fecha_ini, p_fecha_fin, p_id_tipo_columna,p_codigo_columna,p_id_columna_valor);
                                        
    elsif (p_tipo_dato = 'formula' and v_tiene_descuento =1) then
    	v_resultado = plani.f_calcular_formula(p_id_funcionario_planilla, 
                                                p_formula, p_fecha_ini, p_id_columna_valor);
    end if;
    
        
  	return coalesce (v_resultado, 0.00);
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