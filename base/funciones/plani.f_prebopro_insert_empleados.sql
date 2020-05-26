-- FUNCTION: plani.f_prebopro_insert_empleados(integer)

-- DROP FUNCTION plani.f_prebopro_insert_empleados(integer);

CREATE OR REPLACE FUNCTION plani.f_prebopro_insert_empleados(
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
   DESCRIP:  inserta a todo el personal al cual le corresponde pago de bono de produccion
   Fecha: 18-05-2020

    HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 #124           18-05-2020        RAC     KPLIAN             creacion
 ********************************************************************************/
DECLARE
  v_registros            record;
  v_planilla            record;
  v_id_funcionario_planilla    integer;
  v_columnas            record;
  v_resp                varchar;
  v_nombre_funcion      text;
  v_mensaje_error       text;
  v_filtro_uo            varchar;
  v_id_afp                integer;
  v_id_cuenta_bancaria    integer;
  v_fecha_ini            date;
  v_entra                varchar;
  v_fecha_fin_planilla    date;
  v_dias                integer = 0;
  v_tipo_contrato        varchar;
  v_id_funcionario        integer = 0;
  v_bandera                integer;
  v_main_query          varchar;

  v_fecha_ini_gestion   date;
  v_fecha_fin_gestion   date;

BEGIN

    v_nombre_funcion = 'plani.f_prebopro_insert_empleados';
    v_filtro_uo = '';

    -- en planillas de prima ponemos la gestion por la cual vamos a pagar la prima
    -- la fecha de la planilla de prima es la fecha en que se va pagar
    -- la planilla de prima tiene costeo por que es solo el pago
    -- cada mes se provisiona en planilla de ajuste de beneficios sociales , en ese momento ejecuta presupeusto y aplica costeo
    -- el descuento de RC-IVA se lo realiza en la siguiente planilla de sueldos

    select
           p.id_tipo_planilla,
           per.id_periodo,
           ges.fecha_ini,
           ges.fecha_fin,
           p.id_uo,
           p.id_usuario_reg,
           p.fecha_planilla,
           ges.gestion,
           p.id_gestion,
           p.id_tipo_contrato
           ,p.id_tipo_planilla -- #113
         into v_planilla
    from plani.tplanilla p
    left join param.tperiodo per on p.id_periodo = per.id_periodo
    inner join param.tgestion ges on ges.id_gestion = p.id_gestion
    where p.id_planilla = p_id_planilla;

    v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date; --se recupera la fecha del ulitmo dia la gestion que vamos a pagar
    v_fecha_ini_gestion = v_planilla.fecha_ini;
    v_fecha_fin_gestion = v_planilla.fecha_fin;
    --si es necesario filtra los miembro de una determinada UO o por determinado tipo de contrato

    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is not null) then
        v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and tc.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;

    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is null) then
        v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;

    if (v_planilla.id_tipo_contrato is not null and v_planilla.id_uo is null)then
       v_filtro_uo = 'tcon.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;

    ------------------------------------------------------------------------------------------------------
    -- si el empleado ya no trabaja en la empresa
    -- no se lo condeira en esta planilla
    -- por que no podemos retenerle el RC-IVA en la siguiente planilla de pago normal
    -----------------------------------------------------------------------------------------------------

    v_main_query = 'WITH 
    
    planta_gestion as (
                       SELECT  DISTINCT uofun.id_funcionario
                       FROM orga.tuo_funcionario uofun   
                       JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
                       JOIN orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and tcon.codigo in (''PLA'')
                       WHERE uofun.estado_reg != ''inactivo''
                         AND uofun.tipo = ''oficial''
                         and uofun.fecha_asignacion  <= '''||v_fecha_fin_gestion||'''
                    ),
    
    base_query as (
                   SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          ofi.id_lugar,
                          plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) AS fecha_primer_cont,

                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < '''||v_fecha_ini_gestion||''' THEN '''||v_fecha_ini_gestion||'''
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > '''|| v_fecha_fin_gestion||''') THEN '''|| v_fecha_fin_gestion||'''
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin,
                          uofun.fecha_asignacion AS fecha_ini_real,
                          COALESCE(uofun.fecha_finalizacion,''3000-01-01'') AS fecha_fin_real,
                          uofun.tipo,
                          car.id_tipo_contrato,
                          uofun.fecha_asignacion,
                          uofun.fecha_finalizacion
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario
                        INNER JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
                        INNER JOIN orga.toficina ofi ON car.id_oficina = ofi.id_oficina
                        inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and tcon.codigo in (''PLA'')
                   WHERE uofun.estado_reg != ''inactivo''
                         AND uofun.tipo = ''oficial''
                          and ' || v_filtro_uo  || '
                          uofun.fecha_asignacion  <= '''|| v_planilla.fecha_planilla||'''  --para filtrar solo la asinacion anterioa la fecha de pago

                          and  uofun.id_funcionario not in (
                                                                                select id_funcionario
                                                                                from plani.tfuncionario_planilla fp
                                                                                inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                                                                where fp.id_funcionario = uofun.id_funcionario and
                                                                                      p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                                                                                      p.id_gestion = ' || v_planilla.id_gestion || ')
                   ORDER BY uofun.id_funcionario,
                            fecha_primer_cont DESC,
                            fecha_fin_real DESC,
                            uofun.id_uo_funcionario DESC

      ),
     filter_query as (
                    SELECT DISTINCT ON (id_funcionario) id_funcionario,
                           id_uo_funcionario,
                           id_lugar,
                           fecha_ini,
                           fecha_fin,
                           fecha_ini_real,
                           fecha_fin_real,
                           tipo,
                           id_tipo_contrato,
                           plani.f_get_dias_aguinaldo(id_funcionario, fecha_ini, fecha_fin) dias,
                           fecha_fin - fecha_ini as dias_real
                    FROM base_query 
      )
         
           SELECT 
             fq.id_funcionario,
             fq.id_uo_funcionario,
             fq.id_lugar,
             fq.fecha_ini,
             fq.fecha_fin,
             fq.fecha_ini_real,
             fq.fecha_fin_real,
             fq.tipo,
             fq.id_tipo_contrato,
             fq.dias,
             fq.dias_real
           FROM filter_query  fq
           JOIN planta_gestion pg ON pg.id_funcionario = fq.id_funcionario ';
                                    

    for v_registros in execute(v_main_query)loop

        v_entra = 'si';
        v_bandera = 0;

        --cuenta cuantos dias de ultimo contrato vigente del funcionario la gestion pasada
       v_dias = v_registros.dias;

              --v_id_funcionario = v_registros.id_funcionario;

              -- si tiene mas de 90 en la gestion pasada
              -- esta vigente y no fue registrado aun en planilla de primas

              if (v_dias >= 90 ) then

                      -- recupera  cuenta bancaria y tipo de contrato
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
                      for v_columnas in (    select *
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
$BODY$;

ALTER FUNCTION plani.f_prebopro_insert_empleados(integer)
    OWNER TO postgres;
