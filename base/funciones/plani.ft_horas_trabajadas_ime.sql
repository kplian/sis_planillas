CREATE OR REPLACE FUNCTION plani.ft_horas_trabajadas_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_horas_trabajadas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.thoras_trabajadas'
 AUTOR: 		 (admin)
 FECHA:	        26-01-2014 21:35:44
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
	v_planilla				record;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_horas_trabajadas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_HORTRA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		26-01-2014 21:35:44
	***********************************/

	if(p_transaccion='PLA_HORTRA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.thoras_trabajadas(
			id_funcionario_planilla,
			id_uo_funcionario,
			fecha_fin,
			horas_extras,
			horas_disponibilidad,
			horas_nocturnas,
			fecha_ini,
			tipo_contrato,
			estado_reg,
			horas_normales,
			sueldo,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_funcionario_planilla,
			v_parametros.id_uo_funcionario,
			v_parametros.fecha_fin,
			v_parametros.horas_extras,
			v_parametros.horas_disponibilidad,
			v_parametros.horas_nocturnas,
			v_parametros.fecha_ini,
			v_parametros.tipo_contrato,
			'activo',
			v_parametros.horas_normales,
			v_parametros.sueldo,
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
 	#FECHA:		26-01-2014 21:35:44
	***********************************/

	elsif(p_transaccion='PLA_HORTRA_MOD')then

		begin
			select pla.*
        	into v_planilla
        	from plani.tplanilla pla
        	inner join plani.tfuncionario_planilla fp on fp.id_planilla = pla.id_planilla 
        	where fp.id_funcionario_planilla = v_parametros.id_funcionario_planilla;
        	
        	if (v_planilla.estado not in ('registro_horas','calculo_columnas'))then
        		raise exception 'La planilla debe estar en estado registro_horas o calculo_columnas para poder modificar las horas trabajadas';
        	end if;
        	
			--Sentencia de la modificacion
			update plani.thoras_trabajadas set
			id_funcionario_planilla = v_parametros.id_funcionario_planilla,
			id_uo_funcionario = v_parametros.id_uo_funcionario,
			fecha_fin = v_parametros.fecha_fin,
			horas_extras = v_parametros.horas_extras,
			horas_disponibilidad = v_parametros.horas_disponibilidad,
			horas_nocturnas = v_parametros.horas_nocturnas,
			fecha_ini = v_parametros.fecha_ini,
			tipo_contrato = v_parametros.tipo_contrato,
			horas_normales = v_parametros.horas_normales,
			sueldo = v_parametros.sueldo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_horas_trabajadas=v_parametros.id_horas_trabajadas;
            
            update plani.tplanilla set requiere_calculo = 'si'
            where id_planilla =  v_planilla.id_planilla;
               
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
 	#FECHA:		26-01-2014 21:35:44
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;