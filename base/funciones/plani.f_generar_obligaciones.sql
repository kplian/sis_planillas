CREATE OR REPLACE FUNCTION plani.f_generar_obligaciones (
  p_id_planilla integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
DECLARE
	v_planilla			  record;
    v_sql_tabla			  text;
    v_resp	              varchar;
    v_nombre_funcion      text;
    v_mensaje_error       text;
    v_registro			  record;
    v_anadir_select		  text;
    v_anadir_lugar		  text;
    v_where_lugar		  text;
    v_nombre_tabla	  	  varchar;	
    v_registros			  record;
    v_respuesta			  varchar;
    v_obligaciones		  record;
    v_detalles			  record;
    v_id_obligacion		  integer;
    v_lugar				  varchar;	  	
BEGIN
	v_nombre_funcion = 'plani.f_generar_obligaciones';
    --obtener datos de planilla
    select * into v_planilla
    from plani.tplanilla
    where id_planilla = p_id_planilla;
    v_nombre_tabla = 'tmp_plani_obli_' || p_id_planilla;
    
    --Crear tabla temporal con detalle de obligaciones
    v_sql_tabla = 'CREATE TEMPORARY TABLE ' || v_nombre_tabla || '
    		(	id_tipo_obligacion INTEGER, 
            	id_funcionario INTEGER, 
                nombre_funcionario TEXT, 
                id_funcionario_planilla INTEGER, 
                id_presupuesto INTEGER, 
                id_cc INTEGER, 
                tipo_contrato VARCHAR(10), 
                id_tipo_columna INTEGER, 
                codigo_columna VARCHAR(30), 
                porcentaje NUMERIC(5,2), 
                valor NUMERIC, 
                es_ultimo VARCHAR(2), 
                id_lugar INTEGER, 
                nombre_lugar VARCHAR(100), 
                id_afp INTEGER, 
                nombre_afp VARCHAR(300), 
                nro_afp VARCHAR(100), 
                nombre_banco VARCHAR(100), 
                id_institucion INTEGER, 
                nro_cuenta VARCHAR
  			) ON COMMIT DROP';     
    
    EXECUTE(v_sql_tabla);
    --se recorren todos los tipos de obligacion
    for v_registros in (select * 
    					from plani.ttipo_obligacion 
                        where id_tipo_planilla = v_planilla.id_tipo_planilla)loop
    	if (v_registros.dividir_por_lugar = 'si') then
        	v_anadir_lugar = ',id_lugar,nombre_lugar';                		
        else
        	v_anadir_lugar = '';
        end if;
        --llamada a funcion que llena la tabla temporal con detalle de obligaciones de la obligacion
        v_respuesta = plani.f_inserta_detalle_obligaciones(v_nombre_tabla,v_registros.id_tipo_obligacion,p_id_planilla);
    	
        --///////////////////////////////////PAGO EMPLEADOS//////////////////////////////////////////
        if (v_registros.tipo_obligacion = 'pago_empleados') then
            
            /*Se registra una obligacion por banco que se tenga*/
            for v_obligaciones in execute('
        		select id_institucion, nombre_banco, sum(valor) as valor' || v_anadir_lugar || '
                from ' || v_nombre_tabla || '            		 
                where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || '
                and id_institucion is not null and nro_cuenta is not null and trim(both '' '' from nro_cuenta) != '''' 
                group by id_institucion, nombre_banco' || v_anadir_lugar || '
                having sum(valor) > 0') loop
                if (v_registros.dividir_por_lugar= 'si') then
                	v_lugar = v_obligaciones.nombre_lugar;
                else
                	v_lugar = '';
                end if;
                --inserta la obligacion
                INSERT INTO 
                    plani.tobligacion
                  (
                    id_usuario_reg,
                    fecha_reg,                                       
                    id_tipo_obligacion,
                    id_planilla,                    
                    tipo_pago,
                    acreedor,
                    descripcion,
                    monto_obligacion
                  ) 
                  VALUES (
                    p_id_usuario,
                    now(),
                    v_registros.id_tipo_obligacion,
                    p_id_planilla,
                    'transferencia_empleados',
                    v_registros.nombre || ' ' || v_obligaciones.nombre_banco || ' ' ||
                    v_lugar,
                    v_registros.nombre || ' ' || v_obligaciones.nombre_banco || ' ' ||
                    v_lugar,
                    v_obligaciones.valor
                  ) returning id_obligacion into v_id_obligacion;
                
                if (v_registros.dividir_por_lugar = 'si') then
                	v_where_lugar = ' and id_lugar = '|| v_obligaciones.id_lugar;
                else
                	v_where_lugar = '';
                end if;
                --inserta el detalle de obligaciones
                for v_detalles in execute('
                	select id_presupuesto , id_cc, id_tipo_columna, codigo_columna, sum(valor) as valor,tipo_contrato
                    from ' || v_nombre_tabla || '            		 
                	where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || ' and 
                    	id_institucion = '|| v_obligaciones.id_institucion || ' and
                        nro_cuenta is not null and trim(both '' '' from nro_cuenta) != '''' ' || v_where_lugar || '
                    group by id_presupuesto , id_cc, id_tipo_columna, codigo_columna,tipo_contrato' )loop
                	INSERT INTO 
                        plani.tobligacion_columna
                      (
                        id_usuario_reg,
                        fecha_reg,
                        id_obligacion,
                        id_presupuesto,
                        id_cc,
                        id_tipo_columna,
                        codigo_columna,
                        tipo_contrato,
                        monto_detalle_obligacion
                      ) 
                      VALUES (
                        p_id_usuario,
                        now(),
                        v_id_obligacion,
                        v_detalles.id_presupuesto,
                        v_detalles.id_cc,
                        v_detalles.id_tipo_columna,
                        v_detalles.codigo_columna,
                        v_detalles.tipo_contrato,
                        v_detalles.valor
                      );
                end loop;
                
                --inserta detalle de transferencias
                for v_detalles in execute('
                	select id_funcionario , nro_cuenta, sum(valor) as valor
                    from ' || v_nombre_tabla || '            		 
                	where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || ' and 
                    	id_institucion = '|| v_obligaciones.id_institucion || ' and
                        nro_cuenta is not null and trim(both '' '' from nro_cuenta) != '''' ' || v_where_lugar || '
                    group by id_funcionario , nro_cuenta' )loop
                	INSERT INTO 
                      plani.tdetalle_transferencia
                    (
                      id_usuario_reg,                      
                      fecha_reg,
                      id_obligacion,
                      id_institucion,
                      nro_cuenta,
                      id_funcionario,
                      monto_transferencia
                    ) 
                    VALUES (
                      p_id_usuario,
                      now(),                      
                      v_id_obligacion,
                      v_obligaciones.id_institucion,
                      v_detalles.nro_cuenta,
                      v_detalles.id_funcionario,
                      v_detalles.valor
                    );
                end loop;
            	
        	end loop;
            
            /*Se registra una obligacion por empleado que no tenga cuenta bancaria*/
            for v_obligaciones in execute('
        		select id_funcionario,nombre_funcionario, sum(valor) as valor
                from ' || v_nombre_tabla || '            		 
                where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || '
                and (id_institucion is null or nro_cuenta is null or trim(both '' '' from nro_cuenta) = '''') 
                group by id_funcionario, nombre_funcionario
                having sum(valor) > 0') loop
                
                --inserta la obligacion
                INSERT INTO 
                    plani.tobligacion
                  (
                    id_usuario_reg,
                    fecha_reg,                                       
                    id_tipo_obligacion,
                    id_planilla,                    
                    tipo_pago,
                    acreedor,
                    descripcion,
                    monto_obligacion
                  ) 
                  VALUES (
                    p_id_usuario,
                    now(),
                    v_registros.id_tipo_obligacion,
                    p_id_planilla,
                    'cheque',
                    v_obligaciones.nombre_funcionario,
                    v_obligaciones.nombre_funcionario || ' cheque de pago a empleado que no tiene cuenta bancaria',
                    v_obligaciones.valor
                  ) returning id_obligacion into v_id_obligacion;
                
                --inserta el detalle de obligaciones
                for v_detalles in execute('
                	select id_presupuesto , id_cc, id_tipo_columna, codigo_columna, sum(valor) as valor,tipo_contrato
                    from ' || v_nombre_tabla || '            		 
                	where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || ' and 
                    	id_funcionario = '|| v_obligaciones.id_funcionario || '
                    group by id_presupuesto , id_cc, id_tipo_columna, codigo_columna,tipo_contrato' )loop
                	INSERT INTO 
                        plani.tobligacion_columna
                      (
                        id_usuario_reg,
                        fecha_reg,
                        id_obligacion,
                        id_presupuesto,
                        id_cc,
                        id_tipo_columna,
                        codigo_columna,
                        tipo_contrato,
                        monto_detalle_obligacion
                      ) 
                      VALUES (
                        p_id_usuario,
                        now(),
                        v_id_obligacion,
                        v_detalles.id_presupuesto,
                        v_detalles.id_cc,
                        v_detalles.id_tipo_columna,
                        v_detalles.codigo_columna,
                        v_detalles.tipo_contrato,
                        v_detalles.valor
                      );
                end loop;
            	
        	end loop;
        --///////////////////////////////////AFP//////////////////////////////////////////
        elsif (v_registros.tipo_obligacion = 'pago_afp') then
    		/*Se registra una obligacion por afp que se tenga*/
            for v_obligaciones in execute('
        		select id_afp, nombre_afp, sum(valor) as valor' || v_anadir_lugar || '
                from ' || v_nombre_tabla || '            		 
                where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || '
                group by id_afp, nombre_afp' || v_anadir_lugar || '
                having sum(valor) > 0') loop
                
                if (v_registros.dividir_por_lugar= 'si') then
                	v_lugar = v_obligaciones.nombre_lugar;
                else
                	v_lugar = '';
                end if;
                                
                --inserta la obligacion
                INSERT INTO 
                    plani.tobligacion
                  (
                    id_usuario_reg,
                    fecha_reg,                                       
                    id_tipo_obligacion,
                    id_planilla,                    
                    tipo_pago,
                    acreedor,
                    descripcion,
                    monto_obligacion
                  ) 
                  VALUES (
                    p_id_usuario,
                    now(),
                    v_registros.id_tipo_obligacion,
                    p_id_planilla,
                    'cheque',
                    v_obligaciones.nombre_afp || ' ' || v_registros.nombre,
                    v_lugar,
                    v_obligaciones.nombre_afp || ' ' || v_registros.nombre,
                    v_lugar,
                    v_obligaciones.valor
                  ) returning id_obligacion into v_id_obligacion;
                
                if (v_registros.dividir_por_lugar = 'si') then
                	v_where_lugar = ' and id_lugar = '|| v_obligaciones.id_lugar;
                else
                	v_where_lugar = '';
                end if;
                --inserta el detalle de obligaciones
                for v_detalles in execute('
                	select id_presupuesto , id_cc, id_tipo_columna, codigo_columna, sum(valor) as valor,tipo_contrato
                    from ' || v_nombre_tabla || '            		 
                	where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || ' and 
                    	id_afp = '|| v_obligaciones.id_afp  || v_where_lugar || '
                    group by id_presupuesto , id_cc, id_tipo_columna, codigo_columna,tipo_contrato' )loop
                	INSERT INTO 
                        plani.tobligacion_columna
                      (
                        id_usuario_reg,
                        fecha_reg,
                        id_obligacion,
                        id_presupuesto,
                        id_cc,
                        id_tipo_columna,
                        codigo_columna,
                        tipo_contrato,
                        monto_detalle_obligacion
                      ) 
                      VALUES (
                        p_id_usuario,
                        now(),
                        v_id_obligacion,
                        v_detalles.id_presupuesto,
                        v_detalles.id_cc,
                        v_detalles.id_tipo_columna,
                        v_detalles.codigo_columna,
                        v_detalles.tipo_contrato,
                        v_detalles.valor
                      );
                end loop;            	
        	end loop;     
        --///////////////////////////////////PAGO COMUN//////////////////////////////////////////    
        elsif (v_registros.tipo_obligacion = 'pago_comun') then
        	
        	for v_obligaciones in execute('
        		select id_tipo_obligacion,sum(valor) as valor' || v_anadir_lugar || '
                from ' || v_nombre_tabla || '            		 
                where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || '
                group by id_tipo_obligacion' || v_anadir_lugar || '
                having sum(valor) > 0') loop
				
                if (v_registros.dividir_por_lugar= 'si') then
                	v_lugar = v_obligaciones.nombre_lugar;
                else
                	v_lugar = '';
                end if;
                
                --inserta la obligacion
                INSERT INTO 
                    plani.tobligacion
                  (
                    id_usuario_reg,
                    fecha_reg,                                       
                    id_tipo_obligacion,
                    id_planilla,                    
                    tipo_pago,
                    acreedor,
                    descripcion,
                    monto_obligacion
                  ) 
                  VALUES (
                    p_id_usuario,
                    now(),
                    v_registros.id_tipo_obligacion,
                    p_id_planilla,
                    'cheque',
                    v_registros.nombre || ' ' || v_lugar,
                    v_registros.nombre || ' ' || v_lugar,
                    v_obligaciones.valor
                  ) returning id_obligacion into v_id_obligacion;
                
                if (v_registros.dividir_por_lugar = 'si') then
                	v_where_lugar = ' and id_lugar = '|| v_obligaciones.id_lugar;
                else
                	v_where_lugar = '';
                end if;
                --inserta el detalle de obligaciones
                for v_detalles in execute('
                	select id_presupuesto , id_cc, id_tipo_columna, codigo_columna, sum(valor) as valor,tipo_contrato
                    from ' || v_nombre_tabla || '            		 
                	where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion ||  v_where_lugar || '
                    group by id_presupuesto , id_cc, id_tipo_columna, codigo_columna,tipo_contrato' )loop
                	INSERT INTO 
                        plani.tobligacion_columna
                      (
                        id_usuario_reg,
                        fecha_reg,
                        id_obligacion,
                        id_presupuesto,
                        id_cc,
                        id_tipo_columna,
                        codigo_columna,
                        tipo_contrato,
                        monto_detalle_obligacion
                      ) 
                      VALUES (
                        p_id_usuario,
                        now(),
                        v_id_obligacion,
                        v_detalles.id_presupuesto,
                        v_detalles.id_cc,
                        v_detalles.id_tipo_columna,
                        v_detalles.codigo_columna,
                        v_detalles.tipo_contrato,
                        v_detalles.valor
                      );
                end loop;            	
        	end loop;
        
        elsif (v_registros.tipo_obligacion = 'una_obligacion_x_empleado') then
        	/*Se registra una obligacion por empleado*/
            for v_obligaciones in execute('
        		select id_funcionario,nombre_funcionario, sum(valor) as valor
                from ' || v_nombre_tabla || '            		 
                where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || '
                group by id_funcionario, nombre_funcionario 
                having sum(valor) > 0') loop
                
                 --inserta la obligacion
                INSERT INTO 
                    plani.tobligacion
                  (
                    id_usuario_reg,
                    fecha_reg,                                       
                    id_tipo_obligacion,
                    id_planilla,                    
                    tipo_pago,
                    acreedor,
                    descripcion,
                    monto_obligacion
                  ) 
                  VALUES (
                    p_id_usuario,
                    now(),
                    v_registros.id_tipo_obligacion,
                    p_id_planilla,
                    'cheque',
                    v_obligaciones.nombre_funcionario,
                    v_registros.nombre || ' ' || v_obligaciones.nombre_funcionario,
                    v_obligaciones.valor
                  ) returning id_obligacion into v_id_obligacion;
                
                --inserta el detalle de obligaciones
                for v_detalles in execute('
                	select id_presupuesto , id_cc, id_tipo_columna, codigo_columna, sum(valor) as valor,tipo_contrato
                    from ' || v_nombre_tabla || '            		 
                	where id_tipo_obligacion = ' || v_registros.id_tipo_obligacion || ' and 
                    	id_funcionario = '|| v_obligaciones.id_funcionario || '
                    group by id_presupuesto , id_cc, id_tipo_columna, codigo_columna,tipo_contrato' )loop
                	INSERT INTO 
                        plani.tobligacion_columna
                      (
                        id_usuario_reg,
                        fecha_reg,
                        id_obligacion,
                        id_presupuesto,
                        id_cc,
                        id_tipo_columna,
                        codigo_columna,
                        tipo_contrato,
                        monto_detalle_obligacion
                      ) 
                      VALUES (
                        p_id_usuario,
                        now(),
                        v_id_obligacion,
                        v_detalles.id_presupuesto,
                        v_detalles.id_cc,
                        v_detalles.id_tipo_columna,
                        v_detalles.codigo_columna,
                        v_detalles.tipo_contrato,
                        v_detalles.valor
                      );
                end loop;
            	
        	end loop;
        end if;
        
        --truncar tabla temporal
        execute('truncate ' || v_nombre_tabla);
    end loop;
  	return 'exito';
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