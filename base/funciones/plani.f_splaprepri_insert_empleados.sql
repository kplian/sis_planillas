-- FUNCTION: plani.f_splaprepri_insert_empleados(integer)

-- DROP FUNCTION plani.f_splaprepri_insert_empleados(integer);

CREATE OR REPLACE FUNCTION plani.f_splaprepri_insert_empleados(
	p_id_planilla integer)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
   PLANI
  ***************************************************************************
   SCRIPT:
   COMENTARIOS:
   AUTOR: 
   DESCRIP:  inserta a todo el personal al cual le corresponde pago de prima para la gestion
   Fecha: 16-04-2020 


    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #145             02-07-2020       Mzambrana-KPLIAN         funcion de insercion de funcionarios para planilla de primas Simple
 #ETR-2467		  08.01.2021		MZM-KPLIAN				Adicion de condicion para considerar funcionarios con licencia (Caso Wilder Ureña)
 #ETR-2544		  13.01.2021		MZM-KPLIAN				Cambio en condicion de 90 dias, solo funcionarios que acumulen mas de 90 dias entran a planilla de prevision, se omite los de 90
 ********************************************************************************/
DECLARE
  v_registros            record;
  v_planilla            record;
  v_id_funcionario_planilla    integer;
  v_columnas            record;
  v_resp                varchar;
  v_nombre_funcion      text;
  v_mensaje_error       text;
  v_filtro_uo            varchar;
  v_id_afp                integer;
  v_id_cuenta_bancaria    integer;
  v_fecha_ini            date;
  v_entra                varchar;
  v_fecha_fin_planilla    date;
  v_dias                integer = 0;
  v_tipo_contrato        varchar;
  v_id_funcionario        integer = 0;
  v_bandera                integer;
  v_main_query          varchar; 
  
  v_fecha_ini_gestion	date;
  v_fecha_fin_gestion	date;
  --#ETR-2467
  v_motivo				varchar;
