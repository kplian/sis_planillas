-- FUNCTION: plani.ft_tipo_columna_sel(integer, integer, character varying, character varying)

-- DROP FUNCTION plani.ft_tipo_columna_sel(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION plani.ft_tipo_columna_sel(
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
 FUNCION: 		plani.ft_tipo_columna_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.ttipo_columna'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 19:43:15
 COMENTARIOS:
***************************************************************************
HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION

 #0               17-01-2014        JRR KPLIAN       creacion
 #10              04/06/2019        RAC KPLIAN       añade posibilidad  para configurar  si el tipo de columna es editable
 #143			  25.06.2020		MZM KPLIAN		 adicion de campo tipo_movimiento
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'plani.ft_tipo_columna_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PLA_TIPCOL_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		17-01-2014 19:43:15
	***********************************/

	if(p_transaccion='PLA_TIPCOL_SEL')then

    	begin
    		--Sentencia de la consulta
            --#10 añade columna editable
			v_consulta:='select
						tipcol.id_tipo_columna,
						tipcol.id_tipo_planilla,
						tipcol.compromete,
						tipcol.tipo_descuento_bono,
						tipcol.tipo_dato,
						tipcol.codigo,
						tipcol.decimales_redondeo,
						tipcol.nombre,
						tipcol.estado_reg,
						tipcol.orden,
						tipcol.descripcion,
						tipcol.formula,
						tipcol.id_usuario_reg,
						tipcol.fecha_reg,
						tipcol.fecha_mod,
						tipcol.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tipcol.finiquito,
						tipcol.tiene_detalle,
						tipcol.recalcular,
                        tipcol.editable	--#10
                        ,tipcol.tipo_movimiento --#143
						from plani.ttipo_columna tipcol
						inner join segu.tusuario usu1 on usu1.id_usuario = tipcol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tipcol.id_usuario_mod
				        where tipcol.estado_reg = ''activo'' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PLA_TIPCOL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		17-01-2014 19:43:15
	***********************************/

	elsif(p_transaccion='PLA_TIPCOL_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_columna)
					    from plani.ttipo_columna tipcol
					    inner join segu.tusuario usu1 on usu1.id_usuario = tipcol.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tipcol.id_usuario_mod
					    where tipcol.estado_reg = ''activo'' and ';

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

ALTER FUNCTION plani.ft_tipo_columna_sel(integer, integer, character varying, character varying)
    OWNER TO postgres;
