--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_fun_inicio_planilla_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
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
   
 #0               17/10/2014        JRR KPLIAN        Función que se encarga de verificar la integridad del comprobante para posteriormente validarlo
 #1 ETR           24/01/2019        RAC KPLIAN        quita la validacion automatiza del cbte de devengado     
 #7 ETR           25/05/2019        RAC KPLIAN        Configurar la logica para dividir el cbte de devengado en uno presupeustario y uno solo contable
 #21 ETR          17/07/2019        RAC               Recueprar la carga horaria segun configuracion de tuo_funcionario en de usar HORLAB, para que se considere los empleados de medio tiempo
*/

DECLARE

    v_nombre_funcion        text;
    v_resp                 varchar;
    v_mensaje              varchar;

    v_planilla              record;
    v_monto_ejecutar_mo  numeric;
    v_empleados             record;
    v_columnas             record;
    v_cantidad_horas_mes integer;
    v_suma_horas            integer;
    v_suma_sueldo            numeric;
    v_suma_porcentaje        numeric;
    v_id_horas_trabajadas    integer;
    v_config            record;
    v_registros            record;
    v_id_gestion        integer;
    v_id_int_comprobante integer;
    v_id_int_comprobante_obli     integer;
    v_resbool            boolean;
    v_mensaje_error     varchar; --#1
    v_registros_aux     record; --#1
    v_id_int_comprobante_2  integer; --#7
    v_consulta              varchar; --#7



BEGIN

     v_nombre_funcion = 'plani.f_fun_inicio_planilla_wf';

     select (case when pla.fecha_planilla is not null then
                                pla.fecha_planilla ELSE
                                pe.fecha_fin end) as fecha_planilla, pla.*, pe.fecha_ini, pe.fecha_fin,tp.calculo_horas,
                                tp.funcion_calculo_horas, tp.codigo, tp.tipo_presu_cc 
      into v_planilla
      from plani.tplanilla pla
      inner join plani.ttipo_planilla tp
          on tp.id_tipo_planilla = pla.id_tipo_planilla
      left join param.tperiodo pe on pe.id_periodo = pla.id_periodo
      where id_proceso_wf = p_id_proceso_wf;

    -----------------------------------------------------------------------------------
    -- validacion del prorrateo--  (con el codigo actual de estado antes de cambiarlo)
    -----------------------------------------------------------------------------------

     IF p_codigo_estado  in ('registro_horas') THEN
     
         --#7 validar si existe funcion de calculo de horas
         IF v_planilla.funcion_calculo_horas is null or v_planilla.funcion_calculo_horas = '' THEN
             raise exception 'No tiene definida la funcion de calculo de horas para el tipo de planilla';
         END IF;
     
         v_consulta = 'select * from ' || v_planilla.funcion_calculo_horas || '(' ||
                                 v_planilla.id_planilla || ', '||p_id_usuario ||')';
         
         execute v_consulta  into v_resp;

     elsif (p_codigo_estado  in ('calculo_columnas')) then

        --verificacion de presupuesto
        /*select funpla.*,fun.desc_funcionario1 as nombre
        from plani.tfuncionario_planilla funpla
        inner join orga.vfuncionario fun on fun.id_funcionario = funpla.id_funcionario
        where id_planilla = v_planilla.id_planilla;*/
