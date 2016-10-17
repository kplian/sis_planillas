CREATE OR REPLACE FUNCTION plani.ft_descuento_bono_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_descuento_bono_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tdescuento_bono'
 AUTOR: 		 (admin)
 FECHA:	        20-01-2014 18:26:40
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

	v_nombre_funcion = 'plani.ft_descuento_bono_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_DESBON_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 18:26:40
	***********************************/

	if(p_transaccion='PLA_DESBON_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						desbon.id_descuento_bono,
						desbon.id_funcionario,
						desbon.id_moneda,
						desbon.id_tipo_columna,
						desbon.valor_por_cuota,
						desbon.monto_total,
						desbon.num_cuotas,
						desbon.fecha_ini,
						desbon.estado_reg,
						desbon.fecha_fin,
						desbon.fecha_reg,
						desbon.id_usuario_reg,
						desbon.id_usuario_mod,
						desbon.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						mon.moneda,
						tipcol.codigo,
						tipcol.tipo_descuento_bono,
                        tipcol.tipo_dato
						from plani.tdescuento_bono desbon
						inner join segu.tusuario usu1 on usu1.id_usuario = desbon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = desbon.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda = desbon.id_moneda
						inner join plani.ttipo_columna tipcol on tipcol.id_tipo_columna = desbon.id_tipo_columna
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_DESBON_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 18:26:40
	***********************************/

	elsif(p_transaccion='PLA_DESBON_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_descuento_bono)
					    from plani.tdescuento_bono desbon
					    inner join segu.tusuario usu1 on usu1.id_usuario = desbon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = desbon.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda = desbon.id_moneda
						inner join plani.ttipo_columna tipcol on tipcol.id_tipo_columna = desbon.id_tipo_columna
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;