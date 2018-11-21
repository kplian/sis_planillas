CREATE OR REPLACE FUNCTION plani.f_get_dias_aguinaldo_v2 (
  p_id_funcionario integer,
  p_id_gestion integer
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.f_get_dias_aguinaldo_v2
 DESCRIPCION:   Funcion que devuelve el total de dias trabajados de un funcionario
 AUTOR: 		F.E.A
 FECHA:	        3/9/2018 04:53:54
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE
    v_fecha_ini_emp		date;
    v_fecha_fin_emp		date;
    v_fecha_ini 		date;
    v_fecha_fin			date;

    v_nombre_funcion	varchar;
    v_resp				varchar;
    v_registro			record;
    v_bandera			boolean = true;
    v_bandera_unit		boolean = false;
    v_continuo			integer = 0;
    v_id_uo_funcionario	integer = -1;

    v_cadena			varchar='';
    v_grupos			text[];
    v_periodo_horas		varchar[];

    v_subgrupo			text[];
    v_index 			integer = 1;
    v_indexg			integer = 1;
    v_total_reg			integer;
    v_conta_reg			integer = 0;

    v_array				varchar;
    v_horas				integer;
    v_total_horas		integer = 0;
    v_periodo			integer[];
    v_subgrupo_aux		text[];
    v_indexg_aux		integer = 1;
BEGIN
	v_nombre_funcion = 'plani.f_get_dias_aguinaldo';

    for v_registro in select per.periodo, per.fecha_ini, per.fecha_fin, ht.id_uo_funcionario, fp.id_funcionario_planilla, ht.horas_normales, ht.id_horas_trabajadas
                      from plani.tfuncionario_planilla fp
                      inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                      inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                      inner join param.tperiodo per on per.id_periodo=p.id_periodo
                      inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                      and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                      and p.id_gestion=p_id_gestion and ht.estado_reg = 'activo' and fp.id_funcionario = p_id_funcionario
                      order by per.periodo desc, ht.id_uo_funcionario desc  loop


    	select tuo.fecha_asignacion, tuo.fecha_finalizacion
        into v_fecha_ini, v_fecha_fin
        from orga.tuo_funcionario tuo
        where tuo.id_uo_funcionario = v_id_uo_funcionario;

        if v_id_uo_funcionario != v_registro.id_uo_funcionario then
        	v_id_uo_funcionario = v_registro.id_uo_funcionario;
            v_bandera = true;
        end if;


        if v_bandera then

          select tuo.fecha_asignacion, tuo.fecha_finalizacion
          into v_fecha_ini_emp, v_fecha_fin_emp
          from orga.tuo_funcionario tuo
          where tuo.id_uo_funcionario = v_registro.id_uo_funcionario;

          v_bandera = false;
        end if;



        if v_continuo - v_registro.periodo < 0 then
            v_subgrupo[v_indexg] = ARRAY[v_registro.id_horas_trabajadas,v_registro.periodo];
            v_indexg = v_indexg + 1;
        else
        	if (v_continuo - v_registro.periodo) = 1 or v_fecha_ini = (v_fecha_fin_emp + interval '1 day' ) then
                 v_subgrupo[v_indexg] = ARRAY[v_registro.id_horas_trabajadas,v_registro.periodo];
                 v_indexg = v_indexg + 1;
        	elsif v_continuo - v_registro.periodo = 0 or v_continuo - v_registro.periodo > 1 then

                if array_length(v_subgrupo, 1) = 1 then
                	v_bandera_unit = true;
                    v_subgrupo_aux[v_indexg_aux] = ARRAY[v_registro.id_horas_trabajadas,v_registro.periodo];
                end if;

            	v_grupos[v_index] = v_subgrupo;
                v_index = v_index + 1;
                v_subgrupo = '{}';
                v_indexg = 1;

                if v_bandera_unit then
                    v_subgrupo[v_indexg] = v_subgrupo_aux[v_indexg_aux];
                    v_indexg = v_indexg + 1;
                	v_bandera_unit = false;
                    v_subgrupo_aux = '{}';
                end if;

                if v_continuo - v_registro.periodo = 0 then
                	v_indexg = 1;
                    v_subgrupo[v_indexg] = ARRAY[v_registro.id_horas_trabajadas,v_registro.periodo];
                    v_indexg = v_indexg + 1;
                end if;
            end if;
        end if;

	    v_continuo = v_registro.periodo;
    end loop;

    v_grupos[v_index] = v_subgrupo;

    FOREACH v_array in array v_grupos LOOP

		v_periodo_horas = replace(v_array,'"','')::integer[];

        v_index = array_length(v_periodo_horas,1);
        if v_index > 3 then
        	FOREACH v_periodo slice 1 in array v_periodo_horas LOOP
            	select ht.horas_normales
                into v_horas
                from plani.tfuncionario_planilla fp
                inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                inner join param.tperiodo per on per.id_periodo = p.id_periodo
                inner join plani.ttipo_planilla tp on tp.id_tipo_planilla=p.id_tipo_planilla
                and tp.codigo ='PLASUE' and p.estado not in ('registros_horas', 'registro_funcionarios','calculo_columnas','anulado')
                and p.id_gestion=p_id_gestion and ht.estado_reg = 'activo' and fp.id_funcionario = p_id_funcionario
                where per.periodo = v_periodo[2] and ht.id_horas_trabajadas = v_periodo[1];

                v_total_horas = v_total_horas + v_horas/8;

            END LOOP;
            EXIT;
        end if;

    END LOOP;

    return v_total_horas;
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