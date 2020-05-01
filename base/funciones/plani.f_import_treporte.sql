--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_import_treporte (
  p_accion varchar,
  p_codigo_reporte varchar,
  p_codigo_tipo_planilla varchar,
  p_numerar varchar,
  p_hoja_posicion varchar,
  p_mostrar_nombre varchar,
  p_mostrar_codigo_empleado varchar,
  p_mostrar_doc_id varchar,
  p_mostrar_codigo_cargo varchar,
  p_agrupar_por varchar,
  p_ordenar_por varchar,
  p_estado_reg varchar,
  p_ancho_utilizado integer,
  p_ancho_total integer,
  p_titulo_reporte varchar,
  p_control_reporte varchar,
  p_tipo_reporte varchar,
  p_multilinea varchar,
  p_vista_datos_externos varchar,
  p_num_columna_multilinea integer,
  p_mostrar_ufv varchar,
  p_incluir_retirados varchar,
  p_codigo_moneda varchar,
  p_bordes integer,
  p_interlineado numeric
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Planilla
 FUNCION:       plani.f_import_treporte
 DESCRIPCION:   funcion para insertar la exportacion tipo obligacion
 AUTOR:         RAC
 FECHA:         01/05/2020
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA            AUTOR            DESCRIPCION
 #121  ETR       01/05/2020        RAC        creacion
***************************************************************************/

DECLARE
    v_id_reporte                    integer;
    v_id_tipo_planilla              integer;
    v_id_moneda_reporte             integer;
BEGIN

    SELECT
     tpla.id_tipo_planilla
    INTO
    v_id_tipo_planilla
    FROM plani.ttipo_planilla tpla
    where trim(lower(tpla.codigo )) = trim(lower(p_codigo_tipo_planilla)) and tpla.estado_reg = 'activo'; --#11

    SELECT
     repo.id_reporte
    INTO
     v_id_reporte
    FROM plani.treporte repo
    where trim(lower(repo.titulo_reporte)) = trim(lower(p_codigo_reporte))
      and repo.id_tipo_planilla = v_id_tipo_planilla
      and repo.estado_reg = 'activo';

     IF p_codigo_moneda IS NOT NULL THEN

        SELECT m.id_moneda
        into v_id_moneda_reporte
        FROM param.tmoneda m
        WHERE m.codigo = p_codigo_moneda;

     END IF;



    IF (p_estado_reg = 'inactivo') AND v_id_reporte is NULL THEN
        update plani.treporte
           set estado_reg = 'inactivo',
               obs_dba = 'inactivado desde el importador f_import_treporte'
        where id_reporte = v_id_reporte;
    ELSE


        IF v_id_reporte is NULL THEN


                -- si el rpeorte no existe crea uno nuevo
               INSERT INTO
                plani.treporte
              (
                id_usuario_reg,
                fecha_reg,
                estado_reg,
                id_tipo_planilla,
                hoja_posicion,
                titulo_reporte,
                agrupar_por,
                numerar,
                mostrar_nombre,
                mostrar_codigo_empleado,
                mostrar_doc_id,
                mostrar_codigo_cargo,
                ordenar_por,
                ancho_total,
                ancho_utilizado,
                control_reporte,
                tipo_reporte,
                multilinea,
                vista_datos_externos,
                num_columna_multilinea,
                mostrar_ufv,
                incluir_retirados,
                id_moneda_reporte,
                bordes,
                interlineado
              )
              VALUES (
                1,
                now(),
                'activo',
                v_id_tipo_planilla,
                p_hoja_posicion,
                p_titulo_reporte,
                p_agrupar_por,
                p_numerar,
                p_mostrar_nombre,
                p_mostrar_codigo_empleado,
                p_mostrar_doc_id,
                p_mostrar_codigo_cargo,
                p_ordenar_por,
                p_ancho_total,
                p_ancho_utilizado,
                p_control_reporte,
                p_tipo_reporte,
                p_multilinea,
                p_vista_datos_externos,
                p_num_columna_multilinea,
                p_mostrar_ufv,
                p_incluir_retirados,
                v_id_moneda_reporte,
                p_bordes,
                p_interlineado
              );

         ELSE

              UPDATE
                plani.treporte
              SET
                id_usuario_mod = 1,
                fecha_mod = now(),
                obs_dba = 'modificado desde el importador f_import_treporte',
                hoja_posicion = p_hoja_posicion,
                titulo_reporte = p_titulo_reporte,
                agrupar_por = p_agrupar_por,
                numerar = p_numerar,
                mostrar_nombre = p_mostrar_nombre,
                mostrar_codigo_empleado = p_mostrar_codigo_empleado,
                mostrar_doc_id = p_mostrar_doc_id,
                mostrar_codigo_cargo = p_mostrar_codigo_cargo,
                ordenar_por = p_ordenar_por,
                ancho_total = p_ancho_total,
                ancho_utilizado = p_ancho_utilizado,
                control_reporte = p_control_reporte,
                tipo_reporte = p_tipo_reporte,
                multilinea = p_multilinea,
                vista_datos_externos = p_vista_datos_externos,
                num_columna_multilinea = p_num_columna_multilinea,
                mostrar_ufv = p_mostrar_ufv,
                incluir_retirados = p_incluir_retirados,
                id_moneda_reporte = v_id_moneda_reporte,
                bordes = p_bordes,
                interlineado = p_interlineado
              WHERE
                id_reporte = v_id_reporte;

        END IF;
    END IF;

    return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;