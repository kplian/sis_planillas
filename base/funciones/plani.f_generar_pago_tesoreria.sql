CREATE OR REPLACE FUNCTION plani.f_generar_pago_tesoreria (
  p_administrador integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_nombre_usuario_ai varchar,
  p_id_obligacion integer,
  p_obs text
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
    v_id_plan_pago_dev				varchar[];
    v_pago_dev						record;
    v_id_tipo_estado_registro		integer;
    v_id_funcionario_responsable	integer;
    v_id_estado_registro			integer;
    
    
BEGIN
	v_nombre_funcion = 'plani.f_generar_pago_tesoreria';
    
    select * into v_obligacion
    from tes.tobligacion_pago
    where id_obligacion_pago = p_id_obligacion;
    
    select p.id_usuario_reg,p.estado_reg,p.id_usuario_ai,p.usuario_ai,
    p.usuario_ai,p.id_planilla,p.id_gestion,p.id_depto,p.id_periodo,p.id_tipo_planilla,
    p.observaciones,p.id_proceso_wf,p.id_estado_wf,p.estado,p.requiere_calculo,
    p.nro_planilla,
    tp.nombre as tipo_planilla,(case when p.fecha_planilla is not null then
    							p.fecha_planilla ELSE
                                per.fecha_fin end) as fecha_planilla
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    inner join param.tperiodo per on per.id_periodo = p.id_periodo
    where p.id_obligacion_pago = p_id_obligacion;
     
  
    --obtener el concepto generico
     select c.id_concepto_ingas into v_id_concepto_ingas
     from param.tconcepto_ingas c
     where c.desc_ingas like 'PLANILLA DE SUELDOS';
     
     --Inserta pago devengado (Global)
     select id_plantilla into v_id_plantilla
     from param.tplantilla p
     where p.desc_plantilla like 'Recibo sin Retenciones';
    
     select sum(od.monto_pago_mb) into v_total_presu
     from tes.tobligacion_det od
     where od.id_obligacion_pago = p_id_obligacion and od.estado_reg = 'activo';
     
     if (v_id_concepto_ingas is null) then
     	raise exception 'Debe crear un concepto generico "Planilla de Sueldos"';
     end if;
    
     v_hstore_pp =   hstore(ARRAY[
                                  'tipo_pago', 'normal',
                                  'tipo',   'devengado_rrhh',
                                  'tipo_cambio','0'::varchar,
                                  'id_plantilla',v_id_plantilla::varchar,
                                  'id_obligacion_pago',p_id_obligacion::varchar,
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
                                  'descuento_ley','0'::varchar,
                                  'fecha_tentativa',v_planilla.fecha_planilla::varchar,
                                  '_id_usuario_ai',p_id_usuario_ai::varchar,
                                  '_nombre_usuario_ai', p_nombre_usuario_ai::varchar
                                 ]);              
                           
      -- llamada para insertar plan de pagos tambien se llena el prorrateo para el devengado
      v_resp = tes.f_inserta_plan_pago_dev(p_administrador, p_id_usuario,v_hstore_pp);
      
      /*Cambiar al siguiente estado del pago*/
      v_id_plan_pago_dev = pxp.f_recupera_clave(v_resp,'id_plan_pago');
      
      select * into v_pago_dev
      from tes.tplan_pago
      where id_plan_pago = v_id_plan_pago_dev[1]::integer;
      
       /*Obtener el estado de registro*/
     select te.id_tipo_estado into v_id_tipo_estado_registro
     from wf.ttipo_estado te
     inner join wf.ttipo_proceso tp
     	on te.id_tipo_proceso = tp.id_tipo_proceso
     inner join wf.tproceso_wf p
     	on p.id_tipo_proceso = tp.id_tipo_proceso
     where te.codigo = 'vbfin' and p.id_proceso_wf = v_pago_dev.id_proceso_wf;
     
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
                                                         v_pago_dev.id_estado_wf,   --  p_id_estado_wf_anterior
                                                         v_pago_dev.id_proceso_wf,
                                                         p_id_usuario,
                                                         p_id_usuario_ai,
                                                         p_nombre_usuario_ai,
                                                         NULL,
                                                         'Paso de estado automatico por pago de rrhh');
     --update id_estado_wf y id_proceso_wf
     update tes.tplan_pago set 
     id_estado_wf =v_id_estado_registro,     
     estado = 'vbfin' 
     where id_plan_pago = v_id_plan_pago_dev[1]::integer;
      
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