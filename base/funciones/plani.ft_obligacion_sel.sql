CREATE OR REPLACE FUNCTION plani.ft_obligacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Planillas
 FUNCION:         plani.ft_obligacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tobligacion'
 AUTOR:          (jrivera)
 FECHA:            14-07-2014 20:30:19
 COMENTARIOS:    
***************************************************************************
    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               14/07/2014       JRIVERA KPLIAN       creacion
 #38              10/09/2019       RAC KPLIAN           considerar si el cbte es independiente del flujo WF de planilla
 #46              23.09.2019        MZM                    Adicion de funcion para listado de abono en cuenta
 #56              30.09.2019        MZM                    Adicion de funcion para reporte resumen de saldos
 #56              08.10.2019        MZM                    Adicion de funcion para reporte detalle de saldos
 #56              31.10.2019        MZM                    inclusion de join con treporte para que funcione tanto desde la vista de obligaciones como desde generacion de reportes
 #78              19.11.2019        RAC                    considerar esquema origen de datos para listado de backups, PLA_OBLI_SEL
 #84			  18.12.2019		MZM						Considerar tipo_contrato para planilla resumen de aguinaldos
 #83	ETR		  09.12.2019		MZM						Habilitacion de reporte para backup de planilla
*/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_esquema             varchar; --#78
    v_condicion			  varchar; --#84
            
