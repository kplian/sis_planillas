CREATE OR REPLACE FUNCTION plani.f_prorratear_pres_cos_empleados (
  p_id_planilla integer,
  p_tipo_generacion varchar,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
DECLARE
  v_registros		record;
  v_resp	            	varchar;
  v_nombre_funcion      	text;
  v_mensaje_error       	text;
  v_planilla				record;
  v_consulta				varchar;
  v_presupuesto				record;
  v_id_presupuesto			integer;
  v_count					integer;
BEGIN
	v_nombre_funcion = 'plani.f_prorratear_pres_cos_empleados';
	 
    SELECT p.*,tp.tipo_presu_cc,tp.calculo_horas
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    where p.id_planilla = p_id_planilla;
    
    --llenar tprorrateo con datos de la parametrizazion
    if (v_planilla.tipo_presu_cc = 'parametrizacion' and v_planilla.calculo_horas = 'si') then
    	for v_registros in (select fp.id_funcionario_planilla,ht.id_horas_trabajadas, fun.desc_funcionario1,ht.porcentaje_sueldo	
        							from plani.thoras_trabajadas ht 
        							inner join plani.tfuncionario_planilla fp on 
                                    	fp.id_funcionario_planilla = ht.id_funcionario_planilla
                                    inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = p_id_planilla) loop
        	v_presupuesto = NULL;
            v_consulta = 'select cp.fecha_ini, sum(cp.porcentaje) as suma, pxp.aggarray(cp.id_centro_costo) as ids_presupuesto, pxp.aggarray(cp.porcentaje) as porcentajes	
                          from plani.thoras_trabajadas ht 
                          inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = ht.id_funcionario_planilla
                          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                          inner join param.tperiodo per on per.id_periodo = p.id_periodo
                          inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo';
            --hacer el join con cargo_presupeusto o cargo_centro_costo segun corresponda
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' inner join orga.tcargo_presupuesto cp on cp.id_cargo = car.id_cargo and cp.estado_reg = ''activo''  ';
            else
            	v_consulta = v_consulta || ' inner join orga.tcargo_centro_costo cp on cp.id_cargo = car.id_cargo and cp.estado_reg = ''activo'' ';
            end if;
            
            --obtener los presupeustos por contrato
            v_consulta = v_consulta || ' where 	cp.id_gestion = p.id_gestion and p.id_gestion = cp.id_gestion and 
                                  ht.id_horas_trabajadas = ' || v_registros.id_horas_trabajadas||  ' and cp.fecha_ini<= ht.fecha_ini
                          group by cp.fecha_ini
                          order by cp.fecha_ini desc
                          limit 1 offset 0'; 
            
            execute v_consulta
        	into v_presupuesto;
            
            if (v_presupuesto is null) then
            	raise exception 'El cargo del funcionario % no tiene registrado un presupuesto',v_registros.desc_funcionario1;
            end if;
            
            if (v_presupuesto.suma != 100) then
            	raise exception 'El cargo del funcionario % no tiene registrado presupuesto al 100 porciento',v_registros.desc_funcionario1;
            end if;
            v_count = 1;
            
            --para cada presupeusto en el array de presupuestos
            foreach v_id_presupuesto in array v_presupuesto.ids_presupuesto loop
            	
            	INSERT INTO 
                  plani.tprorrateo
                (
                  id_usuario_reg,
                  fecha_reg,
                  estado_reg,
                  id_funcionario_planilla,
                  id_horas_trabajadas,
                  id_presupuesto,
                  id_cc,
                  tipo_prorrateo,
                  porcentaje
                ) 
                VALUES (
                  p_id_usuario,
                  now(),
                  'activo',
                  v_registros.id_funcionario_planilla,
                  v_registros.id_horas_trabajadas,
                  case when p_tipo_generacion = 'presupuestos' then 
                  	v_id_presupuesto
                  else 
                  	NULL
                  END,
                  case when p_tipo_generacion = 'costos' then 
                  	v_id_presupuesto
                  else 
                  	NULL
                  END,
                  p_tipo_generacion,
                  v_presupuesto.porcentajes[v_count]*v_registros.porcentaje_sueldo/100
                );
                v_count = v_count + 1;
            end loop;      
    	    	
        end loop;
    
    --llenar tprorrateo con los datos del ultimo centro de costo
    elsif (v_planilla.tipo_presu_cc = 'ultimo_activo_periodo' or v_planilla.tipo_presu_cc = 'ultimo_activo_aguinaldo') then
    	
        for v_registros in (select fp.id_funcionario_planilla, fun.desc_funcionario1	
        							from plani.tfuncionario_planilla fp
                                    inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = p_id_planilla) loop
        	
            v_presupuesto = NULL;
            v_consulta = 'select cp.fecha_ini, sum(cp.porcentaje) as suma, pxp.aggarray(cp.id_centro_costo) as ids_presupuesto, pxp.aggarray(cp.porcentaje) as porcentajes	
                          from plani.tfuncionario_planilla fp
                          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla                          
                          inner join orga.tuo_funcionario uofun on fp.id_uo_funcionario = uofun.id_uo_funcionario
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo';
            --hacer el join con cargo_presupeusto o cargo_centro_costo segun corresponda
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' inner join orga.tcargo_presupuesto cp on cp.id_cargo = car.id_cargo ';
            else
            	v_consulta = v_consulta || ' inner join orga.tcargo_centro_costo cp on cp.id_cargo = car.id_cargo ';
            end if;
            
            --obtener los presupeustos por contrato
            v_consulta = v_consulta || ' where 	cp.id_gestion = p.id_gestion and p.id_gestion = cp.id_gestion and 
                                  fp.id_funcionario_planilla = ' || v_registros.id_funcionario_planilla||  ' and cp.fecha_ini<= p.fecha_planilla
                          group by cp.fecha_ini
                          order by cp.fecha_ini desc
                          limit 1 offset 0'; 
            
            
            execute v_consulta
        	into v_presupuesto;
            
            if (v_presupuesto is null) then
            	raise exception 'El cargo del funcionario % no tiene registrado un presupuesto',v_registros.desc_funcionario1;
            end if;
            
            if (v_presupuesto.suma != 100) then
            	raise exception 'El cargo del funcionario % no tiene registrado presupuesto al 100 porciento',v_registros.desc_funcionario1;
            end if;
            v_count = 1;
            
            --para cada presupeusto en el array de presupuestos
            foreach v_id_presupuesto in array v_presupuesto.ids_presupuesto loop
            	
            	INSERT INTO 
                  plani.tprorrateo
                (
                  id_usuario_reg,
                  fecha_reg,
                  estado_reg,
                  id_funcionario_planilla,
                  id_horas_trabajadas,
                  id_presupuesto,
                  id_cc,
                  tipo_prorrateo,
                  porcentaje
                ) 
                VALUES (
                  p_id_usuario,
                  now(),
                  'activo',
                  v_registros.id_funcionario_planilla,
                  NULL,
                  case when p_tipo_generacion = 'presupuestos' then 
                  	v_id_presupuesto
                  else 
                  	NULL
                  END,
                  case when p_tipo_generacion = 'costos' then 
                  	v_id_presupuesto
                  else 
                  	NULL
                  END,
                  p_tipo_generacion,
                  v_presupuesto.porcentajes[v_count]
                );
                v_count = v_count + 1;
            end loop;      
    	   	
        end loop;
    end if;
    --llenar tprorrateo_columna de acuerdo al prorrateo
    if (v_planilla.tipo_presu_cc = 'parametrizacion' and v_planilla.calculo_horas = 'si') then
    	v_consulta = '	select pro.id_prorrateo, pro.porcentaje, cv.id_tipo_columna,cv.codigo_columna,tc.compromete
        				from plani.tprorrateo pro
                        inner join plani.thoras_trabajadas ht on pro.id_horas_trabajadas = ht.id_horas_trabajadas
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = ht.id_funcionario_planilla 
                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
                        inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna and 
                        								(tc.compromete = ''si'' or tc.compromete = ''si_contable'')
                        where fp.id_planilla = ' || p_id_planilla;
    elsif (v_planilla.tipo_presu_cc = 'ultimo_activo_periodo') then
    	v_consulta = '	select pro.id_prorrateo, pro.porcentaje, cv.id_tipo_columna,cv.codigo_columna,tc.compromete
        				from plani.tprorrateo pro
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = pro.id_funcionario_planilla 
                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = pro.id_funcionario_planilla
                        inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna and 
                        								(tc.compromete = ''si'' or tc.compromete = ''si_contable'')
                        where fp.id_planilla = ' || p_id_planilla;
    
    end if;
    
    for v_registros in execute (v_consulta) loop
    	INSERT INTO 
          plani.tprorrateo_columna
        (
          id_usuario_reg,
          fecha_reg,
          estado_reg,
          id_prorrateo,
          id_tipo_columna,
          codigo_columna,
          porcentaje,
          compromete
        ) 
        VALUES (
          p_id_usuario,
          now(),
          'activo',
          v_registros.id_prorrateo,
          v_registros.id_tipo_columna,
          v_registros.codigo_columna,
          v_registros.porcentaje,
          v_registros.compromete
        );
    end loop;
    
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