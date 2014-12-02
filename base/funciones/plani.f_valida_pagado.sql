CREATE OR REPLACE FUNCTION plani.f_valida_pagado (
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
    v_estado_destino				varchar;
    
    
BEGIN
	v_nombre_funcion = 'plani.f_valida_pagado';
    
    select op.* into v_obligacion
    from tes.tobligacion_pago op
    inner join tes.tplan_pago pp on pp.id_obligacion_pago = op.id_obligacion_pago
    where pp.id_plan_pago = p_id_plan_pago;
    
    select p.*,tp.nombre as tipo_planilla,per.fecha_fin as fecha_planilla
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    inner join param.tperiodo per on per.id_periodo = p.id_periodo
    where p.id_obligacion_pago = v_obligacion.id_obligacion_pago;
    
    if exists(select 1 from segu.tusuario_rol ur where id_usuario=p_id_usuario and id_rol=1 and estado_reg='activo')then
    	v_administrador = 1;
    end if;
    
    if exists (	select 1 
    			from tes.tplan_pago 
                where estado not in ('devengado','pagado') and 
                	id_obligacion_pago = v_obligacion.id_obligacion_pago ) and 
                    v_planilla.estado = 'comprobante_presupuestario_validado' then
    	v_estado_destino = 'comprobante_obligaciones';
    elsif v_planilla.estado = 'comprobante_obligaciones' then
    	v_estado_destino = 'planilla_finalizada';
    ELSE
    	v_estado_destino = 'ninguno';
    end if;
    
     if (v_estado_destino != 'ninguno') then
          --Obtener el estado de registro
         select te.id_tipo_estado into v_id_tipo_estado_registro
         from wf.ttipo_estado te
         inner join wf.ttipo_proceso tp
            on te.id_tipo_proceso = tp.id_tipo_proceso
         inner join wf.tproceso_wf p
            on p.id_tipo_proceso = tp.id_tipo_proceso
         where te.codigo = v_estado_destino and p.id_proceso_wf = v_planilla.id_proceso_wf;
        
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
         estado = v_estado_destino 
         where id_planilla = v_planilla.id_planilla;
     end if;
      
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