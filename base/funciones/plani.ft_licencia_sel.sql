--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.ft_licencia_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_licencia_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tlicencia'
 AUTOR: 		 (admin)
 FECHA:	        07-03-2019 13:53:18
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                	AUTOR                DESCRIPCION
 #0 ENDEETR           07-03-2019 13:53:18  	EGS                  Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tlicencia'
 #114                 16/04/2020  			EGS 				 Se agrega desc funcionario por Combo de Funcionario en licencias
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_filtro              varchar;

BEGIN

    v_nombre_funcion = 'plani.ft_licencia_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PLA_LICE_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin
     #FECHA:        07-03-2019 13:53:18
    ***********************************/

    if(p_transaccion='PLA_LICE_SEL')then

        begin
                --raise Exception '%',v_parametros.id_funcionario;
                 IF p_administrador !=1  then
                    IF v_parametros.nombreVista = 'LicenciaReq' THEN
                      v_filtro = 'lice.id_funcionario = '||v_parametros.id_funcionario||'  and ';
                      --raise Exception '%',v_filtro;
                    ELSIF v_parametros.nombreVista = 'LicenciaVobo'THEN
                    v_filtro = 'eswf.id_funcionario = '||v_parametros.id_funcionario||' and ';
                    ELSE
                    v_filtro = ' ';
                    END IF;
                 ELSE
                   v_filtro = ' ';
                 END IF;
                 IF v_parametros.nombreVista = 'Licencia' THEN
                      v_filtro = 'lice.id_funcionario = '||v_parametros.id_funcionario||' and ';
                 END IF;
            --Sentencia de la consulta
            v_consulta:='select
                        lice.id_licencia,
                        lice.id_tipo_licencia,
                        lice.estado,
                        lice.estado_reg,
                        lice.desde,
                        lice.motivo,
                        lice.hasta,
                        lice.id_funcionario,
                        lice.fecha_reg,
                        lice.usuario_ai,
                        lice.id_usuario_reg,
                        lice.id_usuario_ai,
                        lice.id_usuario_mod,
                        lice.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        tiplic.nombre as desc_tipo_lic,
                        lice.id_proceso_wf,
                        lice.id_estado_wf,
                        lice.nro_tramite,
                        fun.desc_funcionario1::varchar --#114
                        from plani.tlicencia lice
                        inner join segu.tusuario usu1 on usu1.id_usuario = lice.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = lice.id_usuario_mod
                        left join plani.ttipo_licencia tiplic on tiplic.id_tipo_licencia = lice.id_tipo_licencia
                        left join wf.testado_wf eswf on eswf.id_estado_wf = lice.id_estado_wf
                        join orga.vfuncionario fun on fun.id_funcionario = lice.id_funcionario
                        where '||v_filtro;
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PLA_LICE_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin
     #FECHA:        07-03-2019 13:53:18
    ***********************************/

    elsif(p_transaccion='PLA_LICE_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_licencia)
                        from plani.tlicencia lice
                        inner join segu.tusuario usu1 on usu1.id_usuario = lice.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = lice.id_usuario_mod
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
PARALLEL UNSAFE
COST 100;