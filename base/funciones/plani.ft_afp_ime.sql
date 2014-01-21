CREATE OR REPLACE FUNCTION "plani"."ft_afp_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_afp_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tafp'
 AUTOR: 		 (admin)
 FECHA:	        20-01-2014 03:46:54
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
	v_id_afp	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_afp_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_AFP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:46:54
	***********************************/

	if(p_transaccion='PLA_AFP_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tafp(
			estado_reg,
			codigo,
			nombre,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.codigo,
			v_parametros.nombre,
			p_id_usuario,
			now(),
			null,
			null
							
			)RETURNING id_afp into v_id_afp;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registro de AFPs almacenado(a) con exito (id_afp'||v_id_afp||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_afp',v_id_afp::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_AFP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:46:54
	***********************************/

	elsif(p_transaccion='PLA_AFP_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tafp set
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_afp=v_parametros.id_afp;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registro de AFPs modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_afp',v_parametros.id_afp::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_AFP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:46:54
	***********************************/

	elsif(p_transaccion='PLA_AFP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tafp
            where id_afp=v_parametros.id_afp;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registro de AFPs eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_afp',v_parametros.id_afp::varchar);
              
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
ALTER FUNCTION "plani"."ft_afp_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