--        raise exception 'v_planilla.calculo_horas: %,v_planilla.fecha_ini: %', v_planilla.calculo_horas,v_planilla.fecha_ini;
        
        --#1 verificacion de hojas de trabajo segun configuracion de planilla 
        IF ( v_planilla.tipo_presu_cc = 'hoja_calculo') THEN
        
           --verificar si algun empleado no tiene hoja de trabajo aprobada
           v_mensaje_error = '';
           FOR v_registros_aux in (
                                    SELECT  fun.desc_funcionario1
                                    FROM plani.tfuncionario_planilla fp
                                    INNER JOIN orga.vfuncionario fun ON fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = v_planilla.id_planilla
                                          AND fp.id_funcionario not in (select id_funcionario 
                                                                        from asis.vtotales_horas_centro_costo  toc
                                                                        where toc.id_periodo = v_planilla.id_periodo                                                                        
                                                                        and toc.estado = 'aprobado')) LOOP
                                                                        
                v_mensaje_error = v_mensaje_error|| v_registros_aux.desc_funcionario1||', ';
            END LOOP;
            
            IF v_mensaje_error != '' THEN
               raise exception ' Los siguientes  empleados no tienen hoja de trabajo aprobada en sistema de asistencia: <BR> %',v_mensaje_error;
            END IF;
           
        END IF;

         update plani.tplanilla set
            requiere_calculo = 'no'
         where id_planilla =  v_planilla.id_planilla;
         if (v_planilla.calculo_horas = 'si') then
                
               

                for v_empleados in (select funpla.*,fun.desc_funcionario1 as nombre , uofun.carga_horaria
                                    from plani.tfuncionario_planilla funpla
                                    inner join orga.vfuncionario fun on fun.id_funcionario = funpla.id_funcionario
                                    inner join orga.tuo_funcionario uofun ON uofun.id_uo_funcionario = funpla.id_uo_funcionario
                                    where id_planilla = v_planilla.id_planilla)loop
                                   
                    v_cantidad_horas_mes = v_empleados.carga_horaria;    --#21  recupera carga horaria de configuracion
                                    
                    select sum(horas_normales)::integer, round(sum(sueldo / v_cantidad_horas_mes * case when horas_normales=0 then 1 else horas_normales end),2)
                    into v_suma_horas, v_suma_sueldo
                    from plani.thoras_trabajadas
                    where id_funcionario_planilla = v_empleados.id_funcionario_planilla;

                    if (v_suma_horas > v_cantidad_horas_mes)then
                        raise exception 'La cantidad de horas trabajadas para el empleado : % , superan las : % horas',
                                        v_empleados.nombre,v_cantidad_horas_mes;
                    end if;

                    if (v_suma_horas < 0 )then
                        raise exception 'La cantidad de horas trabajadas para el empleado : % , es 0 o menor a 0',
                                        v_empleados.nombre;
                    end if;

                    update plani.thoras_trabajadas set
                        porcentaje_sueldo = (round((sueldo / v_cantidad_horas_mes * coalesce(horas_normales,1)),2) / case when v_suma_sueldo=0 then 1 else v_suma_sueldo end) * 100
                    where id_funcionario_planilla = v_empleados.id_funcionario_planilla;

                    select sum(porcentaje_sueldo),max(id_horas_trabajadas)
                    into v_suma_porcentaje,v_id_horas_trabajadas
                    from plani.thoras_trabajadas
                    where id_funcionario_planilla = v_empleados.id_funcionario_planilla;

                    if (v_suma_porcentaje != 100 ) then
                        update plani.thoras_trabajadas set
                            porcentaje_sueldo = porcentaje_sueldo + (100 - v_suma_porcentaje)
                        where id_horas_trabajadas = v_id_horas_trabajadas;
                    end if;


                end loop;
            end if;
            --calcula columas despues de validar las horas
            v_resp = (select plani.f_planilla_calcular(v_planilla.id_planilla,p_id_usuario));

     elsif (p_codigo_estado  in ('calculo_validado')) then

              if (v_planilla.requiere_calculo = 'si') then
                  raise exception 'Esta planilla debe ser recalculada antes de validar el calculo';
              end if;

             for v_empleados in (select *
                                from plani.tfuncionario_planilla
                                where id_planilla = v_planilla.id_planilla) loop
                for v_columnas in (    select db.id_descuento_bono
                                    from plani.tcolumna_valor cv
                                    inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                                    inner join plani.tdescuento_bono db on tc.id_tipo_columna = db.id_tipo_columna and
                                                                    db.id_funcionario = v_empleados.id_funcionario and db.estado_reg = 'activo'
                                    where cv.id_funcionario_planilla = v_empleados.id_funcionario_planilla and
                                        tc.tipo_descuento_bono = 'cantidad_cuotas') loop
                    update plani.tdescuento_bono
                        set monto_total = monto_total - valor_por_cuota
                    where id_descuento_bono = v_columnas.id_descuento_bono;
                end loop;
            end loop;
          

     elsif (p_codigo_estado  in ('vbpoa', 'suppresu', 'vbpresupuestos')) then
         update plani.tplanilla  t set
               id_estado_wf =  p_id_estado_wf,
               estado = p_codigo_estado,
               id_usuario_mod=p_id_usuario,
               id_usuario_ai = p_id_usuario_ai,
               usuario_ai = p_usuario_ai,
               fecha_mod=now()
        where id_proceso_wf = p_id_proceso_wf;

     elsif (p_codigo_estado  in ('presupuestos')) then

         v_resp = (select plani.f_prorratear_pres_cos_empleados(v_planilla.id_planilla, 'presupuestos', p_id_usuario));
        v_resp = (select plani.f_consolidar_pres_cos(v_planilla.id_planilla, 'presupuestos',p_id_usuario));

     elsif (p_codigo_estado  in ('obligaciones_validado')) then
        --si el estado anterior es calculo validado quiere decir q necesitamos generar presupuestos y obligaciones
        if (v_planilla.estado = 'calculo_validado') then
            v_resp = (select plani.f_prorratear_pres_cos_empleados(v_planilla.id_planilla, 'presupuestos', p_id_usuario));
            v_resp = (select plani.f_consolidar_pres_cos(v_planilla.id_planilla, 'presupuestos',p_id_usuario));
             v_resp = (select plani.f_generar_obligaciones(v_planilla.id_planilla, p_id_usuario));

         end if;

     elsif (p_codigo_estado  in ('obligaciones')) then

         v_resp = (select plani.f_generar_obligaciones(v_planilla.id_planilla, p_id_usuario));

     elsif (p_codigo_estado  in ('obligaciones_generadas')) then
        --Generamos Presupuestos
        v_resp = (select plani.f_prorratear_pres_cos_empleados(v_planilla.id_planilla, 'presupuestos', p_id_usuario));
        v_resp = (select plani.f_consolidar_pres_cos(v_planilla.id_planilla, 'presupuestos',p_id_usuario));
         --Calculamos obligaciones Obligaciones
         v_resp = (select plani.f_generar_obligaciones(v_planilla.id_planilla, p_id_usuario));
         v_resp = (select plani.f_conta_relacionar_cuentas(v_planilla.id_planilla, p_id_usuario));
     
     
     elsif (p_codigo_estado  in ('comprobante_generado')) then
     
        
          select po_id_gestion into  v_id_gestion from param.f_get_periodo_gestion(v_planilla.fecha_planilla);
          
          -- #7   idenfificar si se divide el cbte o no
           
          
          IF   v_planilla.dividir_comprobante = 'no' THEN
             -- generar comprobante de devengado
             v_id_int_comprobante =   conta.f_gen_comprobante (v_planilla.id_planilla,'DIARIOPLA',p_id_estado_wf,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL);
          ELSE
            
            --si se divide el cbte llama a las planillas  DIARIOPLA_C1 y DIARIOPLA_C2
            v_id_int_comprobante =   conta.f_gen_comprobante (v_planilla.id_planilla,'DIARIOPLA_C1',p_id_estado_wf,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL);   --Diario Presupeustario
            v_id_int_comprobante_2 =   conta.f_gen_comprobante (v_planilla.id_planilla,'DIARIOPLA_C2',p_id_estado_wf,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL); --Diario contable 
          
          END IF;
          
          -- actualiza estado en la solicitud
            update plani.tplanilla  t set
               id_estado_wf =  p_id_estado_wf,
               estado = p_codigo_estado,
               id_usuario_mod=p_id_usuario,
               id_usuario_ai = p_id_usuario_ai,
               usuario_ai = p_usuario_ai,
               fecha_mod=now(),
               id_int_comprobante = (case when id_int_comprobante is not null then id_int_comprobante else  v_id_int_comprobante  end),
               id_int_comprobante_2 = v_id_int_comprobante_2
            where id_proceso_wf = p_id_proceso_wf;
          
           return true;

     --elsif (p_codigo_estado  in ('planilla_finalizada')) then
     --rensi 09050291, temporalemten un opocion para probar directament obligaciones
     --se agrega comprobante_obligaciones
     elsif (p_codigo_estado  in ('planilla_finalizada','comprobante_obligaciones')) then
         /*
         
         if (pxp.f_get_variable_global('plani_generar_comprobante_obligaciones') = 'si') then
            --generar obligacion de apgo sin agrupador
             for v_registros in (    
                                select *
                                  from plani.tobligacion o
                                inner join plani.ttipo_obligacion tipo on o.id_tipo_obligacion = tipo.id_tipo_obligacion
                                where tipo.es_pagable = 'si'
                                    and o.id_planilla = v_planilla.id_planilla --#1
                                    and o.id_obligacion_agrupador is null
                                 ) loop
                                
                       
                -- raise exception '1 pasa...%',v_registros.id_obligacion;      
                                
                  v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_obligacion,'PAGOPLA',p_id_estado_wf,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL);
                
               update  plani.tobligacion set
                 id_int_comprobante =  v_id_int_comprobante_obli
               where  id_obligacion =  v_registros.id_obligacion;
                 
                
              end loop;
            
            --#1 generar obligacion de pago con agrupadores  (si no es pagable no tiene sentido que tenga agrupador)
            
            for v_registros in (    
                                select *
                                  from plani.tobligacion_agrupador oa
                                where oa.id_planilla = v_planilla.id_planilla --#1                                    
                            ) loop
                                
                 --raise exception 'pasa...%', p_id_estado_wf;                
                                
                  v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_obligacion_agrupador,'PAGOPLAAG',p_id_estado_wf,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL);
                
               update  plani.tobligacion_agrupador set
                 id_int_comprobante =  v_id_int_comprobante_obli
               where  id_obligacion_agrupador =  v_registros.id_obligacion_agrupador;
                
              end loop;
            
            
        end if;
        
        */
        
     END IF;


    -- actualiza estado en la solicitud
    update plani.tplanilla  t set
       id_estado_wf =  p_id_estado_wf,
       estado = p_codigo_estado,
       id_usuario_mod=p_id_usuario,
       id_usuario_ai = p_id_usuario_ai,
       usuario_ai = p_usuario_ai,
       fecha_mod=now(),
       id_int_comprobante = (case when id_int_comprobante is not null then id_int_comprobante else  v_id_int_comprobante  end)
    where id_proceso_wf = p_id_proceso_wf;

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