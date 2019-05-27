CREATE OR REPLACE FUNCTION plani.f_import_ttipo_obligacion_columna (
  p_accion varchar,
  p_codigo varchar,
  p_codigo_tipo_obligacion varchar,
  p_codigo_tipo_planilla varchar,
  p_pago varchar,
  p_presupuesto varchar,
  p_es_ultimo varchar,
  p_estado_reg varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Planilla
 FUNCION:        plani.f_import_ttipo_obligacion_columna
 DESCRIPCION:   funcion para insertar la exportacion tipo obligacion columna
 AUTOR:         EGS
 FECHA:         23/05/2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA            AUTOR            DESCRIPCION

***************************************************************************/

DECLARE
    
    v_id_tipo_obligacion_columna    integer;
    v_id_tipo_obligacion            integer;
    v_id_tipo_planilla              integer;
BEGIN
    
    SELECT
     tip.id_tipo_planilla
    INTO 
    v_id_tipo_planilla
    FROM plani.ttipo_planilla tip   
    where trim(lower(tip.codigo)) = trim(lower(p_codigo_tipo_planilla));
    
    SELECT
         tio.id_tipo_obligacion
        INTO 
        v_id_tipo_obligacion
        FROM plani.ttipo_obligacion tio  
        where trim(lower(tio.codigo)) = trim(lower(p_codigo_tipo_obligacion)) and tio.id_tipo_planilla = v_id_tipo_planilla;

    SELECT
     tioc.id_tipo_obligacion_columna
    INTO 
    v_id_tipo_obligacion_columna
    FROM plani.ttipo_obligacion_columna tioc  
    where trim(lower(tioc.codigo_columna)) = trim(lower(p_codigo));
    
    
 
    if (p_accion = 'delete') then
        
        update plani.ttipo_obligacion_columna  set estado_reg = 'inactivo'
        where id_tipo_obligacion_columna = v_id_tipo_obligacion_columna;
    
    else
        if (v_id_tipo_obligacion_columna is null)then
                              
                   INSERT INTO 
                      plani.ttipo_obligacion_columna
                    (
                      id_usuario_reg,
                      fecha_reg,
                      estado_reg,
                      id_tipo_obligacion,
                      codigo_columna,
                      pago,
                      presupuesto,
                      es_ultimo
                    )
                    VALUES (
                      1,
                      now(),
                      p_estado_reg,
                      v_id_tipo_obligacion,
                      p_codigo,
                      p_pago,
                      p_presupuesto,
                      p_es_ultimo
                    );
           
                
        else         
                  UPDATE 
                    plani.ttipo_obligacion_columna 
                  SET 
                    id_usuario_mod = 1,
                    fecha_mod = now(),
                    estado_reg = p_estado_reg,
                    id_tipo_obligacion = v_id_tipo_obligacion,
                    codigo_columna = p_codigo,
                    pago = p_pago,
                    presupuesto = p_presupuesto,
                    es_ultimo = p_es_ultimo
                  WHERE 
                    id_tipo_obligacion_columna = v_id_tipo_obligacion_columna;                       
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