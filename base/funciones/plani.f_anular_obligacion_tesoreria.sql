CREATE OR REPLACE FUNCTION plani.f_anular_obligacion_tesoreria (
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
    
    
BEGIN
	v_nombre_funcion = 'plani.f_anular_obligacion_tesoreria';
    
    select * into v_obligacion
    from tes.tobligacion_pago
    where id_obligacion_pago = p_id_obligacion;
    
    select 
    te.id_tipo_estado
   into
    v_id_tipo_estado
   from wf.tproceso_wf pw 
   inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
   inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'               
   where pw.id_proceso_wf = v_obligacion.id_proceso_wf;
               
               
   IF v_id_tipo_estado is NULL THEN
               
      raise exception 'El estado anulado para la obligacion de pago no esta parametrizado en el workflow';  
               
   END IF;
              
              
   -- pasamos la obligacion al estado anulado
               
               
           
   v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado, 
                                               NULL, 
                                               v_obligacion.id_estado_wf, 
                                               v_obligacion.id_proceso_wf,
                                               p_id_usuario,
                                               p_id_usuario_ai,
                                               p_nombre_usuario_ai,
                                               v_obligacion.id_depto,
                                               'Obligacion de Pago Anulada');
            
            
   -- actualiza estado en la cotizacion
              
   update tes.tobligacion_pago  op set 
     id_estado_wf =  v_id_estado_actual,
     estado = 'anulado',
     id_usuario_mod=p_id_usuario,
     fecha_mod=now(),
     estado_reg='inactivo',
     id_usuario_ai = p_id_usuario_ai,
     usuario_ai = p_nombre_usuario_ai
   where op.id_obligacion_pago  = p_id_obligacion;
               
               
   --inactiva el datalle de la solicitud
   update tes.tobligacion_det od set  
    estado_reg= 'inactivo',
    id_usuario_mod = p_id_usuario,
    fecha_mod = now(),
    id_usuario_ai = p_id_usuario_ai,
     usuario_ai = p_nombre_usuario_ai
   where  od.id_obligacion_pago = p_id_obligacion;
   
   --retroceder planilla
   --obtener planilla
   select * into v_planilla
   from plani.tplanilla p
   where p.id_obligacion_pago = p_id_obligacion;
   
   SELECT  
         
             ps_id_tipo_estado,
             ps_id_funcionario,
             ps_id_usuario_reg,
             ps_id_depto,
             ps_codigo_estado,
             ps_id_estado_wf_ant
          into
             v_id_tipo_estado,
             v_id_funcionario,
             v_id_usuario_reg,
             v_id_depto,
             v_codigo_estado,
             v_id_estado_wf_ant 
          FROM wf.f_obtener_estado_ant_log_wf(v_planilla.id_estado_wf);
              
                      
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado, 
              v_id_funcionario, 
              v_planilla.id_estado_wf, 
              v_planilla.id_proceso_wf, 
              p_id_usuario,
              p_id_usuario_ai,
              p_nombre_usuario_ai,
              v_id_depto,
              '[RETROCESO] '|| p_obs);
                      
         
          
                         
            IF  not plani.f_fun_regreso_planilla_wf(p_id_usuario, 
                                                   p_id_usuario_ai, 
                                                   p_nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_planilla.id_proceso_wf, 
                                                   v_codigo_estado) THEN
            
               raise exception 'Error al retroceder estado';
            
            END IF; 
   		update plani.tconsolidado_columna
        set id_obligacion_det = NULL
        from plani.tconsolidado con
        where con.id_consolidado = plani.tconsolidado_columna.id_consolidado and 
        con.id_planilla = v_planilla.id_planilla;
        
        update plani.tplanilla
        set id_obligacion_pago = NULL
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