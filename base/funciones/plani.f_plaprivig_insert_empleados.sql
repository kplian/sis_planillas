-- FUNCTION: plani.f_plaprivig_insert_empleados(integer)

-- DROP FUNCTION plani.f_plaprivig_insert_empleados(integer);

CREATE OR REPLACE FUNCTION plani.f_plaprivig_insert_empleados(
	p_id_planilla integer)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
 /**************************************************************************
   PLANI
  ***************************************************************************
   SCRIPT:
   COMENTARIOS:
   AUTOR:
   DESCRIP:  inserta a todo el personal al cual le corresponde pago de prima para la gestion
   Fecha: 16-04-2020

    HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 #113              16-04-2020       Rarteaga     KPLIAN    Inserta funcionario para prima de personal vigente
 #113				19.05.2020		Mzambrana	 KPLIAN		Ajuste a funcion por fecha q coincide con la del retiro
 ********************************************************************************/
DECLARE
  v_registros                    record;
  v_planilla                     record;
  v_planilla_prev                record;
  v_planilla_aux                 record;
  v_pla_aux_novig                record;
  v_id_funcionario_planilla      integer;
  v_columnas                     record;
  v_resp                         varchar;
  v_nombre_funcion               text;
  v_mensaje_error                text;
  v_filtro_query                 varchar;
  v_id_afp                       integer;
  v_id_cuenta_bancaria           integer;
  v_fecha_ini                    date;
  v_entra                        varchar;
  v_fecha_fin_planilla           date;
  v_dias                         integer = 0;
  v_tipo_contrato                varchar;
  v_id_funcionario               integer = 0;
  v_bandera                      integer;
  v_main_query                   varchar;

  v_fecha_ini_gestion   date;
  v_fecha_fin_gestion   date;

