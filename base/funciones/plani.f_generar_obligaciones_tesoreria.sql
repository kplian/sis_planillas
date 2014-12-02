CREATE OR REPLACE FUNCTION plani.f_generar_obligaciones_tesoreria (
  p_administrador integer,
  p_id_planilla integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_nombre_usuario_ai varchar,
  p_id_proceso_wf integer,
  p_id_estado_wf integer,
  p_id_depto_tes integer
)
RETURNS boolean AS
$body$
DECLARE
  	v_planilla						record;
  	v_resp		            		varchar;
	v_nombre_funcion        		text;
	v_mensaje_error         		text;
    v_id_funcionario_responsable	integer;
    v_codigo_tipo_pro				varchar;
    v_codigo_llave					varchar;
    v_id_proceso_wf					integer;
    v_id_estado_wf					integer;
    v_codigo_estado					varchar;
    v_id_subsistema					integer;
    v_id_moneda						integer;
    v_id_funcionario				integer;
    v_id_obligacion_pago			integer;
    v_id_obligacion_det 			integer;
    v_codigo_tipo_cuenta			varchar;
    v_registros						record;
    v_id_partida					integer;
	v_id_cuenta						integer; 
    v_id_auxiliar					integer;
    v_hstore_pp						hstore;
    v_total_presu					numeric;
    v_id_plantilla					integer;
    v_id_plan_pago_dev				integer;
    v_id_plan_pago_pag				integer;
    v_prorrateos					record;
    v_id_concepto_ingas				integer;
    
    v_id_estado_registro			integer;
    v_id_tipo_estado_registro		integer;
    
