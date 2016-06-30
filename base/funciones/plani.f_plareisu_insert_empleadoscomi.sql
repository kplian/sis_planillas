CREATE OR REPLACE FUNCTION plani.f_plareisu_insert_empleadoscomi (
  p_id_planilla integer
)
RETURNS varchar AS
$body$
DECLARE
  v_registros			record;
  v_planilla			record;
  v_id_funcionario_planilla	integer;
  v_columnas			record;
  v_resp	            varchar;
  v_nombre_funcion      text;
  v_mensaje_error       text;
  v_filtro_uo			varchar;
  v_id_afp				integer;
  v_id_cuenta_bancaria	integer;
  v_fecha_inicio		date;
  
  v_id_escala			integer;
  v_id_tipo_planilla_suel	integer;
  v_tiene_incremento		integer;
  v_cantidad_horas_mes	integer;
  v_resultado			numeric;
  v_detalle				record;
  v_id_columna_valor	integer;
  v_max_retro			numeric;
  v_tipo_contrato		varchar;
BEGIN
	
    v_nombre_funcion = 'plani.f_plareisu_insert_empleadoscomi';
    v_filtro_uo = '';
	select id_tipo_planilla,p.id_gestion, ges.gestion, id_uo, p.id_usuario_reg,p.fecha_planilla
    into v_planilla 
    from plani.tplanilla p
    inner join param.tgestion ges
    	on p.id_gestion = ges.id_gestion
    where p.id_planilla = p_id_planilla;
    
    select tp.id_tipo_planilla into v_id_tipo_planilla_suel
    from plani.ttipo_planilla tp
    where tp.codigo = 'PLASUE' and tp.estado_reg='activo';
    
    if (v_planilla.id_uo is not null) then
    	v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;
    v_fecha_inicio = ('01/01/' || v_planilla.gestion) ::date;
    v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', v_fecha_inicio)::integer;
    v_max_retro = plani.f_get_valor_parametro_valor('MAXRETROSUE', v_fecha_inicio)::integer;
    
    
    for v_registros in execute('
          select uofun.id_funcionario , array_agg(car.id_cargo) as cargos, 
          		array_agg(car.id_escala_salarial) as escalas, array_agg(ofi.id_lugar) as lugares,
                max(uofun.id_uo_funcionario) as id_uo_funcionario
          from orga.tuo_funcionario uofun
          inner join orga.tcargo car
              on car.id_cargo = uofun.id_cargo
          inner join orga.tescala_salarial esc
              on esc.id_escala_salarial = car.id_escala_salarial
          inner join orga.ttipo_contrato tc
              on car.id_tipo_contrato = tc.id_tipo_contrato  
          left join orga.toficina ofi
              on car.id_oficina = ofi.id_oficina 
          where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and ' 
          	|| v_filtro_uo || ' uofun.fecha_asignacion <= ''' || v_planilla.fecha_planilla || ''' and 
              (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= ''' || v_fecha_inicio || ''') AND
              uofun.estado_reg != ''inactivo'' and uofun.id_funcionario not in (
                  select id_funcionario
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p
                      on p.id_planilla = fp.id_planilla
                  where 	fp.id_funcionario = uofun.id_funcionario and 
                          p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                          p.id_gestion = ' || v_planilla.id_gestion || ')
          group by uofun.id_funcionario')loop
         
    	v_id_afp = plani.f_get_afp(v_registros.id_funcionario, v_planilla.fecha_planilla);
        v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_planilla);
        v_tiene_incremento = 0;
                   
        --calcular si tendra algun incremento durante el año        
        select sum( case when (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
        			and orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then
        			  
        				(orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales) - 
        				(ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
                     else 
                     	0
                     end) into v_resultado
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
        where fp.id_funcionario = v_registros.id_funcionario and  tp.codigo = 'PLASUE' and
        ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion;
    	  
        if (v_resultado > 0) then
        	v_tiene_incremento = 1;
        end if;
        if (v_tiene_incremento = 0)then
         
            --si no hay incremento en escala, verificar si el empleado recibio bono de antiguedad 
            --en alguna planilla de la gestion y en caso de ser asi verificar si hubo incremento 
            --en salario minimo de la gestion
            if (exists (select 1 from plani.tplanilla p
            			inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
                        where p.id_tipo_planilla = v_id_tipo_planilla_suel and 
                        	p.id_gestion = v_planilla.id_gestion and
                        	fp.id_funcionario = v_registros.id_funcionario and
                            cv.codigo_columna = 'FACTORANTICOMI' and cv.valor > 0)) then
                        
            	if (plani.f_tiene_incremento_parametro('SALMIN',v_planilla.gestion)) THEN
                	v_tiene_incremento = 1;
                end if;
            end if;
        end if;
        
        if (v_tiene_incremento = 1) then
            if (v_registros.lugares[1] is null) then
                raise exception 'El cargo con identificador:% , no tiene una oficina asignada',v_registros.cargos[1];
            end if; 
            v_tipo_contrato = plani.f_get_tipo_contrato(v_registros.id_uo_funcionario);  
            INSERT INTO plani.tfuncionario_planilla (
                id_usuario_reg,					estado_reg,					id_funcionario,
                id_planilla,					id_uo_funcionario,			id_lugar,
                forzar_cheque,					finiquito,					id_afp,
                id_cuenta_bancaria,				tipo_contrato)
            VALUES (
                v_planilla.id_usuario_reg,		'activo',					v_registros.id_funcionario,
                p_id_planilla,					v_registros.id_uo_funcionario,v_registros.lugares[1],
                'no',							'no',						v_id_afp,
                v_id_cuenta_bancaria,			v_tipo_contrato)
            RETURNING id_funcionario_planilla into v_id_funcionario_planilla;
                
            for v_columnas in (	select * 
                                from plani.ttipo_columna 
                                where id_tipo_planilla = v_planilla.id_tipo_planilla and estado_reg = 'activo' order by orden) loop
                INSERT INTO 
                    plani.tcolumna_valor
                  (
                    id_usuario_reg,
                    estado_reg,
                    id_tipo_columna,
                    id_funcionario_planilla,
                    codigo_columna,
                    formula,
                    valor,
                    valor_generado
                  ) 
                  VALUES (
                    v_planilla.id_usuario_reg,
                    'activo',
                    v_columnas.id_tipo_columna,
                    v_id_funcionario_planilla,
                    v_columnas.codigo,
                    v_columnas.formula,
                    0,
                    0
                  )returning id_columna_valor into v_id_columna_valor;
                
                --registrando el detalle en caso de ser necesario  
                if (v_columnas.tiene_detalle = 'si')then
                	for v_detalle in (	
                    	select ht.id_horas_trabajadas
                    	from plani.tplanilla p
                    	inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                    	inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                    	inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                    	where fp.id_funcionario = v_registros.id_funcionario and  tp.codigo = 'PLASUE' and
                    	ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion) loop
                        
                        INSERT INTO 
                            plani.tcolumna_detalle
                          (
                            id_usuario_reg,  
                            id_horas_trabajadas,
                            id_columna_valor,
                            valor,
                            valor_generado
                          ) 
                          VALUES (
                            v_planilla.id_usuario_reg,  
                            v_detalle.id_horas_trabajadas,
                            v_id_columna_valor,
                            0,
                            0
                          );
                          
                    end loop;
                end if;
            end loop;
        end if;
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