-- FUNCTION: plani.ft_detalle_transferencia_sel(integer, integer, character varying, character varying)

-- DROP FUNCTION plani.ft_detalle_transferencia_sel(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION plani.ft_detalle_transferencia_sel(
	p_administrador integer,
	p_id_usuario integer,
	p_tabla character varying,
	p_transaccion character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_detalle_transferencia_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tdetalle_transferencia'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 20:28:39
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
 #112			  13.04.2020		  MZM					Modificacion a columna para listado
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_detalle_transferencia_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_DETRAN_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:39
	***********************************/

	if(p_transaccion='PLA_DETRAN_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						detran.id_detalle_transferencia,
						detran.id_funcionario,
						detran.id_institucion,
						detran.id_obligacion,
						detran.nro_cuenta,
						detran.monto_transferencia,
						detran.estado_reg,
						detran.id_usuario_ai,
						detran.id_usuario_reg,
						detran.usuario_ai,
						detran.fecha_reg,
						detran.id_usuario_mod,
						detran.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						fun.ci,
						fun.desc_funcionario2,--#112
						ins.nombre	
						from plani.tdetalle_transferencia detran
						inner join orga.vfuncionario fun
							on fun.id_funcionario = detran.id_funcionario
						inner join param.tinstitucion ins
							on ins.id_institucion = detran.id_institucion
						inner join segu.tusuario usu1 on usu1.id_usuario = detran.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = detran.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_DETRAN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 20:28:39
	***********************************/

	elsif(p_transaccion='PLA_DETRAN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_detalle_transferencia)
					    from plani.tdetalle_transferencia detran
					    inner join orga.vfuncionario fun
							on fun.id_funcionario = detran.id_funcionario
						inner join param.tinstitucion ins
							on ins.id_institucion = detran.id_institucion
					    inner join segu.tusuario usu1 on usu1.id_usuario = detran.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = detran.id_usuario_mod
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
$BODY$;

ALTER FUNCTION plani.ft_detalle_transferencia_sel(integer, integer, character varying, character varying)
    OWNER TO postgres;