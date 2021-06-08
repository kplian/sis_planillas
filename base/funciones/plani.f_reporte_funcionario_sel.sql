CREATE OR REPLACE FUNCTION plani.f_reporte_funcionario_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
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
 #30    ETR            30/07/2019           MZM-KPLIAN          Creacion
 #45	ETR				19.09.2019		    MZM-KPLIAN			Adicion de filtro en reporte fondo_solidario
 #66	ETR				15.10.2019			MZM-KPLIAN			Inclusion de filtro tipo_contrato para consulta de rangos (edad y antiguedad)
 #67	ETR				16.10.2019			MZM-KPLIAN			Reporte de asignacion de cargos
 #72	ETR				04.11.2019			MZM-KPLIAN			Adicion de control por fecha de asignacion de tipo_jubilado en afp de funcionario (caso mendizabal entre sep y oct 2019)
 #75	ETR				05.11.2019			MZM-KPLIAN			bug en tipo_jub
 #77	ETR				15.11.2019			MZM-KPLIAN			Ajuste reportes
 #81	ETR				25.11.2019			MZM-KPLIAN			Cambio en reporte curva salarial, campo jerarquia por nivel de organigrama y prioridad
 #81	ETR				04.12.2019			MZM-KPLIAN			Habilitacion de catalogo profesion en funcionario, habilitacion de estado_jubilado en curvsal, cambio en dependientes
 #83	ETR				09.12.2019			MZM-KPLIAN			Habilitacion de reporte para backup de planilla
 #87	ETR				09.01.2020			MZM-KPLIAN			Reporte detalle de aguinaldos
 #90	ETR				15.01.2020			MZM-KPLIAN			Ajuste a valor total_gral disminuyendo INCAP_TEMPORAL
 #94	ETR				17.02.2020			MZM-KPLIAN			Ajuste a condiciones para personal retirado e incorporado (en el retirado incluir todas las finalizaciones de asignacion por mas que hubiesen recontrataciones (omitir transferencias y promociones), en las incorporaciones incluir las que no estuvieran vigentes
 #96	ETR				27.02.2020			MZM-KPLIAN			Adicion de condicion en reporte retirados cuando obs_finalizacion es vacio, por subida de datos por script
 #98	ETR				04.03.2020			MZM-KPLIAN			Adecuacion de consultas DATAPORTE (caso reintegros para que salga consolidado)
 #108	ETR				17.03.2020			MZM-KPLIAN			Omision de condicion mayor a 13000 en afp fondo solidario
 #115	ETR				20.04.2020			MZM-KPLIAN			Filtro para reporte listado por centros
 #120	ETR				28.04.2020			MZM-KPLIAN			Ajuste a calculo de antiguedad, considerando retiro en el mes
 #119	ETR				29.04.2020			MZM-KPLIAN			REporte detalle de desceuntos acumulados Rc-IVA
 #125	ETR				14.05.2020			MZM-KPLIAN			Reporte para planillas de prima vigente y no vigente
 #124	ETR				21.05.2020			MZM-KPLIAN			Adecuacion de reporte prima para bono de produccion
 #133	ETR				03.06.2020			MZM-KPLIAN			Reporte de Prevision de primas (resumen)
 #135	ETR				04.06.2020			MZM-KPLIAN			Reporte de prevision de primas (detalle)
 #137	ETR				10.06.2020			MZM-KPLIAN			Bugs en reportes (antiguedad: faltaba definir fecha para hallar tiempo de antiguedad; afp fondo solidario en plasue: reponer filtro de 13000 bs)
 #144	ETR				29.06.2020			MZM-KPLIAN			REporte de ingresos/egresos por funcionario
 #145   ETR				02.07.2020
 #146	ETR				03.07.2020			MZM-KPLIAN			Reporte de reserva de beneficios sociales
 #146	ETR				08.07.2020			MZM-KPLIAN			Reposicion inner join en PRIMA_SEL en relacion a tobligacion
 #151	ETR				31.07.2020			MZM-KPLIAN			Inclusion de tipo SPRINOVIG en reporte PRIMA
 #155	ETR				22.07.2020			MZM-KPLIAN			Reporte de detalle de planilla de prima en DETAGUIN
 #158	ETR				19.08.2020			MZM-KPLIAN			En reporte de personal retirado recibir fecha fin para generar el reporte
 #159	ETR				25.08.2020			MZM-KPLIAN			Reporte horas trabajadas
 #162	ETR				11.09.2020			MZM-KPLIAN			ajuse afpsino en dETAGUIN, todos aportan
 #163 	ETR				23.09.2020			MZM-KPLIAN			Planilla tributaria - correccion de control de fecha por fecha_reg
 #169	ETR				09.10.2020			MZM-KPLIAN			Adicion de columna OTDESC para planilla de bono de produccion no vigente
 #ETR-1290				12.10.2020			MZM-KPLIAN			Correccion a parametro de envio para obtencion de fecha_primer_contrato en CURVSAL
 #ETR-1379				16.10.2020			MZM-KPLIAN			Reporte de grupo familiar: genero del dependiente
 #ETR-1489				26.10.2020			MZM-KPLIAN			Reporte CURVSAL, sin condiciones en fecha_retiro/motivo_retiro, incluso que sea en el futuro mostrar como estè registrado
 #ETR-1712				12.11.2020			MZM-KPLIAN			Reporte independiente de total horas
 #ETR-1817				16.11.2020			MZM-KPLIAN			CAmbio de vista de BD a usar en listado de grupo familiar 
 #ETR-1993				01.12.2020			MZM-KPLIAN			Reporte de movimientos, cambio en obtencion de fecha a la de la asignacion del sgte cargo
 #ETR-2064				04.12.2020			MZM-KPLIAN			Correccion de fecha_quinquenio, considerando la asignacion oficial
 #ETR-2416				04.01.2021			MZM-KPLIAN			Cambio de uso de vista vrep_funcionario, debido a que registraron datos de afp (misma), solo con cambio de vigencia (ambos activos)
 #ETR-2457		        06.01.2021			MZM-KPLIAN			Modificacion a reporte reserva_beneficios: el funcionario a la fecha del reporte debe pertenecer al tipo de contrato del filtro y solo para esos obtener lo demas: Los q pasan de ODT a planta generan error, dado que tienen informacion de meses previos como ODT, pero ya no tienen q salir
 #ETR-2464				11.01.2021			MZM-KPLIAN			Mejora reporte de reservas: Caso retirados del mes, considerar cotizables completos (considerar un mes mas) dias de quinquenio ajustar a fecha de retiro 
 #ETR-2467				11.01.2021			MZM-KPLIAN			Adicion de condicion retirado para planilla de prevision en PRIMA_SEL
 #ETR-2476				14.01.2021			MZM-KPLIAN			Adicion de condicion incremento_Salarial en reporte de personal retirado
 #ETR-2780				02.02.2021			MZM-KPLIAN			Cambio de columna extra por extra_autorizada  en PLA_HORTRATOT_SEL
 #ETR-2804				07.02.2021			MZM-KPLIAN			Adicion de tipo a reporte de personal incorporado
 #ETR-3119				02.03.2021			MZM-KPLIAN			Adicion de tiempo total de trabajo(en 30 dias) para personal retirado (SPLAPREPRI)
 #ETR-3862				05.05.2021			MZM-KPLIAN			Adicion de periodo/gestion en reporte de frecuencia de cargos
 #ETR-3892				06.05.2021			MZM-KPLIAN			Habilitacion de reporte DETAGUIN para planilla de Prima vigente
 #ETR-4150				04.06.2021			MZM-KPLIAN			Reporte CPS de planilla de reintegro 
 #ETr-4190				08.06.2021			MZM-KPLIAN			Ajustes en reporte de AFPs para separar por estado (en acumulado) para planilla de reintegros
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

    --
    v_afp_sso  numeric;
    v_afp_rcom numeric;
    v_afp_cadm numeric;
    v_afp_apnal numeric;
    v_afp_apsol numeric;

   v_registros_det record;

   v_tipo_jub varchar; --#72
   --#77
   v_fecha	date;
   v_cont	integer;

   v_incap	numeric;
   v_bonant	numeric;
   v_estado_afp	varchar;--#81
   --#83
   v_esquema	varchar;
   v_consulta_det	varchar;
   v_cons		varchar;
   v_fecha_backup	varchar;

   --#98
   v_sum_group	varchar;
   v_group	varchar;
   v_filtro_periodo	varchar;

   v_fecha_estado	date;
   v_filtro_estado	varchar;
   v_filtro_estado1	varchar;
   v_fecha_control	date;--#120
   
   v_col2 varchar; --ETR-3892
   v_fechas_cont	varchar; --ETR-3892
   v_i 	integer;
   v_fecha_actual	date;
   v_meses	integer;
