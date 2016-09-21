CREATE OR REPLACE FUNCTION plani.ft_planilla_sigma_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_planilla_sigma_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tplanilla_sigma'
 AUTOR: 		 (jrivera)
 FECHA:	        22-09-2015 14:58:50
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
	v_id_planilla_sigma	integer;
    v_id_funcionario		integer;
    v_ci_erp				varchar;
    v_id_periodo			integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_planilla_sigma_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PLASI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		22-09-2015 14:58:50
	***********************************/

	if(p_transaccion='PLA_PLASI_INS')then
					
        begin
        	select id_funcionario into v_id_funcionario
            from orga.vfuncionario fun
            where fun.ci = v_parametros.ci;
            if (pxp.f_existe_parametro(p_tabla,'id_periodo') = FALSE) then
            	v_id_periodo = NULL;
            else
            	v_id_periodo = v_parametros.id_periodo;
            end if;
            
            if (v_id_funcionario is null) then
            	select se.ci_erp into v_ci_erp
                from plani.tsigma_equivalencias se
                where ci_sigma = v_parametros.ci;
                if (v_ci_erp is null) then
        			raise exception 'No existe un empleado con el ci: %',v_parametros.ci;
            	else
                    select id_funcionario into v_id_funcionario
                    from orga.vfuncionario fun
                    where fun.ci = v_ci_erp;
                    if (v_id_funcionario is null) then
                    	raise exception 'No existe un empleado con el ci: %',v_parametros.ci;
                    end if;
                end if;
            end if;
        	--Sentencia de la insercion
        	insert into plani.tplanilla_sigma(
			id_funcionario,
			id_periodo,
			id_gestion,
			id_tipo_planilla,
			sueldo_liquido,
			estado_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_id_funcionario,
			v_id_periodo,
			v_parametros.id_gestion,
			v_parametros.id_tipo_planilla,
			v_parametros.sueldo_liquido,
			'activo',
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_planilla_sigma into v_id_planilla_sigma;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Planilla Sigma almacenado(a) con exito (id_planilla_sigma'||v_id_planilla_sigma||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla_sigma',v_id_planilla_sigma::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PLASI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		22-09-2015 14:58:50
	***********************************/

	elsif(p_transaccion='PLA_PLASI_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tplanilla_sigma set
			id_funcionario = v_parametros.id_funcionario,
			id_periodo = v_parametros.id_periodo,
			id_gestion = v_parametros.id_gestion,
			id_tipo_planilla = v_parametros.id_tipo_planilla,
			sueldo_liquido = v_parametros.sueldo_liquido,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_planilla_sigma=v_parametros.id_planilla_sigma;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Planilla Sigma modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_planilla_sigma',v_parametros.id_planilla_sigma::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PLASI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jrivera	
 	#FECHA:		22-09-2015 14:58:50
	***********************************/

	elsif(p_transaccion='PLA_PLASI_ELI')then

		begin
        	 
			--Sentencia de la eliminacion
             if (pxp.f_existe_parametro(p_tabla,'id_periodo') = FALSE) then
            
            	delete from plani.tplanilla_sigma
                where id_tipo_planilla=v_parametros.id_tipo_planilla and
                id_periodo is null and 
                id_gestion = v_parametros.id_gestion;
             else
             
             	if (v_parametros.id_periodo is null) then
                
                    delete from plani.tplanilla_sigma
                    where id_tipo_planilla=v_parametros.id_tipo_planilla and
                    id_periodo is null and 
                    id_gestion = v_parametros.id_gestion;
                else
                	
                	delete from plani.tplanilla_sigma
                    where id_tipo_planilla=v_parametros.id_tipo_planilla and
                    id_periodo = v_parametros.id_periodo and 
                    id_gestion = v_parametros.id_gestion;
                end if;
             end if;
             
             
             
			
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Planilla Sigma eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'v_id_periodo',v_id_periodo::varchar);
              
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