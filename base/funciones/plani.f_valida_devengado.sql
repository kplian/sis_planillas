CREATE OR REPLACE FUNCTION plani.f_valida_devengado (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_nombre_usuario_ai varchar,
  p_id_plan_pago integer
)
RETURNS boolean AS
$body$
DECLARE
  	v_planilla						record;
    v_obligacion					record;
  	v_resp		            		varchar;
	v_nombre_funcion        		text;
	v_id_tipo_estado				integer;
    v_id_estado_actual				integer;
    v_id_funcionario				integer;
    v_id_usuario_reg				integer;
    v_id_depto						integer;
    v_codigo_estado					varchar;
    v_id_estado_wf_ant				integer;
    v_id_concepto_ingas				integer;
    v_total_presu					numeric;
    v_id_plantilla					integer;
    v_hstore_pp						hstore;
    v_id_plan_pago_dev				integer;
    v_pago_dev						record;
    v_id_tipo_estado_registro		integer;
    v_id_funcionario_responsable	integer;
    v_id_estado_registro			integer;
    v_registros						record;
    v_id_plan_pago_pag				varchar[];
    v_prorrateos					record;
    v_administrador					integer;
    v_nombre_pago					varchar;
    v_forma_pago					varchar;
    v_resp_fin						varchar;
    
    
