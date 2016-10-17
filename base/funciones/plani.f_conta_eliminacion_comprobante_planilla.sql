CREATE OR REPLACE FUNCTION plani.f_conta_eliminacion_comprobante_planilla (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

Autor: RAC KPLIANF
Fecha:   6 junio de 2013
Descripcion  Esta funcion retrocede el estado de los planes de pago cuando los comprobantes son eliminados

  

*/


DECLARE
  
	v_nombre_funcion   	text;
	v_resp				varchar;
    
    
    v_registros 		record;
    
    v_id_estado_actual  integer;
    
    
    va_id_tipo_estado integer[];
    va_codigo_estado varchar[];
    va_disparador    varchar[];
    va_regla         varchar[]; 
    va_prioridad     integer[];
    
    v_tipo_sol   varchar;
    
    v_nro_cuota numeric;
    
     v_id_proceso_wf integer;
     v_id_estado_wf integer;
  
     v_id_plan_pago integer;
     v_verficacion  boolean;
     v_verficacion2  varchar[];
     
     
      v_id_tipo_estado integer;
     v_id_funcionario  integer;
     v_id_usuario_reg integer;
     v_id_depto integer;
     v_codigo_estado varchar;
     v_id_estado_wf_ant  integer;
     v_rec_cbte_trans   record;
     v_resp_fun_regreso	boolean;
    
BEGIN

	v_nombre_funcion = 'plani.f_conta_eliminacion_comprobante_planilla';
    
    
    
    -- 1) con el id_comprobante identificar el plan de pago
   
      select 
          pla.*
      into
          v_registros
      from  plani.tplanilla pla      
      where  pla.id_int_comprobante = p_id_int_comprobante; 
    
    
    --2) Validar que tenga una planilla   
    
     IF  v_registros.id_planilla is NULL  THEN     
        raise exception 'El comprobante no esta relacionado con niguna planilla';     
     END IF;    
     
     
     --  recuperaq estado anterior segun Log del WF
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
        FROM wf.f_obtener_estado_ant_log_wf(v_registros.id_estado_wf);
        
        
        
         --
         
          select 
               ew.id_proceso_wf 
            into 
               v_id_proceso_wf
          from wf.testado_wf ew
          where ew.id_estado_wf= v_id_estado_wf_ant;
                      
          -- registra nuevo estado
                      
          v_id_estado_actual = wf.f_registra_estado_wf(
              v_id_tipo_estado, 
              v_id_funcionario, 
              v_registros.id_estado_wf, 
              v_id_proceso_wf, 
              p_id_usuario,
              p_id_usuario_ai,
              p_usuario_ai,
              v_id_depto,
              'Eliminación de comprobante de la Planilla:'|| COALESCE(v_registros.nro_planilla,'NaN'));
                      
         v_resp_fun_regreso = plani.f_fun_regreso_planilla_wf(p_id_usuario,p_id_usuario_ai,p_usuario_ai,v_id_estado_actual,v_id_proceso_wf,v_codigo_estado);       
             
RETURN  TRUE;

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