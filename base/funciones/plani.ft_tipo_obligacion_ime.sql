CREATE OR REPLACE FUNCTION plani.ft_tipo_obligacion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_obligacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_obligacion'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 19:43:19
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 * ISSUE 	FORK		FECHA			AUTHOR			DESCRIPCION
 * #3		EndeEtr		05/02/2019		EGS				Se agrego el campo id_tipo_obligacion_agrupador 
   #1		EndeEtr		19/02/2019		EGS				Se agrego el campo descripcion
   #1		EndeEtr		20/02/2019		EGS				se agrego los campos codigo_tipo_relacion_debe,codigo_tipo_relacion_haber	 	
   #46		ETR			19.09.2019		MZM				Adicion de campo tipo_abono para reporte abono en cuenta
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tipo_obligacion	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_obligacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	if(p_transaccion='PLA_TIPOBLI_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.ttipo_obligacion(
			tipo_obligacion,
			dividir_por_lugar,
			id_tipo_planilla,
			estado_reg,
			codigo,
			nombre,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            es_pagable,
            id_tipo_obligacion_agrupador, --#3 EGS
            descripcion,
            codigo_tipo_relacion_debe,
            codigo_tipo_relacion_haber
            ,tipo_abono --#46
          	) values(
			v_parametros.tipo_obligacion,
			v_parametros.dividir_por_lugar,
			v_parametros.id_tipo_planilla,
			'activo',
			upper(v_parametros.codigo),
			v_parametros.nombre,
			p_id_usuario,
			now(),
			null,
			null,
            v_parametros.es_pagable,
            v_parametros.id_tipo_obligacion_agrupador, --#3 EGS
            v_parametros.descripcion, --#1 EGS
            v_parametros.codigo_tipo_relacion_debe,--#1 EGS
            v_parametros.codigo_tipo_relacion_haber--#1 EGS
            ,v_parametros.tipo_abono --#46
							
			)RETURNING id_tipo_obligacion into v_id_tipo_obligacion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Obligación almacenado(a) con exito (id_tipo_obligacion'||v_id_tipo_obligacion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion',v_id_tipo_obligacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	elsif(p_transaccion='PLA_TIPOBLI_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.ttipo_obligacion set
			tipo_obligacion = v_parametros.tipo_obligacion,
			dividir_por_lugar = v_parametros.dividir_por_lugar,
			id_tipo_planilla = v_parametros.id_tipo_planilla,
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            es_pagable = v_parametros.es_pagable,
            id_tipo_obligacion_agrupador = v_parametros.id_tipo_obligacion_agrupador, --#3 EGS
            descripcion = v_parametros.descripcion, --#1 EGS
            codigo_tipo_relacion_debe = v_parametros.codigo_tipo_relacion_debe,--#1 EGS
            codigo_tipo_relacion_haber = v_parametros.codigo_tipo_relacion_haber--#1 EGS
            ,tipo_abono=v_parametros.tipo_abono--#46
			where id_tipo_obligacion=v_parametros.id_tipo_obligacion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Obligación modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion',v_parametros.id_tipo_obligacion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPOBLI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:19
	***********************************/

	elsif(p_transaccion='PLA_TIPOBLI_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.ttipo_obligacion
            where id_tipo_obligacion=v_parametros.id_tipo_obligacion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Obligación eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_obligacion',v_parametros.id_tipo_obligacion::varchar);
              
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
LANGUAGE 'plpgsql';