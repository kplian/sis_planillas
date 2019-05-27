CREATE OR REPLACE FUNCTION plani.f_import_ttipo_columna_planilla (
  p_accion varchar,
  p_codigo varchar,
  p_codigo_tipo_pla varchar,
  p_nombre varchar,
  p_tipo_dato varchar,
  p_descripcion text,
  p_formula varchar,
  p_compromete varchar,
  p_tipo_descuento_bono varchar,
  p_decimales_redondeo integer,
  p_orden integer,
  p_finiquito varchar,
  p_tiene_detalle varchar,
  p_recalcular varchar,
  p_estado_reg varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Planilla
 FUNCION:         plani.f_import_ttipo_columna_planilla
 DESCRIPCION:   funcion para insertar la exportacion tipo columna planilla
 AUTOR:         EGS
 FECHA:         23/05/2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA            AUTOR            DESCRIPCION

***************************************************************************/

DECLARE
    
    v_id_tipo_columna      integer;
    v_id_tipo_planilla      integer;
BEGIN
     


    SELECT
     tic.id_tipo_columna
    INTO 
    v_id_tipo_columna
    FROM plani.ttipo_columna tic   
    where trim(lower(tic.codigo)) = trim(lower(p_codigo));
    --raise exception ' %',p_codigo;
    SELECT
     tpla.id_tipo_planilla
    INTO 
    v_id_tipo_planilla
    FROM plani.ttipo_planilla tpla   
    where trim(lower(tpla.codigo )) = trim(lower(p_codigo_tipo_pla));         
    if (p_accion = 'delete') then
        
        update plani.ttipo_columna
            set estado_reg = 'inactivo'
        where id_tipo_columna = v_id_tipo_columna;
    
    else
        if (v_id_tipo_columna is null)then
                              
            INSERT INTO 
              plani.ttipo_columna
                (
                  id_usuario_reg,
                  fecha_reg,
                  estado_reg,
                  id_tipo_planilla,
                  codigo,
                  nombre,
                  tipo_dato,
                  descripcion,
                  formula,
                  compromete,
                  tipo_descuento_bono,
                  decimales_redondeo,
                  orden,
                  finiquito,
                  tiene_detalle,
                  recalcular
                )
                VALUES (
                  1,
                  now(),
                  p_estado_reg,
                  v_id_tipo_planilla,
                  p_codigo,
                  p_nombre,
                  p_tipo_dato,
                  p_descripcion,
                  p_formula,
                  p_compromete,
                  p_tipo_descuento_bono,
                  p_decimales_redondeo,
                  p_orden,
                  p_finiquito,
                  p_tiene_detalle,
                  p_recalcular
              );
           
                
        else            
              UPDATE 
                plani.ttipo_columna 
              SET 
                id_usuario_mod = 1,
                fecha_mod = now(),
                estado_reg = p_estado_reg,
                id_tipo_planilla = v_id_tipo_planilla,
                codigo = p_codigo,
                nombre = p_nombre,
                tipo_dato = p_tipo_dato,
                descripcion = p_descripcion,
                formula = p_formula,
                compromete = p_compromete,
                tipo_descuento_bono = p_tipo_descuento_bono,
                decimales_redondeo = p_decimales_redondeo,
                orden = p_orden,
                finiquito = p_finiquito,
                tiene_detalle = p_tiene_detalle,
                recalcular = p_recalcular
              WHERE 
                id_tipo_columna = v_id_tipo_columna;
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