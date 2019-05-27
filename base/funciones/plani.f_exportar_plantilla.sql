CREATE OR REPLACE FUNCTION plani.f_exportar_plantilla (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Planillas
 FUNCION: 		plani.f_exportar_plantilla
 DESCRIPCION:   exporta la configuraciones
 AUTOR: 		 (EGS)
 FECHA:	        
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
  ISSUE		    FECHA    		AUTOR			DESCRIPCION
	#9 EndeEtr 	21/11/2018		EGS		        Creacion
 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion      text;
    v_resp                varchar;
    v_filtro              varchar;
BEGIN

    v_nombre_funcion = 'plani.f_exportar_plantilla';
    v_parametros = pxp.f_get_record(p_tabla);

     /*********************************    
     #TRANSACCION:  'PLA_EXPTIPL_SEL'
     #DESCRIPCION:   exporta tipo de planilla
     #AUTOR:            EGS
     #FECHA:        
    ***********************************/     
    
    if(p_transaccion='PLA_EXPTIPL_SEL')then
                     
        begin
            --Sentencia de la consulta
            v_consulta:='
                        SELECT
                        ''maestro''::varchar as tipo_reg,                    
                          tpla.codigo,
                          tpla.nombre,                       
                          pm.codigo as codigo_proceso_macro,
                          tpla.funcion_obtener_empleados,
                          tpla.tipo_presu_cc,
                          tpla.funcion_validacion_nuevo_empleado,
                          tpla.calculo_horas,
                          tpla.periodicidad,
                          tpla.funcion_calculo_horas,
                          tpla.recalcular_desde,
                          tpla.estado_reg
                        FROM plani.ttipo_planilla  tpla
                        left join wf.tproceso_macro pm on pm.id_proceso_macro = tpla.id_proceso_macro
                        WHERE tpla.id_tipo_planilla  = '||v_parametros.id_tipo_planilla;
            --Devuelve la respuesta
            return v_consulta;
                        
        end;
     /*********************************    
     #TRANSACCION:  'PLA_EXPTIPLDE_SEL'
     #DESCRIPCION:    exportar plantilla tipo columna
     #AUTOR:            EGS
     #FECHA:        
    ***********************************/     
    
    elsif(p_transaccion='PLA_EXPTIPLDE_SEL')then
                     
        begin
            --Sentencia de la consulta
            v_consulta:='
                    SELECT
                          ''detalle''::varchar as tipo_reg,
                             tc.codigo,
                             tpla.codigo as codigo_tipo_pla,
                             tc.nombre,
                             tc.tipo_dato,
                             tc.descripcion,
                             tc.formula,
                             tc.compromete,
                             tc.tipo_descuento_bono,
                             tc.decimales_redondeo,
                             tc.orden,
                             tc.finiquito,
                             tc.tiene_detalle,
                             tc.recalcular,
                             tc.estado_reg
                      FROM plani.ttipo_columna tc
                        left JOIN plani.ttipo_planilla tpla on tpla.id_tipo_planilla = tc.id_tipo_planilla 
                      WHERE tc.id_tipo_planilla = '||v_parametros.id_tipo_planilla;
                v_consulta = v_consulta||' Order By tc.codigo ASC';
            --Devuelve la respuesta
            return v_consulta;
                        
        end;
  /*********************************    
     #TRANSACCION:  'PLA_EXPTIOB_SEL'
     #DESCRIPCION:   exporta tipo de Obligacion
     #AUTOR:            EGS
     #FECHA:        
    ***********************************/     
    
    elsif(p_transaccion='PLA_EXPTIOB_SEL')then
                     
        BEGIN
            IF (pxp.f_existe_parametro(p_tabla,'id_tipo_planilla')) THEN
                    v_filtro = 'tio.id_tipo_planilla = '||v_parametros.id_tipo_planilla;
            ELSIF (pxp.f_existe_parametro(p_tabla,'id_tipo_obligacion'))THEN               
                    v_filtro = 'tio.id_tipo_obligacion = '||v_parametros.id_tipo_obligacion;
            END IF;
                        
            --Sentencia de la consulta
            v_consulta:='
                        SELECT
                        ''maestro_tipo_obli''::varchar as tipo_reg,                    
                          tio.codigo,
                          tpla.codigo as codigo_tipo_planilla, 
                          tio.nombre,                                                                    
                          tio.tipo_obligacion,
                          tio.dividir_por_lugar,
                          tio.es_pagable,
                          tioa.codigo as codigo_tipo_obligacion_agrupador,
                          tio.descripcion,
                          tio.codigo_tipo_relacion_debe,
                          tio.codigo_tipo_relacion_haber,
                          tio.estado_reg
                        FROM  plani.ttipo_obligacion  tio
                            LEFT JOIN plani.ttipo_planilla tpla on tpla.id_tipo_planilla = tio.id_tipo_planilla
                            LEFT JOIN plani.ttipo_obligacion_agrupador tioa on tioa.id_tipo_obligacion_agrupador = tio.id_tipo_obligacion_agrupador
                        WHERE '||v_filtro;
                       v_consulta = v_consulta||' Order By tio.codigo ASC';
            --Devuelve la respuesta
            return v_consulta;
                        
        end;
     /*********************************    
     #TRANSACCION:  'PLA_EXPTIOBCO_SEL'
     #DESCRIPCION:    exportar plantilla tipo obligacion columna
     #AUTOR:            EGS
     #FECHA:        
    ***********************************/     
    
    elsif(p_transaccion='PLA_EXPTIOBCO_SEL')then
                     
        begin
            IF (pxp.f_existe_parametro(p_tabla,'id_tipo_planilla')) THEN
               v_filtro = 'tio.id_tipo_planilla = '||v_parametros.id_tipo_planilla;
            ELSIF (pxp.f_existe_parametro(p_tabla,'id_tipo_obligacion'))THEN                
               v_filtro = 'toc.id_tipo_obligacion = '||v_parametros.id_tipo_obligacion;
            END IF;
            
            --Sentencia de la consulta
            v_consulta:='
                    SELECT
                        ''detalle_tipo_obli_colum''::varchar as tipo_reg,
                        toc.codigo_columna as codigo,
                        tio.codigo as codigo_tipo_obligacion,
                        tpla.codigo as codigo_tipo_planilla,
                        toc.pago,
                        toc.presupuesto,
                        toc.es_ultimo,
                        toc.estado_reg
                      FROM plani.ttipo_obligacion_columna toc
                      left join plani.ttipo_obligacion tio on tio.id_tipo_obligacion = toc.id_tipo_obligacion
                      left join plani.ttipo_planilla tpla on tpla.id_tipo_planilla = tio.id_tipo_planilla
                      WHERE '||v_filtro;
                v_consulta = v_consulta||' Order By tio.codigo,toc.codigo_columna ASC';
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