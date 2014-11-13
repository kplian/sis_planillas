CREATE OR REPLACE FUNCTION plani.ft_funcionario_afp_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_funcionario_afp_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tfuncionario_afp'
 AUTOR: 		 (admin)
 FECHA:	        20-01-2014 16:05:08
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

	v_nombre_funcion = 'plani.ft_funcionario_afp_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_FUNAFP_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 16:05:08
	***********************************/

	if(p_transaccion='PLA_FUNAFP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						afp.id_funcionario_afp,
						afp.id_afp,
						afp.id_funcionario,
						afp.tipo_jubilado,
						afp.fecha_fin,
						afp.fecha_ini,
						afp.estado_reg,
						afp.nro_afp,
						afp.fecha_reg,
						afp.id_usuario_reg,
						afp.id_usuario_mod,
						afp.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						afppar.nombre	
						from plani.tfuncionario_afp afp
						inner join segu.tusuario usu1 on usu1.id_usuario = afp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = afp.id_usuario_mod
						inner join plani.tafp afppar on afppar.id_afp = afp.id_afp
				        where afp.estado_reg = ''activo'' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNAFP_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 16:05:08
	***********************************/

	elsif(p_transaccion='PLA_FUNAFP_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_funcionario_afp)
					    from plani.tfuncionario_afp afp
					    inner join segu.tusuario usu1 on usu1.id_usuario = afp.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = afp.id_usuario_mod
						inner join plani.tafp afppar on afppar.id_afp = afp.id_afp
					    where afp.estado_reg = ''activo'' and  ';
			
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;