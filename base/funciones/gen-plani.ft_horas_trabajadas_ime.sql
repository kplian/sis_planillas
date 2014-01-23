CREATE OR REPLACE FUNCTION "plani"."ft_horas_trabajadas_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_horas_trabajadas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.thoras_trabajadas'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2014 16:11:12
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
	v_id_horas_trabajadas	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_horas_trabajadas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_HORTRA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:12
	***********************************/

	if(p_transaccion='PLA_HORTRA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.thoras_trabajadas(
			id_funcionario_planilla,
			id_uo_funcionario,
			tipo_contrato,
			estado_reg,
			horas_nocturnas,
			horas_disponibilidad,
			horas_extras,
			horas_normales,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_funcionario_planilla,
			v_parametros.id_uo_funcionario,
			v_parametros.tipo_contrato,
			'activo',
			v_parametros.horas_nocturnas,
			v_parametros.horas_disponibilidad,
			v_parametros.horas_extras,
			v_parametros.horas_normales,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_horas_trabajadas into v_id_horas_trabajadas;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Trabajadas almacenado(a) con exito (id_horas_trabajadas'||v_id_horas_trabajadas||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_horas_trabajadas',v_id_horas_trabajadas::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_HORTRA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:12
	***********************************/

	elsif(p_transaccion='PLA_HORTRA_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.thoras_trabajadas set
			id_funcionario_planilla = v_parametros.id_funcionario_planilla,
			id_uo_funcionario = v_parametros.id_uo_funcionario,
			tipo_contrato = v_parametros.tipo_contrato,
			horas_nocturnas = v_parametros.horas_nocturnas,
			horas_disponibilidad = v_parametros.horas_disponibilidad,
			horas_extras = v_parametros.horas_extras,
			horas_normales = v_parametros.horas_normales,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_horas_trabajadas=v_parametros.id_horas_trabajadas;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Trabajadas modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_horas_trabajadas',v_parametros.id_horas_trabajadas::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_HORTRA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:12
	***********************************/

	elsif(p_transaccion='PLA_HORTRA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.thoras_trabajadas
            where id_horas_trabajadas=v_parametros.id_horas_trabajadas;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Horas Trabajadas eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_horas_trabajadas',v_parametros.id_horas_trabajadas::varchar);
              
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
ALTER FUNCTION "plani"."ft_horas_trabajadas_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