BEGIN

    v_nombre_funcion = 'plani.f_plaprivig_insert_empleados';
    v_filtro_query = '';

    -- en planillas de prima ponemos la gestion por la cual vamos a pagar la prima
    -- la fecha de la planilla de prima es la fecha en que se va pagar
    -- la planilla de prima tiene costeo por que es solo el pago
    -- cada mes se provisiona en planilla de ajuste de beneficios sociales , en ese momento ejecuta presupeusto y aplica costeo
    -- el descuento de RC-IVA se lo realiza en la siguiente planilla de sueldos

    SELECT p.id_tipo_planilla,
           ges.fecha_ini,
           ges.fecha_fin,
           p.id_uo,
           p.id_usuario_reg,
           p.fecha_planilla,
           ges.gestion,
           p.id_gestion,
           p.id_tipo_contrato,
           p.id_tipo_planilla
    INTO v_planilla
    FROM plani.tplanilla p
    INNER JOIN param.tgestion ges ON ges.id_gestion = p.id_gestion
    WHERE p.id_planilla = p_id_planilla;

    v_fecha_ini_gestion = v_planilla.fecha_ini;
    v_fecha_fin_gestion = v_planilla.fecha_fin;
    --si es necesario filtra los miembro de una determinada UO o por determinado tipo de contrato

    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is not null) then
        v_filtro_query = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and tc.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;

    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is null) then
        v_filtro_query = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;

    if (v_planilla.id_tipo_contrato is not null and v_planilla.id_uo is null)then
       v_filtro_query = 'tcon.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;

    --------------------------------------------------------------------------------------------
    --   para generar esta planilla primero tiene que extar genera la panilla de prevsion de prima
    --   en esta planilla se considera os funcionario insertados previamente
    --   pero solo los que tiene contrato vigente a la fecha
    ------------------------------------------------------------------------------------------

    SELECT
          p.id_planilla,
          p.fecha_planilla,
          p.estado
    INTO v_planilla_prev
    FROM plani.tplanilla p
    INNER JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = p.id_tipo_planilla
    WHERE p.id_gestion = v_planilla.id_gestion
      AND tp.codigo = 'PLAPREPRI';

    --verifica si existe otra planillade personal vigente
    -- esta ambas planillas debe ser de la misma fecha para tener un cálculo exacto
    SELECT
          p.id_planilla,
          p.fecha_planilla,
          p.estado
    INTO v_planilla_aux
    FROM plani.tplanilla p
    INNER JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = p.id_tipo_planilla
    WHERE p.id_gestion = v_planilla.id_gestion
      AND tp.codigo = 'PLAPRIVIG';

    --si exsite alguna prima de no vigentes debe ser de la misma fecha
    SELECT
          p.id_planilla,
          p.fecha_planilla,
          p.estado
    INTO v_pla_aux_novig
    FROM plani.tplanilla p
    INNER JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = p.id_tipo_planilla
    WHERE p.id_gestion = v_planilla.id_gestion
      AND tp.codigo = 'PRINOVIG';

    IF v_planilla_prev IS NULL THEN
       raise exception 'primero  tiene que definir  su planilla de previsiones de prima';
    END IF;

    IF v_planilla_prev.estado != 'finalizado' AND 0!=0  THEN --TODO deja pasar temporalmente
       raise exception 'La planilla de previsiones de prima debe estar finalizada para proceder con la planilla de pagos';
    END IF;

    --verificar si eiste otra planilla del mismo tipo tiene que ser de la misma fecha
    IF v_planilla_aux.fecha_planilla !=  v_planilla.fecha_planilla THEN
       raise exception 'Esta planilla debe tener la misma fecha que las otras planilla de personal vigente para tener un cálculo exacto (%)',v_planilla_aux.fecha_planilla ;
    END IF;

    -- previficar que no exista la plnailla de no vigentes
    IF v_pla_aux_novig.fecha_planilla !=  v_planilla.fecha_planilla THEN
       raise exception 'Esta planilla debe tener la misma fecha que las otras planilla de personal no vigente para tener un cálculo exacto (%)',v_pla_aux_novig.fecha_planilla ;
    END IF;

     v_main_query = '
                     SELECT
                      DISTINCT ON (fp.id_funcionario)
                      fp.id_funcionario,
                      uofun.id_uo_funcionario,
                      ofi.id_lugar,
                      uofun.tipo,
                      car.id_tipo_contrato,
                      uofun.fecha_asignacion,
                      COALESCE(uofun.fecha_finalizacion,''01/01/3000'') as fecha_finalizacion
                      FROM plani.tfuncionario_planilla fp
                      INNER JOIN plani.tcolumna_valor cv ON     cv.id_funcionario_planilla = fp.id_funcionario_planilla
                                                            AND cv.codigo_columna = ''PREPRIMA''
                                                            AND cv.valor > 0
                      INNER JOIN orga.tuo_funcionario uofun ON     fp.id_funcionario = uofun.id_funcionario
                                                               AND (uofun.fecha_finalizacion IS NULL
                                                                     OR
                                                                    uofun.fecha_finalizacion >= '''||v_planilla.fecha_planilla::varchar||'''::Date)  --filtro por la fecha de pago de la planilla  #113
                      INNER JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
                      INNER JOIN orga.toficina ofi ON car.id_oficina = ofi.id_oficina
                      INNER JOIN orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and tcon.codigo in (''PLA'',''EVE'')
                      WHERE uofun.estado_reg != ''inactivo''
                            AND uofun.tipo = ''oficial''
                            AND ' || v_filtro_query  || '   fp.id_planilla = '|| v_planilla_prev.id_planilla ||'
                            AND uofun.id_funcionario NOT IN (
                                                            SELECT id_funcionario
                                                            FROM   plani.tfuncionario_planilla fp
                                                            INNER  JOIN plani.tplanilla p on p.id_planilla = fp.id_planilla
                                                            WHERE     fp.id_funcionario = uofun.id_funcionario
                                                                  AND p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || '
                                                                  AND p.id_gestion = ' || v_planilla.id_gestion || ')
                      ORDER BY   fp.id_funcionario,
                                 fecha_finalizacion DESC ';

     raise notice '%',v_main_query;

    for v_registros in execute(v_main_query)loop

            v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_planilla); --recuperamos la cuenta bancaria a la fecha de la planilla (fecha de pago)
            v_tipo_contrato = plani.f_get_tipo_contrato(v_registros.id_uo_funcionario);

            -- inserta el empelado en la planilla
            INSERT INTO plani.tfuncionario_planilla (
                id_usuario_reg,                    estado_reg,                    id_funcionario,
                id_planilla,                        id_uo_funcionario,            id_lugar,
                forzar_cheque,                    finiquito,                    id_afp,
                id_cuenta_bancaria,                tipo_contrato)
            VALUES (
                v_planilla.id_usuario_reg,        'activo',                        v_registros.id_funcionario,
                p_id_planilla,                    v_registros.id_uo_funcionario,  v_registros.id_lugar,
                'no',                                'no',                            v_id_afp,
                v_id_cuenta_bancaria,                 v_tipo_contrato)
             RETURNING id_funcionario_planilla into v_id_funcionario_planilla;

            v_dias = 0;

            --inserta  la columnas configuradas en la planilla para el empleado
            for v_columnas in (   select *
                                  from plani.ttipo_columna
                                  where id_tipo_planilla = v_planilla.id_tipo_planilla
                                    and estado_reg = 'activo'
                                  order by orden) loop
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
$BODY$;

ALTER FUNCTION plani.f_plaprivig_insert_empleados(integer)
    OWNER TO postgres;