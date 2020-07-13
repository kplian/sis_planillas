-- FUNCTION: plani.ft_funcionario_planilla_sel(integer, integer, character varying, character varying)

-- DROP FUNCTION plani.ft_funcionario_planilla_sel(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION plani.ft_funcionario_planilla_sel(
	p_administrador integer,
	p_id_usuario integer,
	p_tabla character varying,
	p_transaccion character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:        Sistema de Planillas
 FUNCION:         plani.ft_funcionario_planilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tfuncionario_planilla'
 AUTOR:          (admin)
 FECHA:            22-01-2014 16:11:08
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
     HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 #51            18/07/2019        RAC       bug en ordenacion , se agrgan alias
 #29 ETR        20/08/2019        MMV       Columna Codigo Funcionarion
 #53 ETR        26/09/2019        RAC       listado para Interface que identifica empleado según centro de costo
 #78 ETR        18/11/2019        RAC       considerar esquema origen de datos para listado de backups, PLA_FUNPLAN_SEL
 #103 ETR       02/04/2020        RAC       Listado de funcionarios  sin contador para envio de boletas de pago
 #131 ETR       03/06/2020        RAC       Agregar columnas en listado basico para mostrar si fue enviada la boleta de pago

***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_registros           record;
    v_nombre_funcion      text;
    v_resp                varchar;
    v_fecha_ini           date;
    v_fecha_fin           date;
    v_esquema             varchar;

BEGIN

    v_nombre_funcion = 'plani.ft_funcionario_planilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PLA_FUNPLAN_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
    ***********************************/

    if(p_transaccion='PLA_FUNPLAN_SEL')then

        begin

            -- #78
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
               v_esquema = v_parametros.esquema;
            ELSE
               v_esquema = 'plani';
            END IF;

            --Sentencia de la consulta
            v_consulta:='select
                        funplan.id_funcionario_planilla,
                        funplan.finiquito,
                        funplan.forzar_cheque,
                        funplan.id_funcionario,
                        funplan.id_planilla,
                        funplan.id_lugar,
                        funplan.id_uo_funcionario,
                        funplan.estado_reg,
                        funplan.id_usuario_reg,
                        funplan.fecha_reg,
                        funplan.id_usuario_mod,
                        funplan.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        funcio.desc_funcionario2,
                        lug.nombre as lugar,
                        afp.nombre,
                        fafp.nro_afp,
                        ins.nombre as banco,
                        fcb.nro_cuenta,
                        funcio.ci,
                        (c.nombre || ''--'' || c.codigo)::varchar desc_cargo,
                        funplan.tipo_contrato,
                        funcio.codigo as desc_codigo,  --#29
                        funplan.sw_boleta --#131
                        from '||v_esquema||'.tfuncionario_planilla funplan
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = funplan.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join segu.tusuario usu1 on usu1.id_usuario = funplan.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = funplan.id_usuario_mod
                        inner join orga.vfuncionario funcio on funcio.id_funcionario = funplan.id_funcionario
                        left join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = funplan.id_afp
                        left join plani.tafp afp on afp.id_afp = fafp.id_afp
                        inner join param.tlugar lug on lug.id_lugar = funplan.id_lugar
                        left join orga.tfuncionario_cuenta_bancaria fcb on  fcb.id_funcionario_cuenta_bancaria = funplan.id_cuenta_bancaria
                        left join param.tinstitucion ins on ins.id_institucion = fcb.id_institucion
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PLA_FUNPLAN_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
    ***********************************/

    elsif(p_transaccion='PLA_FUNPLAN_CONT')then

        begin

            -- #78
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
               v_esquema = v_parametros.esquema;
            ELSE
               v_esquema = 'plani';
            END IF;

            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_funcionario_planilla)
                        from plani.tfuncionario_planilla funplan
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = funplan.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join segu.tusuario usu1 on usu1.id_usuario = funplan.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = funplan.id_usuario_mod
                        inner join orga.vfuncionario funcio on funcio.id_funcionario = funplan.id_funcionario
                        left join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = funplan.id_afp
                        left join plani.tafp afp on afp.id_afp = fafp.id_afp
                        inner join param.tlugar lug on lug.id_lugar = funplan.id_lugar
                        left join orga.tfuncionario_cuenta_bancaria fcb on
                            fcb.id_funcionario_cuenta_bancaria = funplan.id_cuenta_bancaria
                        left join param.tinstitucion ins on ins.id_institucion = fcb.id_institucion
                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;


    /*********************************
     #TRANSACCION:  'PLA_FUNPLANALL_SEL'
     #DESCRIPCION:  Listado de todos lso funcionarios de la planilla sin paginacion para envio de boeltas
     #AUTOR:        RAC
     #FECHA:        02-04-2020
     #ISSUE:        103
    ***********************************/

    elseif(p_transaccion='PLA_FUNPLANALL_SEL')then

        begin


             select
                p.estado,
                tp.id_tipo_planilla
             into
                v_registros
             from plani.tplanilla p
             join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
             where p.id_planilla =  v_parametros.id_planilla;


            -- validar estado de la planilla
            IF v_registros.estado not in ('planilla_finalizada','comprobante_generado','vobo_conta','obligaciones_generadas') THEN --que estado se peude imprimir la boleta
               raise exception 'no puede mandar boletas en el estado: %',v_registros.estado;
            END IF;

            --validar que el tipo de  planilla tenga boletas configuradas
            if (not exists( select 1
                         from plani.treporte r
                         where r.id_tipo_planilla = v_registros.id_tipo_planilla and r.estado_reg = 'activo' and
                               r.tipo_reporte = 'boleta')) then
                raise exception 'No existe  un reporte de boleta de pago para este tipo de planilla';
            end if;


            --Sentencia de la consulta
            v_consulta:=' select
                                funplan.id_funcionario_planilla,
                                funplan.id_funcionario,
                                funplan.id_planilla,
                                funcio.desc_funcionario1,
                                funcio.email_empresa
                          from plani.tfuncionario_planilla funplan
                          inner join orga.vfuncionario_persona funcio on funcio.id_funcionario = funplan.id_funcionario
                          where  funplan.id_planilla = '||v_parametros.id_planilla ||'
                            and  funplan.estado_reg = ''activo''
                            and  funplan.sw_boleta = ''no''; -- #131 solo lista los funcionario a los que no se les mando boleta de pago';

            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PLA_ALTPER_SEL'
     #DESCRIPCION:    Listado de altas de personal en un periodo
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
    ***********************************/

    elsif(p_transaccion='PLA_ALTPER_SEL')then

        begin
            select per.fecha_ini, per.fecha_fin into v_fecha_ini,v_fecha_fin
            from param.tperiodo per
            where per.id_periodo = v_parametros.id_periodo;

            --Sentencia de la consulta de conteo de registros
            v_consulta:='with detail as
                            (select  uo.prioridad,uo.nombre_unidad,car.nombre as cargo,esal.haber_basico, tc.nombre as tipo_contrato, fun.desc_funcionario2,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion) as fecha_inicio,vcc.codigo_cc,
                            car.codigo as item,uofun.certificacion_presupuestaria as certificacion,
                            ROW_NUMBER()OVER (PARTITION BY fun.desc_funcionario2
                                                             ORDER BY plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion) ASC) as rk
                            from orga.tuo_funcionario uofun
                            inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                            inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                            inner join orga.tescala_salarial esal on esal.id_escala_salarial = car.id_escala_salarial
                            left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = ' || v_parametros.id_gestion || ' and carcc.estado_reg = ''activo''
                            left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                            inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                            inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,now()::date)
                            where uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'') and
                            (uofun.fecha_asignacion between ''' || v_fecha_ini || ''' and
                            ''' || v_fecha_fin || ''') and
                            (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion) between ''' || v_fecha_ini || ''' and
                            ''' || v_fecha_fin || '''))
                        select d.nombre_unidad,d.cargo,d.haber_basico,d.tipo_contrato,d.codigo_cc, d.desc_funcionario2,d.fecha_inicio,d.item,d.certificacion
                        from detail d
                        where d.rk =1
                        order by d.prioridad::integer ASC, d.desc_funcionario2 ASC';


            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
     #TRANSACCION:  'PLA_BAJPER_SEL'
     #DESCRIPCION:    Listado de bajas de personal en un periodo
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
    ***********************************/

    elsif(p_transaccion='PLA_BAJPER_SEL')then

        begin
            select per.fecha_ini, per.fecha_fin into v_fecha_ini,v_fecha_fin
            from param.tperiodo per
            where per.id_periodo = v_parametros.id_periodo;

            v_fecha_ini = v_fecha_ini - interval '1 day';
            v_fecha_fin = v_fecha_fin - interval '1 day';

            --Sentencia de la consulta de conteo de registros
            v_consulta:='with detail as
                        (select  uo.prioridad,uo.nombre_unidad,car.nombre as cargo,tc.nombre as tipo_contrato, esal.haber_basico,fun.desc_funcionario2,uofun.fecha_finalizacion,vcc.codigo_cc,
                        car.codigo as item,
                        ROW_NUMBER()OVER (PARTITION BY fun.desc_funcionario2
                                                         ORDER BY uofun.fecha_finalizacion DESC) as rk
                        from orga.tuo_funcionario uofun
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                        inner join orga.tescala_salarial esal on esal.id_escala_salarial = car.id_escala_salarial
                        left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                        left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                        inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,now()::date)
                        where uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'') and
                        (uofun.fecha_finalizacion between ''' || v_fecha_ini || ''' and
                        ''' || v_fecha_fin || ''') and
                        not exists (select 1
                                    from orga.tuo_funcionario temp2
                                    inner join orga.tcargo tcar on tcar.id_cargo = temp2.id_cargo
                                    inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tcar.id_tipo_contrato
                                    where ttc.codigo in (''PLA'', ''EVE'') and
                                    temp2.fecha_asignacion = uofun.fecha_finalizacion + interval ''1 day''
                                    and temp2.estado_reg = ''activo'' and temp2.tipo= ''oficial'' and
                                    temp2.id_funcionario = uofun.id_funcionario))
                        select d.nombre_unidad,d.cargo,d.haber_basico,d.tipo_contrato,d.codigo_cc, d.desc_funcionario2,d.fecha_finalizacion,d.item
                        from detail d
                        where d.rk =1
                        order by d.prioridad::integer ASC, d.desc_funcionario2 ASC';


            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
     #TRANSACCION:  'PLA_MOVPER_SEL'
     #DESCRIPCION:    Listado de movimientos de personal en un periodo
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
    ***********************************/

    elsif(p_transaccion='PLA_MOVPER_SEL')then

        begin
            select per.fecha_ini, per.fecha_fin into v_fecha_ini,v_fecha_fin
            from param.tperiodo per
            where per.id_periodo = v_parametros.id_periodo;

            v_fecha_ini = v_fecha_ini - interval '1 day';
            v_fecha_fin = v_fecha_fin - interval '1 day';

            --Sentencia de la consulta de conteo de registros
            v_consulta:='select  fun.desc_funcionario2,uofundes.fecha_asignacion as fecha_movimiento,uo.nombre_unidad as gerencia_anterior, car.nombre as cargo_anterior,tc.nombre as tipo_contrato_anterior,vcc.codigo_cc as presupuesto_anterior, esal.haber_basico as sueldo_anterior,uodes.nombre_unidad as gerencia_actual, cardes.nombre as cargo_actual,tcdes.nombre as tipo_contrato_actual,vccdes.codigo_cc as presupuesto_actual, esaldes.haber_basico as sueldo_actual,cardes.codigo as item_actual,uofundes.certificacion_presupuestaria as certificacion
                        from orga.tuo_funcionario uofun
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                        left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = ' || v_parametros.id_gestion || '  and carcc.estado_reg = ''activo''
                        left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                        inner join orga.tescala_salarial esal on esal.id_escala_salarial = car.id_escala_salarial
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                        inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,now()::date)
                        inner join orga.tuo_funcionario uofundes on uofundes.id_funcionario = fun.id_funcionario and
                            uofundes.fecha_asignacion = uofun.fecha_finalizacion + interval ''1 day''
                                    and uofundes.estado_reg = ''activo'' and uofundes.tipo= ''oficial''
                        inner join orga.vfuncionario fundes on fundes.id_funcionario = uofundes.id_funcionario
                        inner join orga.tcargo cardes on cardes.id_cargo = uofundes.id_cargo
                        left join orga.tcargo_presupuesto carccdes on cardes.id_cargo = carccdes.id_cargo and carccdes.id_gestion = ' || v_parametros.id_gestion || ' and carccdes.estado_reg = ''activo''
                        left join pre.vpresupuesto_cc vccdes on vccdes.id_centro_costo=carccdes.id_centro_costo
                        inner join orga.tescala_salarial esaldes on esaldes.id_escala_salarial = cardes.id_escala_salarial
                        inner join orga.ttipo_contrato tcdes on tcdes.id_tipo_contrato = cardes.id_tipo_contrato
                        inner join orga.tuo uodes on uodes.id_uo = orga.f_get_uo_gerencia(uofundes.id_uo,NULL,now()::date)
                        where uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'') and
                        tcdes.codigo in (''PLA'', ''EVE'') and (car.nombre != cardes.nombre or esal.haber_basico != esaldes.haber_basico)
                        and (uofun.fecha_finalizacion between '''  || v_fecha_ini ||  ''' and ''' || v_fecha_fin || ''')
                        order by uo.prioridad::integer ASC, fun.desc_funcionario2 ASC';


            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
     #TRANSACCION:  'PLA_ANTIPER_SEL'
     #DESCRIPCION:    Listado de nuevas antiguedades en un periodo
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
    ***********************************/

    elsif(p_transaccion='PLA_ANTIPER_SEL')then

        begin
            select per.fecha_ini, per.fecha_ini into v_fecha_ini,v_fecha_fin
            from param.tperiodo per
            where per.id_periodo = v_parametros.id_periodo;

            v_fecha_ini = v_fecha_ini + interval '1 day' - interval '1 month';


            --Sentencia de la consulta de conteo de registros
            v_consulta:='(select  ''2 AÑOS''::varchar as antiguedad, uo.nombre_unidad ,car.nombre as cargo,tc.nombre as tipo_contrato,vcc.codigo_cc,fun.desc_funcionario1 as funcionario,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso, (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''2 year'')::date as fecha_dos_anos
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                          left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                          where uofun.fecha_asignacion <= ''' || v_fecha_fin || '''::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= ''' || v_fecha_fin || '''::date)
                          and uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'') and uofun.estado_reg = ''activo''
                          and ((plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''2 year'')::date between ''' || v_fecha_ini || ''' and ''' || v_fecha_fin || ''')
                          order by fecha_dos_anos)

                          union all

                          (select  ''5 AÑOS''::varchar as antiguedad,uo.nombre_unidad ,car.nombre as cargo,tc.nombre as tipo_contrato,vcc.codigo_cc,fun.desc_funcionario1 as funcionario,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso, (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''5 year'')::date as fecha_cinco_anos
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                          left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                          where uofun.fecha_asignacion <= ''' || v_fecha_fin || '''::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= ''' || v_fecha_fin || '''::date)
                          and uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'')  and uofun.estado_reg = ''activo''
                          and ((plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''5 year'')::date between ''' || v_fecha_ini || ''' and ''' || v_fecha_fin || ''')
                          order by fecha_cinco_anos)

                          union all

                          (select  ''8 AÑOS''::varchar as antiguedad,uo.nombre_unidad ,car.nombre as cargo,tc.nombre as tipo_contrato,vcc.codigo_cc,fun.desc_funcionario1 as funcionario,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso, (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''8 year'')::date as fecha_ocho_anos
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                          left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                          where uofun.fecha_asignacion <= ''' || v_fecha_fin || '''::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= ''' || v_fecha_fin || '''::date)
                          and uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'')  and uofun.estado_reg = ''activo''
                          and ((plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''8 year'')::date between ''' || v_fecha_ini || ''' and ''' || v_fecha_fin || ''')
                          order by fecha_ocho_anos)

                          union all

                          (select  ''11 AÑOS''::varchar as antiguedad,uo.nombre_unidad ,car.nombre as cargo,tc.nombre as tipo_contrato,vcc.codigo_cc,fun.desc_funcionario1 as funcionario,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso, (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''11 year'')::date as fecha_once_anos
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                          left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                          where uofun.fecha_asignacion <= ''' || v_fecha_fin || '''::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= ''' || v_fecha_fin || '''::date)
                          and uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'')  and uofun.estado_reg = ''activo''
                          and ((plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''11 year'')::date between ''' || v_fecha_ini || ''' and ''' || v_fecha_fin || ''')
                          order by fecha_once_anos)

                          union all

                          (select  ''15 AÑOS''::varchar as antiguedad,uo.nombre_unidad ,car.nombre as cargo,tc.nombre as tipo_contrato,vcc.codigo_cc,fun.desc_funcionario1 as funcionario,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso, (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''15 year'')::date as fecha_quince_anos
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                          left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                          where uofun.fecha_asignacion <= ''' || v_fecha_fin || '''::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= ''' || v_fecha_fin || '''::date)
                          and uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'')  and uofun.estado_reg = ''activo''
                          and ((plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''15 year'')::date between ''' || v_fecha_ini || ''' and ''' || v_fecha_fin || ''')
                          order by fecha_quince_anos)

                          union all

                          (select  ''20 AÑOS''::varchar as antiguedad,uo.nombre_unidad ,car.nombre as cargo,tc.nombre as tipo_contrato,vcc.codigo_cc,fun.desc_funcionario1 as funcionario,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso, (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''20 year'')::date as fecha_veinte_anos
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                          left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                          where uofun.fecha_asignacion <= ''' || v_fecha_fin || '''::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= ''' || v_fecha_fin || '''::date)
                          and uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'')  and uofun.estado_reg = ''activo''
                          and ((plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''20 year'')::date between ''' || v_fecha_ini || ''' and ''' || v_fecha_fin || ''')
                          order by fecha_veinte_anos)

                            union all

                          (select  ''25 AÑOS''::varchar as antiguedad,uo.nombre_unidad ,car.nombre as cargo,tc.nombre as tipo_contrato,vcc.codigo_cc,fun.desc_funcionario1 as funcionario,plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso, (plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''25 year'')::date as fecha_veinticinco_anos
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          left join orga.tcargo_presupuesto carcc on car.id_cargo = carcc.id_cargo and carcc.id_gestion = 13 and carcc.estado_reg = ''activo''
                          left join pre.vpresupuesto_cc vcc on vcc.id_centro_costo=carcc.id_centro_costo
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                          where uofun.fecha_asignacion <= ''' || v_fecha_fin || '''::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= ''' || v_fecha_fin || '''::date)
                          and uofun.tipo = ''oficial'' and tc.codigo in (''PLA'', ''EVE'')  and uofun.estado_reg = ''activo''
                          and ((plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) + interval ''25 year'')::date between ''' || v_fecha_ini || ''' and ''' || v_fecha_fin || ''')
                          order by fecha_veinticinco_anos)



                          ';

            --Devuelve la respuesta
            return v_consulta;

        end;

   /*********************************
     #TRANSACCION:  'PLA_DETFUNPLAN_SEL'
     #DESCRIPCION:  #52  listado para Interface que identifica empleado según centro de costo
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
    ***********************************/

    elsif(p_transaccion='PLA_DETFUNPLAN_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select
                            funplan.id_funcionario_planilla,
                            funplan.finiquito,
                            funplan.forzar_cheque,
                            funplan.id_funcionario,
                            funplan.id_planilla,
                            funplan.id_lugar,
                            funplan.id_uo_funcionario,
                            funplan.estado_reg,
                            funplan.id_usuario_reg,
                            funplan.fecha_reg,
                            funplan.id_usuario_mod,
                            funplan.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            funcio.desc_funcionario2,
                            lug.nombre as lugar,
                            afp.nombre,
                            fafp.nro_afp,
                            ins.nombre as banco,
                            fcb.nro_cuenta,
                            funcio.ci,
                            (c.nombre || ''--'' || c.codigo)::varchar desc_cargo,
                            funplan.tipo_contrato,
                            funcio.codigo as desc_codigo,
                            pro.id_presupuesto
                        from plani.tfuncionario_planilla funplan
                        inner join plani.tprorrateo pro ON pro.id_funcionario_planilla = funplan.id_funcionario_planilla
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = funplan.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join segu.tusuario usu1 on usu1.id_usuario = funplan.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = funplan.id_usuario_mod
                        inner join orga.vfuncionario funcio on funcio.id_funcionario = funplan.id_funcionario
                        left join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = funplan.id_afp
                        left join plani.tafp afp on afp.id_afp = fafp.id_afp
                        inner join param.tlugar lug on lug.id_lugar = funplan.id_lugar
                        left join orga.tfuncionario_cuenta_bancaria fcb on
                            fcb.id_funcionario_cuenta_bancaria = funplan.id_cuenta_bancaria
                        left join param.tinstitucion ins on ins.id_institucion = fcb.id_institucion
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PLA_DETFUNPLAN_CONT'
     #DESCRIPCION:  #52  Conteo de registros
     #AUTOR:        RAC
     #FECHA:        26-09-2019 16:11:08
    ***********************************/

    elsif(p_transaccion='PLA_DETFUNPLAN_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(funplan.id_funcionario_planilla)
                        from plani.tfuncionario_planilla funplan
                        inner join plani.tprorrateo pro ON pro.id_funcionario_planilla = funplan.id_funcionario_planilla
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = funplan.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join segu.tusuario usu1 on usu1.id_usuario = funplan.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = funplan.id_usuario_mod
                        inner join orga.vfuncionario funcio on funcio.id_funcionario = funplan.id_funcionario
                        left join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = funplan.id_afp
                        left join plani.tafp afp on afp.id_afp = fafp.id_afp
                        inner join param.tlugar lug on lug.id_lugar = funplan.id_lugar
                        left join orga.tfuncionario_cuenta_bancaria fcb on
                            fcb.id_funcionario_cuenta_bancaria = funplan.id_cuenta_bancaria
                        left join param.tinstitucion ins on ins.id_institucion = fcb.id_institucion
                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',  v_consulta;
            --Devuelve la respuesta
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
$BODY$;

ALTER FUNCTION plani.ft_funcionario_planilla_sel(integer, integer, character varying, character varying)
    OWNER TO postgres;
