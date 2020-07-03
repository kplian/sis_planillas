-- FUNCTION: pxp.f_get_dias_mes_30(date, date)

-- DROP FUNCTION pxp.f_get_dias_mes_30(date, date);

CREATE OR REPLACE FUNCTION plani.f_get_dias_efectivos_prima(p_id_funcionario integer,
	p_fecha_ini date,
	p_fecha_fin date)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:		plani
 FUNCION: 		plani.f_get_dias_efectivos_prima
 DESCRIPCION:   Devuelve la cantidad de dias efectivos por gestion
 AUTOR: 		mzm
 FECHA:	        01.07.2020
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE
  v_dias	 	integer;
  v_meses		integer;
  v_anos		integer;
  v_fecha_ini	date;
  v_fecha_fin	date;
  v_registros	record;
BEGIN
  	if (p_fecha_fin < p_fecha_ini) then
    	raise exception 'La fecha inicio no puede ser mayor que la fecha fin ****%', p_id_funcionario;
    end if;
    v_dias = 0;
    

    for v_registros in (
    select fun.id_funcionario, uofun.fecha_asignacion,uofun.fecha_finalizacion,
    			pxp.f_get_dias_mes_30(to_date( pxp.f_iif (uofun.fecha_asignacion < p_fecha_ini,p_fecha_ini||'',uofun.fecha_asignacion||''),'YYYY-mm-dd') , to_date( pxp.f_iif (coalesce(uofun.fecha_finalizacion,p_fecha_fin) >=p_fecha_fin,p_fecha_fin||'',uofun.fecha_finalizacion||''),'YYYY-mm-dd')) as dias

               from orga.tuo_funcionario uofun
               inner join orga.tfuncionario fun on fun.id_funcionario=uofun.id_funcionario
               INNER JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
               inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and tcon.codigo in ('PLA','EVE')
               where fun.id_funcionario=p_id_funcionario and uofun.estado_reg='activo'
                and uofun.tipo='oficial'
                  and uofun.fecha_asignacion<p_fecha_fin
                  and coalesce(uofun.fecha_finalizacion,p_fecha_fin) >p_fecha_ini
				order by uofun.fecha_asignacion) loop
                raise notice '--------*******%', p_id_funcionario;
           v_dias:=v_dias+  v_registros.dias;   
    end loop;
   return v_dias;

END;
$BODY$;

ALTER FUNCTION plani.f_get_dias_efectivos_prima(integer,date, date)
OWNER TO postgres;