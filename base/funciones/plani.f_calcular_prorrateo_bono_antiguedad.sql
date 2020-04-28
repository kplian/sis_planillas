--------------- SQL ---------------
-- FUNCTION: plani.f_calcular_prorrateo_bono_antiguedad(integer, integer, integer, date, date, date, character varying, date)

-- DROP FUNCTION plani.f_calcular_prorrateo_bono_antiguedad(integer, integer, integer, date, date, date, character varying, date);

CREATE OR REPLACE FUNCTION plani.f_calcular_prorrateo_bono_antiguedad(
	p_nivel_antiguedad integer,
	p_id_funcionario_planilla integer,
	p_id_funcionario integer,
	p_fecha_ini date,
	p_fecha_per_ini date,
	p_fecha_per_fin date,
	p_planilla_reintegro varchar = 'NO'::character varying,
  	p_fecha_plt_reintegro date = NULL::date)
    RETURNS numeric
    LANGUAGE 'plpgsql'

    COST 100
    STABLE 
AS $BODY$
  /**************************************************************************
   PLANI
  ***************************************************************************
   SCRIPT:
   COMENTARIOS:
   AUTOR: Jaim Rivera (Kplian)
   DESCRIP:
   Fecha: 27/01/2014


    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               27/01/2014        GUY BOA             Creacion 
 #18              03-07-2019        Rarteaga            Considera empleados con antiguedad superioes a 19 años
 #21              17-07-2019        RArteaga            Considerar carga horaria configurada para el usario en vez de quemar 240
 #25              05-08-2019        RArteaga            Correcion del salario minimo para que se calcule el salario minimo a la fecha de la planilla y no el ultimo
 #120			  28.04.2020		Rarteaga			Ajuste a calculo de prorrateo de bono de antiguedad	
 *******************************************************************************/
DECLARE

    v_resp                varchar;
      v_nombre_funcion    text;
      v_mensaje_error     text;
    v_resultado            numeric;
    v_porcentaje        integer;

    v_superior            integer;
    v_inferior            integer;
    v_intermedio        integer;

    v_salario_minimo    numeric;
    v_horas_laborales    numeric;
    v_horas_normales    numeric;
    v_record            record;

    v_ultima_fecha_mes    date;
    v_valor_min            integer;
    
    
    v_es_vigente        boolean;
    v_id_funcionario    integer;
    v_fecha_retiro      date;
    v_fecha_aux         date;
    v_dias_totales      integer;

