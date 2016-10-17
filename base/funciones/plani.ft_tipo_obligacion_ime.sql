CREATE OR REPLACE FUNCTION plani.ft_tipo_obligacion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_obligacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_obligacion'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 19:43:19
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
	v_id_tipo_obligacion	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_obligacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	if(p_transaccion='PLA_TIPOBLI_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.ttipo_obligacion(
			tipo_obligacion,
			dividir_por_lugar,
			id_tipo_planilla,
			estado_reg,
			codigo,
			nombre,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            es_pagable
          	) values(
			v_parametros.tipo_obligacion,
			v_parametros.dividir_por_lugar,
			v_parametros.id_tipo_planilla,
			'activo',
			upper(v_parametros.codigo),
			v_parametros.nombre,
			p_id_usuario,
			now(),
			null,
			null,
            v_parametros.es_pagable
							
			)RETURNING id_tipo_obligacion into v_id_tipo_obligacion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Obligación almacenado(a) con exito (id_tipo_obligacion'||v_id_tipo_obligacion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion',v_id_tipo_obligacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	elsif(p_transaccion='PLA_TIPOBLI_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.ttipo_obligacion set
			tipo_obligacion = v_parametros.tipo_obligacion,
			dividir_por_lugar = v_parametros.dividir_por_lugar,
			id_tipo_planilla = v_parametros.id_tipo_planilla,
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            es_pagable = v_parametros.es_pagable
			where id_tipo_obligacion=v_parametros.id_tipo_obligacion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Obligación modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion',v_parametros.id_tipo_obligacion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	elsif(p_transaccion='PLA_TIPOBLI_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.ttipo_obligacion
            where id_tipo_obligacion=v_parametros.id_tipo_obligacion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Obligación eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion',v_parametros.id_tipo_obligacion::varchar);
              
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;