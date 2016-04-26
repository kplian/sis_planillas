CREATE OR REPLACE FUNCTION plani.f_conta_relacionar_cuentas (
  p_id_planilla integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
DECLARE
  v_registros		record;
  v_resp	            	varchar;
  v_nombre_funcion      	text;
  v_mensaje_error       	text;
  v_planilla				record;
  v_consulta				varchar;
  v_config					record;
  v_codigo_relacion			varchar;
  
BEGIN
	v_nombre_funcion = 'plani.f_conta_relacionar_cuentas';
    select pla.*,(select po_id_gestion from param.f_get_periodo_gestion(pla.fecha_planilla)) as id_gestion_contable
    into v_planilla
    from plani.tplanilla pla
    where pla.id_planilla = p_id_planilla;
	--Generamos  cuenta, auxiliar y partida para obligaciones     
    for v_registros in (select o.*,tipo.nombre as tipo_obligacion
                        from plani.tobligacion o
                        inner join plani.ttipo_obligacion tipo on tipo.id_tipo_obligacion = o.id_tipo_obligacion
                        where id_planilla = v_planilla.id_planilla and o.estado_reg = 'activo')loop
          
         SELECT 
          ps_id_partida,ps_id_cuenta,ps_id_auxiliar 
        into 
          v_config 
        FROM conta.f_get_config_relacion_contable('CUEOBLI', v_planilla.id_gestion_contable, v_registros.id_tipo_obligacion,
         NULL, 'No se encontro relación contable para la obligacion: '||v_registros.tipo_obligacion ||'. <br> Mensaje: ');
               
         update plani.tobligacion SET
           id_cuenta=v_config.ps_id_cuenta,
           id_auxiliar=v_config.ps_id_auxiliar,
           id_partida=v_config.ps_id_partida
         where id_obligacion = v_registros.id_obligacion;
               
         if (v_registros.id_afp is not null) THEN
            SELECT 
              ps_id_cuenta,ps_id_auxiliar 
            into 
              v_config 
            FROM conta.f_get_config_relacion_contable('CUEAFP', v_planilla.id_gestion_contable, v_registros.id_afp,
             NULL, 'No se encontro relación contable para la afp: '||v_registros.id_afp ||'. <br> Mensaje: ');
                   
             update plani.tobligacion SET                   
               id_auxiliar=v_config.ps_id_auxiliar
             where id_obligacion = v_registros.id_obligacion;
         end if;
    end loop;  
    
    --Generamos  cuenta, auxiliar y partida para consolidado_columna     
    for v_registros in (select cc.*,c.id_presupuesto,c.id_cc,tc.nombre as nombre_columna
                        from plani.tconsolidado_columna cc
                        inner join plani.tconsolidado c  on c.id_consolidado = cc.id_consolidado
                        inner join plani.ttipo_columna tc on tc.id_tipo_columna = cc.id_tipo_columna
                        where c.id_planilla = v_planilla.id_planilla and cc.estado_reg = 'activo')loop
          
         if (v_registros.tipo_contrato = 'PLA') then
         	v_codigo_relacion = 'CUETIPCOLPLA';
         else
         	v_codigo_relacion = 'CUETIPCOLEVE';
         end if;
         
         SELECT 
          ps_id_partida,ps_id_cuenta,ps_id_auxiliar 
        into 
          v_config 
        FROM conta.f_get_config_relacion_contable(v_codigo_relacion, v_planilla.id_gestion_contable, v_registros.id_tipo_columna,
         v_registros.id_presupuesto, 'No se encontro relación contable para la columna: '||v_registros.nombre_columna ||'. <br> Mensaje: ');
               
         update plani.tconsolidado_columna SET
           id_cuenta=v_config.ps_id_cuenta,
           id_auxiliar=v_config.ps_id_auxiliar,
           id_partida=v_config.ps_id_partida
         where id_consolidado_columna = v_registros.id_consolidado_columna;               
         
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