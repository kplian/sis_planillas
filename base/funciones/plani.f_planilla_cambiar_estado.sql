CREATE OR REPLACE FUNCTION plani.f_planilla_cambiar_estado (
  p_id_planilla integer,
  p_id_usuario integer,
  p_tipo_estado varchar
)
RETURNS varchar AS
$body$
DECLARE
  	v_planilla				record;
  	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    va_id_tipo_estado_pro 	integer[];
    va_codigo_estado_pro 	varchar[];
    va_disparador_pro 		varchar[];
    va_regla_pro 			varchar[];
    va_prioridad_pro 		integer[];
    v_id_estado_actual		integer;
BEGIN
	v_nombre_funcion = 'plani.f_planilla_cambiar_estado';
    
    select *
    into v_planilla
    from plani.tplanilla
    where id_planilla = p_id_planilla;
   	SELECT 
       ps_id_tipo_estado,
       ps_codigo_estado,
       ps_disparador,
       ps_regla,
       ps_prioridad
    into
      va_id_tipo_estado_pro,
      va_codigo_estado_pro,
      va_disparador_pro,
      va_regla_pro,
      va_prioridad_pro
                      
    FROM wf.f_obtener_estado_wf(v_planilla.id_proceso_wf, v_planilla.id_estado_wf,NULL,p_tipo_estado);        
                    
   	-- registra estado eactual en el WF para la planilla
                   
     v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_pro[1], 
                                                   NULL, --id_funcionario
                                                   v_planilla.id_estado_wf, 
                                                   v_planilla.id_proceso_wf,
                                                   p_id_usuario,
                                                   v_planilla.id_depto);
                     
      --actualiza la planilla
                    
      -- actuliaza el stado en la solictud
       update plani.tplanilla set 
         id_estado_wf =  v_id_estado_actual,
         estado = va_codigo_estado_pro[1],
         id_usuario_mod=p_id_usuario,
         fecha_mod=now()
       where id_planilla = p_id_planilla; 
       
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