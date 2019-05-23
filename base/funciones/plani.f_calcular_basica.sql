--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_calcular_basica (
  p_id_funcionario_planilla integer,
  p_fecha_ini date,
  p_fecha_fin date,
  p_id_tipo_columna integer,
  p_codigo varchar,
  p_id_columna_valor integer
)
RETURNS numeric AS
$body$
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
    v_fecha_aux                date = '31/12/2017'::date;
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


  BEGIN
    v_nombre_funcion = 'plani.f_calcular_basica';
    v_resultado = 0;
    v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', p_fecha_ini)::integer;
    

    select p.*,fp.id_funcionario,tp.periodicidad,tp.codigo,
      uofun.fecha_asignacion,uofun.fecha_finalizacion,ges.gestion,
      per.fecha_ini as fecha_ini_periodo,per.fecha_fin as fecha_fin_periodo,fp.id_uo_funcionario,
      p.id_periodo
    into v_planilla
    from plani.tplanilla p
      inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
      inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
      inner join orga.tuo_funcionario uofun ON uofun.id_uo_funcionario = fp.id_uo_funcionario
      inner join param.tgestion ges on ges.id_gestion = p.id_gestion
      left join param.tperiodo per on per.id_periodo = p.id_periodo
    where fp.id_funcionario_planilla = p_id_funcionario_planilla;
    
     --#2 calculo del tiempo efectivamente trabajado en porcentaje   
    IF (p_codigo = 'FACTIEMPO') THEN  
      v_resultado =  (plani.f_get_valor_columna_valor('HORNORM', p_id_funcionario_planilla)::numeric) / v_cantidad_horas_mes::numeric; 
    ELSIF (p_codigo = 'SUELDOBA') THEN
      select sum(ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
      into v_resultado
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;
      
    --#2 Sueldo Mes , incluye incapacidad temporal y el tiempo trabajado efectivo
    ELSIF (p_codigo = 'SUELDOMES') THEN
      v_factor_tiempo = plani.f_get_valor_columna_valor('FACTIEMPO', p_id_funcionario_planilla)::numeric; --#2 ++
    
      select sum(ht.sueldo)
      into v_auxiliar
      from plani.thoras_trabajadas ht
      where ht.id_funcionario_planilla = p_id_funcionario_planilla;
      
      --v_resultado = (v_factor_tiempo);-- + (v_resultado *(1 - v_factor_tiempo) *(1 - plani.f_get_valor_columna_valor('INCAP_PORC', p_id_funcionario_planilla)::numeric));
      
      
      --v_resultado = (v_auxiliar * v_factor_tiempo) + (v_auxiliar *(1 - v_factor_tiempo) *(1 - plani.f_get_valor_columna_valor('INCAP_PORC', p_id_funcionario_planilla)::numeric));
      
      v_costo_horas_incapcidad = (v_auxiliar/240) * ( plani.f_get_valor_columna_valor('INCAP_DIAS', p_id_funcionario_planilla)::numeric * 8 );  --el costo por todas las hroas de incapacidad
      v_factor_incapcidad_cubierto_empresa = 1 - plani.f_get_valor_columna_valor('INCAP_PORC', p_id_funcionario_planilla)::numeric;--porcentaje de incapcidad que cubre la empresa
      
     
    
     v_resultado = (v_auxiliar * v_factor_tiempo) + --sueldo segun horas efectvamente trabajadas trabajadas
                   (v_costo_horas_incapcidad * v_factor_incapcidad_cubierto_empresa);  -- el monto  que paga la empresa por incapacidad temporal
                     
      /*
      v_resultado =   (v_auxiliar * v_factor_tiempo)  --sueldo segun horas trabajadas
                    + 
      
      
      v_resultado =     (v_auxiliar * v_factor_tiempo)  --sueldo segun horas trabajadas
                     + (v_resultado*( 1- plani.f_get_valor_columna_valor('INCAP_PORC', p_id_funcionario_planilla)::numeric)) --la inversa de las horas 
                   
                    + (v_resultado *
                        (1 - v_factor_tiempo) 
                        *(1 - plani.f_get_valor_columna_valor('INCAP_PORC', p_id_funcionario_planilla)::numeric));*/
      
      
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
                                                      where uofun.id_uo_funcionario = v_planilla.id_uo_funcionario),p_fecha_fin);

    --Horas Trabajadas
    ELSIF (p_codigo = 'HORNORM') THEN
          
      v_cantidad_horas_it = plani.f_get_valor_columna_valor('INCAP_DIAS', p_id_funcionario_planilla)::integer;  --#2 replatea el calculo de horas normal , se cinluye la incapacidad temporal 
    
      select sum(ht.horas_normales) - (v_cantidad_horas_it * 8) --#2 add v_cantidad_horas_it
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
    
    --Dias dados por ley
    
    ELSIF (p_codigo = 'DIALEY') THEN
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
    ELSIF (p_codigo = 'BONANT') THEN

      select fp.id_uo_funcionario, fp.id_funcionario, uf.fecha_asignacion
      into v_id_uo_funcionario, v_id_funcionario,v_fecha_ini
      from plani.tfuncionario_planilla fp
        inner join orga.tuo_funcionario uf on uf.id_uo_funcionario = fp.id_uo_funcionario
      where fp.id_funcionario_planilla = p_id_funcionario_planilla;

      v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado(v_id_uo_funcionario, v_id_funcionario, v_fecha_ini);

      v_fecha_ini_actual = date(date_part('day', v_fecha_ini)||'/'||date_part('month', v_fecha_ini)||'/'||date_part('year', p_fecha_ini));
      --raise exception 'fi % ff %', p_fecha_ini, p_fecha_fin;
      if v_fecha_ini_actual between p_fecha_ini and p_fecha_fin then
        v_gestion:= (select (date_part('year', age(v_fecha_ini_actual, v_fecha_ini))));
        v_periodo:= (select (date_part('month',age(v_fecha_ini_actual, v_fecha_ini))));
      else
          v_gestion:= (select (date_part('year', age(p_fecha_ini, v_fecha_ini))));
          v_periodo:= (select (date_part('month',age(p_fecha_ini, v_fecha_ini))));
      end if;

      v_periodo:= v_periodo + (select coalesce(antiguedad_anterior,0) from orga.tfuncionario f where id_funcionario=v_id_funcionario);

      v_periodo:=(select floor(v_periodo/12));
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

    --Saldo del periodo anterior del dependiente
    ELSIF (p_codigo = 'SALDOPERIANTDEP') THEN

      --v_id_periodo_anterior = param.f_get_id_periodo_anterior(v_planilla.id_periodo);

      select     (case when per.id_periodo is not null then
        per.fecha_fin
               ELSE
                 p.fecha_planilla
               end) as fecha_plani, cv.valor into v_fecha_plani, v_resultado
      from plani.tplanilla p
        inner join plani.tfuncionario_planilla fp
          on p.id_planilla = fp.id_planilla and fp.id_funcionario = v_planilla.id_funcionario
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and
                                              cv.codigo_columna = 'SALDODEPSIGPER'
        left join param.tperiodo per on per.id_periodo = p.id_periodo
      where ((tp.codigo = 'PLASUE' and p.id_periodo is not NULL and per.fecha_fin < coalesce(v_planilla.fecha_planilla,p_fecha_fin)) or (tp.codigo = 'PLAREISU' and p.id_periodo is null and p.fecha_planilla < coalesce(v_planilla.fecha_planilla,p_fecha_fin)))
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


    ELSIF (p_codigo = 'REISUELDOBA') THEN
      v_max_retro = plani.f_get_valor_parametro_valor('MAXRETROSUE', p_fecha_ini)::integer;


      select sum( case when (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
                             and orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then

        (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales) -
        (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
                  else
                    0
                  end),
        array_agg( (case when (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
                               and orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then

          (orga.f_get_haber_basico_a_fecha(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales) -
          (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
                    else
                      0
                    end) order by ht.id_horas_trabajadas asc) into v_resultado, v_resultado_array
      from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
      where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
            ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion;

      /*select sum( case when (orga.f_get_haber_basico_a_fecha_v2(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
                             and orga.f_get_haber_basico_a_fecha_v2(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then

        (orga.f_get_haber_basico_a_fecha_v2(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales) -
        (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
                  else
                    0
                  end),
        array_agg( (case when (orga.f_get_haber_basico_a_fecha_v2(car.id_escala_salarial,v_planilla.fecha_planilla) > ht.sueldo
                               and orga.f_get_haber_basico_a_fecha_v2(car.id_escala_salarial,v_planilla.fecha_planilla) <= v_max_retro) then

          (orga.f_get_haber_basico_a_fecha_v2(car.id_escala_salarial,v_planilla.fecha_planilla) / v_cantidad_horas_mes * ht.horas_normales) -
          (ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
                    else
                      0
                    end) order by ht.id_horas_trabajadas asc) into v_resultado, v_resultado_array
      from plani.tplanilla p
      inner join param.tperiodo tper on tper.id_periodo = p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join orga.tuo_funcionario uofun on ht.id_uo_funcionario = uofun.id_uo_funcionario
        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
      where fp.id_funcionario = v_planilla.id_funcionario and  tp.codigo = 'PLASUE' and
            ht.estado_reg = 'activo' and p.id_gestion = v_planilla.id_gestion and tper.periodo not in (8,9);*/

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
            valor = coalesce(v_resultado_array[v_i], 0),
            valor_generado = coalesce(v_resultado_array[v_i], 0)
          where id_columna_detalle = v_detalle.id_columna_detalle;
          v_resultado = v_resultado + v_resultado_array[v_i];
        else
          v_resultado = v_resultado + v_detalle.valor;
        end if;
        v_i = v_i + 1;
      end loop;

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

        if v_registros.periodo = v_periodo_aux and v_horas_normales = 240 then
            v_periodo_total =  v_periodo_total + 1;
            v_periodo_aux = v_periodo_aux - 1;
            v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
            if v_periodo_total = 3 then
                exit;
            end if;
        else
            if v_horas_normales = 240 then
              v_periodo_total = 1;
              v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
              v_periodo_aux = v_registros.periodo - 1;
            end if;
        end if;

      end loop;

      v_periodo_array_aux = v_periodo_array[1]::integer[];

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
      --group by fp.id_funcionario_planilla,pe.periodo, ht.id_uo_funcionario
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

        v_aux_2 = (2000*v_factor_anti/100*3)*(v_hor_norm/240);

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


        if v_registros.periodo = v_periodo_aux and v_horas_normales = 240 then
            v_periodo_total =  v_periodo_total + 1;
            v_periodo_aux = v_periodo_aux - 1;
            v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
            if v_periodo_total = 3 then
                exit;
            end if;
        else
            if v_horas_normales = 240 then
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

        v_aux_2 = (2000*v_factor_anti/100*3)*(v_hor_norm/240);

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

        if v_registros.periodo = v_periodo_aux and v_horas_normales = 240 then
            v_periodo_total =  v_periodo_total + 1;
            v_periodo_aux = v_periodo_aux - 1;
            v_periodo_array[v_periodo_total] = ARRAY[v_registros.periodo, v_contador];
            if v_periodo_total = 3 then
                exit;
            end if;
        else
            if v_horas_normales = 240 then
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

          v_aux_2 = (2000*v_factor_anti/100*3)*(v_hor_norm/240);

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

    ELSIF(p_codigo = 'DIASAGUI') THEN
        select sum(case when ht.horas_normales_contrato > ht.horas_normales THEN
        ht.horas_normales_contrato - ht.horas_normales  ELSE 0 END)
      into v_resultado
      from plani.tfuncionario_planilla fp
        inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
        inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
        inner join param.tperiodo per on per.id_periodo=p.id_periodo
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                                              and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                                              and p.id_gestion=v_planilla.id_gestion and ht.estado_reg = 'activo' and
                                              fp.id_funcionario = v_planilla.id_funcionario;
      /*v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date;

      if (v_planilla.fecha_finalizacion is null or v_planilla.fecha_finalizacion > v_fecha_fin_planilla) then
        v_fecha_fin =   v_fecha_fin_planilla;
      else
        v_fecha_fin =   v_planilla.fecha_finalizacion;
      end if;
      v_resultado =     (plani.f_get_dias_aguinaldo(v_planilla.id_funcionario, v_planilla.fecha_asignacion,
                                                 v_fecha_fin) * 8) - v_resultado;
      v_resultado = v_resultado / 8; */
      v_resultado = plani.f_get_dias_aguinaldo_v2(v_planilla.id_funcionario, v_planilla.id_gestion);
      --v_resultado = v_resultado / 8;
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;