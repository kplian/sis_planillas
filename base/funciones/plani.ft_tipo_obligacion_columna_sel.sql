CREATE OR REPLACE FUNCTION plani.ft_tipo_obligacion_columna_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_obligacion_columna_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_obligacion_columna'
 AUTOR: 		 (admin)
 FECHA:	        18-01-2014 02:57:04
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

	v_nombre_funcion = 'plani.ft_tipo_obligacion_columna_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_OBCOL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:57:04
	***********************************/

	if(p_transaccion='PLA_OBCOL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						obcol.id_tipo_obligacion_columna,
						obcol.id_tipo_obligacion,
						obcol.presupuesto,
						obcol.pago,
						obcol.estado_reg,
						obcol.codigo_columna,
						obcol.fecha_reg,
						obcol.id_usuario_reg,
						obcol.id_usuario_mod,
						obcol.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        obcol.es_ultimo	
						from plani.ttipo_obligacion_columna obcol
						inner join segu.tusuario usu1 on usu1.id_usuario = obcol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obcol.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_OBCOL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:57:04
	***********************************/

	elsif(p_transaccion='PLA_OBCOL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_obligacion_columna)
					    from plani.ttipo_obligacion_columna obcol
					    inner join segu.tusuario usu1 on usu1.id_usuario = obcol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = obcol.id_usuario_mod
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