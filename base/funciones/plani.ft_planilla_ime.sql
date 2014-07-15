CREATE OR REPLACE FUNCTION plani.ft_planilla_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_planilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tplanilla'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2014 16:11:04
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_planilla			integer;
	v_id_uos				varchar;
	v_id_uo					integer;
	v_num_plani				varchar;
	v_num_tramite			varchar;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_codigo_tipo_proceso	varchar;
    v_id_proceso_macro		integer;
    v_tipo_planilla			record;
    v_registros				record;
    v_planilla				record;
    v_empleados				record;
    v_columnas				record;
    v_horas_trabajadas		record;
    v_cantidad_horas_mes	integer;
    v_suma_horas			integer;
    v_suma_sueldo			numeric;
    v_suma_porcentaje		numeric;
    v_id_horas_trabajadas	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_planilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PLANI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	if(p_transaccion='PLA_PLANI_INS')then
					
        begin
        	select pxp.list(id_uo::text) into v_id_uos
        	from param.tdepto_uo
        	where id_depto = v_parametros.id_depto and estado_reg = 'activo';
        	
            select * into v_tipo_planilla
            from plani.ttipo_planilla
            where id_tipo_planilla = v_parametros.id_tipo_planilla;
            
        	if (v_id_uos is not null) then
        		if (v_parametros.id_uo is null) then
        			raise exception 'El departamento de RRHH seleccionado no tiene permisos para 
        					generar una planilla con todos los empleados de la empresa';
        		end if;
        		
        		execute 'select id_uo from orga.tuo where id_uo in (' || v_id_uos || ') and id_uo = ' || v_parametros.id_uo
        		into v_id_uo;
        		
        		if (v_id_uo is null) then
        			raise exception 'El departamento de RRHH seleccionado no tiene permisos para procesar una planilla de esta UO';
        		end if;
        	end if;
        	--para tipos de planilla por periodo
        	if (v_parametros.id_periodo is not null) then
	        	 v_num_plani =   param.f_obtener_correlativo(
	                  v_tipo_planilla.codigo, 
	                   v_parametros.id_periodo,-- par_id, 
	                   NULL, --id_uo 
	                   v_parametros.id_depto,    -- id_depto
	                   p_id_usuario, 
	                   'PLANI', 
	                   NULL);
	        --para tipos de planilla por gestion
	        else
	        	 v_num_plani =   param.f_obtener_correlativo(
	                  v_tipo_planilla.codigo, 
	                   v_parametros.id_gestion,-- par_id, 
	                   NULL, --id_uo 
	                   v_parametros.id_depto,    -- id_depto
	                   p_id_usuario, 
	                   'PLANI', 
	                   NULL);
	        end if;
      
        
        IF (v_num_plani is NULL or v_num_plani ='') THEN
        
          raise exception 'No se pudo obtener un numero correlativo para la planilla consulte con el administrador';
        
        END IF;
        
        -- obtener el codigo del tipo_proceso
       
        select   tp.codigo, pm.id_proceso_macro 
            into v_codigo_tipo_proceso, v_id_proceso_macro
        from  plani.ttipo_planilla tippla
        inner join wf.tproceso_macro pm
        	on pm.id_proceso_macro =  tippla.id_proceso_macro
        inner join wf.ttipo_proceso tp
        	on tp.id_proceso_macro = pm.id_proceso_macro
        where   tippla.id_tipo_planilla = v_parametros.id_tipo_planilla
                and tp.estado_reg = 'activo' and tp.inicio = 'si';
            
         
        IF v_codigo_tipo_proceso is NULL THEN
        
           raise exception 'No existe un proceso inicial para el proceso macro indicado (Revise la configuración)';
        
        END IF;
        
        -- inciiar el tramite en el sistema de WF
       SELECT 
             ps_num_tramite ,
             ps_id_proceso_wf ,
             ps_id_estado_wf ,
             ps_codigo_estado 
          into
             v_num_tramite,
             v_id_proceso_wf,
             v_id_estado_wf,
             v_codigo_estado   
              
        FROM wf.f_inicia_tramite(
             p_id_usuario, 
             v_parametros._id_usuario_ai,
             v_parametros._nombre_usuario_ai,
             v_parametros.id_gestion, 
             v_codigo_tipo_proceso, 
             NULL,
             NULL,
             'Planilla '||v_num_plani,
             v_num_plani);
             
             
        	--Sentencia de la insercion
        	insert into plani.tplanilla(
			id_periodo,
			id_gestion,
			id_uo,
			id_tipo_planilla,
			estado_reg,
			observaciones,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
			nro_planilla,
			id_estado_wf,
			id_proceso_macro,
			id_proceso_wf,
			estado,
			id_depto
          	) values(
			v_parametros.id_periodo,
			v_parametros.id_gestion,
			v_parametros.id_uo,
			v_parametros.id_tipo_planilla,
			'activo',
			v_parametros.observaciones,
			now(),
			p_id_usuario,
			null,
			null,
			v_num_plani,
			v_id_estado_wf,
			v_id_proceso_macro,
			v_id_proceso_wf,
			v_codigo_estado,
			v_parametros.id_depto				
			)RETURNING id_planilla into v_id_planilla;
           
            execute 'select ' || v_tipo_planilla.funcion_obtener_empleados || '(' || v_id_planilla || ')'
        	into v_resp;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Planilla almacenado(a) con exito (id_planilla'||v_id_planilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_id_planilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PLANI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANI_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tplanilla set
			observaciones = v_parametros.observaciones,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_planilla=v_parametros.id_planilla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Planilla modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PLANI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANI_ELI')then

		begin
        	for v_registros in (select id_funcionario_planilla
            					from plani.tfuncionario_planilla
                                where id_planilla = v_parametros.id_planilla) loop
            	v_resp = plani.f_eliminar_funcionario_planilla(v_registros.id_funcionario_planilla);
            end loop;
            
            --eliminacion de obligacion_columna
            delete from plani.tobligacion_columna using plani.tobligacion
            where plani.tobligacion_columna.id_obligacion = plani.tobligacion.id_obligacion and 
            plani.tobligacion.id_planilla = v_parametros.id_planilla;
            
            --eliminacion de detalle_transferencia
            delete from plani.tdetalle_transferencia using plani.tobligacion
            where plani.tdetalle_transferencia.id_obligacion = plani.tobligacion.id_obligacion and 
            plani.tobligacion.id_planilla = v_parametros.id_planilla;
            
            --eliminacion de consolidacion_columna
            delete from plani.tconsolidado_columna using plani.tconsolidado
            where plani.tconsolidado_columna.id_consolidado = plani.tconsolidado.id_consolidado and 
            plani.tconsolidado.id_planilla = v_parametros.id_planilla;
            
            --eliminacion de las consolidaciones
            delete from plani.tconsolidado
            where id_planilla = v_parametros.id_planilla;
            
            --eliminacion de las obligaciones
            delete from plani.tobligacion
            where id_planilla = v_parametros.id_planilla;
              
			--Sentencia de la eliminacion
			delete from plani.tplanilla
            where id_planilla=v_parametros.id_planilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Planilla eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
	
	/*********************************    
 	#TRANSACCION:  'PLA_PLANIGENHOR_MOD'
 	#DESCRIPCION:	Generación de Horas Trabajadas para la planilla
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANIGENHOR_MOD')then

		begin
        	select *
        	into v_planilla
        	from plani.tplanilla
        	where id_planilla = v_parametros.id_planilla;
        	
        	if (v_planilla.estado != 'registro_funcionarios') then
        		raise exception 'La planilla debe estar en estado registro_funcionarios para la generacion de horas';
        	end if;
        	
        	v_resp = (select plani.f_plasue_generar_horas(v_parametros.id_planilla,p_id_usuario));
            
            v_resp = (select plani.f_planilla_cambiar_estado(v_parametros.id_planilla, p_id_usuario,v_parametros._id_usuario_ai,
             v_parametros._nombre_usuario_ai, 'siguiente'));
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Generadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
		
	/*********************************    
 	#TRANSACCION:  'PLA_PLANIVALHOR_MOD'
 	#DESCRIPCION:	Validación de Horas Trabajadas para la planilla
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANIVALHOR_MOD')then

		begin
        	select pla.*,pe.fecha_ini, pe.fecha_fin
        	into v_planilla
        	from plani.tplanilla pla
        	inner join param.tperiodo pe on pe.id_periodo = pla.id_periodo 
        	where id_planilla = v_parametros.id_planilla;
        	
        	v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', v_planilla.fecha_ini)::integer;
        	
        	for v_empleados in (select funpla.*,fun.desc_funcionario1 as nombre from plani.tfuncionario_planilla funpla
            	 				inner join orga.vfuncionario fun on fun.id_funcionario = funpla.id_funcionario
        						where id_planilla = v_planilla.id_planilla)loop
        						
        		select sum(horas_normales)::integer, round(sum(sueldo / v_cantidad_horas_mes * horas_normales),2)
        		into v_suma_horas, v_suma_sueldo
        		from plani.thoras_trabajadas
        		where id_funcionario_planilla = v_empleados.id_funcionario_planilla;
        		
        		if (v_suma_horas > v_cantidad_horas_mes)then
        			raise exception 'La cantidad de horas trabajadas para el empleado : % , superan las : % horas',
        							v_empleados.nombre,v_cantidad_horas_mes;
        		end if;
        		
        		if (v_suma_horas < 0 )then
        			raise exception 'La cantidad de horas trabajadas para el empleado : % , es 0 o menor a 0',
        							v_empleados.nombre;
        		end if;
        		
        		
    			update plani.thoras_trabajadas set
    				porcentaje_sueldo = (round((sueldo / v_cantidad_horas_mes * horas_normales),2) / v_suma_sueldo) * 100
    			where id_funcionario_planilla = v_empleados.id_funcionario_planilla; 
    			
    			select sum(porcentaje_sueldo),max(id_horas_trabajadas)
    			into v_suma_porcentaje,v_id_horas_trabajadas
                from plani.thoras_trabajadas
    			where id_funcionario_planilla = v_empleados.id_funcionario_planilla; 
    			
    			if (v_suma_porcentaje != 100 ) then
    				update plani.thoras_trabajadas set
    					porcentaje_sueldo = porcentaje_sueldo + (100 - v_suma_porcentaje)
    				where id_horas_trabajadas = v_id_horas_trabajadas; 
    			end if;
        		
        		
        	end loop;
            
            v_resp = (select plani.f_planilla_cambiar_estado(v_parametros.id_planilla, p_id_usuario,v_parametros._id_usuario_ai,
             v_parametros._nombre_usuario_ai, 'siguiente'));
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Generadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
	/*********************************    
 	#TRANSACCION:  'PLA_PLANICALCOL_MOD'
 	#DESCRIPCION:	Calcular Columnas para la planilla
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANICALCOL_MOD')then

		begin
        	select *
        	into v_planilla
        	from plani.tplanilla
        	where id_planilla = v_parametros.id_planilla;
        	
        	if (v_planilla.estado != 'calculo_columnas') then
        		raise exception 'La planilla debe estar en estado calculo_columnas para realizar el cálculo';
        	end if;
        	
        	v_resp = (select plani.f_planilla_calcular(v_parametros.id_planilla,p_id_usuario));
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas calculadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
	/*********************************    
 	#TRANSACCION:  'PLA_PLANIVALCOL_MOD'
 	#DESCRIPCION:	Validación del calculo de columnas
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANIVALCOL_MOD')then

		begin
        	
            v_resp = (select plani.f_planilla_cambiar_estado(v_parametros.id_planilla, p_id_usuario,v_parametros._id_usuario_ai,
             v_parametros._nombre_usuario_ai, 'siguiente'));
            
            for v_empleados in (select * 
            					from plani.tfuncionario_planilla 
                                where id_planilla = v_parametros.id_planilla) loop
            	for v_columnas in (	select db.id_descuento_bono
                					from plani.tcolumna_valor cv
                                    inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                                    inner join plani.tdescuento_bono db on tc.id_tipo_columna = db.id_tipo_columna and
                                    								db.id_funcionario = v_empleados.id_funcionario and db.estado_reg = 'activo'
                                    where cv.id_funcionario_planilla = v_empleados.id_funcionario_planilla and
                                    	tc.tipo_descuento_bono = 'cantidad_cuotas') loop
                	update plani.tdescuento_bono
                    	set monto_total = monto_total - valor_por_cuota
                    where id_descuento_bono = v_columnas.id_descuento_bono;
                end loop;
            end loop;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Generadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
    /*********************************    
 	#TRANSACCION:  'PLA_PLANIVALPRE_MOD'
 	#DESCRIPCION:	Validación de presupuestos de la planilla
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANIVALPRE_MOD')then

		begin
        	
            v_resp = (select plani.f_planilla_cambiar_estado(v_parametros.id_planilla, p_id_usuario,v_parametros._id_usuario_ai,
             v_parametros._nombre_usuario_ai, 'siguiente'));           
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Generadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'PLA_PLANIGENPRE_MOD'
 	#DESCRIPCION:	Generacion de presupuestos de la planilla
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANIGENPRE_MOD')then

		begin
        	v_resp = (select plani.f_prorratear_pres_cos_empleados(v_parametros.id_planilla, 'presupuestos', p_id_usuario));
            
            v_resp = (select plani.f_consolidar_pres_cos(v_parametros.id_planilla, 'presupuestos',p_id_usuario)); 
        	
            v_resp = (select plani.f_planilla_cambiar_estado(v_parametros.id_planilla, p_id_usuario,v_parametros._id_usuario_ai,
             v_parametros._nombre_usuario_ai,'siguiente'));           
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Generadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'PLA_PLANIGENOBLI_MOD'
 	#DESCRIPCION:	Generacion de obligaciones de la planilla
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANIGENOBLI_MOD')then

		begin
        	--raise exception 'llega generar obligaciones';
        	
            v_resp = (select plani.f_generar_obligaciones(v_parametros.id_planilla, p_id_usuario)); 
        	
            v_resp = (select plani.f_planilla_cambiar_estado(v_parametros.id_planilla, p_id_usuario,v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,'siguiente'));           
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligaciones generadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    elsif(p_transaccion='PLA_PLANIVALOBLI_MOD')then

		begin
        	--raise exception 'llega generar obligaciones';
        	           
            v_resp = (select plani.f_planilla_cambiar_estado(v_parametros.id_planilla, p_id_usuario,v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,'siguiente'));           
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligaciones generadas para la planilla'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
        
        
        
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;