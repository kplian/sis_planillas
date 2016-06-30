CREATE OR REPLACE FUNCTION plani.ft_funcionario_afp_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_funcionario_afp_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tfuncionario_afp'
 AUTOR: 		 (admin)
 FECHA:	        20-01-2014 16:05:08
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
	v_id_funcionario_afp	integer;
	v_max_fecha_ini			date;		    
BEGIN

    v_nombre_funcion = 'plani.ft_funcionario_afp_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_FUNAFP_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 16:05:08
	***********************************/

	if(p_transaccion='PLA_FUNAFP_INS')then
					
        begin
        	select max(fecha_ini) into v_max_fecha_ini
        	from plani.tfuncionario_afp
            where id_funcionario = v_parametros.id_funcionario;
        	
        	if (v_max_fecha_ini + interval '1 day' >= v_parametros.fecha_ini)then
        		raise exception 'Ya existe una Afp asignada para este empleado con fecha inicio: %',v_max_fecha_ini;
        	end if;
        	
        	update plani.tfuncionario_afp set
				fecha_fin = v_parametros.fecha_ini - interval '1 day'
			where fecha_fin is null and id_funcionario = v_parametros.id_funcionario;
			
        	--Sentencia de la insercion
        	insert into plani.tfuncionario_afp(
			id_afp,
			id_funcionario,
			tipo_jubilado,
			fecha_ini,
			estado_reg,
			nro_afp,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_afp,
			v_parametros.id_funcionario,
			v_parametros.tipo_jubilado,
			v_parametros.fecha_ini,
			'activo',
			v_parametros.nro_afp,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_funcionario_afp into v_id_funcionario_afp;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','AFP almacenado(a) con exito (id_funcionario_afp'||v_id_funcionario_afp||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_afp',v_id_funcionario_afp::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNAFP_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 16:05:08
	***********************************/

	elsif(p_transaccion='PLA_FUNAFP_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tfuncionario_afp set
			id_afp = v_parametros.id_afp,
			id_funcionario = v_parametros.id_funcionario,
			tipo_jubilado = v_parametros.tipo_jubilado,
			fecha_ini = v_parametros.fecha_ini,
			nro_afp = v_parametros.nro_afp,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_funcionario_afp=v_parametros.id_funcionario_afp;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','AFP modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_afp',v_parametros.id_funcionario_afp::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNAFP_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		20-01-2014 16:05:08
	***********************************/

	elsif(p_transaccion='PLA_FUNAFP_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.tfuncionario_afp
            where id_funcionario_afp=v_parametros.id_funcionario_afp;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','AFP eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_afp',v_parametros.id_funcionario_afp::varchar);
              
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