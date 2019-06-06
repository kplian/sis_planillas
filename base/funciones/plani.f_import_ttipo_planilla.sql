CREATE OR REPLACE FUNCTION plani.f_import_ttipo_planilla (
  p_accion varchar,
  p_codigo varchar,
  p_nombre varchar,
  p_codigo_proceso_macro varchar,
  p_funcion_obtener_empleados varchar,
  p_tipo_presu_cc varchar,
  p_funcion_validacion_nuevo_empleado varchar,
  p_calculo_horas varchar,
  p_periodicidad varchar,
  p_funcion_calculo_horas varchar,
  p_recalcular_desde integer,
  p_estado_reg varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Planilla
 FUNCION:         plani.f_import_ttipo_planilla
 DESCRIPCION:   funcion para insertar la exportacion tipo planilla
 AUTOR:         EGS
 FECHA:         23/05/2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA            AUTOR            DESCRIPCION
#11   endeetr    05/06/2019       EGS              actualizaciones de registros activos
***************************************************************************/

DECLARE
    
    v_id_tipo_planilla      integer;
    v_id_proceso_macro      integer;
BEGIN
     


    SELECT
     tip.id_tipo_planilla
    INTO 
    v_id_tipo_planilla
    FROM plani.ttipo_planilla tip   
    where trim(lower(tip.codigo)) = trim(lower(p_codigo)) and tip.estado_reg = 'activo'; --#11
    --raise exception ' %',p_codigo;
    SELECT
     pm.id_proceso_macro
    INTO 
    v_id_proceso_macro
    FROM wf.tproceso_macro pm   
    where trim(lower(pm.codigo)) = trim(lower(p_codigo_proceso_macro));         
    if (p_accion = 'delete') then
        
        update plani.ttipo_planilla  set estado_reg = 'inactivo'
        where id_tipo_planilla = v_id_tipo_planilla;
    
    else
        if (v_id_tipo_planilla is null)then
                              
              INSERT INTO 
                plani.ttipo_planilla
              (
                id_usuario_reg,
                fecha_reg,
                estado_reg,
                codigo,
                nombre,
                id_proceso_macro,
                funcion_obtener_empleados,
                tipo_presu_cc,
                funcion_validacion_nuevo_empleado,
                calculo_horas,
                periodicidad,
                funcion_calculo_horas,
                recalcular_desde
              )
              VALUES (
                1,
                now(),
                p_estado_reg,
                p_codigo,
                p_nombre,
                v_id_proceso_macro,
                p_funcion_obtener_empleados,
                p_tipo_presu_cc,
                p_funcion_validacion_nuevo_empleado,
                p_calculo_horas,
                p_periodicidad,
                p_funcion_calculo_horas,
                p_recalcular_desde
              );
           
                
        else            
            UPDATE 
              plani.ttipo_planilla 
            SET 
              id_usuario_mod = 1,
              fecha_mod = now(),
              estado_reg = p_estado_reg,
              codigo = p_codigo,
              nombre = p_nombre,
              id_proceso_macro = v_id_proceso_macro,
              funcion_obtener_empleados = p_funcion_obtener_empleados,
              tipo_presu_cc = p_tipo_presu_cc,
              funcion_validacion_nuevo_empleado = p_funcion_validacion_nuevo_empleado,
              calculo_horas = p_calculo_horas,
              periodicidad = p_periodicidad,
              funcion_calculo_horas = p_funcion_calculo_horas,
              recalcular_desde = p_recalcular_desde
            WHERE id_tipo_planilla = v_id_tipo_planilla;                                
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