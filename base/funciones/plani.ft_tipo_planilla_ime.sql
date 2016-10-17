CREATE OR REPLACE FUNCTION "plani"."ft_tipo_planilla_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_planilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_planilla'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 15:36:53
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
	v_id_tipo_planilla	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_planilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_TIPPLA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:53
	***********************************/

	if(p_transaccion='PLA_TIPPLA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.ttipo_planilla(
			id_proceso_macro,
			tipo_presu_cc,
			funcion_obtener_empleados,
			estado_reg,
			nombre,
			codigo,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
			funcion_validacion_nuevo_empleado,
			calculo_horas,
			periodicidad,
			funcion_calculo_horas,
			recalcular_desde
          	) values(
			v_parametros.id_proceso_macro,
			v_parametros.tipo_presu_cc,
			v_parametros.funcion_obtener_empleados,
			'activo',
			v_parametros.nombre,
			v_parametros.codigo,
			now(),
			p_id_usuario,
			null,
			null,
			v_parametros.funcion_validacion_nuevo_empleado,
			v_parametros.calculo_horas,
			v_parametros.periodicidad,
			v_parametros.funcion_calculo_horas,
			v_parametros.recalcular_desde
							
			)RETURNING id_tipo_planilla into v_id_tipo_planilla;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipos de Planilla almacenado(a) con exito (id_tipo_planilla'||v_id_tipo_planilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_planilla',v_id_tipo_planilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPPLA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:53
	***********************************/

	elsif(p_transaccion='PLA_TIPPLA_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.ttipo_planilla set
			id_proceso_macro = v_parametros.id_proceso_macro,
			tipo_presu_cc = v_parametros.tipo_presu_cc,
			funcion_obtener_empleados = v_parametros.funcion_obtener_empleados,
			nombre = v_parametros.nombre,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			funcion_validacion_nuevo_empleado = v_parametros.funcion_validacion_nuevo_empleado,
			calculo_horas = v_parametros.calculo_horas,
			periodicidad = v_parametros.periodicidad,
			fecha_mod = now(),
			funcion_calculo_horas = v_parametros.funcion_calculo_horas,
			recalcular_desde = v_parametros.recalcular_desde
			where id_tipo_planilla=v_parametros.id_tipo_planilla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipos de Planilla modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_planilla',v_parametros.id_tipo_planilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPPLA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:53
	***********************************/

	elsif(p_transaccion='PLA_TIPPLA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.ttipo_planilla
            where id_tipo_planilla=v_parametros.id_tipo_planilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipos de Planilla eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_planilla',v_parametros.id_tipo_planilla::varchar);
              
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
ALTER FUNCTION "plani"."ft_tipo_planilla_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
