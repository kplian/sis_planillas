CREATE OR REPLACE FUNCTION plani.ft_filtro_cbte_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_filtro_cbte_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tfiltro_cbte'
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

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_filtro_cbte	integer;

BEGIN

    v_nombre_funcion = 'plani.ft_filtro_cbte_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PLA_FOE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		15-05-2019 22:18:29
	***********************************/

	if(p_transaccion='PLA_FOE_INS')then

        begin
        	--Sentencia de la insercion
        	insert into plani.tfiltro_cbte(
			id_tipo_presupuesto,
			obs,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_tipo_presupuesto,
			v_parametros.obs,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null



			)RETURNING id_filtro_cbte into v_id_filtro_cbte;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Filtro Cbte almacenado(a) con exito (id_filtro_cbte'||v_id_filtro_cbte||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_filtro_cbte',v_id_filtro_cbte::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PLA_FOE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		15-05-2019 22:18:29
	***********************************/

	elsif(p_transaccion='PLA_FOE_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tfiltro_cbte set
			id_tipo_presupuesto = v_parametros.id_tipo_presupuesto,
			obs = v_parametros.obs,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_filtro_cbte=v_parametros.id_filtro_cbte;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Filtro Cbte modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_filtro_cbte',v_parametros.id_filtro_cbte::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PLA_FOE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		15-05-2019 22:18:29
	***********************************/

	elsif(p_transaccion='PLA_FOE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tfiltro_cbte
            where id_filtro_cbte=v_parametros.id_filtro_cbte;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Filtro Cbte eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_filtro_cbte',v_parametros.id_filtro_cbte::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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