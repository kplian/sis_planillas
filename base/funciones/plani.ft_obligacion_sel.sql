CREATE OR REPLACE FUNCTION "plani"."ft_obligacion_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_obligacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tobligacion'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 20:30:19
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

	v_nombre_funcion = 'plani.ft_obligacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_OBLI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:30:19
	***********************************/

	if(p_transaccion='PLA_OBLI_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						obli.id_obligacion,
						obli.id_auxiliar,
						obli.id_cuenta,
						obli.id_planilla,
						obli.id_tipo_obligacion,
						obli.monto_obligacion,
						obli.acreedor,
						obli.estado_reg,
						obli.tipo_pago,
						obli.descripcion,
						obli.id_usuario_reg,
						obli.usuario_ai,
						obli.fecha_reg,
						obli.id_usuario_ai,
						obli.fecha_mod,
						obli.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tipobli.es_pagable	
						from plani.tobligacion obli
						inner join plani.ttipo_obligacion tipobli 
							on tipobli.id_tipo_obligacion = obli.id_tipo_obligacion
						inner join segu.tusuario usu1 on usu1.id_usuario = obli.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obli.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_OBLI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:30:19
	***********************************/

	elsif(p_transaccion='PLA_OBLI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_obligacion)
					    from plani.tobligacion obli
					    inner join plani.ttipo_obligacion tipobli 
							on tipobli.id_tipo_obligacion = obli.id_tipo_obligacion
					    inner join segu.tusuario usu1 on usu1.id_usuario = obli.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obli.id_usuario_mod
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
ALTER FUNCTION "plani"."ft_obligacion_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
