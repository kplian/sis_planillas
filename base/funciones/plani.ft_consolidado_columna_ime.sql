CREATE OR REPLACE FUNCTION "plani"."ft_consolidado_columna_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_consolidado_columna_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tconsolidado_columna'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 19:04:10
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
	v_id_consolidado_columna	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_consolidado_columna_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_CONCOL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	if(p_transaccion='PLA_CONCOL_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tconsolidado_columna(
			id_auxiliar,
			id_consolidado,
			id_cuenta,
			id_partida,
			id_tipo_columna,
			valor,
			codigo_columna,
			tipo_contrato,
			valor_ejecutado,
			estado_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_auxiliar,
			v_parametros.id_consolidado,
			v_parametros.id_cuenta,
			v_parametros.id_partida,
			v_parametros.id_tipo_columna,
			v_parametros.valor,
			v_parametros.codigo_columna,
			v_parametros.tipo_contrato,
			v_parametros.valor_ejecutado,
			'activo',
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_consolidado_columna into v_id_consolidado_columna;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consolidado por Columna almacenado(a) con exito (id_consolidado_columna'||v_id_consolidado_columna||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_consolidado_columna',v_id_consolidado_columna::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_CONCOL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	elsif(p_transaccion='PLA_CONCOL_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tconsolidado_columna set
			id_auxiliar = v_parametros.id_auxiliar,
			id_consolidado = v_parametros.id_consolidado,
			id_cuenta = v_parametros.id_cuenta,
			id_partida = v_parametros.id_partida,
			id_tipo_columna = v_parametros.id_tipo_columna,
			valor = v_parametros.valor,
			codigo_columna = v_parametros.codigo_columna,
			tipo_contrato = v_parametros.tipo_contrato,
			valor_ejecutado = v_parametros.valor_ejecutado,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_consolidado_columna=v_parametros.id_consolidado_columna;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consolidado por Columna modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_consolidado_columna',v_parametros.id_consolidado_columna::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_CONCOL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	elsif(p_transaccion='PLA_CONCOL_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tconsolidado_columna
            where id_consolidado_columna=v_parametros.id_consolidado_columna;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Consolidado por Columna eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_consolidado_columna',v_parametros.id_consolidado_columna::varchar);
              
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
ALTER FUNCTION "plani"."ft_consolidado_columna_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
