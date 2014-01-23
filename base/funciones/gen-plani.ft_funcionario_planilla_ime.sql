CREATE OR REPLACE FUNCTION "plani"."ft_funcionario_planilla_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_funcionario_planilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tfuncionario_planilla'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2014 16:11:08
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
	v_id_funcionario_planilla	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_funcionario_planilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	if(p_transaccion='PLA_FUNPLAN_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.tfuncionario_planilla(
			finiquito,
			forzar_cheque,
			id_funcionario,
			id_planilla,
			id_lugar,
			id_uo_funcionario,
			estado_reg,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.finiquito,
			v_parametros.forzar_cheque,
			v_parametros.id_funcionario,
			v_parametros.id_planilla,
			v_parametros.id_lugar,
			v_parametros.id_uo_funcionario,
			'activo',
			p_id_usuario,
			now(),
			null,
			null
							
			)RETURNING id_funcionario_planilla into v_id_funcionario_planilla;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla almacenado(a) con exito (id_funcionario_planilla'||v_id_funcionario_planilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_id_funcionario_planilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	elsif(p_transaccion='PLA_FUNPLAN_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tfuncionario_planilla set
			finiquito = v_parametros.finiquito,
			forzar_cheque = v_parametros.forzar_cheque,
			id_funcionario = v_parametros.id_funcionario,
			id_planilla = v_parametros.id_planilla,
			id_lugar = v_parametros.id_lugar,
			id_uo_funcionario = v_parametros.id_uo_funcionario,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_funcionario_planilla=v_parametros.id_funcionario_planilla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_parametros.id_funcionario_planilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	elsif(p_transaccion='PLA_FUNPLAN_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tfuncionario_planilla
            where id_funcionario_planilla=v_parametros.id_funcionario_planilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_parametros.id_funcionario_planilla::varchar);
              
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
ALTER FUNCTION "plani"."ft_funcionario_planilla_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
