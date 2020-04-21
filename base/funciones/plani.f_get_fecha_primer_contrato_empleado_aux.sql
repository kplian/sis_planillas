--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_get_fecha_primer_contrato_empleado_aux (
  p_id_uo_funcionario integer,
  p_id_funcionario integer,
  p_fecha_ini date,
  p_tipo_contrato varchar,
  p_carga_horaria integer,
  p_dividir_tipo_contrato varchar,
  p_dividir_carga_horaria varchar
)
RETURNS date AS
$body$
/**************************************************************************
 FUNCION:       plani.f_get_fecha_primer_contrato_empleado_aux
 DESCRIPCION:

                Web
 AUTOR:         KPLIAN (rac)
 FECHA:         20/04/2020
 COMENTARIOS:
***************************************************************************


    HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION
 #113           20/04/2020      rac     KPLIAN    creacion
 ***************************************************************************/


DECLARE

  v_fecha_ini               date;
  v_id_uo_funcionario       integer;
  v_resp                    varchar;
  v_nombre_funcion          text;
  v_mensaje_error           text;
  v_dividir_tipo_contrato   varchar;
  v_dividir_carga_horaria   varchar;
  v_reg_funcionario         record;
BEGIN
  v_fecha_ini = null;
  v_nombre_funcion = 'plani.f_get_fecha_primer_contrato_empleado_aux';



  select uofun.id_uo_funcionario, uofun.fecha_asignacion
  into  v_id_uo_funcionario, v_fecha_ini
  from orga.tuo_funcionario uofun
  inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
  inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
  where uofun.id_funcionario = p_id_funcionario and uofun.fecha_finalizacion = p_fecha_ini - interval '1 day'
        and uofun.estado_reg != 'inactivo'
        and uofun.tipo = 'oficial'
        and (
             (p_dividir_tipo_contrato = 'no' AND tc.codigo in ('PLA','EVE'))
             OR
             (p_dividir_tipo_contrato = 'si' AND tc.codigo = p_tipo_contrato)
            )
        and (
             (p_dividir_carga_horaria = 'si' AND uofun.carga_horaria = p_carga_horaria)
            OR
             p_dividir_carga_horaria = 'no'
            );


  if (v_fecha_ini is not null) then

    v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado_aux( v_id_uo_funcionario,
                                                                  p_id_funcionario,
                                                                  v_fecha_ini,
                                                                  p_tipo_contrato,
                                                                  p_carga_horaria,
                                                                  p_dividir_tipo_contrato,
                                                                  p_dividir_carga_horaria);
  else
    v_fecha_ini = p_fecha_ini;
  end if;

  return v_fecha_ini;
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;