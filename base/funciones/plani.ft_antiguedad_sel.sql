CREATE OR REPLACE FUNCTION "plani"."ft_antiguedad_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_antiguedad_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tantiguedad'
 AUTOR: 		 (admin)
 FECHA:	        20-01-2014 03:47:41
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

	v_nombre_funcion = 'plani.ft_antiguedad_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_ANTI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:47:41
	***********************************/

	if(p_transaccion='PLA_ANTI_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						anti.id_antiguedad,
						anti.estado_reg,
						anti.valor_max,
						anti.porcentaje,
						anti.valor_min,
						anti.id_usuario_reg,
						anti.fecha_reg,
						anti.id_usuario_mod,
						anti.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from plani.tantiguedad anti
						inner join segu.tusuario usu1 on usu1.id_usuario = anti.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = anti.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_ANTI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 03:47:41
	***********************************/

	elsif(p_transaccion='PLA_ANTI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_antiguedad)
					    from plani.tantiguedad anti
					    inner join segu.tusuario usu1 on usu1.id_usuario = anti.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = anti.id_usuario_mod
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
ALTER FUNCTION "plani"."ft_antiguedad_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
