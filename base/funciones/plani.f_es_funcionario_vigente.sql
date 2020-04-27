--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_es_funcionario_vigente (
  p_id_funcionario integer,
  p_fecha date
)
RETURNS boolean AS
$body$
/**************************************************************************
 FUNCION:       plani.f_es_funcionario_vigente
 DESCRIPCION:   verifica si el funcionario indicado tiene un contrato vigente a la fecha indicada

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
  v_nombre_funcion          TEXT;
  v_id_uo_funcionario       INTEGER;
  v_resp                    TEXT;
BEGIN

   v_nombre_funcion = 'plani.f_es_funcionario_vigente';

   SELECT uf.id_uo_funcionario
   INTO v_id_uo_funcionario
   FROM orga.tuo_funcionario uf
   JOIN orga.tcargo car ON car.id_cargo = uf.id_cargo
   JOIN orga.ttipo_contrato tc ON tc.id_tipo_contrato = car.id_tipo_contrato
   WHERE uf.id_funcionario = p_id_funcionario
     AND uf.estado_reg != 'inactivo'
     AND uf.tipo = 'oficial'
     AND tc.codigo in ('PLA','EVE')  --solo considera planta y eventuales como validos
     AND uf.fecha_asignacion <= p_fecha
     AND (
           uf.fecha_finalizacion is NULL
           OR
           uf.fecha_finalizacion >= p_fecha
         );


   IF v_id_uo_funcionario IS NULL THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
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