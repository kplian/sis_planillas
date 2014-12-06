CREATE OR REPLACE FUNCTION "plani"."ft_columna_detalle_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_columna_detalle_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tcolumna_detalle'
 AUTOR: 		 (jrivera)
 FECHA:	        06-12-2014 17:17:45
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
	v_id_columna_detalle	integer;
	v_estado_planilla		varchar;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_columna_detalle_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_COLDET_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		06-12-2014 17:17:45
	***********************************/

	if(p_transaccion='PLA_COLDET_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tcolumna_detalle(
			id_horas_trabajadas,
			id_columna_valor,
			estado_reg,
			valor_generado,
			valor,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_horas_trabajadas,
			v_parametros.id_columna_valor,
			'activo',
			v_parametros.valor_generado,
			v_parametros.valor,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_columna_detalle into v_id_columna_detalle;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columna Detalle almacenado(a) con exito (id_columna_detalle'||v_id_columna_detalle||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_detalle',v_id_columna_detalle::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_COLDET_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		06-12-2014 17:17:45
	***********************************/

	elsif(p_transaccion='PLA_COLDET_MOD')then

		begin
			select pla.estado
			into v_estado_planilla
			from plani.tcolumna_valor cv				
			inner join plani.tfuncionario_planilla funplan
				on cv.id_funcionario_planilla =  funplan.id_funcionario_planilla
			inner join plani.tplanilla  pla on pla.id_planilla = funplan.id_planilla
			where  cv.id_columna_valor = v_parametros.id_columna_valor;
            
                        
			if (v_estado_planilla != 'calculo_columnas')then
				raise exception 'No es posible modificar un valor para una planilla que no se encuentra en estado "calculo_columnas"';
			end if;
			--Sentencia de la modificacion
			update plani.tcolumna_detalle set
			id_horas_trabajadas = v_parametros.id_horas_trabajadas,
			id_columna_valor = v_parametros.id_columna_valor,
			valor_generado = v_parametros.valor_generado,
			valor = v_parametros.valor,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_columna_detalle=v_parametros.id_columna_detalle;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columna Detalle modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_detalle',v_parametros.id_columna_detalle::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_COLDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		06-12-2014 17:17:45
	***********************************/

	elsif(p_transaccion='PLA_COLDET_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tcolumna_detalle
            where id_columna_detalle=v_parametros.id_columna_detalle;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columna Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_detalle',v_parametros.id_columna_detalle::varchar);
              
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
ALTER FUNCTION "plani"."ft_columna_detalle_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
