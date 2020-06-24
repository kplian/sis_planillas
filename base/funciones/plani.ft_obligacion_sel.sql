-- FUNCTION: plani.ft_obligacion_sel(integer, integer, character varying, character varying)

-- DROP FUNCTION plani.ft_obligacion_sel(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION plani.ft_obligacion_sel(
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
 #88	ETR		  14.01.2020		MZM						Modificacion a PLA_ABOCUE_SEL para abono en planilla de aguinaldo
 #98	ETR		  23.03.2020		MZM						Inclusion de condiciones para manejo de personal activo/retirado y consolidado
 #128	ETR		  25.05.2020		MZM						Adicion de columna para adecuar reporte por bancos en bono de produccion
 #142	ETR		  19.06.2020	 	MZM						
*/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_esquema             varchar; --#78
    v_condicion			  varchar; --#84
    
    v_fecha_backup 		date;--#98
    v_filtro			varchar;--#98
    v_group				varchar;--#98
    v_sum_group			varchar;--#98
    v_periodo_group		varchar; --#98
    v_periodo_fin		varchar; --#98
    v_oficina_inner		varchar; --#98
    v_oficina_dato		varchar; --#98
    v_oficina_group		varchar;
    v_oficina_orden		varchar;
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
        BEGIN  --#88
            v_consulta:='select
                         emp.codigo_bnb||substr(now()::date::varchar,1,4)||substr(now()::date::varchar,6,2)||substr(now()::date::varchar,9,2)||(select pxp.f_llenar_ceros((select count(*) from plani.tdetalle_transferencia where id_obligacion=detran.id_obligacion),6))
                         ||(select pxp.f_llenar_ceros(cast(replace(sum(monto_transferencia)||'''',''.'','''') as integer),13) from plani.tdetalle_transferencia where id_obligacion=detran.id_obligacion)
                         ||(select pxp.f_llenar_ceros(0,13)) as total,
                         (select pxp.f_llenar_espacio_blanco(fun.ci, 13))||
                        (select pxp.f_llenar_espacio_blanco(substr(fun.desc_funcionario2,1,30),30))||
                        ges.gestion||''''||
                        (select pxp.f_llenar_ceros ( (select EXTRACT(MONTH FROM plani.fecha_planilla))::integer  ,2))
                        ||''1''||
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
                       --- inner join param.tperiodo per on per.id_periodo=plani.id_periodo
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
          
          --#98
          v_filtro:='';
          execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
							 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
							 where '||v_parametros.filtro|| ' limit 1' into v_fecha_backup;
          
          if (pxp.f_existe_parametro(p_tabla, 'id_periodo')) then
          
              if(v_parametros.id_periodo is not null) then
                    
                 if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                      if(v_parametros.estado_funcionario='activo') then
                          v_filtro:=v_filtro||'  and uofun.fecha_asignacion <= '''||v_fecha_backup||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  
                         		and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_backup||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''') )
                                or (uofun.fecha_finalizacion>'''||v_fecha_backup||'''
                               
                                )
                                ) ';
                          
                	  elsif (v_parametros.estado_funcionario='retirado') then
                          v_filtro:=v_filtro||'  and uofun.fecha_asignacion <= '''||v_fecha_backup||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_backup||'''
                                     --and fun.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>uofun.fecha_asignacion and tipo=''oficial'')
                                      and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''')
                                ';
                      else
                     v_filtro:=v_filtro||'  and uofun.fecha_asignacion <= '''||v_fecha_backup||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  
                and 
                 (
                (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_backup||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''') )
        		or (uofun.fecha_finalizacion>'''||v_fecha_backup||''' 
                )
        		)
                or
                (
                  uofun.fecha_finalizacion <= '''||v_fecha_backup||'''
                          -- and fun.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>uofun.fecha_asignacion and tipo=''oficial'')
                          and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''')
                )
                )';
                      end if;
                      
                  end if;
                end if;
          end if;
            
           v_consulta:='select ofi.nombre as oficina,sum(df.monto_transferencia)  as monto_pagar,
                        upper( param.f_get_periodo_literal(plani.id_periodo)) as periodo_lite,ins.nombre as banco,

                        ''Banco'' as tipo_pago,  tc.nombre as tipo_contrato, 
                         ofi.orden
						,(select sum(cv.valor) 
							from plani.tcolumna_valor cv 
							inner join plani.ttipo_columna tcol on tcol.id_tipo_columna=cv.id_tipo_columna
							inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla=cv.id_funcionario_planilla
							inner join plani.vorden_planilla orden on orden.id_funcionario_planilla=fp.id_funcionario_planilla
                           	inner join orga.tfuncionario_cuenta_bancaria cb on cb.id_funcionario=fp.id_funcionario
							inner join param.tinstitucion inss on inss.id_institucion=cb.id_institucion
							where cb.estado_reg=''activo'' and plani.fecha_planilla between cb.fecha_ini and coalesce(cb.fecha_fin, plani.fecha_planilla)
							and tcol.codigo=''APCAJ'' and orden.id_oficina=ofi.id_oficina
                            and cb.id_institucion=ins.id_institucion
                          	and fp.id_planilla=plani.id_planilla
							) as caja_oficina --#128
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
                        v_consulta:=v_consulta||v_parametros.filtro||v_condicion||v_filtro;--#84
                        v_consulta:=v_consulta||'
                       -- group by  tc.nombre , ofi.orden,
                       -- ofi.nombre ,o.tipo_pago, plani.id_periodo, ins.nombre
                        
                        group by  tc.nombre , ofi.orden, 
                        ofi.nombre ,o.tipo_pago, plani.id_periodo, ins.nombre,ofi.id_oficina, plani.fecha_planilla, ins.id_institucion, plani.id_planilla
                        
                        union all
                        select ofi.nombre as oficina,sum(o.monto_obligacion) as monto_pagar ,
                        upper( param.f_get_periodo_literal(plani.id_periodo)) as periodo_lite,''SIN BANCO'' as banco,
                        ''cheque'' as tipo_pago,  tc.nombre as tipo_contrato
                        ,ofi.orden, 0.00 as caja_oficina
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
                        v_consulta:=v_consulta||v_parametros.filtro||v_condicion||v_filtro;--#84
                        v_consulta:=v_consulta||'
                        group by 
                        tc.nombre , ofi.orden,
                        ofi.nombre ,o.tipo_pago, plani.id_periodo
                        order by 6 desc, 5 desc, 7 asc,1 asc, 4 asc
                        '; raise notice '%',v_consulta;
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
          
          --#98
          v_filtro:='';
          execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
							 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
							 where '||v_parametros.filtro|| ' limit 1' into v_fecha_backup;
                             
          if (pxp.f_existe_parametro(p_tabla, 'id_periodo')) then
          		--v_fecha_backup:=(select fecha_fin from param.tperiodo where id_periodo=v_parametros.id_periodo);
                
                 if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                      if(v_parametros.estado_funcionario='activo') then
                          v_filtro:=v_filtro||'  and uofun.fecha_asignacion <= '''||v_fecha_backup||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  
                         		and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_backup||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''') )
                                or (uofun.fecha_finalizacion>'''||v_fecha_backup||'''
                               -- and plani.id_periodo='||v_parametros.id_periodo||'
                                )
                                ) ';
                          
                	  elsif (v_parametros.estado_funcionario='retirado') then
                          v_filtro:=v_filtro||'  and uofun.fecha_asignacion <= '''||v_fecha_backup||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_backup||'''
                                     --and fun.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>uofun.fecha_asignacion and tipo=''oficial'')
                                      and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''')
                                ';
                      else
                     v_filtro:=v_filtro||'  and uofun.fecha_asignacion <= '''||v_fecha_backup||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  
                and 
                 (
                (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_backup||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''') )
        		or (uofun.fecha_finalizacion>'''||v_fecha_backup||''' 
                --and plani.id_periodo='||v_parametros.id_periodo||'
                )
        		)
                or
                (
                  uofun.fecha_finalizacion <= '''||v_fecha_backup||'''
                          -- and fun.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>uofun.fecha_asignacion and tipo=''oficial'')
                          and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''')
                )
                )';
                      end if;
                      
                  end if;
          end if;
          
          
          v_sum_group:='';
          v_group:='';
          v_periodo_group:='upper( param.f_get_periodo_literal(plani.id_periodo))';
          v_periodo_fin:='';
          v_oficina_inner:='';
          v_oficina_dato:='ofi.nombre';
          v_oficina_group:=v_oficina_dato;
          v_oficina_orden:='ofi.orden';
          if pxp.f_existe_parametro(p_tabla , 'consolidar')then 
              if(v_parametros.consolidar='si') then
                  v_filtro:=v_filtro||' and plani.id_periodo<='||v_parametros.id_periodo;
                  v_sum_group:='select oficina, sum(monto_pagar),periodo_lite, banco, tipo_pago, tipo_contrato, desc_funcionario2, nro_cuenta
                  ,orden, codigo, ci
                   from (';
                  v_group:=') as foo
                        group by 1,3,4,5,6,7,8,9,10,11';
                  v_periodo_group:='upper( param.f_get_periodo_literal('||v_parametros.id_periodo||'))';
                  
                  
                  
                   if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                      /* if(v_parametros.estado_funcionario!='retirado') then
                      
                           v_oficina_inner:=' inner join '||v_esquema||'.vorden_planilla v on v.id_funcionario=fun.id_funcionario
                   				and v.id_periodo= '||v_parametros.id_periodo;
                           v_oficina_dato:='v.oficina';
                           v_oficina_group:=v_oficina_dato;
                           v_oficina_orden:='v.orden_oficina';
                       end if;*/
        
           		   end if;
                   
                  
              end if;
          end if;
          
   
            v_consulta:=v_sum_group||'select '||v_oficina_dato||' as oficina,sum(df.monto_transferencia)  as monto_pagar ,
                        '||v_periodo_group||' as periodo_lite,ins.nombre as banco,
                        ''Banco'' as tipo_pago,  tc.nombre as tipo_contrato, fun.desc_funcionario2,df.nro_cuenta 
                        , '||v_oficina_orden||' as orden, trim (both ''FUNODTPR'' from fun.codigo) as codigo
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
                        '||v_oficina_inner||'
                        where ';
            v_consulta:=v_consulta||v_parametros.filtro||v_condicion||v_filtro;--#84
            v_consulta:=v_consulta||' group by  tc.nombre , '||v_oficina_orden||',
            '||v_oficina_group||' ,o.tipo_pago
            , plani.id_periodo , ins.nombre,fun.desc_funcionario2, df.nro_cuenta, fun.codigo, fun.ci
                        union all
                        select '||v_oficina_dato||' as oficina,sum(o.monto_obligacion) as monto_pagar ,
                        '||v_periodo_group||' as periodo_lite,''SIN BANCO'' as banco,
                        ''cheque'' as tipo_pago,  tc.nombre as tipo_contrato, fun.desc_funcionario2 ,''''::varchar as nro_cuenta
                        ,'||v_oficina_orden||' as orden, trim (both ''FUNODTPR'' from fun.codigo) as codigo
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
                        '||v_oficina_inner||'
                        and o.tipo_pago = ''cheque'' and tob.tipo_obligacion = ''pago_empleados'' 
                        where ';
            v_consulta:=v_consulta||v_parametros.filtro||v_condicion||v_filtro;--#84
            v_consulta:=v_consulta||' group by 
            tc.nombre , '||v_oficina_orden||',
            '||v_oficina_group||' ,o.tipo_pago
            , plani.id_periodo
            , fun.desc_funcionario2, fun.codigo, fun.ci
                        order by  6 desc, 5 desc,  9 asc,
                        1 asc,4 asc
                        , 7 asc
                        '||v_group;

                   raise notice '%', v_consulta;     
            
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
    elsif (p_transaccion='PLA_ABONOXLS_SEL') THEN --#142
    	BEGIN
            v_consulta:='select  emp.nombre,
                         emp.codigo_bnb, 
                         (select TO_CHAR(now(),''DD''||''/''||''MM''||''/''||''YYYY'')),
                         (select count(*) from plani.tdetalle_transferencia where id_obligacion=detran.id_obligacion) as num_abonos,
                         (select sum(monto_transferencia) from plani.tdetalle_transferencia where id_obligacion=detran.id_obligacion) as total,
                         fun.ci, 
                         fun.desc_funcionario2,
                         ges.gestion,
                         detran.monto_transferencia,
                         detran.nro_cuenta, 
                         (select TO_CHAR(plani.fecha_planilla,''MM'')) as periodo
                         from plani.tdetalle_transferencia detran
                         inner join orga.vfuncionario fun on fun.id_funcionario = detran.id_funcionario
                         inner join param.tinstitucion ins on ins.id_institucion = detran.id_institucion
                         inner join segu.tusuario usu1 on usu1.id_usuario = detran.id_usuario_reg
                         left join segu.tusuario usu2 on usu2.id_usuario = detran.id_usuario_mod
                         inner join plani.tobligacion obli on obli.id_obligacion=detran.id_obligacion
                         inner join plani.tplanilla plani on plani.id_planilla=obli.id_planilla
                         inner join param.tgestion ges on ges.id_gestion=plani.id_gestion
                         inner join param.tempresa emp on emp.id_empresa=ges.id_empresa
                         inner join plani.ttipo_obligacion tipobli on tipobli.id_tipo_obligacion=obli.id_tipo_obligacion
                         inner join plani.tfuncionario_planilla fp on fp.id_funcionario=fun.id_funcionario and fp.id_planilla=plani.id_planilla
                         inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario
                         inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                         inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                         where ';
                         v_consulta:=v_consulta||v_parametros.filtro;
                         
                         v_consulta:=v_consulta || ' and obli.id_obligacion='||v_parametros.id_obligacion;
                         
                         v_consulta:=v_consulta||' order by ofi.orden,fun.desc_funcionario2';
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
$BODY$;

ALTER FUNCTION plani.ft_obligacion_sel(integer, integer, character varying, character varying)
    OWNER TO postgres;
