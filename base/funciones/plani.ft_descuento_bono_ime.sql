CREATE OR REPLACE FUNCTION "plani"."ft_descuento_bono_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_descuento_bono_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tdescuento_bono'
 AUTOR: 		 (admin)
 FECHA:	        20-01-2014 18:26:40
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
	v_id_descuento_bono	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_descuento_bono_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_DESBON_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 18:26:40
	***********************************/

	if(p_transaccion='PLA_DESBON_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tdescuento_bono(
			id_funcionario,
			id_moneda,
			id_tipo_columna,
			valor_por_cuota,
			monto_total,
			fecha_ini,
			estado_reg,
			fecha_fin,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_funcionario,
			v_parametros.id_moneda,
			v_parametros.id_tipo_columna,
			v_parametros.valor_por_cuota,
			v_parametros.monto_total,
			v_parametros.fecha_ini,
			'activo',
			v_parametros.fecha_fin,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_descuento_bono into v_id_descuento_bono;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bono Descuento almacenado(a) con exito (id_descuento_bono'||v_id_descuento_bono||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_descuento_bono',v_id_descuento_bono::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_DESBON_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 18:26:40
	***********************************/

	elsif(p_transaccion='PLA_DESBON_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tdescuento_bono set
			id_funcionario = v_parametros.id_funcionario,
			id_moneda = v_parametros.id_moneda,
			id_tipo_columna = v_parametros.id_tipo_columna,
			valor_por_cuota = v_parametros.valor_por_cuota,
			monto_total = v_parametros.monto_total,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_descuento_bono=v_parametros.id_descuento_bono;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bono Descuento modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_descuento_bono',v_parametros.id_descuento_bono::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_DESBON_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 18:26:40
	***********************************/

	elsif(p_transaccion='PLA_DESBON_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tdescuento_bono
            where id_descuento_bono=v_parametros.id_descuento_bono;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bono Descuento eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_descuento_bono',v_parametros.id_descuento_bono::varchar);
              
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
ALTER FUNCTION "plani"."ft_descuento_bono_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