BEGIN

    v_nombre_funcion = 'plani.ft_obligacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PLA_OBLI_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        jrivera    
     #FECHA:        14-07-2014 20:30:19
    ***********************************/
    
   -- raise exception 'lelga';

    if(p_transaccion='PLA_OBLI_SEL')then
                     
        begin
        
            -- #78
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
               v_esquema = v_parametros.esquema;
            ELSE
               v_esquema = 'plani';
            END IF;
        
        
            --#38 agregar   datos de agrupador
            --Sentencia de la consulta
            v_consulta:='select
            
                          obli.id_obligacion,
                          obli.id_obligacion_agrupador, --#38
                          COALESCE(oa.acreedor, ''Ninguno'')::text as desc_agrupador , --#38
                          obli.id_auxiliar,
                          obli.id_cuenta,
                          obli.id_planilla,
                          obli.id_tipo_obligacion,
                          obli.monto_obligacion,
                          obli.acreedor,
                          obli.estado_reg,
                          obli.tipo_pago,
                          obli.descripcion,
                          obli.id_usuario_reg,
                          obli.usuario_ai,
                          obli.fecha_reg,
                          obli.id_usuario_ai,
                          obli.fecha_mod,
                          obli.id_usuario_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,
                          tipobli.es_pagable,
                          tipobli.descripcion as desc_tipo_obligacion,   --#38
                          obli.id_int_comprobante,                       --#38
                          oa.id_int_comprobante as id_int_comprobante_agrupador --#38                            
                        from '||v_esquema||'.tobligacion obli
                        inner join plani.ttipo_obligacion tipobli  on tipobli.id_tipo_obligacion = obli.id_tipo_obligacion
                        inner join segu.tusuario usu1 on usu1.id_usuario = obli.id_usuario_reg
                        left join '||v_esquema||'.tobligacion_agrupador oa on oa.id_obligacion_agrupador = obli.id_obligacion_agrupador
                        left join segu.tusuario usu2 on usu2.id_usuario = obli.id_usuario_mod                        
                        where  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
             
            --#38  pregunta si existe agrupador        
            if pxp.f_existe_parametro(p_tabla, 'groupBy') THEN
                v_consulta:=v_consulta||' order by ' ||v_parametros.groupBy|| ' ' ||v_parametros.groupDir|| ', '||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            else
                v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            end if;
            
            raise notice '%',v_consulta;
            
            --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'PLA_OBLI_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        jrivera    
     #FECHA:        14-07-2014 20:30:19
    ***********************************/

    elsif(p_transaccion='PLA_OBLI_CONT')then

        begin
            -- #78
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
               v_esquema = v_parametros.esquema;
            ELSE
               v_esquema = 'plani';
            END IF;
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(obli.id_obligacion)
                        from '||v_esquema||'.tobligacion obli
                        inner join plani.ttipo_obligacion tipobli  on tipobli.id_tipo_obligacion = obli.id_tipo_obligacion
                        inner join segu.tusuario usu1 on usu1.id_usuario = obli.id_usuario_reg
                        left  join '||v_esquema||'.tobligacion_agrupador oa on oa.id_obligacion_agrupador = obli.id_obligacion_agrupador
                        left join segu.tusuario usu2 on usu2.id_usuario = obli.id_usuario_mod                        
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
    elsif (p_transaccion='PLA_ABOCUE_SEL') THEN
        BEGIN
            v_consulta:='select
                         emp.codigo_bnb||substr(now()::date::varchar,1,4)||substr(now()::date::varchar,6,2)||substr(now()::date::varchar,9,2)||(select pxp.f_llenar_ceros((select count(*) from plani.tdetalle_transferencia where id_obligacion=detran.id_obligacion),6))
                         ||(select pxp.f_llenar_ceros(cast(replace(sum(monto_transferencia)||'''',''.'','''') as integer),13) from plani.tdetalle_transferencia where id_obligacion=detran.id_obligacion)
                         ||(select pxp.f_llenar_ceros(0,13)) as total,
                         (select pxp.f_llenar_espacio_blanco(fun.ci, 13))||
                        (select pxp.f_llenar_espacio_blanco(substr(fun.desc_funcionario2,1,30),30))||
                        ges.gestion||''''||(select pxp.f_llenar_ceros(per.periodo,2))||''1''||
                        (select pxp.f_llenar_ceros(cast(replace(detran.monto_transferencia||'''',''.'','''') as integer),13))||
                         (select pxp.f_llenar_espacio_blanco(regexp_replace(detran.nro_cuenta,''-'',''''),10))||(select tipo_abono from plani.ttipo_obligacion where id_tipo_obligacion=obli.id_tipo_obligacion) as detalle
                        , (select TO_CHAR(now(),''MMDD'')) as periodo
                        
                        
                        from plani.tdetalle_transferencia detran
                        inner join orga.vfuncionario fun
                            on fun.id_funcionario = detran.id_funcionario
                        inner join param.tinstitucion ins
                            on ins.id_institucion = detran.id_institucion
                        inner join segu.tusuario usu1 on usu1.id_usuario = detran.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = detran.id_usuario_mod
                        inner join plani.tobligacion obli on obli.id_obligacion=detran.id_obligacion
                        inner join plani.tplanilla plani on plani.id_planilla=obli.id_planilla
                        inner join param.tgestion ges on ges.id_gestion=plani.id_gestion
                        inner join param.tempresa emp on emp.id_empresa=ges.id_empresa
                        inner join param.tperiodo per on per.id_periodo=plani.id_periodo
                        inner join plani.ttipo_obligacion tipobli on tipobli.id_tipo_obligacion=obli.id_tipo_obligacion
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario=fun.id_funcionario and fp.id_planilla=plani.id_planilla
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario
                        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                        inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                        where '; 
                        
                        v_consulta:=v_consulta||v_parametros.filtro;
                        v_consulta:=v_consulta||' order by ofi.orden,fun.desc_funcionario2';
            return v_consulta;
        
        END;
    elsif (p_transaccion='PLA_ABOCUE_CONT') THEN
        BEGIN
            v_consulta:='select count(*) from plani.tdetalle_transferencia detran
                        inner join orga.vfuncionario fun
                            on fun.id_funcionario = detran.id_funcionario
                        inner join param.tinstitucion ins
                            on ins.id_institucion = detran.id_institucion
                        inner join segu.tusuario usu1 on usu1.id_usuario = detran.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = detran.id_usuario_mod
                        inner join plani.tobligacion obli on obli.id_obligacion=detran.id_obligacion
                        inner join plani.tplanilla plani on plani.id_planilla=obli.id_planilla
                        inner join param.tgestion ges on ges.id_gestion=plani.id_gestion
                        inner join param.tempresa emp on emp.id_empresa=ges.id_empresa
                        inner join param.tperiodo per on per.id_periodo=plani.id_periodo
                        inner join plani.ttipo_obligacion tipobli on tipobli.id_tipo_obligacion=obli.id_tipo_obligacion
                        where '; 
                        
                        v_consulta:=v_consulta||v_parametros.filtro;
            return v_consulta;
        
        END;            
    elsif (p_transaccion='PLA_REPOBANC_CONT') THEN --#56
        BEGIN
        
        --#84 
          v_condicion:=' and 0=0';
          if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then 
            if(v_parametros.id_tipo_contrato>0) then
              v_condicion = ' and tc.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
            end if;
          end if; 
            v_consulta:='select count(*) from plani.tdetalle_transferencia df
                    inner join plani.tobligacion o on o.id_obligacion = df.id_obligacion
                    and o.id_tipo_obligacion in (select id_tipo_obligacion from plani.ttipo_obligacion where codigo=''SUEL'')
                    inner join plani.tplanilla plani on plani.id_planilla = o.id_planilla
                    inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla --#56
                    inner join plani.tfuncionario_planilla fp on fp.id_funcionario = df.id_funcionario and
                    fp.id_planilla = plani.id_planilla
                    inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                    inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                    inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                    inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina
                    inner join param.tlugar l on ofi.id_lugar = l.id_lugar
                    inner join param.tinstitucion ins on ins.id_institucion=df.id_institucion
                    where '; 
                        
                    v_consulta:=v_consulta||v_parametros.filtro||v_condicion;--#84
            return v_consulta;
        
        END;
        
      elsif (p_transaccion='PLA_REPOBANC_SEL') THEN --#56
        BEGIN
        
        --#84 
          v_condicion:=' and 0=0';
          if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then 
            if(v_parametros.id_tipo_contrato>0) then
              v_condicion = ' and tc.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
            end if;
          end if; 
            
           v_consulta:='select ofi.nombre as oficina,sum(df.monto_transferencia)  as monto_pagar,
                        upper( param.f_get_periodo_literal(plani.id_periodo)) as periodo_lite,ins.nombre as banco,

                        ''Banco'' as tipo_pago,  tc.nombre as tipo_contrato, 
                         ofi.orden

                        from plani.tdetalle_transferencia df
                        inner join param.tinstitucion ins on ins.id_institucion = df.id_institucion
                        inner join plani.tobligacion o on o.id_obligacion = df.id_obligacion
                        inner join plani.tplanilla plani on plani.id_planilla = o.id_planilla
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla --#56
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario = df.id_funcionario and fp.id_planilla = plani.id_planilla
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        where ';
                        v_consulta:=v_consulta||v_parametros.filtro||v_condicion;--#84
                        v_consulta:=v_consulta||'
                        group by  tc.nombre , ofi.orden,
                        ofi.nombre ,o.tipo_pago, plani.id_periodo, ins.nombre
                        union all
                        select ofi.nombre as oficina,sum(o.monto_obligacion) as monto_pagar ,
                        upper( param.f_get_periodo_literal(plani.id_periodo)) as periodo_lite,''SIN BANCO'' as banco,
                        ''cheque'' as tipo_pago,  tc.nombre as tipo_contrato
                        ,ofi.orden
                        from plani.tobligacion o 
                        inner join plani.ttipo_obligacion tob on o.id_tipo_obligacion = tob.id_tipo_obligacion 
                        inner join plani.tplanilla plani on plani.id_planilla = o.id_planilla
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla --#56
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario = o.id_funcionario and fp.id_planilla = plani.id_planilla
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo inner 
                        join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina 
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        and o.tipo_pago = ''cheque'' and tob.tipo_obligacion = ''pago_empleados''
                        where ';
                        v_consulta:=v_consulta||v_parametros.filtro||v_condicion;--#84
                        v_consulta:=v_consulta||'
                        group by 
                        tc.nombre , ofi.orden,
                        ofi.nombre ,o.tipo_pago, plani.id_periodo
                        order by 6 desc, 5 desc, 7 asc,1 asc, 4 asc
                        ';
           return v_consulta;
        
        END; 
        
      elsif (p_transaccion='PLA_REPOBANCDET_SEL') THEN --#56
         BEGIN   
      --#84 
          v_condicion:=' and 0=0';
          if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then 
            if(v_parametros.id_tipo_contrato>0) then
              v_condicion = ' and tc.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
            end if;
          end if; 
          
          --#83
          IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                 v_esquema = v_parametros.esquema;
          ELSE
                 v_esquema = 'plani';
          END IF;
            v_consulta:='select ofi.nombre as oficina,sum(df.monto_transferencia)  as monto_pagar ,
                        upper( param.f_get_periodo_literal(plani.id_periodo)) as periodo_lite,ins.nombre as banco,
                        ''Banco'' as tipo_pago,  tc.nombre as tipo_contrato, fun.desc_funcionario2,df.nro_cuenta 
                        , ofi.orden, trim (both ''FUNODTPR'' from fun.codigo) as codigo
                        --#84
                        ,fun.ci
                        from '||v_esquema||'.tdetalle_transferencia df
                        inner join param.tinstitucion ins on ins.id_institucion = df.id_institucion
                        inner join '||v_esquema||'.tobligacion o on o.id_obligacion = df.id_obligacion
                        inner join '||v_esquema||'.tplanilla plani on plani.id_planilla = o.id_planilla
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla --#56
                        inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario = df.id_funcionario and fp.id_planilla = plani.id_planilla
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        where ';
            v_consulta:=v_consulta||v_parametros.filtro||v_condicion;--#84
            v_consulta:=v_consulta||' group by  tc.nombre , ofi.orden,
            ofi.nombre ,o.tipo_pago
            , plani.id_periodo , ins.nombre,fun.desc_funcionario2, df.nro_cuenta, fun.codigo, fun.ci
                        union all
                        select ofi.nombre as oficina,sum(o.monto_obligacion) as monto_pagar ,
                        upper( param.f_get_periodo_literal(plani.id_periodo)) as periodo_lite,''SIN BANCO'' as banco,
                        ''cheque'' as tipo_pago,  tc.nombre as tipo_contrato, fun.desc_funcionario2 ,''''::varchar as nro_cuenta
                        ,ofi.orden, trim (both ''FUNODTPR'' from fun.codigo) as codigo
                        --#84
                        ,fun.ci
                        from '||v_esquema||'.tobligacion o 
                        inner join plani.ttipo_obligacion tob on o.id_tipo_obligacion = tob.id_tipo_obligacion 
                        inner join '||v_esquema||'.tplanilla plani on plani.id_planilla = o.id_planilla
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla --#56
                        inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario = o.id_funcionario and fp.id_planilla = plani.id_planilla
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo inner 
                        join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                        inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina 
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        and o.tipo_pago = ''cheque'' and tob.tipo_obligacion = ''pago_empleados'' 
                        where ';
            v_consulta:=v_consulta||v_parametros.filtro||v_condicion;--#84
            v_consulta:=v_consulta||' group by 
            tc.nombre , ofi.orden,
            ofi.nombre ,o.tipo_pago
            , plani.id_periodo
            , fun.desc_funcionario2, fun.codigo, fun.ci
                        order by  6 desc, 5 desc,  9 asc,
                        1 asc,4 asc
                        , 7 asc
                        ';

                        
            
            return v_consulta;
        
        END;   
                
    elsif (p_transaccion='PLA_REPOBANCDET_CONT') THEN --#56
        BEGIN
            v_consulta:='select count(*) from plani.tdetalle_transferencia df
                    inner join plani.tobligacion o on o.id_obligacion = df.id_obligacion
                    and o.id_tipo_obligacion in (select id_tipo_obligacion from plani.ttipo_obligacion where codigo=''SUEL'')
                    inner join plani.tplanilla plani on plani.id_planilla = o.id_planilla
                    inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla --#56
                    inner join plani.tfuncionario_planilla fp on fp.id_funcionario = df.id_funcionario and
                    fp.id_planilla = plani.id_planilla
                    inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                    inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                    inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                    inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina
                    inner join param.tlugar l on ofi.id_lugar = l.id_lugar
                    inner join param.tinstitucion ins on ins.id_institucion=df.id_institucion
                    where '; 
                        
                    v_consulta:=v_consulta||v_parametros.filtro;
            return v_consulta;
        
        END;    
            
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
LANGUAGE 'plpgsql';