CREATE OR REPLACE FUNCTION plani.f_get_dias_licencia_funcionario (
  p_id_funcionario integer,
  p_fecha date
)
  RETURNS integer AS
  $body$
  /*Obtiene la cuenta bancaria de un empleado a la fecha indicada y devuelve el id_funcionario_cuenta_bancaria*/
  DECLARE
    v_fecha_ini_lic	date;
    v_fecha_fin_lic	date;
    v_fecha_ini_mes	date;
    v_fecha_fin_mes	date;
    v_gestion 		numeric;
    v_meses			integer;
    v_dias			integer;
    v_nombre_funcion	varchar;
    v_resp				varchar;
    v_dias_en_mes		integer;
    v_total_dias		integer;
    v_registros			record;
  BEGIN
    v_nombre_funcion = 'plani.f_get_dias_licencia_funcionario';
    v_total_dias = 0;

    for v_registros in (select *
                        from plani.tlicencia l
                        where l.id_funcionario = p_id_funcionario and l.estado = 'finalizado'
                              and l.desde <= p_fecha) loop
      v_dias = 0;
      v_fecha_ini_lic = v_registros.desde;
      v_fecha_fin_lic = (case when v_registros.hasta > p_fecha then p_fecha else v_registros.hasta end);
      /*if ((extract(month from v_fecha_fin_lic)::integer - extract(month from v_fecha_ini_lic)::integer) = 0) then
        if ((v_fecha_fin_lic - v_fecha_ini_lic) = 30) then
              return 30;
            else
              return (v_fecha_fin_lic - v_fecha_ini_lic) + 1;
            end if;
      end if;
      --verificar si la fecha de inicio de la licencia es inicio de mes
      v_fecha_ini_mes = date_trunc('month',v_fecha_ini_lic);

        --si la fecha inicio no es inicio de mes tomo el mes siguiente
        if (v_fecha_ini_mes != v_fecha_ini_lic) then
          v_fecha_ini_mes =   date_trunc('month',v_fecha_ini_lic + interval '1 month');
        end if;
         --verificar si la fecha de fin de la licencia es fin de mes
        v_fecha_fin_mes = date_trunc('month',v_fecha_fin_lic) + interval '1 month' - interval '1 day';

        --si la fecha fin no es fin de mes tomo el mes anterior
        if (v_fecha_fin_mes != v_fecha_fin_lic) then
          v_fecha_fin_mes =   date_trunc('month',v_fecha_fin_lic) - interval '1 day';
        end if;

        --obtengo la cantidad de meses
        if (v_fecha_fin_mes > v_fecha_ini_mes) then
          v_meses = date_part('month',age(v_fecha_fin_mes, v_fecha_ini_mes)) + 1;
        else
          v_meses = 0;
        end if;
        --obtengo la licencia al inicio
        if (v_fecha_ini_mes != v_fecha_ini_lic) then
          v_dias = 30 - extract(day from v_fecha_ini_lic)::integer + 1;
        end if;

        --obtengo la licencia al final
        if (v_fecha_fin_mes != v_fecha_fin_lic) then
          v_dias = v_dias + extract(day from v_fecha_fin_lic)::integer;
        end if;*/

      v_total_dias = v_total_dias + pxp.f_get_dias_mes_30(v_fecha_ini_lic,v_fecha_fin_lic);

      --v_total_dias = v_total_dias + (v_meses * 30) + v_dias;

    end loop;
    return v_total_dias;

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