BEGIN
	v_nombre_funcion = 'plani.f_generar_obligaciones_tesoreria';
    
    select p.*,tp.nombre as tipo_planilla,per.fecha_fin as fecha_planilla
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    inner join param.tperiodo per on per.id_periodo = p.id_periodo
    where id_planilla = p_id_planilla;
    
    
    
    --get id_funcionario responsable
    
    select e.id_funcionario into v_id_funcionario
    from wf.testado_wf e
    where id_estado_wf = v_planilla.id_estado_wf;
    
    --get id_subsistema
    select id_subsistema into v_id_subsistema
    from segu.tsubsistema s
    where  s.codigo = 'PLANI'; 
    
    --get id_moneda base
    select param.f_get_moneda_base() into v_id_moneda;   
   
     
     --Inserta la obligacion en el ultimo estado
     INSERT INTO 
              tes.tobligacion_pago
            (
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              --id_proveedor,
              id_subsistema,
              id_moneda,
              id_depto,
              tipo_obligacion,
              fecha,
              numero,
              tipo_cambio_conv,
              num_tramite,
              id_gestion,
              comprometido,
              --id_categoria_compra,
              --tipo_solicitud,
              --tipo_concepto_solicitud,
              id_funcionario
            ) 
            VALUES (
              p_id_usuario,
              now(),
              'activo',
              --v_id_proveedor,
              v_id_subsistema,
              v_id_moneda,
             p_id_depto_tes,    ------------------ojo
              'rrhh',
              now(),
              v_planilla.nro_planilla,
              1,
              v_planilla.nro_planilla,
              v_planilla.id_gestion,
              'no',
              --v_id_categoria_compra,
              --v_tipo,
              --v_tipo_concepto,
              v_id_funcionario
              
            ) RETURNING id_obligacion_pago into v_id_obligacion_pago;
            
     --actualizar el id_obligacion pago en la planilla
     update plani.tplanilla
     set id_obligacion_pago = v_id_obligacion_pago
     where id_planilla = p_id_planilla;
     
     --obtener el concepto generico
     select c.id_concepto_ingas into v_id_concepto_ingas
     from param.tconcepto_ingas c
     where c.desc_ingas like 'PLANILLA DE SUELDOS';
     
     if (v_id_concepto_ingas is null) then
     	raise exception 'Debe crear un concepto generico "Planilla de Sueldos"';
     end if;
     
     --Inserta obligaciones_det
     FOR v_registros in (
              select 
                cc.id_consolidado_columna,
                cc.codigo_columna,
                cc.valor_ejecutado,
                c.id_presupuesto,
                tc.nombre || ' Tipo contrato : '||cc.tipo_contrato as nombre,
                cc.tipo_contrato,
                tc.id_tipo_columna,
                c.id_presupuesto
              from plani.tconsolidado c
              inner join plani.tconsolidado_columna cc on cc.id_consolidado = c.id_consolidado
              inner join plani.ttipo_columna tc on cc.id_tipo_columna = tc.id_tipo_columna
              where c.id_planilla = p_id_planilla 
                    and cc.estado_reg='activo'
              
            )LOOP
            	if (v_registros.tipo_contrato = 'PLA') then
                	v_codigo_tipo_cuenta = 'CUETIPCOLPLA';
                else
                	v_codigo_tipo_cuenta = 'CUETIPCOLEVE';
                end if;
            	if (v_registros.valor_ejecutado > 0) then
                    --obtener los datos de partida, cuenta y auxiliar para el detalle
                    SELECT 
                      ps_id_partida ,
                      ps_id_cuenta,
                      ps_id_auxiliar
                    into 
                      v_id_partida,
                      v_id_cuenta, 
                      v_id_auxiliar
                    FROM conta.f_get_config_relacion_contable(v_codigo_tipo_cuenta, v_planilla.id_gestion, v_registros.id_tipo_columna, 399 /* cambiar esto v_registros.id_presupuesto*/);
                 
                           INSERT INTO 
                            tes.tobligacion_det
                          (
                            id_usuario_reg,
                            fecha_reg,
                            estado_reg,
                            id_obligacion_pago,
                            id_concepto_ingas,
                            id_centro_costo,
                            id_partida,
                            id_cuenta,
                            id_auxiliar,                        
                            monto_pago_mo,
                            monto_pago_mb,
                            descripcion) 
                          VALUES (
                            p_id_usuario,
                            now(),
                            'activo',
                            v_id_obligacion_pago,
                            v_id_concepto_ingas,
                            399,--v_registros.id_presupuesto,
                            v_id_partida,
                            v_id_cuenta,
                            v_id_auxiliar,                        
                            v_registros.valor_ejecutado, 
                            v_registros.valor_ejecutado, 
                            v_registros.nombre
                          )RETURNING id_obligacion_det into v_id_obligacion_det;                
                           
                       update plani.tconsolidado_columna
                       set id_obligacion_det = v_id_obligacion_det
                       where id_consolidado_columna = v_registros.id_consolidado_columna;
                end if;
            END LOOP;
     
     
     --Inserta pago devengado (Global)
     select id_plantilla into v_id_plantilla
     from param.tplantilla p
     where p.desc_plantilla like 'Recibo sin Retenciones';
     --llevar esto tb a la funcion de insercion de plan de pago devengado
     select sum(od.monto_pago_mb) into v_total_presu
     from tes.tobligacion_det od
     where id_obligacion_pago = v_id_obligacion_pago and od.estado_reg = 'activo';
     
     update tes.tobligacion_pago
     set total_pago = v_total_presu
     where id_obligacion_pago = v_id_obligacion_pago;
     /*llevar todo este codigo a otras funciones
     v_hstore_pp =   hstore(ARRAY[
                                  'tipo_pago', 'normal',
                                  'tipo',   'devengado_rrhh',
                                  'tipo_cambio','0'::varchar,
                                  'id_plantilla',v_id_plantilla::varchar,
                                  'id_obligacion_pago',v_id_obligacion_pago::varchar,
                                  'monto_no_pagado','0',
                                  'monto_retgar_mo','0',
                                  'otros_descuentos','0',
                                  'monto_excento','0',
                                  'id_plan_pago_fk',NULL::varchar,
                                  'porc_descuento_ley','0'::varchar,
                                  'obs_descuentos_ley',NULL::varchar,
                                  'obs_otros_descuentos','',
                                  'obs_monto_no_pagado','',
                                  'nombre_pago',v_planilla.tipo_planilla::varchar,
                                  'monto', v_total_presu::varchar,--obtener el total de obligacion_det
                                  'descuento_ley',NULL::varchar,
                                  'fecha_tentativa',v_planilla.fecha_planilla::varchar,
                                  '_id_usuario_ai',p_id_usuario_ai::varchar,
                                  '_nombre_usuario_ai', p_nombre_usuario_ai::varchar
                                 ]);              
                           
      -- llamada para insertar plan de pagos tambien se llena el prorrateo para el devengado
      v_resp = tes.f_inserta_plan_pago_dev(p_administrador, p_id_usuario,v_hstore_pp);
      v_id_plan_pago_dev = pxp.f_recupera_clave(v_resp,'id_plan_pago');
             
     --Inserta pagos de pago(uno por obligacion de la planilla)
     FOR v_registros in (
              select o.id_obligacion,o.acreedor,o.descripcion,o.monto_obligacion                
              from plani.tobligacion o
              inner join plani.ttipo_obligacion tipo on o.id_tipo_obligacion = tipo.id_tipo_obligacion
              where o.id_planilla = p_id_planilla 
                    and o.estado_reg='activo' and tipo.es_pagable = 'si'              
            )LOOP
     		
            v_hstore_pp =   hstore(ARRAY[
                                  'tipo_pago', 'normal',
                                  'tipo',   'pagado_rrhh',
                                  'tipo_cambio','0'::varchar,
                                  'id_plantilla',v_id_plantilla::varchar,
                                  'id_obligacion_pago',v_id_obligacion_pago::varchar,
                                  'monto_no_pagado','0',
                                  'monto_retgar_mo','0',
                                  'otros_descuentos','0',
                                  'monto_excento','0',
                                  'id_plan_pago_fk',v_id_plan_pago_dev::varchar,
                                  'porc_descuento_ley','0'::varchar,
                                  'obs_descuentos_ley',NULL::varchar,
                                  'obs_otros_descuentos','',
                                  'obs_monto_no_pagado','',
                                  'nombre_pago',v_registros.acreedor::varchar,
                                  'monto', v_registros.monto_obligacion::varchar,--obtener el total de obligacion_det
                                  'descuento_ley',NULL::varchar,
                                  'fecha_tentativa',v_planilla.fecha_planilla::varchar,
                                  '_id_usuario_ai',p_id_usuario_ai::varchar,
                                  '_nombre_usuario_ai', p_nombre_usuario_ai::varchar
                                 ]); 
              
            v_resp = tes.f_inserta_plan_pago_pago(p_administrador, p_id_usuario,v_hstore_pp);
      		v_id_plan_pago_pag = pxp.f_recupera_clave(v_resp,'id_plan_pago');
            
            update plani.tobligacion 
            	set id_plan_pago = v_id_plan_pago_pag
            where id_obligacion = v_registros.id_obligacion;
            
            --Inserta prorrateo de pago 
            FOR v_prorrateos in (select cc.id_obligacion_det,oc.monto_detalle_obligacion 
            					 from plani.tobligacion_columna oc
                                 inner join plani.tconsolidado_columna cc on cc.id_presupuesto = oc.id_presupuesto
                                 and oc.id_tipo_columna = cc.id_tipo_columna and oc.tipo_contrato = cc.tipo_contrato
                                 where oc.id_obligacion = v_registros.id_obligacion and oc.estado_reg = 'activo' ) LOOP
            	INSERT INTO 
                  tes.tprorrateo
                (
                  id_usuario_reg,
                  fecha_reg,
                  estado_reg,
                  id_plan_pago,
                  id_obligacion_det,
                  monto_ejecutar_mo
                ) 
                VALUES (
                  p_id_usuario,
                  now(),
                  'activo',
                  v_id_plan_pago_pag,
                  v_prorrateos.id_obligacion_det,
                 v_prorrateos.monto_detalle_obligacion                              
                );	
             
            END LOOP;
            
     END LOOP;
     */
     
     --llevar la obligacion de pago al estado de visto bueno de presupuestos
     
     /*Obtener el estado de registro*/
     select te.id_tipo_estado into v_id_tipo_estado_registro
     from wf.ttipo_estado te
     inner join wf.ttipo_proceso tp
     	on te.id_tipo_proceso = tp.id_tipo_proceso
     inner join wf.tproceso_wf p
     	on p.id_tipo_proceso = tp.id_tipo_proceso
     where te.codigo = 'vbpresupuestos' and p.id_proceso_wf = p_id_proceso_wf;
     
     /*Obtener el funcionario responsable para el siguiente estado*/
     select id_funcionario into v_id_funcionario_responsable 
     from wf.f_funcionario_wf_sel(p_id_usuario, v_id_tipo_estado_registro)
     AS (id_funcionario integer,
         desc_funcionario text,
         desc_funcionario_cargo text,
         prioridad integer);
     
     /*Registrar el estado de registro*/
     v_id_estado_registro =  wf.f_registra_estado_wf(v_id_tipo_estado_registro,   --p_id_tipo_estado_siguiente
                                                         v_id_funcionario_responsable, 
                                                         p_id_estado_wf,   --  p_id_estado_wf_anterior
                                                         p_id_proceso_wf,
                                                         p_id_usuario,
                                                         p_id_usuario_ai,
                                                         p_nombre_usuario_ai,
                                                         NULL,
                                                         'Paso de estado automatico por obligacion de rrhh');
     --update id_estado_wf y id_proceso_wf
     update tes.tobligacion_pago set 
     id_estado_wf =v_id_estado_registro,
     id_proceso_wf = p_id_proceso_wf,
     estado = 'vbpresupuestos' 
     where id_obligacion_pago = v_id_obligacion_pago; 
     --recibir el id_depto de tesoreria y actualizarlo
     
     
     
     
    return true;
       
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