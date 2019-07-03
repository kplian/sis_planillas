--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_calcular_prorrateo_bono_antiguedad (
  p_nivel_antiguedad integer,
  p_id_funcionario_planilla integer,
  p_id_funcionario integer,
  p_fecha_ini date,
  p_fecha_per_ini date,
  p_fecha_per_fin date
)
RETURNS numeric AS
$body$
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
 #18               03-07-2019        Rarteaga            Considera empleados con antiguedad superioes a 19 años
 
 *******************************************************************************/
DECLARE

    v_resp	            varchar;
  	v_nombre_funcion    text;
  	v_mensaje_error     text;
    v_resultado			numeric;
    v_porcentaje		integer;

    v_superior			integer;
    v_inferior			integer;
    v_intermedio		integer;

    v_salario_minimo	numeric;
    v_horas_laborales	numeric;
    v_horas_normales	numeric;
    v_record			record;

    v_ultima_fecha_mes	date;
    v_valor_min			integer;

BEGIN
	v_nombre_funcion = 'plani.f_calcular_prorrateo_bono_antiguedad';

    select tp.valor
    into v_salario_minimo
    from plani.tparametro_valor tp
    where tp.codigo = 'SALMIN' and tp.fecha_fin is null;

    select tp.valor
    into v_horas_laborales
    from plani.tparametro_valor tp
    where tp.codigo = 'HORLAB' and tp.fecha_fin is null;

    select th.horas_normales
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
    
        if v_horas_normales = 240 then
             v_resultado = ((v_salario_minimo*v_porcentaje/100)*3);
        else
             v_resultado = ((v_salario_minimo*v_porcentaje/100)*3)*v_horas_normales/v_horas_laborales;
        end if;
    
    ELSE 
        --  Si el cambio de categoria se produce en mes, se calulo parte del bono con la categoria previa y los dias restantes con la nueva
        IF v_valor_min = p_nivel_antiguedad and p_fecha_ini between p_fecha_per_ini and p_fecha_per_fin THEN
        
             if v_porcentaje = 5 then              	
                    v_superior = 30-date_part('day',p_fecha_ini) + 1;
                    v_resultado = ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30; 
                                           
              elsif v_porcentaje = 11 then
                    v_superior = 30 - date_part('day',p_fecha_ini) + 1;
                    v_inferior = 30 - v_superior;
                    v_resultado = (((v_salario_minimo*5/100)*3) * v_inferior/30) + (((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30);
                    
              elsif v_porcentaje = 18 then              	
                    v_superior = 30 - date_part('day',p_fecha_ini) + 1;
                    v_inferior = 30 - v_superior;
                    v_resultado = ((v_salario_minimo*11/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30; 
                            
              elsif v_porcentaje = 26 then              	
                    v_superior = 30 - date_part('day',p_fecha_ini) + 1;
                    v_inferior = 30 - v_superior;
                    v_resultado = ((v_salario_minimo*18/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30;
                                
              elsif v_porcentaje = 34 then                    
                    v_superior = 30 - date_part('day',p_fecha_ini) + 1;
                    v_inferior = 30 - v_superior;
                    v_resultado = ((v_salario_minimo*26/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30;
                                  
              elsif v_porcentaje = 42 then --#18  se aumenta esta consideracion que faltaba
                    v_superior = 30 - date_part('day',p_fecha_ini) + 1;
                    v_inferior = 30 - v_superior;
                    v_resultado = ((v_salario_minimo*34/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30; 
                                 
              elsif v_porcentaje = 50 then  --#18  se aumenta esta consideracion que faltaba
                    v_superior = 30 - date_part('day',p_fecha_ini) + 1;
                    v_inferior = 30 - v_superior;
                    v_resultado = ((v_salario_minimo*42/100)*3) * v_inferior/30 + ((v_salario_minimo*v_porcentaje/100)*3) * v_superior/30;
                    
              else
                  v_resultado = 0;
              end if;
        
        ELSE
        
            if v_horas_normales = 240 then
              v_resultado = ((v_salario_minimo*v_porcentaje/100)*3);
            else
              v_resultado = ((v_salario_minimo*v_porcentaje/100)*3)*v_horas_normales/v_horas_laborales;
            end if;
        
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
$body$
LANGUAGE 'plpgsql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;