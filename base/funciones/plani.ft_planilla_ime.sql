CREATE OR REPLACE FUNCTION "plani"."ft_planilla_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

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
	                  (select codigo from plani.ttipo_planilla where id_tipo_planilla = v_parametros.id_tipo_planilla), 
	                   v_parametros.id_periodo,-- par_id, 
	                   NULL, --id_uo 
	                   v_parametros.id_depto,    -- id_depto
	                   p_id_usuario, 
	                   'PLANI', 
	                   NULL);
	        --para tipos de planilla por gestion
	        else
	        	 v_num_plani =   param.f_obtener_correlativo(
	                  (select codigo from plani.ttipo_planilla where id_tipo_planilla = v_parametros.id_tipo_planilla), 
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
			--Sentencia de la eliminacion
			delete from plani.tplanilla
            where id_planilla=v_parametros.id_planilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Planilla eliminado(a)'); 
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "plani"."ft_planilla_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
