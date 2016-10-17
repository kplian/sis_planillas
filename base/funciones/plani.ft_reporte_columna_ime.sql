CREATE OR REPLACE FUNCTION "plani"."ft_reporte_columna_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_reporte_columna_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.treporte_columna'
 AUTOR: 		 (admin)
 FECHA:	        18-01-2014 02:56:10
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
	v_id_reporte_columna	integer;
	v_id_reporte	integer;		    
BEGIN

    v_nombre_funcion = 'plani.ft_reporte_columna_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_REPCOL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:56:10
	***********************************/

	if(p_transaccion='PLA_REPCOL_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.treporte_columna(
			id_reporte,
			sumar_total,
			ancho_columna,
			orden,
			estado_reg,
			codigo_columna,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
			titulo_reporte_superior,
			titulo_reporte_inferior,
			tipo_columna
          	) values(
			v_parametros.id_reporte,
			v_parametros.sumar_total,
			v_parametros.ancho_columna,
			v_parametros.orden,
			'activo',
			v_parametros.codigo_columna,
			now(),
			p_id_usuario,
			null,
			null,
			v_parametros.titulo_reporte_superior,
			v_parametros.titulo_reporte_inferior,
			v_parametros.tipo_columna				
			)RETURNING id_reporte_columna into v_id_reporte_columna;
			
			v_resp = plani.f_reporte_calcular_ancho_utilizado(v_parametros.id_reporte); 
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reporte Columna almacenado(a) con exito (id_reporte_columna'||v_id_reporte_columna||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reporte_columna',v_id_reporte_columna::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_REPCOL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:56:10
	***********************************/

	elsif(p_transaccion='PLA_REPCOL_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.treporte_columna set
			id_reporte = v_parametros.id_reporte,
			sumar_total = v_parametros.sumar_total,
			ancho_columna = v_parametros.ancho_columna,
			orden = v_parametros.orden,
			codigo_columna = v_parametros.codigo_columna,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			titulo_reporte_superior = v_parametros.titulo_reporte_superior,
			titulo_reporte_inferior = v_parametros.titulo_reporte_inferior,
			tipo_columna = v_parametros.tipo_columna
			where id_reporte_columna=v_parametros.id_reporte_columna;
            
            v_resp = plani.f_reporte_calcular_ancho_utilizado(v_parametros.id_reporte); 
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reporte Columna modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reporte_columna',v_parametros.id_reporte_columna::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_REPCOL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		18-01-2014 02:56:10
	***********************************/

	elsif(p_transaccion='PLA_REPCOL_ELI')then

		begin
			select id_reporte into v_id_reporte
			from plani.treporte_columna
			where id_reporte_columna = v_parametros.id_reporte_columna;
			
			--Sentencia de la eliminacion
			delete from plani.treporte_columna
            where id_reporte_columna=v_parametros.id_reporte_columna;
            
            v_resp = plani.f_reporte_calcular_ancho_utilizado(v_id_reporte); 
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reporte Columna eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reporte_columna',v_parametros.id_reporte_columna::varchar);
              
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
ALTER FUNCTION "plani"."ft_reporte_columna_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