BEGIN

    v_nombre_funcion = 'plani.f_reporte_funcionario_sel';
    v_parametros = pxp.f_get_record(p_tabla);



    if(p_transaccion='PLA_TOTRANGO_SEL')then
 		begin

        --#77
        if pxp.f_existe_parametro(p_tabla , 'fecha')then
          if(v_parametros.fecha is not null) then
        	 v_fecha=v_parametros.fecha;
          else
             v_fecha:=(select distinct plani.fecha_planilla from plani.tplanilla plani inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
             where tp.codigo='PLASUE' and plani.id_periodo=v_parametros.id_periodo);
             v_id_periodo:=v_parametros.id_periodo;

          end if;
        else
             v_fecha:=(select distinct plani.fecha_planilla from plani.tplanilla plani inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
             where tp.codigo='PLASUE' and plani.id_periodo=v_parametros.id_periodo);
             v_id_periodo:=v_parametros.id_periodo;

        end if;

		--#83
    	IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
               v_esquema = v_parametros.esquema;
        ELSE
               v_esquema = 'plani';
        END IF;

        	create temp table tt_func(
              id_funcionario integer,
              fecha_ingreso date,
              antiguedad integer,
              antiguedad_anos	integer,
              antiguedad_ant	integer


       		)on commit drop;
         	v_filtro:='0=0';

            --#98
            v_filtro_estado:='';
			execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
							 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
							 where '||v_parametros.filtro|| ' limit 1' into v_fecha_estado;

            if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                    v_filtro_estado:='  and uofunc.fecha_asignacion <= '''||v_fecha_estado||''' and uofunc.estado_reg = ''activo'' and uofunc.tipo = ''oficial''
                    and (uofunc.fecha_finalizacion is null or (uofunc.fecha_finalizacion<='''||v_fecha_estado||''' and uofunc.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofunc.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';
                elsif (v_parametros.estado_funcionario='retirado') then
                       v_filtro_estado:='  and uofunc.fecha_asignacion <= '''||v_fecha_estado||''' and uofunc.estado_reg = ''activo'' and uofunc.tipo = ''oficial''  and uofunc.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofunc.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')  --#ETR-2476
                          ';
          		else
                     v_filtro_estado:='
                    and (( uofunc.fecha_asignacion <= '''||v_fecha_estado||''' and uofunc.estado_reg = ''activo'' and uofunc.tipo = ''oficial''
                    and (uofunc.fecha_finalizacion is null or (uofunc.fecha_finalizacion<='''||v_fecha_estado||''' and uofunc.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofunc.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or
                      ( uofunc.fecha_asignacion <= '''||v_fecha_estado||''' and uofunc.estado_reg = ''activo'' and uofunc.tipo = ''oficial''  and uofunc.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofunc.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial''))) --#ETR-2476
                          ';

               end if;
			end if;

            v_consulta:='select distinct uofunc.id_funcionario, uofunc.fecha_asignacion, 0, fu.antiguedad_anterior
            ,uofunc.fecha_finalizacion, uofunc.observaciones_finalizacion
            from orga.tuo_funcionario uofunc
            inner join orga.tfuncionario fu on fu.id_funcionario=uofunc.id_funcionario
            inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=fu.id_funcionario
            inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
            inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
            where '||v_parametros.filtro||' and uofunc.estado_reg!=''inactivo'' and uofunc.id_uo_funcionario=fp.id_uo_funcionario
                                                    and uofunc.tipo=''oficial''  '||v_filtro_estado;
            raise notice '**%',v_consulta;
            for v_registros in execute(v_consulta ) loop
            v_bonant:=0;

              v_fecha_ini_ctto:= (plani.f_get_fecha_primer_contrato_empleado(v_registros.id_funcionario, v_registros.id_funcionario, v_registros.fecha_asignacion));
              --#120
              select fecha_ini, fecha_fin into v_fecha_ini, v_fecha_fin
              from param.tperiodo where id_periodo=v_id_periodo;
              v_fecha_control:=v_fecha_fin;  --#137
              if(v_registros.fecha_finalizacion between v_fecha_ini and v_fecha_fin and v_registros.observaciones_finalizacion not in ('transferencia','promocion','','incremento_salarial')) then --#ETR-2476
				    v_fecha_control:=v_registros.fecha_finalizacion;
              end if;
              v_antiguedad:=(select v_fecha_control - v_fecha_ini_ctto );



              v_antiguedad_anos=round(v_antiguedad/365,0);
              v_antiguedad:=v_antiguedad-(v_antiguedad_anos*365);




              /*v_bonant:=round(COALESCE(v_registros.antiguedad_anterior,0)/12,0) ;
              v_asig:=COALESCE(v_registros.antiguedad_anterior,0)-(v_bonant*12);--#89

				v_antiguedad_anos:=v_antiguedad_anos+v_bonant;--#89
                v_antiguedad:=v_antiguedad+v_asig;--#89*/

              insert into tt_func
              values (v_registros.id_funcionario,v_fecha_ini_ctto ,v_antiguedad,v_antiguedad_anos, v_registros.antiguedad_anterior);

            end loop;

			create temp table tt_func_antiguedad(
        		id integer,--#77
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
              --#77
              ,fecha_rep	date

       		)on commit drop;

          v_contador:=v_parametros.rango_inicio;
          v_fin=v_parametros.rango_fin;

          if(v_parametros.tipo_reporte='empleado_edad') then
            v_bandera:=100;

          elsif (v_parametros.tipo_reporte='empleado_antiguedad') then
            v_bandera:=((select max(antiguedad_anos) from tt_func)+v_parametros.rango_fin);--#77

          end if;

        --#66
        v_condicion:=' and 0=0';

        if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
          if(v_parametros.id_tipo_contrato>0) then
        	v_condicion = ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
          end if;
        end if;

         v_cont:=1;

          while (v_contador< v_bandera) loop

              if(v_parametros.tipo_reporte='empleado_edad') then --#77
                 v_motivo:='extract(YEAR FROM age('''||v_fecha||''',per.fecha_nacimiento ))';

				 v_ordenar:='per.genero,per.fecha_nacimiento DESC, rfu.desc_funcionario2';
              else
              	 v_motivo:='tt.antiguedad_anos';

                  v_ordenar:='per.genero,tt.fecha_ingreso DESC, rfu.desc_funcionario2';
              end if;

                v_filtro:=' select cen.nombre_uo_centro as nombre_uo_pre,trim(both ''FUNODTPR'' from rfu.codigo) as codigo, rfu.desc_funcionario2, tt.fecha_ingreso,
							tt.antiguedad_ant,tt.antiguedad_anos,tt.antiguedad, per.genero, per.fecha_nacimiento, extract(YEAR FROM age('''||v_fecha||''',per.fecha_nacimiento )) AS edad,
							car.nombre as nombre_cargo
                            from tt_func tt
                            inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=tt.id_funcionario
                            inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                            inner join orga.tuo_funcionario uofun on uofun.id_funcionario=tt.id_funcionario and uofun.id_uo_funcionario=fp.id_uo_funcionario
                            and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial'' --#137
                            inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
                            inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                            inner join orga.vfuncionario rfu on rfu.id_funcionario=fp.id_funcionario
                            inner join orga.tfuncionario fun on fun.id_funcionario=rfu.id_funcionario
                            inner join segu.tpersona per on per.id_persona=fun.id_persona
                            inner join orga.vuo_centro cen on cen.id_uo=uofun.id_uo
                            inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                            where '||v_parametros.filtro||' and
                            tt.fecha_ingreso <'''|| v_fecha ||'''
                            and '||v_motivo||'::integer between '|| v_contador||' and '|| v_fin||v_condicion|| '
                            order by '||v_ordenar;



    			for v_registros in execute (v_filtro) loop

                      insert into tt_func_antiguedad
                      values(v_cont, v_registros.nombre_uo_pre,
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
                      v_registros.edad
                      --#77
                      ,v_fecha
                      );

                      v_cont:=v_cont+1;
                 end loop;
                 v_contador:=v_fin+1;
                 v_fin:=v_contador+v_parametros.rango_fin-1;

             end loop;
       if(v_parametros.tipo_reporte='empleado_edad') then --#77
    		v_consulta:='SELECT centro ,
              codigo_emp ,
              nombre	,
              fecha_ingreso ,
              antiguedad_anterior	,
              antiguedad_anos	,
              antiguedad_dias	,
              rango	,
              genero ,
              cargo ,
              fecha_nacimiento ,
              edad

              ,fecha_rep
                       	FROM tt_func_antiguedad
                      ';
       else
       			v_consulta:='SELECT centro ,
              codigo_emp ,
              nombre	,
              fecha_ingreso ,
              antiguedad_anterior	,
              antiguedad_anos	,
              antiguedad_dias	,
              rango	,
              genero ,
              cargo ,
              fecha_nacimiento ,
              edad

              ,fecha_rep
                       	FROM tt_func_antiguedad
                        order by id
                      ';
       end if;
            return v_consulta;

        end;

    elsif(p_transaccion='PLA_DATPLAEMP_SEL')then
 		begin
        --#83
    	IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
               v_esquema = v_parametros.esquema;
        ELSE
               v_esquema = 'plani';
        END IF;


        --#77
        if pxp.f_existe_parametro(p_tabla , 'fecha')then

          if(v_parametros.fecha is not null) then
        	 v_fecha=v_parametros.fecha;
             v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
             --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
          else
             execute 'select distinct plani.fecha_planilla
                     from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
	                 where tp.codigo=''PLASUE'' and plani.id_periodo='||v_parametros.id_periodo into v_registros_det;


             v_fecha:=v_registros_det.fecha_planilla;
             v_id_periodo:=v_parametros.id_periodo;
             --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
          end if;
        else

        	 execute 'select distinct plani.fecha_planilla
                     from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
	                 where tp.codigo=''PLASUE'' and plani.id_periodo='||v_parametros.id_periodo into v_registros_det;

             v_fecha:=v_registros_det.fecha_planilla;
             v_id_periodo:=v_parametros.id_periodo;
             --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
        end if;


		execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
						 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						 where '||v_parametros.filtro||' and plani.id_periodo='||v_id_periodo||' limit 1' into v_fecha_estado;


        if(v_parametros.tipo_reporte='reserva_beneficios2' or v_parametros.tipo_reporte='reserva_beneficios3') then
         /*  for v_registros in (select distinct p.id_periodo, p.fecha_ini from param.tperiodo p inner join plani.tplanilla pl
							on p.id_periodo=pl.id_periodo
							inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=pl.id_tipo_planilla and tp.codigo='PLASUE'
							where p.id_periodo<=v_id_periodo
                            and pl.estado!='registro_horas'
                    	    order by p.fecha_ini desc
                        	limit 1 offset 1) loop
                            v_id_periodo_min:=v_registros.id_periodo;
           end loop;
        	v_id_periodo_min=coalesce (v_id_periodo_min,v_id_periodo);

        else*/
        	--#83
           v_cons:='select distinct p.id_periodo, p.fecha_ini from param.tperiodo p
                              inner join '||v_esquema||'.tplanilla pl
                              on p.id_periodo=pl.id_periodo
                              inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=pl.id_tipo_planilla and tp.codigo=''PLASUE''
                              where p.id_periodo<='||v_id_periodo||'
                              and pl.estado!=''registro_horas''
                              order by p.fecha_ini desc
                              limit 1 offset 2';

           for v_registros in execute (v_cons) loop
                              v_id_periodo_min:=v_registros.id_periodo;
           end loop;
           if(v_id_periodo_min is null) then
             v_cons:='select distinct p.id_periodo, p.fecha_ini from param.tperiodo p
             			    inner join '||v_esquema||'.tplanilla pl
							on p.id_periodo=pl.id_periodo
							inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=pl.id_tipo_planilla and tp.codigo=''PLASUE''
							where p.id_periodo<='||v_id_periodo||'
                            and pl.estado!=''registro_horas''
                    	    order by p.fecha_ini desc
                        	limit 1 offset 1';

               for v_registros in execute (v_cons) loop
                            v_id_periodo_min:=v_registros.id_periodo;
               end loop;
                v_id_periodo_min=coalesce (v_id_periodo_min,v_id_periodo);
           end if;


    	end if;


        v_tc:=(select round( param.f_get_tipo_cambio((select id_moneda from param.tmoneda where triangulacion='si' limit 1), v_fecha,'O'),2));
        v_col:='inner join plani.ttipo_columna tcol on tcol.id_tipo_planilla=plani.id_tipo_planilla
				inner join '||v_esquema||'.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
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
        --#77
        v_estado:=''; -- para los q se ordenan por organigrama
                if(v_parametros.tipo_reporte='nomina_salario') then
                    v_col:=v_col||' and tcol.codigo in (''COTIZABLE'',''HABBAS'')';
                    v_ordenar:='nivel.ruta, nivel.prioridad,nivel.valor_col,fun.desc_funcionario2,tcol.codigo desc';

                    --#77
                    v_estado:='inner join '||v_esquema||'.vorden_planilla nivel on nivel.id_funcionario_planilla=fp.id_funcionario_planilla
                	and nivel.id_cargo=car.id_cargo and nivel.id_oficina=ofi.id_oficina and nivel.id_periodo=plani.id_periodo
               	    and nivel.id_tipo_contrato=tcon.id_tipo_contrato';

                   v_condicion =v_condicion ||' and '|| v_parametros.filtro;

                elseif (v_parametros.tipo_reporte='no_sindicato' or v_parametros.tipo_reporte='aporte_sindicato') then
                	if(v_parametros.tipo_reporte='no_sindicato') then
                    	v_col:=v_col||' and tcol.codigo in (''APSIND'') and colval.valor=0';
                    else
                    	v_col:=v_col||' and tcol.codigo in (''APSIND'') and colval.valor>0';
                    end if;
                    v_condicion =v_condicion ||' and '|| v_parametros.filtro;
                elseif (v_parametros.tipo_reporte='aporte_cacsel') then
                		v_col:=v_col||' and tcol.codigo in (''CACSELFIJO'') and colval.valor>0';
                        v_condicion =v_condicion || v_parametros.filtro;
                 elseif(v_parametros.tipo_reporte='reserva_beneficios') then
                    v_col:=v_col||' and
                    (case when plani.f_es_funcionario_vigente(fp.id_funcionario,'''||v_fecha||''') then
                    	tcol.codigo in (''COTIZABLE'') 
                    else
                       tcol.codigo in (''COTIZABLE_ANT'') 
                    end)
                    ';
                    v_condicion =v_condicion ||' and '|| v_parametros.filtro;

                elseif(v_parametros.tipo_reporte='reserva_beneficios3' or v_parametros.tipo_reporte='reserva_beneficios2' ) then
                    v_col:=v_col||' and  (case when plani.f_es_funcionario_vigente(fp.id_funcionario,'''||v_fecha||''') then
                    	tcol.codigo in (''COTIZABLE'') 
                    else
                       tcol.codigo in (''COTIZABLE_ANT'') 
                    end) ';
					v_condicion:=' plani.id_periodo<='||v_id_periodo||' and plani.id_periodo>='||v_id_periodo_min || ' and fp.id_funcionario in (select funp.id_funcionario from  '||v_esquema||'.tfuncionario_planilla funp inner join '||v_esquema||'.tplanilla planil on planil.id_planilla=funp.id_planilla where planil.id_periodo='||v_id_periodo||')';
                     if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                        if(v_parametros.id_tipo_contrato>0) then
                          v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                        end if;
        			 end if;
                    v_ordenar:=v_ordenar||', plani.fecha_planilla';

                else -- salarios CT

                    create temp  table tt_totplan(id_funcionario integer,
                    total numeric, codigo varchar) on commit drop;

                	v_cons:='SELECT sum(cv.valor) AS sum, fp_1.id_funcionario
                  		FROM '||v_esquema||'.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN '||v_esquema||'.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN '||v_esquema||'.tplanilla plani ON plani.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        plani.id_tipo_planilla
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                  		WHERE '||v_parametros.filtro||' and
                        plani.id_periodo = '||v_id_periodo||' AND

                        tp.codigo in (''PLASUB'', ''PLASUE'') AND

                        tc.codigo IN( ''SUBSEP'' ,
                         ''SUBPRE'' , ''SUBLAC'' , ''SUBNAT'' ,
                          ''COTIZABLE'' , ''AFP_APPAT'' , ''AFP_RIEPRO''
                           , ''AFP_VIVIE'' , ''PREAGUI'',
                            ''PREPRI'' , ''CAJSAL'' , ''PREVBS'')
                            group by fp_1.id_funcionario_planilla';

                    for v_registros in execute(v_cons) loop

                        execute 'SELECT sum(cv.valor) as valor
                  		FROM '||v_esquema||'.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN '||v_esquema||'.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN '||v_esquema||'.tplanilla plani ON plani.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        plani.id_tipo_planilla
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                  		WHERE '||v_parametros.filtro||' and
                        plani.id_periodo = '||v_id_periodo||' AND

                        tp.codigo in ( ''PLASUE'') AND

                        tc.codigo IN( ''INCAP_TEMPORAL'' ) and fp_1.id_funcionario='||v_registros.id_funcionario into v_registros_det;

                        v_incap:=v_registros_det.valor;

                        insert into tt_totplan values (v_registros.id_funcionario,( v_registros.sum-v_incap),'TOTPLANI');
                    end loop;


                    --cotizable
                    v_cons:='select fp.id_funcionario, colval.valor, tcol.codigo
                    	from '||v_esquema||'.tfuncionario_planilla fp
                        inner join '||v_esquema||'.tplanilla plani on plani.id_planilla = fp.id_planilla
                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo=''PLASUE'' and plani.estado!=''registro_horas''
                        inner join plani.ttipo_columna tcol on tcol.id_tipo_planilla=plani.id_tipo_planilla
						inner join '||v_esquema||'.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
						and tcol.codigo = colval.codigo_columna
                        and tcol.codigo in (''COTIZABLE'')
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                        where '||v_parametros.filtro||' and plani.id_periodo='||v_id_periodo;
                    for v_registros in execute (v_cons) loop
                      insert into tt_totplan values (v_registros.id_funcionario, v_registros.valor,v_registros.codigo);
                    end loop;


                    v_col:='inner join tt_totplan tcol on tcol.id_funcionario=fp.id_funcionario
                    ';
                    v_cols:='tcol.codigo, round(tcol.total,2),';

                    --#77
                    v_ordenar:='nivel.ruta, nivel.prioridad,nivel.valor_col,fun.desc_funcionario2,tcol.codigo desc';

                    v_estado:='inner join '||v_esquema||'.vorden_planilla nivel on nivel.id_funcionario_planilla=fp.id_funcionario_planilla
                	and nivel.id_cargo=car.id_cargo and nivel.id_oficina=ofi.id_oficina and nivel.id_periodo=plani.id_periodo
               	    and nivel.id_tipo_contrato=tcon.id_tipo_contrato';

                    v_condicion =v_condicion ||' and '|| v_parametros.filtro;
                end if;


       --XXXX
          if(v_parametros.tipo_reporte='reserva_beneficios' or v_parametros.tipo_reporte='reserva_beneficios2' or v_parametros.tipo_reporte='reserva_beneficios3') then
             --tabla temporal para seleccionar a los funcionarios que a la fecha de consulta tienen el tipo de contrato del filtro
             create temp  table tt_totplan(id_funcionario integer) on commit drop;

                	v_cons:='                       
                         SELECT fp.id_funcionario FROM '||v_esquema||'.tfuncionario_planilla fp
                        inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                        inner join orga.tuo_funcionario uof on uof.id_uo_funcionario=fp.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo=uof.id_cargo
                        inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                        
                  		WHERE  '||v_parametros.filtro||' and
                        plani.id_periodo = '||v_id_periodo||' and 0=0 ';
                        
                        if(v_parametros.id_tipo_contrato>0) then
                        v_cons:=v_cons || ' and c.id_tipo_contrato='|| v_parametros.id_tipo_contrato;
                        end if;




                    for v_registros in execute(v_cons) loop
                        insert into tt_totplan values (v_registros.id_funcionario);
                    end loop;
             
             v_condicion=v_condicion ||' and fp.id_funcionario in (select id_funcionario from tt_totplan)';
          
       	  end if;

       /* if(v_parametros.tipo_reporte='reserva_beneficios2') then
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
                               date_part('year' ::text, age(v_fecha,(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion) ) ))::integer
                            else
	                            date_part('year' ::text, age(v_fecha,ff.fecha_quinquenio))::integer
                            end) AS anos_quinquenio

                           ,
                           (case when ff.fecha_quinquenio is null then
                              date_part('month' ::text, age(v_fecha,(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion) )))::integer
                           else
                               date_part('month' ::text, age(v_fecha,ff.fecha_quinquenio))::integer
                           end) as mes_quinquenio


                           ,
                           (case when ff.fecha_quinquenio is null then
                                date_part('day' ::text, age(v_fecha,(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion) )))::integer
                           else
	                            date_part('day' ::text, age(v_fecha,ff.fecha_quinquenio))::integer
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


        end if;    */

       -- else
 			--#98
            v_filtro_estado:='';

            if(v_parametros.tipo_reporte='reserva_beneficios' or v_parametros.tipo_reporte='reserva_beneficios2' or v_parametros.tipo_reporte='reserva_beneficios3') then
            	v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                       /* and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''') )
                        or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                        )*/ ';--#146


            else

                if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                    if(v_parametros.estado_funcionario='activo') then
                        v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                        and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''') )
                        or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                        ) ';
                    elsif (v_parametros.estado_funcionario='retirado') then
                           v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                                 and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''')
                              ';
                    else
                       v_filtro_estado:='
                        and (( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                        and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''') )
                        or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                        )
                         ) or


                          ( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                                 and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''')))
                              ';
                   end if;
                end if;
          end if;
                 v_consulta:='select
                            fun.id_funcionario,
                            substring(fun.desc_funcionario2 from 1 for 36),
                            trim (both ''FUNODTPR'' from fun.codigo)::varchar as codigo,
                            fun.ci,
                            (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=uofun.id_funcionario and estado_reg=''activo'' and tipo=''oficial''))) as fecha_ingreso,
                            '||v_cols||'
                            tcon.nombre,
                            substring(car.nombre from 1 for 50) ,
                            ger.nombre_unidad_gerencia,
                            cen.nombre_uo_centro,
                            cen.uo_centro_orden, param.f_get_periodo_literal(per.id_periodo) as periodo, ges.gestion,
                            esc.codigo as nivel
                            ,ofi.nombre as distrito, pers.expedicion,'||v_tc||',

                            (case when ff.fecha_quinquenio is null then
                               (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=uofun.id_funcionario and estado_reg=''activo'' and tipo=''oficial'')))
                             else
                               (case when ff.fecha_quinquenio>'''||v_fecha||''' then
                                  (ff.fecha_quinquenio -  interval ''60 month'')::date
                               else
                            		ff.fecha_quinquenio
                               end
                               )
                            end) as fecha_quinquenio
                            ,

							(case when ff.fecha_quinquenio is null then
                               date_part(''year'' ::text, age('''||v_fecha||''',(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=uofun.id_funcionario and estado_reg=''activo'' and tipo=''oficial''))) ))::integer
                            else
                               (case when ff.fecha_quinquenio>'''||v_fecha||''' then
                               		date_part(''year'' ::text, age('''||v_fecha||''', (ff.fecha_quinquenio -  interval ''60 month'')::date ))::integer
                               else
                               	 date_part(''year'' ::text, age('''||v_fecha||''',ff.fecha_quinquenio))::integer
                               end)
                            end) AS anos_quinquenio

                           ,
                           (case when ff.fecha_quinquenio is null then
                              date_part(''month'' ::text, age('''||v_fecha||''',(plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=uofun.id_funcionario and estado_reg=''activo'' and tipo=''oficial'')))))::integer
                           else
                           		(case when ff.fecha_quinquenio>'''||v_fecha||''' then
                                    date_part(''month'' ::text, age('''||v_fecha||''',(ff.fecha_quinquenio -  interval ''60 month'')::date))::integer
                                else
		                              date_part(''month'' ::text, age('''||v_fecha||''',ff.fecha_quinquenio))::integer
                                end )

                           end) as mes_quinquenio


                           ,


                          (case when ff.fecha_quinquenio is null then
								--pxp.f_get_dias_mes_30( (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=uofun.id_funcionario and estado_reg=''activo'' and tipo=''oficial''))),'''||v_fecha||''')
                                
                               pxp.f_get_dias_mes_30( (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,uofun.fecha_asignacion)),coalesce((select fecha_finalizacion from orga.tuo_funcionario where id_uo_funcionario=uofun.id_uo_funcionario 
                                and estado_reg=''activo'' and tipo=''oficial'' and
                                observaciones_finalizacion not in (''transferencia'',''promocion'','''',''incremento_salarial'') --#ETR-2476
                                and fecha_finalizacion between pxp.f_obtener_primer_dia_mes(per.periodo,ges.gestion) and '''||v_fecha||'''
                                ),'''||v_fecha||'''))  
                                
                                
                           else
                               (case when ff.fecha_quinquenio>'''||v_fecha||''' then

                                   pxp.f_get_dias_mes_30( (ff.fecha_quinquenio -  interval ''60 month'')::date, 
                                   coalesce((select fecha_finalizacion from orga.tuo_funcionario where id_uo_funcionario=uofun.id_uo_funcionario 
                                and estado_reg=''activo'' and tipo=''oficial'' and
                                observaciones_finalizacion not in (''transferencia'',''promocion'','''',''incremento_salarial'') --#ETR-2476
                                and fecha_finalizacion between pxp.f_obtener_primer_dia_mes(per.periodo,ges.gestion) and '''||v_fecha||'''
                                ),'''||v_fecha||''')
                                   
                                   
                                   )

                                else
		                           pxp.f_get_dias_mes_30( ff.fecha_quinquenio, 
                                   coalesce((select fecha_finalizacion from orga.tuo_funcionario where id_uo_funcionario=uofun.id_uo_funcionario 
                                and estado_reg=''activo'' and tipo=''oficial'' and
                                observaciones_finalizacion not in (''transferencia'',''promocion'','''',''incremento_salarial'')  --#ETR-2476
                                and fecha_finalizacion between pxp.f_obtener_primer_dia_mes(per.periodo,ges.gestion) and '''||v_fecha||'''
                                ),'''||v_fecha||''')
                                   
                                   )
                                end )
                           end ) as dias_quinquenio



                           , esclim.haber_basico as basico_limite, esclim.codigo as nivel_limite
                        from '||v_esquema||'.tfuncionario_planilla fp
                        inner join '||v_esquema||'.tplanilla plani on plani.id_planilla = fp.id_planilla
                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo=''PLASUE'' and plani.estado!=''registro_horas''

                         '||v_col||'
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial'' --#137
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
                        inner join plani.treporte repo on repo.id_tipo_planilla=tp.id_tipo_planilla
                        '||v_estado||' --#77
                        where '||v_parametros.filtro||' and

                         (plani.f_get_fecha_primer_contrato_empleado(uofun.id_funcionario, uofun.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=uofun.id_funcionario and estado_reg=''activo'' and tipo=''oficial'')))  <= '''||v_fecha||''' and

                        '||v_condicion||v_filtro_estado||'


                        order by '||v_ordenar;
             raise notice 'cons:% ',v_consulta;
        --  end if;

                        return v_consulta;
        end;
     elsif(p_transaccion='PLA_DATAPORTE_SEL')then
 		begin

            --#83
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
            ELSE
                   v_esquema = 'plani';
            END IF;

           --#77
            if pxp.f_existe_parametro(p_tabla , 'fecha')then
              if(v_parametros.fecha is not null) then
                 v_fecha=v_parametros.fecha;
                 v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
              else
                 execute ' select distinct plani.fecha_planilla
                 from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp
                 on tp.id_tipo_planilla=plani.id_tipo_planilla
                 where tp.codigo=''PLASUE'' and
                 plani.id_periodo='||v_parametros.id_periodo into v_registros_det;
                 v_fecha:=v_registros_det.fecha_planilla;
                 v_id_periodo:=v_parametros.id_periodo;
              end if;
            else
                 execute ' select distinct plani.fecha_planilla
                 from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp
                 on tp.id_tipo_planilla=plani.id_tipo_planilla
                 where tp.codigo=''PLASUE'' and
                 plani.id_periodo='||v_parametros.id_periodo into v_registros_det;
                 v_fecha:=v_registros_det.fecha_planilla;
                 v_id_periodo:=v_parametros.id_periodo;


            end if;

           v_condicion:=' and 0=0';
            if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
          		if(v_parametros.id_tipo_contrato>0) then
        			v_condicion := ' and tt.id_tipo_contrato='||v_parametros.id_tipo_contrato;

          		end if;
        	end if;



               SELECT
                  per.fecha_ini,
                  per.fecha_fin
              INTO
                  v_fecha_ini,
                  v_fecha_fin
              FROM param.tperiodo per
              WHERE id_periodo = v_id_periodo;


               --#98
               v_filtro:='';

                 --falta contemplar el consolidar para aplicar sumatorias y groups
                 v_sum_group:='';
                 v_group:='';
                 v_filtro_periodo:='';
                 if pxp.f_existe_parametro(p_tabla , 'consolidar')then
                     if (v_parametros.consolidar='si') then
                       v_filtro:=v_filtro ||' and plani.id_periodo <= '||v_parametros.id_periodo;

                       if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                          if(v_parametros.id_tipo_contrato>0) then
                              v_filtro := v_filtro||' and tc.id_tipo_contrato='||v_parametros.id_tipo_contrato;
                          end if;
                       end if;
                        	v_fecha_ini:=(select g.fecha_ini from param.tgestion g
                                  inner join param.tperiodo p on p.id_gestion=g.id_gestion
                                  where p.id_periodo=v_parametros.id_periodo);

                       		v_filtro_periodo:=' and plani.id_periodo <= '||v_parametros.id_periodo;
                       		v_sum_group:='select id_funcionario, fecha_ingreso,
                       				 fecha_finalizacion,
                                    sum(valor) as valor, sum(hordia) as hordia, sum(incap) as incap,
                                    sum (var1) as var1,sum(var2) as var2,sum(var3) as var3
                                    from (';
                      		v_group:=') as foo
                  				group by 1,2,3';
                                
                                
                     else
                          v_filtro:=v_filtro ||' and plani.id_periodo = '||v_parametros.id_periodo;
                     end if;
                  end if;

          create temp table tt_func(
              id_funcionario integer,
              fecha_ingreso date,
              dias	integer,
              dias_incap	integer,
              var1	numeric,
              var2	numeric,
              var3	numeric --#45,
              ,tipo_jub varchar
              --#83
              ,ncotiz	numeric,
              nvar1	numeric,
              nvar2	numeric,
              nvar3	numeric,
              fecha_finalizacion date
              --ETR-2416
              ,nro_afp varchar,
              id_afp integer,
              nombre_afp	varchar,
              id_tipo_contrato	integer,
              fecha_planilla date

            )on commit drop;
			v_cons:=v_sum_group||'select fp.id_funcionario,
            		plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, uofun.fecha_asignacion) as fecha_ingreso
                  ,
                  	(select fecha_finalizacion from orga.tuo_funcionario uoff
									 inner join orga.tcargo cc on cc.id_cargo=uoff.id_cargo
  									 where id_funcionario=fp.id_funcionario
                                     and uoff.estado_reg!=''inactivo'' and uoff.tipo=''oficial''  --#137
									 and fecha_finalizacion<='''||v_fecha_fin||''' and fecha_finalizacion>='''||v_fecha_ini||'''
									 and observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')  --#ETR-2476
									 and cc.id_tipo_contrato=tc.id_tipo_contrato
									 order by fecha_finalizacion desc limit 1
									) as fecha_finalizacion

                  , cv.valor,
                  (select cvv.valor from '||v_esquema||'.tcolumna_valor cvv where cvv.codigo_columna=''HORDIA''
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as hordia,
                  (select cvv.valor from '||v_esquema||'.tcolumna_valor cvv where cvv.codigo_columna=''INCAP_DIAS''
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as incap
                  ,
                  (select cvv.valor from '||v_esquema||'.tcolumna_valor cvv where cvv.codigo_columna=''AFP_VAR1''
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as var1,
                  (select cvv.valor from '||v_esquema||'.tcolumna_valor cvv where cvv.codigo_columna=''AFP_VAR2''
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as var2,
                  (select cvv.valor from '||v_esquema||'.tcolumna_valor cvv where cvv.codigo_columna=''AFP_VAR3''
                  and cvv.id_funcionario_planilla=fp.id_funcionario_planilla
                  ) as var3 --#45
                  ,tc.id_tipo_contrato
                  
                  from '||v_esquema||'.tfuncionario_planilla fp
                  inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                  --inner join plani.vrep_funcionario f on f.id_funcionario=fp.id_funcionario
                  inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo=''PLASUE''
                  inner join '||v_esquema||'.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                  --inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                  inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario --#98
                  and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial'' --#137
                  inner join orga.tcargo tt on tt.id_cargo=uofun.id_cargo
                  inner join orga.ttipo_contrato tc on tc.id_tipo_contrato=tt.id_tipo_contrato

                  and cv.codigo_columna in (''HOREFEC'')
                  --and f.id_uo_funcionario=fp.id_uo_funcionario
                  where '||v_parametros.filtro||v_filtro||v_group;
                --raise notice 'consulta: %',v_cons;
            for v_registros in execute( v_cons
                  ) loop

      			v_antiguedad:=((v_registros.valor/v_registros.hordia)-v_registros.incap);

                  --#72
				select fa.tipo_jubilado, fa.nro_afp, fa.id_afp, afp.nombre as nombre_afp
                  into v_registros_det  --ETR-2416
                  from plani.tfuncionario_afp fa inner join plani.tafp afp on afp.id_afp=fa.id_afp
                  where fa.id_funcionario=v_registros.id_funcionario
                  and fa.estado_reg='activo'
                  and v_fecha between fa.fecha_ini and coalesce(fa.fecha_fin,v_fecha) order by fa.fecha_fin desc ;
                  --#77
                  /*if(v_tipo_jub is NULL) then
                  select tipo_jubilado into v_tipo_jub
                  from plani.tfuncionario_afp
                  where id_funcionario=v_registros.id_funcionario
                  and estado_reg='activo'
                  and fecha_fin >=v_fecha_fin order by fecha_fin desc ;
                  end if;*/

              		insert into tt_func
              		values (v_registros.id_funcionario,v_registros.fecha_ingreso,v_antiguedad, v_registros.incap , v_registros.var1, v_registros.var2, v_registros.var3, v_registros_det.tipo_jubilado, 0, 0, 0, 0 ,v_registros.fecha_finalizacion, v_registros_det.nro_afp, v_registros_det.id_afp, v_registros_det.nombre_afp, v_parametros.id_tipo_contrato, v_fecha ); --ETR-2416

          			--#84: si la planilla para la cual se consulta no es sueldo == añadir mas columnas porq es de reintegro (7 columnas)
                   if pxp.f_existe_parametro(p_tabla , 'id_tipo_planilla')then
                         if(v_parametros.id_tipo_planilla>0 and v_parametros.id_tipo_planilla in (select id_tipo_planilla from plani.ttipo_planilla where codigo='PLANRE' )) then

							execute ' select sum(valor) as valor, sum(var1) as var1, sum(var2) as var2, sum(var3) as var3 from
                            (select cv.valor,
                            (select valor from plani.tcolumna_valor where id_funcionario_planilla=fp.id_funcionario_planilla
                            and codigo_columna=''PRMAFP_VAR1'') as var1,
                            (select valor from plani.tcolumna_valor where id_funcionario_planilla=fp.id_funcionario_planilla
                            and codigo_columna=''PRMAFP_VAR2'') as var2,
                            (select valor from plani.tcolumna_valor where id_funcionario_planilla=fp.id_funcionario_planilla
                            and codigo_columna=''PRMAFP_VAR3'') as var3
                            from '||v_esquema||'.tfuncionario_planilla fp inner join
                            '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla and plani.id_tipo_planilla='||v_parametros.id_tipo_planilla||'

                            inner join '||v_esquema||'.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                            and cv.codigo_columna=''PRMCOTIZABLE''
                            inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario
                            and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial''
                            inner join orga.tcargo tt on tt.id_cargo=uofun.id_cargo
		                    inner join orga.ttipo_contrato tc on tc.id_tipo_contrato=tt.id_tipo_contrato
                            and fp.id_funcionario='||v_registros.id_funcionario||' and '||v_parametros.filtro ||v_filtro|| ' )as foo' into v_registros_det;


                            update tt_func
                            set ncotiz=v_registros_det.valor,
                            nvar1=v_registros_det.var1,
                            nvar2=v_registros_det.var2,
                            nvar3=v_registros_det.var3,
                            fecha_planilla=v_fecha where id_funcionario=v_registros.id_funcionario;


                         end if;
                   end if;

            end loop;



           if pxp.f_existe_parametro(p_tabla , 'id_tipo_planilla')then
                  if(v_parametros.id_tipo_planilla>0 and v_parametros.id_tipo_planilla in (select id_tipo_planilla from plani.ttipo_planilla where codigo='PLANRE' )) then
                  --#ETR-4190
                       execute ' select distinct plani.fecha_planilla
                           from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp
                           on tp.id_tipo_planilla=plani.id_tipo_planilla
                           where tp.codigo=''PLANRE'' and
                           plani.id_periodo='||v_parametros.id_periodo into v_registros_det;
                 			v_fecha:=v_registros_det.fecha_planilla;
                            update tt_func
                            set fecha_planilla=v_fecha;
                  else
                  		--v_condicion:=v_condicion ||' and repo.id_reporte='||v_parametros.id_reporte;--#108
                  end if;
           end if;

           --#72
           v_filtro:='';
           if pxp.f_existe_parametro(p_tabla , 'consolidar')then
                     if (v_parametros.consolidar='si') then
                       v_filtro:=' and plani.id_periodo <= '||v_parametros.id_periodo;
                     else
                       v_filtro:=' and plani.id_periodo = '||v_parametros.id_periodo;
           			end if;
           end if;
           
           --estados #ETR-4190
           if pxp.f_existe_parametro(p_tabla , 'estado_funcionario')then
              if(v_parametros.estado_funcionario='activo') then
                  v_filtro := v_filtro||' and plani.f_es_funcionario_vigente(fp.id_funcionario, tt.fecha_planilla) is true';
              elsif (v_parametros.estado_funcionario='retirado') then
                  v_filtro := v_filtro||' and plani.f_es_funcionario_vigente(fp.id_funcionario, tt.fecha_planilla) is false';
              end if;
           end if;
        	v_consulta:='select distinct fp.id_funcionario,per.apellido_paterno, per.apellido_materno,split_part(per.nombre,'' '',1)::varchar as primer_nombre,
						(split_part(per.nombre,'' '',2)||'' ''||split_part(per.nombre,'' '',3))::varchar as segundo_nombre,per.ci,
                         ''CI''::varchar as ci, per.expedicion,
                         sum(cv.valor), tcol.codigo,   date_part(''year''::text, age(per.fecha_nacimiento::timestamp with time zone))::integer, 
                         tt.nro_afp, tt.tipo_jub  ,
                         (select nombre from param.tlugar where id_lugar =(select param.f_get_id_lugar_tipo(fp.id_lugar,''departamento'')))::varchar as departamento,
                         ffun.desc_funcionario2
                         ,
						(case when
                            tt.fecha_ingreso between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''  then
                                tt.fecha_ingreso
                            else
                            null::date
                            end) as fecha_ingreso,
                         ( case when tt.fecha_finalizacion is not null and tt.fecha_finalizacion between '''||v_fecha_ini||''' and '''||v_fecha_fin||''' then
                            tt.fecha_finalizacion
                         else
                           null::date
                           end
                         ) as fecha_finalizacion,  tt.nombre_afp, tt.id_afp, --ETR-2416
                         param.f_get_periodo_literal('||v_parametros.id_periodo||') as periodo,

   						 tt.dias, tt.dias_incap, tt.var1, tt.var2, tt.var3 --#45
						 , tt.ncotiz, tt.nvar1, tt.nvar2, tt.nvar3 --#83
                         from '||v_esquema||'.tplanilla plani
                         inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_planilla=plani.id_planilla
                         inner join orga.tfuncionario fun on fun.id_funcionario=fp.id_funcionario
                         inner join segu.tpersona per on per.id_persona=fun.id_persona
                         --inner join plani.vrep_funcionario rep on rep.id_funcionario=fp.id_funcionario and fp.id_uo_funcionario=rep.id_uo_funcionario
                         inner join orga.vfuncionario ffun on ffun.id_funcionario=fp.id_funcionario
                         inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo in (''PLASUE'')
                         inner join tt_func tt on tt.id_funcionario=fp.id_funcionario --and tt.tipo_jub =rep.tipo_jubilado
                         inner join plani.ttipo_columna tcol on tcol.id_tipo_planilla=tp.id_tipo_planilla
                         inner join '||v_esquema||'.tcolumna_valor cv on cv.id_tipo_columna=tcol.id_tipo_columna and fp.id_funcionario_planilla=cv.id_funcionario_planilla
                         inner join param.tlugar lug on lug.id_lugar=fp.id_lugar
                        -- inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                         where '||v_parametros.filtro||' and tcol.codigo in (''COTIZABLE'')
                         and tt.id_afp='||v_parametros.id_afp||v_condicion||v_filtro||'

                         group by fp.id_funcionario,per.apellido_paterno, per.apellido_materno,per.nombre,
                         per.ci, per.expedicion,tcol.codigo,  date_part(''year''::text, age(per.fecha_nacimiento::timestamp with time zone)), nro_afp, tt.tipo_jub,ffun.desc_funcionario2, tt.fecha_ingreso,  tt.fecha_finalizacion,
                         tt.nombre_afp, tt.id_afp, fp.id_lugar,

   						 tt.dias, tt.dias_incap, tt.var1, tt.var2, tt.var3 --#45
						 , tt.ncotiz, tt.nvar1, tt.nvar2, tt.nvar3';

                   if(v_parametros.tipo_reporte='fondo_solidario') then	--#137
                        v_consulta:=v_consulta||' having  sum(cv.valor)>13000';
            	   end if;

					v_consulta:=v_consulta|| ' order by  ffun.desc_funcionario2';

                        -- raise notice '****************%',v_consulta;


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

            v_condicion:=' and 0=0';
          --#77
          if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
            if(v_parametros.id_tipo_contrato>0) then
              v_condicion = ' and c.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
            end if;
          end if;
            if(v_parametros.tipo_reporte='personal_ret') then
            --#158
             if pxp.f_existe_parametro(p_tabla , 'fecha')then
                    v_fecha_fin:=v_parametros.fecha;
           	 end if;
           
           		v_consulta:='select fun.desc_funcionario1, uof.fecha_finalizacion,
      					uof.observaciones_finalizacion, fun.id_funcionario, c.nombre, uop.nombre_uo_centro,
                        esc.haber_basico ,split_part( param.f_get_periodo_literal((select id_periodo from param.tperiodo where uof.fecha_finalizacion between fecha_ini and fecha_fin) ),'' '',1)::varchar
						,'||v_antiguedad||' as gestion, t.nombre,
                        (case when uof.fecha_finalizacion is not null then ''fijo''
                        else ''indefinido''
                        end) as tipo --#ETR-2804
                        from orga.tuo_funcionario uof
                        inner join orga.vfuncionario fun on fun.id_funcionario=uof.id_funcionario
                        and uof.estado_reg!=''inactivo'' and uof.tipo=''oficial'' --#137
                        inner join orga.tcargo c on c.id_cargo=uof.id_cargo
                        inner join orga.ttipo_contrato t on t.id_tipo_contrato=c.id_tipo_contrato --and t.codigo=''PLA''
                        inner join  orga.vuo_centro uop ON uop.id_uo = uof.id_uo
                        inner join orga.tescala_salarial esc on esc.id_escala_salarial=c.id_escala_salarial
                        where uof.tipo=''oficial''
                        and uof.fecha_finalizacion between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''
                        --#94
                        --and fun.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>uof.fecha_asignacion and tipo=''oficial'' and estado_reg!=''inactivo'') --#137
                        and uof.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')--#96  --ETR-2476
                		'||v_condicion||'
		                and uof.estado_reg=''activo''
                        order by uof.fecha_finalizacion
                         ';
            else
            	v_consulta:='select fun.desc_funcionario1, plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion),
      					 ''''::varchar as observaciones_finalizacion, fun.id_funcionario, c.nombre, uop.nombre_uo_centro,
                         esc.haber_basico ,
                         split_part( param.f_get_periodo_literal((select id_periodo from param.tperiodo where plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion) between fecha_ini and fecha_fin) ),'' '',1)::varchar
						,'||v_antiguedad||' as gestion, t.nombre,
                        (case when uof.fecha_finalizacion is not null then ''fijo''
                        else ''indefinido''
                        end) as tipo --#ETr-2804
                        from orga.tuo_funcionario uof
                        inner join orga.vfuncionario fun on fun.id_funcionario=uof.id_funcionario
                        inner join orga.tcargo c on c.id_cargo=uof.id_cargo
                        inner join orga.ttipo_contrato t on t.id_tipo_contrato=c.id_tipo_contrato --and t.codigo=''PLA''
                        inner join  orga.vuo_centro uop ON uop.id_uo = uof.id_uo
                        inner join orga.tescala_salarial esc on esc.id_escala_salarial=c.id_escala_salarial
                        where uof.tipo=''oficial''
                        and uof.estado_reg=''activo''
                        '||v_condicion||'
                        and ( plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion)) between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''
                        --#94 (se omite que esten vigentes, y para no duplicar por las transferencias, se iguala la fecha del primer contrato con el de la asignacion)
                        and ( plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion)) = uof.fecha_asignacion
                        --and (uof.fecha_finalizacion is null or uof.fecha_finalizacion>now())
                        order by  plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uof.fecha_asignacion)';

            end if;
      		return v_consulta;
      end;
    elsif (p_transaccion='PLA_PLATRIB_SEL') then
      begin
     		--#83
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
            ELSE
                   v_esquema = 'plani';
            END IF;

          --#77
            if pxp.f_existe_parametro(p_tabla , 'fecha')then
              if(v_parametros.fecha is not null) then
                 v_fecha=v_parametros.fecha;
                 v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
              else
                 execute ' select distinct plani.fecha_planilla
                 from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp
                 on tp.id_tipo_planilla=plani.id_tipo_planilla
                 where tp.codigo=''PLASUE'' and
                 plani.id_periodo='||v_parametros.id_periodo into v_registros_det;

                 v_fecha:=v_registros_det.fecha_planilla;
                 v_id_periodo:=v_parametros.id_periodo;
              end if;
            else
                 execute ' select distinct plani.fecha_planilla
                 from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp
                 on tp.id_tipo_planilla=plani.id_tipo_planilla
                 where tp.codigo=''PLASUE'' and
                 plani.id_periodo='||v_parametros.id_periodo into v_registros_det;

                 v_fecha:=v_registros_det.fecha_planilla;
                 v_id_periodo:=v_parametros.id_periodo;
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
              ingreso integer,
              retiro  integer

            )on commit drop;

			v_condicion:=' and 0=0 ';
          
			 if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
            if(v_parametros.id_tipo_contrato>0) then
              v_condicion = ' and p.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
            end if;
          end if;

			v_cons:=' select distinct fp.id_funcionario, plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario, f.fecha_asignacion) as fecha_ingreso ,
                     (select fecha_finalizacion from orga.tuo_funcionario uoff
									 inner join orga.tcargo cc on cc.id_cargo=uoff.id_cargo
                                     and uoff.estado_reg!=''inactivo'' and uoff.tipo=''oficial'' --#137
  									 where id_funcionario=fp.id_funcionario
									 and fecha_finalizacion<='''||v_fecha_fin||''' and fecha_finalizacion>='''||v_fecha_ini||'''
									 and observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'') --#ETR-2476
									 and cc.id_cargo=f.id_cargo
									 order by fecha_finalizacion desc limit 1
									) as fecha_finalizacion
                      from '||v_esquema||'.tfuncionario_planilla fp
                      inner join '||v_esquema||'.tplanilla p on p.id_planilla=fp.id_planilla
                      inner join plani.vrep_funcionario f on f.id_funcionario=fp.id_funcionario
                      and f.id_uo_funcionario=fp.id_uo_funcionario
                      where p.id_periodo='||v_id_periodo|| '' ||v_condicion ;

            for v_registros in execute(
                 v_cons
                            ) loop


                    if(v_registros.fecha_ingreso between v_fecha_ini and v_fecha_fin) then
                    	v_antiguedad:=1;
                    else
                    	v_antiguedad:=0;
                    end if;

                     if(v_registros.fecha_finalizacion is not null and v_registros.id_funcionario not in (select id_funcionario from orga.tuo_funcionario where fecha_asignacion>v_registros.fecha_finalizacion and tipo='oficial' and estado_reg!='inactivo')) then  --#137  --#163
                     	v_antiguedad_anos:=1;
                     else
                     	v_antiguedad_anos:=0;
                     end if;


              		insert into tt_func
              		values (v_registros.id_funcionario,v_antiguedad, v_antiguedad_anos  );

            end loop;


		    v_consulta:='select fun.id_funcionario,
                            per.apellido_paterno, per.apellido_materno, per.nombre,
                            per.ci,

                            (select periodo from param.tperiodo where id_periodo=plani.id_periodo),
                            (select gestion from param.tgestion where id_gestion=plani.id_gestion),
                            ff.codigo_rciva, per.tipo_documento,
							(case when tf.ingreso=1 then ''I''
                             else (case when tf.retiro=1 then ''D''
                             	else
                                  ''V''
                             end)
                            end)::varchar as novedad, colval.valor
						from '||v_esquema||'.tfuncionario_planilla fp
                        inner join '||v_esquema||'.tplanilla plani on plani.id_planilla = fp.id_planilla
						inner join plani.treporte repo on repo.id_tipo_planilla = plani.id_tipo_planilla
                        inner join plani.treporte_columna repcol  on repcol.id_reporte = repo.id_reporte
                        inner join '||v_esquema||'.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
                        and repcol.codigo_columna = colval.codigo_columna
                        inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
						inner join orga.vfuncionario fun on fun.id_funcionario = fp.id_funcionario
                        and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial'' --#137
						inner join orga.tfuncionario ff on ff.id_funcionario=fun.id_funcionario
						inner join segu.tpersona per on per.id_persona=ff.id_persona
                        inner join tt_func tf on tf.id_funcionario=ff.id_funcionario
                        where '||v_parametros.filtro||' and repo.titulo_reporte ilike ''%Planilla%Tributaria%''
                        order by fun.desc_funcionario2, repcol.orden

                        ';


                        return v_consulta;
       end;
    elsif (p_transaccion='PLA_INFDEP_SEL') then
      begin
      --#83
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
            ELSE
                   v_esquema = 'plani';
            END IF;

      --#77
        if pxp.f_existe_parametro(p_tabla , 'fecha')then
          if(v_parametros.fecha is not null) then
        	 v_fecha=v_parametros.fecha;
             v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
             --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
          else
              execute ' select distinct plani.fecha_planilla
                 from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp
                 on tp.id_tipo_planilla=plani.id_tipo_planilla
                 where tp.codigo=''PLASUE'' and
                 plani.id_periodo='||v_parametros.id_periodo into v_registros_det;
              v_fecha:=v_registros_det.fecha_planilla;
              v_id_periodo:=v_parametros.id_periodo;
             -- v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
          end if;
        else
             execute ' select distinct plani.fecha_planilla
                 from '||v_esquema||'.tplanilla plani inner join plani.ttipo_planilla tp
                 on tp.id_tipo_planilla=plani.id_tipo_planilla
                 where tp.codigo=''PLASUE'' and
                 plani.id_periodo='||v_parametros.id_periodo into v_registros_det;
             v_fecha:=v_registros_det.fecha_planilla;
             v_id_periodo:=v_parametros.id_periodo;
            -- v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
        end if;


             v_condicion:=' and 0=0 ';
             if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
              if(v_parametros.id_tipo_contrato>0) then
                v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
              end if;
            end if;



            --#98
            v_filtro_estado:='';
			execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
						 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						 where '||v_parametros.filtro||' limit 1' into v_fecha_estado;



            if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                    v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';
                elsif (v_parametros.estado_funcionario='retirado') then
                       v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')  --#ETR-2476
                          ';
          		else
                     v_filtro_estado:='
                    and (( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or


                      ( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')))  --#ETR-2476
                          ';

               end if;
			end if;

            if (v_parametros.tipo_reporte='dependientes') then --#89

            v_consulta:='  select p.id_persona , p.matricula, p.historia_clinica, trim (both ''FUNODTPR'' from fun.codigo)::varchar as codigo, p.fecha_nacimiento,
               plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, repf.id_funcionario,uofun.fecha_asignacion) as fecha_ingreso,
              repf.desc_funcionario2 as nombre_funcionario, pr.relacion, pr.nombre::text as nombre_dep, pr.fecha_nacimiento as fecha_nacimiento_dep, ''''::varchar as matricula_dep, ''''::varchar as historia_clinica_dep
              , date_part(''year'', age(pr.fecha_nacimiento))::integer AS edad_dep
              from segu.tpersona p
              inner join segu.tpersona_relacion pr on pr.id_persona=p.id_persona
              inner join orga.tfuncionario fun on fun.id_persona=p.id_persona
              inner join orga.vfuncionario repf on repf.id_funcionario=fun.id_funcionario
              
              inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=repf.id_funcionario
                            --#66
            inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario --#98
              inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
              inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                            --#66
              inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
              inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo=''PLASUE''
              inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla

              and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial'' --#137
              --where pla.id_periodo='||v_id_periodo||v_condicion||'
              where '||v_parametros.filtro||v_condicion||v_filtro_estado||' --#98
              order by repf.desc_funcionario2, pr.relacion, pr.fecha_nacimiento';
              

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


                 while (v_contador< 100) loop --#89

                    v_filtro:='SELECT repf.desc_funcionario2 as nombre_funcionario,
                            pr.nombre::text as nombre_dep, pr.fecha_nacimiento as fecha_nacimiento_dep
                            , date_part(''year'', age(pr.fecha_nacimiento)) AS edad_dep,
                            upper(substring(pr.genero,1,1)) as genero --#ETR-1379
                            ,ofi.nombre as distrito
                            FROM segu.tpersona p
                            inner join segu.tpersona_relacion pr on pr.id_persona=p.id_persona
                            inner join orga.tfuncionario fun on fun.id_persona=p.id_persona
                            inner join orga.vfuncionario repf on repf.id_funcionario=fun.id_funcionario  --#ETR-1817
                            inner join plani.tfuncionario_planilla fp on fp.id_funcionario=repf.id_funcionario
							inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                            inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo=''PLASUE''
                            inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                            inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario --#98
                            and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial'' --#137
                            inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
                            inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                            inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                            where '||v_parametros.filtro||v_condicion||v_filtro_estado||' --#98

                            and pr.relacion ilike ''%hij%''
                            and  date_part(''year'', age(pr.fecha_nacimiento)) between '||  v_contador ||' and '||  v_fin ||'
                            order by pr.fecha_nacimiento desc';

                     for v_registros in execute (v_filtro
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
         --#77
        if pxp.f_existe_parametro(p_tabla , 'fecha')then
          if(v_parametros.fecha is not null) then
        	 v_fecha=v_parametros.fecha;
             v_id_periodo:=(select id_periodo from param.tperiodo where v_parametros.fecha between fecha_ini and fecha_fin);
             --#98
            -- v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
          else
             v_fecha:=(select distinct plani.fecha_planilla from plani.tplanilla plani inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
             where tp.codigo='PLASUE' and plani.id_periodo=v_parametros.id_periodo);
             v_id_periodo:=v_parametros.id_periodo;
             --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
          end if;
        else
             v_fecha:=(select distinct plani.fecha_planilla from plani.tplanilla plani inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
             where tp.codigo='PLASUE' and plani.id_periodo=v_parametros.id_periodo);
             v_id_periodo:=v_parametros.id_periodo;
             --#98
            -- v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_parametros.id_periodo);

        end if;

        --#66
        v_condicion:=' and 0=0 ';

        if(v_parametros.tipo_reporte='curva_salarial') then
            v_ordenar:='tf.codigo';
        else -- curva_salarial_centro
        	--v_ordenar:=' (select  uo_centro_orden from orga.vuo_centro where id_uo= uof.id_uo)';
            v_ordenar:=' orden.ruta, orden.prioridad'; --#81
        end if;

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
                numero_nivel varchar, --#81
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

                , afp_sso  numeric,
                afp_rcom numeric,
                afp_cadm numeric,
                afp_apnal numeric,
                afp_apsol	numeric,
                nombre_centro	varchar,
                orden_centro	numeric,
                bonant	numeric,
                estado_afp varchar --#81
                ,fecha_backup	text--#83
                ,ruta varchar
            	)on commit drop;

            if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
              if(v_parametros.id_tipo_contrato>0) then
                v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
              end if;
            end if;


            --#83
            v_fecha_backup:=' ''01-01-1000'' ';
            -- v_agrupar_por:='';
            IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
                   if(v_esquema='planibk') then
                      v_fecha_backup:='to_char(plani.fecha_backup,''dd-mm-YYYY'') || '' (''||plani.id_planilla||'')'' ';
                   end if;
            ELSE
                   v_esquema = 'plani';
            END IF;

            --#98
            v_filtro_estado:='';
			execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
						 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						 where '||v_parametros.filtro||' limit 1' into v_fecha_estado;

            if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                    v_filtro_estado:='  and uof.fecha_asignacion <= '''||v_fecha_estado||''' and uof.estado_reg = ''activo'' and uof.tipo = ''oficial''
                    and (uof.fecha_finalizacion is null or (uof.fecha_finalizacion<='''||v_fecha_estado||''' and uof.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uof.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';
                elsif (v_parametros.estado_funcionario='retirado') then
                       v_filtro_estado:='  and uof.fecha_asignacion <= '''||v_fecha_estado||''' and uof.estado_reg = ''activo'' and uof.tipo = ''oficial''  and uof.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uof.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')  --#ETR-2476
                          ';

            	else
                     v_filtro_estado:='
                    and (( uof.fecha_asignacion <= '''||v_fecha_estado||''' and uof.estado_reg = ''activo'' and uof.tipo = ''oficial''
                    and (uof.fecha_finalizacion is null or (uof.fecha_finalizacion<='''||v_fecha_estado||''' and uof.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') ) --#ETR-2476
                    or (uof.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or


                      ( uof.fecha_asignacion <= '''||v_fecha_estado||''' and uof.estado_reg = ''activo'' and uof.tipo = ''oficial''  and uof.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uof.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial''))) --#ETR-2476
                          ';
               end if;
			end if;

			-- #ETR-1290
            v_filtro:='select tf.id_funcionario,  trim (both ''FUNODTPR'' from tf.codigo) as codigo,p.ci, p.tipo_documento, p.expedicion,
                                fafp.nro_afp,
                                p.apellido_paterno, p.apellido_materno,
                                split_part(p.nombre,'' '',1)::varchar as primer_nombre
                                , split_part(p.nombre,'' '',2)::varchar as segundo_nombre, p.fecha_nacimiento, p.direccion, p.telefono1, p.grupo_sanguineo,
                                upper(substr(p.genero,1,1))::varchar as genero, upper(substr(p.estado_civil,1,1))::varchar as estado_civil
                                ,
                                tes.descripcion as profesion, --#81
                                pxp.f_iif(
                                 (select orga.f_get_cargo_x_funcionario_str(tf.id_funcionario,plani.fecha_planilla)) is NULL,
                                 (select  car.nombre
                                            from orga.tuo_funcionario ha
                                            inner join orga.tcargo car on car.id_cargo = ha.id_cargo
                                            inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                                            where ha.id_funcionario =tf.id_funcionario and
                                            tcon.codigo in (''PLA'',''EVE'') and ha.tipo = ''oficial'' and ha.estado_reg!=''inactivo --#137''
                                            order by fecha_asignacion desc limit 1)
                                 ,(select orga.f_get_cargo_x_funcionario_str(tf.id_funcionario,plani.fecha_planilla))) as cargo,
                                (plani.f_get_fecha_primer_contrato_empleado(0,tf.id_funcionario,uof.fecha_asignacion)) as fecha_ingreso,
                                 pxp.f_iif(tcon.codigo=''PLA'' and uof.fecha_finalizacion is null,''Indefinido'',''Fijo'') as tiempo_contrato,
                                ofi.nombre as distrito,
                                (select  codigo_uo_centro from orga.vuo_centro where id_uo= uof.id_uo) as codigo_centro,
                                --niv.numero_nivel,
                                (''N''||pxp.f_rellena_cero_din(orden.nivel,2)||''-P''||pxp.f_rellena_cero_din(coalesce(orden.prioridad,0)::integer,4)) ::varchar as numero_nivel,
                                esc.nombre as escala_cargo ,
                                (select nombre from param.tlugar where id_lugar=ofi.id_lugar) as lugar_pago,--#81
                                COALESCE((select esct.codigo from orga.ttipo_cargo tcar
                                inner join orga.tescala_salarial esct on esct.id_escala_salarial=tcar.id_escala_salarial_max
                                where tcar.id_tipo_cargo=car.id_tipo_cargo),''0'') as escala_sal_max,


                                COALESCE((select esct.haber_basico from orga.ttipo_cargo tcar
                                inner join orga.tescala_salarial esct on esct.id_escala_salarial=tcar.id_escala_salarial_max
                                where tcar.id_tipo_cargo=car.id_tipo_cargo),0) as basico_limite,

                                pxp.f_iif(tf.fecha_quinquenio is null,(plani.f_get_fecha_primer_contrato_empleado(0,tf.id_funcionario,(select max(fecha_asignacion) from orga.tuo_funcionario where id_funcionario=tf.id_funcionario and estado_reg!=''inactivo'' and tipo=''oficial'' )))||'''', tf.fecha_quinquenio||'''')::date as fecha_quinquenio,  --ETR-2064
                                tf.antiguedad_anterior, plani.fecha_planilla,
                                p.celular1,

                                (select fcb.nro_cuenta from orga.tfuncionario_cuenta_bancaria fcb where fcb.id_funcionario=tf.id_funcionario and fcb.estado_reg=''activo''
                                and plani.fecha_planilla between fcb.fecha_ini and coalesce (fcb.fecha_fin,plani.fecha_planilla))
                                 as nro_cuenta
                                ,
                                (select ins.nombre from orga.tfuncionario_cuenta_bancaria fcb inner join param.tinstitucion ins on ins.id_institucion=fcb.id_institucion where fcb.id_funcionario=tf.id_funcionario and fcb.estado_reg=''activo''
                                and plani.fecha_planilla between fcb.fecha_ini and coalesce (fcb.fecha_fin,plani.fecha_planilla) )
                                as banco
                                ,fp.id_funcionario_planilla, uof.fecha_finalizacion, uof.observaciones_finalizacion,
                                afp.nombre as nombre_afp

                                ,(select  nombre_uo_centro from orga.vuo_centro where id_uo= uof.id_uo) as nombre_centro
                                ,(select  uo_centro_orden from orga.vuo_centro where id_uo= uof.id_uo) as orden_centro

                                ,(select tc.codigo from '||v_esquema||'.tcolumna_valor
                                cv inner join plani.ttipo_columna tc on tc.id_tipo_columna=cv.id_tipo_columna

                                where cv.id_funcionario_planilla=fp.id_funcionario_planilla and tc.codigo in (''JUB55'',''JUB65'',''MAY65'')
                                and cv.valor=0 ) as estado_afp,
                                (select valor_col from '||v_esquema||'.vdatos_func_planilla
                                where id_funcionario_planilla=fp.id_funcionario_planilla and nombre_col=''total_gral'') as total_gral
                                ,'||v_fecha_backup||'::text as fecha_backup, orden.ruta
                                from orga.tfuncionario tf
                                inner join segu.tpersona p on p.id_persona=tf.id_persona
                                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario=tf.id_funcionario and fafp.estado_reg=''activo''
                                inner join plani.tafp afp on afp.id_afp=fafp.id_afp
                                --left join orga.tfuncionario_especialidad  fe on fe.id_funcionario=tf.id_funcionario
                                left join param.tcatalogo tes on tes.codigo=tf.profesion --#81
                                inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=tf.id_funcionario
                                inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                                inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla
                                inner join orga.tuo_funcionario uof on uof.id_funcionario=tf.id_funcionario and fp.id_funcionario=uof.id_funcionario
								and uof.estado_reg!=''inactivo'' and uof.tipo=''oficial''  --#137
                                and uof.id_uo_funcionario=fp.id_uo_funcionario
                                inner join orga.tuo uo on uo.id_uo=uof.id_uo
                                inner join orga.tnivel_organizacional niv on niv.id_nivel_organizacional=uo.id_nivel_organizacional
                                inner join orga.tcargo car on car.id_cargo=uof.id_cargo
								inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                                inner join orga.tescala_salarial esc on esc.id_escala_salarial=car.id_escala_salarial
                                inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                                inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                                inner join '||v_esquema||'.vorden_planilla orden on orden.id_funcionario_planilla=fp.id_funcionario_planilla and orden.id_periodo=plani.id_periodo
                                where '||v_parametros.filtro|| ' and
                                plani.id_periodo='||v_id_periodo||v_condicion||' and
            					plani.fecha_planilla between fafp.fecha_ini and coalesce(fafp.fecha_fin,plani.fecha_planilla) and

                                tippla.codigo=''PLASUE''  '||v_filtro_estado||'
                                order by '||v_ordenar;

            raise notice '----%', v_filtro;
    		for v_registros in execute( v_filtro
				) loop
                v_consulta_det:='select tc.codigo, cv.valor
                	from '||v_esquema||'.tcolumna_valor cv
                    inner join plani.ttipo_columna tc on tc.id_tipo_columna=cv.id_tipo_columna
                    where cv.id_funcionario_planilla='||v_registros.id_funcionario_planilla||'
                    and tc.codigo in (
                    ''HABBAS'',''COTIZABLE'',''LIQPAG'',''DISPONIBILIDAD'',
                    ''SUBPRE'',''SUBNAT'',''SUBLAC'',''TOTGAN'',''TOT_DESC'',''AFP_PAT''

                    ,''BONFRONTERA'',''HOREXT'',''EXTRA'',''HORNOC'',''NOCTURNO'',''SUELDOMES'',
                    ''ASIGTRA'',''ASIGTRA_IT'',''ASIGESP'',''ASIGESP_IT'',''ASIGCAJA'',''ASIGCAJA_IT'',''ASIGNACIONES''
                    ,''AFP_SSO'',''AFP_RCOM'',''AFP_CADM'',''AFP_APSOL'',''AFP_APNALSOL'',''BONANT'',''INCAP_TEMPORAL'')'; --#90
					for v_registros_det in execute (v_consulta_det) loop


					 if (v_registros.fecha_finalizacion is not null and v_registros.fecha_finalizacion <=v_fecha) then

                             if not exists (select 1 from orga.tuo_funcionario where id_funcionario=v_registros.id_funcionario and fecha_asignacion>v_registros.fecha_finalizacion and estado_reg!='inactivo' and tipo='oficial') then
                                  v_estado:='Retirado';
                             end if;

                    else
                        v_estado:='Activo';
                    end if;
                    --#81
					v_estado_afp:='Activo';


                    if (v_registros.estado_afp='JUB55') then
                          v_estado_afp:='Jubilado de 55';

                    elsif (v_registros.estado_afp='JUB65') then
                          v_estado_afp:='Jubilado de 65';

                    elsif (v_registros.estado_afp='MAY65') then
                          v_estado_afp:='Mayor de 65';
                    end if;

					--ETR-1489: se quita las condiciones por fecha de consulta, aunq la finalizacion sea en el futuro, mostrar como este el registro
                   -- if(v_registros.fecha_finalizacion is not null and v_registros.fecha_finalizacion <=v_fecha) then
                     -- if not exists (select 1 from orga.tuo_funcionario where id_funcionario=v_registros.id_funcionario and fecha_asignacion>v_registros.fecha_finalizacion and estado_reg!='inactivo' and tipo='oficial') then
                          v_fecha_fin:=v_registros.fecha_finalizacion;
                          v_motivo:=v_registros.observaciones_finalizacion;
                      --else
                        --  v_fecha_fin:=null;
                         -- v_motivo:=null;
                      --end if;
                   -- else
                     -- v_fecha_fin:=null;
                     -- v_motivo:=null;
                   -- end if;

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
                        ----
                    elsif (v_registros_det.codigo='AFP_SSO') then
                    	v_afp_sso:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='AFP_RCOM') then
                    	v_afp_rcom:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='AFP_CADM') then
                    	v_afp_cadm:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='AFP_APSOL') then
                    	v_afp_apsol:=v_registros_det.valor;
                    elsif (v_registros_det.codigo='AFP_APNALSOL') then
                    	v_afp_apnal:=v_registros_det.valor;
                       ----
                    elsif(v_registros_det.codigo='AFP_PAT') then --#81
                      --v_totgral:=v_registros_det.valor; --total_patronal_afp
                      v_totgral:=v_registros.total_gral;--(select valor_col from plani.vdatos_func_planilla where id_funcionario_planilla=v_registros.id_funcionario_planilla and nombre_col='total_gral');
                    elsif(v_registros_det.codigo='BONANT') then --#81
                      v_bonant:=v_registros_det.valor;
                    elsif(v_registros_det.codigo='INCAP_TEMPORAL') then --#90
                      v_incap:=v_registros_det.valor;
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
               ,afp_sso  ,
                afp_rcom ,
                afp_cadm ,
                afp_apnal ,
                afp_apsol, nombre_centro, orden_centro
                                , bonant, estado_afp--#81
                                ,fecha_backup --#83,
                                ,ruta
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
                                v_subpre, v_sublac,--#81
                                v_subnat,

                                v_totgan,
                                v_totdesc,
	                  			(v_totgral-v_incap), --#90
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
                                ,v_afp_sso  ,
                v_afp_rcom ,
                v_afp_cadm ,
                v_afp_apnal ,
                v_afp_apsol, v_registros.nombre_centro, v_registros.orden_centro
                       ,v_bonant , v_estado_afp    --#81
                       ,v_registros.fecha_backup --#83,
                       ,v_registros.ruta
                  );


                end loop;
               if(v_parametros.tipo_reporte='curva_salarial') then
                   v_ordenar:='codigo';
               else
                	v_ordenar:='ruta';

                end if;


                        v_consulta:='SELECT codigo ,num_documento , tipo_documento , expedicion ,
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
               ,afp_sso  ,
                afp_rcom ,
                afp_cadm ,
                afp_apnal ,
                afp_apsol, nombre_centro, orden_centro
                                , bonant, estado_afp
                                ,fecha_backup
                                FROM tt_curva_sal order by '||v_ordenar||'
                              ';

                      return v_consulta;

       end;

	elsif (p_transaccion='PLA_ASIGCAR_SEL') then           --#67
       begin
            -- necesario la gestion
            -- opcional el tipo contrato

       		 SELECT
                  per.fecha_ini,
                  per.fecha_fin
              INTO
                  v_fecha_ini,
                  v_fecha_fin
              FROM param.tgestion per
              WHERE id_gestion = v_parametros.id_gestion;

              v_condicion:=' and 0=0';
              if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                if(v_parametros.id_tipo_contrato>0) then
                  v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;
              end if;

			   v_consulta:='select fun.id_funcionario, trim (both ''FUNODTPR'' from fun.codigo)::varchar as codigo, uofun.fecha_finalizacion, fun.desc_funcionario2, car.nombre,
                        (select carn.nombre
                        from orga.tcargo carn inner join orga.tuo_funcionario uofunn on uofunn.id_cargo=carn.id_cargo
                        where uofunn.id_funcionario=fun.id_funcionario and uofunn.fecha_asignacion=uofun.fecha_finalizacion+1
                        and uofunn.estado_reg=''activo'' and uofunn.tipo=''oficial''  --#137
                        ) as nuevo_cargo,  (select extract(year from uofun.fecha_finalizacion) )::integer as gestion
                        , uoc.nombre_uo_centro,

                        (select uocn.nombre_uo_centro
                        from  orga.tuo_funcionario uofunn
                        inner join orga.vuo_centro uocn on uocn.id_uo=uofunn.id_uo
                        where uofunn.id_funcionario=fun.id_funcionario and uofunn.fecha_asignacion=uofun.fecha_finalizacion+1
                        and uofunn.estado_reg=''activo'' and uofunn.tipo=''oficial''  --#137
                        ) as nueva_unidad,
                        (select uofunn.fecha_asignacion
                        from  orga.tuo_funcionario uofunn
                        inner join orga.vuo_centro uocn on uocn.id_uo=uofunn.id_uo
                        where uofunn.id_funcionario=fun.id_funcionario and uofunn.fecha_asignacion=uofun.fecha_finalizacion+1
                        and uofunn.estado_reg=''activo'' and uofunn.tipo=''oficial''  --#137
                        ) as fecha_movimiento --#ETR-1993
                        --#ETR-2476
                        ,uofun.observaciones_finalizacion,
						esc.haber_basico,
                        (select esc1.haber_basico
                        from orga.tcargo carn inner join orga.tuo_funcionario uofunn on uofunn.id_cargo=carn.id_cargo
                        inner join orga.tescala_salarial esc1 on esc1.id_escala_salarial=carn.id_escala_salarial
                        where uofunn.id_funcionario=fun.id_funcionario and uofunn.fecha_asignacion=uofun.fecha_finalizacion+1
                        and uofunn.estado_reg=''activo'' and uofunn.tipo=''oficial''  --#137
                        ) as nuevo_haber,
                        esc.codigo as nivel,
                        (select esc1.codigo
                        from orga.tcargo carn inner join orga.tuo_funcionario uofunn on uofunn.id_cargo=carn.id_cargo
                        inner join orga.tescala_salarial esc1 on esc1.id_escala_salarial=carn.id_escala_salarial
                        where uofunn.id_funcionario=fun.id_funcionario and uofunn.fecha_asignacion=uofun.fecha_finalizacion+1
                        and uofunn.estado_reg=''activo'' and uofunn.tipo=''oficial''  --#137
                        ) as nuevo_nivel
                        
                        from orga.tcargo car
                        inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                        inner join orga.tuo_funcionario uofun on uofun.id_cargo=car.id_cargo
                        inner join orga.vfuncionario fun on fun.id_funcionario=uofun.id_funcionario
                        inner join orga.ttipo_cargo tcar on tcar.id_tipo_cargo=car.id_tipo_cargo

                        inner join orga.tuo uo on uo.id_uo=uofun.id_uo
                        inner JOIN orga.vuo_centro uoc ON uoc.id_uo = uo.id_uo
                         inner join orga.tescala_salarial esc on esc.id_escala_salarial=car.id_escala_salarial --#ETR-2476
                        where uofun.fecha_finalizacion between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''
                        and uofun.estado_reg=''activo'' '||v_condicion||'
                        and uofun.tipo=''oficial''
                        order by uofun.fecha_finalizacion,fun.desc_funcionario2, fun.codigo';
       raise notice '***%',v_consulta;
       		return v_consulta;

        end;

   elsif (p_transaccion='PLA_FRECCAR_SEL') then  --#67
       begin

			--#77
		   if (pxp.f_existe_parametro(p_tabla , 'id_periodo') and v_parametros.id_periodo >0 )then
        		v_id_periodo:=v_parametros.id_periodo;
                -- v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
       	   else
               v_id_periodo:=(select distinct p.id_periodo from plani.tplanilla p
               inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
               where tp.codigo='PLASUE' order by p.fecha_planilla desc limit 1);
                --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
           end if;

           v_condicion:=' and 0=0';
           if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                if(v_parametros.id_tipo_contrato>0) then
                  v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;
           end if;

		    --#83
           IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
           ELSE
                   v_esquema = 'plani';
           END IF;

            -- #98
            v_filtro_estado:='';
			v_filtro_estado1:='';
            execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
						 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						 where '||v_parametros.filtro||' limit 1' into v_fecha_estado;

            if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                    v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';

                    v_filtro_estado1:='  and uofunn.fecha_asignacion <= '''||v_fecha_estado||''' and uofunn.estado_reg = ''activo'' and uofunn.tipo = ''oficial''
                    and (uofunn.fecha_finalizacion is null or (uofunn.fecha_finalizacion<='''||v_fecha_estado||''' and uofunn.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofunn.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';
                elsif (v_parametros.estado_funcionario='retirado') then
                       v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')  --#ETR-2476
                          ';

                          v_filtro_estado1:='  and uofunn.fecha_asignacion <= '''||v_fecha_estado||''' and uofunn.estado_reg = ''activo'' and uofunn.tipo = ''oficial''  and uofunn.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofunn.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'') --#ETR-2476
                          ';

                else
                     v_filtro_estado:='
                    and (( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or
                      ( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')))  --#ETR-2476
                          ';

                    v_filtro_estado1:='
                    and (( uofunn.fecha_asignacion <= '''||v_fecha_estado||''' and uofunn.estado_reg = ''activo'' and uofunn.tipo = ''oficial''
                    and (uofunn.fecha_finalizacion is null or (uofunn.fecha_finalizacion<='''||v_fecha_estado||''' and uofunn.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofunn.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or
                      ( uofunn.fecha_asignacion <= '''||v_fecha_estado||''' and uofunn.estado_reg = ''activo'' and uofunn.tipo = ''oficial''  and uofunn.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofunn.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')))  --#ETR-2476
                          ';
               end if;
			end if;

              v_consulta:='select distinct tc.codigo, tc.nombre, (select count(*) from segu.tpersona pp inner join
              orga.tfuncionario funn on funn.id_persona=pp.id_persona
              inner join orga.tuo_funcionario uofunn on uofunn.id_funcionario=funn.id_funcionario
              inner join orga.tcargo carr on carr.id_cargo=uofunn.id_cargo
				and uofunn.estado_reg=''activo'' and uofunn.tipo=''oficial''  --#137
                    --         and plani.fecha_planilla between uofunn.fecha_asignacion and coalesce(uofunn.fecha_finalizacion,plani.fecha_planilla) --#77
              inner join '||v_esquema||'.tfuncionario_planilla ffp on ffp.id_uo_funcionario=uofunn.id_uo_funcionario
              inner join '||v_esquema||'.tplanilla pla on pla.id_planilla=ffp.id_planilla and pla.id_periodo=plani.id_periodo and pla.id_tipo_planilla=plani.id_tipo_planilla
              and ffp.id_planilla=plani.id_planilla
               where carr.id_tipo_cargo=tc.id_tipo_cargo
              and genero=''femenino'' '||v_filtro_estado1||' )::integer as femenino ,

              (select count(*) from segu.tpersona pp inner join
              orga.tfuncionario funn on funn.id_persona=pp.id_persona
              inner join orga.tuo_funcionario uofunn on uofunn.id_funcionario=funn.id_funcionario
              inner join orga.tcargo carr on carr.id_cargo=uofunn.id_cargo
			  and uofunn.estado_reg=''activo'' and uofunn.tipo=''oficial''  --#137
              --      and plani.fecha_planilla between uofunn.fecha_asignacion and coalesce(uofunn.fecha_finalizacion,plani.fecha_planilla) --#77
              inner join '||v_esquema||'.tfuncionario_planilla ffp on ffp.id_uo_funcionario=uofunn.id_uo_funcionario
              inner join '||v_esquema||'.tplanilla pla on pla.id_planilla=ffp.id_planilla and pla.id_periodo=plani.id_periodo and pla.id_tipo_planilla=plani.id_tipo_planilla
              and ffp.id_planilla=plani.id_planilla
               where carr.id_tipo_cargo=tc.id_tipo_cargo
              and genero!=''femenino'' '||v_filtro_estado1||')::integer as masculino
              ,param.f_get_periodo_literal(plani.id_periodo) as periodo --#ETR-3862
              from orga.ttipo_cargo tc
              inner join orga.tcargo c on c.id_tipo_cargo=tc.id_tipo_cargo
              inner join orga.tuo_funcionario uofun on uofun.id_cargo=c.id_cargo
              inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=c.id_tipo_contrato
              inner join orga.tfuncionario fun on fun.id_funcionario=uofun.id_funcionario
              inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=fun.id_funcionario and fp.id_uo_funcionario=uofun.id_uo_funcionario --#77
              inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
              inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
              where ';
                          v_consulta:=v_consulta||v_parametros.filtro;
                           v_consulta:=v_consulta||' and tc.estado_reg=''activo'' AND uofun.estado_reg=''activo''
                           and uofun.tipo=''oficial''  --#137
                           and plani.id_tipo_contrato=tcon.id_tipo_contrato '||v_condicion||'
              and plani.id_periodo='||v_id_periodo||v_filtro_estado||'

              order by tc.nombre';
              raise notice '%',v_consulta;
              return v_consulta;
      end;

  elsif (p_transaccion='PLA_LISTCAR_SEL') then  --#67
       begin

       v_condicion:=' and 0=0';
              if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                if(v_parametros.id_tipo_contrato>0) then
                  v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;
              end if;
    		  --#83
              IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
              ELSE
                   v_esquema = 'plani';
              END IF;

              --#98
              if (pxp.f_existe_parametro(p_tabla , 'id_periodo'))then
        		 v_id_periodo:=v_parametros.id_periodo;
                 --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
             else
                 v_id_periodo:=(select distinct p.id_periodo from plani.tplanilla p
                 inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                 where tp.codigo='PLASUE' order by p.fecha_planilla desc limit 1);
                 -- v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
             end if;


             -- #98
            v_filtro_estado:='';
            execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
						 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						 where '||v_parametros.filtro||' limit 1' into v_fecha_estado;

            if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                    v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';
                elsif (v_parametros.estado_funcionario='retirado') then
                       v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'') --#ETR-2476
                          ';
            	else
                     v_filtro_estado:='
                    and (( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') ) --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or


                      ( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')))  --#ETR-2476
                          ';



                end if;
			end if;

              v_consulta:='select distinct c.codigo, c.nombre from orga.tcargo c
                inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=c.id_tipo_contrato
                inner join orga.tuo_funcionario uofun on uofun.id_cargo=c.id_cargo
                inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_uo_funcionario=uofun.id_uo_funcionario
                inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                where ';
                          v_consulta:=v_consulta||v_parametros.filtro;
                           v_consulta:=v_consulta||' and c.estado_reg=''activo'' '||v_condicion||' and uofun.estado_reg=''activo''
                -- and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion > now())
                and uofun.tipo=''oficial'' '||v_filtro_estado||'
                order by c.nombre';
                raise notice '***%', v_consulta;
              return v_consulta;
      end;

  elsif (p_transaccion='PLA_CLASIFPROF_SEL') then  --#67
       begin

       		v_condicion:=' and 0=0';
              if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                if(v_parametros.id_tipo_contrato>0) then
                  v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;
              end if;
              --#83
              IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
              ELSE
                   v_esquema = 'plani';
              END IF;

			  if (pxp.f_existe_parametro(p_tabla , 'id_periodo') and v_parametros.id_periodo >0 )then
        		v_id_periodo:=v_parametros.id_periodo;
                --v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
       	      end if;

              --#98
            	v_filtro_estado:='';
				execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
						 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						 where '||v_parametros.filtro||' limit 1' into v_fecha_estado;

            if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                    v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';
                elsif (v_parametros.estado_funcionario='retirado') then
                       v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')  --#ETR-2476
                          ';
          		else
                     v_filtro_estado:='
                    and (( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') ) --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or


                      ( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')))  --#ETR-2476
                          ';

               end if;
			end if;

   			  --#77
              v_consulta:='select distinct cat.descripcion as profesion, --#81
              				trim (both ''FUNODTPR'' from fun.codigo)::varchar as codigo ,vfun.desc_funcionario2
	              			,param.f_get_periodo_literal(plani.id_periodo) as periodo_lite
              	          from segu.tpersona per
                          inner join orga.tfuncionario fun on fun.id_persona= per.id_persona
                          inner join orga.vfuncionario vfun on vfun.id_funcionario=fun.id_funcionario
                          inner join orga.tuo_funcionario uofun on uofun.id_funcionario=fun.id_funcionario
                          inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
                          inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato

                          inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_uo_funcionario=uofun.id_uo_funcionario
                          inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
						  inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                          left join param.tcatalogo cat on cat.codigo=fun.profesion
                          where ';
                          v_consulta:=v_consulta||v_parametros.filtro;
                           v_consulta:=v_consulta||' and
                          car.estado_reg=''activo'' and uofun.estado_reg=''activo'' and uofun.tipo=''oficial''
                          '||v_condicion||v_filtro_estado||'
                          -- and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion > now() )
                          order by cat.descripcion, vfun.desc_funcionario2'; --#81
raise notice '***:%',v_consulta;
       			return v_consulta;
       end;

 elsif (p_transaccion='PLA_DIREMP_SEL') then  --#67
       begin

           --#83
           IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
           ELSE
                   v_esquema = 'plani';
           END IF;

       		v_condicion:=' and 0=0';
            if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                if(v_parametros.id_tipo_contrato>0) then
                  v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;
            end if;

              --#77
		    if (pxp.f_existe_parametro(p_tabla , 'id_periodo') and v_parametros.id_periodo >0 )then
        		v_id_periodo:=v_parametros.id_periodo;
               -- v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
       	    else

               v_id_periodo:=(select distinct p.id_periodo from plani.tplanilla p
               inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
               where tp.codigo='PLASUE' order by p.fecha_planilla desc limit 1);
				--v_fecha_estado:=(select fecha_fin from param.tperiodo where id_periodo=v_id_periodo);--#98
            end if;

       --#77
       v_estado:='';

       if(v_parametros.tipo_reporte='directorio_empleados' or v_parametros.tipo_reporte='listado_centros') then --#115
           -- v_ordenar:='vrep.uo_centro_orden, vrep.desc_funcionario2';
           --#77
            v_ordenar:='nivel.ruta, nivel.prioridad,nivel.valor_col,vrep.desc_funcionario2';

            v_estado:='inner join '||v_esquema||'.vorden_planilla nivel on nivel.id_funcionario_planilla=fp.id_funcionario_planilla
                	and nivel.id_cargo=car.id_cargo and nivel.id_oficina=ofi.id_oficina and nivel.id_periodo=plani.id_periodo
               	    and nivel.id_tipo_contrato=tcon.id_tipo_contrato';



       elsif(v_parametros.tipo_reporte='nacimiento_ano') then
        	v_ordenar:='(SELECT EXTRACT(YEAR FROM vrep.fecha_nacimiento)),(SELECT EXTRACT(MONTH FROM vrep.fecha_nacimiento)),(SELECT EXTRACT(DAY FROM vrep.fecha_nacimiento)), vrep.desc_funcionario2';
       elsif(v_parametros.tipo_reporte='nacimiento_mes') then
       		v_ordenar:='(SELECT EXTRACT(MONTH FROM vrep.fecha_nacimiento)),(SELECT EXTRACT(DAY FROM vrep.fecha_nacimiento)), vrep.desc_funcionario2';
       end if;

        -- #98
            v_filtro_estado:='';
            execute 'select distinct plani.fecha_planilla from plani.tplanilla plani
						 inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						 where '||v_parametros.filtro||' limit 1' into v_fecha_estado;


            if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                    v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    ) ';
                elsif (v_parametros.estado_funcionario='retirado') then
                       v_filtro_estado:='  and uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')  --#ETR-2476
                          ';
            	else
                     v_filtro_estado:='
                    and (( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''
                    and (uofun.fecha_finalizacion is null or (uofun.fecha_finalizacion<='''||v_fecha_estado||''' and uofun.observaciones_finalizacion in (''transferencia'',''promocion'','''',''incremento_salarial'') )  --#ETR-2476
                    or (uofun.fecha_finalizacion>'''||v_fecha_estado||''' )
                    )
                     ) or
                      ( uofun.fecha_asignacion <= '''||v_fecha_estado||''' and uofun.estado_reg = ''activo'' and uofun.tipo = ''oficial''  and uofun.fecha_finalizacion <= '''||v_fecha_estado||'''
                             and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'', '''',''incremento_salarial'')))  --#ETR-2476
                          ';
                end if;
			end if;

  			v_consulta:='select ofi.nombre as nombre_oficina,
                          trim(both ''FUNODTPR'' from vrep.codigo)::varchar as codigo_funcionario,vrep.desc_funcionario2,vrep.nombre_cargo
                          ,
                          per.telefono1, vrep.celular_personal, vrep.correo_personal,vrep.direccion, vrep.nombre_uo_centro
                          ,(SELECT EXTRACT(YEAR FROM vrep.fecha_nacimiento))::integer as ano,
                          (SELECT EXTRACT(MONTH FROM vrep.fecha_nacimiento))::integer as mes,
						  (SELECT EXTRACT(DAY FROM vrep.fecha_nacimiento))::integer as dia
                          ,param.f_get_periodo_literal(plani.id_periodo) as periodo_lite,
                          pxp.f_obtener_literal_periodo((SELECT EXTRACT(MONTH FROM vrep.fecha_nacimiento))::integer, (SELECT EXTRACT(YEAR FROM vrep.fecha_nacimiento))::integer)::varchar as mes_lite
                          from plani.vrep_funcionario vrep
                          inner join orga.tcargo car on car.id_cargo=vrep.id_cargo
                          inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                          inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=vrep.id_uo_funcionario
                          inner join orga.tfuncionario tfun on tfun.id_funcionario=vrep.id_funcionario
                          inner join segu.tpersona per on per.id_persona=tfun.id_persona
                          inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_uo_funcionario=uofun.id_uo_funcionario
                          inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                          inner join orga.ttipo_contrato tcon on vrep.codigo_tipo_contrato=tcon.codigo '||v_condicion||'
                          and uofun.estado_reg=''activo'' and uofun.tipo=''oficial''
                          --and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion > now() )
                          and plani.fecha_planilla between vrep.fecha_ini_afp and coalesce(vrep.fecha_fin_afp,plani.fecha_planilla)
                          inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                          '||v_estado||'
                          where
                          ';
                           v_consulta:=v_consulta||v_parametros.filtro||v_filtro_estado;
                           v_consulta:=v_consulta||' order by '||v_ordenar;
                           raise notice 'xxx%',v_consulta;
            return v_consulta;

	   end;

  elsif (p_transaccion='PLA_FRECPROF_SEL') then  --#77
       begin
		   --#83
           IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                   v_esquema = v_parametros.esquema;
           ELSE
                   v_esquema = 'plani';
           END IF;

		   if (pxp.f_existe_parametro(p_tabla , 'id_periodo') and v_parametros.id_periodo >0 )then
        		v_id_periodo:=v_parametros.id_periodo;
           end if;
 			 v_condicion:=' and 0=0';
              if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                if(v_parametros.id_tipo_contrato>0) then
                  v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;
              end if;

		      v_consulta:='select distinct cat.descripcion as profesion , --#81
              			   (select count(*) from orga.tfuncionario funn
              			   inner join segu.tpersona pp on pp.id_persona=funn.id_persona
                           inner join '||v_esquema||'.tfuncionario_planilla ffp on ffp.id_funcionario=funn.id_funcionario and ffp.id_planilla=plani.id_planilla
                           where fun.profesion=funn.profesion
                           and pp.genero=''femenino'')::integer as femenino ,
                           (select count(*) from orga.tfuncionario funn
              			   inner join segu.tpersona pp on pp.id_persona=funn.id_persona
                           inner join '||v_esquema||'.tfuncionario_planilla ffp on ffp.id_funcionario=funn.id_funcionario and ffp.id_planilla=plani.id_planilla
	               		   where fun.profesion=funn.profesion
			               and pp.genero!=''femenino'')::integer as masculino
              from orga.tuo_funcionario uofun
              inner join orga.vfuncionario func on func.id_funcionario=uofun.id_funcionario
              inner join orga.tcargo c on c.id_cargo=uofun.id_cargo
              inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=c.id_tipo_contrato
              inner join orga.tfuncionario fun on fun.id_funcionario=uofun.id_funcionario
              inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=fun.id_funcionario and fp.id_uo_funcionario=uofun.id_uo_funcionario --#77
              inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
              inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
              left join param.tcatalogo cat on cat.codigo=fun.profesion
              where

              ';
             v_consulta:=v_consulta||v_parametros.filtro;
             v_consulta:=v_consulta||' and uofun.estado_reg=''activo'' AND uofun.tipo=''oficial'' and plani.id_tipo_contrato=tcon.id_tipo_contrato  '||v_condicion||'
              and plani.id_periodo='||v_id_periodo||'
  			  order by cat.descripcion';
              return v_consulta;
      end;
   elsif (p_transaccion='PLA_DETBONDESC_SEL') then  --#77
       begin
       		  v_condicion:=' and 0=0';

              --#83
               IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                       v_esquema = v_parametros.esquema;
               ELSE
                       v_esquema = 'plani';
               END IF;
              if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                if(v_parametros.id_tipo_contrato>0) then
                  v_condicion = v_condicion|| ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;
              end if;

              v_consulta:='select fun.id_funcionario, trim (both ''FUNODTPR'' from fun.codigo)::varchar as codigo,
              fun.desc_funcionario2::varchar,
                          tcol.codigo as codigo_columna, tcol.nombre as nombre_columna, cv.valor
                          , db.fecha_ini, db.fecha_fin
                          from orga.vfuncionario fun
                          inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=fun.id_funcionario
                          inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                          inner join plani.tdescuento_bono db on db.id_funcionario=fun.id_funcionario
                          inner join plani.ttipo_columna tcol on tcol.id_tipo_columna=db.id_tipo_columna
                          inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario
                          and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial''  --#137
                          inner join orga.tcargo car on car.id_cargo= uofun.id_cargo
                          inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato= car.id_tipo_contrato
                          inner join '||v_esquema||'.tcolumna_valor cv on cv.id_tipo_columna=tcol.id_tipo_columna and cv.id_funcionario_planilla=fp.id_funcionario_planilla
                          inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
              			  where ';
              v_consulta:=v_consulta||v_parametros.filtro;
              v_consulta:=v_consulta||' and db.estado_reg=''activo'' '||v_condicion||'
			  order by fun.desc_funcionario2, tcol.codigo';
        	  return v_consulta;
       end;
    elsif (p_transaccion='PLA_DETAGUIN_SEL') then  --#87
       begin
			select p.id_periodo into v_id_periodo_min
                from param.tperiodo p where periodo in (9)
				and id_gestion=v_parametros.id_gestion;

				select p.id_periodo into v_id_periodo
                from param.tperiodo p where periodo in (11)
				and id_gestion=v_parametros.id_gestion;
			--#155 
			v_col:='DIASAGUI'; v_col2:='DIASAGUI';  v_cols:='';
            v_cons:='select distinct tp.codigo from plani.tplanilla plani
                  		inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                  		inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
                  		where  tp.codigo in (''SPLAPRIVIG'',''PLAPRIVIG'') and '|| v_parametros.filtro;

			                       
           for v_registros in execute (v_cons) loop
                if (v_registros.codigo='SPLAPRIVIG') then
           			v_col:='SPREDIAS2'; v_col2:='SPREDIAS2';
                else
                	v_col2:='PREDIAS2'; v_col:='PREDIAS2'; --#ETR-3892
                end if;
                v_cols:= (select nombre ||'@@@'||nit||'@@@'||coalesce(identificador_min_trabajo,'-')||'@@@'||coalesce(identificador_caja_salud,'-') 
	          	 		  from param.tentidad limit 1 );
                          
                         
				select * into v_columnas from orga.f_obtener_gerente_x_codigo_uo('gerente_general',now()::date);

                v_cols:=v_cols ||'@@@'||v_columnas[3]||'@@@'|| ( select per.ci||' '||per.expedicion from orga.tfuncionario f 
                                 inner join segu.tpersona per on per.id_persona=f.id_persona
                                 where f.id_funcionario= v_columnas[1]::integer );
                          
               select p.id_periodo into v_id_periodo_min
                from param.tperiodo p where periodo in (10)
				and id_gestion=v_parametros.id_gestion;

				select p.id_periodo into v_id_periodo
                from param.tperiodo p where periodo in (12)
				and id_gestion=v_parametros.id_gestion; 
           end loop;

			--#158 para planilla de sueldos
            v_cons:='select distinct plani.id_periodo from plani.tplanilla plani
                  		inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                  		inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla
                  		where  tp.codigo in (''PLASUE'') and '|| v_parametros.filtro;
            for v_registros in execute (v_cons) loop
           		v_col:='HORDIA';
                
                select p.id_periodo into v_id_periodo_min
                from param.tperiodo p where id_periodo =v_registros.id_periodo;
				v_id_periodo:=v_id_periodo_min;
            end loop;            
                        
            
            
			select fecha_fin into v_fecha_fin from param.tperiodo where id_periodo=v_id_periodo;
  			select fecha_ini into v_fecha_ini from param.tperiodo where id_periodo=v_id_periodo_min;
                        
			 create temp table tt_detalle_aguin(
             	id_funcionario integer,
            	tipo_documento varchar,
                num_documento varchar,
                expedicion varchar,
                fecha_nacimiento date,
                paterno varchar,
                materno varchar,
                nombre varchar,
                nacionalidad varchar,
                genero varchar,
                jubilado varchar,
                aporta_afp	varchar,
                persona_discapacidad varchar,
                tutor_discapacidad varchar,
                fecha_ingreso date,
                fecha_retiro date,
                motivo_retiro varchar,
                caja_salud varchar,
                nombre_afp varchar,
                nro_afp varchar,
                sucursal varchar,
                clasificacion_laboral varchar,
                cargo varchar,
                modalidad_ctto varchar,
                haber_basico numeric,
                bono_ant numeric,
                bono_prod numeric,
                bono_frontera numeric,
                extra_noct numeric,
                otros numeric,
                meses numeric,
                gestion integer
                --sueldos--#158
                ,tipo_contrato varchar,
                dias_pagados numeric,
                horas_pagadas numeric,
                horas_extra numeric,
                monto_extra	numeric,
                horas_noct numeric,
                monto_noct numeric,
                rc_iva	numeric,
                cps	numeric,
                afp numeric,
                otros_desc	numeric
                ) on commit drop;


      			IF (pxp.f_existe_parametro(p_tabla, 'esquema')) THEN
                       v_esquema = v_parametros.esquema;
                ELSE
                       v_esquema = 'plani';
                END IF;
                if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
                  if(v_parametros.id_tipo_contrato>0) then
                    v_condicion =  ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                  end if;
                end if;

				


                select gestion into v_antiguedad
                from param.tgestion where id_gestion= v_parametros.id_gestion;

         v_cons:='select fun.id_funcionario,fp.id_funcionario_planilla,  (case when per.tipo_documento = ''documento_identidad'' then ''CI''
                      else ''PASAPORTE''
                      end) as tipo_documento, per.ci as num_documento,
         		  per.expedicion, per.fecha_nacimiento,
                  per.apellido_paterno, per.apellido_materno, per.nombre, per.nacionalidad, upper(substring(per.genero,1,1)) as genero,
                   (case when funafp.tipo_jubilado in (''jubilado_65'',''jubilado_55'') then
                ''1''
                else
                ''0'' end) as tipo_jubilado, ''1'' as afpsino, --#162
                   (case when (per.discapacitado= ''no'' OR per.discapacitado= ''NO'') or per.discapacitado is null then
                ''0'' else
                ''1'' end) as discapacidad,
                  
                  (case when '''||v_col||'''=''SPREDIAS2''    or    '''||v_col2||'''=''PREDIAS2'' then  --#ETR-3892
                  	'''||v_cols||'''
                  else   ''0''
                  end)::varchar as discapacidad_tutor,

                  (plani.f_get_fecha_primer_contrato_empleado(fun.id_funcionario, fun.id_funcionario, uofun.fecha_asignacion)) as fecha_ingreso,
                  (case when uofun.fecha_finalizacion between '''||v_fecha_ini||''' and '''||v_fecha_fin||'''
                  and uofun.observaciones_finalizacion not in (''transferencia'',''promocion'')
                  
                   then
                     uofun.fecha_finalizacion
                  else
                    null
                  end)::date as fecha_finalizacion,
                  
                  (case when uofun.fecha_finalizacion is not null and uofun.observaciones_finalizacion = ''fin contrato'' then ''3''
                      when uofun.fecha_finalizacion is not null and uofun.observaciones_finalizacion = ''retiro'' then ''11''
                      when uofun.fecha_finalizacion is not null and uofun.observaciones_finalizacion = ''renuncia'' then ''1''
                      when uofun.fecha_finalizacion is not null and uofun.observaciones_finalizacion = ''rescision'' then ''10''
                      else '''' end) as observaciones_finalizacion,
                  
                  
                  ''2'' as caja_salud,  (case when afp.codigo = ''PREV'' then ''1'' else ''2'' end) as nombre_afp, funafp.nro_afp, ofi.nombre as sucursal,'''' as clasificacion_laboral,car.nombre as cargo,
                   pxp.f_iif(tcon.codigo=''PLA'' ,''1'',''4'') as tipo_contrato,
                   plani.id_periodo, cv.valor
                  
                  from segu.tpersona per
                  inner join orga.tfuncionario fun on fun.id_persona=per.id_persona
                  inner join '||v_esquema||'.tfuncionario_planilla fp on fp.id_funcionario=fun.id_funcionario
                  inner join '||v_esquema||'.tplanilla plani on plani.id_planilla=fp.id_planilla
                  inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario
                  and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial''  --#137
                  inner join plani.tfuncionario_afp funafp on funafp.id_funcionario=fun.id_funcionario and plani.fecha_planilla between
                  funafp.fecha_ini and coalesce(funafp.fecha_fin, plani.fecha_planilla)
                  inner join plani.tafp afp on afp.id_afp=funafp.id_afp
                  inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
                  inner join orga.toficina ofi on ofi.id_oficina=car.id_oficina
                  inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
                  inner join '||v_esquema||'.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla and (cv.codigo_columna='''||v_col||'''  or  cv.codigo_columna='''||v_col2||''' )  --#ETR-3892
                  inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
                  where '||v_parametros.filtro ||v_condicion|| '
                  order by per.apellido_paterno, per.apellido_materno, per.nombre';

                  for v_registros in execute (v_cons) loop
                      insert into tt_detalle_aguin values (
                      	v_registros.id_funcionario,
                      	v_registros.tipo_documento ,
                		v_registros.num_documento ,
                		v_registros.expedicion ,
	                	v_registros.fecha_nacimiento ,
                		v_registros.apellido_paterno ,
                		v_registros.apellido_materno ,
                		v_registros.nombre ,
                		v_registros.nacionalidad ,
                		v_registros.genero ,
                		v_registros.tipo_jubilado ,
                		v_registros.afpsino	,
                		v_registros.discapacidad ,
                		v_registros.discapacidad_tutor ,
                		v_registros.fecha_ingreso ,
                		v_registros.fecha_finalizacion ,
                		v_registros.observaciones_finalizacion ,
                		v_registros.caja_salud ,
                		v_registros.nombre_afp ,
                		v_registros.nro_afp ,
                		v_registros.sucursal ,
                		v_registros.clasificacion_laboral ,
                		v_registros.cargo ,
                		v_registros.tipo_contrato ,
                		0 ,
                		0 ,
                		0 ,
                		0 ,
                		0 ,
                		0 ,
                		v_registros.valor, v_antiguedad
                      );
					
                  	  --#158 -- para setear el valor de horas dia
                      if (v_col='HORDIA') then
                      	update  tt_detalle_aguin
                        set horas_pagadas=v_registros.valor,
                        tipo_contrato='1'
                        where id_funcionario=v_registros.id_funcionario;
                      end if;
                      
                      --#ETR-3892
                      select p.id_periodo into v_id_periodo_min
                      from param.tperiodo p where periodo in (10)
                      and id_gestion=v_parametros.id_gestion;

                      select p.id_periodo into v_id_periodo
                      from param.tperiodo p where periodo in (12)
                      and id_gestion=v_parametros.id_gestion;
                      
                      
                      	
                      --#155
                      v_cols:='HABBAS';
                      if (v_col='SPREDIAS2' ) then
                      	v_tc:=(select c.valor from plani.tcolumna_valor c where c.id_funcionario_planilla=v_registros.id_funcionario_planilla
                        and c.codigo_columna in ('SPREDIAS1'));
                        update tt_detalle_aguin
                        set meses=meses + v_tc
                        where id_funcionario=v_registros.id_funcionario;
                        v_cols:='SUELDOMES';
                      
                      end if;
                      
                      --#ETR-3892: cuando es planilla PLAPRIVIG, existen 2 contratos por separado que se promedian. 
                      --Si el tiempo del segundo contrato es menor a 90 dias, solo se considera el primero, obtenemos los dias del primer contrato.
                      --Si el tiempo es mayor, puede que el primer contrato haya sido con un basico mayor, por lo que en el promedio para la prima, se ha pagado mas de lo q el promedio de su ultimo contrato establece.
                      --Siendo que se paga en base a un promedio, el de su cotizable no puede ser menor a la prima pagada. Adriana Bautista (18.05.2021) dijo haber consultado con el Ministerio de Trabajo para ajustar la diferencia y llevarlo a otros bonos
                      --Por lo que en la obtencion del promedio de cotizables se lo hara en funcion al contrato con menor sueldo_basico (primer contrato)
                      v_meses:=3;                      
                      if (v_col2='PREDIAS2' ) then
                      	v_tc:=(select c.valor from plani.tcolumna_valor c where c.id_funcionario_planilla=v_registros.id_funcionario_planilla
                        	and c.codigo_columna in ('PREDIAS1'));

	                    if (v_registros.valor >= 90) then  --su segundo contrato es mas de 90 dias
                       		update tt_detalle_aguin
                            set meses=v_registros.valor + v_tc
                            where id_funcionario=v_registros.id_funcionario;
                            
                            select p.id_periodo into v_id_periodo_min
                            from param.tperiodo p where periodo in (10)
                            and id_gestion=v_parametros.id_gestion;

                            select p.id_periodo into v_id_periodo
                            from param.tperiodo p where periodo in (12)
                            and id_gestion=v_parametros.id_gestion;
                            --validamos si el promedio de cotizable es menor a su prima pagada == debe tener un contrato previo y obtener los cotizables de su primer contrato
                            
                            if  (round(((select avg(cv.valor) from plani.tcolumna_valor cv inner join plani.tfuncionario_planilla fp
                                      on fp.id_funcionario_planilla=cv.id_funcionario_planilla
                                      inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                      inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo='PLASUE'
                                      and plani.id_periodo  between v_id_periodo_min and v_id_periodo
                                       and cv.codigo_columna='COTIZABLE' and fp.id_funcionario=v_registros.id_funcionario
                                      )/360*(v_registros.valor + v_tc)),2)
                                      >
                                      (select valor from plani.tcolumna_valor where id_funcionario_planilla=v_registros.id_funcionario_planilla and codigo_columna='PRIMA')
                                      ) then
									
                            		 v_fechas_cont:=(select plani.f_obtener_fechas_prima (v_registros.id_funcionario_planilla,'CTTO1'));

    							    
                                		select id_periodo, fecha_fin, fecha_ini, periodo into v_id_periodo , v_fecha_fin, v_fecha_ini, v_i
                                		from param.tperiodo where split_part(v_fechas_cont,'#@@@#',2)::date between fecha_ini and fecha_fin;

                                        if (v_fecha_fin!=split_part(v_fechas_cont,'#@@@#',2)::date) then
                                            select id_periodo, periodo 
                                            into v_id_periodo,v_i from param.tperiodo where fecha_fin=v_fecha_ini-1;
                                           
                                           v_id_periodo_min:=(select id_periodo from param.tperiodo where periodo=v_i-2
                                                            and id_gestion =(select id_gestion from param.tperiodo where id_periodo=v_id_periodo)); 
                                            
                                                
                                        else
                                           
                                           v_id_periodo_min:=(select id_periodo from param.tperiodo where periodo=v_i-2
                                                            and id_gestion =(select id_gestion from param.tperiodo where id_periodo=v_id_periodo)); 
                                          
                                                
                                            
                                        end if;
                        	end if;
                           
                          else --su segundo contrato no supera los 90 dias
                            
                            if (v_tc >0) then --su primer contrato tiene mas de 90 dias: obtenemos los cotizables completos
                                update tt_detalle_aguin
                                set meses= v_tc
                                where id_funcionario=v_registros.id_funcionario;
                                
                                
                                v_fechas_cont:=(select plani.f_obtener_fechas_prima (v_registros.id_funcionario_planilla,'CTTO1'));

    							
                                select id_periodo, fecha_fin, fecha_ini, periodo into v_id_periodo , v_fecha_fin, v_fecha_ini, v_i
                                from param.tperiodo where split_part(v_fechas_cont,'#@@@#',2)::date between fecha_ini and fecha_fin;

                                if (v_fecha_fin!=split_part(v_fechas_cont,'#@@@#',2)::date) then
                                    select id_periodo, periodo 
                                    into v_id_periodo,v_i from param.tperiodo where fecha_fin=v_fecha_ini-1;
                                   
                                   v_id_periodo_min:=(select id_periodo from param.tperiodo where periodo=v_i-2
                                  					and id_gestion =(select id_gestion from param.tperiodo where id_periodo=v_id_periodo)); 
                                    
                                        
                                else
                                   
                                   v_id_periodo_min:=(select id_periodo from param.tperiodo where periodo=v_i-2
                                  					and id_gestion =(select id_gestion from param.tperiodo where id_periodo=v_id_periodo)); 
                                  
                                        
                                    
                                end if;
                                --el dato de su fecha de ingreso la tomamos del primer contrato
                                update tt_detalle_aguin
                                set fecha_ingreso= split_part(v_fechas_cont,'#@@@#',1)::date
                                where id_funcionario=v_registros.id_funcionario;
                                 
                            else -- no tiene mas de 90 dias o no tiene primer contrato. En 2020 caso Wilder Ureña con 60 dias, q recibe prima porq estuvo ausente con "licencia"
                                update tt_detalle_aguin
                                set meses=v_registros.valor + v_tc
                                where id_funcionario=v_registros.id_funcionario;
                                
                                select p.id_periodo into v_id_periodo_min
                                from param.tperiodo p where periodo in (10)
                                and id_gestion=v_parametros.id_gestion;

                                select p.id_periodo into v_id_periodo
                                from param.tperiodo p where periodo in (12)
                                and id_gestion=v_parametros.id_gestion;
                                
                            end if;
                            
                            select count(*) into v_meses
                                        from plani.tfuncionario_planilla fp
                                        inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                        inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo='PLASUE'
                                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                        and cv.codigo_columna in ('SUELDOMES')
                                        where fp.id_funcionario =v_registros.id_funcionario
										and plani.id_periodo between v_id_periodo_min and v_id_periodo;
                            
                        end if;
                        
                        v_cols:='SUELDOMES';
                      
                      end if;
                      
                      if (v_col in ('SPREDIAS2','DIASAGUI') or v_col2='PREDIAS2') then -- se divide entre 3 
                       v_consulta_det:='select round((sum(cv.valor)/'||v_meses||'),2) as valor,
							 			 cv.codigo_columna
                                        from plani.tfuncionario_planilla fp
                                        inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                        inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo=''PLASUE''
                                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                        and cv.codigo_columna in ('''||v_cols||''',''BONANT'',''BONFRONTERA'',''EXTRA'',''DISPONIBILIDAD'')
                                        where fp.id_funcionario ='||v_registros.id_funcionario||'
										and plani.id_periodo between '||v_id_periodo_min||' and '||v_id_periodo||'
                                        group by cv.codigo_columna
                                        ';
                                        
					else -- plasue #158
                        v_cols:='SUELDOMES';
                    	v_consulta_det:='select round((sum(cv.valor)),2) as valor,
							 			 cv.codigo_columna
                                        from plani.tfuncionario_planilla fp
                                        inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                        inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo=''PLASUE''
                                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                        and cv.codigo_columna in ('''||v_cols||''',''BONANT'',''BONFRONTERA'',''EXTRA'',''DISPONIBILIDAD''
                                        ,''HORNORM'',''HOREXT'',''HORNOC'',''NOCTURNO'',''IMPURET'',''CAJSAL'',''AFP_LAB'',''OTRO_DESC''
                                        )
                                        where fp.id_funcionario ='||v_registros.id_funcionario||'
										and plani.id_periodo between '||v_id_periodo_min||' and '||v_id_periodo||'
                                        group by cv.codigo_columna
                                        ';
                                    
                                        
                    end if;
						for v_registros_det in execute (v_consulta_det) loop

                             if (v_col in ('DIASAGUI') and v_registros_det.codigo_columna='HABBAS' and v_registros_det.valor> 0 ) then
                            	update tt_detalle_aguin
                            	set haber_basico=v_registros_det.valor
                            	where id_funcionario=v_registros.id_funcionario;
                            elsif ((v_col in ('SPREDIAS2','HORDIA') or (v_col2='PREDIAS2')) and v_registros_det.codigo_columna='SUELDOMES' and v_registros_det.valor> 0 ) then
                            	update tt_detalle_aguin
                            	set haber_basico=v_registros_det.valor
                            	where id_funcionario=v_registros.id_funcionario;
                            elsif (v_registros_det.codigo_columna='BONANT' and v_registros_det.valor> 0) then
                                update tt_detalle_aguin
                            	set bono_ant=v_registros_det.valor
                            	where id_funcionario=v_registros.id_funcionario;
                            elsif (v_registros_det.codigo_columna='BONFRONTERA' and v_registros_det.valor> 0) then
                                update tt_detalle_aguin
                            	set bono_frontera=v_registros_det.valor
                            	where id_funcionario=v_registros.id_funcionario;
                            elsif (v_registros_det.codigo_columna='EXTRA' and (v_col in ('DIASAGUI','SPREDIAS2') or v_col2='PREDIAS2')) then
                                v_tc:=(select sum(cv.valor)/v_meses as valor
                                        from plani.tfuncionario_planilla fp
                                        inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                        inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo='PLASUE'
                                        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                        and cv.codigo_columna in ('NOCTURNO')
                                        where fp.id_funcionario =v_registros.id_funcionario
										and plani.id_periodo between v_id_periodo_min and v_id_periodo
                                        );
                                update tt_detalle_aguin
                            	set extra_noct=round((v_registros_det.valor+coalesce(v_tc,0)),2)
                            	where id_funcionario=v_registros.id_funcionario;
                            elsif (v_registros_det.codigo_columna='EXTRA' and v_col in ('HORDIA')) then --#158
                            	update tt_detalle_aguin
                                set monto_extra=v_registros_det.valor
                                where id_funcionario=v_registros.id_funcionario;
                            
                            
                            
                            elsif (v_registros_det.codigo_columna='DISPONIBILIDAD') then
                                  if (v_col='DIASAGUI') then
                                		  v_tc:=(select sum(cv.valor)/3 as valor
                                          from plani.tfuncionario_planilla fp
                                          inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                          inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                          inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo='PLASUE'
                                          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                                          and cv.codigo_columna in ('ASIGTRA','ASIGCAJA')
                                          where fp.id_funcionario =v_registros.id_funcionario
                                          and plani.id_periodo between v_id_periodo_min and v_id_periodo
                                          );

                                          update tt_detalle_aguin
                                          set otros=round((v_registros_det.valor+coalesce(v_tc,0)),2)
                                          where id_funcionario=v_registros.id_funcionario;
                                  elsif (v_col='SPREDIAS2' or v_col2='PREDIAS2') then -- planilla de primas, se quiere obtener el complemento para el cotizable
                                  
                                          v_tc:=(select sum(cv.valor)/v_meses as valor
                                          from plani.tfuncionario_planilla fp
                                          inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                          inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                          inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo='PLASUE'
                                          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla

                                          and cv.codigo_columna in ('ASIGNACIONES','INCAP_TEMPORAL','REINTEGRO1')
                                          where fp.id_funcionario =v_registros.id_funcionario
                                          and plani.id_periodo between v_id_periodo_min and v_id_periodo
                                          );

                                          update tt_detalle_aguin
                                          set otros=round((v_registros_det.valor+coalesce(v_tc,0)),2)
                                          where id_funcionario=v_registros.id_funcionario;
                                          
                                          if (v_col2='PREDIAS2') then --#ETR-3892: Si la prima entregada es mayor al promedio que se reporta, llevamos la diferencia a "otros", segun lo indicado por Adriana Bautista que consulto con el Ministerio de Trabajo (18.05.2021)
                                              if ((select valor from plani.tcolumna_valor where id_funcionario_planilla=v_registros.id_funcionario_planilla and codigo_columna='PRIMA')
                                               > round(((select avg(cv.valor) from plani.tcolumna_valor cv inner join plani.tfuncionario_planilla fp
                                                  on fp.id_funcionario_planilla=cv.id_funcionario_planilla
                                                  inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                                  inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo='PLASUE'
                                                  and plani.id_periodo  between v_id_periodo_min and v_id_periodo
                                                   and cv.codigo_columna='COTIZABLE' and fp.id_funcionario=v_registros.id_funcionario
                                                  )/360*(select meses from tt_detalle_aguin  where id_funcionario=v_registros.id_funcionario)),2)
                                                
                                                  
                                                  ) then
                                                  
                                                    update tt_detalle_aguin
                                                    set otros=otros + round(
                                                    ((select valor from plani.tcolumna_valor where id_funcionario_planilla=v_registros.id_funcionario_planilla and codigo_columna='PRIMA')
                                               		- ((select avg(cv.valor) from plani.tcolumna_valor cv inner join plani.tfuncionario_planilla fp
                                                    on fp.id_funcionario_planilla=cv.id_funcionario_planilla
                                                    inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                                    inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo='PLASUE'
                                                    and plani.id_periodo  between v_id_periodo_min and v_id_periodo
                                                     and cv.codigo_columna='COTIZABLE' and fp.id_funcionario=v_registros.id_funcionario
                                                    )/360*meses)) / meses*360
                                                
                                                    
                                                    ,2)
                                                    where id_funcionario=v_registros.id_funcionario;
                                                  
                                                  
                                              end if;
                                          
                                          end if;
                                         
                                          
                                          
                                          
                                  else -- para sueldos HORDIA --#158
                                          v_tc:=(select sum(cv.valor) as valor
                                          from plani.tfuncionario_planilla fp
                                          inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                          inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                          inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo='PLASUE'
                                          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla

                                          and cv.codigo_columna in ('ASIGNACIONES','INCAP_TEMPORAL','REINTEGRO1')
                                          where fp.id_funcionario =v_registros.id_funcionario
                                          and plani.id_periodo between v_id_periodo_min and v_id_periodo
                                          );

                                          update tt_detalle_aguin
                                          set otros=round((v_registros_det.valor+coalesce(v_tc,0)),2)
                                          where id_funcionario=v_registros.id_funcionario;
                                          
                                  end if;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='HORNORM') then
                             	update tt_detalle_aguin
                                set dias_pagados=round((v_registros_det.valor)/(v_registros.valor),2)
                                where id_funcionario=v_registros.id_funcionario;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='HOREXT') then
                            	update tt_detalle_aguin
                                set horas_extra=round(v_registros_det.valor,2)
                                where id_funcionario=v_registros.id_funcionario;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='HORNOC') then
                            	update tt_detalle_aguin
                                set horas_noct=round(v_registros_det.valor,2)
                                where id_funcionario=v_registros.id_funcionario;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='NOCTURNO') then
                            	update tt_detalle_aguin
                                set monto_noct=round(v_registros_det.valor,2)
                                where id_funcionario=v_registros.id_funcionario;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='IMPURET') then
                            	update tt_detalle_aguin
                                set rc_iva=round(v_registros_det.valor,2)
                                where id_funcionario=v_registros.id_funcionario;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='CAJSAL') then
                            	update tt_detalle_aguin
                                set cps=round(v_registros_det.valor,2)
                                where id_funcionario=v_registros.id_funcionario;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='AFP_LAB') then
                            	update tt_detalle_aguin
                                set afp=round(v_registros_det.valor,2)
                                where id_funcionario=v_registros.id_funcionario;
                            elsif (v_col='HORDIA' and v_registros_det.codigo_columna='OTRO_DESC') then
                            
                            	v_tc:=(select sum(cv.valor) as valor
                                          from plani.tfuncionario_planilla fp
                                          inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
                                          inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                          inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla=plani.id_tipo_planilla and tippla.codigo='PLASUE'
                                          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
										  and cv.codigo_columna in ('APSIND', 'CACSELFIJO','CACSELVAR','CACSELPRES','ASIB',
                                          'RETJUD','PRESPER','LICENCIA','DESCANTC'
                                          )
                                          where fp.id_funcionario =v_registros.id_funcionario
                                          and plani.id_periodo between v_id_periodo_min and v_id_periodo
                                          );
				
                                          update tt_detalle_aguin
                                          set otros_desc=round((v_registros_det.valor+coalesce(v_tc,0)),2)
                                          where id_funcionario=v_registros.id_funcionario;
                            end if;
                        end loop;

                  end loop;
                  /*v_consulta:='SELECT *
                       	FROM tt_detalle_aguin
                      ';*/
                      
                      
                  v_consulta:='SELECT id_funcionario ,
            	tipo_documento ,
                num_documento ,
                expedicion ,
                fecha_nacimiento ,
                paterno ,
                materno ,
                nombre ,
                nacionalidad ,
                genero ,
                jubilado ,
                aporta_afp	,
                persona_discapacidad ,
                tutor_discapacidad ,
                fecha_ingreso ,
                fecha_retiro ,
                motivo_retiro ,
                caja_salud ,
                nombre_afp ,
                nro_afp ,
                sucursal ,
                clasificacion_laboral ,
                cargo ,
                modalidad_ctto ,
                haber_basico ,
                bono_ant ,
                bono_prod ,
                bono_frontera ,
                extra_noct ,
                otros ,
                meses ,
                gestion 
              
                ,tipo_contrato ,
                dias_pagados,
                horas_pagadas ,
                horas_extra ,
                monto_extra	,
                horas_noct ,
                monto_noct ,
                rc_iva	,
                cps	,
                afp ,
                otros_desc	FROM tt_detalle_aguin ';    
                  return v_consulta;
       end;
    elsif (p_transaccion='PLA_SALDO_FISCO_SEL') then  --#119
       begin


       select fecha_ini, fecha_fin
       into v_fecha_ini, v_fecha_fin
       from param.tperiodo
       where id_periodo=v_parametros.id_periodo;

    	v_condicion:='';
        if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
          if(v_parametros.id_tipo_contrato>0) then
        	v_condicion = ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
          end if;
        end if;
           v_consulta:='select fun.desc_funcionario2, car.nombre,
            (plani.f_get_fecha_primer_contrato_empleado(fp.id_funcionario, fp.id_funcionario, uofun.fecha_asignacion))
            ,f.fecha_quinquenio,
            uofun.fecha_finalizacion,
            uofun.observaciones_finalizacion,
            (select valor from plani.tcolumna_valor   where id_funcionario_planilla=fp.id_funcionario_planilla
            and codigo_columna=''SUELNETO'' ) as sueldo_neto,
            coalesce((select valor from plani.tcolumna_valor   where id_funcionario_planilla=fp.id_funcionario_planilla
            and codigo_columna=''SALDOSIGPERFIS'' ),0) as saldo_acumulado,
            param.f_get_periodo_literal(plani.id_periodo) as periodo,
             coalesce((select valor from plani.tcolumna_valor   where id_funcionario_planilla=fp.id_funcionario_planilla
            and codigo_columna=''SALDODEPSIGPER'' ),0) as saldo_dependiente
            from plani.tplanilla plani
            inner join plani.tfuncionario_planilla fp on fp.id_planilla=plani.id_planilla
            inner join orga.vfuncionario fun on fun.id_funcionario=fp.id_funcionario
            inner join orga.tfuncionario f on f.id_funcionario=fun.id_funcionario
            --inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
            inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario
            and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial''  --#137
            inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
            inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato
            where ';
             v_consulta:=v_consulta||v_parametros.filtro;
              v_consulta:=v_consulta || v_condicion || ' order by fun.desc_funcionario2';
        	  return v_consulta;
    	end;

     elsif (p_transaccion='PLA_PRIMA_SEL') then  --#125
       begin

    		v_condicion:='';
            if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
              if(v_parametros.id_tipo_contrato>0) then
                v_condicion = ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
              end if;
            end if;

            v_filtro:=''; v_col:=''; v_cols:='';
            if pxp.f_existe_parametro(p_tabla , 'id_tipo_planilla')then
              if exists (select 1 from plani.ttipo_planilla where id_tipo_planilla=v_parametros.id_tipo_planilla
              and codigo in ('PLAPRIVIG','BONOVIG','SPLAPRIVIG')  --#145
              ) then --#146
                v_filtro = ' inner join plani.tobligacion obli on obli.id_planilla=plani.id_planilla
                  	  		 inner join plani.tdetalle_transferencia detra on detra.id_obligacion=obli.id_obligacion
					  		 inner join param.tinstitucion inst on inst.id_institucion=detra.id_institucion and detra.id_funcionario=fun.id_funcionario
                      	';
                v_col:= '(nivel.oficina||''*''||coalesce(inst.nombre,''''))';

              else
              	v_col:= '(nivel.oficina||''*'')';

              end if;
            end if;


            v_ordenar:='';
            if pxp.f_existe_parametro(p_tabla , 'id_tipo_planilla')then
              if exists (select 1 from plani.ttipo_planilla where id_tipo_planilla=v_parametros.id_tipo_planilla
              and codigo in ('PLAPRIVIG','PRINOVIG')
              ) then
             v_cols:=' and colval.codigo_columna in (''PREDIAS1'',''PREDIAS2'',''PREPROME1'',''PREPROME2'',''PREPRICOT21'',''PREPRICOT22'',''PREPRICOT23'',''PRIMA'',
                        ''IMPDET'',''IMPOFAC'',''LIQPAG'')';
            elseif (select 1 from plani.ttipo_planilla where id_tipo_planilla=v_parametros.id_tipo_planilla
              			and codigo in ('PLAPREPRI')) then--#135
            		v_cols:=' and colval.codigo_columna in (''PREDIAS1'',''PREDIAS2'',''PREPROME1'',''PREPROME2'',''PREPRICOT21'',''PREPRICOT22'',''PREPRICOT23'',''PREPRIMA''
                        )';
            		v_ordenar:='(plani.f_es_funcionario_vigente (fp.id_funcionario,plani.fecha_planilla)),';
                    if (v_parametros.estado='activo') then
                      v_condicion:=v_condicion || ' and (plani.f_es_funcionario_vigente (fp.id_funcionario,plani.fecha_planilla))=true
                      --and fp.id_funcionario=551

                      ';
                    end if;
                    --#145
            elseif (select 1 from plani.ttipo_planilla where id_tipo_planilla=v_parametros.id_tipo_planilla
              			and codigo in ('SPLAPREPRI')) then--#135
            		v_cols:=' and colval.codigo_columna in (''SPREDIAS1'',''SPREDIAS2'',''PREPROME1'',''SPREPRICOT1'',''SPREPRICOT2'',''SPREPRICOT3'',''PREPRIMA''
                        )';
            		v_ordenar:='(plani.f_es_funcionario_vigente (fp.id_funcionario,plani.fecha_planilla)),';
                    if (v_parametros.estado='activo') then
                      v_condicion:=v_condicion || ' and (plani.f_es_funcionario_vigente (fp.id_funcionario,plani.fecha_planilla))=true
                      --and fp.id_funcionario=551

                      ';
                    elsif (v_parametros.estado='retirado') then --#ETR-2467
                     	v_condicion:=v_condicion || ' and (plani.f_es_funcionario_vigente (fp.id_funcionario,plani.fecha_planilla))=false  ';
                    end if;
             elseif (select 1 from plani.ttipo_planilla where id_tipo_planilla=v_parametros.id_tipo_planilla
              			and codigo in ('SPLAPRIVIG','SPRINOVIG')) then--#145  --#151

            		 v_cols:=' and colval.codigo_columna in (''SPREDIAS1'',''SPREDIAS2'',''PREPROME'',''SPREPRICOT1'',''SPREPRICOT2'',''SPREPRICOT3'',''PRIMA'',
                        ''IMPDET'',''IMPOFAC'',''LIQPAG'')';

            else --#124
             v_cols:=' and colval.codigo_columna in (''PREDIAS2'',''PREPROME2'',''BONO'',
                        ''IMPDET'',''IMPOFAC'',''LIQPAG'',''PORCBONO'',''APCAJ'',''CTOTAL'',''OTDESC'')'; --#169
            end if;
       end if;
            v_consulta:='select  fun.id_funcionario, fun.desc_funcionario2  as desc_funcionario2,
           			    trim(both ''FUNODTPR'' from fun.codigo) as codigo,
                      	nivel.id_oficina,'||v_col||' as desc_oficina,
                      --	fp.id_funcionario_planilla,
                      	tcon.nombre
					  	, colval.codigo_columna, colval.valor, plani.f_obtener_fechas_prima(fp.id_funcionario_planilla,''CTTO1'') as ctto1,
                      	plani.f_obtener_fechas_prima(fp.id_funcionario_planilla,''CTTO2'') as ctto2,
                      	car.nombre, ges.gestion, (select observaciones_finalizacion from orga.tuo_funcionario
                        where id_uo_funcionario=
                         fp.id_uo_funcionario) as obs_fin,
                         (plani.f_es_funcionario_vigente (fp.id_funcionario,plani.fecha_planilla)) as es_vigente --#135
                         ,pxp.f_get_dias_mes_30 ( plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario, fp.id_funcionario,uof.fecha_asignacion),coalesce(uof.fecha_finalizacion,plani.fecha_planilla) )::integer as total_dias --#ETR-3119
                      	from plani.vorden_planilla  nivel
                      	inner join plani.tfuncionario_planilla fp on
                  		fp.id_funcionario_planilla=nivel.id_funcionario_planilla
                      	inner join orga.vfuncionario fun on fun.id_funcionario = nivel.id_funcionario
                      	inner join orga.tcargo car on car.id_cargo=nivel.id_cargo
                      	inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                        inner join param.tgestion ges on ges.id_gestion=plani.id_gestion
                      	inner join plani.tcolumna_valor colval on  colval.id_funcionario_planilla = fp.id_funcionario_planilla
                    	inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and nivel.id_oficina=car.id_oficina
                        inner join orga.tuo_funcionario uof on uof.id_uo_funcionario=fp.id_uo_funcionario
                      	'||v_filtro||'
                      	where ';
              	v_consulta:=v_consulta||v_parametros.filtro;
            	v_consulta:=v_consulta || v_condicion || v_cols || '

                        order by '||v_ordenar||' nivel.orden_oficina,nivel.id_oficina,'||v_col||', fun.desc_funcionario2
                        , colval.codigo_columna';
      raise notice 'aaa%',v_consulta;
        	  return v_consulta;
    	end;
    elsif (p_transaccion='PLA_REPPREVIS_SEL') THEN --#133
        BEGIN
        	 if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
              if(v_parametros.id_tipo_contrato>0) then
                v_condicion = ' and tcon.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
              end if;
             end if;
        	 v_consulta:='select ofi.nombre as oficina,sum(cv.valor)  as monto_pagar,
						  ''''	::text as periodo,
						  ins.nombre as banco,''Banco'' as tipo_pago,
                          tcon.nombre as tipo_contrato,
						  (select count(*) from plani.tfuncionario_planilla ffp
          				inner join orga.tuo_funcionario uuo on uuo.id_uo_funcionario=ffp.id_uo_funcionario
                          and uuo.estado_reg!=''inactivo''	and uuo.tipo=''oficial''  --#137
                          inner join orga.tcargo c on c.id_cargo=uuo.id_cargo
                          and ffp.id_funcionario_planilla=ffp.id_funcionario_planilla
                          and ffp.id_planilla=plani.id_planilla
                          and c.id_tipo_contrato=tcon.id_tipo_contrato) as total
						  from orga.toficina ofi
						  inner join orga.tcargo c on c.id_oficina=ofi.id_oficina
						  inner join orga.tuo_funcionario uofun on uofun.id_cargo=c.id_cargo
                          and uofun.estado_reg!=''inactivo'' and uofun.tipo=''oficial''  --#137
						  inner join plani.tfuncionario_planilla fp on fp.id_uo_funcionario= uofun.id_uo_funcionario
						  inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
						  inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						  inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=c.id_tipo_contrato
						  inner join plani.treporte_columna rc on rc.id_reporte=repo.id_reporte
						  inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
						  inner join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario=fp.id_funcionario
						  and fcb.nro_cuenta is not null and trim(both '' '' from nro_cuenta) != ''''
                          and fcb.fecha_fin is null
						  inner join param.tinstitucion ins on ins.id_institucion=fcb.id_institucion
						  and rc.codigo_columna=cv.codigo_columna
                          where ';

             v_consulta:=v_consulta||v_parametros.filtro||v_condicion;
             v_consulta:=v_consulta||'group by ofi.nombre, ins.nombre, ofi.orden, tcon.nombre, plani.id_planilla,tcon.id_tipo_contrato
						 order by ofi.orden
						 ';

             return v_consulta;
        END;
    elsif (p_transaccion='PLA_INGEGR_SEL') THEN --#144
        BEGIN
        	v_consulta:='select fun.id_funcionario, fun.desc_funcionario2,
