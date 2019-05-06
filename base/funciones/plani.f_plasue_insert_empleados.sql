CREATE OR REPLACE FUNCTION plani.f_plasue_insert_empleados (
  p_id_planilla integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.f_plasue_insert_empleados
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tplanilla'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2014 16:11:04
 COMENTARIOS:
***************************************************************************
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#5	ETR				30/04/2019			kplian MMV			Registrar planilla por tipo de contrato
***************************************************************************/
DECLARE
  v_registros			record;
  v_planilla			record;
  v_id_funcionario_planilla	integer;
  v_columnas			record;
  v_resp	            varchar;
  v_nombre_funcion      text;
  v_mensaje_error       text;
  v_filtro_uo			varchar;
  v_id_afp				integer;
  v_id_cuenta_bancaria	integer;
  v_licencia			boolean;
  v_aux 				varchar;
BEGIN

    v_nombre_funcion = 'plani.f_plasue_insert_empleados';
    v_filtro_uo = '';
	select id_tipo_planilla, per.id_periodo, fecha_ini, fecha_fin, id_uo, p.id_usuario_reg,p.id_tipo_contrato
    into v_planilla
    from plani.tplanilla p
    inner join param.tperiodo per
    	on p.id_periodo = per.id_periodo
    where p.id_planilla = p_id_planilla;
	----------#5---------------
    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is not null) then
    	v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and tc.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;

    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is null) then
    	v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;

    if (v_planilla.id_tipo_contrato is not null and v_planilla.id_uo is null)then
        	v_filtro_uo = 'tc.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;
    ----------#5---------------

    for v_registros in execute('select distinct on (uofun.id_funcionario) uofun.id_funcionario , uofun.id_uo_funcionario,ofi.id_lugar,car.id_cargo,tc.codigo as tipo_contrato
              from orga.tuo_funcionario uofun
              inner join orga.tcargo car
                  on car.id_cargo = uofun.id_cargo
              inner join orga.ttipo_contrato tc
                  on car.id_tipo_contrato = tc.id_tipo_contrato
              left join orga.toficina ofi
                  on car.id_oficina = ofi.id_oficina
              where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and '
                || v_filtro_uo || ' uofun.fecha_asignacion <= ''' || v_planilla.fecha_fin || ''' and
                  (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= ''' || v_planilla.fecha_ini || ''') AND
                  uofun.estado_reg != ''inactivo'' and uofun.id_funcionario not in (
                      select id_funcionario
                    from plani.tfuncionario_planilla fp
                    inner join plani.tplanilla p
                        on p.id_planilla = fp.id_planilla
                    where 	fp.id_funcionario = uofun.id_funcionario and
                            p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                            p.id_periodo = ' || v_planilla.id_periodo || ')
            order by uofun.id_funcionario, uofun.fecha_asignacion desc')loop
    	v_id_afp = plani.f_get_afp(v_registros.id_funcionario, v_planilla.fecha_fin);
        v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_fin);
        --v_licencia = plani.f_get_licencia(v_registros.id_funcionario, v_planilla.fecha_fin);


        if (v_registros.id_lugar is null) then
        	raise exception 'El cargo con identificador:% , no tiene una oficina asignada',v_registros.id_cargo;
        end if;

        --if(not v_licencia)then
          INSERT INTO plani.tfuncionario_planilla (
              id_usuario_reg,					estado_reg,					id_funcionario,
              id_planilla,					id_uo_funcionario,			id_lugar,
              forzar_cheque,					finiquito,					id_afp,
              id_cuenta_bancaria,				tipo_contrato)
          VALUES (
              v_planilla.id_usuario_reg,		'activo',					v_registros.id_funcionario,
              p_id_planilla,					v_registros.id_uo_funcionario,v_registros.id_lugar,
              'no',							'no',						v_id_afp,
              v_id_cuenta_bancaria,			v_registros.tipo_contrato)
          RETURNING id_funcionario_planilla into v_id_funcionario_planilla;

          for v_columnas in (	select *
                              from plani.ttipo_columna
                              where id_tipo_planilla = v_planilla.id_tipo_planilla and estado_reg = 'activo' order by orden) loop
              INSERT INTO
                  plani.tcolumna_valor
                (
                  id_usuario_reg,
                  estado_reg,
                  id_tipo_columna,
                  id_funcionario_planilla,
                  codigo_columna,
                  formula,
                  valor,
                  valor_generado
                )
                VALUES (
                  v_planilla.id_usuario_reg,
                  'activo',
                  v_columnas.id_tipo_columna,
                  v_id_funcionario_planilla,
                  v_columnas.codigo,
                  v_columnas.formula,
                  0,
                  0
                );


          end loop;
        --end if;
      end loop;


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