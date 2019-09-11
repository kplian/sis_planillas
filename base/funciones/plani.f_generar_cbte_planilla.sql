--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_generar_cbte_planilla (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_planilla integer,
  p_id_obligacion integer,
  p_tipo varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   JRR
*  DESC:    funcion que actualiza los estados despues del registro de un siguiente en planilla
*  Fecha:   17/10/2014
*
 ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #38             10/09/2019        RAC KPLIAN      creacion de cbte de debengado o de pago  independiente al wf de la planilla
*/

DECLARE

    v_nombre_funcion             text;
    v_resp                       varchar;
    v_mensaje                    varchar;
    v_planilla                   record;
    v_registros                  record;
    v_id_gestion                 integer;
    v_id_int_comprobante         integer;
    v_id_int_comprobante_2       integer;
    v_plani_cbte_independiente   varchar;
    v_id_int_comprobante_obli    integer;
    
   



BEGIN

    v_nombre_funcion = 'plani.f_generar_cbte_planilla';
    
     select 
            pla.*, 
            pe.fecha_ini, 
            pe.fecha_fin,
            tp.calculo_horas,
            tp.funcion_calculo_horas, 
            tp.codigo, 
            tp.tipo_presu_cc 
    into v_planilla
    from plani.tplanilla pla
    inner join plani.ttipo_planilla tp
          on tp.id_tipo_planilla = pla.id_tipo_planilla
    left join param.tperiodo pe on pe.id_periodo = pla.id_periodo
    where id_planilla = p_id_planilla;
    
    
    --recupera configuracion
    v_plani_cbte_independiente = pxp.f_get_variable_global('plani_cbte_independiente');
    
    IF v_plani_cbte_independiente = 'NO' THEN
      raise exception 'El sistema no permite los cbtes independiente de WF, revisa la configuracion, de la vriable : plani_cbte_independiente';    
    END IF;
    
    IF v_planilla.estado = 'finalizado' THEN
       raise exception 'solo se permite generar cbte indpendiente en planillas en estado finalizado';
    END IF;
    
    
    IF p_tipo = 'devengado' THEN  --un solo scbte de devengado
    
        select po_id_gestion into  v_id_gestion from param.f_get_periodo_gestion(v_planilla.fecha_planilla);
        
        IF   v_planilla.dividir_comprobante = 'no' THEN
             -- generar comprobante de devengado
             v_id_int_comprobante =   conta.f_gen_comprobante (v_planilla.id_planilla,'DIARIOPLA',v_planilla.id_estado_wf, p_id_usuario, p_id_usuario_ai, p_usuario_ai, NULL, FALSE, v_planilla.nro_planilla);
        ELSE
            
            --si se divide el cbte llama a las planillas  DIARIOPLA_C1 y DIARIOPLA_C2
            v_id_int_comprobante =   conta.f_gen_comprobante (v_planilla.id_planilla,'DIARIOPLA_C1',p_id_estado_wf,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL, FALSE,  v_planilla.nro_planilla);   --Diario Presupeustario
            v_id_int_comprobante_2 =   conta.f_gen_comprobante (v_planilla.id_planilla,'DIARIOPLA_C2',p_id_estado_wf,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL, FALSE, v_planilla.nro_planilla); --Diario contable 
          
        END IF;
        
        update plani.tplanilla  t set               
               id_usuario_mod=p_id_usuario,
               id_usuario_ai = p_id_usuario_ai,
               usuario_ai = p_usuario_ai,
               fecha_mod=now(),
               id_int_comprobante =   v_id_int_comprobante,
               id_int_comprobante_2 = v_id_int_comprobante_2
         where id_planilla = p_id_planilla;
        
    ELSEIF p_tipo = 'pagogrupo' THEN  -- genera todos los cbte de pago de la planolla
    
      IF (pxp.f_get_variable_global('plani_generar_comprobante_obligaciones') = 'si') then
      
             -- generar obligacion de pago sin agrupador
             for v_registros in (    
                                select *
                                  from plani.tobligacion o
                                inner join plani.ttipo_obligacion tipo on o.id_tipo_obligacion = tipo.id_tipo_obligacion
                                where tipo.es_pagable = 'si'
                                    and o.id_planilla = v_planilla.id_planilla --#1
                                    and o.id_obligacion_agrupador is null
                                 ) loop
                                
                       
                v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_obligacion,'PAGOPLA',NULL,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL, FALSE, v_planilla.nro_planilla);
                
               update  plani.tobligacion set
                 id_int_comprobante =  v_id_int_comprobante_obli
               where  id_obligacion =  v_registros.id_obligacion;
                 
                
              end loop;
              
             
             -- generar obligacion de pago con agrupadores  (si no es pagable no tiene sentido que tenga agrupador)
            
              for v_registros in (    
                                   select *
                                   from plani.tobligacion_agrupador oa
                                   where oa.id_planilla = v_planilla.id_planilla --#1                                    
                            ) loop
                               
                  v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_obligacion_agrupador,'PAGOPLAAG',NULL,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL);
                
                 update  plani.tobligacion_agrupador set
                   id_int_comprobante =  v_id_int_comprobante_obli
                 where  id_obligacion_agrupador =  v_registros.id_obligacion_agrupador;
                
              end loop;
      
      
      ELSE
      
        raise exception 'Los cbtes de obligacion no estan autorizados revisase variable:  plani_generar_comprobante_obligaciones'; 
             
      END IF;
    
    ELSEIF p_tipo = 'pago' THEN -- gerar un cbte de pago especifico por id_obligacion_pago
       
       IF (pxp.f_get_variable_global('plani_generar_comprobante_obligaciones') = 'si') then
       
          IF p_id_obligacion IS NULL THEN
             raise exception 'Debe indicar la obligacion que vamos a pagar';
          END IF;
          
          select * 
          into 
          v_registros
          from plani.tobligacion o
          inner join plani.ttipo_obligacion tipo on o.id_tipo_obligacion = tipo.id_tipo_obligacion
          where  o.id_obligacion = p_id_obligacion;
          
          IF v_registros.es_pagable = 'no' THEN
            raise exception 'Esta obligacion esta configurada como no pagable';
          END IF;
          
          IF v_registros.id_obligacion_agrupador is null THEN 
             --  es una obligacion  sin agrupador
             v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_obligacion,'PAGOPLA',NULL,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL, FALSE, v_planilla.nro_planilla);
             
             update  plani.tobligacion set
               id_int_comprobante =  v_id_int_comprobante_obli
             where  id_obligacion =  v_registros.id_obligacion;
          
          ELSE
            
            v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_obligacion_agrupador,'PAGOPLAAG',NULL,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL);
                
            update  plani.tobligacion_agrupador set
              id_int_comprobante =  v_id_int_comprobante_obli
            where  id_obligacion_agrupador =  v_registros.id_obligacion_agrupador;
                          
          END IF;
       
       END IF;
    
    END IF;
     
    RETURN   TRUE;

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