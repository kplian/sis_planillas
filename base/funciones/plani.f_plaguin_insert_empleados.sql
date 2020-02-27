--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_plaguin_insert_empleados (
  p_id_planilla integer
)
RETURNS varchar AS
$body$
 /**************************************************************************
   PLANI
  ***************************************************************************
   SCRIPT:
   COMENTARIOS:
   AUTOR: Jaim Rivera (Kplian)
   DESCRIP:  inserta solo personal vigente que tiene derechi a prima la gestion pasada
   Fecha: 16-10-2019 


    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #95           17-02-2020       Rarteaga KPLIAN     No revisar AFP en registro de funcionarios en planillas de Aguinaldos 
 ********************************************************************************/
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
BEGIN
	
    v_nombre_funcion = 'plani.f_plaguin_insert_empleados';
    v_filtro_uo = '';
	select id_tipo_planilla, per.id_periodo, fecha_ini, fecha_fin, id_uo, p.id_usuario_reg
    into v_planilla 
    from plani.tplanilla p
    inner join param.tperiodo per
    	on p.id_periodo = per.id_periodo
    where p.id_planilla = p_id_planilla;
    
    if (v_planilla.id_uo is not null) then
    	v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;
    
    
    for v_registros in execute('
          select distinct on (uofun.id_funcionario) uofun.id_funcionario , uofun.id_uo_funcionario,ofi.id_lugar,car.id_cargo,
          tc.codigo as tipo_contrato,uofun.fecha_finalizacion  
          from orga.tuo_funcionario uofun
          inner join orga.tcargo car
              on car.id_cargo = uofun.id_cargo
          inner join orga.ttipo_contrato tc
              on car.id_tipo_contrato = tc.id_tipo_contrato  
          left join orga.toficina ofi
              on car.id_oficina = ofi.id_oficina 
          where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and ' 
          	|| v_filtro_uo || ' uofun.fecha_asignacion <= ''' || v_planilla.fecha_fin || ''' and 
              (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= ''' || v_planilla.fecha_ini || ''') AND
              uofun.estado_reg != ''inactivo'' and uofun.id_funcionario not in (
                  select id_funcionario
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p
                      on p.id_planilla = fp.id_planilla
                  where 	fp.id_funcionario = uofun.id_funcionario and 
                          p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                          p.id_periodo = ' || v_planilla.id_periodo || ')
          order by uofun.id_funcionario, uofun.fecha_asignacion desc')loop
    	
       --#95 se comentara para planillas de aguinaldo no necesitamos el dato de la AFP
       -- v_id_afp = plani.f_get_afp(v_registros.id_funcionario, v_planilla.fecha_fin);
        
        
        v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_fin);
        if (v_registros.id_lugar is null) then
        	raise exception 'El cargo con identificador:% , no tiene una oficina asignada',v_registros.id_cargo;
        end if;

	-- verificar que tendra quincena para este periodo: solo si tiene una asignacion hasta fin de mes
	-- y tiene un descuento bono para este periodo

	if (exists (	select 1 
			from plani.tdescuento_bono db
			inner join plani.ttipo_columna tc on db.id_tipo_columna = tc.id_tipo_columna
			where db.estado_reg = 'activo' and db.id_funcionario = v_registros.id_funcionario  
			and tc.codigo = 'QUICENA' and db.fecha_ini <v_planilla.fecha_fin and (db.fecha_fin is null or db.fecha_fin >=v_planilla.fecha_ini)) 
			and (v_registros.fecha_finalizacion is null or v_registros.fecha_finalizacion >= v_planilla.fecha_fin))then
         
		INSERT INTO plani.tfuncionario_planilla (
			id_usuario_reg,					estado_reg,					id_funcionario,
		    id_planilla,					id_uo_funcionario,			id_lugar,
		    forzar_cheque,					finiquito,					id_afp,
		    id_cuenta_bancaria,				tipo_contrato)
		VALUES (
			v_planilla.id_usuario_reg,		'activo',					v_registros.id_funcionario,
		    p_id_planilla,					v_registros.id_uo_funcionario,v_registros.id_lugar,
		    'no',							'no',						 NULL,
		    v_id_cuenta_bancaria,			v_registros.tipo_contrato)
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