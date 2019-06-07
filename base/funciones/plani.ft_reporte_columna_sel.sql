CREATE OR REPLACE FUNCTION plani.ft_reporte_columna_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_reporte_columna_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.treporte_columna'
 AUTOR: 		 (admin)
 FECHA:	        18-01-2014 02:56:10
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:	
 #ISSUE				FECHA				AUTOR				DESCRIPCION
 #8		EndeEtr		06-06-2019 			MZM				Se agrego los campos espacio_previo,columna_vista,origen en operaciones basicas (listar, contar) de la tabla 'plani.treporte_columna',en procedimiento REPCOL_SEL	
   	
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_reporte_columna_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_REPCOL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:56:10
	***********************************/

	if(p_transaccion='PLA_REPCOL_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						repcol.id_reporte_columna,
						repcol.id_reporte,
						repcol.sumar_total,
						repcol.ancho_columna,
						repcol.orden,
						repcol.estado_reg,
						repcol.codigo_columna,
						repcol.fecha_reg,
						repcol.id_usuario_reg,
						repcol.id_usuario_mod,
						repcol.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						repcol.titulo_reporte_superior,
						repcol.titulo_reporte_inferior,
						repcol.tipo_columna,
                        repcol.espacio_previo,
						repcol.columna_vista,
                        repcol.origen
						from plani.treporte_columna repcol
						inner join segu.tusuario usu1 on usu1.id_usuario = repcol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = repcol.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_REPCOL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:56:10
	***********************************/

	elsif(p_transaccion='PLA_REPCOL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_reporte_columna)
					    from plani.treporte_columna repcol
					    inner join segu.tusuario usu1 on usu1.id_usuario = repcol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = repcol.id_usuario_mod
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