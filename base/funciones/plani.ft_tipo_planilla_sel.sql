CREATE OR REPLACE FUNCTION "plani"."ft_tipo_planilla_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_planilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_planilla'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 15:36:53
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
			    
BEGIN

	v_nombre_funcion = 'plani.ft_tipo_planilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_TIPPLA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:53
	***********************************/

	if(p_transaccion='PLA_TIPPLA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tippla.id_tipo_planilla,
						tippla.id_proceso_macro,
						tippla.tipo_presu_cc,
						tippla.funcion_obtener_empleados,
						tippla.estado_reg,
						tippla.nombre,
						tippla.codigo,
						tippla.fecha_reg,
						tippla.id_usuario_reg,
						tippla.id_usuario_mod,
						tippla.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						pm.nombre,
						tippla.funcion_validacion_nuevo_empleado,
						tippla.calculo_horas,
						tippla.periodicidad,
						tippla.funcion_calculo_horas,
						tippla.recalcular_desde
						from plani.ttipo_planilla tippla
						inner join segu.tusuario usu1 on usu1.id_usuario = tippla.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tippla.id_usuario_mod
						inner join wf.tproceso_macro  pm on pm.id_proceso_macro = tippla.id_proceso_macro
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPPLA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:53
	***********************************/

	elsif(p_transaccion='PLA_TIPPLA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_planilla)
					    from plani.ttipo_planilla tippla
					    inner join segu.tusuario usu1 on usu1.id_usuario = tippla.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tippla.id_usuario_mod
						inner join wf.tproceso_macro  pm on pm.id_proceso_macro = tippla.id_proceso_macro
					    where ';
			
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
ALTER FUNCTION "plani"."ft_tipo_planilla_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
