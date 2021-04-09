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
 #ETR-2467				11.01.2021			MZM-KPLIAN			Modificacion para CTTO1, considerando todos los contratos antes del vigente ya que se tiene que considerar la suma de contratos para verificar si llegan a 90 dias
 #ETR-3610				09.04.2021			MZM-KPLIAN			Modificacion 
**************************************************************************/

 DECLARE
    v_resp                    varchar;
    v_nombre_funcion          text;
    v_mensaje_error           text;
    v_registros					record;
    v_planilla				record;
    v_resultado					text;
    v_fecha_ini	date;
    v_fecha_fin	date;
    v_dias	integer;
    v_tope	integer;
     BEGIN
    v_nombre_funcion = 'plani.f_obtener_fechas_prima';
    v_resultado = 0; v_dias:=0;
    v_fecha_ini=null;
    select p.fecha_planilla, fp.id_funcionario, fp.id_uo_funcionario, g.fecha_ini, g.fecha_fin , p.nro_planilla
        into v_planilla
        from plani.tfuncionario_planilla fp
        inner join plani.tplanilla p on p.id_planilla=fp.id_planilla
        inner join param.tgestion g on g.id_gestion=p.id_gestion
        where fp.id_funcionario_planilla=p_id_funcionario_planilla;
    v_resultado:='#@@@#';
    IF (p_codigo = 'CTTO1') THEN  -- 
    
    
   /* v_tope:=(select count (*) from orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario
                          
                      WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
						 --and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario  --#135
 						 and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','') 
 						 );*/
    	
    --#ETR-2467
    /* if (plani.f_es_funcionario_vigente(v_planilla.id_funcionario,v_planilla.fecha_planilla)=false) then
     --if no exist un contrato posterior al ultimo encontrado significa que debemos reducir el ultimo registro, pues debe ir como ctto 2
     
       
            v_tope:=v_tope-1;
      
     end if;*/
     for v_registros in (	SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) > v_planilla.fecha_fin THEN null
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) as fecha_primer_ctto,
                          
                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > v_planilla.fecha_fin) THEN v_planilla.fecha_fin
                             ELSE uofun.fecha_finalizacion
                           END) as fecha_fin_ctto
                          
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario
                          
                      WHERE uofun.estado_reg != 'inactivo'
                         AND uofun.tipo = 'oficial'
                         and uofun.id_funcionario=v_planilla.id_funcionario
						 --and uofun.id_uo_funcionario!=v_planilla.id_uo_funcionario  --#135
 						 and uofun.fecha_finalizacion between v_planilla.fecha_ini and v_planilla.fecha_fin
                         and uofun.observaciones_finalizacion not in ('transferencia','promocion','') 
 						 order by uofun.id_uo_funcionario 
                         )loop
                            
                         if  exists (select 1 from orga.tuo_funcionario  where id_funcionario=v_planilla.id_funcionario
                            and fecha_asignacion>=v_registros.fecha_fin_ctto and estado_reg='activo' and tipo='oficial'
                            and fecha_asignacion between v_planilla.fecha_ini and v_planilla.fecha_fin 
                            
                            ) then 
                            if v_fecha_ini is null then v_fecha_ini:= v_registros.fecha_primer_ctto; end if;

                                v_fecha_fin:= v_registros.fecha_fin_ctto;                            
                            end if; 
							       
                         end loop;
                         

                      v_resultado:=v_fecha_ini||'#@@@#'||v_fecha_fin;    
                     
                         
                         
                            
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
    OWNER TO postgres;
