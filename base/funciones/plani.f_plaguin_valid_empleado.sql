--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_plaguin_valid_empleado (
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
  v_cantidad_horas_mes	integer;
  v_resultado			numeric;
  v_tiene_incremento	integer;
  v_id_escala			integer;
  v_fecha_fin_planilla	date;
  v_entra				varchar;
  v_dias				integer;
BEGIN
	
    v_nombre_funcion = 'plani.f_plaguin_valid_empleado';
   
	v_existe = 'no';
	select id_tipo_planilla, p.id_gestion, ges.gestion,id_uo, p.id_usuario_reg,p.fecha_planilla
    into v_planilla 
    from plani.tplanilla p
    inner join param.tgestion ges
    	on p.id_gestion = ges.id_gestion
    where p.id_planilla = p_id_planilla;
    
    if (v_planilla.fecha_planilla >= ('20/12/' || v_planilla.gestion)::date) then
    	v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date;        
    ELSE
    	v_fecha_fin_planilla = v_planilla.fecha_planilla;    	
    end if;
    
    for v_registros in execute('
          select distinct on (uofun.id_funcionario) uofun.id_funcionario , uofun.id_uo_funcionario,ofi.id_lugar,uofun.fecha_asignacion as fecha_ini,
          (case when (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion > ''' || v_fecha_fin_planilla || ''') then 
          	''' || v_fecha_fin_planilla || ''' 
          else 
          	uofun.fecha_finalizacion 
          end) as fecha_fin,uofun.fecha_finalizacion as fecha_fin_real 
          from orga.tuo_funcionario uofun
          inner join orga.tcargo car
              on car.id_cargo = uofun.id_cargo
          inner join orga.ttipo_contrato tc
              on car.id_tipo_contrato = tc.id_tipo_contrato  
          inner join orga.toficina ofi
              on car.id_oficina = ofi.id_oficina 
          where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and  
          coalesce(uofun.fecha_finalizacion,''' || v_fecha_fin_planilla || ''') >= (''01/04/' || v_planilla.gestion ||''')::date and 
            uofun.fecha_asignacion <=  '''|| '31/12/' || v_planilla.gestion || ''' and 
              uofun.estado_reg != ''inactivo'' and uofun.id_funcionario = ' || p_id_funcionario || '  
              and uofun.id_funcionario not in (
                  select id_funcionario
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p
                      on p.id_planilla = fp.id_planilla
                  where 	fp.id_funcionario = uofun.id_funcionario and 
                          p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                          p.id_gestion = ' || v_planilla.id_gestion || ')
          order by uofun.id_funcionario, uofun.fecha_asignacion desc')loop
             
        v_entra = 'si';
        if (v_fecha_fin_planilla != ('31/12/' || v_planilla.gestion)::date) then
        	if (v_registros.fecha_fin_real is null or v_registros.fecha_fin_real > v_fecha_fin_planilla)then
            	v_entra = 'no';
            end if;
        end if;
        v_dias = plani.f_get_dias_aguinaldo(v_registros.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin);
        
        
        if (v_dias >= 90  and v_entra = 'si') then
        	v_existe = 'si'; 
            o_id_lugar = v_registros.id_lugar;
            o_id_uo_funcionario = v_registros.id_uo_funcionario;           
            o_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(p_id_funcionario, v_planilla.fecha_planilla);
        end if; 
  			  	
    end loop;
    if (v_existe = 'no') then
    	raise exception 'No se puede añadir el funcionario a la planilla ya que no le corresponde entrar a esta planilla de aguinaldo';
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