CREATE OR REPLACE FUNCTION "plani"."ft_detalle_transferencia_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_detalle_transferencia_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tdetalle_transferencia'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 20:28:39
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
	v_id_detalle_transferencia	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_detalle_transferencia_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_DETRAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:39
	***********************************/

	if(p_transaccion='PLA_DETRAN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tdetalle_transferencia(
			id_funcionario,
			id_institucion,
			id_obligacion,
			nro_cuenta,
			monto_transferencia,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_funcionario,
			v_parametros.id_institucion,
			v_parametros.id_obligacion,
			v_parametros.nro_cuenta,
			v_parametros.monto_transferencia,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null
							
			
			
			)RETURNING id_detalle_transferencia into v_id_detalle_transferencia;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Transferencia a Empleados almacenado(a) con exito (id_detalle_transferencia'||v_id_detalle_transferencia||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_transferencia',v_id_detalle_transferencia::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_DETRAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:39
	***********************************/

	elsif(p_transaccion='PLA_DETRAN_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tdetalle_transferencia set
			id_funcionario = v_parametros.id_funcionario,
			id_institucion = v_parametros.id_institucion,
			id_obligacion = v_parametros.id_obligacion,
			nro_cuenta = v_parametros.nro_cuenta,
			monto_transferencia = v_parametros.monto_transferencia,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_detalle_transferencia=v_parametros.id_detalle_transferencia;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Transferencia a Empleados modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_transferencia',v_parametros.id_detalle_transferencia::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_DETRAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:39
	***********************************/

	elsif(p_transaccion='PLA_DETRAN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tdetalle_transferencia
            where id_detalle_transferencia=v_parametros.id_detalle_transferencia;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Transferencia a Empleados eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_transferencia',v_parametros.id_detalle_transferencia::varchar);
              
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
ALTER FUNCTION "plani"."ft_detalle_transferencia_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
