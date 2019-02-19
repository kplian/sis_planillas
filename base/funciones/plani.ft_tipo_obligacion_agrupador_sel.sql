CREATE OR REPLACE FUNCTION plani.ft_tipo_obligacion_agrupador_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Planillas
 FUNCION:         plani.ft_tipo_obligacion_agrupador_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_obligacion_agrupador'
 AUTOR:          (eddy.gutierrez)
 FECHA:            05-02-2019 20:20:47
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                05-02-2019 20:20:47                                Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_obligacion_agrupador'    
 #1		EndeEtr		19/02/2019		        EGS				Se agrego el campo descripcion
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
                
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_obligacion_agrupador_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PLA_TIOBAG_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        eddy.gutierrez    
     #FECHA:        05-02-2019 20:20:47
    ***********************************/

    if(p_transaccion='PLA_TIOBAG_SEL')then
                     
        begin
            --Sentencia de la consulta
            v_consulta:='select
                        tiobag.id_tipo_obligacion_agrupador,
                        tiobag.codigo,
                        tiobag.codigo_plantilla_comprobante,
                        tiobag.nombre,
                        tiobag.estado_reg,
                        tiobag.id_usuario_ai,
                        tiobag.id_usuario_reg,
                        tiobag.fecha_reg,
                        tiobag.usuario_ai,
                        tiobag.fecha_mod,
                        tiobag.id_usuario_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        tiobag.descripcion --#1 EGS
                        from plani.ttipo_obligacion_agrupador tiobag
                        inner join segu.tusuario usu1 on usu1.id_usuario = tiobag.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tiobag.id_usuario_mod
                        where  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'PLA_TIOBAG_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        05-02-2019 20:20:47
    ***********************************/

    elsif(p_transaccion='PLA_TIOBAG_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_tipo_obligacion_agrupador)
                        from plani.ttipo_obligacion_agrupador tiobag
                        inner join segu.tusuario usu1 on usu1.id_usuario = tiobag.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tiobag.id_usuario_mod
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
                    
    else
                         
        raise exception 'Transaccion inexistente';
                             
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