btrim(fun.codigo, ''FUNODTPR'' ), fun.ci, repcol.titulo_reporte_superior, repcol.titulo_reporte_inferior,
(plani.f_get_fecha_primer_contrato_empleado(
                fp.id_uo_funcionario, fp.id_funcionario, uofun.fecha_asignacion)
                )
, esc.codigo, (select afp.nombre from plani.tfuncionario_afp fafp inner join plani.tafp afp on afp.id_afp=fafp.id_afp
and fafp.id_funcionario=fun.id_funcionario and plani.fecha_planilla between fafp.fecha_ini and coalesce(fafp.fecha_fin,plani.fecha_planilla)
), tc.codigo, cv.valor, tc.tipo_movimiento, car.nombre as nombre_cargo,


(select fafp.tipo_jubilado from plani.tfuncionario_afp fafp inner join plani.tafp afp on afp.id_afp=fafp.id_afp
and fafp.id_funcionario=fun.id_funcionario and plani.fecha_planilla between fafp.fecha_ini and coalesce(fafp.fecha_fin,plani.fecha_planilla)
) as jubilado,
(param.f_get_periodo_literal(plani.id_periodo)) as periodo
						from orga.vfuncionario fun
						inner join plani.tfuncionario_planilla fp on fp.id_funcionario=fun.id_funcionario
						inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario=fp.id_uo_funcionario
						inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
						inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
						inner join orga.tescala_salarial esc on esc.id_escala_salarial=car.id_escala_salarial
						inner join plani.ttipo_columna tc on tc.id_tipo_planilla=plani.id_tipo_planilla
						inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
						inner join plani.treporte repo on repo.id_tipo_planilla=plani.id_tipo_planilla
						inner join plani.treporte_columna repcol on repcol.id_reporte=repo.id_reporte and repcol.codigo_columna=tc.codigo
						and cv.id_tipo_columna=tc.id_tipo_columna
						and tc.tipo_movimiento is not null
						where ';
          	v_consulta:=v_consulta||v_parametros.filtro;




             v_consulta:=v_consulta||'
						 order by repcol.orden
						 ';
         	return v_consulta;
        END;
        
        
