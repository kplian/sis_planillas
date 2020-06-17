-- FUNCTION: plani.f_obtener_fechas_prima(integer, character varying)

-- DROP FUNCTION plani.f_obtener_fechas_prima(integer, character varying);

CREATE OR REPLACE FUNCTION plani.f_obtener_fechas_prima(
	p_id_funcionario_planilla integer,
	p_codigo character varying)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:      Sistema de Planillas
 FUNCION:      plani.f_reporte_funcionario_sel
 DESCRIPCION:  
 AUTOR:        (EGS)
 FECHA:        27/06/2019
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #135	ETR				12.06.2020			MZM-KPLIAN			Reporte de prevision de primas (detalle), modificacion funcion CTOO1
**************************************************************************/

 DECLARE
    v_resp                    varchar;
    v_nombre_funcion          text;
    v_mensaje_error           text;
    v_registros					record;
    v_planilla				record;
    v_resultado					text;
     BEGIN
    v_nombre_funcion = 'plani.f_obtener_fechas_prima';
    v_resultado = 0;
    select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;
    v_resultado:='#@@@#';
    IF (p_codigo = 'CTTO1') THEN  -- 
    
    	
    	SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) > v_planilla.fecha_fin THEN null
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) as fecha_primer_ctto,
                          
                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) as fecha_fin_ctto
                           into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario
                          
                      WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
						-- and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario  --#135
 						 and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','') 
 						 order by uofun.id_uo_funcionario limit 1 offset 0
                      ;  
      			   if not exists (select 1 from orga.tuo_funcionario  where id_funcionario=v_registros.id_funcionario
                            and fecha_asignacion>=v_registros.fecha_fin_ctto and estado_reg='activo' and tipo='oficial'
                            ) then
                                v_resultado:='#@@@#';
                   else
                   
                         if( (plani.f_get_dias_aguinaldo(v_registros.id_funcionario, v_planilla.fecha_ini, v_registros.fecha_fin_ctto))>= 90 )then
                   			v_resultado:=v_registros.fecha_primer_ctto||'#@@@#'||v_registros.fecha_fin_ctto;         
                         else v_resultado:='#@@@#';
                         end if;
                            
                   end if;
                            
    ELSIF (p_codigo = 'CTTO2') THEN                   
                      
    		SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) > v_planilla.fecha_fin THEN null
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) as fecha_primer_ctto,
                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  plani.f_es_funcionario_vigente(fun.id_funcionario, v_planilla.fecha_planilla) ) THEN '3000-01-01'
                             ELSE uofun.fecha_finalizacion
                           END) as fecha_fin_ctto
                           into v_registros
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario
                          
                     WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario


						  and 
                          (plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)< v_planilla.fecha_fin)
                          order by plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) desc ,uofun.fecha_asignacion desc
                          limit 1
                      ;
    
		    	v_resultado:=v_registros.fecha_primer_ctto||'#@@@#'||v_registros.fecha_fin_ctto; 
    
    
    END IF;
     return coalesce (v_resultado, '#@@@#');
    EXCEPTION

    WHEN OTHERS THEN
      v_resp='';
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
      raise exception '%',v_resp;

  END;
$BODY$;

ALTER FUNCTION plani.f_obtener_fechas_prima(integer, character varying)
    OWNER TO ukplian;
