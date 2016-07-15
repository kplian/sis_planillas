CREATE OR REPLACE FUNCTION plani.ft_reporte_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_reporte_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.treporte'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 22:07:28
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_ordenar_por		varchar;
    v_where				varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_reporte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_REPO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	if(p_transaccion='PLA_REPO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						repo.id_reporte,
						repo.id_tipo_planilla,
						repo.numerar,
						repo.hoja_posicion,
						repo.mostrar_nombre,
						repo.mostrar_codigo_empleado,
						repo.mostrar_doc_id,
						repo.mostrar_codigo_cargo,
						repo.agrupar_por,
						repo.ordenar_por,
						repo.estado_reg,
						repo.ancho_utilizado,
						repo.ancho_total,
						repo.titulo_reporte,
						repo.fecha_reg,
						repo.id_usuario_reg,
						repo.id_usuario_mod,
						repo.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						repo.control_reporte,
						repo.tipo_reporte	
						from plani.treporte repo
						inner join segu.tusuario usu1 on usu1.id_usuario = repo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = repo.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_REPO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_reporte)
					    from plani.treporte repo
					    inner join segu.tusuario usu1 on usu1.id_usuario = repo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = repo.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************    
 	#TRANSACCION:  'PLA_REPOMAES_SEL'
 	#DESCRIPCION:	Reporte Generico de planilla de sueldos maestro
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPOMAES_SEL')then
     				
    	begin
        	
        	
            --Sentencia de la consulta
			v_consulta:='select
            				repo.numerar,
                            repo.hoja_posicion,
                            repo.mostrar_nombre,
                            repo.mostrar_codigo_empleado,
                            repo.mostrar_doc_id,
                            repo.mostrar_codigo_cargo,
                            repo.agrupar_por,
                            repo.ordenar_por,
                            repo.titulo_reporte,
                            
                            plani.nro_planilla,
                            per.periodo,
                            ges.gestion,
                            uo.nombre_unidad,
                            dep.nombre_corto,
                            (select count(*) from plani.treporte_columna where id_reporte = repo.id_reporte)::integer
						
						from plani.tplanilla plani
						inner join plani.treporte repo on  repo.id_tipo_planilla = plani.id_tipo_planilla
                        left join param.tperiodo per on per.id_periodo = plani.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = plani.id_gestion
                        left join orga.tuo uo on uo.id_uo = plani.id_uo
                        inner join param.tdepto dep on dep.id_depto = plani.id_depto
				        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;
    
     /*********************************    
 	#TRANSACCION:  'PLA_REPOPREV_SEL'
 	#DESCRIPCION:	Reporte de previsiones
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPOPREV_SEL')then
     				
    	begin
        	v_where = '';
        	if (v_parametros.id_tipo_contrato <> -1) then
                v_where = v_where || ' and tc.id_tipo_contrato = ' || v_parametros.id_tipo_contrato;
            end if;
            
            if (v_parametros.id_uo <> -1) then
                v_where = v_where || ' and ger.id_uo = ' || v_parametros.id_uo;
            end if;
            
            
        	raise notice '%',v_where;
            --Sentencia de la consulta
			v_consulta:='with detalle as(

              select
                              ger.nombre_unidad as Gerencia, 
                              car.nombre as NombreCargo, 
                              datos.desc_funcionario2 as NombreCompleto, 
              			    
                              (case when uofun.id_funcionario = 10 then
                                  ''27/12/2013''::date
                              else            
                                  plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion)           
                              END)  as FechaIncorp,
                              
                              (case when uofun.id_funcionario = 10 then
                                   (''' || v_parametros.fecha ||'''::date - ''27/12/2013''::date) + 1
                              else            
                                 (''' || v_parametros.fecha ||'''::date - plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion)) + 1 - plani.f_get_dias_licencia_funcionario(datos.id_funcionario)          
                              END)::integer  as diastrabajados, 
                              
                          (case when ' || v_parametros.id_uo ||' <>-1 then
                              ger.nombre_unidad	
                          ELSE 
                              ''Boliviana de Aviacion''::varchar
                          END)  as NombreDepartamento,
                          (case when ' || v_parametros.id_tipo_contrato ||'<>-1 then 
                              tc.nombre
                          ELSE 
                              ''TODOS''::varchar
                          END)  as NombreContrato,
                          ''' || v_parametros.fecha ||'''::Date as FechaPrev ,
                          orga.f_get_haber_basico_a_fecha(escala.id_escala_salarial,''' || v_parametros.fecha ||'''::date) as haberbasico,
                          fun.antiguedad_anterior,
                          plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,uofun.id_funcionario,uofun.fecha_asignacion) as fechaAntiguedad,
                          (case when ofi.frontera =''si'' then
                          	0.2
                          else
                          	0
                          end) as frontera
                          from orga.tuo_funcionario uofun                            
                          INNER JOIN orga.vfuncionario datos ON datos.id_funcionario=uofun.id_funcionario
                          inner join orga.tcargo car ON car.id_cargo = uofun.id_cargo
                          inner join orga.toficina ofi ON ofi.id_oficina = car.id_oficina
                          inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                          inner join orga.tescala_salarial escala ON escala.id_escala_salarial=car.id_escala_salarial
                          inner join orga.tfuncionario fun on fun.id_funcionario = datos.id_funcionario
                          inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,''' || v_parametros.fecha ||'''::date)
                          where uofun.estado_reg != ''inactivo'' and uofun.fecha_asignacion <= ''' || v_parametros.fecha ||'''::date and 
                          (uofun.fecha_finalizacion >= ''' || v_parametros.fecha ||'''::date or uofun.fecha_finalizacion is null) ' || v_where ||' 
                          order by ger.prioridad::INTEGER,datos.desc_funcionario2)

                          select Gerencia::varchar,NombreCargo::varchar,NombreCompleto::text,
                          round(haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_parametros.fecha ||'''::date,antiguedad_anterior),2) as HaberBasico,
                          to_char(FechaIncorp::date,''DD/MM/YYYY'')::varchar,
                          diastrabajados::integer,
                          round((haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_parametros.fecha ||'''::date,antiguedad_anterior))/365,8) as indemdia,
                          round((haberBasico*frontera + haberBasico + plani.f_evaluar_antiguedad (fechaAntiguedad,''' || v_parametros.fecha ||'''::date,antiguedad_anterior))/365,8)*diastrabajados as Indem
                          
                          from detalle
                          where diastrabajados >= 90';
			
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;
		
	/*********************************    
 	#TRANSACCION:  'PLA_REPOMAESBOL_SEL'
 	#DESCRIPCION:	Reporte Generico de boleta de sueldos maestro
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPOMAESBOL_SEL')then
     				
    	begin
    		if (not exists(	select 1 
        					from plani.treporte r
        					where r.id_tipo_planilla = v_parametros.id_tipo_planilla and r.estado_reg = 'activo' and
        					r.tipo_reporte = 'boleta')) then
        		raise exception 'No existe una configurado un reporte de boleta de pago para este tipo de planilla';
        	end if;
        	
            --Sentencia de la consulta
			v_consulta:='select            				
                            repo.titulo_reporte,
                            plani.nro_planilla,
                            param.f_literal_periodo(per.id_periodo),
                            ges.gestion,
                            emp.nit,
                            ''''::varchar as numero_patronal,
                            fun.desc_funcionario1::varchar as nombre,
                            (case when sum(ht.id_horas_trabajadas) is null then
                            	car.nombre
                            else
                            	pxp.list(carht.nombre || ''  ('' ||round(ht.horas_normales/8,0) || '' dias)'')
                            end)::varchar as cargo,
                            (case when sum(ht.id_horas_trabajadas) is null then
                            	car.codigo
                            else
                            	pxp.list(carht.codigo)
                            end)::varchar as item,
                            fun.codigo as codigo_empleado,
                            sum(ht.horas_normales)::integer,
                            fun.ci,fun.id_funcionario
                            
						from plani.tplanilla plani
						inner join plani.treporte repo on  repo.id_tipo_planilla = plani.id_tipo_planilla
                        left join param.tperiodo per on per.id_periodo = plani.id_periodo
                        inner join param.tgestion ges on ges.id_gestion = plani.id_gestion    
                        inner join param.tempresa emp on emp.estado_reg = ''activo'' 
                        inner join plani.tfuncionario_planilla planifun  on planifun.id_planilla = plani.id_planilla
                        inner join orga.vfuncionario fun on fun.id_funcionario = planifun.id_funcionario                                        
				        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = planifun.id_uo_funcionario
				        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
				        left join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = planifun.id_funcionario_planilla
				        left join orga.tuo_funcionario uofunht on uofunht.id_uo_funcionario = ht.id_uo_funcionario
				        left join orga.tcargo carht on carht.id_cargo = uofunht.id_cargo
				        where repo.tipo_reporte = ''boleta'' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' group by 
							repo.titulo_reporte,
							plani.nro_planilla,
                            per.id_periodo,
                            ges.gestion,
                            emp.nit,                            
                            fun.desc_funcionario1,
                            car.nombre,
                            car.codigo,
                            fun.codigo,
                            fun.ci,
                            fun.id_funcionario
			';
			
			return v_consulta;
						
		end;
	/*********************************    
 	#TRANSACCION:  'PLA_REPODETBOL_SEL'
 	#DESCRIPCION:	Reporte Generico de planilla de sueldos detalle
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPODETBOL_SEL')then
     				
    	begin        	
            
            
    		--Sentencia de la consulta
			v_consulta:='select
                                                       
                            repcol.titulo_reporte_superior,
                            repcol.titulo_reporte_inferior,
                            repcol.tipo_columna,
                            colval.codigo_columna,
                            colval.valor
						
						from plani.tfuncionario_planilla planifun
                        inner join plani.tplanilla plani on plani.id_planilla = planifun.id_planilla
						inner join plani.treporte repo on repo.id_tipo_planilla = plani.id_tipo_planilla
                        inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = planifun.id_funcionario_planilla
                        inner join plani.treporte_columna repcol  on repcol.id_reporte = repo.id_reporte and 
                        											repcol.codigo_columna = colval.codigo_columna
                        
				        where repo.tipo_reporte = ''boleta'' and repcol.estado_reg = ''activo'' and colval.estado_reg = ''activo'' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by repcol.tipo_columna,repcol.orden asc';

			--Devuelve la respuesta
			return v_consulta;
						
		end;
	
	
    
    /*********************************    
 	#TRANSACCION:  'PLA_REPODET_SEL'
 	#DESCRIPCION:	Reporte Generico de planilla de sueldos detalle
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPODET_SEL')then
     				
    	begin
        	--para obtener la columna de ordenacion para el reporte
            execute	'select repo.ordenar_por
           			from plani.tplanilla plani
					inner join plani.treporte repo on  repo.id_tipo_planilla = plani.id_tipo_planilla 
           			where '||v_parametros.filtro into v_ordenar_por;
            if (v_ordenar_por = 'nombre')then
            	v_ordenar_por = 'fun.desc_funcionario2';
            elsif (v_ordenar_por = 'doc_id') then
            	v_ordenar_por = 'fun.ci';
            elsif (v_ordenar_por = 'codigo_cargo') then
            	v_ordenar_por = 'car.codigo';
            else
            	v_ordenar_por = 'fun.codigo';
            end if;       
            
    		--Sentencia de la consulta
			v_consulta:='select
                            fun.id_funcionario,
                            substring(fun.desc_funcionario2 from 1 for 38),
                            fun.codigo,
                            car.codigo,
                            fun.ci,
                            uo.id_uo,
                            uo.nombre_unidad,
                            repcol.sumar_total,
                            repcol.ancho_columna,                            
                            repcol.titulo_reporte_superior,
                            repcol.titulo_reporte_inferior,
                            colval.codigo_columna,
                            colval.valor
						
						from plani.tfuncionario_planilla fp
                        inner join plani.tplanilla plani on plani.id_planilla = fp.id_planilla
						inner join plani.treporte repo on repo.id_tipo_planilla = plani.id_tipo_planilla
                        inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
                        inner join plani.treporte_columna repcol  on repcol.id_reporte = repo.id_reporte and 
                        											repcol.codigo_columna = colval.codigo_columna
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL,NULL)                        
				        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by uo.prioridad::integer, uo.id_uo,' || v_ordenar_por || ', fun.id_funcionario,repcol.orden asc';

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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;