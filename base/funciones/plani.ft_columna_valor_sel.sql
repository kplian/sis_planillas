CREATE OR REPLACE FUNCTION "plani"."ft_columna_valor_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_columna_valor_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tcolumna_valor'
 AUTOR: 		 (admin)
 FECHA:	        27-01-2014 04:53:54
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

	v_nombre_funcion = 'plani.ft_columna_valor_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_COLVAL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		27-01-2014 04:53:54
	***********************************/

	if(p_transaccion='PLA_COLVAL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						colval.id_columna_valor,
						colval.id_tipo_columna,
						colval.id_funcionario_planilla,
						colval.codigo_columna,
						colval.estado_reg,
						colval.valor,
						colval.valor_generado,
						colval.formula,
						colval.fecha_reg,
						colval.id_usuario_reg,
						colval.fecha_mod,
						colval.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tipcol.nombre,
						pla.estado
						from plani.tcolumna_valor colval
						inner join segu.tusuario usu1 on usu1.id_usuario = colval.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = colval.id_usuario_mod
						inner join plani.ttipo_columna tipcol on tipcol.id_tipo_columna = colval.id_tipo_columna
						inner join plani.tfuncionario_planilla funpla on funpla.id_funcionario_planilla = colval.id_funcionario_planilla
						inner join plani.tplanilla pla on pla.id_planilla = funpla.id_planilla
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_COLVAL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		27-01-2014 04:53:54
	***********************************/

	elsif(p_transaccion='PLA_COLVAL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_columna_valor)
					    from plani.tcolumna_valor colval
					    inner join segu.tusuario usu1 on usu1.id_usuario = colval.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = colval.id_usuario_mod
						inner join plani.ttipo_columna tipcol on tipcol.id_tipo_columna = colval.id_tipo_columna
						inner join plani.tfuncionario_planilla funpla on funpla.id_funcionario_planilla = colval.id_funcionario_planilla
						inner join plani.tplanilla pla on pla.id_planilla = funpla.id_planilla
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
ALTER FUNCTION "plani"."ft_columna_valor_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
