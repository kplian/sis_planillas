CREATE OR REPLACE FUNCTION plani.f_reporte_funcionario_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:      Sistema de Planillas
 FUNCION:      plani.f_reporte_funcionario_sel
 DESCRIPCION:  
 AUTOR:        (EGS)
 FECHA:        27/06/2019
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
 #45	ETR				19.09.2019		    MZM					Adicion de filtro en reporte fondo_solidario
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_fecha_ini           date;
    v_fecha_fin           date;
    v_filtro              varchar;
    v_registros		record;
    
    v_fecha_ini_ctto	date;
    v_antiguedad		integer;
    v_antiguedad_anos	integer;
    v_ordenar	varchar;
	v_contador	integer;
    v_fin	integer;
    v_bandera integer;
    v_id_periodo integer;
    v_columnas varchar[];
    v_col	varchar;
    v_condicion	varchar;
    v_id_periodo_min integer;
    v_tc	numeric;
    v_cols	varchar;
    
    --CURVA SAL
    v_estado	varchar;
    v_sueldo 	numeric;
    v_cotizable	numeric;
    v_liquido	numeric;
    v_dispon	numeric;
    v_subpre	numeric;
    v_subnat	numeric;
    v_sublac	numeric;
    v_totgan	numeric;
    v_totdesc	numeric;
    v_totgral	numeric;
    v_motivo	varchar;
    
    v_bonofron	numeric;
    v_horext	numeric;
    v_bonoext	numeric;
    v_hornoc	numeric;
    v_bononoc	numeric;
    v_suelmes	numeric;
    v_asigtra	numeric;
    v_asigtra_it	numeric;
    v_asigesp	numeric;
    v_asigesp_it	numeric;
    v_asigcaja	numeric;
    v_asigcaja_it	numeric;
    v_asig		numeric;
    
   v_registros_det record;
