CREATE OR REPLACE FUNCTION plani.f_calculo_retroactivo_presupuestaria (
  p_id_planilla integer
)
RETURNS void AS
$body$
	/*Obtiene la afp asignada a un empleado a la fecha indicada y devuelve el id_funcionario_afp*/
DECLARE

    v_id_afp				integer;
    v_nombre_empleado		text;
    v_resp	            	varchar;
    v_nombre_funcion      	text;
    v_mensaje_error       	text;
    v_consulta				varchar;
    v_funcionario			record;
    v_asignacion			record;
    v_codigo_pres			varchar = '';
    v_cont_pres				integer = 0;
BEGIN
	v_nombre_funcion = 'plani.f_calculo_retroactivo_presupuestaria';


    create temp table tt_plani_filtro (
    	id_uo_funcionario integer
    ) on commit drop;



   /* v_consulta = 'insert into tt_af_filtro
                select afij.id_activo_fijo
                from kaf.tactivo_fijo afij
                inner join kaf.tclasificacion cla
                on cla.id_clasificacion = afij.id_clasificacion
                where '||v_parametros.filtro;

    execute(v_consulta);*/

    /*for v_funcionario in select tf.* from orga.tfuncionario tf where tf.estado_reg != 'inactivo' loop
    	for v_asignacion in select from orga.tuo_funcionario tuo where tuo.id_funcionario = v_funcionario.id_funcionario loop
        	if((v_asignacion.fecha_finalizacion between '1/1/2018'::date and '31/7/2018'::date) or v_asignacion.fecha_finalizacion is null) then
            	insert into tt_plani_filtro(
                	id_uo_funcionario
                ) values (
                	v_asignacion.id_uo_funcionario
                );
            end if;

        end loop;
    end loop;*/

    for v_funcionario in select
                            --vf.desc_funcionario1,
                            --vf.id_funcionario,
                            tuo.id_uo_funcionario,
                            tuo.fecha_asignacion,
                            tuo.fecha_finalizacion,
                            tuo.tipo,
                            --tcon.nombre,
                            --vcp.descripcion as categoria_prog,
                            ttc.codigo as codigo_pres,
                            ttc.descripcion as presupuesto
                          from plani.tplanilla tp
                          inner join plani.tfuncionario_planilla tfp on tfp.id_planilla = tp.id_planilla
                          --inner join plani.thoras_trabajadas tht on tht.id_funcionario_planilla = tfp.id_funcionario_planilla
                          --inner join plani.tcolumna_valor tcv on tcv.id_funcionario_planilla = tfp.id_funcionario_planilla
                          --inner join plani.tcolumna_detalle tcd on tcd.id_columna_valor = tcv.id_columna_valor
                          --inner join orga.vfuncionario vf on vf.id_funcionario = tfp.id_funcionario
                          inner join orga.tuo_funcionario tuo on tuo.id_funcionario = tfp.id_funcionario and
                          ((tuo.fecha_finalizacion between '1/1/2018'::date and '31/7/2018'::date) or tuo.fecha_finalizacion is null)
                          inner join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuo.id_cargo and tcp.id_gestion =  (select tg.id_gestion from param.tgestion tg where tg.gestion = extract(year from tuo.fecha_asignacion))
                          --inner join orga.tcargo tca on tca.id_cargo = tcp.id_cargo
                          --inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = tca.id_tipo_contrato

                          inner join param.tcentro_costo tcc on tcc.id_centro_costo = tcp.id_centro_costo
                          inner join param.ttipo_cc ttc on ttc.id_tipo_cc = tcc.id_tipo_cc

                          --INNER JOIN pre.tpresupuesto	tpre ON tpre.id_presupuesto = tcc.id_centro_costo
                          --INNER JOIN pre.vcategoria_programatica vcp ON vcp.id_categoria_programatica = tpre.id_categoria_prog
                          where tp.id_planilla = 527 and tuo.tipo = 'oficial' and tuo.estado_reg = 'activo' loop

    	if(v_codigo_pres != v_funcionario.codigo_pres)then
        	v_codigo_pres = v_funcionario.codigo_pre;
            v_cont_pres  = v_cont_pres + 1;
        	insert into tt_plani_filtro(
            	id_uo_funcionario
            ) values (
            	v_asignacion.id_uo_funcionario
            );
        end if;
    end loop;



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