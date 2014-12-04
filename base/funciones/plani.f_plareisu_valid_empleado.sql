CREATE OR REPLACE FUNCTION plani.f_plareisu_valid_empleado (
  p_id_funcionario integer,
  p_id_planilla integer,
  out o_id_uo_funcionario integer,
  out o_id_lugar integer,
  out o_id_afp integer,
  out o_id_cuenta_bancaria integer
)
RETURNS record AS
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
  v_existe				varchar;
  v_fecha_ini		date;
  
  v_tiene_incremento	integer;
  v_id_escala			integer;
BEGIN
	
    v_nombre_funcion = 'plani.f_plareisu_valid_empleado';
   
	v_existe = 'no';
	select id_tipo_planilla, p.id_gestion, ges.gestion,id_uo, p.id_usuario_reg,p.fecha_planilla
    into v_planilla 
    from plani.tplanilla p
    inner join param.tgestion ges
    	on p.id_gestion = ges.id_gestion
    where p.id_planilla = p_id_planilla;
    
    v_fecha_ini = ('01/01/' || v_planilla.gestion) ::date;
    
    
    for v_registros in execute('
          select uofun.id_funcionario , array_agg(car.id_cargo) as cargos, 
          		array_agg(car.id_escala_salarial) as escalas, array_agg(ofi.id_lugar) as lugares,
                max(uofun.id_uo_funcionario) as id_uo_funcionario 
          from orga.tuo_funcionario uofun
          inner join orga.tcargo car
              on car.id_cargo = uofun.id_cargo
          inner join orga.ttipo_contrato tc
              on car.id_tipo_contrato = tc.id_tipo_contrato  
          inner join orga.toficina ofi
              on car.id_oficina = ofi.id_oficina 
          where uofun.id_funcionario = ' || p_id_funcionario || ' and tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and 
          	 uofun.fecha_asignacion <= ''' || v_planilla.fecha_planilla || ''' and 
              (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= ''' || v_fecha_ini || ''') AND
              uofun.estado_reg != ''inactivo'' and uofun.id_funcionario not in (
                  select id_funcionario
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p
                      on p.id_planilla = fp.id_planilla
                  where 	fp.id_funcionario = uofun.id_funcionario and 
                          p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                          p.id_gestion = ' || v_planilla.id_gestion || ')
          group by uofun.id_funcionario')loop
          	 v_tiene_incremento = 0;
          	FOREACH v_id_escala IN ARRAY v_registros.escalas
              LOOP
                  if (plani.f_tiene_incremento_escala(v_id_escala, v_planilla.gestion)) THEN
                      v_tiene_incremento = 1;
                  end if;  
              END LOOP;
    	
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
                                  cv.codigo_columna = 'FACTORANTI' and cv.valor > 0)) then
                      if (plani.f_tiene_incremento_parametro('SALMIN',v_planilla.gestion)) THEN
                          v_tiene_incremento = 1;
                      end if;
                  end if;
              end if;
        
        if (v_tiene_incremento = 1) then
            v_existe = 'si';
            o_id_lugar = v_registros.lugares[1];
            o_id_uo_funcionario = v_registros.id_uo_funcionario;
            o_id_afp = plani.f_get_afp(p_id_funcionario, v_planilla.fecha_planilla);
            o_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(p_id_funcionario, v_planilla.fecha_planilla);
        end if;    
  			  	
    end loop;
    if (v_existe = 'no') then
    	raise exception 'No se puede añadir el funcionario a la planilla ya que no tiene una asignacion de cargo para el periodo';
    end if;
    return;
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