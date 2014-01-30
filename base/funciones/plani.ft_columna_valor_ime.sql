CREATE OR REPLACE FUNCTION "plani"."ft_columna_valor_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_columna_valor_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tcolumna_valor'
 AUTOR: 		 (admin)
 FECHA:	        27-01-2014 04:53:54
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
	v_id_columna_valor	integer;
	v_estado_planilla		varchar;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_columna_valor_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_COLVAL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-01-2014 04:53:54
	***********************************/

	if(p_transaccion='PLA_COLVAL_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tcolumna_valor(
			id_tipo_columna,
			id_funcionario_planilla,
			codigo_columna,
			estado_reg,
			valor,
			valor_generado,
			formula,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_tipo_columna,
			v_parametros.id_funcionario_planilla,
			v_parametros.codigo_columna,
			'activo',
			v_parametros.valor,
			v_parametros.valor_generado,
			v_parametros.formula,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_columna_valor into v_id_columna_valor;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columna Valor almacenado(a) con exito (id_columna_valor'||v_id_columna_valor||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_valor',v_id_columna_valor::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_COLVAL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-01-2014 04:53:54
	***********************************/

	elsif(p_transaccion='PLA_COLVAL_MOD')then

		begin
			select pla.estado
			into v_estado_planilla
			from plani.tfuncionario_planilla funplan
			inner join plani.tplanilla  pla on pla.id_planilla = funplan.id_planilla
			where  funplan.id_funcionario_planilla = v_parametros.id_funcionario_planilla;
			
			if (v_estado_planilla != 'calculo_columnas')then
				raise exception 'No es posible modificar un valor para una planilla que no se encuentra en estado "calculo_columnas"';
			end if;
			
			--Sentencia de la modificacion
			update plani.tcolumna_valor set
			id_tipo_columna = v_parametros.id_tipo_columna,
			id_funcionario_planilla = v_parametros.id_funcionario_planilla,
			codigo_columna = v_parametros.codigo_columna,
			valor = v_parametros.valor,
			valor_generado = v_parametros.valor_generado,
			formula = v_parametros.formula,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_columna_valor=v_parametros.id_columna_valor;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columna Valor modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_valor',v_parametros.id_columna_valor::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_COLVAL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		27-01-2014 04:53:54
	***********************************/

	elsif(p_transaccion='PLA_COLVAL_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tcolumna_valor
            where id_columna_valor=v_parametros.id_columna_valor;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columna Valor eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_columna_valor',v_parametros.id_columna_valor::varchar);
              
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
ALTER FUNCTION "plani"."ft_columna_valor_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
