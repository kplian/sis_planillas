CREATE OR REPLACE FUNCTION plani.f_conta_act_tran_consolidado (
  p_id_int_transaccion integer,
  p_id_consolidado_columna integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planilla
 FUNCION: 		plani.f_conta_act_tran_consolidado
 DESCRIPCION:  Esta funciona actualiza el id_int_trasaccion en  consolidado_columna
 AUTOR: 		 JRR
 FECHA:	        04-09-2013 03:51:00
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
	v_id_transaccion	integer;
			    
BEGIN

    v_nombre_funcion = 'plani.f_conta_act_tran_consolidado';
  
      update plani.tconsolidado_columna set
      id_int_transaccion = p_id_int_transaccion
      where id_consolidado_columna = p_id_consolidado_columna;

	RETURN TRUE;
	

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