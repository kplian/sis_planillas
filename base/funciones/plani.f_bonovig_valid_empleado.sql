--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_bonovig_valid_empleado (
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
 /**************************************************************************
   PLANI
  ***************************************************************************
   SCRIPT:
   COMENTARIOS:
   AUTOR:    RAC KPLIAN
   DESCRIP:  funcion para vlaidar personal insertado  directamente en planilla de bono de personal vigente
   Fecha: 16-04-2020


    HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 #124             18-05-2020       Rarteaga     KPLIAN    Creación
 ********************************************************************************/
DECLARE
    v_registros             record;
    v_planilla              record;
    v_planilla_prev         record;
    v_columnas              record;
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_existe                varchar;
    v_tiene_incremento      integer;
    v_id_columna_valor      integer;
    v_detalle               record;
    v_main_query            varchar;
BEGIN

    v_nombre_funcion = 'plani.f_bonovig_valid_empleado';

    v_existe = 'no';

    select
        p.id_gestion,
        ges.gestion,id_uo,
        p.id_usuario_reg,
        p.fecha_planilla,
        p.id_tipo_planilla,
        ges.fecha_ini,
        ges.fecha_fin,
        ges.gestion
    into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
    inner join param.tgestion ges on p.id_gestion = ges.id_gestion
    where p.id_planilla = p_id_planilla;

    SELECT
          p.id_planilla,
          p.fecha_planilla,
          p.estado
    INTO v_planilla_prev
    FROM plani.tplanilla p
    INNER JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = p.id_tipo_planilla
    WHERE p.id_gestion = v_planilla.id_gestion
      AND tp.codigo = 'PREBOPRO';




     v_main_query =  'SELECT
                      DISTINCT ON (fp.id_funcionario)
                      fp.id_funcionario,
                      uofun.id_uo_funcionario,
                      ofi.id_lugar,
                      uofun.tipo,
                      car.id_tipo_contrato,
                      uofun.fecha_asignacion,
                      COALESCE(uofun.fecha_finalizacion,''01/01/3000'') as fecha_finalizacion,
                      tcon.codigo as tipo_contrato
                      FROM plani.tfuncionario_planilla fp
                      INNER JOIN plani.tcolumna_valor cv ON     cv.id_funcionario_planilla = fp.id_funcionario_planilla
                                                            AND cv.codigo_columna = ''PREBONO''
                                                            AND cv.valor > 0
                      INNER JOIN orga.tuo_funcionario uofun ON     fp.id_funcionario = uofun.id_funcionario
                                                               AND (uofun.fecha_finalizacion IS NULL
                                                                     OR
                                                                    uofun.fecha_finalizacion > '''||v_planilla.fecha_planilla::varchar||'''::Date)  --filtro por la fecha de pago de la planilla
                      INNER JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
                      INNER JOIN orga.toficina ofi ON car.id_oficina = ofi.id_oficina
                      INNER JOIN orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and tcon.codigo in (''PLA'',''EVE'')
                      WHERE uofun.estado_reg != ''inactivo''
                            AND uofun.tipo = ''oficial''
                            AND uofun.id_funcionario = ' || p_id_funcionario || '
                            AND fp.id_planilla = '|| v_planilla_prev.id_planilla ||'
                            AND uofun.id_funcionario NOT IN (
                                                            SELECT id_funcionario
                                                            FROM   plani.tfuncionario_planilla fp
                                                            INNER  JOIN plani.tplanilla p on p.id_planilla = fp.id_planilla
                                                            WHERE     fp.id_funcionario = uofun.id_funcionario
                                                                  AND p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || '
                                                                  AND p.id_gestion = ' || v_planilla.id_gestion || ')
                      ORDER BY   fp.id_funcionario,
                                 fecha_finalizacion DESC';


    for v_registros in execute(v_main_query)loop


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
            NULL,
            plani.f_get_cuenta_bancaria_empleado(p_id_funcionario, v_planilla.fecha_planilla),
            v_registros.tipo_contrato

            )RETURNING id_funcionario_planilla into o_id_funcionario_planilla;

            for v_columnas in ( select *
                                from plani.ttipo_columna
                                where id_tipo_planilla = v_planilla.id_tipo_planilla and estado_reg = 'activo'  order by orden) loop
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
        raise exception 'No se puede añadir el funcionario a la planilla de prima de personal vigente';
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
PARALLEL UNSAFE
COST 100;