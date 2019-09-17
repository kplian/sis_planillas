--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.ft_planilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
  /**************************************************************************
   SISTEMA:        Sistema de Planillas
   FUNCION:         plani.ft_planilla_sel
   DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tplanilla'
   AUTOR:          (admin)
   FECHA:            22-01-2014 16:11:04
   COMENTARIOS:
  ***************************************************************************
 HISTORIAL DE MODIFICACIONES:
  #ISSUE                FECHA                AUTOR                DESCRIPCION
   #13                    7-6-2019            MMV ETR                Incluir campos tipo_contrato y dividir_comprobante
   #25    ETR             07/08/2019            RAC                  Registrar  calcular_reintegro_rciva
   #28    ETR             22-08-2019            RAC                  añade alias para correcta ordenacion por tipo planilla
   #42    ETR             17-09-2019            RAC                  exluir estados vobo_conta y finalizado de la interface de vobo planilla  
 ***************************************************************************/


  DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_filtro            varchar;

    --variables reporte certificacion presupuestaria
    v_record_op                    record;
    v_index                        integer;
    v_record                    record;
    v_record_funcionario        record;
    v_firmas                    varchar[];
    v_firma_fun                    varchar;
    v_nombre_entidad            varchar;
    v_direccion_admin            varchar;
    v_unidad_ejecutora            varchar;
    v_cod_proceso                varchar;
    v_cont                        integer;
    v_gerencia                    varchar;
    v_id_funcionario            integer;

    v_desc_funcionario            varchar;

    v_id_gestion                integer;
    v_desc_planilla                varchar;
    v_porcentaje                varchar='';
    v_inner_periodo                varchar='';
  BEGIN

    v_nombre_funcion = 'plani.ft_planilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PLA_PLANI_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:04
    ***********************************/

    if(p_transaccion='PLA_PLANI_SEL')then

      begin
      
        v_filtro = '';--#42
        
        IF p_administrador !=1 THEN
          
          v_filtro = ' plani.id_depto IN (' ||(case when (param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA') = '')
                                                    then  '-1'
                                               else param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA')
                                               end) || ') and ';
        END IF;

        IF (pxp.f_existe_parametro(p_tabla, 'tipo_interfaz')) THEN
                   
          IF  v_parametros.tipo_interfaz in ('PlanillaVb') THEN   --#42          
             
             IF v_filtro != '' THEN
               v_filtro = v_filtro||' (lower(plani.estado) not in  (''vobo_conta'',''planilla_finalizada'')) and ';
             ELSE
               v_filtro = ' (lower(plani.estado) not in  (''vobo_conta'',''planilla_finalizada'')) and ';
             END IF;
          END IF;
            
        END IF;

        --Sentencia de la consulta
        v_consulta:='select
                        plani.id_planilla,
                        plani.id_periodo,
                        plani.id_gestion,
                        plani.id_uo,
                        plani.id_tipo_planilla,
                        plani.id_proceso_macro,
                        plani.id_proceso_wf,
                        plani.id_estado_wf,
                        plani.estado_reg,
                        plani.observaciones,
                        plani.nro_planilla,
                        plani.estado,
                        plani.fecha_reg,
                        plani.id_usuario_reg,
                        plani.id_usuario_mod,
                        plani.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        ges.gestion,
                        per.periodo,
                        tippla.codigo as nombre_planilla,  --#28
                        uo.nombre_unidad as desc_uo, --#28
                        plani.id_depto,
                        depto.nombre,
                        tippla.calculo_horas,
                        pxp.f_get_variable_global(''plani_tiene_presupuestos''),
                        pxp.f_get_variable_global(''plani_tiene_costos''),
                        plani.fecha_planilla,
                        plani.codigo_poa,
                        plani.obs_poa,
                        plani.dividir_comprobante, --#13
                        tc.nombre as tipo_contrato ,--#13
                        plani.id_tipo_contrato,
                        plani.calcular_reintegro_rciva
                        from plani.tplanilla plani
                        inner join segu.tusuario usu1 on usu1.id_usuario = plani.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = plani.id_usuario_mod
                        inner join param.tgestion ges on ges.id_gestion = plani.id_gestion
                        left join param.tperiodo per on per.id_periodo = plani.id_periodo
                        inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla = plani.id_tipo_planilla
                        left join orga.tuo uo on uo.id_uo = plani.id_uo
                        inner join param.tdepto depto on depto.id_depto = plani.id_depto
                        left join orga.ttipo_contrato tc on tc.id_tipo_contrato = plani.id_tipo_contrato --#13
                        where  ' || v_filtro;

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
        raise notice 'v_consulta: %', v_consulta;
        --Devuelve la respuesta
        return v_consulta;

      end;

    /*********************************
     #TRANSACCION:  'PLA_PLANI_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:04
    ***********************************/

    elsif(p_transaccion='PLA_PLANI_CONT')then

      begin
        --Sentencia de la consulta de conteo de registros

         v_filtro = '';--#42
        
        IF p_administrador !=1 THEN
          
          v_filtro = ' plani.id_depto IN (' ||(case when (param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA') = '')
                                                    then  '-1'
                                               else param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA')
                                               end) || ') and ';
        END IF;

        IF (pxp.f_existe_parametro(p_tabla, 'tipo_interfaz')) THEN
                   
          IF  v_parametros.tipo_interfaz in ('PlanillaVb') THEN   --#42          
             
             IF v_filtro != '' THEN
               v_filtro = v_filtro||' (lower(plani.estado) not in  (''vobo_conta'',''planilla_finalizada'')) and ';
             ELSE
               v_filtro = ' (lower(plani.estado) not in  (''vobo_conta'',''planilla_finalizada'')) and ';
             END IF;
          END IF;
            
        END IF;


        v_consulta:='select count(id_planilla)
                        from plani.tplanilla plani
                        inner join segu.tusuario usu1 on usu1.id_usuario = plani.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = plani.id_usuario_mod
                        inner join param.tgestion ges on ges.id_gestion = plani.id_gestion
                        left join param.tperiodo per on per.id_periodo = plani.id_periodo
                        inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla = plani.id_tipo_planilla
                        left join orga.tuo uo on uo.id_uo = plani.id_uo
                        left join orga.ttipo_contrato tc on tc.id_tipo_contrato = plani.id_tipo_contrato --#13
                        where ' || v_filtro;

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;

        --Devuelve la respuesta
        return v_consulta;

      end;

    /*********************************
#TRANSACCION:  'PLA_REPMINCABE_SEL'
#DESCRIPCION:    Listado de datos para cabecera de reporte de ministerio de trabajo
#AUTOR:        admin
#FECHA:        22-01-2014 16:11:04
***********************************/

    elsif(p_transaccion='PLA_REPMINCABE_SEL')then

      begin
        --Sentencia de la consulta de conteo de registros

        if (exists (    select 1
                      from param.tdepto d
                      where id_depto = v_parametros.id_depto and
                            d.id_entidad is null)) then
          raise exception 'El Departamento de RRHH seleccionado no esta relacionado con una entidad para la obtencion de los datos de la empresa';
        end if;



        v_consulta:='select en.nombre,en.nit,en.identificador_min_trabajo,identificador_caja_salud
                        from param.tdepto dep
                        inner join param.tentidad en on en.id_entidad = dep.id_entidad

                        where dep.id_depto =  ' || v_parametros.id_depto;


        --Devuelve la respuesta
        return v_consulta;

      end;

    /*********************************
    #TRANSACCION:  'PLA_PLANI_CONT'
    #DESCRIPCION:    Conteo de registros
    #AUTOR:        admin
    #FECHA:        22-01-2014 16:11:04
    ***********************************/

    elsif(p_transaccion='PLA_REPMINPRIMA_SEL')then

      begin
        v_consulta = 'with empleados as (
                select
                uo.prioridad,
                uo.id_uo,
                (row_number() over (ORDER BY fun.desc_funcionario2 ASC))::integer as fila,
                fp.id_funcionario_planilla,
                (case when perso.id_tipo_doc_identificacion = 1 then 1
                        when perso.id_tipo_doc_identificacion = 5 then
                        3
                        ELSE
                        0
                        end)::integer as tipo_documento,
                perso.ci,perso.expedicion,afp.nombre as afp,fafp.nro_afp,perso.apellido_paterno,
                perso.apellido_materno,''''::varchar as apellido_casada,
                split_part(perso.nombre,'' '',1)::varchar as primer_nombre,

                trim(both '' '' from replace(perso.nombre,split_part(perso.nombre,'' '',1), ''''))::varchar as otros_nombres,
                (case when lower(perso.nacionalidad) like ''%bolivi%'' then
                ''Bolivia''
                ELSE
                perso.nacionalidad
                end)::varchar as nacionalidad,
                perso.fecha_nacimiento,
                (case when upper(genero)= ''VARON'' then
                1 else
                0 end)::integer as sexo,
                (case when fafp.tipo_jubilado in (''jubilado_65'',''jubilado_55'') then
                1
                else
                0 end)::integer as jubilado,
                ''''::varchar as clasificacion_laboral,
                car.nombre as cargo,
                 plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso,
                1::integer as modalidad_contrato,
                (case when (uofun.fecha_finalizacion is not null and uofun.fecha_finalizacion < (''31/12/''||ges.gestion)::date) then
                    (case when (orga.f_existe_sgte_asignacion(uofun.fecha_finalizacion, uofun.id_funcionario) = 1) then
                        NULL
                    else
                        uofun.fecha_finalizacion
                    end)
                else
                    NULL
                end)::date as fecha_finalizacion,
                8::integer as horas_dia,
                30::integer as dias_mes,
                ofi.nombre as oficina,
                (case when perso.discapacitado= ''no''  or perso.discapacitado is null then
                ''no'' else
                ''si'' end)::varchar as discapacitado,

                EXTRACT(year from age( (''31/12/''||ges.gestion)::date,perso.fecha_nacimiento ))::integer as edad,
                lug.nombre as lugar
                from plani.tplanilla p
                inner join param.tgestion ges on ges.id_gestion = p.id_gestion
                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                inner join orga.tfuncionario f1 on f1.id_funcionario = fp.id_funcionario
                inner join segu.tpersona perso on perso.id_persona = f1.id_persona
                inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                left join param.tlugar lug on lug.id_lugar = ofi.id_lugar
                inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL, NULL)
                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = fp.id_afp
                inner join plani.tafp afp on afp.id_afp = fafp.id_afp
                where tp.codigo = ''PLAPRI'' and ges.id_gestion = ' || v_parametros.id_gestion || '
                order by fun.desc_funcionario2 ASC
                )

                select
                emp.fila,emp.tipo_documento,emp.ci,emp.expedicion, emp.afp,emp.nro_afp,emp.apellido_paterno,emp.apellido_materno,emp.apellido_casada,
                emp.primer_nombre,emp.otros_nombres,emp.nacionalidad,to_char(emp.fecha_nacimiento,''DD/MM/YYYY''),emp.sexo,emp.jubilado,emp.clasificacion_laboral,emp.cargo,
                to_char(emp.fecha_ingreso,''DD/MM/YYYY''),emp.modalidad_contrato,to_char(emp.fecha_finalizacion,''DD/MM/YYYY''),emp.horas_dia,cv.codigo_columna,
                (case when cv.codigo_columna = ''HORNORM'' then
                    cv.valor/emp.horas_dia
                else
                    cv.valor
                end)::numeric as valor,
                emp.oficina,emp.discapacitado,
                emp.edad,
                emp.lugar
                from empleados emp
                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = emp.id_funcionario_planilla
                inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                where cv.codigo_columna in (''PRIMA'',''IMPDET'',''OTDESC'',''TOTDESC'',''LIQPAG'')
                order by emp.fila,tc.orden';
        raise notice '%',v_consulta;
        --Devuelve la respuesta
        return v_consulta;
      end;
    /*********************************
        #TRANSACCION:  'PLA_REPMINAGUI_SEL'
        #DESCRIPCION:    Reporte para ministerio de trabajo Aguinaldo
        #AUTOR:        admin
        #FECHA:        22-01-2014 16:11:04
        ***********************************/

    elsif(p_transaccion='PLA_REPMINAGUI_SEL')then

      begin
        v_consulta = 'with empleados as (
                select
                uo.prioridad,
                uo.id_uo,
                (row_number() over (ORDER BY fun.desc_funcionario2 ASC))::integer as fila,
                fp.id_funcionario_planilla,
                (case when perso.id_tipo_doc_identificacion = 1 then 1
                        when perso.id_tipo_doc_identificacion = 5 then
                        3
                        ELSE
                        0
                        end)::integer as tipo_documento,
                perso.ci,perso.expedicion,(case when afp.nombre = ''PREVISION'' then ''1'' else ''2'' end)::varchar as afp,fafp.nro_afp,perso.apellido_paterno,
                perso.apellido_materno,''''::varchar as apellido_casada,
                split_part(perso.nombre,'' '',1)::varchar as primer_nombre,

                trim(both '' '' from replace(perso.nombre,split_part(perso.nombre,'' '',1), ''''))::varchar as otros_nombres,
                (case when lower(perso.nacionalidad) like ''%bolivi%'' then
                ''Bolivia''
                ELSE
                perso.nacionalidad
                end)::varchar as nacionalidad,
                perso.fecha_nacimiento,
                (case when upper(genero)= ''VARON'' then
                1 else
                0 end)::integer as sexo,
                (case when fafp.tipo_jubilado in (''jubilado_65'',''jubilado_55'') then
                1
                else
                0 end)::integer as jubilado,
                ''''::varchar as clasificacion_laboral,
                car.nombre as cargo,
                 plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso,
                1::integer as modalidad_contrato,
                (case when (uofun.fecha_finalizacion is not null and uofun.fecha_finalizacion < (''31/12/''||ges.gestion)::date) then
                    (case when (orga.f_existe_sgte_asignacion(uofun.fecha_finalizacion, uofun.id_funcionario) = 1) then
                        NULL
                    else
                        uofun.fecha_finalizacion
                    end)
                else
                    NULL
                end)::date as fecha_finalizacion,
                8::integer as horas_dia,
                30::integer as dias_mes,
                ofi.nombre as oficina,
                (case when perso.discapacitado= ''no''  or perso.discapacitado is null then
                ''no'' else
                ''si'' end)::varchar as discapacitado,

                EXTRACT(year from age( (''31/12/''||ges.gestion)::date,perso.fecha_nacimiento ))::integer as edad,
                lug.nombre as lugar
                from plani.tplanilla p
                inner join param.tgestion ges on ges.id_gestion = p.id_gestion
                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                inner join orga.tfuncionario f1 on f1.id_funcionario = fp.id_funcionario
                inner join segu.tpersona perso on perso.id_persona = f1.id_persona
                inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                left join param.tlugar lug on lug.id_lugar = ofi.id_lugar
                inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL, NULL)
                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = fp.id_afp
                inner join plani.tafp afp on afp.id_afp = fafp.id_afp
                where tp.codigo = ''PLAGUIN'' and ges.id_gestion = ' || v_parametros.id_gestion || '
                order by fun.desc_funcionario2 ASC
                )

                select
                emp.fila,emp.tipo_documento,emp.ci,emp.expedicion, emp.afp,emp.nro_afp,emp.apellido_paterno,emp.apellido_materno,emp.apellido_casada,
                emp.primer_nombre,emp.otros_nombres,emp.nacionalidad,to_char(emp.fecha_nacimiento,''DD/MM/YYYY''),emp.sexo,emp.jubilado,emp.clasificacion_laboral,emp.cargo,
                to_char(emp.fecha_ingreso,''DD/MM/YYYY''),emp.modalidad_contrato,to_char(emp.fecha_finalizacion,''DD/MM/YYYY''),emp.horas_dia,cv.codigo_columna,
                (case when cv.codigo_columna = ''HORNORM'' then
                    cv.valor/emp.horas_dia
                else
                    cv.valor
                end)::numeric as valor,
                emp.oficina,emp.discapacitado,
                emp.edad,
                emp.lugar
                from empleados emp
                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = emp.id_funcionario_planilla
                inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                where cv.codigo_columna in (''PROMHAB'',''PROMANT'',''PROMFRO'',''PROME'',''DIASAGUI'',''LIQPAG'')
                order by emp.fila,tc.orden';
        raise notice '%',v_consulta;
        --Devuelve la respuesta
        return v_consulta;
      end;
    /*********************************
        #TRANSACCION:  'PLA_REPSEGAGUI_SEL'
        #DESCRIPCION:    Reporte para ministerio de trabajo Segundo Aguinaldo
        #AUTOR:        admin
        #FECHA:        22-01-2014 16:11:04
        ***********************************/

    elsif(p_transaccion='PLA_REPSEGAGUI_SEL')then

      begin
        v_consulta = 'with empleados as (
                select
                (row_number() over (ORDER BY fun.desc_funcionario2 ASC))::integer as fila,
                uo.prioridad,
                uo.id_uo,

                fp.id_funcionario_planilla,
                (case when perso.id_tipo_doc_identificacion = 1 then 1
                        when perso.id_tipo_doc_identificacion = 5 then
                        3
                        ELSE
                        0
                        end)::integer as tipo_documento,
                perso.ci,perso.expedicion,afp.nombre as afp,fafp.nro_afp,fun.desc_funcionario2,
                perso.nombre,perso.apellido_paterno,perso.apellido_materno,
                (case when lower(perso.nacionalidad) like ''%bolivi%'' then
                ''Bolivia''
                ELSE
                perso.nacionalidad
                end)::varchar as nacionalidad,
                perso.fecha_nacimiento,
                (case when upper(genero)= ''VARON'' then
                ''M'' else
                ''F'' end)::varchar as sexo,
                (case when fafp.tipo_jubilado in (''jubilado_65'',''jubilado_55'') then
                1
                else
                0 end)::integer as jubilado,
                ''''::varchar as clasificacion_laboral,
                car.nombre as cargo,
                 plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso,
                1::integer as modalidad_contrato,
                (case when (uofun.fecha_finalizacion is not null and uofun.fecha_finalizacion < (''31/12/''||ges.gestion)::date) then
                    (case when (orga.f_existe_sgte_asignacion(uofun.fecha_finalizacion, uofun.id_funcionario) = 1) then
                        NULL
                    else
                        uofun.fecha_finalizacion
                    end)
                else
                    NULL
                end)::date as fecha_finalizacion,
                8::integer as horas_dia,
                30::integer as dias_mes,
                ofi.nombre as oficina,
                (case when perso.discapacitado= ''no''  or perso.discapacitado is null then
                ''no'' else
                ''si'' end)::varchar as discapacitado,
                EXTRACT(year from age( (''31/12/''||ges.gestion)::date,perso.fecha_nacimiento ))::integer as edad,
                lug.nombre as lugar
                from plani.tplanilla p
                inner join param.tgestion ges on ges.id_gestion = p.id_gestion
                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                inner join orga.tfuncionario f1 on f1.id_funcionario = fp.id_funcionario
                inner join segu.tpersona perso on perso.id_persona = f1.id_persona
                inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                 inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                left join param.tlugar lug on lug.id_lugar = ofi.id_lugar
                inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL, NULL)
                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = fp.id_afp
                inner join plani.tafp afp on afp.id_afp = fafp.id_afp
                where tp.codigo = ''PLASEGAGUI'' and tc.codigo in (''PLA'',''EVE'') and ges.id_gestion = ' || v_parametros.id_gestion || '

                )

                select
                emp.fila,emp.ci,emp.apellido_paterno,emp.apellido_materno,emp.nombre,
                emp.nacionalidad,to_char(emp.fecha_nacimiento,''DD/MM/YYYY''),emp.sexo,emp.cargo,
                to_char(emp.fecha_ingreso,''DD/MM/YYYY''),cv.codigo_columna,
                   cv.valor,emp.jubilado,emp.discapacitado
                from empleados emp
                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = emp.id_funcionario_planilla
                inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                where cv.codigo_columna in (''PROME'',''DIASAGUI'',''AGUINA'')
                order by emp.fila,tc.orden';
        raise notice '%',v_consulta;
        --Devuelve la respuesta
        return v_consulta;
      end;
    /*********************************
        #TRANSACCION:  'PLA_R_MINTRASUE_SEL'
        #DESCRIPCION:    Reporte para ministerio de trabajo Formato Nuevo
        #AUTOR:        f.e.a
        #FECHA:        22-02-2018 16:11:04
        ***********************************/
    elsif(p_transaccion='PLA_R_MINTRASUE_SEL')then

      begin
          --Creamos una tabla donde obtenemos la ultima asignacion de un funcionario
           /*create temp table tt_orga_filtro (
              id_funcionario integer,
              id_uo_funcionario integer
           )on commit drop;

        v_consulta = 'insert into tt_orga_filtro
                      select tuo.id_funcionario,  max(tuo.id_uo_funcionario)
                      from orga.tuo_funcionario tuo
                      group by  tuo.id_funcionario';

        execute(v_consulta);*/


        v_consulta = 'with empleados as (
                select
                uo.prioridad,
                uo.id_uo,
                (row_number() over (ORDER BY fun.desc_funcionario2 ASC))::integer as fila,
                fp.id_funcionario_planilla,
                (case when perso.id_tipo_doc_identificacion = 1 then ''CI''
                      when perso.id_tipo_doc_identificacion = 5 then ''PASAPORTE''
                      ELSE ''0'' end)::varchar as tipo_documento,
                perso.ci,perso.expedicion,afp.nombre as afp,fafp.nro_afp,perso.apellido_paterno,
                perso.apellido_materno,''''::varchar as apellido_casada,
                split_part(perso.nombre,'' '',1)::varchar as primer_nombre,

                trim(both '' '' from replace(perso.nombre,split_part(perso.nombre,'' '',1), ''''))::varchar as otros_nombres,
                (case when lower(perso.nacionalidad) like ''%bolivi%'' then
                ''Bolivia''
                ELSE
                perso.nacionalidad
                end)::varchar as nacionalidad,
                perso.fecha_nacimiento,
                (case when upper(genero)= ''VARON'' then
                ''M'' else
                ''F'' end)::varchar as sexo,
                (case when fafp.tipo_jubilado in (''jubilado_65'',''jubilado_55'') then
                1
                else
                0 end)::integer as jubilado,
                ''''::varchar as clasificacion_laboral,
                car.nombre as cargo,
                 plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso,
                1::integer as modalidad_contrato,
                (case when (uofun.fecha_finalizacion is not null and uofun.fecha_finalizacion <= per.fecha_fin) then
                    (case when (orga.f_existe_sgte_asignacion(uofun.fecha_finalizacion, uofun.id_funcionario) = 1) then
                        NULL
                    else
                        uofun.fecha_finalizacion
                    end)
                else
                    NULL
                end)::date as fecha_finalizacion,
                8::integer as horas_dia,
                ofi.nombre as oficina,
                (case when (perso.discapacitado= ''no'' OR perso.discapacitado= ''NO'') or perso.discapacitado is null then
                0 else
                1 end)::integer as discapacitado,
                per.fecha_ini as inicio_periodo,
                per.fecha_fin as fin_periodo,
                EXTRACT(year from age( per.fecha_fin,perso.fecha_nacimiento ))::integer as edad,
                lug.nombre as lugar,
                uofun.observaciones_finalizacion as motivo_retiro,
                car.id_tipo_contrato,
                lug.nombre as lugar_oficina,
                f1.es_tutor
                from plani.tplanilla p
                inner join param.tperiodo per on per.id_periodo = p.id_periodo
                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                inner join orga.tfuncionario f1 on f1.id_funcionario = fp.id_funcionario
                inner join segu.tpersona perso on perso.id_persona = f1.id_persona
                inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                left join param.tlugar lug on lug.id_lugar = ofi.id_lugar
                inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL, NULL)
                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = fp.id_afp
                inner join plani.tafp afp on afp.id_afp = fafp.id_afp
                where tp.codigo = ''PLASUE'' and per.id_periodo = ' || v_parametros.id_periodo || '
                order by fun.desc_funcionario2 ASC
                )

                select
                emp.fila,
                emp.tipo_documento,
                emp.ci,
                emp.expedicion,
                to_char(emp.fecha_nacimiento,''DD/MM/YYYY''),
                emp.apellido_paterno,
                emp.apellido_materno,
                (emp.primer_nombre||'' ''||emp.otros_nombres)::varchar as nombres,
                emp.nacionalidad,
                emp.sexo,
                emp.jubilado,
                (case when emp.afp is null and emp.nro_afp is null then 0 else 1 end)::integer as aporta_afp,
                emp.discapacitado,
                (case when emp.es_tutor = ''si'' then 1::integer else 0::integer end) as tutor_discapacidad,
                to_char(emp.fecha_ingreso,''DD/MM/YYYY''),
                coalesce(to_char(emp.fecha_finalizacion,''DD/MM/YYYY''),'''')::text,
                (case when emp.fecha_finalizacion is not null and emp.motivo_retiro = ''fin contrato'' then ''2''
                      when emp.fecha_finalizacion is not null and emp.motivo_retiro = ''retiro'' or emp.motivo_retiro = ''renuncia''  then ''1''
                      else '''' end)::varchar as motivo_retiro,
                case when emp.ci = ''630048'' then ''7'' else ''6''::varchar end as caja_salud,
                (case when emp.afp = ''PREVISION'' then 1 else 2 end)::integer as afp,
                emp.nro_afp,
                --emp.oficina,
                --(''REGIONAL''||'' ''||emp.lugar_oficina)::varchar as oficina,
                (case emp.lugar_oficina when ''COCHABAMBA'' then 1 when ''LA PAZ'' then 2 when ''SANTA CRUZ'' then 3 when ''TRINIDAD'' then 4 when ''TARIJA'' then 5
                when ''COBIJA'' then 6 when ''SUCRE'' then 7 when ''UYUNI'' then 8 when ''POTOSI'' then 9 when ''ORURO'' then 10 when ''CHIMORE'' then 11
                when ''YACUIBA'' then 12 when ''MONTEAGUDO'' then 13 end)::integer as oficina,
                emp.clasificacion_laboral,
                emp.cargo,
                (case when tcont.id_tipo_contrato = 1 then 1 when tcont.id_tipo_contrato = 4 then 2 end)::integer as modalidad_contrato,
                1::integer as tipo_contrato,

                (case when cv.codigo_columna = ''HORNORM'' then
                    cv.valor/emp.horas_dia
                else
                    cv.valor
                end)::numeric as valor,

                emp.horas_dia,cv.codigo_columna,

                (case when emp.fecha_ingreso >= emp.inicio_periodo then
                ''si''
                else
                ''no'' end):: varchar as contrato_periodo,

                (case when emp.fecha_finalizacion < emp.fin_periodo then
                ''si''
                else
                ''no'' end):: varchar as retiro_periodo,

                emp.edad,
                emp.lugar

                from empleados emp
                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = emp.id_funcionario_planilla
                inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                inner join orga.ttipo_contrato tcont on tcont.id_tipo_contrato = emp.id_tipo_contrato
                where cv.codigo_columna in (''HORNORM'',''SUELDOBA'',''BONANT'',''BONFRONTERA'',''REINBANT'',''COTIZABLE'',''AFP_LAB'',''IMPURET'',''OTRO_DESC'',''TOT_DESC'',''LIQPAG'',''CAJSAL'')
                order by emp.fila,tc.orden';
        raise notice 'v_consulta: %', v_consulta;
        --Devuelve la respuesta
        return v_consulta;
      end;
    elsif(p_transaccion='PLA_REPMINTRASUE_SEL')then

      begin
        v_consulta = 'with empleados as (
                select
                uo.prioridad,
                uo.id_uo,
                (row_number() over (ORDER BY fun.desc_funcionario2 ASC))::integer as fila,
                fp.id_funcionario_planilla,
                (case when perso.id_tipo_doc_identificacion = 1 then 1
                        when perso.id_tipo_doc_identificacion = 5 then
                        3
                        ELSE
                        0
                        end)::integer as tipo_documento,
                perso.ci,perso.expedicion,afp.nombre as afp,fafp.nro_afp,perso.apellido_paterno,
                perso.apellido_materno,''''::varchar as apellido_casada,
                split_part(perso.nombre,'' '',1)::varchar as primer_nombre,

                trim(both '' '' from replace(perso.nombre,split_part(perso.nombre,'' '',1), ''''))::varchar as otros_nombres,
                (case when lower(perso.nacionalidad) like ''%bolivi%'' then
                ''Bolivia''
                ELSE
                perso.nacionalidad
                end)::varchar as nacionalidad,
                perso.fecha_nacimiento,
                (case when upper(genero)= ''VARON'' then
                1 else
                0 end)::integer as sexo,
                (case when fafp.tipo_jubilado in (''jubilado_65'',''jubilado_55'') then
                1
                else
                0 end)::integer as jubilado,
                ''''::varchar as clasificacion_laboral,
                car.nombre as cargo,
                 plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso,
                1::integer as modalidad_contrato,
                (case when (uofun.fecha_finalizacion is not null and uofun.fecha_finalizacion < per.fecha_fin) then
                    (case when (orga.f_existe_sgte_asignacion(uofun.fecha_finalizacion, uofun.id_funcionario) = 1) then
                        NULL
                    else
                        uofun.fecha_finalizacion
                    end)
                else
                    NULL
                end)::date as fecha_finalizacion,
                8::integer as horas_dia,
                ofi.nombre as oficina,
                (case when perso.discapacitado= ''no''  or perso.discapacitado is null then
                ''no'' else
                ''si'' end)::varchar as discapacitado,
                per.fecha_ini as inicio_periodo,
                per.fecha_fin as fin_periodo,
                EXTRACT(year from age( per.fecha_fin,perso.fecha_nacimiento ))::integer as edad,
                lug.nombre as lugar,
                car.id_tipo_contrato
                from plani.tplanilla p
                inner join param.tperiodo per on per.id_periodo = p.id_periodo
                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                inner join orga.tfuncionario f1 on f1.id_funcionario = fp.id_funcionario
                inner join segu.tpersona perso on perso.id_persona = f1.id_persona
                inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                left join param.tlugar lug on lug.id_lugar = ofi.id_lugar
                inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL, NULL)
                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = fp.id_afp
                inner join plani.tafp afp on afp.id_afp = fafp.id_afp
                where tp.codigo = ''PLASUE'' and per.id_periodo = ' || v_parametros.id_periodo || '
                order by fun.desc_funcionario2 ASC
                )

                select
                emp.fila,emp.tipo_documento,emp.ci,emp.expedicion, emp.afp,emp.nro_afp,emp.apellido_paterno,emp.apellido_materno,emp.apellido_casada,
                emp.primer_nombre,emp.otros_nombres,emp.nacionalidad,to_char(emp.fecha_nacimiento,''DD/MM/YYYY''),emp.sexo,emp.jubilado,emp.clasificacion_laboral,emp.cargo,
                to_char(emp.fecha_ingreso,''DD/MM/YYYY''),
                --emp.modalidad_contrato,
                (case when tcont.id_tipo_contrato = 1 then 1 when tcont.id_tipo_contrato = 4 then 2 end)::integer as modalidad_contrato,
                to_char(emp.fecha_finalizacion,''DD/MM/YYYY''),emp.horas_dia,cv.codigo_columna,
                (case when cv.codigo_columna = ''HORNORM'' then
                    cv.valor/emp.horas_dia
                else
                    cv.valor
                end)::numeric as valor,

                emp.oficina,emp.discapacitado,
                (case when emp.fecha_ingreso >= emp.inicio_periodo then
                ''si''
                else
                ''no'' end):: varchar as contrato_periodo,
                (case when emp.fecha_finalizacion < emp.fin_periodo then
                ''si''
                else
                ''no'' end):: varchar as retiro_periodo,
                emp.edad,
                emp.lugar
                from empleados emp
                inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = emp.id_funcionario_planilla
                inner join plani.ttipo_columna tc on tc.id_tipo_columna = cv.id_tipo_columna
                inner join orga.ttipo_contrato tcont on tcont.id_tipo_contrato = emp.id_tipo_contrato
                where cv.codigo_columna in (''HORNORM'',''SUELDOBA'',''BONANT'',''BONFRONTERA'',''REINBANT'',''COTIZABLE'',''AFP_LAB'',''IMPURET'',''OTRO_DESC'',''TOT_DESC'',''LIQPAG'',''CAJSAL'')
                order by emp.fila,tc.orden';

        --Devuelve la respuesta
        return v_consulta;
      end;
    /*********************************
     #TRANSACCION:  'PLA_REPCERPRE_SEL'
     #DESCRIPCION:    Reporte Certificación Presupuestaria Planillas
     #AUTOR:        FEA
     #FECHA:        14-02-2018 15:00
    ***********************************/

    elsif(p_transaccion='PLA_REPCERPRE_SEL')then

        begin

            SELECT tpl.codigo, tp.id_gestion
            INTO v_desc_planilla, v_id_gestion
            FROM plani.tplanilla tp
            INNER JOIN plani.ttipo_planilla tpl on tpl.id_tipo_planilla = tp.id_tipo_planilla
            WHERE tp.id_proceso_wf =  v_parametros.id_proceso_wf;

            if v_desc_planilla = 'PLASUB' then
                v_porcentaje = '/0.87';
            /*else
                v_porcentaje = '';*/
            end if;

            --raise exception 'v_desc_planilla: %, v_id_gestion: %', v_desc_planilla, v_id_gestion;
            if v_desc_planilla = 'PLASUB' or v_desc_planilla = 'PLASUE' then
                v_inner_periodo = 'inner join param.tperiodo tper on tper.id_periodo = tpla.id_periodo
                                   inner join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuof.id_cargo and tcp.id_gestion = '||v_id_gestion||' and
                                   ((tper.fecha_ini between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)) or
                                   (tper.fecha_fin between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)))';
            else
                v_inner_periodo = 'inner join param.tperiodo tper on tper.periodo = extract(''month'' from tpla.fecha_planilla) and tper.id_gestion = '||v_id_gestion||'
                                   inner join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuof.id_cargo and tcp.id_gestion = '||v_id_gestion||' and
                                   ((tper.fecha_ini between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)) or
                                   (tper.fecha_fin between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)))';
            end if;

            /*select g.id_gestion
             into v_id_gestion
             from param.tgestion g
             where g.gestion = EXTRACT(YEAR FROM current_date);*/

            v_id_funcionario = 57;

            select vf.desc_funcionario1
            into v_desc_funcionario
            from orga.vfuncionario vf
            where vf.id_funcionario = v_id_funcionario;

            --Gerencia del funcionario solicitante
            WITH RECURSIVE gerencia(id_uo, id_nivel_organizacional, nombre_unidad, nombre_cargo, codigo) AS (
              SELECT tu.id_uo, tu.id_nivel_organizacional, tu.nombre_unidad, tu.nombre_cargo, tu.codigo
              FROM orga.tuo  tu
              INNER JOIN orga.tuo_funcionario tf ON tf.id_uo = tu.id_uo
              WHERE tf.id_funcionario = v_id_funcionario and tu.estado_reg = 'activo'

              UNION ALL

              SELECT teu.id_uo_padre, tu1.id_nivel_organizacional, tu1.nombre_unidad, tu1.nombre_cargo, tu1.codigo
              FROM orga.testructura_uo teu
              INNER JOIN gerencia g ON g.id_uo = teu.id_uo_hijo
              INNER JOIN orga.tuo tu1 ON tu1.id_uo = teu.id_uo_padre
              WHERE substring(g.nombre_cargo,1,7) <> 'Gerente'
              )

            SELECT (codigo||'-'||nombre_unidad)::varchar
            INTO v_gerencia
            FROM gerencia
            ORDER BY id_nivel_organizacional asc limit 1;
            --end gerencia

            SELECT tpla.estado, tpla.id_estado_wf, 'ninguna 7.7.7'::varchar as obs
            INTO v_record_op
            FROM plani.tplanilla tpla
            WHERE tpla.id_proceso_wf = v_parametros.id_proceso_wf;


            SELECT tpo.nombre
            INTO v_cod_proceso
            FROM wf.tproceso_wf tpw
            INNER JOIN wf.ttipo_proceso ttp ON ttp.id_tipo_proceso = tpw.id_tipo_proceso
            INNER JOIN wf.tproceso_macro tpo ON tpo.id_proceso_macro = ttp.id_proceso_macro
            WHERE tpw.id_proceso_wf = v_parametros.id_proceso_wf;

            IF(v_record_op.estado IN ('vbpresupuestos', 'suppresu', 'comprobante_generado', 'planilla_finalizada'))THEN
              v_index = 1;
              FOR v_record IN (WITH RECURSIVE firmas(id_estado_fw, id_estado_anterior,fecha_reg, codigo, id_funcionario) AS (
                                SELECT tew.id_estado_wf, tew.id_estado_anterior , tew.fecha_reg, te.codigo, tew.id_funcionario
                                FROM wf.testado_wf tew
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = tew.id_tipo_estado
                                WHERE tew.id_estado_wf = v_record_op.id_estado_wf

                                UNION ALL

                                SELECT ter.id_estado_wf, ter.id_estado_anterior, ter.fecha_reg, te.codigo, ter.id_funcionario
                                FROM wf.testado_wf ter
                                INNER JOIN firmas f ON f.id_estado_anterior = ter.id_estado_wf
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = ter.id_tipo_estado
                                WHERE f.id_estado_anterior IS NOT NULL
                            )SELECT distinct on (codigo) codigo, fecha_reg , id_estado_fw, id_estado_anterior, id_funcionario FROM firmas ORDER BY codigo, fecha_reg DESC) LOOP

                  IF(v_record.codigo = 'vbpoa' OR v_record.codigo = 'suppresu' OR v_record.codigo = 'vbpresupuestos' OR v_record.codigo = 'comprobante_generado')THEN
                        SELECT vf.desc_funcionario1, vf.nombre_cargo, vf.oficina_nombre
                        INTO v_record_funcionario
                        FROM orga.vfuncionario_cargo_lugar vf
                        WHERE vf.id_funcionario = v_record.id_funcionario;
                        v_firmas[v_index] = v_record.codigo::VARCHAR||','||v_record.fecha_reg::VARCHAR||','||v_record_funcionario.desc_funcionario1::VARCHAR||','||v_record_funcionario.nombre_cargo::VARCHAR||','||v_record_funcionario.oficina_nombre;
                        v_index = v_index + 1;
                  END IF;
              END LOOP;
                v_firma_fun = array_to_string(v_firmas,';');
            ELSE
                v_firma_fun = '';
            END IF;
            ------
            SELECT (''||te.codigo||' '||te.nombre)::varchar
            INTO v_nombre_entidad
            FROM param.tempresa te;
            ------
            SELECT (''||tda.codigo||' '||tda.nombre)::varchar
            INTO v_direccion_admin
            FROM pre.tdireccion_administrativa tda;
            ------
            SELECT (''||tue.codigo||' '||tue.nombre)::varchar
            INTO v_unidad_ejecutora
            FROM pre.tunidad_ejecutora tue;
            ---

            --Sentencia de la consulta de conteo de registros
            v_consulta:='
            SELECT
                vcp.id_categoria_programatica AS id_cp, ttc.codigo AS centro_costo,
                   vcp.codigo_programa , vcp.codigo_proyecto, vcp.codigo_actividad, vcp.codigo_fuente_fin, vcp.codigo_origen_fin,
                tpar.codigo AS codigo_partida, tpar.nombre_partida AS nombre_partida,
                tcg.codigo AS codigo_cg, tcg.nombre AS nombre_cg,
                --sum(tcv.valor '||v_porcentaje||')::numeric AS precio_total,
                sum(CASE WHEN tcv.codigo_columna = ''SUBLACGAS'' or tcv.codigo_columna = ''SUBPREGAS'' THEN tcv.valor '||v_porcentaje||' ELSE tcv.valor END)::numeric AS precio_total,
                ''Bs''::varchar AS codigo_moneda, tpla.nro_planilla as num_tramite,

            '''||v_nombre_entidad||'''::varchar AS nombre_entidad,
            COALESCE('''||v_direccion_admin||'''::varchar, '''') AS direccion_admin,
            '''||v_unidad_ejecutora||'''::varchar AS unidad_ejecutora,

            COALESCE('''||v_firma_fun||'''::varchar, '''') AS firmas,

            COALESCE(tpla.observaciones::varchar,'''')::varchar as justificacion,
            COALESCE(tet.codigo::varchar,''00''::varchar) AS codigo_transf,

            '''||v_gerencia||'''::varchar AS unidad_solicitante,

            vfp.desc_funcionario1::varchar as funcionario_solicitante,


            '''||v_cod_proceso||'''::varchar AS codigo_proceso,

            COALESCE(tpla.fecha_planilla,null::date) AS fecha_soli,
            --COALESCE(tg.gestion, (extract(year from now()::date))::integer) AS gestion,
            extract(year from fecha_planilla)::integer as gestion,
            --ts.codigo_poa,
            tpla.codigo_poa as codigo_poa,
            --''descripcion prueba''::varchar as codigo_descripcion
            (select  pxp.list(distinct ob.codigo|| '' ''||ob.descripcion||'' '')
            from pre.tobjetivo ob
            where ob.codigo = ANY (string_to_array(tpla.codigo_poa,'',''))
            )::varchar as codigo_descripcion



        FROM plani.tplanilla tpla
        INNER JOIN segu.tusuario tusu on tusu.id_usuario = tpla.id_usuario_reg
        INNER JOIN orga.vfuncionario_persona vfp on vfp.id_persona = tusu.id_persona

        inner join plani.tfuncionario_planilla tfp on tfp.id_planilla = tpla.id_planilla

        INNER JOIN orga.tuo_funcionario tuof on tuof.id_uo_funcionario = tfp.id_uo_funcionario

        /*inner join param.tperiodo tper on tper.id_periodo = tpla.id_periodo
        inner join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuof.id_cargo and tcp.id_gestion = '||v_id_gestion||' and
        ((tper.fecha_ini between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)) or
        (tper.fecha_fin between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)))*/
         '||v_inner_periodo||'

        inner join orga.vfuncionario vf on vf.id_funcionario = tfp.id_funcionario

        inner JOIN plani.tcolumna_valor tcv on tcv.id_funcionario_planilla = tfp.id_funcionario_planilla --and tcv.codigo_columna = ''SUELDOBA''

        inner JOIN conta.trelacion_contable trc on trc.id_tabla = tcv.id_tipo_columna and trc.id_centro_costo = tcp.id_centro_costo and
        case when tfp.tipo_contrato = ''PLA'' then trc.id_tipo_relacion_contable = 27 when tfp.tipo_contrato = ''EVE'' then trc.id_tipo_relacion_contable = 28 else false end

        inner join param.tcentro_costo tcc on tcc.id_centro_costo = tcp.id_centro_costo
        inner join param.ttipo_cc ttc on ttc.id_tipo_cc = tcc.id_tipo_cc



        INNER JOIN pre.tpresupuesto    tp ON tp.id_presupuesto = tcc.id_centro_costo
        INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog

        INNER JOIN pre.tpartida tpar ON tpar.id_partida = trc.id_partida and tpar.id_gestion = '||v_id_gestion||'

        left join pre.tpresupuesto_partida_entidad tppe on tppe.id_partida = trc.id_partida and tppe.id_presupuesto = tp.id_presupuesto and tppe.id_gestion = '||v_id_gestion||'
        and case when tcv.codigo_columna = ''CAJSAL'' THEN (case when vf.ci = ''630048'' then tppe.id_entidad_transferencia = 22 else tppe.id_entidad_transferencia = 21 end) else (tppe.id_entidad_transferencia !=21 and tppe.id_entidad_transferencia !=22) end

        left join pre.tentidad_transferencia tet on tet.id_entidad_transferencia = tppe.id_entidad_transferencia and tet.id_gestion = '||v_id_gestion||'

        left join pre.tclase_gasto_partida tcgp on tcgp.id_partida = trc.id_partida
        left join pre.tclase_gasto tcg on tcg.id_clase_gasto = tcgp.id_clase_gasto
        WHERE tcp.id_gestion = '||v_id_gestion||' and tpla.estado_reg = ''activo'' AND tpla.id_proceso_wf = '||v_parametros.id_proceso_wf;

        v_consulta =  v_consulta ||
            ' GROUP BY
              vcp.id_categoria_programatica,
              ttc.codigo,
              vcp.codigo_programa,vcp.codigo_proyecto, vcp.codigo_actividad, vcp.codigo_fuente_fin, vcp.codigo_origen_fin,
              tpar.codigo , tpar.nombre_partida,
              tcg.codigo, tcg.nombre, tpla.nro_planilla, tet.codigo, tpla.fecha_planilla, tpla.observaciones, tpla.codigo_poa, vfp.desc_funcionario1 ';

        v_consulta =  v_consulta || 'ORDER BY tpar.codigo, tcg.nombre, vcp.id_categoria_programatica, ttc.codigo asc  ';

        --Devuelve la respuesta
        RAISE NOTICE 'v_consulta %',v_consulta;
        return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PLA_REPCLACATPRO_SEL'
     #DESCRIPCION:    Reporte Clasificacion categoria programatica Planillas
     #AUTOR:        FEA
     #FECHA:        14-02-2018 15:00
    ***********************************/

    elsif(p_transaccion='PLA_REPCLACATPRO_SEL')then

        begin

            SELECT tpl.codigo, tp.id_gestion
            INTO v_desc_planilla, v_id_gestion
            FROM plani.tplanilla tp
            INNER JOIN plani.ttipo_planilla tpl on tpl.id_tipo_planilla = tp.id_tipo_planilla
            WHERE tp.id_proceso_wf =  v_parametros.id_proceso_wf;

            if v_desc_planilla = 'PLASUB' then
                v_porcentaje = '/0.87';
            /*else
                v_porcentaje = '';*/
            end if;

            --raise exception 'v_desc_planilla: %, v_id_gestion: %', v_desc_planilla, v_id_gestion;
            if v_desc_planilla = 'PLASUB' or v_desc_planilla = 'PLASUE' then
                v_inner_periodo = 'inner join param.tperiodo tper on tper.id_periodo = tpla.id_periodo
                                   inner join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuof.id_cargo and tcp.id_gestion = '||v_id_gestion||' and
                                   ((tper.fecha_ini between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)) or
                                   (tper.fecha_fin between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)))';
            else
                v_inner_periodo = 'inner join param.tperiodo tper on tper.periodo = extract(''month'' from tpla.fecha_planilla) and tper.id_gestion = '||v_id_gestion||'
                                   inner join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuof.id_cargo and tcp.id_gestion = '||v_id_gestion||' and
                                   ((tper.fecha_ini between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)) or
                                   (tper.fecha_fin between tcp.fecha_ini and coalesce(tcp.fecha_fin,''31/12/2018''::date)))';
            end if;

            /*select g.id_gestion
             into v_id_gestion
             from param.tgestion g
             where g.gestion = EXTRACT(YEAR FROM current_date);*/

            v_id_funcionario = 57;

            select vf.desc_funcionario1
            into v_desc_funcionario
            from orga.vfuncionario vf
            where vf.id_funcionario = v_id_funcionario;

            --Gerencia del funcionario solicitante
            WITH RECURSIVE gerencia(id_uo, id_nivel_organizacional, nombre_unidad, nombre_cargo, codigo) AS (
              SELECT tu.id_uo, tu.id_nivel_organizacional, tu.nombre_unidad, tu.nombre_cargo, tu.codigo
              FROM orga.tuo  tu
              INNER JOIN orga.tuo_funcionario tf ON tf.id_uo = tu.id_uo
              WHERE tf.id_funcionario = v_id_funcionario and tu.estado_reg = 'activo'

              UNION ALL

              SELECT teu.id_uo_padre, tu1.id_nivel_organizacional, tu1.nombre_unidad, tu1.nombre_cargo, tu1.codigo
              FROM orga.testructura_uo teu
              INNER JOIN gerencia g ON g.id_uo = teu.id_uo_hijo
              INNER JOIN orga.tuo tu1 ON tu1.id_uo = teu.id_uo_padre
              WHERE substring(g.nombre_cargo,1,7) <> 'Gerente'
              )

            SELECT (codigo||'-'||nombre_unidad)::varchar
            INTO v_gerencia
            FROM gerencia
            ORDER BY id_nivel_organizacional asc limit 1;
            --end gerencia

            SELECT tpla.estado, tpla.id_estado_wf, 'ninguna 7.7.7'::varchar as obs
            INTO v_record_op
            FROM plani.tplanilla tpla
            WHERE tpla.id_proceso_wf = v_parametros.id_proceso_wf;


            SELECT tpo.nombre
            INTO v_cod_proceso
            FROM wf.tproceso_wf tpw
            INNER JOIN wf.ttipo_proceso ttp ON ttp.id_tipo_proceso = tpw.id_tipo_proceso
            INNER JOIN wf.tproceso_macro tpo ON tpo.id_proceso_macro = ttp.id_proceso_macro
            WHERE tpw.id_proceso_wf = v_parametros.id_proceso_wf;

            IF(v_record_op.estado IN ('vbpresupuestos', 'suppresu', 'comprobante_generado', 'planilla_finalizada'))THEN
              v_index = 1;
              FOR v_record IN (WITH RECURSIVE firmas(id_estado_fw, id_estado_anterior,fecha_reg, codigo, id_funcionario) AS (
                                SELECT tew.id_estado_wf, tew.id_estado_anterior , tew.fecha_reg, te.codigo, tew.id_funcionario
                                FROM wf.testado_wf tew
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = tew.id_tipo_estado
                                WHERE tew.id_estado_wf = v_record_op.id_estado_wf

                                UNION ALL

                                SELECT ter.id_estado_wf, ter.id_estado_anterior, ter.fecha_reg, te.codigo, ter.id_funcionario
                                FROM wf.testado_wf ter
                                INNER JOIN firmas f ON f.id_estado_anterior = ter.id_estado_wf
                                INNER JOIN wf.ttipo_estado te ON te.id_tipo_estado = ter.id_tipo_estado
                                WHERE f.id_estado_anterior IS NOT NULL
                            )SELECT distinct on (codigo) codigo, fecha_reg , id_estado_fw, id_estado_anterior, id_funcionario FROM firmas ORDER BY codigo, fecha_reg DESC) LOOP

                  IF(v_record.codigo = 'vbpoa' OR v_record.codigo = 'suppresu' OR v_record.codigo = 'vbpresupuestos' OR v_record.codigo = 'comprobante_generado')THEN
                        SELECT vf.desc_funcionario1, vf.nombre_cargo, vf.oficina_nombre
                        INTO v_record_funcionario
                        FROM orga.vfuncionario_cargo_lugar vf
                        WHERE vf.id_funcionario = v_record.id_funcionario;
                        v_firmas[v_index] = v_record.codigo::VARCHAR||','||v_record.fecha_reg::VARCHAR||','||v_record_funcionario.desc_funcionario1::VARCHAR||','||v_record_funcionario.nombre_cargo::VARCHAR||','||v_record_funcionario.oficina_nombre;
                        v_index = v_index + 1;
                  END IF;
              END LOOP;
                v_firma_fun = array_to_string(v_firmas,';');
            ELSE
                v_firma_fun = '';
            END IF;
            ------
            SELECT (''||te.codigo||' '||te.nombre)::varchar
            INTO v_nombre_entidad
            FROM param.tempresa te;
            ------
            SELECT (''||tda.codigo||' '||tda.nombre)::varchar
            INTO v_direccion_admin
            FROM pre.tdireccion_administrativa tda;
            ------
            SELECT (''||tue.codigo||' '||tue.nombre)::varchar
            INTO v_unidad_ejecutora
            FROM pre.tunidad_ejecutora tue;
            ---

            --Sentencia de la consulta de conteo de registros
            v_consulta:='
            SELECT

            vcp.codigo_categoria::varchar,
            (''(''||ttc.codigo||'')''||ttc.descripcion)::varchar as presupuesto,
            vf.desc_funcionario2::varchar as desc_funcionario,
            tcar.nombre::varchar as cargo,
            tofi.nombre::varchar as oficina,
            ''Bs''::varchar AS codigo_moneda,
            tpla.nro_planilla as num_tramite,
            '''||v_nombre_entidad||'''::varchar AS nombre_entidad,
            COALESCE('''||v_direccion_admin||'''::varchar, '''') AS direccion_admin,
            '''||v_unidad_ejecutora||'''::varchar AS unidad_ejecutora,
             COALESCE('''||v_firma_fun||'''::varchar, '''') AS firmas,
            COALESCE(tpla.observaciones::varchar,'''')::varchar as justificacion,
            COALESCE(tet.codigo::varchar,''00''::varchar) AS codigo_transf,
            '''||v_gerencia||'''::varchar AS unidad_solicitante,
            vfp.desc_funcionario1::varchar as funcionario_solicitante,
            '''||v_cod_proceso||'''::varchar AS codigo_proceso,
            COALESCE(tpla.fecha_planilla,null::date) AS fecha_soli,
            extract(year from fecha_planilla)::integer as gestion,
            tpla.codigo_poa as codigo_poa,
            (select  pxp.list(distinct ob.codigo|| '' ''||ob.descripcion||'' '')
            from pre.tobjetivo ob
            where ob.codigo = ANY (string_to_array(tpla.codigo_poa,'',''))
            )::varchar as codigo_descripcion
            FROM plani.tplanilla tpla
            INNER JOIN segu.tusuario tusu on tusu.id_usuario = tpla.id_usuario_reg
            INNER JOIN orga.vfuncionario_persona vfp on vfp.id_persona = tusu.id_persona

            inner join plani.tfuncionario_planilla tfp on tfp.id_planilla = tpla.id_planilla
            INNER JOIN orga.tuo_funcionario tuof on tuof.id_uo_funcionario = tfp.id_uo_funcionario
            '||v_inner_periodo||'
            inner join plani.ttipo_planilla ttp on ttp.id_tipo_planilla = tpla.id_tipo_planilla
            inner join orga.tcargo tcar on tcar.id_cargo = tcp.id_cargo
            inner join orga.toficina tofi on tofi.id_oficina = tcar.id_oficina
            inner join orga.vfuncionario vf on vf.id_funcionario = tfp.id_funcionario
            inner JOIN plani.tcolumna_valor tcv on tcv.id_funcionario_planilla = tfp.id_funcionario_planilla
            inner JOIN conta.trelacion_contable trc on trc.id_tabla = tcv.id_tipo_columna and trc.id_centro_costo = tcp.id_centro_costo and trc.id_gestion = 16 and
            case when tfp.tipo_contrato = ''PLA'' then trc.id_tipo_relacion_contable = 27 when tfp.tipo_contrato = ''EVE'' then trc.id_tipo_relacion_contable = 28  end
            inner join param.tcentro_costo tcc on tcc.id_centro_costo = tcp.id_centro_costo and tcc.id_gestion = '||v_id_gestion||'
            inner join param.ttipo_cc ttc on ttc.id_tipo_cc = tcc.id_tipo_cc
            INNER JOIN pre.tpresupuesto    tp ON tp.id_presupuesto = tcc.id_centro_costo
            INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tp.id_categoria_prog and vcp.id_gestion = 1'||v_id_gestion||'

            INNER JOIN pre.tpartida tpar ON tpar.id_partida = trc.id_partida and tpar.id_gestion = '||v_id_gestion||'

            left join pre.tpresupuesto_partida_entidad tppe on tppe.id_partida = trc.id_partida and tppe.id_presupuesto = tp.id_presupuesto and tppe.id_gestion = '||v_id_gestion||'
            and case when tcv.codigo_columna = ''CAJSAL'' THEN (case when vf.ci = ''630048'' then tppe.id_entidad_transferencia = 22 else tppe.id_entidad_transferencia = 21 end)
            else (tppe.id_entidad_transferencia !=21 and tppe.id_entidad_transferencia !=22) end

            left join pre.tentidad_transferencia tet on tet.id_entidad_transferencia = tppe.id_entidad_transferencia and tet.id_gestion = '||v_id_gestion||'

            INNER join pre.tclase_gasto_partida tcgp on tcgp.id_partida = trc.id_partida
            INNER join pre.tclase_gasto tcg on tcg.id_clase_gasto = tcgp.id_clase_gasto
            WHERE tcp.id_gestion = 16 and tpla.estado_reg = ''activo'' AND tpla.id_proceso_wf = '||v_parametros.id_proceso_wf;

        v_consulta =  v_consulta ||
            ' GROUP BY
              vcp.codigo_categoria, presupuesto, vf.desc_funcionario2,tcar.nombre, tofi.nombre ';

        v_consulta =  v_consulta || 'ORDER BY vcp.codigo_categoria asc, presupuesto asc, vf.desc_funcionario2 asc  ';

        --Devuelve la respuesta
        RAISE NOTICE 'v_consulta %',v_consulta;
        return v_consulta;

        end;

    else

      raise exception 'Transaccion inexistente';

    end if;

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