CREATE OR REPLACE FUNCTION "plani"."ft_prorrateo_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_prorrateo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tprorrateo'
 AUTOR: 		 (jrivera)
 FECHA:	        17-02-2016 16:12:04
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

	v_nombre_funcion = 'plani.ft_prorrateo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		17-02-2016 16:12:04
	***********************************/

	if(p_transaccion='PLA_PRO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pro.id_prorrateo,						
						pro.id_presupuesto,
						cc.codigo_cc,
						pro.id_funcionario_planilla,
						pro.id_horas_trabajadas,						
						pro.porcentaje,					
						pro.tipo_contrato,
												
						pro.estado_reg,						
						pro.id_usuario_reg,
						pro.fecha_reg,
						usu1.cuenta as usr_reg,
						
						pro.id_usuario_mod,
						pro.fecha_mod,
						usu2.cuenta as usr_mod,
						
						pro.id_usuario_ai,						
						pro.usuario_ai
									
							
						from plani.tprorrateo pro
						inner join segu.tusuario usu1 on usu1.id_usuario = pro.id_usuario_reg
						inner join pre.vpresupuesto_cc cc on cc.id_centro_costo=pro.id_presupuesto					
						left join segu.tusuario usu2 on usu2.id_usuario = pro.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		17-02-2016 16:12:04
	***********************************/

	elsif(p_transaccion='PLA_PRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_prorrateo)
					    from plani.tprorrateo pro
					    inner join segu.tusuario usu1 on usu1.id_usuario = pro.id_usuario_reg
					    inner join param.vcentro_costo cc on cc.id_centro_costo=pro.id_presupuesto
						left join segu.tusuario usu2 on usu2.id_usuario = pro.id_usuario_mod
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
ALTER FUNCTION "plani"."ft_prorrateo_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
