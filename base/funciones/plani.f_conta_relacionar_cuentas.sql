CREATE OR REPLACE FUNCTION plani.f_conta_relacionar_cuentas (
  p_id_planilla integer,
  p_id_usuario integer
)
RETURNS varchar AS
$body$
/*
*
*  Autor:   JRR
*  DESC:    funcion que actualiza los estados despues del registro de un siguiente en planilla
*  Fecha:   17/10/2014
*
 ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               17/10/2014        JRR KPLIAN        Creación
 #1 ETR           24/01/2019        RAC KPLIAN        agrega cuenta contable, relaciones contables debe y haber configurables

*/
DECLARE
  v_registros		record;
  v_resp	            	varchar;
  v_nombre_funcion      	text;
  v_mensaje_error       	text;
  v_planilla				record;
  v_consulta				varchar;
  v_config					record;
  v_config_haber			record;
  v_codigo_relacion			varchar;
  v_id_relacion             integer;
  v_id_auxiliar             integer;
  v_id_auxiliar_haber       integer;
  
BEGIN
	v_nombre_funcion = 'plani.f_conta_relacionar_cuentas';
    select pla.*,(select po_id_gestion from param.f_get_periodo_gestion(pla.fecha_planilla)) as id_gestion_contable
    into v_planilla
    from plani.tplanilla pla
    where pla.id_planilla = p_id_planilla;
	--Generamos  cuenta, auxiliar y partida para obligaciones     
    for v_registros in ( select o.*,tipo.nombre as tipo_obligacion_desc, tipo.tipo_obligacion, tipo.codigo_tipo_relacion_debe, tipo.codigo_tipo_relacion_haber
                        from plani.tobligacion o
                        inner join plani.ttipo_obligacion tipo on tipo.id_tipo_obligacion = o.id_tipo_obligacion
                        where id_planilla = v_planilla.id_planilla and o.estado_reg = 'activo')loop
                        
                   
         --#1  define el id para buscar la relacion contable
         IF v_registros.tipo_obligacion = 'pago_afp'  THEN
            v_id_relacion = v_registros.id_afp;   
         ELSE
            v_id_relacion = v_registros.id_tipo_obligacion;   --Por defecto ubscamos 
         END IF;
        
        --#1 recupera relaciones contables para el debe 
        SELECT 
          ps_id_partida,ps_id_cuenta,ps_id_auxiliar 
        into 
          v_config                                            
        FROM conta.f_get_config_relacion_contable(  v_registros.codigo_tipo_relacion_debe, 
                                                    v_planilla.id_gestion_contable, 
                                                    v_id_relacion,
                                                    NULL, 
                                                    'No se encontro relación contable para la obligacion: '||v_registros.tipo_obligacion_desc ||'. <br> Mensaje: ');
         
         
        --#1 recupera relaciones contable para el haber 
        SELECT 
          ps_id_partida,ps_id_cuenta,ps_id_auxiliar 
        into 
          v_config_haber 
        FROM conta.f_get_config_relacion_contable(v_registros.codigo_tipo_relacion_haber, v_planilla.id_gestion_contable, v_id_relacion,
        NULL, 'No se encontro relación contable para la obligacion: '||v_registros.tipo_obligacion_desc ||'. <br> Mensaje: ');
        
        
        -- #1   recuperamos el auxiliar del funcionario
        IF v_registros.tipo_obligacion = 'una_obligacion_x_empleado'  THEN
          
           select 
               f.id_auxiliar into v_id_auxiliar
           from  orga.tfuncionario f
           where f.id_funcionario =   v_registros.id_funcionario;
           
           v_id_auxiliar_haber = v_id_auxiliar; 
           
        ELSE
           v_id_auxiliar = v_config.ps_id_auxiliar;
           v_id_auxiliar_haber = v_config_haber.ps_id_auxiliar;
        END IF;
        
        
         update plani.tobligacion SET
           id_cuenta          = v_config.ps_id_cuenta,
           id_auxiliar        = v_id_auxiliar,
           id_partida         = v_config.ps_id_partida,
           id_cuenta_haber    = v_config_haber.ps_id_cuenta,
           id_auxiliar_haber  = v_id_auxiliar_haber,
           id_partida_haber   = v_config_haber.ps_id_partida
         where id_obligacion  = v_registros.id_obligacion;
               
        
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
