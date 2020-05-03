--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_import_treporte_columna (
  p_accion varchar,
  p_codigo_columna varchar,
  p_codigo_reporte varchar,
  p_codigo_tipo_planilla varchar,
  p_sumar_total varchar,
  p_ancho_columna integer,
  p_orden integer,
  p_estado_reg varchar,
  p_titulo_reporte_superior varchar,
  p_titulo_reporte_inferior varchar,
  p_tipo_columna varchar,
  p_espacio_previo integer,
  p_columna_vista varchar,
  p_origen varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Planilla
 FUNCION:       plani.f_import_treporte_columna
 DESCRIPCION:   funcion para insertar la exportacion reporte de planillas
 AUTOR:         RAC
 FECHA:         01/05/2020
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA            AUTOR            DESCRIPCION
 #121  ETR       01/05/2020        RAC        creacion
***************************************************************************/

DECLARE

    v_id_reporte_columna           integer;
    v_id_reporte                   integer;
    v_id_tipo_planilla             integer;
BEGIN

    SELECT
      tip.id_tipo_planilla
    INTO
     v_id_tipo_planilla
    FROM plani.ttipo_planilla tip
    where trim(lower(tip.codigo)) = trim(lower(p_codigo_tipo_planilla))
      and tip.estado_reg = 'activo' ; --#11



   SELECT
     repo.id_reporte
    INTO
     v_id_reporte
    FROM plani.treporte repo
    WHERE trim(lower(repo.titulo_reporte)) = trim(lower(p_codigo_reporte))
      AND repo.id_tipo_planilla = v_id_tipo_planilla
      AND repo.estado_reg = 'activo';


    SELECT
     rc.id_reporte_columna
    INTO
      v_id_reporte_columna
    FROM plani.treporte_columna rc
    where trim(lower(rc.codigo_columna)) = trim(lower(p_codigo_columna))
      and rc.id_reporte = v_id_reporte
      AND COALESCE(rc.columna_vista,'') = COALESCE(p_columna_vista,'')
      and rc.estado_reg = 'activo';



    if (p_estado_reg = 'inactivo' AND v_id_reporte_columna is NOT NULL ) then

        update plani.treporte_columna
           set estado_reg = 'inactivo',
               obs_dba = 'inactivado desde el importador f_import_treporte_columna'
         where id_reporte_columna = v_id_reporte_columna;

    else

        if (v_id_reporte_columna is null)then
               INSERT INTO
                  plani.treporte_columna
                (
                  id_usuario_reg,
                  fecha_reg,
                  estado_reg,
                  id_reporte,
                  codigo_columna,
                  sumar_total,
                  ancho_columna,
                  orden,
                  titulo_reporte_superior,
                  titulo_reporte_inferior,
                  tipo_columna,
                  columna_vista,
                  origen,
                  espacio_previo
                )
                VALUES (
                  1,
                  now(),
                  'activo',
                  v_id_reporte,
                  p_codigo_columna,
                  p_sumar_total,
                  p_ancho_columna,
                  p_orden,
                  p_titulo_reporte_superior,
                  p_titulo_reporte_inferior,
                  p_tipo_columna,
                  p_columna_vista,
                  p_origen,
                  p_espacio_previo
                );

        else
                 UPDATE
                      plani.treporte_columna
                    SET
                      id_usuario_mod = 1,
                      fecha_mod = now(),
                      obs_dba = 'modificado desde el importador f_import_treporte_columna',
                      codigo_columna = p_codigo_columna,
                      sumar_total = p_sumar_total,
                      ancho_columna = p_ancho_columna,
                      orden = p_orden,
                      titulo_reporte_superior = p_titulo_reporte_superior,
                      titulo_reporte_inferior = p_titulo_reporte_inferior,
                      tipo_columna = p_tipo_columna,
                      columna_vista = p_columna_vista,
                      origen = p_origen,
                      espacio_previo = p_espacio_previo
                    WHERE
                      id_reporte_columna = v_id_reporte_columna;
        end if;

    end if;
    return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;