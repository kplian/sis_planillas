CREATE OR REPLACE FUNCTION plani.ft_tipo_obligacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_obligacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_obligacion'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 19:43:19
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 * ISSUE 	FORK		FECHA			AUTHOR			DESCRIPCION
 * #3		EndeEtr		05/02/2019		EGS				Se agrego a la consulta campo id_tipo_obligacion_agrupador y codigo_agrupador
   #1		EndeEtr		19/02/2019		EGS				Se agrego el campo descripcion
 * #1		EndeEtr		20/02/2019		EGS				se agrego los campos codigo_tipo_relacion_debe,codigo_tipo_relacion_haber	 	
   #46		ETR			19.09.2019		MZM				Adicion de campo tipo_abono para reporte bono en cuenta
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_tipo_obligacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	if(p_transaccion='PLA_TIPOBLI_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tipobli.id_tipo_obligacion,
						tipobli.tipo_obligacion,
						tipobli.dividir_por_lugar,
						tipobli.id_tipo_planilla,
						tipobli.estado_reg,
						tipobli.codigo,
						tipobli.nombre,
						tipobli.id_usuario_reg,
						tipobli.fecha_reg,
						tipobli.id_usuario_mod,
						tipobli.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tipobli.es_pagable,
                        tipobli.id_tipo_obligacion_agrupador,  --#3 EGS
                        toag.codigo as codigo_agrupador,	  --#3 EGS
                        tipobli.descripcion,         --#1 EGS
                        tipobli.codigo_tipo_relacion_debe,--#1 EGS
                        tipobli.codigo_tipo_relacion_haber--#1 EGS
                        ,tipobli.tipo_abono --#46
						from plani.ttipo_obligacion tipobli
						inner join segu.tusuario usu1 on usu1.id_usuario = tipobli.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tipobli.id_usuario_mod
                        left join plani.ttipo_obligacion_agrupador toag on toag.id_tipo_obligacion_agrupador = tipobli.id_tipo_obligacion_agrupador
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	elsif(p_transaccion='PLA_TIPOBLI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_obligacion)
					    from plani.ttipo_obligacion tipobli
					    inner join segu.tusuario usu1 on usu1.id_usuario = tipobli.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tipobli.id_usuario_mod
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
LANGUAGE 'plpgsql';