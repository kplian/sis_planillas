CREATE OR REPLACE FUNCTION "plani"."ft_prorrateo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_prorrateo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tprorrateo'
 AUTOR: 		 (jrivera)
 FECHA:	        17-02-2016 16:12:04
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_prorrateo	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_prorrateo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PRO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		17-02-2016 16:12:04
	***********************************/

	if(p_transaccion='PLA_PRO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tprorrateo(
			id_cc,
			id_funcionario_planilla,
			id_horas_trabajadas,
			id_presupuesto,
			id_lugar,
			id_oficina,
			id_lugar,
			id_int_transaccion,
			id_obligacion_det,
			id_plan_pago,
			id_prorrateo_fk,
			porcentaje_dias,
			porcentaje,
			id_transaccion_pag,
			monto_ejecutar_mb,
			id_partida_ejecucion_dev,
			tipo_contrato,
			tipo_prorrateo,
			id_partida_ejecucion_pag,
			estado_reg,
			monto_ejecutar_mo,
			estado_reg,
			id_transaccion_dev,
			id_usuario_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_cc,
			v_parametros.id_funcionario_planilla,
			v_parametros.id_horas_trabajadas,
			v_parametros.id_presupuesto,
			v_parametros.id_lugar,
			v_parametros.id_oficina,
			v_parametros.id_lugar,
			v_parametros.id_int_transaccion,
			v_parametros.id_obligacion_det,
			v_parametros.id_plan_pago,
			v_parametros.id_prorrateo_fk,
			v_parametros.porcentaje_dias,
			v_parametros.porcentaje,
			v_parametros.id_transaccion_pag,
			v_parametros.monto_ejecutar_mb,
			v_parametros.id_partida_ejecucion_dev,
			v_parametros.tipo_contrato,
			v_parametros.tipo_prorrateo,
			v_parametros.id_partida_ejecucion_pag,
			'activo',
			v_parametros.monto_ejecutar_mo,
			'activo',
			v_parametros.id_transaccion_dev,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
			null,
			null
							
			
			
			)RETURNING id_prorrateo into v_id_prorrateo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo almacenado(a) con exito (id_prorrateo'||v_id_prorrateo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_prorrateo',v_id_prorrateo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PRO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		17-02-2016 16:12:04
	***********************************/

	elsif(p_transaccion='PLA_PRO_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tprorrateo set
			
			id_presupuesto = v_parametros.id_cc,			
			porcentaje = v_parametros.porcentaje,
			
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()			
			where id_prorrateo=v_parametros.id_prorrateo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_prorrateo',v_parametros.id_prorrateo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PRO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		17-02-2016 16:12:04
	***********************************/

	elsif(p_transaccion='PLA_PRO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tprorrateo
            where id_prorrateo=v_parametros.id_prorrateo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_prorrateo',v_parametros.id_prorrateo::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "plani"."ft_prorrateo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
