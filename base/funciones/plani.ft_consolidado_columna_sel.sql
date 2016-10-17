CREATE OR REPLACE FUNCTION "plani"."ft_consolidado_columna_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_consolidado_columna_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tconsolidado_columna'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 19:04:10
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

	v_nombre_funcion = 'plani.ft_consolidado_columna_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_CONCOL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	if(p_transaccion='PLA_CONCOL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						concol.id_consolidado_columna,
						concol.id_auxiliar,
						concol.id_consolidado,
						concol.id_cuenta,
						concol.id_partida,
						concol.id_tipo_columna,
						concol.valor,
						concol.codigo_columna,
						concol.tipo_contrato,
						concol.valor_ejecutado,
						concol.estado_reg,
						concol.id_usuario_ai,
						concol.usuario_ai,
						concol.fecha_reg,
						concol.id_usuario_reg,
						concol.id_usuario_mod,
						concol.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tipcol.nombre,
						par.codigo,
						par.nombre_partida	
						from plani.tconsolidado_columna concol
						inner join plani.ttipo_columna tipcol
							on tipcol.id_tipo_columna = concol.id_tipo_columna
						left join pre.tpartida par
							on par.id_partida = concol.id_partida
						inner join segu.tusuario usu1 on usu1.id_usuario = concol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = concol.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_CONCOL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	elsif(p_transaccion='PLA_CONCOL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_consolidado_columna)
					    from plani.tconsolidado_columna concol
					    inner join plani.ttipo_columna tipcol
							on tipcol.id_tipo_columna = concol.id_tipo_columna
						left join pre.tpartida par
							on par.id_partida = concol.id_partida
					    inner join segu.tusuario usu1 on usu1.id_usuario = concol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = concol.id_usuario_mod
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
ALTER FUNCTION "plani"."ft_consolidado_columna_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
