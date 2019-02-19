CREATE OR REPLACE FUNCTION plani.ft_tipo_obligacion_agrupador_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_obligacion_agrupador_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_obligacion_agrupador'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        05-02-2019 20:20:47
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #3				05-02-2019 20:20:47								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_obligacion_agrupador'	
 #1		EndeEtr		19/02/2019		     EGS				    Se agrego el campo descripcion
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tipo_obligacion_agrupador	integer;
    v_codigo                varchar;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_obligacion_agrupador_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PLA_TIOBAG_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        05-02-2019 20:20:47
    ***********************************/

    if(p_transaccion='PLA_TIOBAG_INS')then
                    
        begin
            --el codigo es en mayusculas y no permite espacios en blanco
            v_parametros.codigo=trim(upper(v_parametros.codigo));
            v_parametros.codigo=REPLACE(v_parametros.codigo,' ', '');
            SELECT
              tioagr.codigo
            INTO
              v_codigo  
            FROM  plani.ttipo_obligacion_agrupador  tioagr
            WHERE trim(upper(tioagr.codigo))= v_parametros.codigo;
            --si existe el codigo no se inserta
            IF v_codigo is not null THEN
                RAISE EXCEPTION 'El codigo % ya existe',v_parametros.codigo;
            END IF;
            
            --Sentencia de la insercion
            insert into plani.ttipo_obligacion_agrupador(
            codigo,
            codigo_plantilla_comprobante,
            nombre,
            estado_reg,
            id_usuario_ai,
            id_usuario_reg,
            fecha_reg,
            usuario_ai,
            fecha_mod,
            id_usuario_mod,
            descripcion --#1 EGS
              ) values(
            v_parametros.codigo,
            v_parametros.codigo_plantilla_comprobante,
            v_parametros.nombre,
            'activo',
            v_parametros._id_usuario_ai,
            p_id_usuario,
            now(),
            v_parametros._nombre_usuario_ai,
            null,
            null,
            v_parametros.descripcion --#1 EGS
                            
            
            
            )RETURNING id_tipo_obligacion_agrupador into v_id_tipo_obligacion_agrupador;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador Tipo de Obligacion almacenado(a) con exito (id_tipo_obligacion_agrupador'||v_id_tipo_obligacion_agrupador||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion_agrupador',v_id_tipo_obligacion_agrupador::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'PLA_TIOBAG_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        05-02-2019 20:20:47
    ***********************************/

    elsif(p_transaccion='PLA_TIOBAG_MOD')then

        begin
            --el codigo es en mayusculas y no permite espacios en blanco
            v_parametros.codigo=trim(upper(v_parametros.codigo));
            v_parametros.codigo=REPLACE(v_parametros.codigo,' ', '');
            SELECT
              tioagr.codigo
            INTO
              v_codigo  
            FROM  plani.ttipo_obligacion_agrupador  tioagr
            WHERE trim(upper(tioagr.codigo))= v_parametros.codigo and tioagr.id_tipo_obligacion_agrupador<>v_parametros.id_tipo_obligacion_agrupador;
            --si existe el codigo no se modifica
            IF v_codigo is not null THEN
                RAISE EXCEPTION 'El codigo % ya existe',v_parametros.codigo;
            END IF;
            --Sentencia de la modificacion
            update plani.ttipo_obligacion_agrupador set
            codigo = v_parametros.codigo,
            codigo_plantilla_comprobante = v_parametros.codigo_plantilla_comprobante,
            nombre = v_parametros.nombre,
            fecha_mod = now(),
            id_usuario_mod = p_id_usuario,
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            descripcion = v_parametros.descripcion  --#1 EGS
            where id_tipo_obligacion_agrupador=v_parametros.id_tipo_obligacion_agrupador;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador Tipo de Obligacion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion_agrupador',v_parametros.id_tipo_obligacion_agrupador::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'PLA_TIOBAG_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        05-02-2019 20:20:47
    ***********************************/

    elsif(p_transaccion='PLA_TIOBAG_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from plani.ttipo_obligacion_agrupador
            where id_tipo_obligacion_agrupador=v_parametros.id_tipo_obligacion_agrupador;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agrupador Tipo de Obligacion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion_agrupador',v_parametros.id_tipo_obligacion_agrupador::varchar);
              
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