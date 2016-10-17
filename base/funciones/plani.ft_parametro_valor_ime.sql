CREATE OR REPLACE FUNCTION plani.ft_parametro_valor_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_parametro_valor_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tparametro_valor'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 15:36:56
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
	v_id_parametro_valor	integer;
    v_reg					record;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_parametro_valor_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PARVAR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:56
	***********************************/

	if(p_transaccion='PLA_PARVAR_INS')then
					
        begin
        	if (plani.f_existe_columna(v_parametros.codigo,NULL,v_parametros.fecha_ini)) then
        		raise exception 'Ya existe otro parametro o columna con este codigo';
        	end if;
        	--Sentencia de la insercion
        	insert into plani.tparametro_valor(
			estado_reg,
			nombre,
			codigo,
			valor,
			fecha_ini,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.nombre,			
			upper(v_parametros.codigo),
			v_parametros.valor,
			v_parametros.fecha_ini,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_parametro_valor into v_id_parametro_valor;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Parametro Valor almacenado(a) con exito (id_parametro_valor'||v_id_parametro_valor||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_parametro_valor',v_id_parametro_valor::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PARVAR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:56
	***********************************/

	elsif(p_transaccion='PLA_PARVAR_MOD')then

		begin
		
			select * into v_reg
			from plani.tparametro_valor
			where id_parametro_valor=v_parametros.id_parametro_valor;
			
			if (v_parametros.valor != v_reg.valor) then
				if (v_parametros.fecha_ini > v_reg.fecha_ini) then
					insert into plani.tparametro_valor (
						fecha_ini, 				nombre, 			codigo, 
						valor, 					fecha_fin, 			id_usuario_reg,
						fecha_reg,				estado_reg) 
					values (
						v_reg.fecha_ini,		v_reg.nombre,		v_reg.codigo,
						v_reg.valor,			v_parametros.fecha_ini - interval '1 day',	v_reg.id_usuario_reg,
						v_reg.fecha_reg,		'activo');
					
					--Sentencia de la modificacion
					update plani.tparametro_valor set
					fecha_ini = v_parametros.fecha_ini,
					valor = v_parametros.valor,			
					id_usuario_mod = p_id_usuario,
					fecha_mod = now()
					where id_parametro_valor=v_parametros.id_parametro_valor;
				else
					raise exception 'La fecha de aplicación no puede ser menor a la ultima fecha de aplicación de este parametro';
				end if;
			else
				raise exception 'No ha realizado modificaciones al valor';
			end if;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Parametro Valor modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_parametro_valor',v_parametros.id_parametro_valor::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PARVAR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 15:36:56
	***********************************/

	elsif(p_transaccion='PLA_PARVAR_ELI')then

		begin
			--Sentencia de la eliminacion
			update plani.tparametro_valor
			set estado_reg = 'inactivo'
            where id_parametro_valor=v_parametros.id_parametro_valor;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Parametro Valor eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_parametro_valor',v_parametros.id_parametro_valor::varchar);
              
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