BEGIN
    v_nombre_funcion = 'plani.f_calcular_prorrateo_bono_antiguedad';
    
    --#21 adiciona carga horaria
    select 
       uofun.carga_horaria,
       uofun.id_funcionario,
       COALESCE(uofun.fecha_finalizacion ,'01/01/3000')
    into 
      v_horas_laborales,
      v_id_funcionario,
      v_fecha_retiro
    from  plani.tfuncionario_planilla fp 
    inner join orga.tuo_funcionario uofun ON uofun.id_uo_funcionario = fp.id_uo_funcionario
    where fp.id_funcionario_planilla = p_id_funcionario_planilla;
    
     
    -- revisamos si e funcionario sigue vigente al fin del periodo 
    v_es_vigente = plani.f_es_funcionario_vigente(v_id_funcionario,p_fecha_per_fin);

    
    select tp.valor
    into v_salario_minimo
    from plani.tparametro_valor tp
    where   tp.codigo = 'SALMIN' 
         and 
         CASE WHEN p_planilla_reintegro = 'NO' THEN
            (     
             ( p_fecha_per_ini BETWEEN tp.fecha_ini AND  tp.fecha_fin)       --#25
              OR
             (p_fecha_per_ini >= tp.fecha_ini AND   tp.fecha_fin is null)
             )
           ELSE  -- si es planilla de reintegro calculo con la fecha de la planilla de reintegro con el sueldo bascio
            (     
             ( p_fecha_plt_reintegro BETWEEN tp.fecha_ini AND  tp.fecha_fin)       --#25
              OR
             (p_fecha_plt_reintegro >= tp.fecha_ini AND   tp.fecha_fin is null)
             )
          END;
       
      
   
    IF v_salario_minimo is null THEN
       raise exception 'No se encontro un salario minimo para la fecha % ', p_fecha_per_ini; 
    END IF;

    select sum(th.horas_normales)  --#18 aumenta el sum para considerar si el empleado cambio de cargo durante el mes
    into v_horas_normales
    from plani.thoras_trabajadas th
    where th.id_funcionario_planilla = p_id_funcionario_planilla;

    select porcentaje::integer, valor_min
    into v_porcentaje, v_valor_min
    from plani.tantiguedad
    where p_nivel_antiguedad BETWEEN valor_min and valor_max;
    
    
    
    --#18 p_fecha_ini,   ES el cumpleaños de trabajado
    --#18 p_fecha_per_ini,  Es la fecha de inicio del periodo de la plnailla
    --#18 restruturacion de IF para facilitar el entendimiento y mantenimiento
    
    
    IF p_fecha_ini = p_fecha_per_ini THEN 
    
        if v_horas_normales = v_horas_laborales then
             v_resultado = ((v_salario_minimo*v_porcentaje/100)*3);
        else
             v_resultado = ((v_salario_minimo*v_porcentaje/100)*3)*v_horas_normales/v_horas_laborales;
        end if;
      
    
    
    ELSE 
        --  Si el cambio de categoria se produce en mes, se calulo parte del bono con la categoria previa y los dias restantes con la nueva
        IF v_valor_min = p_nivel_antiguedad and p_fecha_ini between p_fecha_per_ini and p_fecha_per_fin THEN
        
             --si el empleado se retira el mes de debemos trabajar con la fecha menor
             IF v_es_vigente THEN
                v_fecha_aux = p_fecha_ini;
                v_dias_totales = 30;
             ELSE
                /*
                IF p_fecha_ini < v_fecha_retiro  THEN
                   v_fecha_aux = p_fecha_ini;
                ELSE 
                   v_fecha_aux = v_fecha_retiro;
                END IF;*/
                
                --cuantos dias trabajo en el mes antes de retirarce
                v_dias_totales = LEAST(date_part('day',v_fecha_retiro),30);
                
             END IF;
             
           

        
        
             if v_porcentaje = 5 then                  
             
                    v_superior = greatest(0,v_dias_totales - date_part('day',p_fecha_ini) + 1);
                    
                    v_resultado = ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30; 
                    
                    /*
                    v_superior = 30-date_part('day',v_fecha_aux) + 1;
                    v_resultado = ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30; */
                                           
              elsif v_porcentaje = 11 then
                    v_superior = greatest(0,v_dias_totales - date_part('day',p_fecha_ini) + 1);
                    v_inferior = v_dias_totales - v_superior;
                    v_resultado = (((v_salario_minimo*5/100)*3) * v_inferior/30) + (((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30);
                    
              elsif v_porcentaje = 18 then                  
                    v_superior = greatest(0,v_dias_totales - date_part('day',p_fecha_ini) + 1);
                    v_inferior = v_dias_totales - v_superior;
                    v_resultado = ((v_salario_minimo*11/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30; 
                            
              elsif v_porcentaje = 26 then                  
                    v_superior = greatest(0,v_dias_totales - date_part('day',p_fecha_ini) + 1);
                    v_inferior = v_dias_totales - v_superior;
                    v_resultado = ((v_salario_minimo*18/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30;
                                
              elsif v_porcentaje = 34 then                    
                    v_superior = greatest(0,v_dias_totales - date_part('day',p_fecha_ini) + 1);
                    v_inferior = v_dias_totales - v_superior;
                    v_resultado = ((v_salario_minimo*26/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30;
                                  
              elsif v_porcentaje = 42 then --#18  se aumenta esta consideracion que faltaba
                    v_superior = greatest(0,v_dias_totales - date_part('day',p_fecha_ini) + 1);
                    v_inferior = v_dias_totales - v_superior;
                    v_resultado = ((v_salario_minimo*34/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30; 
                      
                /*      if v_id_funcionario =  264  then
                  raise exception ' % ,% , %, %, %, %', v_porcentaje, p_fecha_ini, v_fecha_aux, v_superior, v_inferior, v_resultado;
                     end if;    */      
                     
              elsif v_porcentaje = 50 then  --#18  se aumenta esta consideracion que faltaba
                    v_superior = greatest(0,v_dias_totales - date_part('day',p_fecha_ini) + 1);
                    v_inferior = v_dias_totales - v_superior;
                    v_resultado = ((v_salario_minimo*42/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30;
                    
              else
                  v_resultado = 0;
              end if;
              
                  
              
              /*
             --TODO este bloque considera las posibles personas con medio tiempo de trabajo
              
            --considera el personal de no trabaja tiempo completo  
            if v_horas_normales != v_horas_laborales then             
              v_resultado =  v_resultado*v_horas_normales/v_horas_laborales;
            end if;*/
        
        ELSE
        
            if v_horas_normales = v_horas_laborales then
              v_resultado = ((v_salario_minimo*v_porcentaje/100)*3);
            else
              v_resultado = ((v_salario_minimo*v_porcentaje/100)*3)*v_horas_normales/v_horas_laborales;
            end if;
            /*
               if v_id_funcionario =  264  then
                  raise exception ' otro   %', v_resultado;
                end if;   */ 
            
            -- raise notice 'horas normales % ,  minimo %  , por % ', v_horas_normales, v_salario_minimo, v_porcentaje ;
        
        END IF;
    
    END IF;

    return v_resultado;
EXCEPTION

    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;

END;
$BODY$;

ALTER FUNCTION plani.f_calcular_prorrateo_bono_antiguedad(integer, integer, integer, date, date, date, character varying, date)
    OWNER TO postgres;
