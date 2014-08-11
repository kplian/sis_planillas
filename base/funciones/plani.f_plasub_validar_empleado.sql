CREATE OR REPLACE FUNCTION plani.f_plasub_valid_empleado (
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
  v_fecha_ini			date;
BEGIN
	
    v_nombre_funcion = 'plani.f_plasub_valid_empleado';
   
	v_existe = 'no';
	select id_tipo_planilla, per.id_periodo, fecha_ini, fecha_fin, id_uo, p.id_usuario_reg
    into v_planilla 
    from plani.tplanilla p
    inner join param.tperiodo per
    	on p.id_periodo = per.id_periodo
    where p.id_planilla = p_id_planilla;
    v_fecha_ini =  (v_planilla.fecha_ini - interval '2 months')::DATE;
        
    for v_registros in execute('
          select uofun.id_funcionario, uofun.id_funcionario , uofun.id_uo_funcionario,ofi.id_lugar 
          from orga.tuo_funcionario uofun
          inner join orga.tcargo car
              on car.id_cargo = uofun.id_cargo
          inner join orga.ttipo_contrato tc
              on car.id_tipo_contrato = tc.id_tipo_contrato  
          inner join orga.toficina ofi
              on car.id_oficina = ofi.id_oficina 
          where uofun.id_funcionario = ' || p_id_funcionario || ' and tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and 
          	 uofun.fecha_asignacion <= ''' || v_planilla.fecha_fin || ''' and 
              (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= ''' || v_fecha_ini || ''') AND
              uofun.estado_reg != ''inactivo'' and uofun.id_funcionario not in (
                  select id_funcionario
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p
                      on p.id_planilla = fp.id_planilla
                  where 	fp.id_funcionario = uofun.id_funcionario and 
                          p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                          p.id_periodo = ' || v_planilla.id_periodo || ')
          order by uofun.fecha_asignacion desc
          limit 1')loop
    		
          	v_existe = 'si';
            o_id_lugar = v_registros.id_lugar;
            o_id_uo_funcionario = v_registros.id_uo_funcionario;            
            o_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(p_id_funcionario, v_planilla.fecha_fin);
            
  			  	
    end loop;
    if (v_existe = 'no') then
    	raise exception 'No se puede añadir el funcionario a la planilla ya que no le corresponde asignación de subsidio por los periodos trabajados en la empresa';
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