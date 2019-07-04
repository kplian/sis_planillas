--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_reporte_funcionario_planilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:      Sistema de Planillas
 FUNCION:      plani.f_reporte_funcionario_planilla_sel
 DESCRIPCION:  
 AUTOR:        (EGS)
 FECHA:        27/06/2019
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #16    ETR            27/06/2019           EGS                 Creacion 
 #
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_fecha_ini           date;
    v_fecha_fin           date;
    v_filtro              varchar;
                
BEGIN

    v_nombre_funcion = 'plani.f_reporte_funcionario_planilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PLA_REFUPL_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        EGS    
     #FECHA:        04/07/2019
    ***********************************/

    if(p_transaccion='PLA_REFUPL_SEL')then
        
       
        SELECT
            per.fecha_ini,
            per.fecha_fin
        INTO
            v_fecha_ini,
            v_fecha_fin
        FROM param.tperiodo per
        WHERE id_periodo = v_parametros.id_periodo;
        
        v_filtro = '( rfu.fecha_finalizacion >= '''||v_fecha_ini::varchar||''' or rfu.fecha_finalizacion is null) and';
       
        begin
            --Sentencia de la consulta
            v_consulta:='SELECT 
                              rfu.id_funcionario,
                              rfu.ci,
                              rfu.codigo,
                              rfu.desc_funcionario1::text,
                              rfu.desc_funcionario2::text,
                              rfu.num_doc,
                              rfu.fecha_asignacion,
                              rfu.fecha_finalizacion,                                                                                       
                              rfu.id_cargo,
                              rfu.codigo_cargo,
                              rfu.nombre_cargo,
                              rfu.observaciones_finalizacion,
                              rfu.nro_documento_asignacion,
                              rfu.fecha_documento_asignacion,
                              rfu.tipo,
                              rfu.text::text,                             
                              rfu.id_uo_funcionario,
                              rfu.id_uo,
                              rfu.nombre_lugar,
                              rfu.codigo_gerencia,
                              rfu.nombre_unidad_gerencia,
                              rfu.codigo_uo_pre,
                              rfu.nombre_uo_pre,
                              rfu.codigo_uo_centro,
                              rfu.nombre_uo_centro,
                              rfu.firma::text,
                              rfu.interno,
                              rfu.id_biometrico,
                              rfu.email_empresa,
                              rfu.telefono_ofi,
                              rfu.codigo_rciva,
                              rfu.profesion,
                              rfu.id_afp,
                              rfu.nombre_afp,
                              rfu.nro_afp,
                              rfu.tipo_jubilado,
                              rfu.edad::integer,
                              rfu.carnet_discapacitado,
                              rfu.celular_personal,
                              rfu.correo_personal,
                              rfu.estado_civil,
                              rfu.expedicion,
                              rfu.genero,
                              rfu.direccion,
                              rfu.fecha_nacimiento,
                              rfu.ano_nacimiento::integer,
                              rfu.mes_nacimiento::varchar,
                              rfu.estado_reg, 
                              rfu.fecha_reg,
                              rfu.fecha_mod,
                              rfu.id_usuario_reg,
                              rfu.id_usuario_mod,
                              rfu.uo_centro_orden,                              
                              rfu.codigo_tipo_contrato,
                              rfu.nombre_tipo_contrato,
                              rfu.tipo_asignacion
                              
                            FROM plani.vrep_funcionario rfu
                        where '||v_filtro||' ';
            
        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        if pxp.f_existe_parametro(p_tabla, 'groupBy') THEN
            
                IF v_parametros.groupBy = 'nombre_uo_centro' or v_parametros.groupBy = 'codigo_uo_centro' THEN
                  v_consulta:=v_consulta||' order by uo_centro_orden ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
                
                ELSEIF v_parametros.groupBy = 'mes_nacimiento'  THEN
                  v_consulta:=v_consulta||' order by mes_numero ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
                
                ELSE 
            
                  v_consulta:=v_consulta||' order by ' ||v_parametros.groupBy|| ' ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
                 END IF;
            else
                 v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
        end if;
       
        raise notice 'v_consulta % ',v_consulta;
          --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'PLA_REFUPL_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        miguel.mamani    
     #FECHA:        15-05-2019 22:18:29
    ***********************************/

    elsif(p_transaccion='PLA_REFUPL_CONT')then

        begin
             SELECT
                  per.fecha_ini,
                  per.fecha_fin
              INTO
                  v_fecha_ini,
                  v_fecha_fin
              FROM param.tperiodo per
              WHERE id_periodo = v_parametros.id_periodo;
              
              v_filtro = '(rfu.fecha_finalizacion >= '''||v_fecha_ini::varchar||''' or rfu.fecha_finalizacion is null) and';
             
                
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT count(rfu.id_funcionario)
                       FROM plani.vrep_funcionario rfu
                       WHERE '||v_filtro||' ';
            
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