CREATE OR REPLACE FUNCTION plani.f_reporte_calcular_ancho_utilizado (
  p_id_reporte integer
)
RETURNS varchar AS
$body$
DECLARE  
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_ancho_utilizado			integer;
  v_reg						record;
BEGIN
	v_nombre_funcion = 'plani.f_reporte_calcular_ancho_utilizado';
	
	select * into v_reg from plani.treporte where id_reporte = p_id_reporte;
	v_ancho_utilizado = 0;
	if (v_reg.numerar = 'si') then
		v_ancho_utilizado = v_ancho_utilizado + 10;
	end if;
	if (v_reg.mostrar_nombre = 'si') then
		v_ancho_utilizado = v_ancho_utilizado +10;
	end if;
	if (v_reg.mostrar_codigo_empleado = 'si') then
		v_ancho_utilizado = v_ancho_utilizado + 15;
	end if;
	if (v_reg.mostrar_doc_id = 'si') then
		v_ancho_utilizado = v_ancho_utilizado + 15;
	end if;
	if (v_reg.mostrar_codigo_cargo = 'si') then
		v_ancho_utilizado = v_ancho_utilizado + 10;
	end if;
	
	for v_reg in (select * from plani.treporte_columna where id_reporte = p_id_reporte) loop
		v_ancho_utilizado = v_ancho_utilizado + v_reg.ancho_columna;
	end loop;
  
  	update plani.treporte set
  	ancho_utilizado = v_ancho_utilizado
  	where id_reporte = p_id_reporte;
  	
  	return 'exito';
  
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