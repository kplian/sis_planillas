CREATE OR REPLACE FUNCTION plani.f_anular_pago_tesoreria (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_nombre_usuario_ai varchar,
  p_id_plan_pago integer
)
RETURNS varchar AS
$body$
DECLARE
  	v_planilla						record;
    v_plan_pago 					record;
  	v_resp		            		varchar;
	v_nombre_funcion        		text;
	v_id_tipo_estado				integer;
    v_id_estado_actual				integer;
    v_id_funcionario				integer;
    v_id_usuario_reg				integer;
    v_id_depto						integer;
    v_codigo_estado					varchar;
    v_id_estado_wf_ant				integer;
    v_secuencia         			integer;
    v_retorno						varchar;
    v_consulta						varchar;
    
    
BEGIN
	v_nombre_funcion = 'plani.f_anular_pago_tesoreria';
    
    
    select pp.*,op.id_depto,op.id_estado_wf as id_estado_obligacion into v_plan_pago
    from tes.tplan_pago pp
    inner join tes.tobligacion_pago op 
    	on op.id_obligacion_pago = pp.id_obligacion_pago
    where id_plan_pago = p_id_plan_pago;
    
    if (v_plan_pago.tipo != 'devengado_rrhh') then
    	return 'exito';
    end if;
    
    select 
    te.id_tipo_estado
   into
    v_id_tipo_estado
   from wf.tproceso_wf pw 
   inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
   inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
   where pw.id_proceso_wf = v_plan_pago.id_proceso_wf;
               
               
   IF v_id_tipo_estado is NULL THEN
               
      raise exception 'El estado anulado para la obligacion de pago no esta parametrizado en el workflow';  
               
   END IF;
              
              
   -- pasamos la obligacion al estado anulado
               
               
           
   v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                               NULL, 
                                               v_plan_pago.id_estado_wf, 
                                               v_plan_pago.id_proceso_wf,
                                               p_id_usuario,
                                               p_id_usuario_ai,
                                               p_nombre_usuario_ai,
                                               v_plan_pago.id_depto,
                                               'Plan de Pago Anulado');
            
            
   update tes.tplan_pago  pp set 
     id_estado_wf =  v_id_estado_actual,
     estado = 'anulado',
     id_usuario_mod=p_id_usuario,
     fecha_mod=now(),
     estado_reg='inactivo',
     id_usuario_ai = p_id_usuario_ai,
     usuario_ai = p_nombre_usuario_ai
    where pp.id_plan_pago  = p_id_plan_pago;
                
    --actulizamos el nro_cuota actual actual en obligacion_pago              
                         
                     
   --elimina los prorrateos
    update  tes.tprorrateo pro  set 
     estado_reg='inactivo'
    where pro.id_plan_pago =  p_id_plan_pago;  
    
             
               
   -- Cambiamos la obligacion de pago al estado anterior   
   v_secuencia:=(nextval('pxp.parametro'));
   
   v_consulta:='create temporary table tt_parametros_'||v_secuencia||'(';
   v_consulta:=v_consulta ||'id_obligacion_pago integer, operacion varchar, obs text, _id_usuario_ai integer, _nombre_usuario_ai varchar) on commit drop'; 
      
   execute(v_consulta);
   v_consulta:='insert into tt_parametros_'||v_secuencia||' values(' || v_plan_pago.id_obligacion_pago || ',''cambiar'',''Cambio de estado automatico por retroceso de plande pago de RRHH'',';
   v_consulta:=v_consulta || coalesce (p_id_usuario_ai::text,'NULL') ||',' || coalesce('''' || p_nombre_usuario_ai || '''','NULL') || ');';
   execute(v_consulta);
   
   v_consulta:='select tes.ft_obligacion_pago_ime(0,'||coalesce(p_id_usuario,0)||',''tt_parametros_'||v_secuencia||''',''TES_ANTEOB_IME'')';
   --primera llamada para llegar a estado registro
   execute v_consulta into v_retorno; 
   --segunda llamada para llegar a estado vbpresupuestos
   execute v_consulta into v_retorno; 
   return 'exito';
       
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