BEGIN

    v_nombre_funcion = 'plani.f_reporte_funcionario_sel';
    v_parametros = pxp.f_get_record(p_tabla);


			
    if(p_transaccion='PLA_TOTRANGO_SEL')then
 		begin
           
        	create temp table tt_func(
              id_funcionario integer,
              fecha_ingreso date,
              antiguedad integer,
              antiguedad_anos	integer,
              antiguedad_ant	integer
              
             
       		)on commit drop;
         	v_filtro:='0=0';
            for v_registros in (select uofunc.id_funcionario, uofunc.fecha_asignacion, 0, fu.antiguedad_anterior from orga.tuo_funcionario uofunc
            inner join orga.tfuncionario fu on fu.id_funcionario=uofunc.id_funcionario
                            where uofunc.estado_reg!='inactivo'
                            and (uofunc.fecha_finalizacion is null or uofunc.fecha_finalizacion>now())
                            and uofunc.tipo='oficial' 
                            ) loop
                            

              v_fecha_ini_ctto:= (plani.f_get_fecha_primer_contrato_empleado(v_registros.id_funcionario, v_registros.id_funcionario, v_registros.fecha_asignacion));
              v_antiguedad:=(select v_parametros.fecha - v_fecha_ini_ctto );
              v_antiguedad_anos= round(v_antiguedad/365,0); 
			  v_antiguedad:=v_antiguedad-(v_antiguedad_anos*365);

              insert into tt_func 
              values (v_registros.id_funcionario,v_fecha_ini_ctto ,v_antiguedad,v_antiguedad_anos, v_registros.antiguedad_anterior);
           
            end loop;
        
			create temp table tt_func_antiguedad(
              centro varchar,
              codigo_emp varchar,
              nombre	text,
              fecha_ingreso date,
              antiguedad_anterior	integer,
              antiguedad_anos	integer,
              antiguedad_dias	integer,
              rango	varchar,
              genero varchar,
              cargo varchar,
              fecha_nacimiento date,
              edad integer
              
       		)on commit drop;
          
          v_contador:=v_parametros.rango_inicio;
          v_fin=v_parametros.rango_fin;
          
          if(v_parametros.tipo_reporte='empleado_edad') then
            v_bandera:=100;
                        
          elsif (v_parametros.tipo_reporte='empleado_antiguedad') then
            v_bandera:=(select max(antiguedad_anos) from tt_func);
            
          end if;
          
          
          
          while (v_contador< v_bandera) loop
               
              if(v_parametros.tipo_reporte='empleado_edad') then
               v_filtro:='select rfu.nombre_uo_pre,trim (both ''FUNODTPR'' from rfu.codigo) as codigo, rfu.desc_funcionario2, tt.fecha_ingreso,
                      tt.antiguedad_ant,tt.antiguedad_anos,tt.antiguedad, rfu.genero, rfu.fecha_nacimiento, 
                      --rfu.edad
                        date_part(''year''::text,age('''||v_parametros.fecha||''', rfu.fecha_nacimiento))::integer as edad
                      
                      ,rfu.nombre_cargo
                      from plani.vrep_funcionario rfu
                      inner join tt_func tt on tt.id_funcionario=rfu.id_funcionario  
                            where
                            (rfu.fecha_finalizacion is null or rfu.fecha_finalizacion>now())
                            and 
                            rfu.tipo=''oficial'' and
                            tt.fecha_ingreso <'''|| v_parametros.fecha ||'''
                            and date_part(''year''::text,age('''||v_parametros.fecha||''', rfu.fecha_nacimiento))::integer between '|| v_contador||' and '|| v_fin|| '
                 			order by rfu.genero,rfu.fecha_nacimiento DESC, rfu.desc_funcionario2 ';
              else
                v_filtro:=' select rfu.nombre_uo_pre,trim (both ''FUNODTPR'' from rfu.codigo) as codigo, rfu.desc_funcionario2, tt.fecha_ingreso,
                      tt.antiguedad_ant,tt.antiguedad_anos,tt.antiguedad, rfu.genero, rfu.fecha_nacimiento, rfu.edad
                      ,rfu.nombre_cargo
                      from plani.vrep_funcionario rfu
                      inner join tt_func tt on tt.id_funcionario=rfu.id_funcionario  
                            where
                            (rfu.fecha_finalizacion is null or rfu.fecha_finalizacion>now())
                            and rfu.tipo=''oficial'' and
                            tt.fecha_ingreso <'''|| v_parametros.fecha ||'''
                            and tt.antiguedad_anos between '|| v_contador||' and '|| v_fin|| '
                 			order by rfu.genero,tt.fecha_ingreso DESC, rfu.desc_funcionario2 ';
              end if;
          
          
    			for v_registros in execute (v_filtro) loop   
    
                      insert into tt_func_antiguedad
                      values(v_registros.nombre_uo_pre,
                      v_registros.codigo,
                      v_registros.desc_funcionario2,
                      v_registros.fecha_ingreso,
                      v_registros.antiguedad_ant,
                      v_registros.antiguedad_anos,
                      v_registros.antiguedad,
                      v_contador||'-'||v_fin,
                      v_registros.genero,
                      v_registros.nombre_cargo,
                      v_registros.fecha_nacimiento,
                      v_registros.edad);
                 end loop;
                 v_contador:=v_fin+1;
                 v_fin:=v_contador+v_parametros.rango_fin-1;  
         
             end loop;           
       
    		v_consulta:='SELECT *
                       	FROM tt_func_antiguedad 
                      ';
    
            return v_consulta;
                        
        end; 
        
    elsif(p_transaccion='PLA_DATPLAEMP_SEL')then
 		begin     
        
        v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
        if(v_parametros.tipo_reporte='reserva_beneficios2') then
           for v_registros in (select distinct p.id_periodo, p.fecha_ini from param.tperiodo p inner join plani.tplanilla pl
							on p.id_periodo=pl.id_periodo
							inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=pl.id_tipo_planilla and tp.codigo='PLASUE'
							where p.id_periodo<=v_id_periodo
                            and pl.estado!='registro_horas'
                    	    order by p.fecha_ini desc
                        	limit 1 offset 1) loop
                            v_id_periodo_min:=v_registros.id_periodo;
           end loop;
        	v_id_periodo_min=coalesce (v_id_periodo_min,v_id_periodo);
           
        else
           for v_registros in (
                              select distinct p.id_periodo, p.fecha_ini from param.tperiodo p inner join plani.tplanilla pl
                              on p.id_periodo=pl.id_periodo
                              inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=pl.id_tipo_planilla and tp.codigo='PLASUE'
                              where p.id_periodo<=v_id_periodo
                              and pl.estado!='registro_horas'
                              order by p.fecha_ini desc
                              limit 1 offset 2) loop
                              v_id_periodo_min:=v_registros.id_periodo;
           end loop;
           if(v_id_periodo_min is null) then 
               for v_registros in (select distinct p.id_periodo, p.fecha_ini from param.tperiodo p inner join plani.tplanilla pl
							on p.id_periodo=pl.id_periodo
							inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=pl.id_tipo_planilla and tp.codigo='PLASUE'
							where p.id_periodo<=v_id_periodo
                            and pl.estado!='registro_horas'
                    	    order by p.fecha_ini desc
                        	limit 1 offset 1) loop
                            v_id_periodo_min:=v_registros.id_periodo;
               end loop;
                v_id_periodo_min=coalesce (v_id_periodo_min,v_id_periodo);
           end if;
           
           
    	end if;                    
        v_tc:=(select round( param.f_get_tipo_cambio((select id_moneda from param.tmoneda where triangulacion='si' limit 1), v_parametros.fecha,'O'),2));
        v_col:='inner join plani.ttipo_columna tcol on tcol.id_tipo_planilla=plani.id_tipo_planilla 
				inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
				and tcol.codigo = colval.codigo_columna';
        v_ordenar:='fun.desc_funcionario2 ';
        
	    v_condicion:=' plani.id_periodo='||v_id_periodo||'  ';  --uo.orden_centro 0 quitar
        
        --03.09.2019: adicion de id_tipo_contrato
        if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then 
          if(v_parametros.id_tipo_contrato>0) then
        	v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
          end if;
        end if;
        -- fin 03.09.2019
       
       
        
        v_cols:='tcol.codigo,round(colval.valor,2),';
        
                if(v_parametros.tipo_reporte='nomina_salario') then
                    v_col:=v_col||' and tcol.codigo in (''COTIZABLE'',''HABBAS'')';
                    v_ordenar:='cen.uo_centro_orden,fun.desc_funcionario2,tcol.codigo desc';
                elseif (v_parametros.tipo_reporte='no_sindicato' or v_parametros.tipo_reporte='aporte_sindicato') then
                	if(v_parametros.tipo_reporte='no_sindicato') then
                    	v_col:=v_col||' and tcol.codigo in (''APSIND'') and colval.valor=0';
                    else
                    	v_col:=v_col||' and tcol.codigo in (''APSIND'') and colval.valor>0';
                    end if;
                elseif (v_parametros.tipo_reporte='aporte_cacsel') then
                		v_col:=v_col||' and tcol.codigo in (''CACSELFIJO'') and colval.valor>0';
                 elseif(v_parametros.tipo_reporte='reserva_beneficios') then
                    v_col:=v_col||' and tcol.codigo in (''COTIZABLE'') ';

                elseif(v_parametros.tipo_reporte='reserva_beneficios3' or v_parametros.tipo_reporte='reserva_beneficios2' ) then
                    v_col:=v_col||' and tcol.codigo in (''COTIZABLE'') ';
					v_condicion:=' plani.id_periodo<='||v_id_periodo||' and plani.id_periodo>='||v_id_periodo_min;
                    v_ordenar:=v_ordenar||',per.periodo ';
                     if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then 
                        if(v_parametros.id_tipo_contrato>0) then
                          v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                        end if;
        			 end if;
                    
                    
                else 
                    create temp  table tt_totplan(id_funcionario integer,
                    total numeric, codigo varchar) on commit drop;
                
                    for v_registros in (SELECT sum(cv.valor) AS sum, fp_1.id_funcionario
                  		FROM plani.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN plani.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN plani.tplanilla p ON p.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        p.id_tipo_planilla
                  		WHERE 
                        p.id_periodo = v_id_periodo AND
                      
                        tp.codigo in ('PLASUB', 'PLASUE') AND
                         
                        tc.codigo IN( 'SUBSEP' ,
                         'SUBPRE' , 'SUBLAC' , 'SUBNAT' ,
                          'COTIZABLE' , 'AFP_APPAT' , 'AFP_RIEPRO'
                           , 'AFP_VIVIE' , 'PREAGUI' ,
                            'PREPRI' , 'CAJSAL' , 'PREVBS' )
                            group by fp_1.id_funcionario_planilla) loop
                            
                            insert into tt_totplan values (v_registros.id_funcionario, v_registros.sum,'TOTPLANI');
                    end loop;
                    
                    
                    --cotizable
                    
                    for v_registros in (select fp.id_funcionario, colval.valor, tcol.codigo from plani.tfuncionario_planilla fp
                        inner join plani.tplanilla plani on plani.id_planilla = fp.id_planilla
                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo='PLASUE' and plani.estado!='registro_horas'
                        inner join plani.ttipo_columna tcol on tcol.id_tipo_planilla=plani.id_tipo_planilla 
						inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
						and tcol.codigo = colval.codigo_columna
                        and tcol.codigo in ('COTIZABLE')
                        where  plani.id_periodo=v_id_periodo ) loop
                      insert into tt_totplan values (v_registros.id_funcionario, v_registros.valor,v_registros.codigo);
                    end loop;
                    
                
                    v_col:='inner join tt_totplan tcol on tcol.id_funcionario=fp.id_funcionario 
                    ';
                    v_ordenar:='cen.uo_centro_orden,fun.desc_funcionario2,tcol.codigo asc';
                    v_cols:='tcol.codigo, round(tcol.total,2),';
                end if;

        
        if(v_parametros.tipo_reporte='reserva_beneficios2') then
           create temp table tt_reserva2(
              id_funcionario integer,
              nombre	text,
              codigo_emp varchar,
              codigo_col	varchar,
              fecha_ingreso date,
              valor	numeric,
              anos_quinquenio integer,
              mes_quinquenio integer,
              dias_quinquenio integer,
              tc numeric
       		)on commit drop;
        
        	for v_registros in (select
                            fun.id_funcionario,
                            fun.desc_funcionario2,
                            trim (both 'FUNODTPR' from fun.codigo) as codigo,
                            tcol.codigo as codigo_col,
                            (case when ff.fecha_quinquenio is null then
                            (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion) )
                            else
                              ff.fecha_quinquenio
                            end) as fecha_ingreso,
                            colval.valor,
                            
                             (case when ff.fecha_quinquenio is null then
                               date_part('year' ::text, age(v_parametros.fecha,(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion) ) ))::integer  
                            else
	                            date_part('year' ::text, age(v_parametros.fecha,ff.fecha_quinquenio))::integer                           
                            end) AS anos_quinquenio  

                           ,
                           (case when ff.fecha_quinquenio is null then
                              date_part('month' ::text, age(v_parametros.fecha,(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion) )))::integer 
                           else
                               date_part('month' ::text, age(v_parametros.fecha,ff.fecha_quinquenio))::integer 
                           end) as mes_quinquenio
                           
                           
                           , 
                           (case when ff.fecha_quinquenio is null then
                                date_part('day' ::text, age(v_parametros.fecha,(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion) )))::integer 
                           else
	                            date_part('day' ::text, age(v_parametros.fecha,ff.fecha_quinquenio))::integer 
                           end ) as dias_quinquenio, v_tc as tc
                            
                            
 							from plani.tfuncionario_planilla fp
                        inner join plani.tplanilla plani on plani.id_planilla = fp.id_planilla
                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo='PLASUE'
                        inner join plani.ttipo_columna tcol on tcol.id_tipo_planilla=plani.id_tipo_planilla 
						inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
						and tcol.codigo in ('COTIZABLE')			
						and tcol.codigo = colval.codigo_columna
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        inner join orga.tfuncionario ff on ff.id_funcionario=fun.id_funcionario
                     	where  plani.id_periodo<=v_id_periodo and plani.id_periodo>=v_id_periodo_min  and uofun.estado_reg!='inactivo'
                        order by fun.desc_funcionario2,tcol.codigo desc
			)loop
            
            	insert into tt_reserva2 values (v_registros.id_funcionario, v_registros.desc_funcionario2,v_registros.codigo,
            	v_registros.codigo_col, v_registros.fecha_ingreso, v_registros.valor
                ,v_registros.anos_quinquenio, v_registros.mes_quinquenio, v_registros.dias_quinquenio
                
                , v_registros.tc);
            
            end loop;
        	
          
        end if;    
            
       -- else

          
                 v_consulta:='select
                            fun.id_funcionario,
                            substring(fun.desc_funcionario2 from 1 for 38),
                            trim (both ''FUNODTPR'' from fun.codigo)::varchar as codigo,
                            fun.ci,
                            (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion)) as fecha_ingreso,
                            '||v_cols||'
                            tcon.nombre,
                            substring(car.nombre from 1 for 50) ,
                            ger.nombre_unidad_gerencia,
                            cen.nombre_uo_centro, 
                            cen.uo_centro_orden, param.f_get_periodo_literal(per.id_periodo) as periodo, ges.gestion,
                            esc.codigo as nivel
                            ,ofi.nombre as distrito, pers.expedicion,'||v_tc||',
							
                            (case when ff.fecha_quinquenio is null then
                               (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion))
                             else
                               (case when ff.fecha_quinquenio>'''||v_parametros.fecha||''' then
                                  (ff.fecha_quinquenio -  interval ''60 month'')::date
                               else
                            		ff.fecha_quinquenio
                               end
                               )
                            end) as fecha_quinquenio
                            ,
                            
							(case when ff.fecha_quinquenio is null then
                               date_part(''year'' ::text, age('''||v_parametros.fecha||''',(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion)) ))::integer  
                            else
                               (case when ff.fecha_quinquenio>'''||v_parametros.fecha||''' then
                               		date_part(''year'' ::text, age('''||v_parametros.fecha||''', (ff.fecha_quinquenio -  interval ''60 month'')::date ))::integer                           
                               else
                               	 date_part(''year'' ::text, age('''||v_parametros.fecha||''',ff.fecha_quinquenio))::integer                           
                               end)
                            end) AS anos_quinquenio  

                           ,
                           (case when ff.fecha_quinquenio is null then
                              date_part(''month'' ::text, age('''||v_parametros.fecha||''',(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion))))::integer 
                           else
                           		(case when ff.fecha_quinquenio>'''||v_parametros.fecha||''' then
                                    date_part(''month'' ::text, age('''||v_parametros.fecha||''',(ff.fecha_quinquenio -  interval ''60 month'')::date))::integer 
                                else
		                              date_part(''month'' ::text, age('''||v_parametros.fecha||''',ff.fecha_quinquenio))::integer                                 
                                end )

                           end) as mes_quinquenio
                           
                           
                           , 
                           (case when ff.fecha_quinquenio is null then
                                date_part(''day'' ::text, age('''||v_parametros.fecha||''',(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion))))::integer 
                           else
                               (case when ff.fecha_quinquenio>'''||v_parametros.fecha||''' then
                                      date_part(''day'' ::text, age('''||v_parametros.fecha||''',(ff.fecha_quinquenio -  interval ''60 month'')::date))::integer 
                                else
		                             date_part(''day'' ::text, age('''||v_parametros.fecha||''',ff.fecha_quinquenio))::integer 
                                end )
                           end ) as dias_quinquenio
                           , esclim.haber_basico as basico_limite, esclim.codigo as nivel_limite
                        from plani.tfuncionario_planilla fp
                        inner join plani.tplanilla plani on plani.id_planilla = fp.id_planilla
                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo=''PLASUE'' and plani.estado!=''registro_horas''
                        
                         '||v_col||'
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario and uofun.estado_reg!=''inactivo''
                        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                        
                        left join orga.ttipo_cargo tcar on tcar.id_tipo_cargo=car.id_tipo_cargo
                        left join orga.tescala_salarial esclim on esclim.id_escala_salarial=tcar.id_escala_salarial_max
                        
                        
                        inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                      
                        inner join orga.tescala_salarial esc on esc.id_escala_salarial=car.id_escala_salarial
                        inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        inner join orga.tfuncionario ff on ff.id_funcionario=fun.id_funcionario
                        inner join segu.tpersona pers on pers.id_persona=ff.id_persona
                        inner join orga.tuo uo on uo.id_uo=uofun.id_uo
                    	inner join orga.vuo_gerencia ger on ger.id_uo=uofun.id_uo
						inner join orga.vuo_centro cen on cen.id_uo=uofun.id_uo
                        inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = car.id_tipo_contrato
                        inner join param.tperiodo per on per.id_periodo=plani.id_periodo
                        inner join param.tgestion ges on ges.id_gestion=per.id_gestion
                        where
                        
                         (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion))  <= '''||v_parametros.fecha||''' and
                        
                        '||v_condicion||'
                       
                       
                        order by '||v_ordenar;
             raise notice 'aaa%',v_consulta;
        --  end if;              
                        
                        return v_consulta;
        end;
     elsif(p_transaccion='PLA_DATAPORTE_SEL')then
 		begin 
           v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
           v_condicion:=' and 0=0';
            if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then 
          		if(v_parametros.id_tipo_contrato>0) then
        			v_condicion := 'and rep.codigo_tipo_contrato=(select codigo from orga.ttipo_contrato where id_tipo_contrato='||v_parametros.id_tipo_contrato||') ';
                
          		end if;
        	end if;
           
            --19.09.2019#45
            if(v_parametros.tipo_reporte='fondo_solidario') then
               v_condicion:=v_condicion||' and cv.valor>=13000';
            end if;
        
               SELECT
                  per.fecha_ini,
                  per.fecha_fin
              INTO
                  v_fecha_ini,
                  v_fecha_fin
              FROM param.tperiodo per
              WHERE id_periodo = v_id_periodo;
              
              
          create temp table tt_func(
              id_funcionario integer,
              fecha_ingreso date,
              dias	integer,
              dias_incap	integer,
              var1	numeric,
              var2	numeric,
              var3	numeric --#45
              
            )on commit drop; 

            for v_registros in (
                  select fp.id_funcionario, plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, f.fecha_asignacion) as fecha_ingreso 
                  , f.fecha_finalizacion, cv.valor, (select cvv.valor from plani.tcolumna_valor cvv where cvv.codigo_columna='HORDIA'
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as hordia,
                  (select cvv.valor from plani.tcolumna_valor cvv where cvv.codigo_columna='INCAP_DIAS'
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as incap
                  ,
                  (select cvv.valor from plani.tcolumna_valor cvv where cvv.codigo_columna='AFP_VAR1'
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as var1,
                  (select cvv.valor from plani.tcolumna_valor cvv where cvv.codigo_columna='AFP_VAR2'
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as var2,
                  (select cvv.valor from plani.tcolumna_valor cvv where cvv.codigo_columna='AFP_VAR3'
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as var3 --#45
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
                  inner join plani.vrep_funcionario f on f.id_funcionario=fp.id_funcionario
                  inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo='PLASUE'
                  inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                  and cv.codigo_columna in ('HOREFEC')
                  and f.id_uo_funcionario=fp.id_uo_funcionario
                  where p.id_periodo=v_id_periodo
                            ) loop 
                      
      			v_antiguedad:=((v_registros.valor/v_registros.hordia)-v_registros.incap);
                  
                    


              		insert into tt_func 
              		values (v_registros.id_funcionario,v_registros.fecha_ingreso,v_antiguedad, v_registros.incap , v_registros.var1, v_registros.var2, v_registros.var3 );
           
            end loop;
              
            
        	v_consulta:='select fp.id_funcionario,per.apellido_paterno, per.apellido_materno,split_part(per.nombre,'' '',1)::varchar as primer_nombre, 
						(split_part(per.nombre,'' '',2)||'' ''||split_part(per.nombre,'' '',3))::varchar as segundo_nombre,rep.ci,
                         ''CI''::varchar as ci, rep.expedicion,
                         cv.valor, tcol.codigo,  rep.edad::integer, rep.nro_afp, rep.tipo_jubilado,
                         (select nombre from param.tlugar where id_lugar =(select param.f_get_id_lugar_tipo(fp.id_lugar,''departamento'')))::varchar as departamento,  rep.desc_funcionario2
                         , 
						(case when 
                            tt.fecha_ingreso between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''  then
                                tt.fecha_ingreso
                            else 
                            null::date
                            end) as fecha_ingreso,
                         ( case when rep.fecha_finalizacion is not null and rep.fecha_finalizacion between '''||v_fecha_ini||''' and '''||v_fecha_fin||''' then
                            rep.fecha_finalizacion
                         else
                           null::date
                           end
                         ) as fecha_finalizacion, rep.nombre_afp, rep.id_afp,
                         param.f_get_periodo_literal(p.id_periodo) as periodo,
                         
   
    
   						 tt.dias, tt.dias_incap, tt.var1, tt.var2, tt.var3 --#45

                         from plani.tplanilla p
                         inner join plani.tfuncionario_planilla fp on fp.id_planilla=p.id_planilla
                         inner join orga.tfuncionario fun on fun.id_funcionario=fp.id_funcionario
                         inner join segu.tpersona per on per.id_persona=fun.id_persona
                         inner join plani.vrep_funcionario rep on rep.id_funcionario=fp.id_funcionario and fp.id_uo_funcionario=rep.id_uo_funcionario
                         inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla and tp.codigo in (''PLASUE'')
                         inner join tt_func tt on tt.id_funcionario=fp.id_funcionario
                         inner join plani.ttipo_columna tcol on tcol.id_tipo_planilla=tp.id_tipo_planilla
                         inner join plani.tcolumna_valor cv on cv.id_tipo_columna=tcol.id_tipo_columna and fp.id_funcionario_planilla=cv.id_funcionario_planilla
                         inner join param.tlugar lug on lug.id_lugar=fp.id_lugar
                         where p.id_periodo='||v_id_periodo||' and tcol.codigo in (''COTIZABLE'') 
                         and rep.id_afp='||v_parametros.id_afp||v_condicion||'
                         
                         order by  rep.desc_funcionario2'; 
                            
                         return v_consulta;
        end; 
    elsif (p_transaccion='PLA_DATPERSON_SEL') then
      begin 
      
      		select fecha_ini, fecha_fin, gestion
            INTO
                  v_fecha_ini,
                  v_fecha_fin, v_antiguedad
            from param.tgestion
            where id_gestion=v_parametros.id_gestion;
      
	        if(v_fecha_fin>now()) then
              v_fecha_fin:=now();
            end if;
            
            if(v_parametros.tipo_reporte='personal_ret') then
           		v_consulta:='select fun.desc_funcionario1, uof.fecha_finalizacion, 
      					uof.observaciones_finalizacion, fun.id_funcionario, c.nombre, uop.nombre_uo_centro,
                        esc.haber_basico ,split_part( param.f_get_periodo_literal((select id_periodo from param.tperiodo where uof.fecha_finalizacion between fecha_ini and fecha_fin) ),'' '',1)::varchar
						,'||v_antiguedad||' as gestion
                        from orga.tuo_funcionario uof
                        inner join orga.vfuncionario fun on fun.id_funcionario=uof.id_funcionario
                        inner join orga.tcargo c on c.id_cargo=uof.id_cargo
                        inner join  orga.vuo_centro uop ON uop.id_uo = uof.id_uo
                        inner join orga.tescala_salarial esc on esc.id_escala_salarial=c.id_escala_salarial
                        where uof.tipo=''oficial''
                        and uof.fecha_finalizacion between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''
                        and fun.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>uof.fecha_asignacion and tipo=''oficial'')
                        and uof.estado_reg=''activo''
                        order by uof.fecha_finalizacion
                         ';
            else
            	v_consulta:='select fun.desc_funcionario1, plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion), 
      					 ''''::varchar as observaciones_finalizacion, fun.id_funcionario, c.nombre, uop.nombre_uo_centro,
                         esc.haber_basico ,
                         split_part( param.f_get_periodo_literal((select id_periodo from param.tperiodo where plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion) between fecha_ini and fecha_fin) ),'' '',1)::varchar
						,'||v_antiguedad||' as gestion
                        from orga.tuo_funcionario uof
                        inner join orga.vfuncionario fun on fun.id_funcionario=uof.id_funcionario
                        inner join orga.tcargo c on c.id_cargo=uof.id_cargo
                        inner join orga.ttipo_contrato t on t.id_tipo_contrato=c.id_tipo_contrato and t.codigo=''PLA''
                        inner join  orga.vuo_centro uop ON uop.id_uo = uof.id_uo
                        inner join orga.tescala_salarial esc on esc.id_escala_salarial=c.id_escala_salarial
                        where uof.tipo=''oficial'' and (uof.fecha_finalizacion is null or uof.fecha_finalizacion>now())
                        and uof.estado_reg=''activo''
                      
                        and ( plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion)) between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''
                        order by  plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion)';
            
            
            end if;
      		return v_consulta;
      end;  
    elsif (p_transaccion='PLA_PLATRIB_SEL') then
      begin 
    		v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
        	 
            SELECT
                  per.fecha_ini,
                  per.fecha_fin
            INTO
                  v_fecha_ini,
                  v_fecha_fin
            FROM param.tperiodo per
            WHERE id_periodo = v_id_periodo;
              
      		create temp table tt_func(
              id_funcionario integer,
              ingreso integer,
              retiro  integer
            
            )on commit drop;

            for v_registros in (
                  select fp.id_funcionario, plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, f.fecha_asignacion) as fecha_ingreso ,
                  f.fecha_finalizacion
                  from plani.tfuncionario_planilla fp
                  inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
                  inner join plani.vrep_funcionario f on f.id_funcionario=fp.id_funcionario
                  and f.id_uo_funcionario=fp.id_uo_funcionario
                  where p.id_periodo=v_id_periodo and f.codigo_tipo_contrato='PLA'
                            ) loop
                      
                                  
                    if(v_registros.fecha_ingreso between v_fecha_ini and v_fecha_fin) then
                    	v_antiguedad:=1;		
                    else
                    	v_antiguedad:=0;
                    end if;
                    
                     if(v_registros.fecha_finalizacion is not null and v_registros.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>v_registros.fecha_finalizacion and tipo='oficial')) then
                     	v_antiguedad_anos:=1;
                     else
                     	v_antiguedad_anos:=0;
                     end if;
                        

              		insert into tt_func 
              		values (v_registros.id_funcionario,v_antiguedad, v_antiguedad_anos  );
           
            end loop;
      
      
		    v_consulta:='select fun.id_funcionario,
                            per.apellido_paterno, per.apellido_materno, per.nombre,
                            fun.ci,
                           
                            (select periodo from param.tperiodo where id_periodo=plani.id_periodo),
                            (select gestion from param.tgestion where id_gestion=plani.id_gestion),
                            ff.codigo_rciva, per.tipo_documento,
							(case when tf.ingreso=1 then ''I''
                             else (case when tf.retiro=1 then ''D'' 
                             	else
                                  ''V''
                             end)
                            end)::varchar as novedad, colval.valor
						from plani.tfuncionario_planilla fp
                        inner join plani.tplanilla plani on plani.id_planilla = fp.id_planilla
						inner join plani.treporte repo on repo.id_tipo_planilla = plani.id_tipo_planilla
                        inner join plani.treporte_columna repcol  on repcol.id_reporte = repo.id_reporte
                        inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
                        and repcol.codigo_columna = colval.codigo_columna
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                                                inner join plani.vrep_funcionario fun on fun.id_uo_funcionario = uofun.id_uo_funcionario
						inner join orga.tfuncionario ff on ff.id_funcionario=fun.id_funcionario
						inner join segu.tpersona per on per.id_persona=ff.id_persona
                        inner join tt_func tf on tf.id_funcionario=ff.id_funcionario 
                        where plani.id_periodo='||v_id_periodo||' and repo.titulo_reporte ilike ''%Planilla%Tributaria%''
                        order by fun.desc_funcionario2, repcol.orden
                       
                        ';
                        
                        
                        return v_consulta;
       end;    
    elsif (p_transaccion='PLA_INFDEP_SEL') then
      begin 
    		v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
        	    
            
            if (v_parametros.tipo_reporte='dependientes') then
             
              v_consulta:='SELECT p.id_persona, p.matricula, p.historia_clinica,  trim (both ''FUNODTPR'' from fun.codigo) as codigo, p.fecha_nacimiento,
              plani.f_get_fecha_primer_contrato_empleado(repf.id_uo_funcionario, repf.id_funcionario,repf.fecha_asignacion) as fecha_ingreso,
              repf.desc_funcionario2 as nombre_funcionario, pr.relacion, dep.nombre_completo1 as nombre_dep, pdep.fecha_nacimiento as fecha_nacimiento_dep, pdep.matricula as matricula_dep,pdep.historia_clinica as historia_clinica_dep
              , date_part(''year'', age(pdep.fecha_nacimiento))::integer AS edad_dep
              FROM segu.tpersona p
              inner join segu.tpersona_relacion pr on pr.id_persona_fk=p.id_persona
              inner join segu.vpersona dep on dep.id_persona=pr.id_persona
              inner join segu.tpersona pdep on pdep.id_persona=dep.id_persona
              inner join orga.tfuncionario fun on fun.id_persona=p.id_persona
              inner join plani.vrep_funcionario repf on repf.id_funcionario=fun.id_funcionario
              inner join plani.tfuncionario_planilla fp on fp.id_uo_funcionario=repf.id_uo_funcionario
              inner join plani.tplanilla pla on pla.id_planilla=fp.id_planilla where pla.id_periodo='||v_id_periodo||'
              order by repf.desc_funcionario2, pr.relacion, pdep.fecha_nacimiento';
            else
            
                 create temp table tt_func_antiguedad(
                
                 nombre_funcionario text,
                 fecha_nacimiento_dep date,
                 edad_dep	integer,
                 nombre_dep text,
                 genero	varchar,
                 distrito varchar,
                 rango varchar
            
            	)on commit drop;
            	  v_contador:=v_parametros.rango_inicio;
		          v_fin=v_parametros.rango_fin;
            
            
                 while (v_contador< 100) loop
               
                     for v_registros in (SELECT repf.desc_funcionario2 as nombre_funcionario,
                            dep.nombre_completo1 as nombre_dep, pdep.fecha_nacimiento as fecha_nacimiento_dep
                            , date_part('year', age(pdep.fecha_nacimiento)) AS edad_dep, upper(substring(p.genero,1,1)) as genero
                            ,ofi.nombre as distrito
                            FROM segu.tpersona p
                            inner join segu.tpersona_relacion pr on pr.id_persona_fk=p.id_persona
                            inner join segu.vpersona dep on dep.id_persona=pr.id_persona
                            inner join segu.tpersona pdep on pdep.id_persona=dep.id_persona
                            inner join orga.tfuncionario fun on fun.id_persona=p.id_persona
                            inner join plani.vrep_funcionario repf on repf.id_funcionario=fun.id_funcionario
                            inner join plani.tfuncionario_planilla fp on fp.id_uo_funcionario=repf.id_uo_funcionario
                            
                            inner join orga.tcargo car on car.id_cargo=repf.id_cargo
                            inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
               				inner join plani.tplanilla pla on pla.id_planilla=fp.id_planilla where pla.id_periodo=v_id_periodo
                            and pr.relacion ilike '%hijo%'
                            and  date_part('year', age(pdep.fecha_nacimiento)) between  v_contador and  v_fin
                            order by pdep.fecha_nacimiento desc
                        ) loop
                     
          
                            insert into tt_func_antiguedad
                            values(v_registros.nombre_funcionario ,
                                 v_registros.fecha_nacimiento_dep ,
                                 v_registros.edad_dep	,
                                 v_registros.nombre_dep ,
                                 v_registros.genero	,
                                 v_registros.distrito ,
                                 v_contador||'-'||v_fin
                            );
                       end loop;
                       v_contador:=v_fin+1;
                       v_fin:=v_contador+v_parametros.rango_fin-1;  
         
             end loop;           
       
    		v_consulta:='SELECT *
                       	FROM tt_func_antiguedad 
                      ';
            
            
            
            end if;  
               return v_consulta;
              
      end;
    elsif (p_transaccion='PLA_CURVSAL_SEL') then           
       begin
          v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
        	
            create temp table tt_curva_sal(
            	codigo varchar,
                num_documento varchar, 
                tipo_documento varchar, 
                expedicion varchar, 
                nro_afp varchar, 
                apellido_paterno varchar, 
                apellido_materno varchar, 
                primer_nombre varchar, 
                segundo_nombre varchar, 
                fecha_nacimiento date, 
                direccion varchar, 
                telefono1 varchar, 
                grupo_sanguineo varchar, 
                genero varchar, 
                estado_civil varchar,
                profesion varchar,
                cargo varchar, 
                fecha_ingreso date,
                tiempo_contrato varchar,
                nombre_lugar varchar,
                codigo_centro varchar,
                numero_nivel integer,
                nivel_salarial_cargo varchar,
                lugar_pago varchar,
                nivel_salarial_categoria varchar,
                basico_limite numeric,
                
				fecha_quinquenio date,
                antiguedad_anterior integer, 
                fecha_planilla date,
                
                fecha_retiro date,
                motivo_retiro varchar,
                fecha_ingreso_ctto1 date,
                fecha_retiro_ctto1 date,
                fecha_ingreso_ctto2 date,
                fecha_retiro_ctto2 date,
                estado varchar,
                
                sueldo_mes numeric,
                cotizable numeric,
                liquido numeric,
                disponibilidad numeric,
                prenatal numeric, 
                lactancia numeric, 
                natalidad numeric, 
                total_ganado numeric,
                total_descuentos numeric , 
                total_gral numeric,
                celular1 varchar, 
                nro_cuenta varchar, 
                banco varchar,
                
                
               bonofrontera numeric,
               horext 	numeric,
               extra	numeric,
               hornoc 	numeric,
               nocturno numeric,
               suelmes 	numeric,
               asigtra 	numeric,
               asigtra_it numeric,
               asigesp	numeric,
               asigesp_it	numeric,
               asigcaja	numeric,
               asigcaja_it	numeric,
               asignaciones numeric,
               nombre_afp varchar
                
                
            	)on commit drop;
       
       
    		for v_registros in (select tf.id_funcionario,  trim (both 'FUNODTPR' from tf.codigo) as codigo,p.ci, p.tipo_documento, p.expedicion, 
                                fafp.nro_afp, 
                                p.apellido_paterno, p.apellido_materno, 
                                split_part(p.nombre,' ',1)::varchar as primer_nombre 
                                , split_part(p.nombre,' ',2)::varchar as segundo_nombre, p.fecha_nacimiento, p.direccion, p.telefono1, p.grupo_sanguineo, 
                                upper(substr(p.genero,1,1))::varchar as genero, upper(substr(p.estado_civil,1,1))::varchar as estado_civil
                                ,
                                tes.nombre as profesion,
                                pxp.f_iif( 
                                 (select orga.f_get_cargo_x_funcionario_str(tf.id_funcionario,pla.fecha_planilla)) is NULL,
                                 (select  car.nombre
                                            from orga.tuo_funcionario ha
                                            inner join orga.tcargo car on car.id_cargo = ha.id_cargo
                                            inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                                            where ha.id_funcionario =tf.id_funcionario and 
                                            tcon.codigo in ('PLA','EVE') and ha.tipo = 'oficial' 
                                            order by fecha_asignacion desc limit 1)
                                 ,(select orga.f_get_cargo_x_funcionario_str(tf.id_funcionario,pla.fecha_planilla))) as cargo, 
                                (plani.f_get_fecha_primer_contrato_empleado(0,tf.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=tf.id_funcionario))) as fecha_ingreso,
                                pxp.f_iif(tcon.codigo='PLA','Indefinido','Fijo') as tiempo_contrato,
                                ofi.nombre as distrito,
                                (select  codigo_uo_centro from orga.vuo_centro where id_uo= uof.id_uo) as codigo_centro,niv.numero_nivel,
                                esc.nombre as escala_cargo ,
                                ofi.codigo as lugar_pago,
                                COALESCE((select esct.codigo from orga.ttipo_cargo tcar
                                inner join orga.tescala_salarial esct on esct.id_escala_salarial=tcar.id_escala_salarial_max
                                where tcar.id_tipo_cargo=car.id_tipo_cargo),'0') as escala_sal_max,


                                COALESCE((select esct.haber_basico from orga.ttipo_cargo tcar
                                inner join orga.tescala_salarial esct on esct.id_escala_salarial=tcar.id_escala_salarial_max
                                where tcar.id_tipo_cargo=car.id_tipo_cargo),0) as basico_limite,

                                pxp.f_iif(tf.fecha_quinquenio is null,(plani.f_get_fecha_primer_contrato_empleado(0,tf.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=tf.id_funcionario)))||'', tf.fecha_quinquenio||'')::date as fecha_quinquenio,
                                tf.antiguedad_anterior, pla.fecha_planilla,
                                p.celular1, fcb.nro_cuenta, ins.nombre as banco

                                ,fp.id_funcionario_planilla, uof.fecha_finalizacion, uof.observaciones_finalizacion,
                                afp.nombre as nombre_afp
                                from orga.tfuncionario tf
                                inner join segu.tpersona p on p.id_persona=tf.id_persona
                                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario=tf.id_funcionario and fafp.estado_reg='activo'
                                inner join plani.tafp afp on afp.id_afp=fafp.id_afp
                                left join orga.tfuncionario_especialidad  fe on fe.id_funcionario=tf.id_funcionario
                                left join orga.tespecialidad tes on tes.id_especialidad=fe.id_especialidad
                                inner join plani.tfuncionario_planilla fp on fp.id_funcionario=tf.id_funcionario
                                inner join plani.tplanilla pla on pla.id_planilla=fp.id_planilla
                                inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=pla.id_tipo_planilla 
                                inner join orga.tuo_funcionario uof on uof.id_funcionario=tf.id_funcionario and fp.id_funcionario=uof.id_funcionario
                                and uof.id_uo_funcionario=fp.id_uo_funcionario
                                inner join orga.tuo uo on uo.id_uo=uof.id_uo
                                inner join orga.tnivel_organizacional niv on niv.id_nivel_organizacional=uo.id_nivel_organizacional
                                inner join orga.tcargo car on car.id_cargo=uof.id_cargo

                                inner join orga.tescala_salarial esc on esc.id_escala_salarial=car.id_escala_salarial
                                inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                                inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                                inner join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario=tf.id_funcionario and fcb.estado_reg='activo'
                                inner join param.tinstitucion ins on ins.id_institucion=fcb.id_institucion
                                where 
                                pla.id_periodo=v_id_periodo and 
                                tippla.codigo='PLASUE'
                                order by tf.codigo
				) loop
            
					for v_registros_det in (select tc.codigo, cv.valor from plani.tcolumna_valor cv 
                    inner join plani.ttipo_columna tc on tc.id_tipo_columna=cv.id_tipo_columna
                    where cv.id_funcionario_planilla=v_registros.id_funcionario_planilla
                    and tc.codigo in ('JUB55','JUB65','MAY65','HABBAS','COTIZABLE','LIQPAG','DISPONIBILIDAD',
                    'SUBPRE','SUBNAT','SUBLAC','TOTGAN','TOT_DESC','AFP_PAT'
                    
                    ,'BONFRONTERA','HOREXT','EXTRA','HORNOC','NOCTURNO','SUELDOMES',
                    'ASIGTRA','ASIGTRA_IT','ASIGESP','ASIGESP_IT','ASIGCAJA','ASIGCAJA_IT','ASIGNACIONES'
                    ))loop
						
                    if (v_registros_det.codigo='JUB55' and v_registros_det.valor=0) then
							v_estado:='J';
					elsif (v_registros_det.codigo='JUB65' and v_registros_det.valor=0) then
                          	v_estado:='N';
                    elsif (v_registros_det.codigo='MAY65' and v_registros_det.valor=0) then
                    		v_estado:='M';
            		elsif (v_registros.fecha_finalizacion is not null and v_registros.fecha_finalizacion <=v_parametros.fecha) then
                       if not exists (select 1 from orga.tuo_funcionario where id_funcionario=v_registros.id_funcionario and fecha_asignacion>v_registros.fecha_finalizacion) then
                        	v_estado:='R';
                       	else
                            v_estado:='A';
                        end if;
                    else
                       v_estado:='A';
                    end if;
                    
                    if(v_registros.fecha_finalizacion is not null and v_registros.fecha_finalizacion <=v_parametros.fecha) then
                      if not exists (select 1 from orga.tuo_funcionario where id_funcionario=v_registros.id_funcionario and fecha_asignacion>v_registros.fecha_finalizacion) then
                          v_fecha_fin:=v_registros.fecha_finalizacion;
                          v_motivo:=v_registros.observaciones_finalizacion;
                      else
                          v_fecha_fin:=null;
                          v_motivo:=null;
                      end if;
                    else
                      v_fecha_fin:=null;
                      v_motivo:=null;
                    end if;
                    
                    if (v_registros_det.codigo='HABBAS') then
                      v_sueldo:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='COTIZABLE') then
                      v_cotizable:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='LIQPAG') then
                      v_liquido:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='DISPONIBILIDAD') then
                      v_dispon:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='SUBPRE') then
                      v_subpre:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='SUBNAT') then
                      v_subnat:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='SUBLAC') then
                      v_sublac:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='TOTGAN') then
                      v_totgan:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='TOT_DESC') then
                      v_totdesc:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='BONFRONTERA') then
                    	v_bonofron:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='HOREXT') then
                    	v_horext:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='EXTRA') then
                    	v_bonoext:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='HORNOC') then
                    	v_hornoc:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='NOCTURNO') then
                    	v_bononoc:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='SUELDOMES') then   
                    	v_suelmes:=v_registros_det.valor;                                                                             
                    elsif (v_registros_det.codigo='ASIGTRA') then    
                    	v_asigtra:=v_registros_det.valor;                  
                    elsif (v_registros_det.codigo='ASIGTRA_IT') then  
                    	v_asigtra_it:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='ASIGESP') then  
                    	v_asigesp:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='ASIGESP_IT') then  
                    	v_asigesp_it:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='ASIGCAJA') then 
                    	v_asigcaja:=v_registros_det.valor; 
                    elsif (v_registros_det.codigo='ASIGCAJA_IT') then
                    	v_asigcaja_it:=v_registros_det.valor;  
                    elsif (v_registros_det.codigo='ASIGNACIONES') then                                                                                                                          
                    	v_asig:=v_registros_det.valor;
                    else
                      v_totgral:=v_registros_det.valor; --total_patronal_afp 
                    end if;
                    
    
                  end loop; 
                  
                  insert into tt_curva_sal (codigo ,num_documento , tipo_documento , expedicion , 
                                nro_afp , apellido_paterno , apellido_materno , primer_nombre , 
                                segundo_nombre , fecha_nacimiento , direccion , telefono1 , 
                                grupo_sanguineo , genero , estado_civil  , profesion ,
                                cargo , fecha_ingreso , tiempo_contrato , nombre_lugar ,
                                codigo_centro ,  numero_nivel , nivel_salarial_cargo , lugar_pago ,
                                nivel_salarial_categoria ,basico_limite ,fecha_quinquenio ,antiguedad_anterior, 
                                fecha_planilla ,
                                fecha_retiro ,
                                motivo_retiro ,
                                fecha_ingreso_ctto1 ,
                                fecha_retiro_ctto1 ,
                                fecha_ingreso_ctto2 ,
                                fecha_retiro_ctto2 ,
                                
                                estado ,
                                sueldo_mes ,
                                cotizable ,
                                liquido ,
                                disponibilidad ,
                                prenatal , 
                                lactancia , 
                                natalidad , 
                                total_ganado ,
                                total_descuentos  , 
                                total_gral,
                                celular1 , nro_cuenta , banco,
                                
                                bonofrontera ,
               horext 	,
               extra	,
               hornoc 	,
               nocturno ,
               suelmes 	,
               asigtra 	,
               asigtra_it ,
               asigesp	,
               asigesp_it	,
               asigcaja	,
               asigcaja_it	,
               asignaciones, nombre_afp
                                
                                )
                  		values (
                                v_registros.codigo, v_registros.ci, v_registros.tipo_documento, v_registros.expedicion, 
                                v_registros.nro_afp, v_registros.apellido_paterno, v_registros.apellido_materno, v_registros.primer_nombre, 
                                v_registros.segundo_nombre, v_registros.fecha_nacimiento, v_registros.direccion, v_registros.telefono1, 
                                v_registros.grupo_sanguineo,v_registros.genero, v_registros.estado_civil,v_registros.profesion,
                              	v_registros.cargo, v_registros.fecha_ingreso, v_registros.tiempo_contrato, v_registros.distrito,
								v_registros.codigo_centro,v_registros.numero_nivel, v_registros.escala_cargo , v_registros.lugar_pago,
                                v_registros.escala_sal_max,	v_registros.basico_limite,v_registros.fecha_quinquenio,v_registros.antiguedad_anterior, 
                                v_registros.fecha_planilla, 
                                v_fecha_fin, v_motivo, null, null,null,null,
                                v_estado,
                                v_sueldo,
                                v_cotizable,
								v_liquido, 
                                v_dispon,
                                v_subpre,
                                v_subnat,
                                v_sublac,
                                v_totgan,
                                v_totdesc,
	                  			(v_totgan+v_totgral),
                                v_registros.celular1, v_registros.nro_cuenta, v_registros.banco,
                                
                                v_bonofron, v_horext,	
                                v_bonoext,	
                                v_hornoc,	
                                v_bononoc,	
                                v_suelmes,	
                                v_asigtra,	
                                v_asigtra_it,
                                v_asigesp,
                                v_asigesp_it,
                                v_asigcaja,	
                                v_asigcaja_it,
                                v_asig, v_registros.nombre_afp
                  );
                   
                    
                end loop;
       
       			v_consulta:='SELECT *
                       	FROM tt_curva_sal 
                      ';
                      
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