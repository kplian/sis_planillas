--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_plaguin_insert_empleados_etr (
  p_id_planilla integer
)
RETURNS varchar AS
$body$
 /**************************************************************************
   PLANI
  ***************************************************************************
   SCRIPT:
   COMENTARIOS:
   AUTOR: Jaim Rivera (Kplian)
   DESCRIP: Calcula columnas básicas que necesitan estar definidas en esta funcion
   Fecha: 27/01/2014


    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               27/01/2014       Jaim Rivera (Kplian)    Creacion 
 #63              22-02-2020       Rarteaga     KPLIAN     refactorizacion plnailla aguinlados, comentarios, etc
 #110             26/03/2020       RArteaga     KPLIAN     considerar funcionarios segun sus ultimos tres meses de trabajo       
 ********************************************************************************/
 
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
  v_fecha_ini			date;
  v_entra				varchar;
  v_fecha_fin_planilla	date;
  v_dias				integer;
  v_tipo_contrato		varchar;
  v_base_query          varchar; --#63
  
BEGIN
	
    v_nombre_funcion = 'plani.f_plaguin_insert_empleados';     
    
    v_filtro_uo = '';
	
    select p.id_tipo_planilla, 
           per.id_periodo, 
           ges.fecha_ini,
           ges.fecha_fin, 
           p.id_uo, 
    	   p.id_usuario_reg,
           p.fecha_planilla,
           ges.gestion,
           p.id_gestion,
           p.id_tipo_contrato
    into v_planilla 
    from plani.tplanilla p
    left join param.tperiodo per
    	on p.id_periodo = per.id_periodo
    inner join param.tgestion ges
    	on ges.id_gestion = p.id_gestion
    where p.id_planilla = p_id_planilla;
    
    --#110 la fecha para ahcer los calculor siempre es el 31 de diciembre
    -- no importa si la planilla se calcula y pago el el 4 de diciembre (cualquier fecha antes del 31 de diciembre)
    -- se calcula e pago seun ultimos 90 dias
    -- pero solo se considera los funcionarios vigentes al 31 de diciembre
    v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date;        
    
    
    
    --si es necesario filtra los miembro de una determinada UO o por determinado tipo de contrato
       
    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is not null) then
    	v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and tc.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;

    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is null) then
    	v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;

    if (v_planilla.id_tipo_contrato is not null and v_planilla.id_uo is null)then
       v_filtro_uo = 'tc.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;
    
    --TODO anaizar como incluir solo al persona con contrato vigente 
    --     que no se le aya apagado el aguinaldo en el finiquito
    -- con fecha de finalizacion nulll o mayor a la fecha  de fnalizacion mayor a la fecha de planilla
    -- e personacola con fecha de finalizacion se asumi que que le dieorn el aguinaldo en el finiquito
        
    
    
    v_base_query =' SELECT  
                       distinct on (uofun.id_funcionario) uofun.id_funcionario , 
                       uofun.id_uo_funcionario,
                       ofi.id_lugar,
                       uofun.fecha_asignacion as fecha_ini,
                       (case when (   uofun.fecha_finalizacion is null 
                                   or uofun.fecha_finalizacion > ''' || v_fecha_fin_planilla || ''') then 
                          ''' || v_fecha_fin_planilla || ''' 
                        else 
                          uofun.fecha_finalizacion 
                        end
                       ) as fecha_fin,
                       uofun.fecha_finalizacion as fecha_fin_real 
                    FROM orga.tuo_funcionario uofun
                    INNER JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
                    INNER JOIN orga.ttipo_contrato tc ON car.id_tipo_contrato = tc.id_tipo_contrato  
                    INNER JOIN orga.toficina ofi ON car.id_oficina = ofi.id_oficina 
                    WHERE 
                             tc.codigo in (''PLA'', ''EVE'') 
                         AND UOFUN.tipo = ''oficial'' 
                         AND ' || v_filtro_uo || ' 
                             coalesce(uofun.fecha_finalizacion, ''' || v_fecha_fin_planilla || ''') >= (''31/03/' || v_planilla.gestion ||''')::date 
                         AND uofun.fecha_asignacion <=  '''|| '31/12/' || v_planilla.gestion || ''' 
                         AND uofun.estado_reg != ''inactivo'' 
                         AND uofun.id_funcionario not in (
                                                          SELECT id_funcionario
                                                          FROM plani.tfuncionario_planilla fp
                                                          JOIN plani.tplanilla p ON p.id_planilla = fp.id_planilla
                                                          WHERE   fp.id_funcionario = uofun.id_funcionario 
                                                                AND p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' 
                                                                AND p.id_gestion = ' || v_planilla.id_gestion || ')
                    ORDER BY uofun.id_funcionario, uofun.fecha_asignacion DESC';
        --raise notice '%',v_base_query;  
        
     
     
        
     for v_registros in execute(v_base_query)loop
    	
     -------------------------------------------------------------------------------------------
     -- solo entran los empleado con contrato vigente  a la fecha de la planilla
     -- (feha finalizacion real igual a NULL or fecha de finalizacion mayor a la planilla)
     -- OJO analizar caso de otras empresa esto puede cambiar y se peude customizar otra funcion
     --------------------------------------------------------------------------------------------
        
        --por defecto ninguno entra
        v_entra = 'no';
                
        if (     v_registros.fecha_fin_real is null 
              or v_registros.fecha_fin_real >= v_fecha_fin_planilla 
            )then                
            v_entra = 'si';                
        end if;
            
        -- recuepra cuantos dias de aguinadol tiene e empleado
        -- si el contrato no es consecutivo solo se considera el utimo
        
        v_dias = plani.f_get_dias_aguinaldo(v_registros.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin);
        
        
        --solo se paga a empleados con por lo menos 90 dias trabajados
        
        if (v_dias >= 90  and v_entra = 'si') then
        	
            v_id_afp = plani.f_get_afp(v_registros.id_funcionario, v_planilla.fecha_planilla);
        	v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_planilla);
            v_tipo_contrato = plani.f_get_tipo_contrato(v_registros.id_uo_funcionario);  
            
            
            INSERT INTO plani.tfuncionario_planilla (
                id_usuario_reg,					estado_reg,					id_funcionario,
                id_planilla,					id_uo_funcionario,			id_lugar,
                forzar_cheque,					finiquito,					id_afp,
                id_cuenta_bancaria,				tipo_contrato)
            VALUES (
                v_planilla.id_usuario_reg,		'activo',					v_registros.id_funcionario,
                p_id_planilla,					v_registros.id_uo_funcionario,v_registros.id_lugar,
                'no',							'no',						v_id_afp,
                v_id_cuenta_bancaria,			v_tipo_contrato)
            RETURNING id_funcionario_planilla into v_id_funcionario_planilla;
            
            --inserta la columnas configuradas para planilla de aguinaldos por cada empleado
            
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
        end if;
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
PARALLEL UNSAFE
COST 100;