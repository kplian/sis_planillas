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
  v_dias_aguinaldo			integer;
  v_suma					numeric;
  v_porcentaje				numeric;
  v_valor_total				numeric;
  v_valor_horas				numeric;
  v_subsidio_actual			numeric;
  v_horas_laborales			numeric;
BEGIN
	v_nombre_funcion = 'plani.f_prorratear_pres_cos_empleados';
	 
    SELECT p.*,tp.tipo_presu_cc,tp.calculo_horas,tp.codigo as tipo_planilla,per.fecha_fin as fecha_periodo
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    left join param.tperiodo per on per.id_periodo = p.id_periodo
    where p.id_planilla = p_id_planilla;
    
    --llenar tprorrateo con datos de la parametrizazion
    if (v_planilla.tipo_presu_cc = 'parametrizacion' and v_planilla.calculo_horas = 'si') then
    	v_horas_laborales = plani.f_get_valor_parametro_valor('HORLAB',v_planilla.fecha_periodo);
    	for v_registros in (select fp.id_funcionario_planilla,ht.id_horas_trabajadas, fun.desc_funcionario1,
        					ht.porcentaje_sueldo,ht.horas_normales,ht.sueldo
        							from plani.thoras_trabajadas ht 
        							inner join plani.tfuncionario_planilla fp on 
                                    	fp.id_funcionario_planilla = ht.id_funcionario_planilla
                                    inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = p_id_planilla) loop
        	--obtener sueldo total y horas totales de columna valor
            
            select c.valor into v_valor_horas
            from plani.tcolumna_valor c
            where id_funcionario_planilla = v_registros.id_funcionario_planilla 
            and c.codigo_columna = 'HORNORM' and c.estado_reg = 'activo'; 
            
            select c.valor into v_valor_total
            from plani.tcolumna_valor c
            where id_funcionario_planilla = v_registros.id_funcionario_planilla 
            and c.codigo_columna = 'SUELDOBA' and c.estado_reg = 'activo'; 
            
        	v_presupuesto = NULL;
            v_consulta = 'select cp.fecha_ini, sum(cp.porcentaje) as suma, pxp.aggarray(cp.id_centro_costo) as ids_presupuesto, pxp.aggarray(cp.porcentaje) as porcentajes,sum(ht.horas_normales) as suma_horas,sum(ht.horas_normales*ht.sueldo/' || v_horas_laborales || ') as suma_sueldos	
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
                  porcentaje,
                  porcentaje_dias
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
                  v_presupuesto.porcentajes[v_count]*v_registros.sueldo/v_horas_laborales*v_registros.horas_normales/v_valor_total,
                  v_presupuesto.porcentajes[v_count]*v_registros.horas_normales/v_valor_horas
                );
                v_count = v_count + 1;
            end loop;      
    	    	
        end loop;
        
    
    --llenar tprorrateo con los datos del ultimo centro de costo
    elsif (v_planilla.tipo_presu_cc = 'prorrateo_aguinaldo') then
    	
        for v_registros in (select fp.id_funcionario,fp.id_funcionario_planilla, fun.desc_funcionario1, p.id_gestion 	
        							from plani.tfuncionario_planilla fp
                                    inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                    inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = p_id_planilla) loop
        	
            v_presupuesto = NULL;
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta =  ' select ht.tipo_contrato,fp.id_funcionario,pro.id_presupuesto,NULL::integer as id_cc, sum((cv.valor*pro.porcentaje)/100)/8 as dias_presupuesto ';
            else
            	v_consulta =  ' select ht.tipo_contrato,fp.id_funcionario,pro.id_cc,NULL::integer as id_presupuesto, sum((cv.valor*pro.porcentaje)/100)/8 as dias_presupuesto ';
            end if;
            v_consulta =  v_consulta || '
                          from plani.tfuncionario_planilla fp
                          inner join plani.thoras_trabajadas ht  on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                          inner join plani.tprorrateo pro  on pro.id_horas_trabajadas = ht.id_horas_trabajadas                          
                          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                          inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                          inner join plani.tcolumna_valor cv on fp.id_funcionario_planilla = cv.id_funcionario_planilla
                          where cv.codigo_columna = ''HORNORM'' and tp.codigo = ''PLASUE'' 
                          	and p.id_gestion = ' || v_registros.id_gestion || ' and fp.id_funcionario = ' || v_registros.id_funcionario || ' and 
                          p.estado_reg=''activo''';
            
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' group by ht.tipo_contrato,fp.id_funcionario,pro.id_presupuesto ';
            else
            	v_consulta = v_consulta || ' group by ht.tipo_contrato,fp.id_funcionario,pro.id_cc ';
            end if;
            
           
            select cv.valor::integer into v_dias_aguinaldo
            from  plani.tcolumna_valor cv
            where cv.id_funcionario_planilla = v_registros.id_funcionario_planilla and
            cv.codigo_columna = 'DIASAGUI';          
            
           v_suma = 0;  
                     
           for v_presupuesto in execute(v_consulta) loop
            	--se obtiene el porcentaje de los dias con el presupuesto de los dias del aguinaldo
                v_porcentaje = round(v_presupuesto.dias_presupuesto/v_dias_aguinaldo*100,2);
            	v_suma = v_suma + v_porcentaje;
                --si se excede por redondeo restamos la diferencia del ultimo prorrateo
                if (v_suma > 100 and v_suma < 100.10) then
                	v_porcentaje = v_porcentaje + (100 - v_suma);
                end if;
                --insertamos un prorrateo
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
                  porcentaje,
                  tipo_contrato
                ) 
                VALUES (
                  p_id_usuario,
                  now(),
                  'activo',
                  v_registros.id_funcionario_planilla,
                  NULL,
                  case when p_tipo_generacion = 'presupuestos' then 
                  	v_presupuesto.id_presupuesto
                  else 
                  	NULL
                  END,
                  case when p_tipo_generacion = 'costos' then 
                  	v_presupuesto.id_cc
                  else 
                  	NULL
                  END,
                  p_tipo_generacion,
                  v_porcentaje,
                  v_presupuesto.tipo_contrato
                );
                
           end loop;
           
           if (v_suma = 0) then
           		raise exception 'La suma de presupuestos para el empleado %, suma 0',v_registros.desc_funcionario1;
           elsif (v_suma < 100) then
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
                  porcentaje,
                  tipo_contrato
                ) 
                VALUES (
                  p_id_usuario,
                  now(),
                  'activo',
                  v_registros.id_funcionario_planilla,
                  NULL,
                  case when p_tipo_generacion = 'presupuestos' then 
                  	v_presupuesto.id_presupuesto
                  else 
                  	NULL
                  END,
                  case when p_tipo_generacion = 'costos' then 
                  	v_presupuesto.id_cc
                  else 
                  	NULL
                  END,
                  p_tipo_generacion,
                  100 - v_suma,
                  v_presupuesto.tipo_contrato
                );
           elsif (v_suma > 100) then
           		raise exception 'La suma de presupuestos para el empleado %, suma mas del 100 porciento',v_registros.desc_funcionario1;
           end if;         
                 
    	   	
        end loop;
    
    --llenar tprorrateo con los datos del ultimo centro de costo
    elsif (v_planilla.tipo_presu_cc = 'retroactivo_sueldo') then
    	
        for v_registros in (select fp.id_funcionario,fp.id_funcionario_planilla, fun.desc_funcionario1, p.id_gestion 	
        							from plani.tfuncionario_planilla fp
                                    inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                    inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = p_id_planilla) loop
        	
            v_presupuesto = NULL;
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta =  ' select ht.tipo_contrato,cp.id_presupuesto,NULL::integer as id_cc, sum(cd.valor) as valor_presupuesto ';
            else
            	v_consulta =  ' select ht.tipo_contrato,cp.id_cc,NULL::integer as id_presupuesto, sum(cd.valor) as valor_presupuesto ';
            end if;
            v_consulta =  v_consulta || '
                          from plani.tfuncionario_planilla fp
                          inner join plani.tcolumna_valor cv  on cv.id_funcionario_planilla = fp.id_funcionario_planilla
                          inner join plani.tcolumna_detalle cd  on cd.id_columna_valor = cv.id_columna_valor                          
                          inner join plani.thoras_trabajadas ht on ht.id_horas_trabajadas = cv.id_horas_trabajadas
                          inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = ht.id_uo_funcionario
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo';
                          
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' inner join orga.tcargo_presupuesto cp on cp.id_cargo = car.id_cargo and cp.estado_reg = ''activo''  ';
            else
            	v_consulta = v_consulta || ' inner join orga.tcargo_centro_costo cp on cp.id_cargo = car.id_cargo and cp.estado_reg = ''activo'' ';
            end if;
                          
            v_consulta = v_consulta || '   where cv.codigo_columna = ''COTIZABLE''  
                          	and fp.id_funcionario = ' || v_registros.id_funcionario_planilla || ' and cp.fecha_ini<= ht.fecha_ini ';
            
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' group by ht.tipo_contrato,cp.id_presupuesto ';
            else
            	v_consulta = v_consulta || ' group by ht.tipo_contrato,cp.id_cc ';
            end if;
            
           
            select cv.valor::integer into v_valor_total
            from  plani.tcolumna_valor cv
            where cv.id_funcionario_planilla = v_registros.id_funcionario_planilla and
            cv.codigo_columna = 'COTIZABLE';          
            
           v_suma = 0;  
                     
           for v_presupuesto in execute(v_consulta) loop
            	--se obtiene el porcentaje de los dias con el presupuesto de los dias del aguinaldo
                v_porcentaje = round(v_presupuesto.valor_presupuesto/v_valor_total,2);
            	v_suma = v_suma + v_porcentaje;
                --si se excede por redondeo restamos la diferencia del ultimo prorrateo
                if (v_suma > 100 and v_suma < 100.10) then
                	v_porcentaje = v_porcentaje + (100 - v_suma);
                end if;
                --insertamos un prorrateo
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
                  porcentaje,
                  tipo_contrato
                ) 
                VALUES (
                  p_id_usuario,
                  now(),
                  'activo',
                  v_registros.id_funcionario_planilla,
                  NULL,
                  case when p_tipo_generacion = 'presupuestos' then 
                  	v_presupuesto.id_presupuesto
                  else 
                  	NULL
                  END,
                  case when p_tipo_generacion = 'costos' then 
                  	v_presupuesto.id_cc
                  else 
                  	NULL
                  END,
                  p_tipo_generacion,
                  v_porcentaje,
                  v_presupuesto.tipo_contrato
                );
                
           end loop;
           
          if (v_suma < 100) then
           		raise exception 'La suma de presupuestos para el empleado %, no suma el 100 porciento',v_registros.desc_funcionario1;
           elsif (v_suma > 100) then
           		raise exception 'La suma de presupuestos para el empleado %, suma mas del 100 porciento',v_registros.desc_funcionario1;
           end if;         
                 
    	   	
        end loop;
        
    --llenar tprorrateo con los datos del ultimo centro de costo
    elsif (v_planilla.tipo_presu_cc = 'retroactivo_asignaciones') then
    	
        v_subsidio_actual = plani.f_get_valor_parametro_valor('MONTOSUB',v_planilla.fecha_planilla);
        
        for v_registros in (select fp.id_funcionario,fp.id_funcionario_planilla, fun.desc_funcionario1, p.id_gestion 	
        							from plani.tfuncionario_planilla fp
                                    inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                    inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = p_id_planilla) loop
        	
            v_presupuesto = NULL;
            if (p_tipo_generacion = 'presupuestos') then 
            	
                v_consulta =  ' select tc.codigo as tipo_contrato,cp.id_presupuesto,NULL::integer as id_cc, 
                ((cv.valor/plani.f_get_valor_parametro_valor(''MONTOSUB'',p.fecha_fin)) * (' || v_subsidio_actual || ' - plani.f_get_valor_parametro_valor(''MONTOSUB'',p.fecha_fin))) as valor_presupuesto ';
            
            else
            	
                v_consulta =  ' select tc.codigo as tipo_contrato,cp.id_cc,NULL::integer as id_presupuesto, 
                ((cv.valor/plani.f_get_valor_parametro_valor(''MONTOSUB'',p.fecha_fin)) * (' || v_subsidio_actual || ' - plani.f_get_valor_parametro_valor(''MONTOSUB'',p.fecha_fin))) as valor_presupuesto ';
            
            end if;
            
            v_consulta =  v_consulta || '
                          from plani.tfuncionario_planilla fp
                          inner join plani.tplanilla p on fp.id_planilla = p.id_planilla
                          inner join param.tperiodo per on per.id_periodo = p.id_periodo
                          inner join plani.tcolumna_valor cv  on cv.id_funcionario_planilla = fp.id_funcionario_planilla
                          inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = ht.id_uo_funcionario
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato';
                          
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' inner join orga.tcargo_presupuesto cp on cp.id_cargo = car.id_cargo and cp.estado_reg = ''activo''  ';
            else
            	v_consulta = v_consulta || ' inner join orga.tcargo_centro_costo cp on cp.id_cargo = car.id_cargo and cp.estado_reg = ''activo'' ';
            end if;
                          
            v_consulta = v_consulta || '   where cv.codigo_columna = ''TOTSUB''  
                          	and fp.id_funcionario = ' || v_registros.id_funcionario_planilla || ' and cp.fecha_ini<= ht.fecha_ini ';
            
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' group by tc.codigo,cp.id_presupuesto ';
            else
            	v_consulta = v_consulta || ' group by tc.codigo,cp.id_cc ';
            end if;
            
           
            select cv.valor::integer into v_valor_total
            from  plani.tcolumna_valor cv
            where cv.id_funcionario_planilla = v_registros.id_funcionario_planilla and
            cv.codigo_columna = 'TOTSUB';          
            
           v_suma = 0;  
                     
           for v_presupuesto in execute(v_consulta) loop
            	--se obtiene el porcentaje de los dias con el presupuesto de los dias del aguinaldo
                v_porcentaje = round(v_presupuesto.valor_presupuesto/v_valor_total,2);
            	v_suma = v_suma + v_porcentaje;
                --si se excede por redondeo restamos la diferencia del ultimo prorrateo
                if (v_suma > 100 and v_suma < 100.10) then
                	v_porcentaje = v_porcentaje + (100 - v_suma);
                end if;
                --insertamos un prorrateo
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
                  porcentaje,
                  tipo_contrato
                ) 
                VALUES (
                  p_id_usuario,
                  now(),
                  'activo',
                  v_registros.id_funcionario_planilla,
                  NULL,
                  case when p_tipo_generacion = 'presupuestos' then 
                  	v_presupuesto.id_presupuesto
                  else 
                  	NULL
                  END,
                  case when p_tipo_generacion = 'costos' then 
                  	v_presupuesto.id_cc
                  else 
                  	NULL
                  END,
                  p_tipo_generacion,
                  v_porcentaje,
                  v_presupuesto.tipo_contrato
                );
                
           end loop;
           
          if (v_suma < 100) then
           		raise exception 'La suma de presupuestos para el empleado %, no suma el 100 porciento',v_registros.desc_funcionario1;
           elsif (v_suma > 100) then
           		raise exception 'La suma de presupuestos para el empleado %, suma mas del 100 porciento',v_registros.desc_funcionario1;
           end if;         
                 
    	   	
        end loop;
    
    
    --llenar tprorrateo con los datos del ultimo centro de costo
    elsif (v_planilla.tipo_presu_cc = 'ultimo_activo_periodo') then
    	
        for v_registros in (select fp.id_funcionario_planilla, fun.desc_funcionario1	
        							from plani.tfuncionario_planilla fp
                                    inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                    where fp.id_planilla = p_id_planilla) loop
        	
            v_presupuesto = NULL;
            v_consulta = 'select tc.codigo as tipo_contrato,cp.fecha_ini, sum(cp.porcentaje) as suma, pxp.aggarray(cp.id_centro_costo) as ids_presupuesto, pxp.aggarray(cp.porcentaje) as porcentajes	
                          from plani.tfuncionario_planilla fp
                          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla                          
                          inner join orga.tuo_funcionario uofun on fp.id_uo_funcionario = uofun.id_uo_funcionario
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato';
            --hacer el join con cargo_presupeusto o cargo_centro_costo segun corresponda
            if (p_tipo_generacion = 'presupuestos') then 
            	v_consulta = v_consulta || ' inner join orga.tcargo_presupuesto cp on cp.id_cargo = car.id_cargo ';
            else
            	v_consulta = v_consulta || ' inner join orga.tcargo_centro_costo cp on cp.id_cargo = car.id_cargo ';
            end if;
            
            --obtener los presupeustos por contrato
            v_consulta = v_consulta || ' where 	cp.id_gestion = p.id_gestion and p.id_gestion = cp.id_gestion and 
                                  fp.id_funcionario_planilla = ' || v_registros.id_funcionario_planilla||  ' and cp.fecha_ini<= p.fecha_planilla
                          group by tc.codigo,cp.fecha_ini
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
                  porcentaje,
                  tipo_contrato
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
                  v_presupuesto.porcentajes[v_count],
                  v_presupuesto.tipo_contrato
                );
                v_count = v_count + 1;
            end loop;      
    	   	
        end loop;
    end if;
    --llenar tprorrateo_columna de acuerdo al prorrateo
    if (v_planilla.tipo_presu_cc = 'parametrizacion' and v_planilla.calculo_horas = 'si') then
    	v_consulta = '	select pro.id_prorrateo, pro.porcentaje,pro.porcentaje_dias, cv.id_tipo_columna,cv.codigo_columna,tc.compromete
        				from plani.tprorrateo pro
                        inner join plani.thoras_trabajadas ht on pro.id_horas_trabajadas = ht.id_horas_trabajadas
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla = ht.id_funcionario_planilla 
                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
                        inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna and 
                        								(tc.compromete = ''si'' or tc.compromete = ''si_contable'')
                        where fp.id_planilla = ' || p_id_planilla;
    elsif (v_planilla.tipo_presu_cc in ('ultimo_activo_periodo', 'prorrateo_aguinaldo', 'retroactivo_sueldo' ,'retroactivo_asignaciones')) then
    	v_consulta = '	select pro.id_prorrateo, pro.porcentaje,pro.porcentaje_dias, cv.id_tipo_columna,cv.codigo_columna,tc.compromete
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
          (case when (v_registros.codigo_columna = 'BONANT' and v_planilla.tipo_planilla = 'PLASUE') then
          	v_registros.porcentaje_dias
          else
          	v_registros.porcentaje
          end),
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