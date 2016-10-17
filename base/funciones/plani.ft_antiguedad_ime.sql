CREATE OR REPLACE FUNCTION "plani"."ft_antiguedad_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_antiguedad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tantiguedad'
 AUTOR: 		 (admin)
 FECHA:	        20-01-2014 03:47:41
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
	v_id_antiguedad	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_antiguedad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_ANTI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:47:41
	***********************************/

	if(p_transaccion='PLA_ANTI_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tantiguedad(
			estado_reg,
			valor_max,
			porcentaje,
			valor_min,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.valor_max,
			v_parametros.porcentaje,
			v_parametros.valor_min,
			p_id_usuario,
			now(),
			null,
			null
							
			)RETURNING id_antiguedad into v_id_antiguedad;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición Periodos Antiguedad almacenado(a) con exito (id_antiguedad'||v_id_antiguedad||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_antiguedad',v_id_antiguedad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_ANTI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:47:41
	***********************************/

	elsif(p_transaccion='PLA_ANTI_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tantiguedad set
			valor_max = v_parametros.valor_max,
			porcentaje = v_parametros.porcentaje,
			valor_min = v_parametros.valor_min,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_antiguedad=v_parametros.id_antiguedad;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición Periodos Antiguedad modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_antiguedad',v_parametros.id_antiguedad::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_ANTI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:47:41
	***********************************/

	elsif(p_transaccion='PLA_ANTI_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tantiguedad
            where id_antiguedad=v_parametros.id_antiguedad;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición Periodos Antiguedad eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_antiguedad',v_parametros.id_antiguedad::varchar);
              
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
ALTER FUNCTION "plani"."ft_antiguedad_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
