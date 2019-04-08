CREATE OR REPLACE FUNCTION plani.ft_tipo_licencia_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Planillas
 FUNCION:         plani.ft_tipo_licencia_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_licencia'
 AUTOR:          (admin)
 FECHA:            07-03-2019 13:52:26
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0     EndeETR       07-03-2019 13:52:26     EGS                    Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_licencia'    
 #
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
                
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_licencia_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PLA_TIPLIC_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin    
     #FECHA:        07-03-2019 13:52:26
    ***********************************/

    if(p_transaccion='PLA_TIPLIC_SEL')then
                     
        begin
            --Sentencia de la consulta
            v_consulta:='select
                        tiplic.id_tipo_licencia,
                        tiplic.nombre,
                        tiplic.genera_descuento,
                        tiplic.estado_reg,
                        tiplic.codigo,
                        tiplic.id_usuario_ai,
                        tiplic.id_usuario_reg,
                        tiplic.usuario_ai,
                        tiplic.fecha_reg,
                        tiplic.id_usuario_mod,
                        tiplic.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod    
                        from plani.ttipo_licencia tiplic
                        inner join segu.tusuario usu1 on usu1.id_usuario = tiplic.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tiplic.id_usuario_mod
                        where  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'PLA_TIPLIC_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin    
     #FECHA:        07-03-2019 13:52:26
    ***********************************/

    elsif(p_transaccion='PLA_TIPLIC_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_tipo_licencia)
                        from plani.ttipo_licencia tiplic
                        inner join segu.tusuario usu1 on usu1.id_usuario = tiplic.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = tiplic.id_usuario_mod
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