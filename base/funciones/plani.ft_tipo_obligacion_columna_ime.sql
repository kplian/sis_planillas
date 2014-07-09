CREATE OR REPLACE FUNCTION plani.ft_tipo_obligacion_columna_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_obligacion_columna_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_obligacion_columna'
 AUTOR: 		 (admin)
 FECHA:	        18-01-2014 02:57:04
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
	v_id_tipo_obligacion_columna	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_obligacion_columna_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_OBCOL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:57:04
	***********************************/

	if(p_transaccion='PLA_OBCOL_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.ttipo_obligacion_columna(
			id_tipo_obligacion,
			presupuesto,
			pago,
			estado_reg,
			codigo_columna,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
            es_ultimo
          	) values(
			v_parametros.id_tipo_obligacion,
			v_parametros.presupuesto,
			v_parametros.pago,
			'activo',
			v_parametros.codigo_columna,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.es_ultimo
							
			)RETURNING id_tipo_obligacion_columna into v_id_tipo_obligacion_columna;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligación Columna almacenado(a) con exito (id_tipo_obligacion_columna'||v_id_tipo_obligacion_columna||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion_columna',v_id_tipo_obligacion_columna::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_OBCOL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:57:04
	***********************************/

	elsif(p_transaccion='PLA_OBCOL_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.ttipo_obligacion_columna set
			id_tipo_obligacion = v_parametros.id_tipo_obligacion,
			presupuesto = v_parametros.presupuesto,
			pago = v_parametros.pago,
			codigo_columna = v_parametros.codigo_columna,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            es_ultimo = v_parametros.es_ultimo
			where id_tipo_obligacion_columna=v_parametros.id_tipo_obligacion_columna;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligación Columna modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion_columna',v_parametros.id_tipo_obligacion_columna::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_OBCOL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:57:04
	***********************************/

	elsif(p_transaccion='PLA_OBCOL_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.ttipo_obligacion_columna
            where id_tipo_obligacion_columna=v_parametros.id_tipo_obligacion_columna;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Obligación Columna eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion_columna',v_parametros.id_tipo_obligacion_columna::varchar);
              
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