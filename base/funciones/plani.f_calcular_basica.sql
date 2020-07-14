-- FUNCTION: plani.f_calcular_basica(integer, date, date, integer, character varying, integer)

-- DROP FUNCTION plani.f_calcular_basica(integer, date, date, integer, character varying, integer);

CREATE OR REPLACE FUNCTION plani.f_calcular_basica(
	p_id_funcionario_planilla integer,
	p_fecha_ini date,
	p_fecha_fin date,
	p_id_tipo_columna integer,
	p_codigo character varying,
	p_id_columna_valor integer)
    RETURNS numeric
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
  /**************************************************************************
   PLANI
  ***************************************************************************
   SCRIPT:
   COMENTARIOS:
   AUTOR: Jaim Rivera (Kplian)
   DESCRIP: Calcula columnas básicas que necesitan estar definidas en esta funcion
   Fecha: 27/01/2014


    HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 #0               27/01/2014        GUY BOA             Creacion
 #1               22-02-2019        Rarteaga            Integracion con sistema de asistencias
 #2               13-05-2019        Rarteaga            incapidad temporal
 #18              03-07-2019        Rarteaga            restructuracion de codigo
 #20              16-07-2019        Rarteaga            funcion basica para  obtener el factor de disponibilidad
 #21              17/07/2019        RArteaga            Considera carga horaira para calcula trabajadores medio tiempo
 #24              30/07/2019        Rarteaga            columna básica para calculo de reintegro por horas extra
 #25              01/08/2019        Rarteaga            Nuevas colunas para planilla de reintegro mensual
 #35              05/09/2019        RArteaga            Funcion bascia para arastrar el cotizable de las planillas de reintegro REI-PLT
 #36              09/09/2019        RArteaga            Corregir sueldomes cuando la incapacidad temporal lleva cero horas trabajadas
 #37              10/09/2019        RArteaga            Recuperar horas efectivamente trabaja como colulmna basica
 #48              24/09/2019        RArteaga            bug en calculo de haber básico para planillas en meses que no han cerrado
 #51              25/09/2019        RArteaga            Incluir en planilla de retroactivos el reintegro por asignación por sitio de trabajo con incapacidad temporal de la columna  El código es ASIGTRA_I
 #52              25/09/2019        RArteaga            Funcion abasiso para calculo de factor nocturno
 #55              27/09/2019        RArteaga            funciones basicas para recuperar Ufv inicial y final
 #59              30/09/2019        RArteaga            Sueldo según escala menos incapacidad temporal para calculo de horas extra, nocturna y disponibilidad
 #63              22-02-2019        Rarteaga  KPLIAN    cambio de logica de la claculo de dias aguinaldo, DIASAGUI
 #68              17-10-2019        RARTEAGA  KPLIAN    refactorizacion planilla de primas
 #85              23-12-2019        RARTEAGA  KPLIAN    Correcion de funcion basica de calculo de planillas para incluir personal que no recibe incremento salarial en planilla de retroactivos, código columna PRMCOTIZABLE_MES
 #111             08-04-2020        MZM KPLIAN          Correcion a prmcotizable_mes considerando proporcion de horas trabajadas en el mes
 #117             23.04.2020        MZM KPLIAN          Adicion de columnas para manejo de saldo acumulable a favor del fisco en planilla impositiva
 #113             27.04.2020        RAC KPLIAN          Considera arrastre de iva de prima de personal vigente
 #122             30.04.2020        MZM KPLIAN          Funciones para planilla de prevision de primas
 #124             14.05.2020        RAC KPLIAN          Bascia para arrastrar RC-IVA de las planillas de bono de produccion a la planilla de sueldos mensual si la bancera esta activada
 #125             14.05.2020        MZM KPLIAN          Ajuste a funciones para obtencion de fecha_ini-fecha_fin de contratos
 #113             19.05.2020        MZM KPLIAN          Modificacion calculo cotizables para prevision de primas
 #136			  09.06.2020		MZM KPLIAN			Ajuste para calculo de contrato1 para personal odt planilla de prevision de prima			
 #145			  30.06.2020		MZM KPLIAN			Columnas basicas para planilla de prevision de prima SIMPLE
 #151			  14.07.2020		MZM KPLIAN			Control de 90 dias en SPREDIAS1
 ********************************************************************************/
  DECLARE
    v_resp                    varchar;
    v_nombre_funcion          text;
    v_mensaje_error           text;
    v_registros             record;
    v_resultado                numeric;
    v_aux                    numeric;
    v_cantidad_horas_mes    integer;
    v_id_uo_funcionario        integer;
    v_gestion                numeric;
    v_periodo                numeric;
    v_fecha_ini                date;
    v_id_funcionario        integer;
    v_planilla                record;
    v_id_periodo_anterior    integer;
    v_fecha_fin                date;
    v_fecha_plani            date;
    v_resultado_array        numeric[];
    v_array_actual            numeric[];
    v_i                        integer;
    v_tamano_array            integer;
    v_detalle                record;
    v_subsidio_actual        numeric;
    v_max_retro                numeric;
    v_id_funcionario_planilla_mes integer;
    v_fecha_fin_planilla    date;
    v_horas_normales        numeric;

    --meses consecutivos
    v_periodo_total            integer = 0;
    v_periodo_aux            integer = 12;
    v_periodo_array            text[];
    v_periodo_array_aux     integer[];

    v_contador                integer;
    v_dias_total            integer = 0;
    v_dias_asignacion        integer = 0;
    v_aux_2                    integer = 0;
    v_factor_anti            numeric = 0;
    v_hor_norm                numeric = 0;
    --FACTOR ANTIGUEDAD
    v_fecha_ini_actual        date;
    v_nivel_antiguedad        integer;

    v_cantidad_horas_it      integer; --#2 horaa de incapacidad temporal
    v_factor_tiempo         numeric; --#2 factor de tiempo efectivamente trabajado  horan_normales / 240
    v_auxiliar              numeric;
    v_costo_horas_incapcidad  numeric;  --#2
    v_factor_incapcidad_cubierto_empresa  numeric;  --#2
    v_reintegro_sueldoba                  numeric; --#24
    v_bono_ant_original                   numeric; --#25
    v_horas_normales_ht                   integer; --#36
    v_gestion_de_pago                     record; --#68

