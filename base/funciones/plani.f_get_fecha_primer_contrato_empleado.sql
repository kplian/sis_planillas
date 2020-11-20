-- FUNCTION: plani.f_get_fecha_primer_contrato_empleado(integer, integer, date)

-- DROP FUNCTION plani.f_get_fecha_primer_contrato_empleado(integer, integer, date);
CREATE OR REPLACE FUNCTION plani.f_get_fecha_primer_contrato_empleado(
	p_id_uo_funcionario integer,
	p_id_funcionario integer,
	p_fecha_ini date)
    RETURNS date
    LANGUAGE 'plpgsql'

    COST 100
    STABLE 
AS $BODY$

/****************************************************************************
 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #ETR-1889				20.11.2020			MZM-KPLIAN			Adicion de condicion por nueva modalidad de finalziacion de contrato: licencia sin goce de haber
*****************************************************************************/
DECLARE
  v_fecha_ini				date;
  v_id_uo_funcionario		integer;
  v_resp	            	varchar;
  v_nombre_funcion      	text;
  v_mensaje_error       	text;
  v_separar_ctto			varchar;
BEGIN
  v_fecha_ini = null;
  v_separar_ctto:='no';
  v_nombre_funcion = 'plani.f_kp_get_fecha_primer_contrato_empleado';
  
      select uofun.id_uo_funcionario, uofun.fecha_asignacion, uofun.separar_contrato
      into	v_id_uo_funcionario, v_fecha_ini, v_separar_ctto
      from orga.tuo_funcionario uofun
      inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
      inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato 
      where uofun.id_funcionario = p_id_funcionario and uofun.fecha_asignacion = p_fecha_ini 
      and uofun.estado_reg != 'inactivo' and uofun.tipo = 'oficial' and tc.codigo in ('PLA','EVE');
  
  if (v_separar_ctto='si') then
  	v_fecha_ini = p_fecha_ini;
  else
      select uofun.id_uo_funcionario, uofun.fecha_asignacion
      into	v_id_uo_funcionario, v_fecha_ini
      from orga.tuo_funcionario uofun
      inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
      inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato 
      where uofun.id_funcionario = p_id_funcionario and uofun.fecha_finalizacion = p_fecha_ini - interval '1 day'
      and uofun.estado_reg != 'inactivo' and uofun.tipo = 'oficial' and tc.codigo in ('PLA','EVE');
      
      
      -- 16.11.2020 #ETR-1889
      if (v_fecha_ini is null) then -- intentar si es licencia sin goce de haber (caso Wilder Ureña)
      	 	select uofun.id_uo_funcionario, uofun.fecha_asignacion
			into v_id_uo_funcionario, v_fecha_ini
      		from orga.tuo_funcionario uofun
      		inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
      		inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato 
      		where uofun.id_funcionario = p_id_funcionario and 
	      	uofun.fecha_finalizacion<p_fecha_ini - interval '1 day' and uofun.observaciones_finalizacion='licencia'  -- licencia sin goce de haber
	        and uofun.estado_reg != 'inactivo' and uofun.tipo = 'oficial' and tc.codigo in ('PLA','EVE')
      		order by uofun.fecha_finalizacion desc limit 1;
      end if;
      
      
  end if;
  
  
  if (v_fecha_ini is not null and v_separar_ctto='no' ) then
  	v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado(v_id_uo_funcionario, p_id_funcionario, v_fecha_ini);
  else
  	v_fecha_ini = p_fecha_ini;
  end if;
  return v_fecha_ini;
EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$BODY$;

ALTER FUNCTION plani.f_get_fecha_primer_contrato_empleado(integer, integer, date)
    OWNER TO postgres;