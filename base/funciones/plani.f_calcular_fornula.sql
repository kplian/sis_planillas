CREATE OR REPLACE FUNCTION plani.f_calcular_formula (
  p_id_funcionario_planilla integer,
  p_formula varchar,
  p_fecha_ini date
)
RETURNS numeric AS
$body$
/**************************************************************************
 PLANI
***************************************************************************
 SCRIPT:
 COMENTARIOS:
 AUTOR: Jaim Rivera (Kplian)
 DESCRIP: Calcula la fórmula que recibe como parametro
 PRECONDICION: todos los valores de las variables en la formula ya fueron calculados
 Fecha: 27/01/2014

*/
DECLARE
	v_resp	            varchar;
  	v_nombre_funcion      text;
  	v_mensaje_error       text;
	v_respuesta varchar;
	v_registros record;
	v_resultado numeric;
	v_existen_variables boolean;
	v_cantidad_variables integer;
	v_formula varchar;
	v_cod_columna varchar;
	v_cod_columna_limpio varchar;
    v_valor_columna numeric;
    	
BEGIN
	v_nombre_funcion = 'plani.f_calcular_formula';
    -- iniciamos llave while
    v_existen_variables = true;
    v_cantidad_variables = 0;
    v_formula = p_formula;

	while (v_existen_variables  =true) LOOP
    	
        v_cod_columna = NULL;
     	v_cod_columna_limpio = NULL;
        --Obtenemos una variable dentro de la formula
        v_cod_columna  =  substring(v_formula from '%#"#{%#}#"%' for '#');

      	--Si se encontró alguna variable
  		IF  v_cod_columna IS NOT NULL THEN         
        	v_cantidad_variables = v_cantidad_variables+1;
            --quitar las llaves de la variable          
            v_cod_columna_limpio= split_part(v_cod_columna,'{',2);
            v_cod_columna_limpio= split_part( v_cod_columna_limpio,'}',1);
            --validar que la columna esta en columna_valor            
            
            SELECT
               cv.valor
            INTO
               v_valor_columna
            FROM plani.tcolumna_valor cv
            WHERE cv.codigo_columna = v_cod_columna_limpio  and 
            	cv.id_funcionario_planilla = p_id_funcionario_planilla;
            
            if (v_valor_columna is null) then
            	v_valor_columna = (plani.f_get_valor_parametro_valor(v_cod_columna_limpio, p_fecha_ini));
            end if;
            
            if (v_valor_columna is null) then            	
        		raise exception 'No se encontro la columna %, definida en la formula : %',
                				v_cod_columna_limpio,p_formula;
            end if;
                       
             
            v_formula = replace( v_formula, v_cod_columna, COALESCE(v_valor_columna,0.00)::varchar);
                                
    	ELSE          
        	v_existen_variables := false;
     	END IF;
	END LOOP;
	
	-- evaluar formula si la cantidad de variables es > 0
  	IF v_cantidad_variables > 0 THEN  
  		
    	FOR v_registros in EXECUTE('SELECT ('|| v_formula||') as res') LOOP
        	v_resultado = coalesce(v_registros.res,0);          
    	END LOOP;
    	
  	ELSE
    	RAISE EXCEPTION  'La formula % no contiene variables',v_formula;
  	END IF;     
  	return v_resultado;
EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje','formula: '|| p_formula || '------' || v_formula || '-------' || SQLERRM);
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