CREATE OR REPLACE FUNCTION plani.f_plaretsub_insert_empleados (
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
  v_fecha_ini			date;  
  v_fecha_fin_planilla	date;
  v_dias				integer;
  v_subsidio_actual		numeric;
  
BEGIN
	
    v_nombre_funcion = 'plani.f_plaretsub_insert_empleados';
    v_filtro_uo = '';
	select id_tipo_planilla, per.id_periodo, fecha_ini, fecha_fin, id_uo, 
    		p.id_usuario_reg,p.fecha_planilla,ges.gestion,p.id_gestion
    into v_planilla 
    from plani.tplanilla p
    left join param.tperiodo per
    	on p.id_periodo = per.id_periodo
    inner join param.tgestion ges
    	on ges.id_gestion = p.id_gestion
    where p.id_planilla = p_id_planilla;
    
    v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date;  
    
    v_subsidio_actual = plani.f_get_valor_parametro_valor('MONTOSUB',v_planilla.fecha_planilla);
        
    if (v_planilla.id_uo is not null) then
    	v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;
        
        
    for v_registros in execute('
          select distinct on (uofun.id_funcionario) uofun.id_funcionario , uofun.id_uo_funcionario,fp.id_lugar,uofun.fecha_asignacion as fecha_ini
          from plani.tfuncionario_planilla fp
          inner join plani.tplanilla p on fp.id_planilla = p.id_planilla
          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
          inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
          where cv.codigo_columna in (''SUBPRE'',''SUBNAT'',''SUBLAC'',''SUBSEP'') and cv.valor < ' || v_subsidio_actual || ' and cv.valor > 0
          and p.id_gestion = ' || v_planilla.id_gestion || ' and '
          	|| v_filtro_uo || ' 
              uofun.estado_reg != ''inactivo'' 
              and uofun.id_funcionario not in (
                  select id_funcionario
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p
                      on p.id_planilla = fp.id_planilla
                  where 	fp.id_funcionario = uofun.id_funcionario and 
                          p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                          p.id_gestion = ' || v_planilla.id_gestion || ')
          order by uofun.id_funcionario, uofun.fecha_asignacion desc')loop
    	  
          if (plani.f_tiene_contrato_activo(v_registros.id_funcionario,v_planilla.fecha_planilla)) then
    	  --En caso de que el empleado ya no trabaje para la empresa es probable que la cuenta bancaria tenga q ser null       
          	v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_planilla);
          end if;
            
          INSERT INTO plani.tfuncionario_planilla (
              id_usuario_reg,					estado_reg,					id_funcionario,
              id_planilla,					id_uo_funcionario,			id_lugar,
              forzar_cheque,					finiquito,					id_afp,
              id_cuenta_bancaria)
          VALUES (
              v_planilla.id_usuario_reg,		'activo',					v_registros.id_funcionario,
              p_id_planilla,					v_registros.id_uo_funcionario,v_registros.id_lugar,
              'no',							'no',						NULL,
              v_id_cuenta_bancaria)
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
                );
          end loop;
        
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