--------------- SQL ---------------

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

     HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               06/06/2013       RAC KPLIANF       Cuando un comprobante de devegado o pago es validado  ->   cambia el estado de la planilla.  
 #7 ETR           20/05/2019       RAC KPLIAN        considerar la validacion  de comprobantes divididos    
 #38              10/09/2019       RAC KPLIAN        considerar si el cbte es independiente del flujo WF de planilla
   

*/
DECLARE

	 v_nombre_funcion   	    text;
	 v_resp				        varchar; 
     v_registros 		        record; 
     v_id_estado_actual         integer; 
     va_id_tipo_estado          integer[];
     va_codigo_estado           varchar[];
     va_disparador              varchar[];
     va_regla                   varchar[]; 
     va_prioridad               integer[]; 
     v_tipo_sol                 varchar; 
     v_nro_cuota                numeric; 
     v_id_proceso_wf            integer;
     v_id_estado_wf             integer;
     v_codigo_estado            varchar;
     v_id_plan_pago             integer;
     v_verficacion              boolean;
     v_verficacion2             varchar[];
     v_id_tipo_estado           integer;
     v_codigo_proceso_llave_wf  varchar;
	 --gonzalo
     v_id_finalidad		        integer;
     v_respuesta_libro_bancos   varchar;
     v_resp_fun_inicio	        boolean;
     v_registros_id_cbte_1 		record;  --#7
     v_registros_id_cbte_2		record;  --#7
     v_sw_cbte                  varchar; --#7
     v_plani_cbte_independiente varchar; --#38
    
BEGIN


  

	v_nombre_funcion = 'plani.f_conta_validacion_comprobante_planilla';
    
    --#38 recupera configuracion de cbte independite SI/NO
    v_plani_cbte_independiente = pxp.f_get_variable_global('plani_cbte_independiente');
    
    IF v_plani_cbte_independiente = 'NO' THEN --#38 si la generacion de cbte no es independiente del flujo de planilla, entonces cambiamos el estado we de la planilla
    
        -- 1) con el id_comprobante identificar la planilla
       
          select 
              pla.*
          into
              v_registros
          from  plani.tplanilla pla      
          where  pla.id_int_comprobante = p_id_int_comprobante;
        
        
        --2) Validar que tenga un plan de pago
         
          IF  v_registros.id_planilla is NULL  THEN  
             select 
                  pla.*
              into
                  v_registros
              from  plani.tplanilla pla      
              where  pla.id_int_comprobante_2 = p_id_int_comprobante;
              
              
              
              IF  v_registros.id_planilla is NULL  THEN
                  raise exception 'El comprobante no esta relacionado con niguna planilla'; 
              ELSE
                v_sw_cbte = '2';        
              END IF; 
         ELSE
           v_sw_cbte = '1'; 
         END IF;     

        
        -----------------------------------------------------------------------------------------------
        ---  cambiar el estado de la cuota si los dos comprobantes estan validados                -----
        -----------------------------------------------------------------------------------------------
        
        select c.estado_reg, c.id_int_comprobante
        into v_registros_id_cbte_1
        from conta.tint_comprobante c
        where c.id_int_comprobante = v_registros.id_int_comprobante; 
            
        select c.estado_reg, c.id_int_comprobante
        into v_registros_id_cbte_2
        from conta.tint_comprobante c
        where c.id_int_comprobante = v_registros.id_int_comprobante_2; 
    
    
    
        IF     (v_registros_id_cbte_1.estado_reg = 'validado' and  v_registros_id_cbte_2.estado_reg = 'validado') 
           OR  (v_registros_id_cbte_1.estado_reg = 'validado' AND v_registros.id_int_comprobante_2 IS NULL) THEN   --#7 add validacion  
              
              
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
                 
       END IF;
   END IF;
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