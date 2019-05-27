CREATE OR REPLACE FUNCTION plani.f_import_ttipo_obligacion (
  p_accion varchar,
  p_codigo varchar,
  p_codigo_tipo_planilla varchar,
  p_nombre varchar,
  p_tipo_obligacion varchar,
  p_dividir_por_lugar varchar,
  p_es_pagable varchar,
  p_codigo_tipo_obligacion_agrupador varchar,
  p_descripcion varchar,
  p_codigo_tipo_relacion_debe varchar,
  p_codigo_tipo_relacion_haber varchar,
  p_estado_reg varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Planilla
 FUNCION:        plani.f_import_ttipo_obligacion
 DESCRIPCION:   funcion para insertar la exportacion tipo obligacion
 AUTOR:         EGS
 FECHA:         23/05/2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA            AUTOR            DESCRIPCION

***************************************************************************/

DECLARE
    
    v_id_tipo_obligacion    integer;
    v_id_tipo_planilla      integer;
    v_id_tipo_obligacion_agrupador  integer;
BEGIN
     


    SELECT
     tio.id_tipo_obligacion
    INTO 
    v_id_tipo_obligacion
    FROM plani.ttipo_obligacion tio  
    where trim(lower(tio.codigo)) = trim(lower(p_codigo));

    SELECT
     tpla.id_tipo_planilla
    INTO 
    v_id_tipo_planilla
    FROM plani.ttipo_planilla tpla   
    where trim(lower(tpla.codigo )) = trim(lower(p_codigo_tipo_planilla)); 
    
    SELECT
     tioa.id_tipo_obligacion_agrupador
    INTO 
    v_id_tipo_obligacion_agrupador
    FROM plani.ttipo_obligacion_agrupador tioa   
    where trim(lower(tioa.codigo )) = trim(lower(p_codigo_tipo_obligacion_agrupador));         
    
    if (p_accion = 'delete') then
        
        update plani.ttipo_planilla  set estado_reg = 'inactivo'
        where id_tipo_planilla = v_id_tipo_planilla;
    
    else
        if (v_id_tipo_obligacion is null)then
                              
                    INSERT INTO 
                      plani.ttipo_obligacion
                    (
                      id_usuario_reg,
                      fecha_reg,
                      estado_reg,
                      id_tipo_planilla,
                      codigo,
                      nombre,
                      tipo_obligacion,
                      dividir_por_lugar,
                      es_pagable,
                      id_tipo_obligacion_agrupador,
                      descripcion,
                      codigo_tipo_relacion_debe,
                      codigo_tipo_relacion_haber
                    )
                    VALUES (
                      1,
                      now(),
                      p_estado_reg,
                      v_id_tipo_planilla,
                      p_codigo,
                      p_nombre,
                      p_tipo_obligacion,
                      p_dividir_por_lugar,
                      p_es_pagable,
                      v_id_tipo_obligacion_agrupador,
                      p_descripcion,
                      p_codigo_tipo_relacion_debe,
                      p_codigo_tipo_relacion_haber
                    );
           
                
        else         
           UPDATE 
                  plani.ttipo_obligacion 
                SET 
                  id_usuario_mod = 1,
                  fecha_mod = now(),
                  estado_reg = p_estado_reg,
                  id_tipo_planilla = v_id_tipo_planilla,
                  codigo = p_codigo,
                  nombre = p_nombre,
                  tipo_obligacion = p_tipo_obligacion,
                  dividir_por_lugar = p_dividir_por_lugar,
                  es_pagable = p_es_pagable,
                  id_tipo_obligacion_agrupador = v_id_tipo_obligacion_agrupador,
                  descripcion = p_descripcion,
                  codigo_tipo_relacion_debe = p_codigo_tipo_relacion_debe,
                  codigo_tipo_relacion_haber = p_codigo_tipo_relacion_haber
                WHERE 
                  id_tipo_obligacion =v_id_tipo_obligacion;                          
        end if;
    
    end if; 
    return 'exito';
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;