BEGIN

    v_nombre_funcion = 'plani.f_splaprepri_insert_empleados';
    v_filtro_uo = '';
    
    -- en planillas de prima ponemos la gestion por la cual vamos a pagar la prima
    -- la fecha de la planilla de prima es la fecha en que se va pagar
    -- la planilla de prima tiene costeo por que es solo el pago
    -- cada mes se provisiona en planilla de ajuste de beneficios sociales , en ese momento ejecuta presupeusto y aplica costeo
    -- el descuento de RC-IVA se lo realiza en la siguiente planilla de sueldos
    
    
    
    select 
           p.id_tipo_planilla, 
           per.id_periodo, 
           ges.fecha_ini, 
           ges.fecha_fin, 
           p.id_uo,
           p.id_usuario_reg,
           p.fecha_planilla,
           ges.gestion,
           p.id_gestion,
           p.id_tipo_contrato
           ,p.id_tipo_planilla 
         into v_planilla
    from plani.tplanilla p
    left join param.tperiodo per on p.id_periodo = per.id_periodo
    inner join param.tgestion ges on ges.id_gestion = p.id_gestion
    where p.id_planilla = p_id_planilla; 


    v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date; --se recupera la fecha del ulitmo dia la gestion que vamos a pagar
	v_fecha_ini_gestion = v_planilla.fecha_ini;
    v_fecha_fin_gestion = v_planilla.fecha_fin;
    --si es necesario filtra los miembro de una determinada UO o por determinado tipo de contrato
       
    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is not null) then
        v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and tc.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;

    if (v_planilla.id_uo is not null and v_planilla.id_tipo_contrato is null) then
        v_filtro_uo = ' uofun.id_uo in (' || orga.f_get_uos_x_planilla(v_planilla.id_uo) || ','|| v_planilla.id_uo ||') and ';
    end if;

    if (v_planilla.id_tipo_contrato is not null and v_planilla.id_uo is null)then
       v_filtro_uo = 'tcon.id_tipo_contrato in (' ||v_planilla.id_tipo_contrato||') and ';
    end if;
    
    
    ------------------------------------------------------------------------------------------------------
    -- si el empleado ya no trabaja en la empresa  
    -- no se lo condeira en esta planilla
    -- por que no podemos retenerle el RC-IVA en la siguiente planilla de pago normal
    -----------------------------------------------------------------------------------------------------    
    
    v_main_query = 'WITH base_query as (SELECT distinct uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          ofi.id_lugar, tcon.nombre 
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario
                        INNER JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
                        INNER JOIN orga.toficina ofi ON car.id_oficina = ofi.id_oficina
                        inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and tcon.codigo in (''PLA'',''EVE'')
                   WHERE uofun.estado_reg != ''inactivo''
                         AND uofun.tipo = ''oficial''
                         and 
                         uofun.fecha_asignacion  <= '''||v_planilla.fecha_planilla||'''  --para filtrar solo la asinacion anterioa la fecha de pago
                         
                         and  uofun.id_funcionario not in (
                                                                                select id_funcionario
                                                                                from plani.tfuncionario_planilla fp
                                                                                inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                                                                where fp.id_funcionario = uofun.id_funcionario and
                                                                                      p.id_tipo_planilla = '||v_planilla.id_tipo_planilla||' and
                                                                                      p.id_gestion = '||v_planilla.id_gestion||')
                   ORDER BY uofun.id_funcionario,
                            uofun.id_uo_funcionario DESC
                            )
                    SELECT DISTINCT ON (id_funcionario) id_funcionario,
                    id_uo_funcionario,
                    id_lugar, nombre
                    ,plani.f_get_dias_efectivos_prima(id_funcionario, '''||v_fecha_ini_gestion||''','''||v_fecha_fin_gestion||''') as dias_efectivos
                    FROM base_query
                    ';
     
    raise notice 'llega--> %',v_main_query;               
    for v_registros in execute(v_main_query)loop
                
   			  --#ETR-2467
              --obtener el motivo finalizacion previa a su incorporacion del funcionario, en caso de ser licencia, entonces si le corresponde aunq no tenga 90 dias
              v_motivo:=(select observaciones_finalizacion from orga.tuo_funcionario 
              where id_funcionario=v_registros.id_funcionario and id_uo_funcionario<v_registros.id_uo_funcionario
              and estado_reg='activo' and tipo='oficial'
              order by fecha_finalizacion desc limit 1);
              --#ETR-2544
              if (v_registros.dias_efectivos > 90 or (v_registros.dias_efectivos <= 90 and v_motivo='licencia') ) then
                    
                    v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_planilla); --recuperamos la cuenta bancaria a la fecha de la planilla (fecha de pago)
                    v_tipo_contrato = plani.f_get_tipo_contrato(v_registros.id_uo_funcionario);
                      
                      
                      -- inserta el empelado en la planilla
                      
                      INSERT INTO plani.tfuncionario_planilla (
                          id_usuario_reg,                    estado_reg,                    id_funcionario,
                          id_planilla,                        id_uo_funcionario,            id_lugar,
                          forzar_cheque,                    finiquito,                    id_afp,
                          id_cuenta_bancaria,                tipo_contrato)
                      VALUES (
                          v_planilla.id_usuario_reg,        'activo',                        v_registros.id_funcionario,
                          p_id_planilla,                    v_registros.id_uo_funcionario,  v_registros.id_lugar,
                          'no',                                'no',                            v_id_afp,
                          v_id_cuenta_bancaria,                 v_tipo_contrato)
                       RETURNING id_funcionario_planilla into v_id_funcionario_planilla;
                      
                      v_dias = 0;
                      
                      --inserta  la columnas configuradas en la planilla para el empleado
                      for v_columnas in (    select *
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
$BODY$;

ALTER FUNCTION plani.f_splaprepri_insert_empleados(integer)
    OWNER TO postgres;