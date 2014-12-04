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
    v_id_tipo_estado		integer;
    v_pedir_obs				varchar;
    v_codigo_estado_siguiente varchar;
    v_id_depto				integer;
    v_obs					text;
    v_acceso_directo  	varchar;
    v_clase   			varchar;
    v_parametros_ad   	varchar;
    v_tipo_noti  		varchar;
    v_titulo   			varchar;
    v_id_estado_actual	integer;
    v_registros_proc	record;
    v_codigo_tipo_pro	varchar;
    v_id_estado_wf_ant	integer;
    v_id_funcionario	integer;
    v_id_usuario_reg	integer;
    v_codigo_llave		varchar;
    
			    
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
			id_depto,
			fecha_planilla
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
			v_parametros.id_depto,
			v_parametros.fecha_planilla				
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
			fecha_planilla = v_parametros.fecha_planilla,
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
 	#TRANSACCION:  'PLA_ANTEPLA_IME'
 	#DESCRIPCION:	Transaccion utilizada  pasar a  estados anterior en la planilla
                    segun la operacion definida
 	#AUTOR:		JRR	
 	#FECHA:		17-10-2014 12:12:51
	***********************************/

	elseif(p_transaccion='PLA_ANTEPLA_IME')then   
        begin
        
        --------------------------------------------------
        --Retrocede al estado inmediatamente anterior
        -------------------------------------------------
       --recuperaq estado anterior segun Log del WF
          SELECT  
         
             ps_id_tipo_estado,
             ps_id_funcionario,
             ps_id_usuario_reg,
             ps_id_depto,
             ps_codigo_estado,
             ps_id_estado_wf_ant
          into
             v_id_tipo_estado,
             v_id_funcionario,
             v_id_usuario_reg,
             v_id_depto,
             v_codigo_estado,
             v_id_estado_wf_ant 
          FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
                        
                        
           --
          select 
               ew.id_proceso_wf 
            into 
               v_id_proceso_wf
          from wf.testado_wf ew
          where ew.id_estado_wf= v_id_estado_wf_ant;
          
          
         --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Notificacion';
             
           
            IF   v_codigo_estado_siguiente not in('registro_funcionarios','obligaciones_generadas','comprobante_presupuestario_validado','comprobante_obligaciones','planilla_finalizada')   THEN
                  v_acceso_directo = '../../../sis_planillas/vista/planilla/Planilla.php';
                  v_clase = 'Planilla';
                  v_parametros_ad = '{filtro_directo:{campo:"plani.id_proceso_wf",valor:"'||v_parametros.id_proceso_wf_act::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Notificacion';             
             END IF;
             
          
          -- registra nuevo estado
                      
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado, 
              v_id_funcionario, 
              v_parametros.id_estado_wf, 
              v_id_proceso_wf, 
              p_id_usuario,
              v_parametros._id_usuario_ai,
              v_parametros._nombre_usuario_ai,
              v_id_depto,
              '[RETROCESO] '|| v_parametros.obs,
              v_acceso_directo,
              v_clase,
              v_parametros_ad,
              v_tipo_noti,
              v_titulo);
                      
         
          
                         
            IF  not plani.f_fun_regreso_planilla_wf(p_id_usuario, 
                                                   v_parametros._id_usuario_ai, 
                                                   v_parametros._nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_parametros.id_proceso_wf, 
                                                   v_codigo_estado) THEN
            
               raise exception 'Error al retroceder estado';
            
            END IF;              
                         
                         
         -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
          --Devuelve la respuesta
            return v_resp;
                        
           
        
        
        
        end;	
    
     /*********************************    
 	#TRANSACCION:  'PLA_SIGEPLA_IME'
 	#DESCRIPCION:	funcion que controla el cambio al Siguiente estado de las planillas, integrado  con el WF
 	#AUTOR:		JRR	
 	#FECHA:		17-10-2014 12:12:51
	***********************************/

	elseif(p_transaccion='PLA_SIGEPLA_IME')then   
        begin
        	
         /*   PARAMETROS
         
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
        */        
      select pla.*
      into v_planilla
      from plani.tplanilla pla     
      where id_proceso_wf = v_parametros.id_proceso_wf_act;
      
          select 
            ew.id_tipo_estado ,
            te.pedir_obs,
            ew.id_estado_wf
           into 
            v_id_tipo_estado,
            v_pedir_obs,
            v_id_estado_wf
            
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf =  v_parametros.id_estado_wf_act;
          
         
           -- obtener datos tipo estado
                
                select
                 te.codigo
                into
                 v_codigo_estado_siguiente
                from wf.ttipo_estado te
                where te.id_tipo_estado = v_parametros.id_tipo_estado;
                
             IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
                 
               v_id_depto = v_parametros.id_depto_wf;
                
             END IF;
                
                
                
             IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
                  v_obs=v_parametros.obs;
             ELSE
                   v_obs='---';
                
             END IF;
               
             --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Bueno';
             
           
             IF   v_codigo_estado_siguiente not in('registro_funcionarios','obligaciones_generadas','comprobante_presupuestario_validado','comprobante_obligaciones','planilla_finalizada')   THEN
                  v_acceso_directo = '../../../sis_planillas/vista/planilla/Planilla.php';
                  v_clase = 'Planilla';
                  v_parametros_ad = '{filtro_directo:{campo:"plani.id_proceso_wf",valor:"'||v_parametros.id_proceso_wf_act::varchar||'"}}';
                  v_tipo_noti = 'notificacion';
                  v_titulo  = 'Notificacion';             
             END IF;
             
             
             -- hay que recuperar el supervidor que seria el estado inmediato,...
             v_id_estado_actual =  wf.f_registra_estado_wf(v_parametros.id_tipo_estado, 
                                                             v_parametros.id_funcionario_wf, 
                                                             v_parametros.id_estado_wf_act, 
                                                             v_parametros.id_proceso_wf_act,
                                                             p_id_usuario,
                                                             v_parametros._id_usuario_ai,
                                                             v_parametros._nombre_usuario_ai,
                                                             v_id_depto,
                                                             COALESCE(v_planilla.nro_planilla,'--')||' Obs:'||v_obs,
                                                             v_acceso_directo ,
                                                             v_clase,
                                                             v_parametros_ad,
                                                             v_tipo_noti,
                                                             v_titulo);
                
          --------------------------------------
          -- registra los procesos disparados
          --------------------------------------
         
          FOR v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) LOOP
    
               --get cdigo tipo proceso
               select   
                  tp.codigo,
                  tp.codigo_llave  
               into 
                  v_codigo_tipo_pro, 
                  v_codigo_llave  
               from wf.ttipo_proceso tp 
                where  tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;
          
          
               -- disparar creacion de procesos seleccionados
              
              SELECT
                       ps_id_proceso_wf,
                       ps_id_estado_wf,
                       ps_codigo_estado
                 into
                       v_id_proceso_wf,
                       v_id_estado_wf,
                       v_codigo_estado
              FROM wf.f_registra_proceso_disparado_wf(
                       p_id_usuario,
                       v_parametros._id_usuario_ai,
                       v_parametros._nombre_usuario_ai,
                       v_id_estado_actual, 
                       v_registros_proc.id_funcionario_wf_pro, 
                       v_registros_proc.id_depto_wf_pro,
                       v_registros_proc.obs_pro,
                       v_codigo_tipo_pro,    
                       v_codigo_tipo_pro);
              
              /*Generar una olbigacion de pago en caso de ser necesario*/
              IF v_codigo_llave = 'obligacion_pago' THEN
                     
                  IF  v_registros_proc.id_depto_wf_pro::integer  is NULL  THEN
                          
                     raise exception 'Para obligaciones de pago el depto es indispensable';
                          
                  END IF;
                  
                  IF NOT plani.f_generar_obligaciones_tesoreria(
                  								v_planilla.id_planilla,
                                                p_id_usuario,
                                                v_parametros._id_usuario_ai,
                                                v_parametros._nombre_usuario_ai 
                                                ) THEN
                                                         
                     raise exception 'Error al generar el contrato';
                          
                  END IF;
                     
                   
                    
              ELSE
              	 raise exception 'Codigo llave no reconocido  verifique el WF (%)', v_codigo_llave;
              END IF;
                       
                       
           END LOOP; 
           
           -- actualiza estado en la solicitud
           -- funcion para cambio de estado     
           
          IF  plani.f_fun_inicio_planilla_wf(p_id_usuario, 
           									v_parametros._id_usuario_ai, 
                                            v_parametros._nombre_usuario_ai, 
                                            v_id_estado_actual, 
                                            v_parametros.id_proceso_wf_act, 
                                            v_codigo_estado_siguiente) THEN
                                            
          END IF;
          
          
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado de la planilla)'); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
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