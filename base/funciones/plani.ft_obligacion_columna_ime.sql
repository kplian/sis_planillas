CREATE OR REPLACE FUNCTION "plani"."ft_obligacion_columna_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_obligacion_columna_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tobligacion_columna'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 20:28:37
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
	v_id_obligacion_columna	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_obligacion_columna_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_OBLICOL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:37
	***********************************/

	if(p_transaccion='PLA_OBLICOL_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tobligacion_columna(
			id_cc,
			id_obligacion,
			id_presupuesto,
			id_tipo_columna,
			codigo_columna,
			estado_reg,
			monto_detalle_obligacion,
			tipo_contrato,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_cc,
			v_parametros.id_obligacion,
			v_parametros.id_presupuesto,
			v_parametros.id_tipo_columna,
			v_parametros.codigo_columna,
			'activo',
			v_parametros.monto_detalle_obligacion,
			v_parametros.tipo_contrato,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_obligacion_columna into v_id_obligacion_columna;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Ejecución por Obligación almacenado(a) con exito (id_obligacion_columna'||v_id_obligacion_columna||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_columna',v_id_obligacion_columna::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_OBLICOL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:37
	***********************************/

	elsif(p_transaccion='PLA_OBLICOL_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tobligacion_columna set
			id_cc = v_parametros.id_cc,
			id_obligacion = v_parametros.id_obligacion,
			id_presupuesto = v_parametros.id_presupuesto,
			id_tipo_columna = v_parametros.id_tipo_columna,
			codigo_columna = v_parametros.codigo_columna,
			monto_detalle_obligacion = v_parametros.monto_detalle_obligacion,
			tipo_contrato = v_parametros.tipo_contrato,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_obligacion_columna=v_parametros.id_obligacion_columna;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Ejecución por Obligación modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_columna',v_parametros.id_obligacion_columna::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_OBLICOL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:37
	***********************************/

	elsif(p_transaccion='PLA_OBLICOL_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tobligacion_columna
            where id_obligacion_columna=v_parametros.id_obligacion_columna;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Ejecución por Obligación eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_obligacion_columna',v_parametros.id_obligacion_columna::varchar);
              
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
ALTER FUNCTION "plani"."ft_obligacion_columna_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
