CREATE OR REPLACE FUNCTION plani.f_evaluar_antiguedad (
  kp_fecha_ini date,
  kp_fecha_calculo date,
  kp_periodos_antiguedad integer
)
RETURNS numeric AS
$body$
DECLARE
  g_anos numeric;
  g_gestion numeric;
  g_periodos numeric; 
  g_porcentaje numeric;
  g_salario_minimo numeric;
BEGIN
	
	g_anos:=(select (date_part('year', age(date_trunc('month', kp_fecha_calculo)::date, kp_fecha_ini))));
    g_periodos:=(coalesce(kp_periodos_antiguedad,0) + (select (date_part('month',age(kp_fecha_calculo, kp_fecha_ini)))));
    
    g_periodos:=(select floor(g_periodos/12));
    g_anos:=g_anos + g_periodos;
        
    select plani.f_get_valor_parametro_valor('SALMIN',kp_fecha_calculo) into g_salario_minimo;
    
    
    select ant.porcentaje
    into g_porcentaje
    from plani.tantiguedad ant
    where ant.valor_min <= g_anos and ant.valor_max >= g_anos;
    
    if g_porcentaje is null then
    g_porcentaje = 0;     
    end if;
    
    return round(g_porcentaje/100 * g_salario_minimo * 3 , 2);
    
END;
$body$
LANGUAGE 'plpgsql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;