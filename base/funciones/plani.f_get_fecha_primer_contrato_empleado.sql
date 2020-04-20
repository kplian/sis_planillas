--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_get_fecha_primer_contrato_empleado (
  p_id_uo_funcionario integer,
  p_id_funcionario integer,
  p_fecha_ini date
)
RETURNS date AS
$body$
/**************************************************************************
 FUNCION:       plani.f_get_fecha_primer_contrato_empleado
 DESCRIPCION:

                Web
 AUTOR:         KPLIAN (jrr)
 FECHA:
 COMENTARIOS:
***************************************************************************


    HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 0              -               jrr     KPLIAN     creacion
 #113           20/04/2020      rac     KPLIAN     agrega variable globales para dividir la entiguedad seun tipo de contrato o segun carga horaria
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
  v_nombre_funcion = 'plani.f_get_fecha_primer_contrato_empleado';

  v_dividir_tipo_contrato := pxp.f_get_variable_global_defecto('plani_dividir_antiguedad_tipo_contrato');
  v_dividir_carga_horaria := pxp.f_get_variable_global_defecto('plani_dividir_antiguedad_carga_horaria');

  -- obtiene  datos del ultimo contrato a la fecha señalada
  SELECT
        uf.id_uo_funcionario,
        uf.carga_horaria,
        tc.codigo as tipo_contrato
  INTO v_reg_funcionario
  FROM orga.tuo_funcionario uf
  INNER JOIN orga.tcargo car on car.id_cargo = uf.id_cargo
  INNER JOIN orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
  WHERE uf.id_funcionario = p_id_funcionario
    AND uf.fecha_asignacion = p_fecha_ini
    AND uf.estado_reg != 'inactivo'
    AND uf.tipo = 'oficial';

  IF v_reg_funcionario IS NULL THEN
      return plani.f_get_fecha_primer_contrato_empleado_aux(v_reg_funcionario.id_uo_funcionario,
                                                            p_id_funcionario,
                                                            p_fecha_ini,
                                                            v_reg_funcionario.tipo_contrato,
                                                            v_reg_funcionario.carga_horaria,
                                                            v_dividir_tipo_contrato,
                                                            v_dividir_carga_horaria);
  ELSE
       raise exception 'no se encontro un contrato activo para el funcionario % en fecha %',p_id_funcionario, p_fecha_ini;
  END IF;

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