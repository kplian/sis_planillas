CREATE OR REPLACE FUNCTION plani.f_existe_incremento_en_rango (
  p_id_escala_salarial integer,
  p_fecha_ini date,
  p_fecha_fin date
)
  RETURNS date AS
  $body$
DECLARE
  v_id_empleado				integer;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
  v_fecha_incremento		date;
  v_nombre_escala			varchar;
BEGIN
  v_nombre_funcion = 'plani.f_existe_incremento_en_rango';
  select es.fecha_ini into v_fecha_incremento
  from orga.tescala_salarial es
  where (id_escala_padre = p_id_escala_salarial or id_escala_salarial = p_id_escala_salarial) and
  (es.fecha_ini is not null  and es.fecha_ini > p_fecha_ini and es.fecha_ini <= p_fecha_fin)
  limit 1 offset 0;

  return v_fecha_incremento;

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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;