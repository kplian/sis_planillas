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
   DESCRIP: Calcula columnas básicas que necesitan estar definidas en esta funcion
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
BEGIN

    v_nombre_funcion = 'plani.f_plapri_insert_empleados_etr';
    v_filtro_uo = '';
	
    -- en primas ponemos la gestion por la cual vamos a pagar la prima
    -- la fecha de la plnilla de prima es la fecha en que se va pagar
    
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


    for v_registros in execute('
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
          inner join orga.tcargo car  on car.id_cargo = uofun.id_cargo
          inner join orga.ttipo_contrato tc  on car.id_tipo_contrato = tc.id_tipo_contrato
          inner join orga.toficina ofi  on car.id_oficina = ofi.id_oficina
          where 
             tc.codigo in (''PLA'', ''EVE'') and 
             UOFUN.tipo = ''oficial'' and '
          	|| v_filtro_uo 
            || ' coalesce(uofun.fecha_finalizacion,''' || v_fecha_fin_planilla || ''') >= (''01/04/' || v_planilla.gestion ||''')::date and
              uofun.fecha_asignacion <=  '''|| '31/12/' || v_planilla.gestion || ''' and
              uofun.estado_reg != ''inactivo'' and 
              uofun.id_funcionario not in (
                                            select id_funcionario
                                            from plani.tfuncionario_planilla fp
                                            inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                            where fp.id_funcionario = uofun.id_funcionario and
                                                  p.id_tipo_planilla = ' || v_planilla.id_tipo_planilla || ' and
                                                  p.id_gestion = ' || v_planilla.id_gestion || ')
           order by 
                uofun.id_funcionario, 
                uofun.fecha_asignacion desc')loop
                
    	v_entra = 'si';
        
        --si el empleado se retiro entre abril y  diciembre no entral en la planilla de prima
        -- cuando lso empelados son despedidos no reciben prima
        if (exists ( select 1 from orga.tuo_funcionario uofun
        			 where 
                           uofun.id_funcionario = v_registros.id_funcionario 
                      and  uofun.estado_reg = 'activo' 
                      and  uofun.fecha_finalizacion BETWEEN ('01/01/' || v_planilla.gestion)::date and  ('31/12/' || v_planilla.gestion)::date 
                      and  uofun.observaciones_finalizacion = 'retiro' )) then
                      
        	v_entra = 'no';
            
    	end if;
        
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
         
        -- NOTA un empleado puede tern mas de un contato en el año 
        -- sele considera el contrao con mas de 90 dias trabajados
        -- peros solo uno de ellos, el ultimos con m as de 90 dias trabajados
        
        if v_id_funcionario != v_registros.id_funcionario then
        
              v_id_funcionario = v_registros.id_funcionario;
              
              --si tiene mas de 90 dias trabajados y no fue despedido
              if (v_dias > 90  and v_entra = 'si') then
                  
                      -- recupera afp, cuenta bancaria y tipo de contrato
                      
                      v_id_afp = plani.f_get_afp(v_registros.id_funcionario, v_registros.fecha_fin);
                      v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, ('31/12/'||v_planilla.gestion)::date);
                      v_tipo_contrato = plani.f_get_tipo_contrato(v_registros.id_uo_funcionario);
                      
                      
                      -- inserta el empelado en la planilla
                      
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
                      
                      v_dias = 0;
                      
                      --inserta  la collumnas confiugardas en la planilla para el empleado
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
          
        --  si el empelado no fue registrado bandera = 0, 
        -- y tiene mas de 90 dias su contrato y no fue despedido
        elsif v_dias > 90  and v_entra = 'si' and v_bandera = 0 then
              
              -- recupera afp, cuenta bancaria y tipo de contrato
              v_id_afp = plani.f_get_afp(v_registros.id_funcionario, v_registros.fecha_fin);
              v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, ('31/12/'||v_planilla.gestion)::date);
              v_tipo_contrato = plani.f_get_tipo_contrato(v_registros.id_uo_funcionario);
              
              --inserta funcionario a la planilla
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
              
              v_dias = 0;

              --inserta  la columnas configuradas para el empleado
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