CREATE OR REPLACE FUNCTION plani.ft_obligacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_obligacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tobligacion'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 20:30:19
 COMENTARIOS:	
***************************************************************************
    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               14/07/2014       JRIVERA KPLIAN       creacion
 #38              10/09/2019       RAC KPLIAN           considerar si el cbte es independiente del flujo WF de planilla
 #46			  23.09.2019		MZM					Adicion de funcion para listado de abono en cuenta
 #56			  30.09.2019		MZM					Adicion de funcion para reporte resumen de saldos
*/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_obligacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_OBLI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:30:19
	***********************************/
    
   -- raise exception 'lelga';

	if(p_transaccion='PLA_OBLI_SEL')then
     				
    	begin
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
						from plani.tobligacion obli
						inner join plani.ttipo_obligacion tipobli  on tipobli.id_tipo_obligacion = obli.id_tipo_obligacion
						inner join segu.tusuario usu1 on usu1.id_usuario = obli.id_usuario_reg
                        left join plani.tobligacion_agrupador oa on oa.id_obligacion_agrupador = obli.id_obligacion_agrupador
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
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:30:19
	***********************************/

	elsif(p_transaccion='PLA_OBLI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(obli.id_obligacion)
					    from plani.tobligacion obli
						inner join plani.ttipo_obligacion tipobli  on tipobli.id_tipo_obligacion = obli.id_tipo_obligacion
						inner join segu.tusuario usu1 on usu1.id_usuario = obli.id_usuario_reg
                        left  join plani.tobligacion_agrupador oa on oa.id_obligacion_agrupador = obli.id_obligacion_agrupador
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
    elsif (p_transaccion='PLA_REPOBANC_COUNT') THEN
	    BEGIN
	    	v_consulta:='select count(*) from plani.tdetalle_transferencia df
                    inner join plani.tobligacion o on o.id_obligacion = df.id_obligacion
                    and o.id_tipo_obligacion in (select id_tipo_obligacion from plani.ttipo_obligacion where codigo=''SUEL'')
                    inner join plani.tplanilla pla on pla.id_planilla = o.id_planilla
                    inner join plani.tfuncionario_planilla fp on fp.id_funcionario = df.id_funcionario and
                    fp.id_planilla = pla.id_planilla
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
        
      elsif (p_transaccion='PLA_REPOBANC_SEL') THEN
	    BEGIN
	    	v_consulta:='
                    select l.nombre,sum(df.monto_transferencia), upper( param.f_get_periodo_literal(pla.id_periodo)) as periodo_lite, ins.nombre as banco, o.tipo_pago
                    from plani.tdetalle_transferencia df
                    inner join plani.tobligacion o on o.id_obligacion = df.id_obligacion
                    and o.id_tipo_obligacion in (select id_tipo_obligacion from plani.ttipo_obligacion where codigo=''SUEL'')
                    inner join plani.tplanilla pla on pla.id_planilla = o.id_planilla
                    inner join plani.tfuncionario_planilla fp on fp.id_funcionario = df.id_funcionario and
                    fp.id_planilla = pla.id_planilla
                    inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                    inner join orga.tcargo c on c.id_cargo = uofun.id_cargo
                    inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                    inner join orga.toficina ofi on ofi.id_oficina = c.id_oficina
                    inner join param.tlugar l on ofi.id_lugar = l.id_lugar
                    inner join param.tinstitucion ins on ins.id_institucion=df.id_institucion
                    where '; 

                        
             v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' group by l.nombre, pla.id_periodo, ins.nombre, o.tipo_pago
            order by l.nombre '; 
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
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;