elsif (p_transaccion='PLA_HORTRA1_SEL') THEN --#159
        BEGIN
        v_condicion:='';
        if(v_parametros.id_tipo_contrato>0) then
                v_condicion = ' and tc.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
              end if;
        
        	v_consulta:='select	 fun.id_funcionario,
            					(pxp.f_iif( pe.periodo<10,''0''||pe.periodo, pe.periodo||'''' )|| g.gestion) ::varchar as periodo,
                                trim(both ''FUNODTPR'' from  fun.codigo ) as codigo,
                                fun.desc_funcionario2 as desc_funcionario, 
                                smtd.id_mes_trabajo_det,smtd.dia, smtd.total_comp, 
                                smtd.total_normal,smtd.extra_autorizada as total_extra, smtd.total_nocturna,
                                cc.codigo_tcc,
                                pxp.f_obtener_literal_periodo(pe.periodo,0) as periodo_lite
                                from asis.tmes_trabajo smt
                                inner join orga.vfuncionario fun on fun.id_funcionario = smt.id_funcionario  
								inner join orga.tuo_funcionario uofun on uofun.id_funcionario=fun.id_funcionario
                                inner join orga.tcargo car on car.id_cargo=uofun.id_cargo
                                inner join orga.ttipo_contrato tc on tc.id_tipo_contrato=car.id_tipo_contrato
                                inner join plani.tplanilla plani on plani.id_periodo=smt.id_periodo
                                inner join plani.tfuncionario_planilla fp on fp.id_planilla=plani.id_planilla
                                and fp.id_uo_funcionario=uofun.id_uo_funcionario
                                inner join param.tperiodo pe on pe.id_periodo = smt.id_periodo
                                inner join param.tgestion g on g.id_gestion = smt.id_gestion
                                inner join asis.tmes_trabajo_det smtd on smtd.id_mes_trabajo=smt.id_mes_trabajo
                                inner join param.vcentro_costo cc on cc.id_centro_costo = smtd.id_centro_costo
                                where '; --smt.id_periodo=41 
                                --and tc.id_tipo_contrato=2
                                
          	v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||v_condicion;
			v_consulta:=v_consulta||' order by cc.codigo_tcc, fun.desc_funcionario2, smtd.id_mes_trabajo_det ';


         	return v_consulta;
        END;
elsif (p_transaccion='PLA_HORTRATOT_SEL') THEN --#ETR-1712
        BEGIN
        v_condicion:='';
        if(v_parametros.id_tipo_contrato>0) then
                v_condicion = ' and tc.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
              end if;
        
        	v_consulta:='select nivel.id_funcionario,  trim(both ''FUNODTPR'' from  fun.codigo ) as codigo,nivel.desc_funcionario2, nivel.nombre_uo_centro::varchar,
                        0::numeric as tot_comp,
                        tot.total_normal, 
                         tot.extra_autorizada,  --#ETR-2780 
                         tot.total_nocturna,
                         0::numeric as total_extra_vac,
                         0::numeric as total_noctura_vac,
                         pxp.f_obtener_literal_periodo(per.periodo,0)::varchar as periodo_lite
                         ,(SELECT gestion FROM param.tgestion where id_gestion=per.id_gestion) as gestion
                        from asis.vtotales_horas tot
                        inner join plani.tfuncionario_planilla fp on fp.id_funcionario=tot.id_funcionario --and tot.id_planilla=fp.id_planilla
                        inner join orga.tuo_funcionario uof on uof.id_uo_funcionario=fp.id_uo_funcionario
                        inner join orga.tcargo c on c.id_cargo=uof.id_cargo
                        inner join orga.ttipo_contrato tc on tc.id_tipo_contrato=c.id_tipo_contrato
                        inner join plani.vorden_planilla nivel on nivel.id_funcionario_planilla=fp.id_funcionario_planilla
                        and nivel.id_tipo_contrato=tc.id_tipo_contrato and nivel.id_cargo=c.id_cargo
                        inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla 
                        inner join param.tperiodo per on per.id_periodo=plani.id_periodo
                        inner join orga.vfuncionario fun on fun.id_funcionario=tot.id_funcionario
                        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=plani.id_tipo_planilla and tp.codigo=''PLASUE''
                        where nivel.id_periodo=tot.id_periodo and ';


          	v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||v_condicion;
			v_consulta:=v_consulta||' order by nivel.ruta,nivel.prioridad,nivel.desc_funcionario2 ';


         	return v_consulta;
        END;
    elsif (p_transaccion='PLA_PLANRECPS_SEL') THEN --#ETR-4150
        BEGIN
        	create temp table tt_reicps(
              id_funcionario integer,
              ci varchar,
              desc_funcionario2 text,
              cargo varchar,
              vigente	varchar,
              fecha_ingreso	date,
              genero	varchar,
              gestion integer,
              haber_basico numeric,
              haber_basico_inc	numeric,
              bant_ene numeric,
              bant_feb	numeric,
              bant_mar	numeric,
              bant_abr	numeric,
              total_retroactivo	numeric,
              afp numeric,
              rc_iva numeric,
              otros numeric,
              total_desc numeric,
              liqpag numeric) on commit drop;
        
           v_filtro:=' ';
            
           if (pxp.f_existe_parametro(p_tabla, 'estado_funcionario')) then
                if(v_parametros.estado_funcionario='activo') then
                	v_filtro:=v_filtro||' and plani.f_es_funcionario_vigente(fp.id_funcionario, plani.fecha_planilla) is true';
                elsif (v_parametros.estado_funcionario='retirado') then
                	v_filtro:=v_filtro||' and plani.f_es_funcionario_vigente(fp.id_funcionario, plani.fecha_planilla) is false';                
                end if;
           end if;
           
           if pxp.f_existe_parametro(p_tabla , 'consolidar')then
                if (v_parametros.consolidar='si') then
                	v_filtro:=v_filtro||' and plani.id_periodo<='||v_parametros.id_periodo; 
                else
                	v_filtro:=v_filtro||' and plani.id_periodo='||v_parametros.id_periodo; 
                end if;
           end if;
           
           
           if pxp.f_existe_parametro(p_tabla , 'id_tipo_contrato')then
              if(v_parametros.id_tipo_contrato>0) then
                v_filtro = v_filtro|| ' and plani.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
              end if;
           end if;
           
           
           v_consulta:='select distinct fp.id_funcionario,f.ci, f.desc_funcionario2,  f.genero, orga.f_get_cargo_x_funcionario_str(fp.id_funcionario, plani.fecha_planilla,''oficial'') as cargo,
								plani.f_es_funcionario_vigente(fp.id_funcionario, plani.fecha_planilla) as vigente,
								plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario,fp.id_funcionario,
              					(select fecha_asignacion from orga.tuo_funcionario where id_uo_funcionario=fp.id_uo_funcionario)) as fecha_ingreso,
              					 (select gestion from param.tgestion where id_gestion=plani.id_gestion) as gestion
                                from plani.tfuncionario_planilla fp
                                inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                                inner join plani.vrep_funcionario f on f.id_funcionario=fp.id_funcionario
                                inner join param.tperiodo per on per.id_periodo=plani.id_periodo

								where ' || v_parametros.filtro || v_filtro; 

           for v_registros in execute(v_consulta
                                 ) loop
                                
                insert into tt_reicps values (v_registros.id_funcionario, v_registros.ci, v_registros.desc_funcionario2,
                v_registros.cargo, v_registros.vigente, v_registros.fecha_ingreso,  v_registros.genero, v_registros.gestion,
                0,0,0,0,0,0,0,0,0,0,0,0);
                               
                v_afp_sso:=0;
                v_afp_rcom:=0;
				v_afp_cadm:=0;
				v_afp_apnal:=0; --iva
				v_afp_apsol:=0;
	            v_totdesc:=0;
                v_liquido:=0;
                
                v_estado:='select cv.valor 
                from plani.tcolumna_valor cv
				inner join plani.tfuncionario_planilla fp on fp.id_funcionario_planilla=cv.id_funcionario_planilla
				inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
				inner join param.tperiodo per on per.id_periodo=p.id_periodo
                inner join param.tgestion ges on ges.id_gestion=p.id_gestion
				inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
				where fp.id_funcionario='||v_registros.id_funcionario||' and  
                ges.gestion=(select gestion-1 from param.tgestion where id_gestion='||v_parametros.id_gestion||') 
                and per.periodo=12 and tp.codigo=''PLASUE'' and p.id_tipo_contrato='||v_parametros.id_tipo_contrato||'
				and cv.codigo_columna=''HABBAS'' ';
               
              
                for v_registros_det in execute (v_estado) loop
                   update tt_reicps set haber_basico=v_registros_det.valor,
                   haber_basico_inc=v_registros_det.valor
                   where id_funcionario=v_registros.id_funcionario;
                end loop;

                v_estado:='select per.periodo, cv.codigo_columna, cv.valor, fp.id_funcionario from plani.tfuncionario_planilla fp
                          inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla=fp.id_funcionario_planilla
                          inner join plani.tplanilla plani on plani.id_planilla=fp.id_planilla
                          inner join param.tperiodo per on per.id_periodo=plani.id_periodo
                          where '||v_parametros.filtro||v_filtro||' 

                          and cv.codigo_columna in (''PRMBONOANTG'',''PRMAFP_LAB'',''PRMAFP_PAT'',''PRMIMPRCIVA'',''PRMTOT_DESC'',''PRMLIQPAG'')
                    	  and fp.id_funcionario='||v_registros.id_funcionario||'
                          order by fp.id_funcionario,cv.codigo_columna, per.periodo';

				for v_registros_det in execute ( v_estado
                          
                ) loop
                 	 if (v_registros_det.codigo_columna='PRMBONOANTG') then
                         if (v_registros_det.periodo=1 ) then
                            update tt_reicps set bant_ene=v_registros_det.valor
                            where id_funcionario=v_registros.id_funcionario;
                         elsif (v_registros_det.periodo=2) then
                            update tt_reicps set bant_feb=v_registros_det.valor
                            where id_funcionario=v_registros.id_funcionario;
                         elsif (v_registros_det.periodo=3) then
                            update tt_reicps set bant_mar=v_registros_det.valor
                            where id_funcionario=v_registros.id_funcionario;
                         elsif (v_registros_det.periodo=4) then                 
                            update tt_reicps set bant_abr=v_registros_det.valor
                            where id_funcionario=v_registros.id_funcionario;  
                            
                            update tt_reicps set total_retroactivo= (v_afp_sso+ v_registros_det.valor)
                            where id_funcionario=v_registros.id_funcionario;  
                         end if;    
                         v_afp_sso:=v_afp_sso+ v_registros_det.valor;  --total_bono_ant
                     else
                        if (v_registros_det.codigo_columna='PRMAFP_LAB') then
                           v_afp_rcom:=coalesce(v_registros_det.valor,0);  --AFP_LAB
                        elsif (v_registros_det.codigo_columna='PRMAFP_PAT') then
                        	v_afp_cadm:= coalesce(v_registros_det.valor,0); --AFP_PAT
                        elsif (v_registros_det.codigo_columna='PRMIMPRCIVA') then
                        	v_afp_apnal:= coalesce(v_registros_det.valor,0); --iva
                        elsif (v_registros_det.codigo_columna='PRMTOT_DESC') then
                        	v_totdesc:=coalesce(v_registros_det.valor,0);
                        elsif (v_registros_det.codigo_columna='PRMLIQPAG') then
	                        v_liquido:=coalesce(v_registros_det.valor,0);
                        end if;
                        
                     end if;                  
                     
                     --if (v_registros_det.periodo=4) then
                        if (v_registros_det.codigo_columna='PRMAFP_LAB') then
                          	update tt_reicps set afp=(afp+ (coalesce(v_afp_rcom,0)+ coalesce(v_afp_cadm,0)))
                          	where id_funcionario=v_registros.id_funcionario;  
                      
                        elsif (v_registros_det.codigo_columna='PRMIMPRCIVA') then
                        	update tt_reicps set rc_iva=rc_iva+ coalesce(v_afp_apnal,0)
                            where id_funcionario=v_registros.id_funcionario;  
                        elsif (v_registros_det.codigo_columna='PRMTOT_DESC') then
                        	update tt_reicps set total_desc=total_desc+coalesce(v_totdesc,0)
                            where id_funcionario=v_registros.id_funcionario;  
                        elsif (v_registros_det.codigo_columna='PRMLIQPAG') then
	                        update tt_reicps set liqpag=liqpag+coalesce(v_liquido,0)
                            where id_funcionario=v_registros.id_funcionario;  
                        end if;
                       
                     
                     
                   --  end if;
                
				
                    
                end loop;
                
           
           end loop;
           
           
           v_consulta:='select id_funcionario ,
              ci ,
              desc_funcionario2 ,
              cargo ,
              fecha_ingreso	,
              genero	,
              gestion ,
              haber_basico ,
              haber_basico_inc	,
              bant_ene ,
              bant_feb	,
              bant_mar	,
              bant_abr	,
              total_retroactivo	,
              afp ,
              rc_iva ,
              otros ,
              total_desc ,
              liqpag from tt_reicps order by desc_funcionario2 ';
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
$function$
;