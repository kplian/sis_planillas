--------------- SQL ---------------

CREATE OR REPLACE FUNCTION planibk.f_generar_planilla_bk (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_planilla_original integer
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    genera un nuevo backup de la planilal indicada
*  Fecha:   17/10/2014
*
 ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #78              14/11/2019       RAC KPLIAN       Creacion
*/

DECLARE

    v_nombre_funcion           text;
    v_resp                     varchar;
    v_mensaje                  varchar;
    v_planilla                 record;
    v_id_planilla              integer;
    v_funcionario_planilla     record;
    v_id_funcionario_planilla  integer;
    v_columna_valor            record;
    v_obligacion_agrupador     record;
    v_id_obligacion_agrupador  integer;
    v_obligacion               record;
    v_id_obligacion            integer;
    v_consolidado              record;
    v_id_consolidado           integer;
    v_consolidado_columna      record;
    v_detalle_transferencia    record;



BEGIN

     v_nombre_funcion = 'planibk.f_generar_planilla_bk';
     
     select 
     *
     into 
       v_planilla
     from plani.tplanilla p
     where p.id_planilla = p_id_planilla_original;
     
     ---------------------------------
     --  Copia tabla planilla
     -----------------------------------
    
     INSERT INTO planibk.tplanilla
                  (
                    id_usuario_reg,
                    id_usuario_mod,
                    fecha_reg,
                    fecha_mod,
                    estado_reg,
                    id_usuario_ai,
                    usuario_ai,                   
                    id_planilla_original,
                    fecha_backup,
                    id_gestion,
                    id_depto,
                    id_periodo,
                    nro_planilla,
                    id_uo,
                    id_tipo_planilla,
                    observaciones,
                    id_proceso_macro,
                    id_proceso_wf,
                    id_estado_wf,
                    estado,
                    id_obligacion_pago,
                    requiere_calculo,
                    fecha_planilla,
                    id_int_comprobante,
                    codigo_poa,
                    obs_poa,
                    dividir_comprobante,
                    id_tipo_contrato,
                    id_int_comprobante_2,
                    calcular_reintegro_rciva,
                    calcular_prima_rciva
                  )
                  VALUES (
                    p_id_usuario,
                    v_planilla.id_usuario_mod,
                    v_planilla.fecha_reg,
                    v_planilla.fecha_mod,
                    v_planilla.estado_reg,
                    p_id_usuario_ai,
                    p_usuario_ai,                   
                    p_id_planilla_original,  --id_planilla_original
                    now()::date, --fecha_backup,
                    v_planilla.id_gestion,
                    v_planilla.id_depto,
                    v_planilla.id_periodo,
                    v_planilla.nro_planilla,
                    v_planilla.id_uo,
                    v_planilla.id_tipo_planilla,
                    v_planilla.observaciones,
                    v_planilla.id_proceso_macro,
                    v_planilla.id_proceso_wf,
                    v_planilla.id_estado_wf,
                    v_planilla.estado,
                    v_planilla.id_obligacion_pago,
                    v_planilla.requiere_calculo,
                    v_planilla.fecha_planilla,
                    v_planilla.id_int_comprobante,
                    v_planilla.codigo_poa,
                    v_planilla.obs_poa,
                    v_planilla.dividir_comprobante,
                    v_planilla.id_tipo_contrato,
                    v_planilla.id_int_comprobante_2,
                    v_planilla.calcular_reintegro_rciva,
                    v_planilla.calcular_prima_rciva
                  )RETURNING id_planilla into v_id_planilla;
     
     ----------------------------------------------------
     --  Copia tabla funcio plani.tfuncionario_planilla
     ----------------------------------------------------
     
     FOR v_funcionario_planilla IN (
                                    SELECT * 
                                    FROM plani.tfuncionario_planilla fp
                                    WHERE fp.id_planilla = p_id_planilla_original
                                 ) LOOP
         
         INSERT INTO 
                  planibk.tfuncionario_planilla
                (
                  id_usuario_reg,
                  id_usuario_mod,
                  fecha_reg,
                  fecha_mod,
                  estado_reg,
                  id_usuario_ai,
                  usuario_ai,
                  id_funcionario,
                  id_planilla,
                  id_uo_funcionario,
                  id_lugar,
                  forzar_cheque,
                  finiquito,
                  id_afp,
                  id_cuenta_bancaria,
                  tipo_contrato
                )
                VALUES (
                  v_funcionario_planilla.id_usuario_reg,
                  v_funcionario_planilla.id_usuario_mod,
                  v_funcionario_planilla.fecha_reg,
                  v_funcionario_planilla.fecha_mod,
                  v_funcionario_planilla.estado_reg,
                  v_funcionario_planilla.id_usuario_ai,
                  v_funcionario_planilla.usuario_ai,
                  v_funcionario_planilla.id_funcionario,
                  v_id_planilla,
                  v_funcionario_planilla.id_uo_funcionario,
                  v_funcionario_planilla.id_lugar,
                  v_funcionario_planilla.forzar_cheque,
                  v_funcionario_planilla.finiquito,
                  v_funcionario_planilla.id_afp,
                  v_funcionario_planilla.id_cuenta_bancaria,
                  v_funcionario_planilla.tipo_contrato
                )RETURNING id_funcionario_planilla into v_id_funcionario_planilla;
                
              -----------------------------------------
              --  copiar tabla  plani.tcolumna_valor
              -----------------------------------------
              
               FOR v_columna_valor IN (
                                    SELECT * 
                                    FROM plani.tcolumna_valor cv
                                    WHERE cv.id_funcionario_planilla = v_funcionario_planilla.id_funcionario_planilla
                                 ) LOOP
              
                  INSERT INTO 
                    planibk.tcolumna_valor
                  (
                    id_usuario_reg,
                    id_usuario_mod,
                    fecha_reg,
                    fecha_mod,
                    estado_reg,
                    id_usuario_ai,
                    usuario_ai,               
                    id_tipo_columna,
                    id_funcionario_planilla,
                    codigo_columna,
                    formula,
                    valor,
                    valor_generado
                  )
                  VALUES (
                    v_columna_valor.id_usuario_reg,
                    v_columna_valor.id_usuario_mod,
                    v_columna_valor.fecha_reg,
                    v_columna_valor.fecha_mod,
                    v_columna_valor.estado_reg,
                    v_columna_valor.id_usuario_ai,
                    v_columna_valor.usuario_ai,                
                    v_columna_valor.id_tipo_columna,
                    v_id_funcionario_planilla,
                    v_columna_valor.codigo_columna,
                    v_columna_valor.formula,
                    v_columna_valor.valor,
                    v_columna_valor.valor_generado
                  );  
              
              END LOOP;
                
                
      END LOOP;
      
     --------------------------------------------
     -- copia tabla plani.tobligacion_agrupador
     --------------------------------------------
     
      FOR v_obligacion_agrupador IN (
                                    SELECT * 
                                    FROM plani.tobligacion_agrupador oa
                                    WHERE oa.id_planilla = p_id_planilla_original
                                 ) LOOP 

           INSERT INTO 
                planibk.tobligacion_agrupador
              (
                id_usuario_reg,
                id_usuario_mod,
                fecha_reg,
                fecha_mod,
                estado_reg,
                id_usuario_ai,
                usuario_ai,         
                id_tipo_obligacion_agrupador,
                id_planilla,
                monto_agrupador,
                acreedor,
                descripcion,
                tipo_pago,
                id_int_comprobante,
                obs_cbte,
                id_afp
              )
              VALUES (
                v_obligacion_agrupador.id_usuario_reg,
                v_obligacion_agrupador.id_usuario_mod,
                v_obligacion_agrupador.fecha_reg,
                v_obligacion_agrupador.fecha_mod,
                v_obligacion_agrupador.estado_reg,
                v_obligacion_agrupador.id_usuario_ai,
                v_obligacion_agrupador.usuario_ai,         
                v_obligacion_agrupador.id_tipo_obligacion_agrupador,
                v_id_planilla,
                v_obligacion_agrupador.monto_agrupador,
                v_obligacion_agrupador.acreedor,
                v_obligacion_agrupador.descripcion,
                v_obligacion_agrupador.tipo_pago,
                v_obligacion_agrupador.id_int_comprobante,
                v_obligacion_agrupador.obs_cbte,
                v_obligacion_agrupador.id_afp
              )RETURNING id_obligacion_agrupador into  v_id_obligacion_agrupador;
              
              --------------------------------------------------
              -- copia tabla plani.tobligacion por agrupador
              --------------------------------------------------
              
               FOR v_obligacion IN (
                                    SELECT * 
                                    FROM plani.tobligacion o
                                    WHERE o.id_obligacion_agrupador = v_obligacion_agrupador.id_obligacion_agrupador
                                 ) LOOP 
              
                  INSERT INTO 
                      planibk.tobligacion
                    (
                      id_usuario_reg,
                      id_usuario_mod,
                      fecha_reg,
                      fecha_mod,
                      estado_reg,
                      id_usuario_ai,
                      usuario_ai,                
                      id_tipo_obligacion,
                      id_planilla,
                      id_cuenta,
                      id_auxiliar,
                      tipo_pago,
                      acreedor,
                      descripcion,
                      monto_obligacion,
                      id_plan_pago,
                      id_partida,
                      id_afp,
                      id_obligacion_pago,
                      id_int_comprobante,
                      id_obligacion_agrupador,
                      id_funcionario,
                      id_cuenta_haber,
                      id_partida_haber,
                      id_auxiliar_haber,
                      obs_cbte
                    )
                    VALUES (
                      v_obligacion.id_usuario_reg,
                      v_obligacion.id_usuario_mod,
                      v_obligacion.fecha_reg,
                      v_obligacion.fecha_mod,
                      v_obligacion.estado_reg,
                      v_obligacion.id_usuario_ai,
                      v_obligacion.usuario_ai,                 
                      v_obligacion.id_tipo_obligacion,
                      v_id_planilla,
                      v_obligacion.id_cuenta,
                      v_obligacion.id_auxiliar,
                      v_obligacion.tipo_pago,
                      v_obligacion.acreedor,
                      v_obligacion.descripcion,
                      v_obligacion.monto_obligacion,
                      v_obligacion.id_plan_pago,
                      v_obligacion.id_partida,
                      v_obligacion.id_afp,
                      v_obligacion.id_obligacion_pago,
                      v_obligacion.id_int_comprobante,
                      v_id_obligacion_agrupador,
                      v_obligacion.id_funcionario,
                      v_obligacion.id_cuenta_haber,
                      v_obligacion.id_partida_haber,
                      v_obligacion.id_auxiliar_haber,
                      v_obligacion.obs_cbte
                    ) RETURNING  id_obligacion into  v_id_obligacion;
                    
                    ---------------------------------------------------------------------------------
                    -- copia la talba planibk.tdetalle_transferencia para obligaciones con agrupador
                    ---------------------------------------------------------------------------------
                    
                    FOR v_detalle_transferencia IN (
                           SELECT *
                           FROM plani.tdetalle_transferencia dt
                           WHERE dt.id_obligacion = v_obligacion.id_obligacion
                    ) LOOP
                    
                         INSERT INTO 
                                planibk.tdetalle_transferencia
                              (
                                id_usuario_reg,
                                id_usuario_mod,
                                fecha_reg,
                                fecha_mod,
                                estado_reg,
                                id_usuario_ai,
                                usuario_ai,                                
                                id_obligacion,
                                id_institucion,
                                nro_cuenta,
                                id_funcionario,
                                monto_transferencia
                              )
                              VALUES (
                                v_detalle_transferencia.id_usuario_reg,
                                v_detalle_transferencia.id_usuario_mod,
                                v_detalle_transferencia.fecha_reg,
                                v_detalle_transferencia.fecha_mod,
                                v_detalle_transferencia.estado_reg,
                                v_detalle_transferencia.id_usuario_ai,
                                v_detalle_transferencia.usuario_ai,                                
                                v_id_obligacion,
                                v_detalle_transferencia.id_institucion,
                                v_detalle_transferencia.nro_cuenta,
                                v_detalle_transferencia.id_funcionario,
                                v_detalle_transferencia.monto_transferencia
                              );
                    
                    END LOOP;
                    
               END LOOP;
              
      END LOOP;
      
     --------------------------------------------------
     -- copia tabla plani.tobligacion SIN agrupador
     --------------------------------------------------
     
    FOR v_obligacion IN (
                          SELECT * 
                          FROM plani.tobligacion o
                          WHERE     o.id_obligacion_agrupador IS NULL 
                                AND o.id_planilla = p_id_planilla_original
                       ) LOOP 
              
        INSERT INTO 
            planibk.tobligacion
          (
            id_usuario_reg,
            id_usuario_mod,
            fecha_reg,
            fecha_mod,
            estado_reg,
            id_usuario_ai,
            usuario_ai,                
            id_tipo_obligacion,
            id_planilla,
            id_cuenta,
            id_auxiliar,
            tipo_pago,
            acreedor,
            descripcion,
            monto_obligacion,
            id_plan_pago,
            id_partida,
            id_afp,
            id_obligacion_pago,
            id_int_comprobante,
            id_funcionario,
            id_cuenta_haber,
            id_partida_haber,
            id_auxiliar_haber,
            obs_cbte
          )
          VALUES (
            v_obligacion.id_usuario_reg,
            v_obligacion.id_usuario_mod,
            v_obligacion.fecha_reg,
            v_obligacion.fecha_mod,
            v_obligacion.estado_reg,
            v_obligacion.id_usuario_ai,
            v_obligacion.usuario_ai,                 
            v_obligacion.id_tipo_obligacion,
            v_id_planilla,
            v_obligacion.id_cuenta,
            v_obligacion.id_auxiliar,
            v_obligacion.tipo_pago,
            v_obligacion.acreedor,
            v_obligacion.descripcion,
            v_obligacion.monto_obligacion,
            v_obligacion.id_plan_pago,
            v_obligacion.id_partida,
            v_obligacion.id_afp,
            v_obligacion.id_obligacion_pago,
            v_obligacion.id_int_comprobante,
            v_obligacion.id_funcionario,
            v_obligacion.id_cuenta_haber,
            v_obligacion.id_partida_haber,
            v_obligacion.id_auxiliar_haber,
            v_obligacion.obs_cbte
          ) RETURNING  id_obligacion into  v_id_obligacion;
                    
              ---------------------------------------------------------------------------------
              -- copia la talba planibk.tdetalle_transferencia para obligaciones SIN  agrupador
              ---------------------------------------------------------------------------------
                    
              FOR v_detalle_transferencia IN (
                     SELECT *
                     FROM plani.tdetalle_transferencia dt
                     WHERE dt.id_obligacion = v_obligacion.id_obligacion
              ) LOOP
                    
                   INSERT INTO 
                          planibk.tdetalle_transferencia
                        (
                          id_usuario_reg,
                          id_usuario_mod,
                          fecha_reg,
                          fecha_mod,
                          estado_reg,
                          id_usuario_ai,
                          usuario_ai,                                
                          id_obligacion,
                          id_institucion,
                          nro_cuenta,
                          id_funcionario,
                          monto_transferencia
                        )
                        VALUES (
                          v_detalle_transferencia.id_usuario_reg,
                          v_detalle_transferencia.id_usuario_mod,
                          v_detalle_transferencia.fecha_reg,
                          v_detalle_transferencia.fecha_mod,
                          v_detalle_transferencia.estado_reg,
                          v_detalle_transferencia.id_usuario_ai,
                          v_detalle_transferencia.usuario_ai,                                
                          v_id_obligacion,
                          v_detalle_transferencia.id_institucion,
                          v_detalle_transferencia.nro_cuenta,
                          v_detalle_transferencia.id_funcionario,
                          v_detalle_transferencia.monto_transferencia
                        );
                    
              END LOOP;
     END LOOP;
     
     ---------------------------------------------------
     -- Copia tabla plani.tconsolidado
     --------------------------------------------------
     
     FOR v_consolidado IN (
                          SELECT * 
                          FROM plani.tconsolidado c
                          WHERE c.id_planilla = p_id_planilla_original
                       ) LOOP
     
          INSERT INTO 
            planibk.tconsolidado
          (
            id_usuario_reg,
            id_usuario_mod,
            fecha_reg,
            fecha_mod,
            estado_reg,
            id_usuario_ai,
            usuario_ai,           
            id_planilla,
            id_presupuesto,
            id_cc,
            tipo_consolidado
          )
          VALUES (
            v_consolidado.id_usuario_reg,
            v_consolidado.id_usuario_mod,
            v_consolidado.fecha_reg,
            v_consolidado.fecha_mod,
            v_consolidado.estado_reg,
            v_consolidado.id_usuario_ai,
            v_consolidado.usuario_ai,           
            v_id_planilla,
            v_consolidado.id_presupuesto,
            v_consolidado.id_cc,
            v_consolidado.tipo_consolidado
          )RETURNING id_consolidado into v_id_consolidado;
          
          
          ------------------------------------------------
          -- copia  la tabla  plani.tconsolidado_columna
          ----------------------------------------------
          
          FOR v_consolidado_columna IN (
                          SELECT * 
                          FROM plani.tconsolidado_columna con
                          WHERE con.id_consolidado = v_consolidado.id_consolidado
                       ) LOOP
          
              INSERT INTO 
                    planibk.tconsolidado_columna
                  (
                    id_usuario_reg,
                    id_usuario_mod,
                    fecha_reg,
                    fecha_mod,
                    estado_reg,
                    id_usuario_ai,
                    usuario_ai,
                   
                    id_consolidado,
                    id_tipo_columna,
                    codigo_columna,
                    valor,
                    valor_ejecutado,
                    id_partida,
                    id_cuenta,
                    id_auxiliar,
                    tipo_contrato,
                    id_obligacion_det,
                    id_int_transaccion
                  )
                  VALUES (
                    v_consolidado_columna.id_usuario_reg,
                    v_consolidado_columna.id_usuario_mod,
                    v_consolidado_columna.fecha_reg,
                    v_consolidado_columna.fecha_mod,
                    v_consolidado_columna.estado_reg,
                    v_consolidado_columna.id_usuario_ai,
                    v_consolidado_columna.usuario_ai,
                    v_id_consolidado,
                    v_consolidado_columna.id_tipo_columna,
                    v_consolidado_columna.codigo_columna,
                    v_consolidado_columna.valor,
                    v_consolidado_columna.valor_ejecutado,
                    v_consolidado_columna.id_partida,
                    v_consolidado_columna.id_cuenta,
                    v_consolidado_columna.id_auxiliar,
                    v_consolidado_columna.tipo_contrato,
                    v_consolidado_columna.id_obligacion_det,
                    v_consolidado_columna.id_int_transaccion
                  );
          END LOOP;
     
     END LOOP;
          
     RETURN TRUE;
          
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