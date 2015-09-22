CREATE OR REPLACE FUNCTION "plani"."ft_planilla_sigma_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_planilla_sigma_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tplanilla_sigma'
 AUTOR: 		 (jrivera)
 FECHA:	        22-09-2015 14:58:50
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

	v_nombre_funcion = 'plani.ft_planilla_sigma_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PLASI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		22-09-2015 14:58:50
	***********************************/

	if(p_transaccion='PLA_PLASI_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						plasi.id_planilla_sigma,
						plasi.id_funcionario,
						plasi.id_periodo,
						plasi.id_gestion,
						plasi.id_tipo_planilla,
						plasi.sueldo_liquido,
						plasi.estado_reg,
						plasi.id_usuario_ai,
						plasi.usuario_ai,
						plasi.fecha_reg,
						plasi.id_usuario_reg,
						plasi.id_usuario_mod,
						plasi.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from plani.tplanilla_sigma plasi
						inner join segu.tusuario usu1 on usu1.id_usuario = plasi.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plasi.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PLASI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		22-09-2015 14:58:50
	***********************************/

	elsif(p_transaccion='PLA_PLASI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_planilla_sigma)
					    from plani.tplanilla_sigma plasi
					    inner join segu.tusuario usu1 on usu1.id_usuario = plasi.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plasi.id_usuario_mod
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
ALTER FUNCTION "plani"."ft_planilla_sigma_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
