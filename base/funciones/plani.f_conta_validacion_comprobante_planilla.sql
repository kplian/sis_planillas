CREATE OR REPLACE FUNCTION plani.f_conta_validacion_comprobante_planilla (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

Autor: RAC KPLIAN
Fecha:   6 junio de 2013
Descripcion  Esta funcion gestiona los planes de pago de la siguiente manera


    Cuando un comprobante de devegado o pago es validado  ->   cambia el estado de la cuota.

    

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
     v_codigo_estado varchar;
     v_id_plan_pago integer;
     v_verficacion  boolean;
     v_verficacion2  varchar[];
     
     v_id_tipo_estado  integer;
     v_codigo_proceso_llave_wf   varchar;
	 --gonzalo
     v_id_finalidad		integer;
     v_respuesta_libro_bancos varchar;
     v_resp_fun_inicio	boolean;
    
BEGIN


  

	v_nombre_funcion = 'plani.f_conta_validacion_comprobante_planilla';
    
    
    
    -- 1) con el id_comprobante identificar la planilla
   
      select 
          pla.*
      into
          v_registros
      from  plani.tplanilla pla      
      where  pla.id_int_comprobante = p_id_int_comprobante;
    
    
    --2) Validar que tenga un plan de pago
    
    
     IF  v_registros.id_planilla is NULL  THEN     
        raise exception 'El comprobante no esta relacionado con niguna planilla';     
     END IF;      

    
    --------------------------------------------------------
    ---  cambiar el estado de la cuota                 -----
    --------------------------------------------------------
        
        
          -- obtiene el siguiente estado del flujo 
               SELECT 
                   *
                into
                  va_id_tipo_estado,
                  va_codigo_estado,
                  va_disparador,
                  va_regla,
                  va_prioridad
              
              FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'siguiente');
              
              
              --raise exception '--  % ,  % ,% ',v_id_proceso_wf,v_id_estado_wf,va_codigo_estado;
              
              
              IF va_codigo_estado[2] is not null THEN
              
               raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
              
              END IF;
              
               IF va_codigo_estado[1] is  null THEN
              
               raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;           
              END IF;
              
              
            
              
              -- estado siguiente
               v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                             NULL, 
                                                             v_registros.id_estado_wf, 
                                                             v_registros.id_proceso_wf,
                                                             p_id_usuario,
                                                             p_id_usuario_ai, -- id_usuario_ai
                                                             p_usuario_ai, -- usuario_ai
                                                             v_registros.id_depto,
                                                             'Comprobante de planilla nro:'||v_registros.nro_planilla||' fue validado');
              --raise exception 'llega%,%,%',v_id_estado_actual,v_registros.id_proceso_wf,va_codigo_estado[1];
              v_resp_fun_inicio = plani.f_fun_inicio_planilla_wf(p_id_usuario,p_id_usuario_ai,p_usuario_ai,v_id_estado_actual,v_registros.id_proceso_wf,va_codigo_estado[1]);
             
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