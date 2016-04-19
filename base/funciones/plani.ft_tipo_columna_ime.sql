CREATE OR REPLACE FUNCTION plani.ft_tipo_columna_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_tipo_columna_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.ttipo_columna'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 19:43:15
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
	v_id_tipo_columna	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_tipo_columna_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_TIPCOL_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:15
	***********************************/

	if(p_transaccion='PLA_TIPCOL_INS')then
					
        begin
        	if (plani.f_existe_columna(v_parametros.codigo,v_parametros.id_tipo_planilla)) then
        		raise exception 'Ya existe otro parametro o columna con este codigo';
        	end if;
        	--Sentencia de la insercion
        	insert into plani.ttipo_columna(
			id_tipo_planilla,
			compromete,
			tipo_descuento_bono,
			tipo_dato,
			codigo,
			decimales_redondeo,
			nombre,
			estado_reg,
			orden,
			descripcion,
			formula,
			id_usuario_reg,
			fecha_reg,
			fecha_mod,
			id_usuario_mod,
			finiquito,
			tiene_detalle,
			recalcular
          	) values(
			v_parametros.id_tipo_planilla,
			v_parametros.compromete,
			v_parametros.tipo_descuento_bono,
			v_parametros.tipo_dato,
			upper(v_parametros.codigo),
			v_parametros.decimales_redondeo,
			v_parametros.nombre,
			'activo',
			v_parametros.orden,
			v_parametros.descripcion,
			v_parametros.formula,
			p_id_usuario,
			now(),
			null,
			null,
			v_parametros.finiquito,
			v_parametros.tiene_detalle,
			v_parametros.recalcular
							
			)RETURNING id_tipo_columna into v_id_tipo_columna;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Columna almacenado(a) con exito (id_tipo_columna'||v_id_tipo_columna||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_columna',v_id_tipo_columna::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPCOL_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:15
	***********************************/

	elsif(p_transaccion='PLA_TIPCOL_MOD')then

		begin
        	
			--Sentencia de la modificacion
			update plani.ttipo_columna set
			id_tipo_planilla = v_parametros.id_tipo_planilla,
			compromete = v_parametros.compromete,
			tipo_descuento_bono = v_parametros.tipo_descuento_bono,
			tipo_dato = v_parametros.tipo_dato,
			decimales_redondeo = v_parametros.decimales_redondeo,
			nombre = v_parametros.nombre,
			orden = v_parametros.orden,
			descripcion = v_parametros.descripcion,
			formula = v_parametros.formula,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			finiquito = v_parametros.finiquito,
			tiene_detalle = v_parametros.tiene_detalle,
			recalcular = v_parametros.recalcular
			where id_tipo_columna=v_parametros.id_tipo_columna;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Columna modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_columna',v_parametros.id_tipo_columna::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_TIPCOL_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 19:43:15
	***********************************/

	elsif(p_transaccion='PLA_TIPCOL_ELI')then

		begin
			--Sentencia de la eliminacion
			update plani.ttipo_columna
			set estado_reg = 'inactivo'
            where id_tipo_columna=v_parametros.id_tipo_columna;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Columna eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_columna',v_parametros.id_tipo_columna::varchar);
              
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