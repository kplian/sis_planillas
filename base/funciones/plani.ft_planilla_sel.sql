CREATE OR REPLACE FUNCTION "plani"."ft_planilla_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
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
    			v_filtro = ' plani.id_depto IN (' || coalesce (param.f_get_lista_deptos_x_usuario(p_id_usuario, PLANI),'-1')|| ') and ';
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
						pxp.f_get_variable_global(''plani_tiene_costos'')	
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
    			v_filtro = ' plani.id_depto IN (' || coalesce (param.f_get_lista_deptos_x_usuario(p_id_usuario, PLANI),'-1')|| ') and ';
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "plani"."ft_planilla_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
