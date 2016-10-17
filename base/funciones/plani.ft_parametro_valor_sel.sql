CREATE OR REPLACE FUNCTION "plani"."ft_parametro_valor_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_parametro_valor_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tparametro_valor'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 15:36:56
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

	v_nombre_funcion = 'plani.ft_parametro_valor_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PARVAR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:56
	***********************************/

	if(p_transaccion='PLA_PARVAR_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						parvar.id_parametro_valor,
						parvar.valor,
						parvar.fecha_fin,
						parvar.estado_reg,
						parvar.nombre,
						parvar.codigo,
						parvar.fecha_ini,
						parvar.fecha_reg,
						parvar.id_usuario_reg,
						parvar.id_usuario_mod,
						parvar.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from plani.tparametro_valor parvar
						inner join segu.tusuario usu1 on usu1.id_usuario = parvar.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = parvar.id_usuario_mod
				        where  parvar.estado_reg = ''activo'' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PARVAR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:56
	***********************************/

	elsif(p_transaccion='PLA_PARVAR_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_parametro_valor)
					    from plani.tparametro_valor parvar
					    inner join segu.tusuario usu1 on usu1.id_usuario = parvar.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = parvar.id_usuario_mod
					    where  parvar.estado_reg = ''activo'' and ';
			
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
ALTER FUNCTION "plani"."ft_parametro_valor_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
