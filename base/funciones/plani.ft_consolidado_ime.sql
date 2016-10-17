CREATE OR REPLACE FUNCTION "plani"."ft_consolidado_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_consolidado_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tconsolidado'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 19:04:07
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
	v_id_consolidado	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_consolidado_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_CONPRE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:07
	***********************************/

	if(p_transaccion='PLA_CONPRE_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tconsolidado(
			id_cc,
			id_planilla,
			id_presupuesto,
			estado_reg,
			tipo_consolidado,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_cc,
			v_parametros.id_planilla,
			v_parametros.id_presupuesto,
			'activo',
			v_parametros.tipo_consolidado,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_consolidado into v_id_consolidado;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consolidado Presupuestario almacenado(a) con exito (id_consolidado'||v_id_consolidado||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_consolidado',v_id_consolidado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_CONPRE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:07
	***********************************/

	elsif(p_transaccion='PLA_CONPRE_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tconsolidado set
			id_cc = v_parametros.id_cc,
			id_planilla = v_parametros.id_planilla,
			id_presupuesto = v_parametros.id_presupuesto,
			tipo_consolidado = v_parametros.tipo_consolidado,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_consolidado=v_parametros.id_consolidado;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consolidado Presupuestario modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_consolidado',v_parametros.id_consolidado::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_CONPRE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:07
	***********************************/

	elsif(p_transaccion='PLA_CONPRE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tconsolidado
            where id_consolidado=v_parametros.id_consolidado;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consolidado Presupuestario eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_consolidado',v_parametros.id_consolidado::varchar);
              
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
ALTER FUNCTION "plani"."ft_consolidado_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
