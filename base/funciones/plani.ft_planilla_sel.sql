CREATE OR REPLACE FUNCTION plani.ft_planilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_planilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tplanilla'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2014 16:11:04
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
	v_filtro			varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_planilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PLANI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	if(p_transaccion='PLA_PLANI_SEL')then
     				
    	begin
    		IF p_administrador !=1 THEN
    			v_filtro = ' plani.id_depto IN (' ||(case when (param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA') = '') 
                									then  '-1'
                                                    else param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA')
                                                    end) || ') and ';
    		else
    			v_filtro = '';
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
						tippla.codigo,
						uo.nombre_unidad,
						plani.id_depto,
						depto.nombre,
						tippla.calculo_horas,
						pxp.f_get_variable_global(''plani_tiene_presupuestos''),
						pxp.f_get_variable_global(''plani_tiene_costos''),
						plani.fecha_planilla	
						from plani.tplanilla plani
						inner join segu.tusuario usu1 on usu1.id_usuario = plani.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plani.id_usuario_mod
						inner join param.tgestion ges on ges.id_gestion = plani.id_gestion
						left join param.tperiodo per on per.id_periodo = plani.id_periodo
						inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla = plani.id_tipo_planilla
						left join orga.tuo uo on uo.id_uo = plani.id_uo
						inner join param.tdepto depto on depto.id_depto = plani.id_depto
				        where  ' || v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PLANI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:04
	***********************************/

	elsif(p_transaccion='PLA_PLANI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			
			IF p_administrador !=1 THEN
    			v_filtro = ' plani.id_depto IN (' ||(case when (param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA') = '') 
                									then  '-1'
                                                    else param.f_get_lista_deptos_x_usuario(p_id_usuario, 'ORGA')
                                                    end) || ') and ';
    		else
    			v_filtro = '';
    		END IF;
    		
    		
			v_consulta:='select count(id_planilla)
					    from plani.tplanilla plani
					    inner join segu.tusuario usu1 on usu1.id_usuario = plani.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plani.id_usuario_mod
						inner join param.tgestion ges on ges.id_gestion = plani.id_gestion
						left join param.tperiodo per on per.id_periodo = plani.id_periodo
						inner join plani.ttipo_planilla tippla on tippla.id_tipo_planilla = plani.id_tipo_planilla
						left join orga.tuo uo on uo.id_uo = plani.id_uo
					    where ' || v_filtro;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        /*********************************    
        #TRANSACCION:  'PLA_PLANI_CONT'
        #DESCRIPCION:	Conteo de registros
        #AUTOR:		admin	
        #FECHA:		22-01-2014 16:11:04
        ***********************************/

	elsif(p_transaccion='PLA_REPMINTRASUE_SEL')then

		begin
            v_consulta = 'with empleados as (
                select
                uo.prioridad,
                uo.id_uo,
                (row_number() over ())::integer as fila,
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
                (case when genero= ''VARON'' then
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
                lug.nombre as lugar
                from plani.tplanilla p
                inner join param.tperiodo per on per.id_periodo = p.id_periodo
                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                inner join orga.tfuncionario fun on fun.id_funcionario = fp.id_funcionario
                inner join segu.tpersona perso on perso.id_persona = fun.id_persona
                inner join orga.tuo_funcionario uofun on uofun.id_uo_funcionario = fp.id_uo_funcionario
                inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                left join param.tlugar lug on lug.id_lugar = ofi.id_lugar
                inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL, NULL)
                inner join plani.tfuncionario_afp fafp on fafp.id_funcionario_afp = fp.id_afp
                inner join plani.tafp afp on afp.id_afp = fafp.id_afp
                where tp.codigo = ''PLASUE'' and per.id_periodo = ' || v_parametros.id_periodo || '
                order by uo.prioridad, uo.id_uo, perso.apellido_paterno,perso.apellido_materno,perso.nombre
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
                where cv.codigo_columna in (''HORNORM'',''SUELDOBA'',''BONANT'',''BONFRONTERA'',''REINBANT'',''COTIZABLE'',''AFP_LAB'',''IMPURET'',''OTRO_DESC'',''TOT_DESC'',''LIQPAG'',''CAJSAL'')
                order by emp.fila,tc.orden';
                
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