BEGIN
	v_nombre_funcion = 'plani.f_valida_devengado';
    
    select op.*,tp.codigo_plantilla_comprobante into v_obligacion
    from tes.tobligacion_pago op
    inner join tes.tplan_pago pp on pp.id_obligacion_pago = op.id_obligacion_pago
    inner join tes.ttipo_plan_pago tp on tp.codigo = pp.tipo
    where pp.id_plan_pago = p_id_plan_pago;
    
    select (case when p.fecha_planilla is not null then
    							p.fecha_planilla ELSE
                                per.fecha_fin end) as fecha_planilla, p.*,tp.nombre as tipo_planilla
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    left join param.tperiodo per on per.id_periodo = p.id_periodo
    where p.id_obligacion_pago = v_obligacion.id_obligacion_pago;
    
    if exists(select 1 from segu.tusuario_rol ur where id_usuario=p_id_usuario and id_rol=1 and estado_reg='activo')then
    	v_administrador = 1;
    end if;
    if (v_obligacion.codigo_plantilla_comprobante != 'DEVPAGRRHH') then
    	v_codigo_estado = 'comprobante_presupuestario_validado';
       --Inserta pagos de pago(uno por tipo de obligacion de la planilla)
         FOR v_registros in (
                  select /*o.id_obligacion,o.acreedor,o.descripcion,o.monto_obligacion, */tipo.nombre ,pxp.aggarray(o.id_obligacion) as obligaciones,
                  tipo.id_tipo_obligacion,sum(o.monto_obligacion) as monto_obligacion,o.id_afp,o.tipo_pago           
                  from plani.tobligacion o
                  inner join plani.ttipo_obligacion tipo on o.id_tipo_obligacion = tipo.id_tipo_obligacion
                  where o.id_planilla = v_planilla.id_planilla 
                        and o.estado_reg='activo' and tipo.es_pagable = 'si' 
                  group by tipo.nombre ,tipo.id_tipo_obligacion,o.id_afp,o.tipo_pago                 
                )LOOP
                    if (v_registros.id_afp is not null) then
                        select nombre into v_nombre_pago 
                        from plani.tafp 
                        where id_afp = v_registros.id_afp;
                        v_nombre_pago = v_registros.nombre || '   ' || v_nombre_pago;
                    else
                        if (v_registros.tipo_pago != 'cheque') then
                            v_nombre_pago = v_registros.nombre || '    TRANSFERENCIAS';
                        else
                            v_nombre_pago = v_registros.nombre;
                        end if;
                    end if;	
                    
                    if (v_registros.tipo_pago = 'cheque') then
                        v_forma_pago = 'cheque';
                    else 
                        v_forma_pago = 'transferencia';
                    end if;
                    v_hstore_pp =   hstore(ARRAY[
                                      'forma_pago',v_forma_pago,
                                      'tipo_pago', 'normal',
                                      'tipo',   'pagado_rrhh',
                                      'tipo_cambio','0'::varchar,
                                      'id_plantilla',v_id_plantilla::varchar,
                                      'id_obligacion_pago',v_obligacion.id_obligacion_pago::varchar,
                                      'monto_no_pagado','0',
                                      'monto_retgar_mo','0',
                                      'otros_descuentos','0',                                  
                                      'monto_excento','0',
                                      'id_plan_pago_fk',p_id_plan_pago::varchar,
                                      'porc_descuento_ley','0'::varchar,
                                      'descuento_anticipo','0'::varchar,
                                      'descuento_ley','0'::varchar,
                                      'descuento_inter_serv','0'::varchar,
                                      'monto_ajuste_ag' ,'0'::varchar,
                                      'obs_descuentos_ley',NULL::varchar,
                                      'obs_otros_descuentos','',
                                      'obs_monto_no_pagado',''::varchar,
                                      'nombre_pago',v_nombre_pago::varchar,
                                      'monto', v_registros.monto_obligacion::varchar,--obtener el total de obligacion_det
                                      'descuento_ley',NULL::varchar,
                                      'fecha_tentativa',v_planilla.fecha_planilla::varchar,
                                      '_id_usuario_ai',p_id_usuario_ai::varchar,
                                      '_nombre_usuario_ai', p_nombre_usuario_ai::varchar
                                     ]); 
                  
                v_resp = tes.f_inserta_plan_pago_pago(v_administrador, p_id_usuario,v_hstore_pp);
          		
                v_id_plan_pago_pag = pxp.f_recupera_clave(v_resp,'id_plan_pago');
                
                update plani.tobligacion set
                    id_plan_pago = v_id_plan_pago_pag[1]::integer
                where id_obligacion = ANY(v_registros.obligaciones);
                
                update tes.tplan_pago set
                    total_prorrateado = v_registros.monto_obligacion
                where id_plan_pago = v_id_plan_pago_pag[1]::integer;
                
                --Inserta prorrateo de pago 
                FOR v_prorrateos in (select cc.id_obligacion_det,p.id_prorrateo,p.id_int_transaccion,sum(oc.monto_detalle_obligacion) as  monto_detalle_obligacion
                                     from plani.tobligacion_columna oc
                                     inner join plani.tobligacion ob on ob.id_obligacion = oc.id_obligacion  
                                     inner join plani.tconsolidado con on con.id_presupuesto = oc.id_presupuesto 
                                        and con.id_planilla = v_planilla.id_planilla                               
                                     inner join plani.tconsolidado_columna cc on cc.id_consolidado = con.id_consolidado
                                     and oc.id_tipo_columna = cc.id_tipo_columna and oc.tipo_contrato = cc.tipo_contrato
                                     inner join tes.tprorrateo p on p.id_obligacion_det = cc.id_obligacion_det and p.id_plan_pago = p_id_plan_pago
                                     where ob.id_obligacion = ANY(v_registros.obligaciones) and oc.estado_reg = 'activo' and 
                                            oc.monto_detalle_obligacion > 0 
                                     group by cc.id_obligacion_det,p.id_prorrateo,p.id_int_transaccion) LOOP
                    INSERT INTO 
                      tes.tprorrateo
                    (
                      id_usuario_reg,
                      fecha_reg,
                      estado_reg,
                      id_plan_pago,
                      id_obligacion_det,
                      monto_ejecutar_mo,
                      id_prorrateo_fk,
                      id_int_transaccion
                    ) 
                    VALUES (
                      p_id_usuario,
                      now(),
                      'activo',
                      v_id_plan_pago_pag[1]::integer,
                      v_prorrateos.id_obligacion_det,
                     v_prorrateos.monto_detalle_obligacion,
                     v_prorrateos.id_prorrateo,
                     v_prorrateos.id_int_transaccion                             
                    );	
                 
                END LOOP;
                
         END LOOP;
     else
     	v_codigo_estado = 'planilla_finalizada';        
        --v_resp_fin = tes.f_finalizar_obligacion_total(v_obligacion.id_obligacion_pago,p_id_usuario,p_id_usuario_ai, p_nombre_usuario_ai);     
     end if;
     
      --Obtener el estado de registro
       select te.id_tipo_estado into v_id_tipo_estado_registro
       from wf.ttipo_estado te
       inner join wf.ttipo_proceso tp
          on te.id_tipo_proceso = tp.id_tipo_proceso
       inner join wf.tproceso_wf p
          on p.id_tipo_proceso = tp.id_tipo_proceso
       where te.codigo = v_codigo_estado and p.id_proceso_wf = v_planilla.id_proceso_wf;
       
       --Obtener el funcionario responsable para el siguiente estado
       select id_funcionario into v_id_funcionario_responsable 
       from wf.f_funcionario_wf_sel(p_id_usuario, v_id_tipo_estado_registro, now()::date,v_planilla.id_estado_wf)
       AS (id_funcionario integer,
           desc_funcionario text,
           desc_funcionario_cargo text,
           prioridad integer);
     
     --Registrar el estado de registro
     v_id_estado_registro =  wf.f_registra_estado_wf(v_id_tipo_estado_registro,   --p_id_tipo_estado_siguiente
                                                         v_id_funcionario_responsable, 
                                                         v_planilla.id_estado_wf,   --  p_id_estado_wf_anterior
                                                         v_planilla.id_proceso_wf,
                                                         p_id_usuario,
                                                         p_id_usuario_ai,
                                                         p_nombre_usuario_ai,
                                                         NULL,
                                                         'Paso de estado automatico por validacion de comprobante de devengado');
     --update id_estado_wf y id_proceso_wf
     update plani.tplanilla set 
     id_estado_wf =v_id_estado_registro,     
     estado = v_codigo_estado
     where id_planilla = v_planilla.id_planilla;
      
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