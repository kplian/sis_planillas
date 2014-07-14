CREATE OR REPLACE FUNCTION "plani"."ft_obligacion_columna_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_obligacion_columna_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tobligacion_columna'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 20:28:37
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

	v_nombre_funcion = 'plani.ft_obligacion_columna_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_OBLICOL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:37
	***********************************/

	if(p_transaccion='PLA_OBLICOL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						oblicol.id_obligacion_columna,
						oblicol.id_cc,
						oblicol.id_obligacion,
						oblicol.id_presupuesto,
						oblicol.id_tipo_columna,
						oblicol.codigo_columna,
						oblicol.estado_reg,
						oblicol.monto_detalle_obligacion,
						oblicol.tipo_contrato,
						oblicol.id_usuario_reg,
						oblicol.usuario_ai,
						oblicol.fecha_reg,
						oblicol.id_usuario_ai,
						oblicol.id_usuario_mod,
						oblicol.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tipcol.nombre,						
						cc.codigo_cc	
						from plani.tobligacion_columna oblicol
						inner join plani.ttipo_columna tipcol
							on tipcol.id_tipo_columna = oblicol.id_tipo_columna
						inner join param.vcentro_costo cc
							on cc.id_centro_costo = oblicol.id_presupuesto						
						
						inner join segu.tusuario usu1 on usu1.id_usuario = oblicol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = oblicol.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_OBLICOL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:37
	***********************************/

	elsif(p_transaccion='PLA_OBLICOL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_obligacion_columna)
					    from plani.tobligacion_columna oblicol
					    inner join plani.ttipo_columna tipcol
							on tipcol.id_tipo_columna = oblicol.id_tipo_columna
						inner join param.vcentro_costo cc
							on cc.id_centro_costo = oblicol.id_presupuesto						
						
					    inner join segu.tusuario usu1 on usu1.id_usuario = oblicol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = oblicol.id_usuario_mod
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
ALTER FUNCTION "plani"."ft_obligacion_columna_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
