CREATE OR REPLACE FUNCTION plani.f_plaretsub_valid_empleado (
      p_id_usuario integer,
      p_id_funcionario integer,
      p_id_planilla integer,
      p_forzar_cheque varchar,
      p_finiquito varchar,
  out o_id_funcionario_planilla integer,
  out o_tipo_contrato varchar
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
    v_subsidio_actual		numeric;
    v_tipo_planilla		record;
    v_id_columna_valor	integer;
    v_detalle		record;
    v_id_cuenta_bancaria	integer;
  BEGIN

    v_nombre_funcion = 'plani.f_plaretsub_valid_empleado';

    v_existe = 'no';
    select id_tipo_planilla, p.id_gestion, ges.gestion,id_uo, p.id_usuario_reg,p.fecha_planilla
    into v_planilla
    from plani.tplanilla p
      inner join param.tgestion ges
        on p.id_gestion = ges.id_gestion
    where p.id_planilla = p_id_planilla;

    v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', v_fecha_ini)::integer;
    v_subsidio_actual = plani.f_get_valor_parametro_valor('MONTOSUB',v_planilla.fecha_planilla);
    for v_registros in execute('
          select distinct on (uofun.id_funcionario) uofun.id_funcionario , uofun.id_uo_funcionario,fp.id_lugar,uofun.fecha_asignacion as fecha_ini,
          tc.codigo as tipo_contrato
          from plani.tfuncionario_planilla fp
          inner join plani.tplanilla p on fp.id_planilla = p.id_planilla
          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
          inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
          where cv.codigo_columna in (''SUBPRE'',''SUBNAT'',''SUBLAC'',''SUBSEP'') and cv.valor > 0
          and p.id_gestion = ' || v_planilla.id_gestion
                               || ' and uofun.id_funcionario = ' || p_id_funcionario || '
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

      select tp.*,p.id_gestion,p.estado into v_tipo_planilla
      from plani.tplanilla p
        inner join plani.ttipo_planilla tp
          on tp.id_tipo_planilla = p.id_tipo_planilla
      where p.id_planilla = p_id_planilla;

      --Sentencia de la insercion
      insert into plani.tfuncionario_planilla(
        finiquito,
        forzar_cheque,
        id_funcionario,
        id_planilla,
        id_lugar,
        id_uo_funcionario,
        estado_reg,
        id_usuario_reg,
        fecha_reg,
        id_usuario_mod,
        fecha_mod,
        id_afp,
        id_cuenta_bancaria,
        tipo_contrato
      ) values(
        p_finiquito,
        p_forzar_cheque,
        p_id_funcionario,
        p_id_planilla,
        v_registros.id_lugar,
        v_registros.id_uo_funcionario,
        'activo',
        p_id_usuario,
        now(),
        null,
        null,
        plani.f_get_afp(p_id_funcionario, v_planilla.fecha_planilla),
        v_id_cuenta_bancaria,
        v_registros.tipo_contrato

      )RETURNING id_funcionario_planilla into o_id_funcionario_planilla;

      for v_columnas in (	select *
                           from plani.ttipo_columna
                           where id_tipo_planilla = v_tipo_planilla.id_tipo_planilla and estado_reg = 'activo'  order by orden) loop
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
          p_id_usuario,
          'activo',
          v_columnas.id_tipo_columna,
          o_id_funcionario_planilla,
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
            where fp.id_funcionario = p_id_funcionario and  tp.codigo = 'PLASUE' and
                  ht.estado_reg = 'activo' and p.id_gestion = v_tipo_planilla.id_gestion) loop

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
              p_id_usuario,
              v_detalle.id_horas_trabajadas,
              v_id_columna_valor,
              0,
              0
            );

          end loop;
        end if;
      end loop;

      v_existe = 'si';
      o_tipo_contrato = v_registros.tipo_contrato;


    end loop;
    if (v_existe = 'no') then
      raise exception 'No se puede añadir el funcionario a la planilla ya que no le corresponde retroactivo de subsidios';
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