--------------- SQL ---------------

CREATE OR REPLACE FUNCTION plani.f_plapri_insert_empleados_etr (
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
   DESCRIP:  inserta solo personal vigente que tiene derechi a prima la gestion pasada
   Fecha: 16-10-2019 


    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #68              16-10-2019       Rarteaga     KPLIAN     refactorizacion plnailla primas
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
  v_dias				integer = 0;
  v_tipo_contrato		varchar;
  v_id_funcionario		integer = 0;
  v_bandera				integer;
  v_main_query          varchar; 
BEGIN

    v_nombre_funcion = 'plani.f_plapri_insert_empleados_etr';
    v_filtro_uo = '';
	
    -- en planillas de prima ponemos la gestion por la cual vamos a pagar la prima
    -- la fecha de la planilla de prima es la fecha en que se va pagar
    -- con la fecha de la plailla recuepramos las hojas de trabajo para costeo
    
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
    into 
      v_planilla
    from plani.tplanilla p
    left join param.tperiodo per on p.id_periodo = per.id_periodo
    inner join param.tgestion ges on ges.id_gestion = p.id_gestion
    where p.id_planilla = p_id_planilla; 


    v_fecha_fin_planilla = ('31/12/' || v_planilla.gestion)::date; --se recupera la fecha del ulitmo dia la gestion que vamos a pagar

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
    
    
    ------------------------------------------------------------------------------------------------------
    --si el empleado ya no trabaja en la empresa  
    -- no se lo condeira en esta planilla
    -- por que no podemos retenerle el RC-IVA en la siguiente planilla de pago normal
    -----------------------------------------------------------------------------------------------------    
    
    
    v_main_query = 'WITH empleados_vigentes as 

                      (
                         SELECT 
                                 uofun.id_funcionario,
                                 plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)  as fecha_primer_cont
                         FROM  orga.tuo_funcionario uofun
                                inner join orga.tcargo car  on car.id_cargo = uofun.id_cargo
                                inner join orga.ttipo_contrato tc  on car.id_tipo_contrato = tc.id_tipo_contrato         
                                where 
                                         tc.codigo in (''PLA'', ''EVE'')
                                   and   UOFUN.tipo = ''oficial''
                                   and  uofun.estado_reg != ''inactivo''
                                   and ' || v_filtro_uo  || '   
                                       ( 
                                                uofun.fecha_finalizacion is null 
                                             or uofun.fecha_finalizacion  >= (''' || v_planilla.fecha_planilla || ''')::date  
                                        ) 
                      )

                      select  
                                     uofun.id_funcionario , 
                                     uofun.id_uo_funcionario,
                                     ofi.id_lugar,
                                     uofun.fecha_asignacion as fecha_ini,
                                     (case when (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion > ''' || v_fecha_fin_planilla || ''') then
                                      ''' || v_fecha_fin_planilla || '''
                                      else
                                         uofun.fecha_finalizacion
                                      end) as fecha_fin,
                                      uofun.fecha_finalizacion as fecha_fin_real
                                
                                from orga.tuo_funcionario uofun
                                INNER join empleados_vigentes vig on vig.id_funcionario = uofun.id_funcionario --este join filtra usarios vigente
                                inner join orga.tcargo car  on car.id_cargo = uofun.id_cargo          
                                inner join orga.toficina ofi  on car.id_oficina = ofi.id_oficina
                                where 
                                   
                                        vig.fecha_primer_cont <=  ''' || v_fecha_fin_planilla || '''   --la fecha del primer contrato consecutivo tiene que ser menor al ultimo dia del año de la prima
                                   and  uofun.fecha_asignacion <= vig.fecha_primer_cont -- incluir solo las asignacion desde el primer contrato vigente      
                                   and  uofun.id_funcionario not in (
                                                                  select id_funcionario
                                                                  from plani.tfuncionario_planilla fp
                                                                  inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                                                  where fp.id_funcionario = uofun.id_funcionario and
                                                                        p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                                                                        p.id_gestion = ' || v_planilla.id_gestion || ') --el funcionario no tiene que estar registrado en ninguna planilal de prima
                                 order by 
                                      uofun.id_funcionario, 
                                      uofun.fecha_asignacion desc';

     raise notice  'consulta %  <-----------',v_main_query;

    for v_registros in execute(v_main_query)loop
                
    	v_entra = 'si';
        v_bandera = 0;
        
              
        --cuenta cuantos dias de ultimo contrato vigente del funcionario la gestion pasada
        v_dias = plani.f_get_dias_aguinaldo(v_registros.id_funcionario, v_registros.fecha_ini, v_registros.fecha_fin);

        
        -- cuenta cuantas veces el empelado aparece en alguna planilla  de prima para la misma gestion
        select 
            count(tfp.id_funcionario_planilla)
        into 
           v_bandera
        from plani.tfuncionario_planilla tfp
        inner join plani.tplanilla tp on tp.id_planilla = tfp.id_planilla
        inner join plani.ttipo_planilla ttp on ttp.id_tipo_planilla = tp.id_tipo_planilla
        where 
                    tfp.id_funcionario = v_registros.id_funcionario 
                and tp.id_gestion = v_planilla.id_gestion 
                and ttp.codigo = 'PLAPRI'; 
         
      
        
              v_id_funcionario = v_registros.id_funcionario;
              
              -- si tiene mas de 90 en la gestion pasada
              -- esta vigente y no fue registrado aun en planilal de primas
              
              if (v_dias > 90  and v_entra = 'si' and v_bandera = 0) then
                  
                      -- recupera afp, cuenta bancaria y tipo de contrato
                      
                      v_id_afp = plani.f_get_afp(v_registros.id_funcionario, v_planilla.fecha_planilla);  --recuperamos la AFP a la fecha de la palnilla (fecha de pago)
                      v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_planilla.fecha_planilla); --recuperamos la cuenta bancaria a la fecha de la planilla (fecha de pago)
                      v_tipo_contrato = plani.f_get_tipo_contrato(v_registros.id_uo_funcionario);
                      
                      
                      -- inserta el empelado en la planilla
                      
                      INSERT INTO plani.tfuncionario_planilla (
                          id_usuario_reg,					estado_reg,					id_funcionario,
                          id_planilla,					    id_uo_funcionario,			id_lugar,
                          forzar_cheque,					finiquito,					id_afp,
                          id_cuenta_bancaria,				tipo_contrato)
                      VALUES (
                          v_planilla.id_usuario_reg,		'activo',					    v_registros.id_funcionario,
                          p_id_planilla,					v_registros.id_uo_funcionario,  v_registros.id_lugar,
                          'no',							    'no',						    v_id_afp,
                          v_id_cuenta_bancaria,			     v_tipo_contrato)
                       RETURNING id_funcionario_planilla into v_id_funcionario_planilla;
                      
                      v_dias = 0;
                      
                      --inserta  la columnas configuradas en la planilla para el empleado
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
COST 100;