--------------- SQL ---------------

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


    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               6 junio de 2013       RAC KPLIAN          Función que se encarga de verificar la integridad del comprobante para posteriormente validarlo
 #1 ETR           24/01/2019            RAC KPLIAN          quita la validacion automatiza del cbte de devengado  
 #7 ETR           16/05/2019            RAC KPLIAN          considerar la eliminacion de comprobantes dividios   
 #38 ETR          10/09/2019            RAC KPLIAN          considerar si el cbte es independiente del flujo WF de planilla 

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
     v_registros_id_cbte 		record;--#7
     v_registros_id_cbte_1 		record;  --#7
     v_registros_id_cbte_2		record;  --#7
     v_sw_cbte     varchar;
     v_plani_cbte_independiente varchar;--#38 
    
BEGIN

	v_nombre_funcion = 'plani.f_conta_eliminacion_comprobante_planilla';
    
    --#38 recupera configuracion de cbte independite SI/NO
    v_plani_cbte_independiente = pxp.f_get_variable_global('plani_cbte_independiente');
    IF v_plani_cbte_independiente = 'NO' THEN   --#38 si la generacion de cbte no es independiente del flujo de planilla, entonces cambiamos el estado wf de la planilla
      
    
          -- 1) con el id_comprobante identificar la planilla
          select 
              pla.*
          into
              v_registros
          from  plani.tplanilla pla      
          where  pla.id_int_comprobante = p_id_int_comprobante; 
        
        
         --2) Validar que tenga una planilla   
        
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
        
        --#7 recuperar el estado de lso comprobante 
        select c.estado_reg, c.id_int_comprobante
        into v_registros_id_cbte_1
        from conta.tint_comprobante c
        where c.id_int_comprobante = v_registros.id_int_comprobante; 
            
        select c.estado_reg, c.id_int_comprobante
        into v_registros_id_cbte_2
        from conta.tint_comprobante c
        where c.id_int_comprobante = v_registros.id_int_comprobante_2;     
         
        -- #7 no podemos eliminar si el otro cbte fue validado
        IF v_registros_id_cbte_1.estado_reg = 'validado' OR v_registros_id_cbte_2.estado_reg = 'validado' THEN
            raise exception 'No puede eliminar,  el cbte paralelo ya fue validado (revise los cbte id:  % y %)',v_registros.id_int_comprobante, v_registros.id_int_comprobante_2 ;
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
            
         -- #1 ETR anula relacion foranea             
         update plani.tconsolidado_columna c set
         id_int_transaccion  = NULL           
         where c.id_int_transaccion in (select id_int_transaccion from conta.tint_transaccion where id_int_comprobante = p_id_int_comprobante );
             
        --#7 revisamos que comprobate quiere eliminar
             
        IF  v_sw_cbte = '1'   THEN           
           update plani.tplanilla p set
             id_int_comprobante = NULL
            where p.id_int_comprobante = p_id_int_comprobante;          
        END IF;
              
              
         IF v_sw_cbte = '2'   THEN           
           update plani.tplanilla p set
             id_int_comprobante_2 = NULL
            where p.id_int_comprobante_2 = p_id_int_comprobante;          
        END IF;
              
        select 
            pla.*
        into
            v_registros_id_cbte
        from  plani.tplanilla pla      
        where  pla.id_planilla = v_registros.id_planilla;
              
        select 
             ew.id_proceso_wf 
          into 
             v_id_proceso_wf
        from wf.testado_wf ew
        where ew.id_estado_wf= v_id_estado_wf_ant;
        
              
        --#7 si los dos comprobante fueron eliminados retrocede el estadode la planilla
         IF v_registros_id_cbte.id_int_comprobante IS NULL  AND v_registros_id_cbte.id_int_comprobante_2 IS NULL  THEN          
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
                      
         END IF;
    
    ELSE
     --#38 si existe relacion con la planilla rompemos la relacion si existe
         
      update plani.tconsolidado_columna c set
         id_int_transaccion  = NULL           
      where c.id_int_transaccion in (select id_int_transaccion from conta.tint_transaccion where id_int_comprobante = p_id_int_comprobante);
      
      update plani.tplanilla p set
        id_int_comprobante_2 = NULL
      where p.id_int_comprobante_2 = p_id_int_comprobante;   
      
      update plani.tplanilla p set
        id_int_comprobante = NULL
      where p.id_int_comprobante = p_id_int_comprobante;
         
         
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