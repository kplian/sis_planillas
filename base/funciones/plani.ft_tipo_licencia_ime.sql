CREATE OR REPLACE FUNCTION plani.ft_tipo_licencia_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_licencia_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_licencia'
 AUTOR: 		 (admin)
 FECHA:	        07-03-2019 13:52:26
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				    AUTOR				DESCRIPCION
 #0	EndeEtr			07-03-2019 13:52:26		EGS						Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_licencia'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tipo_licencia	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_licencia_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
     #TRANSACCION:  'PLA_TIPLIC_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin    
     #FECHA:        07-03-2019 13:52:26
    ***********************************/

    if(p_transaccion='PLA_TIPLIC_INS')then
                    
        begin
            --Sentencia de la insercion
            insert into plani.ttipo_licencia(
            nombre,
            genera_descuento,
            estado_reg,
            codigo,
            id_usuario_ai,
            id_usuario_reg,
            usuario_ai,
            fecha_reg,
            id_usuario_mod,
            fecha_mod
              ) values(
            v_parametros.nombre,
            v_parametros.genera_descuento,
            'activo',
            v_parametros.codigo,
            v_parametros._id_usuario_ai,
            p_id_usuario,
            v_parametros._nombre_usuario_ai,
            now(),
            null,
            null
                            
            
            
            )RETURNING id_tipo_licencia into v_id_tipo_licencia;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo de Licencia almacenado(a) con exito (id_tipo_licencia'||v_id_tipo_licencia||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_licencia',v_id_tipo_licencia::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'PLA_TIPLIC_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin    
     #FECHA:        07-03-2019 13:52:26
    ***********************************/

    elsif(p_transaccion='PLA_TIPLIC_MOD')then

        begin
            --Sentencia de la modificacion
            update plani.ttipo_licencia set
            nombre = v_parametros.nombre,
            genera_descuento = v_parametros.genera_descuento,
            codigo = v_parametros.codigo,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            where id_tipo_licencia=v_parametros.id_tipo_licencia;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo de Licencia modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_licencia',v_parametros.id_tipo_licencia::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'PLA_TIPLIC_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin    
     #FECHA:        07-03-2019 13:52:26
    ***********************************/

    elsif(p_transaccion='PLA_TIPLIC_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from plani.ttipo_licencia
            where id_tipo_licencia=v_parametros.id_tipo_licencia;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo de Licencia eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_licencia',v_parametros.id_tipo_licencia::varchar);
              
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