CREATE OR REPLACE FUNCTION plani.ft_reporte_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_reporte_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.treporte'
 AUTOR: 		 (admin)
 FECHA:	        17-01-2014 22:07:28
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
 #ISSUE				FECHA				AUTOR				DESCRIPCION
 #8		EndeEtr		06-06-2019 			MZM				Se agrego los campos multilinea,vista_datos_externos,num_columna_multilinealas operaciones basicas (inserciones, modificaciones, eliminaciones) de la tabla 'plani.treporte',en procedimiento REPODET_SEL	
 #32	ETR			02.09.2019			MZM				Adicion de relacion id_pie_firma 
 #58	ETR			30.09.2019			MZM				Adicion de campo mostrar_ufv
 #60	ETR			01.10.2019			MZM				Adicion de campo incluir_retirados para reporte de reintegros
 #65	ETR			10.10.2019			MZM				Adicion de campo id_moneda_reporte
 #77	ETR			14.11.2019			MZM				Ajustes varios reportes
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_reporte	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_reporte_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_REPO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	if(p_transaccion='PLA_REPO_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into plani.treporte(
			id_tipo_planilla,
			numerar,
			hoja_posicion,
			mostrar_nombre,
			mostrar_codigo_empleado,
			mostrar_doc_id,
			mostrar_codigo_cargo,
			agrupar_por,
			ordenar_por,
			estado_reg,
			titulo_reporte,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
			ancho_total,
			control_reporte,
			tipo_reporte,
            multilinea,
            vista_datos_externos,
            num_columna_multilinea
            --#32 - 31.08.2019
            ,id_pie_firma
            ,mostrar_ufv --#58
            ,incluir_retirados --#60
            ,id_moneda_reporte--#65
            ,bordes, interlineado--#77
          	) values(
			v_parametros.id_tipo_planilla,
			v_parametros.numerar,
			v_parametros.hoja_posicion,
			v_parametros.mostrar_nombre,
			v_parametros.mostrar_codigo_empleado,
			v_parametros.mostrar_doc_id,
			v_parametros.mostrar_codigo_cargo,
			v_parametros.agrupar_por,
			v_parametros.ordenar_por,
			'activo',
			
			v_parametros.titulo_reporte,
			now(),
			p_id_usuario,
			null,
			null,
			plani.f_reporte_get_ancho_total_hoja(v_parametros.hoja_posicion),
			v_parametros.control_reporte,
			v_parametros.tipo_reporte,
			v_parametros.multilinea,
            v_parametros.vista_datos_externos,
            v_parametros.num_columna_multilinea				
            --#32 - 31.08.2019
            ,v_parametros.id_pie_firma
            ,v_parametros.mostrar_ufv --#58
            ,v_parametros.incluir_retirados --#60
            ,v_parametros.id_moneda_reporte --#65
            ,v_parametros.bordes, v_parametros.interlineado --#77
			)RETURNING id_reporte into v_id_reporte;
			
			v_resp = plani.f_reporte_calcular_ancho_utilizado(v_id_reporte);
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reportes de Planilla almacenado(a) con exito (id_reporte'||v_id_reporte||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reporte',v_id_reporte::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_REPO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPO_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.treporte set
			id_tipo_planilla = v_parametros.id_tipo_planilla,
			numerar = v_parametros.numerar,
			hoja_posicion = v_parametros.hoja_posicion,
			mostrar_nombre = v_parametros.mostrar_nombre,
			mostrar_codigo_empleado = v_parametros.mostrar_codigo_empleado,
			mostrar_doc_id = v_parametros.mostrar_doc_id,
			mostrar_codigo_cargo = v_parametros.mostrar_codigo_cargo,
			agrupar_por = v_parametros.agrupar_por,
			ordenar_por = v_parametros.ordenar_por,
			ancho_total = plani.f_reporte_get_ancho_total_hoja(v_parametros.hoja_posicion),
			titulo_reporte = v_parametros.titulo_reporte,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			control_reporte = v_parametros.control_reporte,
			tipo_reporte = v_parametros.tipo_reporte,
            multilinea=v_parametros.multilinea,
            vista_datos_externos=v_parametros.vista_datos_externos,
            num_columna_multilinea=v_parametros.num_columna_multilinea
            --#32 - 31.08.2019
            ,id_pie_firma=v_parametros.id_pie_firma
            ,mostrar_ufv=v_parametros.mostrar_ufv --#58
            ,incluir_retirados=v_parametros.incluir_retirados --#60
            ,id_moneda_reporte=v_parametros.id_moneda_reporte --#65
            ,bordes=v_parametros.bordes, interlineado=v_parametros.interlineado --#77
			where id_reporte=v_parametros.id_reporte;
            v_resp = plani.f_reporte_calcular_ancho_utilizado(v_parametros.id_reporte);   
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reportes de Planilla modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reporte',v_parametros.id_reporte::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_REPO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-01-2014 22:07:28
	***********************************/

	elsif(p_transaccion='PLA_REPO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from plani.treporte
            where id_reporte=v_parametros.id_reporte;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reportes de Planilla eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reporte',v_parametros.id_reporte::varchar);
              
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