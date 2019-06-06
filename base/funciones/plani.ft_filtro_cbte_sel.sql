CREATE OR REPLACE FUNCTION plani.ft_filtro_cbte_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_filtro_cbte_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tfiltro_cbte'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        15-05-2019 22:18:29
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 #ISSUE				FECHA				AUTOR				DESCRIPCION
 #6	ETR			15-05-2019 22:18:29		MMV Kplian			Identifica los presupeusto que entran al abte de diario presupeustario para planillas, los que noesten presente iran al  cbte de diraio
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'plani.ft_filtro_cbte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PLA_FOE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		15-05-2019 22:18:29
	***********************************/

	if(p_transaccion='PLA_FOE_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						foe.id_filtro_cbte,
						foe.id_tipo_presupuesto,
                        tp.nombre as tipo_presupuesto,
						foe.obs,
						foe.estado_reg,
						foe.id_usuario_ai,
						foe.id_usuario_reg,
						foe.usuario_ai,
						foe.fecha_reg,
						foe.fecha_mod,
						foe.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from plani.tfiltro_cbte foe
						inner join segu.tusuario usu1 on usu1.id_usuario = foe.id_usuario_reg
                        inner join pre.ttipo_presupuesto tp on tp.id_tipo_presupuesto = foe.id_tipo_presupuesto
						left join segu.tusuario usu2 on usu2.id_usuario = foe.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PLA_FOE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		15-05-2019 22:18:29
	***********************************/

	elsif(p_transaccion='PLA_FOE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_filtro_cbte)
					    from plani.tfiltro_cbte foe
					    inner join segu.tusuario usu1 on usu1.id_usuario = foe.id_usuario_reg
                        inner join pre.ttipo_presupuesto tp on tp.id_tipo_presupuesto = foe.id_tipo_presupuesto
						left join segu.tusuario usu2 on usu2.id_usuario = foe.id_usuario_mod
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