v_cons    varchar;

  BEGIN
    v_nombre_funcion = 'plani.f_calcular_basica';
    v_resultado = 0;

    select p.*,fp.id_funcionario,tp.periodicidad,tp.codigo,
           uofun.fecha_asignacion,uofun.fecha_finalizacion,ges.gestion,
           per.fecha_ini as fecha_ini_periodo,per.fecha_fin as fecha_fin_periodo,fp.id_uo_funcionario,
           p.id_periodo, uofun.carga_horaria --#21 adiciona carga horaria
    into v_planilla
    from plani.tplanilla p
      inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
      inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
      inner join orga.tuo_funcionario uofun ON uofun.id_uo_funcionario = fp.id_uo_funcionario
      inner join param.tgestion ges on ges.id_gestion = p.id_gestion
      left join param.tperiodo per on per.id_periodo = p.id_periodo
    where fp.id_funcionario_planilla = p_id_funcionario_planilla;


     v_cantidad_horas_mes = v_planilla.carga_horaria; --#21


    IF (p_codigo = 'CARHOR') THEN  --#21 recupera la carga horaria del funcionario
      v_resultado =  v_cantidad_horas_mes;
    ELSIF (p_codigo = 'FACTIEMPO') THEN   --#2 calculo del tiempo efectivamente trabajado en porcentaje
      v_resultado =  (plani.f_get_valor_columna_valor('HORNORM', p_id_funcionario_planilla)::numeric) / v_cantidad_horas_mes::numeric;
    ELSIF (p_codigo = 'SUELDOBA') THEN
      select sum(ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
      into v_resultado
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;

    --#37  recupera la horas efectivas trabajdas en elmes para calculo de incapacidad temporal
    ELSIF (p_codigo = 'HOREFEC') THEN

      select sum(ht.horas_normales)
      into v_horas_normales_ht
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;

      v_resultado =  v_horas_normales_ht;

    --#2 Sueldo Mes , incluye incapacidad temporal y el tiempo trabajado efectivo
    ELSIF (p_codigo = 'SUELDOMES') THEN


      select sum(ht.sueldo * (ht.horas_normales/v_cantidad_horas_mes)), --#14  corrige calculo de sueldo basico
             sum(ht.horas_normales)
      into v_auxiliar,
           v_horas_normales_ht --#36 horas normales de hoja de tiempo
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;


      --el costo por todas las hroas de incapacidad
      v_costo_horas_incapcidad = (v_auxiliar/v_horas_normales_ht) *   --#36 utilia la horas normales segun hoja de tiempo
                                 ( plani.f_get_valor_columna_valor('INCAP_DIAS', p_id_funcionario_planilla)::numeric *
                                 (v_cantidad_horas_mes/30));  --el costo por todas las hroas de incapacidad

      v_factor_incapcidad_cubierto_empresa = 1 - plani.f_get_valor_columna_valor('INCAP_PORC', p_id_funcionario_planilla)::numeric;--porcentaje de incapcidad que cubre la empresa



      v_resultado = (v_auxiliar - v_costo_horas_incapcidad) + --sueldo segun horas efectvamente trabajadas trabajadas
                   (v_costo_horas_incapcidad * v_factor_incapcidad_cubierto_empresa);  -- el monto  que paga la empresa por incapacidad temporal


    --#59 ultimo sueldo segun escala menos incapacidad temporal,
    ELSIF (p_codigo = 'SUELSCL') THEN

      --ultimos sueldo segun escala asignada al trabajador
      v_auxiliar = orga.f_get_haber_basico_a_fecha(( select es.id_escala_salarial
                                                        from orga.tuo_funcionario uofun
                                                          inner join orga.tcargo car on uofun.id_cargo = car.id_cargo
                                                          inner join orga.tescala_salarial es on es.id_escala_salarial = car.id_escala_salarial
                                                        where uofun.id_uo_funcionario = v_planilla.id_uo_funcionario),p_fecha_ini);

      select --sum(ht.sueldo * (ht.horas_normales/v_cantidad_horas_mes)),
             sum(ht.horas_normales)
      into --v_auxiliar,
           v_horas_normales_ht -- horas normales de hoja de tiempo
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;


      --el costo por todas las hroas de incapacidad
      v_costo_horas_incapcidad = (v_auxiliar/v_cantidad_horas_mes) *   -- utilia la horas normales segun hoja de tiempo
                                 ( plani.f_get_valor_columna_valor('INCAP_DIAS', p_id_funcionario_planilla)::numeric *
                                 (v_cantidad_horas_mes/30));  --el costo por todas las hroas de incapacidad

      v_factor_incapcidad_cubierto_empresa = 1 - plani.f_get_valor_columna_valor('INCAP_PORC', p_id_funcionario_planilla)::numeric;--porcentaje de incapcidad que cubre la empresa



      v_resultado = (v_auxiliar - v_costo_horas_incapcidad) + --sueldo segun horas efectvamente trabajadas trabajadas
                   (v_costo_horas_incapcidad * v_factor_incapcidad_cubierto_empresa);  -- el monto  que paga la empresa por incapacidad temporal


    --#25 PRMSUELDOBA  - sueldo para reintegro mensual

    ELSIF (p_codigo = 'PRMSUELDOBA') THEN

          select
                sum(
                       (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) * (ht.horas_normales / v_cantidad_horas_mes) )
                     - (ht.sueldo * (ht.horas_normales/v_cantidad_horas_mes))
                  )
          into
              v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
            inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
            inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and  ht.estado_reg = 'activo'
           and p.id_periodo =  v_planilla.id_periodo
           and p.id_gestion = v_planilla.id_gestion;

    --#1  caculo de sueldo por hora
    ELSIF (p_codigo = 'SUHORA') THEN
      select sum(ht.sueldo / v_cantidad_horas_mes)
      into v_resultado
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;

    --Sueldo Básico para quincena
    ELSIF (p_codigo = 'HABBAS') THEN


      v_resultado = orga.f_get_haber_basico_a_fecha(( select es.id_escala_salarial
                                                      from orga.tuo_funcionario uofun
                                                        inner join orga.tcargo car on uofun.id_cargo = car.id_cargo
                                                        inner join orga.tescala_salarial es on es.id_escala_salarial = car.id_escala_salarial
                                                      where uofun.id_uo_funcionario = v_planilla.id_uo_funcionario),p_fecha_ini);
      --#48 cambio el farametro fecha_fin por fecha_ini
      --OJO las escala no deben variar a medio mes siempe al primer dia del mes

    --Horas Trabajadas
    ELSIF (p_codigo = 'HORNORM') THEN

      v_cantidad_horas_it = plani.f_get_valor_columna_valor('INCAP_DIAS', p_id_funcionario_planilla)::integer;  --#2 replatea el calculo de horas normal , se cinluye la incapacidad temporal

      select sum(ht.horas_normales) - (v_cantidad_horas_it * (v_cantidad_horas_mes/30)) --#2 add v_cantidad_horas_it
      into v_resultado
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;


    --#1  calculo de horas extra
    ELSIF (p_codigo = 'HOREXT') THEN

      select sum(th.extra_autorizada)
      into v_resultado
      from asis.vtotales_horas th

      where     th.id_funcionario = v_planilla.id_funcionario
            and th.id_periodo = v_planilla.id_periodo
            and th.estado = 'aprobado';

    --#1 calculode horas nocturnas
    ELSIF (p_codigo = 'HORNOC') THEN

      select sum(th.total_nocturna)
      into v_resultado
      from asis.vtotales_horas th
      where     th.id_funcionario = v_planilla.id_funcionario
            and th.id_periodo = v_planilla.id_periodo
            and th.estado = 'aprobado';

    --#20 calculo del factor de disponibilidad
    ELSIF (p_codigo = 'FACTDISP') THEN

        SELECT  COALESCE(tcar.factor_disp)
        INTO v_resultado
        FROM orga.tuo_funcionario uofun
        INNER JOIN orga.tcargo car on uofun.id_cargo = car.id_cargo
        LEFT JOIN orga.ttipo_cargo tcar ON tcar.id_tipo_cargo = car.id_tipo_cargo
        WHERE uofun.id_uo_funcionario = v_planilla.id_uo_funcionario;

     --#52 calculo del factor de horas norcturas
    ELSIF (p_codigo = 'FACNOCT') THEN

        SELECT  COALESCE(tcar.factor_nocturno)
        INTO v_resultado
        FROM orga.tuo_funcionario uofun
        INNER JOIN orga.tcargo car on uofun.id_cargo = car.id_cargo
        LEFT JOIN orga.ttipo_cargo tcar ON tcar.id_tipo_cargo = car.id_tipo_cargo
        WHERE uofun.id_uo_funcionario = v_planilla.id_uo_funcionario;


    ELSIF (p_codigo = 'DIALEY') THEN  -- Dias dados por ley
      v_resultado = 0;
      if ( v_cantidad_horas_mes = plani.f_get_valor_columna_valor('HORNORM', p_id_funcionario_planilla)) then
        v_resultado = 10;
      else
        for v_registros in (select *
                            from plani.thoras_trabajadas ht
                            where ht.id_funcionario_planilla = p_id_funcionario_planilla)loop
          if (extract(day from v_registros.fecha_fin) = 31 and extract(dow from v_registros.fecha_fin) in (0,6)) then

            v_resultado = v_resultado - 1;
          elsif (extract(day from v_registros.fecha_fin) = 29 and extract(month from v_registros.fecha_fin) = 2 and
                 pxp.isleapyear(extract(year from v_registros.fecha_fin)::integer) = TRUE) then

            v_resultado = v_resultado + 1;
          elsif (extract(day from v_registros.fecha_fin) = 28 and extract(month from v_registros.fecha_fin) = 2 and
                 pxp.isleapyear(extract(year from v_registros.fecha_fin)::integer) = FALSE) then

            v_resultado = v_resultado + 2;
          end if;
          v_resultado = v_resultado + pxp.f_get_weekend_days(v_registros.fecha_ini, v_registros.fecha_fin);

        end loop;
      end if;
    --Factor de Antiguedad
    ELSIF (p_codigo = 'FACTORANTI') THEN
      select fp.id_uo_funcionario, fp.id_funcionario, uf.fecha_asignacion
      into v_id_uo_funcionario, v_id_funcionario,v_fecha_ini
      from plani.tfuncionario_planilla fp
        inner join orga.tuo_funcionario uf on uf.id_uo_funcionario = fp.id_uo_funcionario
      where fp.id_funcionario_planilla = p_id_funcionario_planilla;



      v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado(v_id_uo_funcionario, v_id_funcionario, v_fecha_ini);

      v_fecha_ini_actual = date(date_part('day', v_fecha_ini)||'/'||date_part('month', v_fecha_ini)||'/'||date_part('year', p_fecha_ini));

      if v_fecha_ini_actual between p_fecha_ini and p_fecha_fin then
        v_gestion:= (select (date_part('year', age(v_fecha_ini_actual, v_fecha_ini))));
        v_periodo:= (select (date_part('month',age(v_fecha_ini_actual, v_fecha_ini))));
      else
          v_gestion:= (select (date_part('year', age(p_fecha_ini, v_fecha_ini))));
          v_periodo:= (select (date_part('month',age(p_fecha_ini, v_fecha_ini))));

      end if;

      v_periodo:= v_periodo + (select coalesce(antiguedad_anterior,0) from orga.tfuncionario f where id_funcionario=v_id_funcionario);

      v_periodo:=(select floor(v_periodo/12));

      select porcentaje
      into v_resultado
      from plani.tantiguedad
      where v_gestion + v_periodo BETWEEN valor_min and valor_max;

    --Prorrateo de Antiguedad
    ELSIF (p_codigo = 'BONOANTG') THEN --#XX   cambio de codigo

        select fp.id_uo_funcionario, fp.id_funcionario, uf.fecha_asignacion
        into v_id_uo_funcionario, v_id_funcionario, v_fecha_ini
        from plani.tfuncionario_planilla fp
          inner join orga.tuo_funcionario uf on uf.id_uo_funcionario = fp.id_uo_funcionario
        where fp.id_funcionario_planilla = p_id_funcionario_planilla;

        -- recupera la fecha de su primer contrato sin interupciones
        v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado(v_id_uo_funcionario, v_id_funcionario, v_fecha_ini);

        -- calcula la fecha donde se cumplira un año para la presente gestion, aniversario contractual

        v_fecha_ini_actual = date(date_part('day', v_fecha_ini)||'/'||date_part('month', v_fecha_ini)||'/'||date_part('year', p_fecha_ini));


        if v_fecha_ini_actual between p_fecha_ini and p_fecha_fin then  --si en el mes de la planilla cumple un año mas de contrato

            v_gestion:= (select (date_part('year', age(v_fecha_ini_actual, v_fecha_ini))));
            v_periodo:= (select (date_part('month',age(v_fecha_ini_actual, v_fecha_ini))));

        else  --si no cumple un año mas de contrato en el mes de la planilla

            v_gestion:= (select (date_part('year', age(p_fecha_ini, v_fecha_ini))));
            v_periodo:= (select (date_part('month',age(p_fecha_ini, v_fecha_ini))));
        end if;

        --si el empleado tiene registrado una antiguedad previa se suman los meses de antiguedad
        v_periodo := v_periodo + (select coalesce(antiguedad_anterior,0) from orga.tfuncionario f where id_funcionario=v_id_funcionario);

        --se convierte los meses en años y se redondeda
        v_periodo := (select floor(v_periodo/12));

        -- total de años de antiguedad calculados
        v_nivel_antiguedad = v_gestion + v_periodo;

        v_resultado = plani.f_calcular_prorrateo_bono_antiguedad(v_nivel_antiguedad, p_id_funcionario_planilla, v_id_funcionario, v_fecha_ini_actual, p_fecha_ini, p_fecha_fin);



    --Factor de Antiguedad
    ELSIF (p_codigo = 'FACTORANTICOMI') THEN
      select fp.id_uo_funcionario, fp.id_funcionario, uf.fecha_asignacion
      into v_id_uo_funcionario, v_id_funcionario,v_fecha_ini
      from plani.tfuncionario_planilla fp
        inner join orga.tuo_funcionario uf on uf.id_uo_funcionario = fp.id_uo_funcionario
      where fp.id_funcionario_planilla = p_id_funcionario_planilla;



      v_periodo:= (select coalesce(antiguedad_anterior,0) from orga.tfuncionario f where id_funcionario=v_id_funcionario);

      v_periodo:=(select floor(v_periodo/12));

      select porcentaje
      into v_resultado
      from plani.tantiguedad
      where v_periodo BETWEEN valor_min and valor_max;
    --Quincena

    ELSIF (p_codigo = 'QUINCE') THEN

      select coalesce(cv.valor,0) into v_resultado
      from plani.tplanilla pla
        inner join plani.ttipo_planilla tp
          on tp.id_tipo_planilla    = pla.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp
          on fp.id_planilla = pla.id_planilla
        inner join plani.tcolumna_valor cv
          on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where tp.codigo = 'PLAQUIN' and pla.estado_reg = 'activo'
            and pla.id_periodo = v_planilla.id_periodo and pla.id_gestion = v_planilla.id_gestion  and cv.codigo_columna = 'LIQPAG' and
            fp.id_funcionario = v_planilla.id_funcionario;
    --Jubilado de 55
    ELSIF (p_codigo = 'JUB55') THEN

      if (v_planilla.codigo = 'PLAREISU') then

        select array_agg(cv.valor order by ht.id_horas_trabajadas asc) into v_resultado_array
        from plani.tplanilla p
          inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
          inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
          inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
          inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
        where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
              ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and cv.codigo_columna = 'JUB55' ;

        v_i = 1;
        FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                            from plani.tcolumna_detalle cd
                              inner join plani.tcolumna_valor cv
                                on cv.id_columna_valor = cd.id_columna_valor
                              inner join plani.thoras_trabajadas ht
                                on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                            where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                            order by ht.id_horas_trabajadas asc) loop
          if (v_detalle.valor = v_detalle.valor_generado) then
            update plani.tcolumna_detalle set
              valor = v_resultado_array[v_i],
              valor_generado = v_resultado_array[v_i]
            where id_columna_detalle = v_detalle.id_columna_detalle;
          end if;
          v_i = v_i + 1;
        end loop;
        v_resultado = 0;

      elseif (v_planilla.codigo = 'PLANRE') then  --#25 jubilado 55 recupera de las planilla mensual correpondiente

          select cv.valor
          into v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
          where  fp.id_funcionario = v_planilla.id_funcionario
            and  tp.codigo = 'PLASUE'
            and p.id_gestion = v_planilla.id_gestion
            and p.id_periodo =  v_planilla.id_periodo
            and cv.codigo_columna = 'JUB55' ;



      else
             if (exists (select 1
                        from plani.tfuncionario_afp fa
                        where fa.estado_reg = 'activo' and fa.tipo_jubilado = 'jubilado_55' AND
                              id_funcionario = v_planilla.id_funcionario and fa.fecha_ini <= p_fecha_ini and
                              (fa.fecha_fin is null or fa.fecha_fin > p_fecha_ini))) then
              v_resultado = 0;
            else
              v_resultado = 1;
            end if;
      end if;

    --Jubilado de 55
    ELSIF (p_codigo = 'MAY55') THEN

      if (v_planilla.codigo = 'PLAREISU') then

        select array_agg(cv.valor order by ht.id_horas_trabajadas asc) into v_resultado_array
        from plani.tplanilla p
          inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
          inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
          inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
          inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
        where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
              ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and cv.codigo_columna = 'MAY55' ;

        v_i = 1;
        FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                            from plani.tcolumna_detalle cd
                              inner join plani.tcolumna_valor cv
                                on cv.id_columna_valor = cd.id_columna_valor
                              inner join plani.thoras_trabajadas ht
                                on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                            where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                            order by ht.id_horas_trabajadas asc) loop
          if (v_detalle.valor = v_detalle.valor_generado) then
            update plani.tcolumna_detalle set
              valor = v_resultado_array[v_i],
              valor_generado = v_resultado_array[v_i]
            where id_columna_detalle = v_detalle.id_columna_detalle;
          end if;
          v_i = v_i + 1;
        end loop;
        v_resultado = 0;
      else


        if (exists (select 1
                    from plani.tfuncionario_afp fa
                    where fa.estado_reg = 'activo' and fa.tipo_jubilado = 'mayor_55' AND
                          id_funcionario = v_planilla.id_funcionario and fa.fecha_ini <= p_fecha_ini and
                          (fa.fecha_fin is null or fa.fecha_fin > p_fecha_ini))) then
          v_resultado = 0;
        else
          v_resultado = 1;
        end if;
      end if;

    --Jubilado de 55
    ELSIF (p_codigo = 'MAY65') THEN

      if (v_planilla.codigo = 'PLAREISU') then

        select array_agg(cv.valor order by ht.id_horas_trabajadas asc) into v_resultado_array
        from plani.tplanilla p
          inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
          inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
          inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
          inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
        where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
              ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and cv.codigo_columna = 'MAY65' ;

        v_i = 1;
        FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                            from plani.tcolumna_detalle cd
                              inner join plani.tcolumna_valor cv
                                on cv.id_columna_valor = cd.id_columna_valor
                              inner join plani.thoras_trabajadas ht
                                on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                            where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                            order by ht.id_horas_trabajadas asc) loop
          if (v_detalle.valor = v_detalle.valor_generado) then
            update plani.tcolumna_detalle set
              valor = v_resultado_array[v_i],
              valor_generado = v_resultado_array[v_i]
            where id_columna_detalle = v_detalle.id_columna_detalle;
          end if;
          v_i = v_i + 1;
        end loop;
        v_resultado = 0;
      else

        if (exists (select 1
                    from plani.tfuncionario_afp fa
                    where fa.estado_reg = 'activo' and fa.tipo_jubilado = 'mayor_65' AND
                          id_funcionario = v_planilla.id_funcionario and fa.fecha_ini <= p_fecha_ini and
                          (fa.fecha_fin is null or fa.fecha_fin > p_fecha_ini))) then
          v_resultado = 0;
        else
          v_resultado = 1;
        end if;
      end if;


    --Jubilado de 65
    ELSIF (p_codigo = 'JUB65') THEN


          if (v_planilla.codigo = 'PLAREISU') then

            select array_agg(cv.valor order by ht.id_horas_trabajadas asc) into v_resultado_array
            from plani.tplanilla p
              inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
              inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
              inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
              inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
              inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
            where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
                  ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and cv.codigo_columna = 'JUB65' ;
            v_i = 1;

            FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                                from plani.tcolumna_detalle cd
                                  inner join plani.tcolumna_valor cv
                                    on cv.id_columna_valor = cd.id_columna_valor
                                  inner join plani.thoras_trabajadas ht
                                    on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                                where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                                order by ht.id_horas_trabajadas asc) loop
              if (v_detalle.valor = v_detalle.valor_generado) then

                update plani.tcolumna_detalle set
                  valor = v_resultado_array[v_i],
                  valor_generado = v_resultado_array[v_i]
                where id_columna_detalle = v_detalle.id_columna_detalle;

              end if;
              v_i = v_i + 1;
            end loop;
            v_resultado = 0;

         elseif (v_planilla.codigo = 'PLANRE') then  -- #25 es planilla de reintegro mensual

              select  cv.valor
              into v_resultado
              from plani.tplanilla p
                  inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                  inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                  inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
              where
                          fp.id_funcionario = v_planilla.id_funcionario
                      and tp.codigo = 'PLASUE'
                      and p.id_gestion = v_planilla.id_gestion
                      and p.id_periodo =  v_planilla.id_periodo
                      and cv.codigo_columna = 'JUB65' ;

          else

            if (exists (select 1
                        from plani.tfuncionario_afp fa
                        where fa.estado_reg = 'activo' and fa.tipo_jubilado = 'jubilado_65' AND
                              id_funcionario = v_planilla.id_funcionario and fa.fecha_ini <= p_fecha_ini and
                              (fa.fecha_fin is null or fa.fecha_fin > p_fecha_ini))) then
              v_resultado = 0;
            else
                v_resultado = 1;
            end if;
        end if;

    --Factor del bono de frontera
    ELSIF (p_codigo = 'FACFRONTERA') THEN
      select coalesce (sum(ht.porcentaje_sueldo),0)
      into v_resultado
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla and
            ht.frontera = 'si';

      v_resultado = v_resultado/100;

    --Factor del bono de frontera
    ELSIF (p_codigo = 'FACFRONTERAPRI') THEN
      select (case when ofi.frontera = 'si' then 0 else 1 end)
      into v_resultado
      from plani.tfuncionario_planilla fp
      inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
      inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
      inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina
      where fp.id_funcionario_planilla = p_id_funcionario_planilla;


    --Factor actualizacion UFV
    ELSIF (p_codigo = 'FAC_ACT') THEN
      v_fecha_ini:=(select pxp.f_ultimo_dia_habil_mes((p_fecha_ini- interval '1 day')::date));
      v_fecha_fin:=(select pxp.f_ultimo_dia_habil_mes(p_fecha_fin));

      v_resultado = param.f_get_factor_actualizacion_ufv(v_fecha_ini, v_fecha_fin);

    --#55  recupera tipo de cambio ufv inicial
     ELSIF (p_codigo = 'UFV_INI') THEN


      v_fecha_ini:=(select pxp.f_ultimo_dia_habil_mes((p_fecha_ini- interval '1 day')::date));

      select oficial
      into v_resultado
      from param.ttipo_cambio tc
      inner join param.tmoneda m on m.id_moneda = tc.id_moneda
      where m.codigo = 'UFV' and tc.fecha = v_fecha_ini and
            tc.estado_reg = 'activo' and m.estado_reg = 'activo';

      IF v_resultado IS NULL THEN
        raise exception 'no existe tipo de cambio para la fecha %',v_fecha_ini;
      END IF;

     --#55  recupera tipo de cambio ufv final
     ELSIF (p_codigo = 'UFV_FIN') THEN

      v_fecha_fin:=(select pxp.f_ultimo_dia_habil_mes(p_fecha_fin));

      select oficial
      into v_resultado
      from param.ttipo_cambio tc
      inner join param.tmoneda m on m.id_moneda = tc.id_moneda
      where m.codigo = 'UFV' and tc.fecha = v_fecha_fin and
            tc.estado_reg = 'activo' and m.estado_reg = 'activo';

      IF v_resultado IS NULL THEN
        raise exception 'no existe tipo de cambio para la fecha %',v_fecha_fin;
      END IF;

    --Saldo del periodo anterior del dependiente
    ELSIF (p_codigo = 'SALDOPERIANTDEP') THEN

      --v_id_periodo_anterior = param.f_get_id_periodo_anterior(v_planilla.id_periodo);

      select   (case when  per.id_periodo is not null then
                           per.fecha_fin
                      else
                         p.fecha_planilla
                       end
                ) as fecha_plani,
               cv.valor
        into
             v_fecha_plani,
             v_resultado
      from plani.tplanilla p
        inner join plani.tfuncionario_planilla fp on p.id_planilla = fp.id_planilla and fp.id_funcionario = v_planilla.id_funcionario
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and cv.codigo_columna = 'SALDODEPSIGPER'
        left join param.tperiodo per on per.id_periodo = p.id_periodo
      where
          (
             (
                   tp.codigo = 'PLASUE'
               and p.id_periodo is not NULL
               and per.fecha_fin < coalesce(v_planilla.fecha_planilla,p_fecha_fin)
             )
             or
             (
                  tp.codigo = 'PLAREISU'
               and p.id_periodo is null
               and p.fecha_planilla < coalesce(v_planilla.fecha_planilla,p_fecha_fin)
             )
          )

      order by fecha_plani desc limit 1;


   -- #2 recuperara cotizable planilla anterior
    ELSIF (p_codigo = 'COTIZABLE_ANT') THEN

      select     (case when per.id_periodo is not null then
        per.fecha_fin
               ELSE
                 p.fecha_planilla
               end) as fecha_plani, cv.valor into v_fecha_plani, v_resultado
      from plani.tplanilla p
        inner join plani.tfuncionario_planilla fp  on p.id_planilla = fp.id_planilla and fp.id_funcionario = v_planilla.id_funcionario
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and
                                              cv.codigo_columna = 'COTIZABLE'
        left join param.tperiodo per on per.id_periodo = p.id_periodo
      where (
                   tp.codigo = 'PLASUE'
               and p.id_periodo is not NULL
               and per.fecha_fin < coalesce(v_planilla.fecha_planilla,p_fecha_fin)

           )
      order by fecha_plani desc limit 1;


    --Factor del zona franca
    ELSIF (p_codigo = 'FAC_ZONAFRAN') THEN

          if (v_planilla.codigo = 'PLAREISU') then

              select sum(cv.valor),sum(1) into v_resultado, v_aux
              from plani.tfuncionario_planilla fp
                inner join plani.tcolumna_valor cv
                  on cv.id_funcionario_planilla = fp.id_funcionario_planilla and cv.codigo_columna = 'FAC_ZONAFRAN'
                inner join plani.tplanilla p
                  on p.id_planilla = fp.id_planilla
                inner join plani.ttipo_planilla tp
                  on p.id_tipo_planilla = tp.id_tipo_planilla
                inner join param.tperiodo per
                  on per.id_periodo = p.id_periodo
              where fp.id_funcionario = v_planilla.id_funcionario and tp.codigo = 'PLASUE' and
                    per.fecha_fin < v_planilla.fecha_planilla and cv.estado_reg = 'activo' and
                    p.id_gestion = v_planilla.id_gestion;

            v_resultado = v_resultado / v_aux;


          elseif (v_planilla.codigo = 'PLANRE') then  --#25 para planilla de reintegro mensual

              select
                  sum(cv.valor),
                  sum(1)
              into
                  v_resultado,
                  v_aux
              from plani.tfuncionario_planilla fp
                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and cv.codigo_columna = 'FAC_ZONAFRAN'
                inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                inner join plani.ttipo_planilla tp on p.id_tipo_planilla = tp.id_tipo_planilla
                inner join param.tperiodo per on per.id_periodo = p.id_periodo
              where    fp.id_funcionario = v_planilla.id_funcionario
                   and tp.codigo = 'PLASUE'
                   and per.fecha_fin < v_planilla.fecha_planilla
                   and cv.estado_reg = 'activo'
                   and p.id_gestion = v_planilla.id_gestion
                   and p.id_periodo =  v_planilla.id_periodo;

              v_resultado = v_resultado / v_aux;

          else
              select coalesce (sum(ht.porcentaje_sueldo),0)
              into v_resultado
              from plani.thoras_trabajadas ht
              where ht.id_funcionario_planilla = p_id_funcionario_planilla and
                    ht.zona_franca = 'si';

              v_resultado = 1-(v_resultado/100);
          end if;

    --Factor del zona franca para la planilla de prima
     --Factor del zona franca para la planilla de prima
    ELSIF (p_codigo = 'FAC_FRONTERAPRI') THEN

      select (case when ofi.zona_franca = 'si' then
        0
              else
                1
              end) into v_resultado
      from orga.tuo_funcionario uofun
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
        inner join orga.toficina ofi on ofi.id_oficina = car.id_oficina
      where uofun.id_uo_funcionario = v_planilla.id_uo_funcionario;



      --#25 calcular la suma de reintegro de RC-IVA para la planilla donde se cobrara el impuesto

      ELSIF (p_codigo = 'REI-RCIVA') THEN

         IF  v_planilla.calcular_reintegro_rciva = 'si'  THEN  -- si la planilla esta configurada para hace el calculo del RC-IVA acumulado

          select
               (cval.valor)
          into
              v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'PRMIMPRCIVA'
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLANRE'
           and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado') --#68 anhade validacion dele stado de planillas
           and p.id_gestion = v_planilla.id_gestion;
        ELSE
          v_resultado := 0;
        END IF;

      --#68 calcular la suma de prima de RC-IVA para la planilla donde se cobrara el impuesto

      ELSIF (p_codigo = 'PRI-RCIVA') THEN  --#68

         IF  v_planilla.calcular_prima_rciva = 'si'  THEN  -- si la planilla esta configurada  hace el calculo del RC-IVA acumulado en planilla de primas

          -- NOTA, la gestion de la prima es la gestion pasada
          -- ejemplo abril 2019 se paga la prima 2018
          -- en la planlla mensual de abrils 2019 cobraremos el RCV-IVA correpndiente a la ultima prima pagada

          --recupera la columna IMPDET , impuesto determinado de la planilla de prima de empleados vigentes PLAPRI
          --para la gestion anterior a nuestra planilla

          select
           ges.fecha_ini,
           ges.fecha_fin
          into v_gestion_de_pago
          from  param.tgestion ges
          where ges.id_gestion  = v_planilla.id_gestion;



            select
                 (cval.valor)
            into
                v_resultado
            from plani.tplanilla p
              inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
              inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
              inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'IMPDET'
            where fp.id_funcionario = v_planilla.id_funcionario
             and  tp.codigo in ('PLAPRI','PLAPRIVIG')     --#113
             and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
             and p.fecha_planilla BETWEEN v_gestion_de_pago.fecha_ini and v_gestion_de_pago.fecha_fin; --buscamos la planilla de prima paga en la gestion donde haremos el descuento

             v_resultado := COALESCE(v_resultado,0);
        ELSE
          v_resultado := 0;
        END IF;
      --#124 calcular la suma de RC-IVA de las planillas de bono de produccion para la planilla donde se cobrara el impuesto
      ELSIF (p_codigo = 'BP-RCIVA') THEN  --#124

         IF  v_planilla.calcular_bono_rciva = 'si'  THEN  -- si la planilla esta configurada  hace el calculo del RC-IVA acumulado en planilla de primas

            --recupera la columna IMPDET , impuesto determinado de la planilla de prima de empleados vigentes BPVIG
            --para la gestion anterior a nuestra planilla

            select
             ges.fecha_ini,
             ges.fecha_fin
            into v_gestion_de_pago
            from  param.tgestion ges
            where ges.id_gestion  = v_planilla.id_gestion;

            select
                 (cval.valor)
            into
                v_resultado
            from plani.tplanilla p
              inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
              inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
              inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'IMPDET'
            where fp.id_funcionario = v_planilla.id_funcionario
             and  tp.codigo in ('BONOVIG')
             and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
             and p.fecha_planilla BETWEEN v_gestion_de_pago.fecha_ini and v_gestion_de_pago.fecha_fin; --buscamos la planilla de prima paga en la gestion donde haremos el descuento

             v_resultado := COALESCE(v_resultado,0);
        ELSE
          v_resultado := 0;
        END IF;


      --#35 calcular la suma de total de reintegro pagado, en las planillas de reintegro mensual previas
      ELSIF (p_codigo = 'REI-PLT') THEN

         IF  v_planilla.calcular_reintegro_rciva = 'si'  THEN  -- si la planilla esta configurada para hace el calculo del RC-IVA acumulado

          select
               (cval.valor)
          into
              v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'PRMCOTIZABLE'
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLANRE'
           and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado') --#68 anhade vaidacion del estado de planillas
           and p.id_gestion = v_planilla.id_gestion;
        ELSE
          v_resultado := 0;
        END IF;


      --#25 calculo de reintegro por horas extra para planilla de reintegro mensual

      ELSIF (p_codigo = 'PRMEXTRA') THEN

          --recuperar sueldo segun escala salarial

          v_reintegro_sueldoba = plani.f_get_valor_columna_valor('PRMSUELDOBA', p_id_funcionario_planilla); -- recupera el reintegro de sueldo basico

          select
               ( (cval.valor * v_reintegro_sueldoba) / cval_s.valor )
          into
              v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'EXTRA'
            inner join plani.tcolumna_valor cval_s ON  cval_s.id_funcionario_planilla = fp.id_funcionario_planilla and cval_s.codigo_columna = 'SUELDOMES'
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado') --#68 anhade vaidacion del estado de planillas
           and p.id_periodo =  v_planilla.id_periodo
           and p.id_gestion = v_planilla.id_gestion;

     --#25 calculo de reintegro por horas nocturan con regla de 2 para planilla de reintegro mensual

      ELSIF (p_codigo = 'PRMNOCTURNO') THEN

          --recuperar sueldo segun escala salarial

          v_reintegro_sueldoba = plani.f_get_valor_columna_valor('PRMSUELDOBA', p_id_funcionario_planilla); -- recupera el reintegro de sueldo basico

          select
               ( (cval.valor * v_reintegro_sueldoba) / cval_s.valor )
          into
              v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'NOCTURNO'
            inner join plani.tcolumna_valor cval_s ON  cval_s.id_funcionario_planilla = fp.id_funcionario_planilla and cval_s.codigo_columna = 'SUELDOMES'
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado') --#68 anhade vaidacion del estado de planillas
           and p.id_periodo =  v_planilla.id_periodo
           and p.id_gestion = v_planilla.id_gestion;

      --#25 calculo de reintegro por disponibilidad con regla de 2 para planilla de reintegro mensual

      ELSIF (p_codigo = 'PRMDISPONIBILIDAD') THEN

          --recuperar sueldo segun escala salarial

          v_reintegro_sueldoba = plani.f_get_valor_columna_valor('PRMSUELDOBA', p_id_funcionario_planilla); -- recupera el reintegro de sueldo basico

          select
               ( (cval.valor * v_reintegro_sueldoba) / cval_s.valor )
          into
              v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'DISPONIBILIDAD'
            inner join plani.tcolumna_valor cval_s ON  cval_s.id_funcionario_planilla = fp.id_funcionario_planilla and cval_s.codigo_columna = 'SUELDOMES'
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado') --#68 anhade vaidacion del estado de planillas
           and p.id_periodo =  v_planilla.id_periodo
           and p.id_gestion = v_planilla.id_gestion;

    -- #25 reintegro por leactancia prenatal planila  mensual de reintegros
    ELSIF (p_codigo = 'PRMLACPRE') THEN


      v_subsidio_actual = plani.f_get_valor_parametro_valor('MONTOSUB',v_planilla.fecha_planilla);

      select sum(v_subsidio_actual - cv.valor)
      into v_resultado
      from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on fp.id_planilla = p.id_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where    fp.id_funcionario = v_planilla.id_funcionario
           and cv.estado_reg = 'activo'
           and p.id_gestion = v_planilla.id_gestion
           and p.id_periodo =  v_planilla.id_periodo
           and cv.codigo_columna in ('SUBLAC','SUBPRE')
           and cv.valor < v_subsidio_actual
           and cv.valor > 0;

    -- #25 PRMBONFRONTERA    bono frontera para reintegro de sueldos mensual

    ELSIF (p_codigo = 'PRMBONFRONTERA') THEN


      select sum(
                  case when orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo then

                     (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales * 0.2 * cv.valor) -
                     (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales * 0.2 * cv.valor)
                  else
                    0
                  end)

      into v_resultado
      from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where    fp.id_funcionario = v_planilla.id_funcionario
          and  tp.codigo = 'PLASUE'
          and  p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado') --#68 anhade vaidacion del estado de planillas
          and  ht.estado_reg = 'activo'
          and  p.id_gestion = v_planilla.id_gestion
          and  p.id_periodo =  v_planilla.id_periodo
          and  cv.codigo_columna = 'FACFRONTERA' ;

     -- #25 PRMNATSEP,  reintegro natalidad y sepeio planilla reintegro mensual

    ELSIF (p_codigo = 'PRMNATSEP') THEN

      v_subsidio_actual = plani.f_get_valor_parametro_valor('MONTOSUB',v_planilla.fecha_planilla);

      select
          sum(v_subsidio_actual - cv.valor)
      into v_resultado
      from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on fp.id_planilla = p.id_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where
                fp.id_funcionario = v_planilla.id_funcionario
            and cv.estado_reg = 'activo'
            and p.id_gestion = v_planilla.id_gestion
            and p.id_periodo =  v_planilla.id_periodo
            and cv.codigo_columna in ('SUBNAT','SUBSEP')
            and cv.valor < v_subsidio_actual
            and cv.valor > 0;

    -- #25 reintegro de bono de antiguedad mensual
    ELSIF (p_codigo = 'PRMBONOANTG') THEN


        select
            fp.id_uo_funcionario,
            fp.id_funcionario,
            uf.fecha_asignacion
        into
           v_id_uo_funcionario,
           v_id_funcionario,
           v_fecha_ini
        from plani.tfuncionario_planilla fp
        inner join orga.tuo_funcionario uf on uf.id_uo_funcionario = fp.id_uo_funcionario
        where fp.id_funcionario_planilla = p_id_funcionario_planilla;



         -- recupera el bono de antiguedad asignado en el mes original
        select
                cval.valor
          into
               v_bono_ant_original
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'BONOANTG'
        where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and p.id_periodo =  v_planilla.id_periodo
           and p.id_gestion = v_planilla.id_gestion;





        -- recupera la fecha de su primer contrato sin interupciones
        v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado(v_id_uo_funcionario, v_id_funcionario, v_fecha_ini);

        -- calcula la fecha donde se cumplira un año para la presente gestion, aniversario contractual

        v_fecha_ini_actual = date(date_part('day', v_fecha_ini)||'/'||date_part('month', v_fecha_ini)||'/'||date_part('year', p_fecha_ini));


        if v_fecha_ini_actual between p_fecha_ini and p_fecha_fin then  --si en el mes de la planilla cumple un año mas de contrato

            v_gestion:= (select (date_part('year', age(v_fecha_ini_actual, v_fecha_ini))));
            v_periodo:= (select (date_part('month',age(v_fecha_ini_actual, v_fecha_ini))));

        else  --si no cumple un año mas de contrato en el mes de la planilla

            v_gestion:= (select (date_part('year', age(p_fecha_ini, v_fecha_ini))));
            v_periodo:= (select (date_part('month',age(p_fecha_ini, v_fecha_ini))));
        end if;

        --si el empleado tiene registrado una antiguedad previa se suman los meses de antiguedad
        v_periodo := v_periodo + (select coalesce(antiguedad_anterior,0) from orga.tfuncionario f where id_funcionario=v_id_funcionario);

        --se convierte los meses en años y se redondeda
        v_periodo := (select floor(v_periodo/12));

        -- total de años de antiguedad calculados
        v_nivel_antiguedad = v_gestion + v_periodo;

        v_resultado = plani.f_calcular_prorrateo_bono_antiguedad(v_nivel_antiguedad, p_id_funcionario_planilla, v_id_funcionario, v_fecha_ini_actual, p_fecha_ini, p_fecha_fin, 'SI',v_planilla.fecha_planilla );

        v_resultado = v_resultado - v_bono_ant_original;


    --#25 PRMBANT   reintegro mensual de bono de antiguedad

    ELSIF (p_codigo = 'PRMBANT') THEN

     IF v_planilla.id_funcionario  =  320 THEN
       -- raise exception '%,%,%,%', v_planilla.id_gestion, v_planilla.id_periodo, v_planilla.fecha_planilla  , v_cantidad_horas_mes;
     END IF;

      select sum(
                  (
                    (plani.f_get_valor_parametro_valor('SALMIN', v_planilla.fecha_planilla)*cv.valor/100*3)* (ht.horas_normales/v_cantidad_horas_mes)
                  )
                 -
                  (
                    (plani.f_get_valor_parametro_valor('SALMIN', per.fecha_fin)*cv.valor/100*3) * (ht.horas_normales / v_cantidad_horas_mes)
                  )
                )
       into v_resultado
      from plani.tplanilla p
        inner join param.tperiodo per on per.id_periodo = p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where
                 fp.id_funcionario = v_planilla.id_funcionario
            and  tp.codigo = 'PLASUE'
            and  cv.estado_reg = 'activo'
            and  p.id_gestion = v_planilla.id_gestion
            and  p.id_periodo =  v_planilla.id_periodo
            and  cv.codigo_columna = 'FACTORANTI';

    --#51 PRMASIGTRA   reintegro por asignación por sitio de trabajo

     ELSIF (p_codigo = 'PRMASIGTRA') THEN

          --recuperar sueldo segun escala salarial

          v_reintegro_sueldoba = plani.f_get_valor_columna_valor('PRMSUELDOBA', p_id_funcionario_planilla); -- recupera el reintegro de sueldo basico

          select
               ( (cval.valor * v_reintegro_sueldoba) / cval_s.valor )
          into
              v_resultado
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'ASIGTRA_IT'
            inner join plani.tcolumna_valor cval_s ON  cval_s.id_funcionario_planilla = fp.id_funcionario_planilla and cval_s.codigo_columna = 'SUELDOMES'
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and p.id_periodo =  v_planilla.id_periodo
           and p.id_gestion = v_planilla.id_gestion;


    --#25  cotizable para reintegro mensual

    ELSIF (p_codigo = 'PRMCOTIZABLE_MES') THEN

      -- recupera el meaximo suledo para retroactivos
      v_max_retro = plani.f_get_valor_parametro_valor('MAXRETROSUE', p_fecha_ini)::integer;

      select sum(  case when ( orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) >= ht.sueldo ) then  --#85 considera mayor o igual

                    cv.valor*ht.porcentaje_sueldo/100 --#111
                  else
                    0
                  end)
       into v_resultado
      from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and
                                              cv.codigo_columna = 'COTIZABLE' and cv.estado_reg = 'activo'
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
      where
                 fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and  ht.estado_reg = 'activo'
           and p.id_gestion = v_planilla.id_gestion
           and p.id_periodo =  v_planilla.id_periodo;



    ELSIF (p_codigo = 'REISUELDOBA') THEN  --#24 refactorizacion

          v_max_retro = plani.f_get_valor_parametro_valor('MAXRETROSUE', p_fecha_ini)::integer;


          select
                array_agg(
                            (

                             case when (     orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
                                         and orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then

                                          (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales) -
                                          (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
                                  else
                                           0
                                   end
                            ) order by ht.id_horas_trabajadas asc
                         )
          into
              v_resultado_array
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
            inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
            inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and  ht.estado_reg = 'activo'
           and p.id_gestion = v_planilla.id_gestion;


          v_resultado = 0;
          v_i = 1;

          FOR v_detalle in (  select cd.id_columna_detalle,
                                     cd.valor,
                                     cd.valor_generado
                              from plani.tcolumna_detalle cd
                              inner join plani.tcolumna_valor cv on cv.id_columna_valor = cd.id_columna_valor
                              inner join plani.thoras_trabajadas ht on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                              where cv.id_columna_valor = p_id_columna_valor
                                and cv.estado_reg = 'activo'
                              order by ht.id_horas_trabajadas asc) LOOP

                if (v_detalle.valor = v_detalle.valor_generado) then

                  update plani.tcolumna_detalle set
                    valor = coalesce(v_resultado_array[v_i], 0),
                    valor_generado = coalesce(v_resultado_array[v_i], 0)
                  where id_columna_detalle = v_detalle.id_columna_detalle;

                  v_resultado = v_resultado + v_resultado_array[v_i];
                else
                  v_resultado = v_resultado + v_detalle.valor;
                end if;

                v_i = v_i + 1;

          END LOOP;

    ELSIF (p_codigo = 'REIEXTRA') THEN  --#24 calculo de reintegro por horas extra

          --recuperar sueldo segun escala salarial


          v_reintegro_sueldoba = plani.f_get_valor_columna_valor('REISUELDOBA', p_id_funcionario_planilla); -- recupera el reintegro de sueldo basico

          select
                array_agg(
                            ( (cval.valor * v_reintegro_sueldoba) / cval_s.valor ) order by p.id_planilla asc
                         )
          into
              v_resultado_array
          from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
            inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
            inner join plani.tcolumna_valor cval ON  cval.id_funcionario_planilla = fp.id_funcionario_planilla and cval.codigo_columna = 'EXTRA'
            inner join plani.tcolumna_valor cval_s ON  cval_s.id_funcionario_planilla = fp.id_funcionario_planilla and cval_s.codigo_columna = 'SUELDOMES'


          where fp.id_funcionario = v_planilla.id_funcionario
           and  tp.codigo = 'PLASUE'
           and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado') --#68 anhade vaidacion del estado de planillas
           and p.id_gestion = v_planilla.id_gestion;


          v_resultado = 0;
          v_i = 1;

          FOR v_detalle in (  select cd.id_columna_detalle,
                                     cd.valor,
                                     cd.valor_generado
                              from plani.tcolumna_detalle cd
                              inner join plani.tcolumna_valor cv on cv.id_columna_valor = cd.id_columna_valor
                              inner join plani.thoras_trabajadas ht on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                              where cv.id_columna_valor = p_id_columna_valor
                                and cv.estado_reg = 'activo'
                              order by ht.id_horas_trabajadas asc) LOOP

                if (v_detalle.valor = v_detalle.valor_generado) then

                  update plani.tcolumna_detalle set
                    valor = coalesce(v_resultado_array[v_i], 0),
                    valor_generado = coalesce(v_resultado_array[v_i], 0)
                  where id_columna_detalle = v_detalle.id_columna_detalle;

                  v_resultado = v_resultado + v_resultado_array[v_i];
                else
                  v_resultado = v_resultado + v_detalle.valor;
                end if;

                v_i = v_i + 1;

          END LOOP;



    ELSIF (p_codigo = 'COTIZABLE_MES') THEN
      v_max_retro = plani.f_get_valor_parametro_valor('MAXRETROSUE', p_fecha_ini)::integer;


      select sum( case when (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
                             and orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then

        cv.valor
                  else
                    0
                  end),
        array_agg( (case when (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
                               and orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then

          cv.valor
                    else
                      0
                    end) order by ht.id_horas_trabajadas asc) into v_resultado, v_resultado_array
      from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and
                                              cv.codigo_columna = 'COTIZABLE' and cv.estado_reg = 'activo'
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
      where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
            ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion;

      v_resultado = 0;
      v_i = 1;

      FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                          from plani.tcolumna_detalle cd
                            inner join plani.tcolumna_valor cv
                              on cv.id_columna_valor = cd.id_columna_valor
                            inner join plani.thoras_trabajadas ht
                              on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                          where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                          order by ht.id_horas_trabajadas asc) loop

        if (v_detalle.valor = v_detalle.valor_generado) then

          update plani.tcolumna_detalle set
            valor = v_resultado_array[v_i],
            valor_generado = v_resultado_array[v_i]
          where id_columna_detalle = v_detalle.id_columna_detalle;
          v_resultado = v_resultado + v_resultado_array[v_i];
        else
          v_resultado = v_resultado + v_detalle.valor;
        end if;
        v_i = v_i + 1;
      end loop;

    ELSIF (p_codigo = 'REINBANT') THEN


      select sum(((plani.f_get_valor_parametro_valor('SALMIN', v_planilla.fecha_planilla)*cv.valor/100*3)*
                  (ht.horas_normales/v_cantidad_horas_mes))
                 -
                 ((plani.f_get_valor_parametro_valor('SALMIN', per.fecha_fin)*cv.valor/100*3)*
                  (ht.horas_normales/v_cantidad_horas_mes)) ),
        array_agg(((plani.f_get_valor_parametro_valor('SALMIN', v_planilla.fecha_planilla)*cv.valor/100*3)*
                   (ht.horas_normales/v_cantidad_horas_mes))
                  -
                  ((plani.f_get_valor_parametro_valor('SALMIN', per.fecha_fin)*cv.valor/100*3)*
                   (ht.horas_normales/v_cantidad_horas_mes)) order by ht.id_horas_trabajadas asc) into v_resultado,v_resultado_array
      from plani.tplanilla p
        inner join param.tperiodo per on per.id_periodo = p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
            cv.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and cv.codigo_columna = 'FACTORANTI';
      v_tamano_array = array_length(v_resultado_array,1);

      v_resultado = 0;
      v_i = 1;
      FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                          from plani.tcolumna_detalle cd
                            inner join plani.tcolumna_valor cv
                              on cv.id_columna_valor = cd.id_columna_valor
                            inner join plani.thoras_trabajadas ht
                              on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                          where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                          order by ht.id_horas_trabajadas asc) loop
        if (v_detalle.valor = v_detalle.valor_generado) then
          update plani.tcolumna_detalle set
            valor = v_resultado_array[v_i],
            valor_generado = v_resultado_array[v_i]
          where id_columna_detalle = v_detalle.id_columna_detalle;
          v_resultado = v_resultado + v_resultado_array[v_i];
        else
          v_resultado = v_resultado + v_detalle.valor;
        end if;
        v_i = v_i + 1;
      end loop;

    ELSIF (p_codigo = 'REINBANTCOMI') THEN


      select sum(((plani.f_get_valor_parametro_valor('SALMIN', v_planilla.fecha_planilla)*cv.valor/100*3)*
                  (ht.horas_normales/v_cantidad_horas_mes))
                 -
                 ((plani.f_get_valor_parametro_valor('SALMIN', per.fecha_fin)*cv.valor/100*3)*
                  (ht.horas_normales/v_cantidad_horas_mes)) ),
        array_agg(((plani.f_get_valor_parametro_valor('SALMIN', v_planilla.fecha_planilla)*cv.valor/100*3)*
                   (ht.horas_normales/v_cantidad_horas_mes))
                  -
                  ((plani.f_get_valor_parametro_valor('SALMIN', per.fecha_fin)*cv.valor/100*3)*
                   (ht.horas_normales/v_cantidad_horas_mes)) order by ht.id_horas_trabajadas asc) into v_resultado,v_resultado_array
      from plani.tplanilla p
        inner join param.tperiodo per on per.id_periodo = p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
            cv.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and cv.codigo_columna = 'FACTORANTICOMI';
      v_tamano_array = array_length(v_resultado_array,1);

      v_resultado = 0;
      v_i = 1;
      FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                          from plani.tcolumna_detalle cd
                            inner join plani.tcolumna_valor cv
                              on cv.id_columna_valor = cd.id_columna_valor
                            inner join plani.thoras_trabajadas ht
                              on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                          where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                          order by ht.id_horas_trabajadas asc) loop
        if (v_detalle.valor = v_detalle.valor_generado) then
          update plani.tcolumna_detalle set
            valor = v_resultado_array[v_i],
            valor_generado = v_resultado_array[v_i]
          where id_columna_detalle = v_detalle.id_columna_detalle;
          v_resultado = v_resultado + v_resultado_array[v_i];
        else
          v_resultado = v_resultado + v_detalle.valor;
        end if;
        v_i = v_i + 1;
      end loop;

    ELSIF (p_codigo = 'BONFRONTERA') THEN


      select sum( case when orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo then

        (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales * 0.2 * cv.valor) -
        (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales * 0.2 * cv.valor)
                  else
                    0
                  end),
        array_agg((case when orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo then

          (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales * 0.2 * cv.valor) -
          (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales * 0.2 * cv.valor)
                   else
                     0
                   end) order by ht.id_horas_trabajadas asc) into v_resultado,v_resultado_array
      from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
            ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and cv.codigo_columna = 'FACFRONTERA' ;
      v_tamano_array = array_length(v_resultado_array,1);

      v_resultado = 0;
      v_i = 1;
      FOR v_detalle in (    select cd.id_columna_detalle, cd.valor,cd.valor_generado
                          from plani.tcolumna_detalle cd
                            inner join plani.tcolumna_valor cv
                              on cv.id_columna_valor = cd.id_columna_valor
                            inner join plani.thoras_trabajadas ht
                              on ht.id_horas_trabajadas = cd.id_horas_trabajadas
                          where cv.id_columna_valor = p_id_columna_valor and cv.estado_reg = 'activo'
                          order by ht.id_horas_trabajadas asc) loop
        if (v_detalle.valor = v_detalle.valor_generado) then
          update plani.tcolumna_detalle set
            valor = v_resultado_array[v_i],
            valor_generado = v_resultado_array[v_i]
          where id_columna_detalle = v_detalle.id_columna_detalle;
          v_resultado = v_resultado + v_resultado_array[v_i];
        else
          v_resultado = v_resultado + v_detalle.valor;
        end if;
        v_i = v_i + 1;
      end loop;

    --Factor del zona franca
    ELSIF (p_codigo = 'RETLACPRE') THEN
      v_subsidio_actual = plani.f_get_valor_parametro_valor('MONTOSUB',v_planilla.fecha_planilla);

      select sum(v_subsidio_actual - cv.valor) into v_resultado
      from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on fp.id_planilla = p.id_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where fp.id_funcionario = v_planilla.id_funcionario and cv.estado_reg = 'activo' and
            p.id_gestion = v_planilla.id_gestion and cv.codigo_columna in ('SUBLAC','SUBPRE') and
            cv.valor < v_subsidio_actual and cv.valor > 0;

    ELSIF (p_codigo = 'RETNATSEP') THEN
      v_subsidio_actual = plani.f_get_valor_parametro_valor('MONTOSUB',v_planilla.fecha_planilla);

      select sum(v_subsidio_actual - cv.valor) into v_resultado
      from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on fp.id_planilla = p.id_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
      where fp.id_funcionario = v_planilla.id_funcionario and cv.estado_reg = 'activo' and
            p.id_gestion = v_planilla.id_gestion and cv.codigo_columna in ('SUBNAT','SUBSEP') and
            cv.valor < v_subsidio_actual and cv.valor > 0;
    ELSIF(p_codigo = 'PROMSUEL1') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 0;

      SELECT sum(COALESCE(cv.valor,0)) into v_aux
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONANT', 'BONFRONTERA') and cv.estado_reg = 'activo';

      select sum(ht.sueldo * ht.porcentaje_sueldo/100) into v_resultado
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
      v_resultado = v_resultado + v_aux;



    ELSIF(p_codigo = 'PROMSUEL2') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 1;

      SELECT sum(COALESCE(cv.valor,0)) into v_aux
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONANT', 'BONFRONTERA') and cv.estado_reg = 'activo';

      select sum(ht.sueldo * ht.porcentaje_sueldo/100) into v_resultado
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
      v_resultado = v_resultado + v_aux;

    ELSIF(p_codigo = 'PROMSUEL3') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 2;

      SELECT sum(COALESCE(cv.valor,0)) into v_aux
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONANT', 'BONFRONTERA') and cv.estado_reg = 'activo';

      select sum(coalesce(ht.sueldo * ht.porcentaje_sueldo/100, 0)) into v_resultado
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
      v_resultado = v_resultado + v_aux;

      if (v_resultado = 0 or v_resultado is null) then
        select cv.valor into v_resultado
        from plani.tcolumna_valor cv
        where cv.id_funcionario_planilla = p_id_funcionario_planilla and
              cv.estado_reg = 'activo' and cv.codigo_columna = 'PROMSUEL2';

      end if;

    ELSIF(p_codigo = 'PROMPRI1') THEN

      -- lista las planillas de sueldo del empleado de manera descendiente, de la ultima  hacia la primeras
      for v_registros in (select  pe.periodo,
                                  fp.id_funcionario_planilla
                          from plani.tfuncionario_planilla fp
                          inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                          inner join orga.tfuncionario fun on     fun.id_funcionario = fp.id_funcionario
                                                              and fun.id_funcionario = v_planilla.id_funcionario
                          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                          inner join param.tperiodo pe on pe.id_periodo = p.id_periodo
                          inner join plani.ttipo_planilla tp on     tp.id_tipo_planilla = p.id_tipo_planilla
                                                                and tp.codigo = 'PLASUE'
                                                                and p.estado not in ('registros_horas', 'registro_funcionarios', 'calculo_columnas', 'anulado')
                                                                and p.id_gestion = v_planilla.id_gestion
                          group by  fp.id_funcionario_planilla,
                                    pe.periodo
                          order by  pe.periodo desc) loop


            -- cuenta cuantos cargos distintos en el mes y suma las horas del mes del empleado
            select
                  count(tht.id_funcionario_planilla),
                  sum(tht.horas_normales)
            into
                  v_contador,
                  v_horas_normales
            from plani.thoras_trabajadas tht
            where tht.id_funcionario_planilla = v_registros.id_funcionario_planilla;

            -- v_periodo_aux es 12 ( = diciembre),
            -- y si el empleado tiene el total de horas trabajadas segun carga horaria
            -- si a trabajado todo el año
            if v_registros.periodo = v_periodo_aux and v_horas_normales = v_cantidad_horas_mes then

                v_periodo_total =  v_periodo_total + 1;
                v_periodo_aux = v_periodo_aux - 1;

                v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];

                if v_periodo_total = 3 then
                    exit;
                end if;

            else  -- si no a tabajado todo el año

                if v_horas_normales = v_cantidad_horas_mes then
                  v_periodo_total = 1;
                  v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
                  v_periodo_aux = v_registros.periodo - 1;
                end if;

            end if;

      end loop;

      v_periodo_array_aux = v_periodo_array[1]::integer[];

      -- obtiene el funcionario de la planilla  del primes mes completo
      select
           fp.id_funcionario_planilla,
           ht.id_uo_funcionario
      into
           v_id_funcionario_planilla_mes,
           v_id_uo_funcionario
      from plani.tfuncionario_planilla fp
      inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
      inner join orga.tfuncionario fun on     fun.id_funcionario = fp.id_funcionario
                                          and fun.id_funcionario = v_planilla.id_funcionario
      inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
      inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
      inner join plani.ttipo_planilla tp on      tp.id_tipo_planilla=p.id_tipo_planilla
                                            and tp.codigo ='PLASUE'
                                            and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                            and p.id_gestion=v_planilla.id_gestion
                                            and pe.periodo = v_periodo_array_aux[1]
      order by  pe.periodo desc
      limit 1;

      --recupera la fecha de fin fr asignacion del funcionario
      select tuo.fecha_finalizacion
      into v_fecha_fin
      from orga.tuo_funcionario tuo
      where tuo.id_uo_funcionario = v_id_uo_funcionario;

      if  v_periodo_array_aux[1] >= 8 and (v_fecha_fin > '31/07/2017'::date or v_fecha_fin is null) then

        SELECT sum(COALESCE(cv.valor,0))
        into v_aux
        from plani.tcolumna_valor cv
        where id_funcionario_planilla = v_id_funcionario_planilla_mes and
              cv.codigo_columna IN ('BONANT', 'BONFRONTERA') and cv.estado_reg = 'activo';


        if v_periodo_array_aux[2] > 1 then

          select sum(coalesce(ht.sueldo, 0))/v_periodo_array_aux[2] into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';

        else
          select sum(coalesce(ht.sueldo * ht.porcentaje_sueldo/100, 0)) into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
        end if;

        v_resultado = v_resultado + v_aux;


      else

          for v_registros in  select tcv.*
                            from plani.tcolumna_valor tcv
                            where tcv.id_funcionario_planilla = v_id_funcionario_planilla_mes and tcv.codigo_columna in ('HORNORM','FACTORANTI') loop

            if v_registros.codigo_columna = 'HORNORM' then
                v_hor_norm = v_registros.valor;
            elsif v_registros.codigo_columna = 'FACTORANTI' then
                v_factor_anti = v_registros.valor;
            end if;
        end loop;



        SELECT sum(COALESCE(cv.valor,0)) into v_aux
        from plani.tcolumna_valor cv
        where id_funcionario_planilla = v_id_funcionario_planilla_mes and cv.codigo_columna = 'BONFRONTERA' and cv.estado_reg = 'activo';

        v_aux_2 = (2000*v_factor_anti/100*3)*(v_hor_norm/v_cantidad_horas_mes);

        v_aux = v_aux + v_aux_2;

        if v_periodo_array_aux[2] > 1 then
          select sum(coalesce(ht.sueldo, 0))/v_periodo_array_aux[2] into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
        else
          select sum(coalesce(ht.sueldo * ht.porcentaje_sueldo/100, 0)) into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
        end if;

        v_resultado = (v_resultado*0.05)+v_resultado;

        v_resultado =  round((v_resultado + v_aux),0);

      end if;

    ELSIF(p_codigo = 'PROMPRI2') THEN

      for v_registros in  select pe.periodo, fp.id_funcionario_planilla
                          from plani.tfuncionario_planilla fp
                          inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                          inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario and fun.id_funcionario = v_planilla.id_funcionario
                          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                          inner join param.tperiodo pe on pe.id_periodo = p.id_periodo
                          inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla and tp.codigo = 'PLASUE' and p.estado not in (
                            'registros_horas', 'registro_funcionarios', 'calculo_columnas', 'anulado') and p.id_gestion = v_planilla.id_gestion
                          group by fp.id_funcionario_planilla, pe.periodo
                          order by  pe.periodo desc loop

        select count(tht.id_funcionario_planilla), sum(tht.horas_normales)
        into  v_contador, v_horas_normales
        from plani.thoras_trabajadas tht
        where tht.id_funcionario_planilla = v_registros.id_funcionario_planilla;


        if v_registros.periodo = v_periodo_aux and v_horas_normales = v_cantidad_horas_mes then
            v_periodo_total =  v_periodo_total + 1;
            v_periodo_aux = v_periodo_aux - 1;
            v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
            if v_periodo_total = 3 then
                exit;
            end if;
        else
            if v_horas_normales = v_cantidad_horas_mes then
              v_periodo_total = 1;
              v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
              v_periodo_aux = v_registros.periodo - 1;
            end if;
        end if;

      end loop;

      v_periodo_array_aux = v_periodo_array[2]::integer[];


      select fp.id_funcionario_planilla, ht.id_uo_funcionario
      into v_id_funcionario_planilla_mes, v_id_uo_funcionario
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo = v_periodo_array_aux[1]
      group by fp.id_funcionario_planilla,pe.periodo, ht.id_uo_funcionario
      --having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1;


      select tuo.fecha_finalizacion
      into v_fecha_fin
      from orga.tuo_funcionario tuo
      where tuo.id_uo_funcionario = v_id_uo_funcionario;



      if  v_periodo_array_aux[1] >= 8 and (v_fecha_fin > '31/07/2017'::date or v_fecha_fin is null) then

        SELECT sum(COALESCE(cv.valor,0)) into v_aux
        from plani.tcolumna_valor cv
        where id_funcionario_planilla = v_id_funcionario_planilla_mes and
              cv.codigo_columna IN ('BONANT', 'BONFRONTERA') and cv.estado_reg = 'activo';

        if v_periodo_array_aux[2] > 1 then
          select sum(coalesce(ht.sueldo, 0))/v_periodo_array_aux[2] into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
        else
          select sum(coalesce(ht.sueldo * ht.porcentaje_sueldo/100, 0)) into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
        end if;

        v_resultado = v_resultado + v_aux;
      else

          for v_registros in  select tcv.*
                            from plani.tcolumna_valor tcv
                            where tcv.id_funcionario_planilla = v_id_funcionario_planilla_mes and tcv.codigo_columna in ('HORNORM','FACTORANTI') loop
            if v_registros.codigo_columna = 'HORNORM' then
                v_hor_norm = v_registros.valor;
            elsif v_registros.codigo_columna = 'FACTORANTI' then
                v_factor_anti = v_registros.valor;
            end if;
        end loop;

        SELECT sum(COALESCE(cv.valor,0)) into v_aux
        from plani.tcolumna_valor cv
        where id_funcionario_planilla = v_id_funcionario_planilla_mes and cv.codigo_columna = 'BONFRONTERA' and cv.estado_reg = 'activo';

        v_aux_2 = (2000*v_factor_anti/100*3)*(v_hor_norm/v_cantidad_horas_mes);

        v_aux = v_aux + v_aux_2;

        if v_periodo_array_aux[2] > 1 then
          select sum(coalesce(ht.sueldo, 0))/v_periodo_array_aux[2] into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
        else
          select sum(coalesce(ht.sueldo * ht.porcentaje_sueldo/100, 0)) into v_resultado
          from plani.thoras_trabajadas ht
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
        end if;

         v_resultado = (v_resultado*0.05)+v_resultado;

         v_resultado =  round((v_resultado + v_aux),0);

      end if;
    ELSIF(p_codigo = 'PROMPRI3') THEN

      for v_registros in select pe.periodo, fp.id_funcionario_planilla
                          from plani.tfuncionario_planilla fp
                          inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                          inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario and fun.id_funcionario = v_planilla.id_funcionario
                          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                          inner join param.tperiodo pe on pe.id_periodo = p.id_periodo
                          inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla and tp.codigo = 'PLASUE' and p.estado not in (
                            'registros_horas', 'registro_funcionarios', 'calculo_columnas', 'anulado') and p.id_gestion = v_planilla.id_gestion
                          group by fp.id_funcionario_planilla, pe.periodo
                          order by  pe.periodo desc loop

        select count(tht.id_funcionario_planilla), sum(tht.horas_normales)
        into  v_contador, v_horas_normales
        from plani.thoras_trabajadas tht
        where tht.id_funcionario_planilla = v_registros.id_funcionario_planilla;

        if v_registros.periodo = v_periodo_aux and v_horas_normales = v_cantidad_horas_mes then
            v_periodo_total =  v_periodo_total + 1;
            v_periodo_aux = v_periodo_aux - 1;
            v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
            if v_periodo_total = 3 then
                exit;
            end if;
        else
            if v_horas_normales = v_cantidad_horas_mes then
              v_periodo_total = 1;
              v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
              v_periodo_aux = v_registros.periodo - 1;
            end if;
        end if;
      end loop;

      v_periodo_array_aux = v_periodo_array[3]::integer[];

      select fp.id_funcionario_planilla, ht.id_uo_funcionario
      into v_id_funcionario_planilla_mes, v_id_uo_funcionario
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo = v_periodo_array_aux[1]
      --group by fp.id_funcionario_planilla,pe.periodo, ht.id_uo_funcionario
      --having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1;

      if (v_id_funcionario_planilla_mes is null) then
        select cv.valor into v_resultado
        from plani.tcolumna_valor cv
        where cv.id_funcionario_planilla = p_id_funcionario_planilla and
              cv.estado_reg = 'activo' and cv.codigo_columna = 'PROMPRI2';
      else

        select tuo.fecha_finalizacion
        into v_fecha_fin
        from orga.tuo_funcionario tuo
        where tuo.id_uo_funcionario = v_id_uo_funcionario;

          if  v_periodo_array_aux[1] >= 8 and (v_fecha_fin > '31/07/2017'::date or v_fecha_fin is null) then
          SELECT sum(COALESCE(cv.valor,0)) into v_aux
          from plani.tcolumna_valor cv
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and
                cv.codigo_columna IN ('BONANT', 'BONFRONTERA') and cv.estado_reg = 'activo';

          if v_periodo_array_aux[2] > 1 then
            select sum(coalesce(ht.sueldo, 0))/v_periodo_array_aux[2] into v_resultado
            from plani.thoras_trabajadas ht
            where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
          else
            select sum(coalesce(ht.sueldo * ht.porcentaje_sueldo/100, 0)) into v_resultado
            from plani.thoras_trabajadas ht
            where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
          end if;

          v_resultado = v_resultado + v_aux;
          else

          for v_registros in  select tcv.*
                              from plani.tcolumna_valor tcv
                              where tcv.id_funcionario_planilla = v_id_funcionario_planilla_mes and tcv.codigo_columna in ('HORNORM','FACTORANTI') loop
              if v_registros.codigo_columna = 'HORNORM' then
                  v_hor_norm = v_registros.valor;
              elsif v_registros.codigo_columna = 'FACTORANTI' then
                  v_factor_anti = v_registros.valor;
              end if;
          end loop;

          SELECT sum(COALESCE(cv.valor,0)) into v_aux
          from plani.tcolumna_valor cv
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and cv.codigo_columna = 'BONFRONTERA' and cv.estado_reg = 'activo';

          v_aux_2 = (2000*v_factor_anti/100*3)*(v_hor_norm/v_cantidad_horas_mes);

          v_aux = v_aux + v_aux_2;

          if v_periodo_array_aux[2] > 1 then
            select sum(coalesce(ht.sueldo, 0))/v_periodo_array_aux[2] into v_resultado
            from plani.thoras_trabajadas ht
            where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
          else
            select sum(coalesce(ht.sueldo * ht.porcentaje_sueldo/100, 0)) into v_resultado
            from plani.thoras_trabajadas ht
            where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';
          end if;

           v_resultado = (v_resultado*0.05)+v_resultado;
           v_resultado =  round((v_resultado + v_aux),0);

          end if;
      end if;
    ELSIF(p_codigo = 'PROMHAB1') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 0;

      select sum(ht.sueldo * ht.porcentaje_sueldo/100) into v_resultado
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';


    ELSIF(p_codigo = 'PROMHAB2') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 1;

      select sum(ht.sueldo * ht.porcentaje_sueldo/100) into v_resultado
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';


    ELSIF(p_codigo = 'PROMHAB3') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 2;

      select sum(ht.sueldo * ht.porcentaje_sueldo/100) into v_resultado
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';

      if (v_resultado = 0 or v_resultado is null) then
        select cv.valor into v_resultado
        from plani.tcolumna_valor cv
        where cv.id_funcionario_planilla = p_id_funcionario_planilla and
              cv.estado_reg = 'activo' and cv.codigo_columna = 'PROMHAB2';

      end if;

    ELSIF(p_codigo = 'PROMANT1') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 0;

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONANT') and cv.estado_reg = 'activo';

    ELSIF(p_codigo = 'PROMANT2') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 1;

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONANT') and cv.estado_reg = 'activo';

    ELSIF(p_codigo = 'PROMANT3') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 2;

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONANT') and cv.estado_reg = 'activo';

      select sum(ht.sueldo * ht.porcentaje_sueldo/100) into v_aux
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';



      if ((v_aux + v_resultado) = 0 or (v_aux + v_resultado) is null) then
        select cv.valor into v_resultado
        from plani.tcolumna_valor cv
        where cv.id_funcionario_planilla = p_id_funcionario_planilla and
              cv.estado_reg = 'activo' and cv.codigo_columna = 'PROMANT2';

      end if;
    ELSIF(p_codigo = 'PROMFRO1') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 0;

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONFRONTERA') and cv.estado_reg = 'activo';

    ELSIF(p_codigo = 'PROMFRO2') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 1;

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONFRONTERA') and cv.estado_reg = 'activo';

    ELSIF(p_codigo = 'PROMFRO3') THEN
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 2;

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('BONFRONTERA') and cv.estado_reg = 'activo';

      select sum(ht.sueldo * ht.porcentaje_sueldo/100) into v_aux
      from plani.thoras_trabajadas ht
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and ht.estado_reg = 'activo';


      if ((v_aux + v_resultado) = 0 or (v_aux + v_resultado) is null) then
        select cv.valor into v_resultado
        from plani.tcolumna_valor cv
        where cv.id_funcionario_planilla = p_id_funcionario_planilla and
              cv.estado_reg = 'activo' and cv.codigo_columna = 'PROMFRO2';

      end if;

    ELSIF(p_codigo = 'DIASAGUI') THEN  --#63

      --determina la fecha fin del empleado
      v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date;
       if (   v_planilla.fecha_finalizacion is null
          or v_planilla.fecha_finalizacion > v_fecha_fin_planilla) then

        v_fecha_fin =   v_fecha_fin_planilla;
      else
        v_fecha_fin =   v_planilla.fecha_finalizacion;
      end if;

      --recupera los dias segun ultimo contrato hasta la fecha de finalizacion
      v_resultado =  plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_planilla.fecha_asignacion, v_fecha_fin);

    ELSIF(p_codigo = 'TIENEPRE') THEN
      v_resultado = 0;
      if (exists(
          select 1
          from plani.tdescuento_bono db
            inner join plani.ttipo_columna tc on db.id_tipo_columna = tc.id_tipo_columna
          where db.id_funcionario = v_planilla.id_funcionario and db.estado_reg = 'activo' and
                tc.codigo = 'SUBPRE' and db.fecha_ini <= v_planilla.fecha_ini_periodo and
                (db.fecha_fin is null or
                 db.fecha_fin > v_planilla.fecha_ini_periodo))) then
        v_resultado = 1;
      end if;
    ELSIF(p_codigo = 'TIENELAC') THEN
      v_resultado = 0;
      if (exists(
          select 1
          from plani.tdescuento_bono db
            inner join plani.ttipo_columna tc on db.id_tipo_columna = tc.id_tipo_columna
          where db.id_funcionario = v_planilla.id_funcionario and db.estado_reg = 'activo' and
                tc.codigo = 'SUBLAC' and db.fecha_ini <= v_planilla.fecha_ini_periodo and
                (db.fecha_fin is null or
                 db.fecha_fin > v_planilla.fecha_ini_periodo))) then
        v_resultado = 1;
      end if;

     ELSIF(p_codigo = 'PROMCOTI1') THEN --#63 recupera el cotizable del primer mes,

      --recupera una primera planilla del funcionario donde haya trabajado el todo le mes
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion = v_planilla.id_gestion and
                                              pe.periodo != 12 -- nose utliza diciembre por que no es un mes completo
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes --conidera la planilla que  cumplio su carga laboral mensual (medio o tiempo completo)
      order by  pe.periodo desc
      limit 1
      offset 0; --  filtra la primera planilla

     -- raise exception '% , % , %', v_cantidad_horas_mes, v_planilla.id_gestion , v_planilla.id_funcionario;

      --recupera el cotizable del empleado para la priera planilla compelta
      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('COTIZABLE') and cv.estado_reg = 'activo';

    ELSIF(p_codigo = 'PROMCOTI2') THEN --#63  recupera el segundo cotizable
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 1; --filtra la segunda planilla

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('COTIZABLE') and cv.estado_reg = 'activo';


    ELSIF(p_codigo = 'PROMCOTI3') THEN --#63 recupera el tercer cotizable
      select fp.id_funcionario_planilla
      into v_id_funcionario_planilla_mes
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                            and fun.id_funcionario = v_planilla.id_funcionario
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and
                                              pe.periodo != 12
      group by fp.id_funcionario_planilla,pe.periodo
      having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
      order by  pe.periodo desc
      limit 1
      offset 2; --filtra tercera planilla

      SELECT sum(COALESCE(cv.valor,0)) into v_resultado
      from plani.tcolumna_valor cv
      where id_funcionario_planilla = v_id_funcionario_planilla_mes and
            cv.codigo_columna IN ('COTIZABLE') and cv.estado_reg = 'activo';

      --si no tiene un tercer mes, usamos el valor del segundo sueldo calculado previamente

      if (v_resultado = 0 or v_resultado is null) then
        select cv.valor into v_resultado
        from plani.tcolumna_valor cv
        where cv.id_funcionario_planilla = p_id_funcionario_planilla and
              cv.estado_reg = 'activo' and cv.codigo_columna = 'PROMCOTI2';

      end if;


    ----------------------------------------------------------------
    -- #68  Cotizable apra calculo de promedio en planilla de primas
    --  la gestion de la planilla debe conincidir con la gestion que se va pagar
    --  la fecha de pago no necesita esta dentro la gestion de la planilla de prima
    --  en abril de 2020 pueden pagar la prima de 2019,   lages tion de l aplanilla sera 2019 y la fecha de pago X Abril de 2020
    --  el calculo es mu parecido a planilla de aguinaldos
    ---------------------------------------------------------------
    ELSIF(p_codigo = 'PRICOTI1') THEN --#68 recupera el cotizable del primer mes,

            --recupera una primera planilla del funcionario donde haya trabajado el todo le mes
            select fp.id_funcionario_planilla
            into v_id_funcionario_planilla_mes
            from plani.tfuncionario_planilla fp
              inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
              inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                                  and fun.id_funcionario = v_planilla.id_funcionario
              inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
              inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
              inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                                    and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                                    and p.id_gestion=v_planilla.id_gestion -- la gestion de la planilla de prima
            group by
                 fp.id_funcionario_planilla,pe.periodo
            having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes --conidera la planilla que  cumplio su carga laboral mensual (medio o tiempo completo)
            order by  pe.periodo desc
            limit 1
            offset 0; --  filtra la primera planilla

            -- recupera el cotizable del empleado para la primera  planilla compelta
            SELECT sum(COALESCE(cv.valor,0)) into v_resultado
            from plani.tcolumna_valor cv
            where id_funcionario_planilla = v_id_funcionario_planilla_mes and
                  cv.codigo_columna IN ('COTIZABLE') and cv.estado_reg = 'activo';

    ELSIF(p_codigo = 'PRICOTI2') THEN --#68  recupera el segundo cotizable

          select fp.id_funcionario_planilla
          into v_id_funcionario_planilla_mes
          from plani.tfuncionario_planilla fp
            inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
            inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                                and fun.id_funcionario = v_planilla.id_funcionario
            inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
            inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                                  and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                                  and p.id_gestion=v_planilla.id_gestion
          group by fp.id_funcionario_planilla, pe.periodo
          having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
          order by  pe.periodo desc
          limit 1
          offset 1; --filtra la segunda planilla

          SELECT sum(COALESCE(cv.valor,0)) into v_resultado
          from plani.tcolumna_valor cv
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and
                cv.codigo_columna IN ('COTIZABLE') and cv.estado_reg = 'activo';


    ELSIF(p_codigo = 'PRICOTI3') THEN --#68 recupera el tercer cotizable

          --raise exception '%,%,%', v_cantidad_horas_mes, v_planilla.id_gestion, v_planilla.id_funcionario;
          select fp.id_funcionario_planilla
          into v_id_funcionario_planilla_mes
          from plani.tfuncionario_planilla fp
            inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
            inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                                                and fun.id_funcionario = v_planilla.id_funcionario
            inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
            inner join param.tperiodo pe on pe.id_periodo=p.id_periodo
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                                  and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                                  and p.id_gestion=v_planilla.id_gestion
          group by fp.id_funcionario_planilla,pe.periodo
          having sum(ht.horas_normales_contrato) = v_cantidad_horas_mes
          order by  pe.periodo desc
          limit 1
          offset 2; --filtra tercera planilla

          SELECT sum(COALESCE(cv.valor,0)) into v_resultado
          from plani.tcolumna_valor cv
          where id_funcionario_planilla = v_id_funcionario_planilla_mes and
                cv.codigo_columna IN ('COTIZABLE') and cv.estado_reg = 'activo';

          --si no tiene un tercer mes, usamos el valor del segundo sueldo calculado previamente

          if (v_resultado = 0 or v_resultado is null) then
            select cv.valor into v_resultado
            from plani.tcolumna_valor cv
            where cv.id_funcionario_planilla = p_id_funcionario_planilla and
                  cv.estado_reg = 'activo' and cv.codigo_columna = 'PRICOTI2';

          end if;

    --#122
    ELSIF(p_codigo = 'PREPRICOT11') THEN -- el primer cotizable del contrato mas antiguo

        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla

        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;

        --#113
        SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                       --  and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario --#136
                         and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','')

                         order by uofun.id_uo_funcionario limit 1 offset 0
                      ;



                            --no es vigente == preguntar si tiene un contrato q inicie en 2019 == nos quedamos con el valor, sino es 0
                            if not exists (select 1 from orga.tuo_funcionario  where id_funcionario=v_registros.id_funcionario
                            and fecha_asignacion>=v_registros.fecha_fin and estado_reg='activo' and tipo='oficial'
                            ) then
                                v_resultado:=0;
                            else
                               v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );

                            end if;



                         if (v_aux>= 90 and v_registros.fecha_ini < v_planilla.fecha_fin  and (v_registros.fecha_fin between v_planilla.fecha_ini and v_planilla.fecha_fin) ) then


                             select id_periodo, fecha_fin into v_i , v_fecha_ini_actual
                            from param.tperiodo where v_registros.fecha_fin between fecha_ini and fecha_fin;

                            if (v_registros.fecha_fin!=v_fecha_ini_actual) then
                                  select cv.valor into v_resultado from plani.tplanilla p
                                  inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                  inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                  inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                  inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                  and cv.codigo_columna='COTIZABLE_ANT'
                                  and fp.id_funcionario=v_planilla.id_funcionario
                                  and p.id_periodo<= v_i
                                  order by per.periodo desc limit 1 offset 0;
                             else
                                  select cv.valor into v_resultado from plani.tplanilla p
                                  inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                  inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                  inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                  inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                  and cv.codigo_columna='COTIZABLE'
                                  and fp.id_funcionario=v_planilla.id_funcionario
                                  and p.id_periodo<= v_i
                                  order by per.periodo desc limit 1 offset 0;
                            end if;
                         else

                             v_resultado:=0;
                         end if;



    ELSIF(p_codigo = 'PREPRICOT12') THEN -- el segundo cotizable

        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;
        --#113
        SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                        -- and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario --#136
                         and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','')

                         order by uofun.id_uo_funcionario limit 1 offset 0
                      ;
                          if not exists (select 1 from orga.tuo_funcionario  where id_funcionario=v_registros.id_funcionario
                            and fecha_asignacion>=v_registros.fecha_fin and estado_reg='activo' and tipo='oficial'
                            ) then
                                v_resultado:=0;
                            else
                                    v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );
                             end if;

                                 if (v_aux>= 90 and v_registros.fecha_ini < v_planilla.fecha_fin  and (v_registros.fecha_fin between v_planilla.fecha_ini and v_planilla.fecha_fin) ) then
                                    select id_periodo, fecha_fin into v_i , v_fecha_ini_actual
                                    from param.tperiodo where v_registros.fecha_fin between fecha_ini and fecha_fin;

                                    if (v_registros.fecha_fin!=v_fecha_ini_actual) then

                                        select cv.valor into v_resultado from plani.tplanilla p
                                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                        inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                        inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                        and cv.codigo_columna='COTIZABLE_ANT'
                                        and fp.id_funcionario=v_planilla.id_funcionario
                                        and p.id_periodo<= v_i
                                        order by per.periodo desc limit 1 offset 1;
                                    else
                                        select cv.valor into v_resultado from plani.tplanilla p
                                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                        inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                        inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                        and cv.codigo_columna='COTIZABLE'
                                        and fp.id_funcionario=v_planilla.id_funcionario
                                        and p.id_periodo<= v_i
                                        order by per.periodo desc limit 1 offset 1;
                                    end if;
                                 else
                                    v_resultado:=0;
                                end if;




    ELSIF(p_codigo = 'PREPRICOT13') THEN -- el tercer cotizable

        select p.fecha_planilla, fp.id_funcionario,fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;

        --#113
        SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin

                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                         --and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario --#136
                          and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','')

                         order by uofun.id_uo_funcionario limit 1 offset 0
                      ;
                 if  not exists (select 1 from orga.tuo_funcionario  where id_funcionario=v_registros.id_funcionario
                            and fecha_asignacion>=v_registros.fecha_fin and estado_reg='activo' and tipo='oficial'
                            ) then
                    v_resultado:=0;
                 else
                       v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );
                 end if;

                 if (v_aux>= 90 and v_registros.fecha_ini < v_planilla.fecha_fin  and (v_registros.fecha_fin between v_planilla.fecha_ini and v_planilla.fecha_fin)) then
                             select id_periodo, fecha_fin into v_i , v_fecha_ini_actual
                            from param.tperiodo where v_registros.fecha_fin between fecha_ini and fecha_fin;

                       if (v_registros.fecha_fin!=v_fecha_ini_actual) then

                            if(v_registros.fecha_ini > (select distinct per.fecha_ini from  plani.tplanilla p
                                     inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                     and tp.codigo='PLASUE'
                                     inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                     where per.id_periodo<=v_i-1 order by per.fecha_ini desc limit 1 offset 2)) then

                                select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE_ANT'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 1;
                            else
                                 select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE_ANT'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 2;

                            end if;


                        else
                                select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 2;
                        end if;

                   else
                       v_resultado:=0;
                   end if;

   --los del ultimo contrato, que siempre tendran valor
    ELSIF(p_codigo = 'PREPRICOT21') THEN -- el primer cotizable del contrato mas actual

        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;
        --#113
        SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                           (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                          and
                          (plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)< v_planilla.fecha_fin)
                          order by plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) desc ,uofun.fecha_asignacion desc
                          limit 1
                      ;

                            v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );

                         if (v_aux>= 90) then
                             select id_periodo, fecha_fin into v_i , v_fecha_ini_actual
                            from param.tperiodo where v_registros.fecha_fin between fecha_ini and fecha_fin;

                            if (v_registros.fecha_fin!=v_fecha_ini_actual) then

                                select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE_ANT'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 0;
                            else
                                select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 0;
                            end if;

                         else

                             v_resultado:=0;
                         end if;






    ELSIF(p_codigo = 'PREPRICOT22') THEN -- el segundo cotizable

        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;
        --#113
        SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                           (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin

                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                          and
                          (plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)< v_planilla.fecha_fin)
                          order by plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) desc ,uofun.fecha_asignacion desc
                          limit 1
                      ;

                            v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );

                         if (v_aux>= 90) then
                             select id_periodo, fecha_fin into v_i , v_fecha_ini_actual
                            from param.tperiodo where v_registros.fecha_fin between fecha_ini and fecha_fin;

                            if (v_registros.fecha_fin!=v_fecha_ini_actual) then

                                select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE_ANT'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 1;
                            else
                                select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 1;
                            end if;

                         end if;




    ELSIF(p_codigo = 'PREPRICOT23') THEN -- el tercer cotizable

        select p.fecha_planilla, fp.id_funcionario,fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;

        --#113
        SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                           (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin

                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                          and
                          (plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)< v_planilla.fecha_fin)
                          order by plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) desc ,uofun.fecha_asignacion desc
                          limit 1
                      ;

                            v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );

                         if (v_aux>= 90) then
                             select id_periodo, fecha_fin into v_i , v_fecha_ini_actual
                            from param.tperiodo where v_registros.fecha_fin between fecha_ini and fecha_fin;

                            if (v_registros.fecha_fin!=v_fecha_ini_actual) then

                                  if(v_registros.fecha_ini > (select distinct per.fecha_ini from  plani.tplanilla p
                                     inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                     and tp.codigo='PLASUE'
                                     inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                     where per.id_periodo<=v_i-1 order by per.fecha_ini desc limit 1 offset 2)) then

                                    select cv.valor into v_resultado from plani.tplanilla p
                                    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                    inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                    inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                    inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                    and cv.codigo_columna='COTIZABLE_ANT'
                                    and fp.id_funcionario=v_planilla.id_funcionario
                                    and p.id_periodo<= v_i
                                    order by per.periodo desc limit 1 offset 1;
                                else
                                    select cv.valor into v_resultado from plani.tplanilla p
                                    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                    inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                    inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                    inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                    and cv.codigo_columna='COTIZABLE_ANT'
                                    and fp.id_funcionario=v_planilla.id_funcionario
                                    and p.id_periodo<= v_i
                                    order by per.periodo desc limit 1 offset 2;


                                end if;


                            else
                                select cv.valor into v_resultado from plani.tplanilla p
                                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                inner join param.tperiodo per on per.id_periodo=p.id_periodo
                                and cv.codigo_columna='COTIZABLE'
                                and fp.id_funcionario=v_planilla.id_funcionario
                                and p.id_periodo<= v_i
                                order by per.periodo desc limit 1 offset 2;
                            end if;
                        end if;


    ELSIF(p_codigo = 'PREDIAS1') THEN -- dias del primer contrato #125
        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;


        /*SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                         and uofun.fecha_asignacion  <= v_planilla.fecha_planilla
                          and uofun.observaciones_finalizacion not in ('transferencia','promocion','')
                          and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario
                          --order by uofun.id_uo_funcionario limit 1 offset 0
                      ;*/


                    SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                        -- and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario --#136
                          and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','')

                         order by uofun.id_uo_funcionario limit 1 offset 0
                      ;



                            --no es vigente == preguntar si tiene un contrato q inicie en 2019 == nos quedamos con el valor, sino es 0
                            if not exists (select 1 from orga.tuo_funcionario  where id_funcionario=v_registros.id_funcionario
                            and fecha_asignacion>=v_registros.fecha_fin and estado_reg='activo' and tipo='oficial'
                            ) then
                                v_resultado:=0;
                            else
                               v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );

                            end if;



                         if (v_aux>= 90 and v_registros.fecha_ini < v_planilla.fecha_fin  and (v_registros.fecha_fin between v_planilla.fecha_ini and v_planilla.fecha_fin) ) then
                           v_resultado:=v_aux;
                         else
                           v_resultado:=0;
                         end if;

    ELSIF(p_codigo = 'PREDIAS2') THEN -- dias del primer contrato #125
           select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;




            SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                           (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                          and
                          (plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)< v_planilla.fecha_fin)
                          order by plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) desc ,uofun.fecha_asignacion desc
                          limit 1
                      ;

                            v_aux:= (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );
                         if (v_aux>= 90 and v_registros.fecha_ini < v_planilla.fecha_fin  and (v_registros.fecha_fin between v_planilla.fecha_ini and v_planilla.fecha_fin) ) then
                           v_resultado:=v_aux;
                         else
                           v_resultado:=0;
                         end if;
    -- #117
    ELSIF(p_codigo = 'APLICADES') THEN -- Si aplica o no el calculo de descuento en planilla tributaria
        v_resultado:= coalesce(plani.f_get_valor_parametro_valor('DSCTOIMP',v_planilla.fecha_planilla),1);
    ELSIF(p_codigo = 'SALDOACUMFIS') THEN -- Si aplica o no el calculo de descuento en planilla tributaria

        select   (case when  per.id_periodo is not null then
                           per.fecha_fin
                      else
                         p.fecha_planilla
                       end
                ) as fecha_plani,
               cv.valor
        into
             v_fecha_plani,
             v_resultado
      from plani.tplanilla p
        inner join plani.tfuncionario_planilla fp on p.id_planilla = fp.id_planilla and fp.id_funcionario = v_planilla.id_funcionario
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and cv.codigo_columna = 'SALDOSIGPERFIS'
        left join param.tperiodo per on per.id_periodo = p.id_periodo
      where
          (
             (
               tp.codigo = 'PLASUE'
               and p.id_periodo is not NULL
               and per.fecha_fin < coalesce(v_planilla.fecha_planilla,p_fecha_fin)
             )
             or
             (
                  tp.codigo = 'PLAREISU'
               and p.id_periodo is null
               and p.fecha_planilla < coalesce(v_planilla.fecha_planilla,p_fecha_fin)
             )
          )

      order by fecha_plani desc limit 1;

	--#145
    ELSIF (p_codigo = 'SPREDIAS1') THEN 
    	select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;

		SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                        -- and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario --#136
                          and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','')

                         order by uofun.id_uo_funcionario limit 1 offset 0
                      ;
					if (v_registros.id_funcionario>0) then


                            --no es vigente == preguntar si tiene un contrato q inicie en 2019 == nos quedamos con el valor, sino es 0
                            if not exists (select 1 from orga.tuo_funcionario  where id_funcionario=v_planilla.id_funcionario
                            and fecha_asignacion>=v_registros.fecha_fin and estado_reg='activo' and tipo='oficial'
                            ) then
                                v_aux:=0;
                            else
                            
                               v_aux:= (plani.f_get_dias_efectivos_prima(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );
								if (v_aux<90) then
                                	v_aux:=0;
                                end if;
                            end if;
                    else
                       v_aux:=0;
                    end if;

                         	v_resultado:=v_aux;
                         	
    ELSIF(p_codigo = 'SPREDIAS2') THEN -- dias del primer contrato #145
        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;




            SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                           (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < v_planilla.fecha_ini THEN v_planilla.fecha_ini
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,

                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin
                   into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario

                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
                          and
                          (plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)< v_planilla.fecha_fin)
                          order by plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) desc ,uofun.fecha_asignacion desc
                          limit 1
                      ;

                      v_aux:= (plani.f_get_dias_efectivos_prima(v_planilla.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin) );

                      v_resultado:=v_aux;
                      
    ELSIF(p_codigo = 'SPREPRICOT1') THEN -- el primer cotizable del contrato mas actual

        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;
        
        select plani.f_get_dias_efectivos_prima(fp.id_funcionario, per.fecha_ini, per.fecha_fin) as dias, plani.f_es_funcionario_vigente(fp.id_funcionario,v_planilla.fecha_fin)  as vigente ,
        (select valor from plani.tcolumna_valor where id_funcionario_planilla=fp.id_funcionario_planilla and codigo_columna='COTIZABLE') as cotizable,
        (select valor from plani.tcolumna_valor where id_funcionario_planilla=fp.id_funcionario_planilla and codigo_columna='COTIZABLE_ANT') as cotizable_ant
        into v_registros
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
        inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
        inner join param.tperiodo per on per.id_periodo=p.id_periodo
        and plani.fecha_planilla between v_planilla.fecha_ini and v_planilla.fecha_fin
        and fp.id_funcionario=v_planilla.id_funcionario
        order by per.periodo desc limit 1 offset 0;
        
        
       
        if (v_registros.vigente ) then
        	v_resultado:=v_registros.cotizable;
        else
          if (v_registros.dias<30) then
	          v_resultado:=v_registros.cotizable_ant;
          else
           	  v_resultado:=v_registros.cotizable;
          end if;
        end if;
        
	

    ELSIF(p_codigo = 'SPREPRICOT2') THEN -- el segundo cotizable

        select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;
        
                       
        select plani.f_get_dias_efectivos_prima(fp.id_funcionario,per.fecha_ini , per.fecha_fin) as dias
        into v_dias_total
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
        inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
        inner join param.tperiodo per on per.id_periodo=p.id_periodo
        and plani.fecha_planilla between  v_planilla.fecha_ini and v_planilla.fecha_fin
        and fp.id_funcionario=v_planilla.id_funcionario
        order by per.periodo desc limit 1 offset 0;
        
        
        if (plani.f_es_funcionario_vigente(v_planilla.id_funcionario,v_planilla.fecha_fin)) then
	        v_id_funcionario:=1;
        else
        	v_id_funcionario:=0;
        end if;
        
        if (v_id_funcionario=1 or (v_id_funcionario=0 and v_dias_total=30) ) then
          
            select cv.valor into v_resultado    
			from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
            inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
            inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
            inner join param.tperiodo per on per.id_periodo=p.id_periodo
            inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
            and cv.codigo_columna='COTIZABLE'
            and plani.fecha_planilla between v_planilla.fecha_ini and v_planilla.fecha_fin
            and fp.id_funcionario=v_planilla.id_funcionario
            order by per.periodo desc limit 1 offset 1;
		else
           select cv.valor into v_resultado    
			from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
            inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
            inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
            inner join param.tperiodo per on per.id_periodo=p.id_periodo
            inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
            and cv.codigo_columna='COTIZABLE'
            and plani.fecha_planilla between v_planilla.fecha_ini and v_planilla.fecha_fin
            and fp.id_funcionario=v_planilla.id_funcionario
            order by per.periodo desc limit 1 offset 2;
        
        end if;
 		

    ELSIF(p_codigo = 'SPREPRICOT3') THEN -- el tercer cotizable

        select p.fecha_planilla, fp.id_funcionario,fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;

        select plani.f_get_dias_efectivos_prima(fp.id_funcionario,per.fecha_ini , per.fecha_fin) as dias
        into v_dias_total
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
        inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
        inner join param.tperiodo per on per.id_periodo=p.id_periodo
        and plani.fecha_planilla between  v_planilla.fecha_ini and v_planilla.fecha_fin
        and fp.id_funcionario=v_planilla.id_funcionario
        order by per.periodo desc limit 1 offset 0;
        
        
        if (plani.f_es_funcionario_vigente(v_planilla.id_funcionario,v_planilla.fecha_fin)) then
	        v_id_funcionario:=1;
        else
        	v_id_funcionario:=0;
        end if;
        
        select plani.f_get_dias_efectivos_prima(fp.id_funcionario,per.fecha_ini , per.fecha_fin) as dias
        into v_dias_asignacion
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
        inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
        inner join param.tperiodo per on per.id_periodo=p.id_periodo
        and plani.fecha_planilla between  v_planilla.fecha_ini and v_planilla.fecha_fin
        and fp.id_funcionario=v_planilla.id_funcionario
        order by per.periodo desc limit 1 offset 3;
        
        
        if (v_id_funcionario=1 or (v_id_funcionario=0 and v_dias_total=30) or v_dias_asignacion!=30 ) then
          
            select cv.valor  into v_resultado   
			from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
            inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
            inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
            inner join param.tperiodo per on per.id_periodo=p.id_periodo
            inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
            and cv.codigo_columna='COTIZABLE'
            and plani.fecha_planilla between v_planilla.fecha_ini and v_planilla.fecha_fin
            and fp.id_funcionario=v_planilla.id_funcionario
            order by per.periodo desc limit 1 offset 2;
		else
        
            select cv.valor  into v_resultado   
			from plani.tplanilla p
            inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
            inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
            inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
            inner join param.tperiodo per on per.id_periodo=p.id_periodo
            inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
            and cv.codigo_columna='COTIZABLE'
            and plani.fecha_planilla between v_planilla.fecha_ini and v_planilla.fecha_fin
            and fp.id_funcionario=v_planilla.id_funcionario
            order by per.periodo desc limit 1 offset 3;
           
        
        end if;
    ELSE
      raise exception 'No hay una definición para la columna básica %',p_codigo;
    END IF;

    return coalesce (v_resultado, 0.00);
    EXCEPTION

    WHEN OTHERS THEN
      v_resp='';
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
      raise exception '%',v_resp;

  END;
$BODY$;

ALTER FUNCTION plani.f_calcular_basica(integer, date, date, integer, character varying, integer)
    OWNER TO postgres;
