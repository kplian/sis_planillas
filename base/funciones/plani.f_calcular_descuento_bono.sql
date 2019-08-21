--------------- SQL ---------------

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
 
  HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                       DESCRIPCION
   
 #0               27/01/2014        Jaim Rivera Rojas(Kplian)  Creacion 
 #27               21-08-2019        Rarteaga                   Considera moenda dolares
**********************************************************************************************
*/
DECLARE
	v_resp	            	varchar;
  	v_nombre_funcion      	text;
  	v_mensaje_error       	text;	
	v_registros 			record;
	v_resultado				numeric; 
    v_tiene_descuento		INTEGER;   	
    v_cantidad_decuento_bono integer;
    v_id_funcionario         integer;  --#21
    v_id_moneda_bono         integer;  --#21
    v_fecha_plt              date;     --#21
    v_nombre_fun             varchar;  --#21
    
BEGIN
	v_nombre_funcion = 'plani.f_calcular_descuento_bono';
    if (p_tipo_descuento_bono = 'monto_fijo_indefinido') then
    	select 
               sum(db.valor_por_cuota),
               1,
               count(*),
               db.id_moneda 
            into 
               v_resultado,
               v_tiene_descuento,
               v_cantidad_decuento_bono,
               v_id_moneda_bono
        from plani.tdescuento_bono db
        where db.id_funcionario = p_id_funcionario and db.fecha_ini <= p_fecha_ini and 
        (db.fecha_fin > p_fecha_ini or db.fecha_fin is null) and
        db.id_tipo_columna = p_id_tipo_columna
        group by db.id_moneda;
        
    elsif (p_tipo_descuento_bono = 'cantidad_cuotas') then
    	
        select 
              sum(db.valor_por_cuota),
              1,
              count(*),
              db.id_moneda 
          into 
              v_resultado,
              v_tiene_descuento,
              v_cantidad_decuento_bono,
              v_id_moneda_bono
        from plani.tdescuento_bono db
        where db.id_funcionario = p_id_funcionario and db.estado_reg = 'activo' and
        db.id_tipo_columna = p_id_tipo_columna and db.fecha_ini <= p_fecha_ini and 
        db.monto_total > 0
        group by db.id_moneda;
    
    elsif (p_tipo_descuento_bono = 'monto_fijo_por_fechas') then
    	
    	select 
             sum(db.valor_por_cuota),
             1,
             count(*) ,
             db.id_moneda
          into 
             v_resultado,
             v_tiene_descuento,
             v_cantidad_decuento_bono,
             v_id_moneda_bono
        from plani.tdescuento_bono db
        where db.id_funcionario = p_id_funcionario and db.estado_reg = 'activo' and
        db.id_tipo_columna = p_id_tipo_columna and db.fecha_ini <= p_fecha_ini and 
        (db.fecha_fin is null or db.fecha_fin > p_fecha_ini)
        group by db.id_moneda;
    end if;
    
    
    --#21 calculo de moneda del bono
    SELECT 
       plt.fecha_planilla ,
       fp.id_funcionario
     into 
       v_fecha_plt,
       v_id_funcionario 
    FROM plani.tplanilla plt 
    INNER JOIN plani.tfuncionario_planilla fp ON fp.id_planilla = plt.id_planilla
    WHERE fp.id_funcionario_planilla = p_id_funcionario_planilla;
       
    -- si la moneda no es base convertimos 
    IF  v_id_moneda_bono !=   param.f_get_moneda_base() THEN
    
         IF p_tipo_dato in  ('basica', 'formula') THEN
           
           select   
             fun.desc_funcionario1  
            into 
             v_nombre_fun
           from orga.vfuncionario fun 
           where fun.id_funcionario = v_id_funcionario;
            
           raise exception 'la columnas de tipo basica y formula solo se calculan en moneda base, revise la configuración de bonos/descuentos para:  %', v_nombre_fun;
         END IF;
         
         v_resultado = param.f_convertir_moneda(
                           v_id_moneda_bono,
                           NULL,   --por defecto moenda base
                           v_resultado,
                           v_fecha_plt,
                           'O',-- tipo oficial, venta, compra
                           NULL);--defecto dos decimales
       
    END IF;
    
    
    
    if (p_tipo_dato = 'basica' and v_tiene_descuento =1) then
    	
        v_resultado = plani.f_calcular_basica(p_id_funcionario_planilla, p_fecha_ini, p_fecha_fin, p_id_tipo_columna,p_codigo_columna,p_id_columna_valor);        
        v_resultado = v_cantidad_decuento_bono * v_resultado;                                
        
    elsif (p_tipo_dato = 'formula' and v_tiene_descuento =1) then
    	
        v_resultado = plani.f_calcular_formula(p_id_funcionario_planilla,  p_formula, p_fecha_ini, p_id_columna_valor);    	
        v_resultado = v_cantidad_decuento_bono * v_resultado;
        
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