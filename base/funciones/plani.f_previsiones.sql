CREATE OR REPLACE FUNCTION plani.f_previsiones (
  gerencias integer,
  contratos integer,
  fecha varchar
)
RETURNS SETOF record AS
$body$
DECLARE

    --PARÁMETROS FIJOS
    g_registros                record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT
    g_consulta                 text;    -- VARIABLE QUE CONTENDRÁ LA CONSULTA DINÁMICA PARA EL FILTRO
	v_where						varchar;
    v_fecha						date;
BEGIN
	v_fecha = to_date(fecha,'MM/DD/YYYY');
	v_where = '';
	if (contratos <> -1) then
    	v_where = v_where || ' and tc.id_tipo_contrato = ' || contratos;
    end if;
    
    if (gerencias <> -1) then
    	v_where = v_where || ' and ger.id_uo = ' || gerencias;
    end if;
    
    ---***SELECCIÓN DE OPERACIÓN A REALIZAR
    FOR g_registros in  execute ('
                  with detalle as(

              select
                              ger.nombre_unidad as Gerencia, 
                              car.nombre as NombreCargo, 
                              datos.desc_funcionario2 as NombreCompleto, 
              			    
                              (case when uofun.id_funcionario = 10 then
                                  ''27/12/2013''::date
                              else            
                                  plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion)           
                              END)  as FechaIncorp,
                              
                              (case when uofun.id_funcionario = 10 then
                                   (''' || v_fecha ||'''::date - ''27/12/2013''::date) + 1
                              else            
                                 (''' || v_fecha ||'''::date - plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion)) + 1 - plani.f_get_dias_licencia_funcionario(datos.id_funcionario)          
                              END)::integer  as diastrabajados, 
                              
                          (case when ' || gerencias ||' <>-1 then
                              ger.nombre_unidad	
                          ELSE 
                              ''Boliviana de Aviacion''::varchar
                          END)  as NombreDepartamento,
                          (case when ' || contratos ||'<>-1 then 
                              tc.nombre
                          ELSE 
                              ''TODOS''::varchar
                          END)  as NombreContrato,
                          ''' || v_fecha ||'''::Date as FechaPrev ,
                          orga.f_get_haber_basico_a_fecha(escala.id_escala_salarial,''' || v_fecha ||'''::date) as haberbasico,
                          fun.antiguedad_anterior,
                          plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion) as fechaAntiguedad,
                          (case when ofi.frontera =''si'' then
                          	0.2
                          else
                          	0
                          end) as frontera
                          from orga.tuo_funcionario uofun                            
                          INNER JOIN orga.vfuncionario datos ON datos.id_funcionario=uofun.id_funcionario
                          inner join orga.tcargo car ON car.id_cargo = uofun.id_cargo
                          inner join orga.toficina ofi ON ofi.id_oficina = car.id_oficina
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tescala_salarial escala ON escala.id_escala_salarial=car.id_escala_salarial
                          inner join orga.tfuncionario fun on fun.id_funcionario = datos.id_funcionario
                          inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,''' || v_fecha ||'''::date)
                          where uofun.estado_reg != ''inactivo'' and uofun.fecha_asignacion <= ''' || v_fecha ||'''::date and 
                          (uofun.fecha_finalizacion >= ''' || v_fecha ||'''::date or uofun.fecha_finalizacion is null) ' || v_where ||' 
                          order by ger.prioridad::INTEGER,datos.desc_funcionario2)

                          select Gerencia::varchar,NombreCargo::varchar,NombreCompleto::text,
                          round(haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_fecha ||'''::date,antiguedad_anterior),2) as HaberBasico,
                          FechaIncorp::date,
                          diastrabajados::integer,
                          round((haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_fecha ||'''::date,antiguedad_anterior))/365,8) as indemdia,
                          round((haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_fecha ||'''::date,antiguedad_anterior))/365,8)*diastrabajados as Indem,
                          NombreDepartamento::varchar,
                          NombreContrato::varchar,
                          FechaPrev::varchar
                          from detalle
                          where diastrabajados >= 90') LOOP
                  
        RETURN NEXT g_registros;
    END LOOP;        
  

return;
--end

EXCEPTION

    WHEN others THEN BEGIN
    
        --SE OBTIENE EL MENSAJE Y EL NÚMERO DEL ERROR LANZADO POR EL GESTOR DE BASE DE DATOS
        RAISE EXCEPTION '%', 'fallo en el proceso de la consulta jjjjjjj'|| SQLSTATE||' '||SQLERRM;

    END;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;