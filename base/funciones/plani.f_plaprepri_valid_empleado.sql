-- FUNCTION: plani.f_plasue_valid_empleado(integer, integer, integer, character varying, character varying)

-- DROP FUNCTION plani.f_plasue_valid_empleado(integer, integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION plani.f_plaprepri_valid_empleado(
	p_id_usuario integer,
	p_id_funcionario integer,
	p_id_planilla integer,
	p_forzar_cheque character varying,
	p_finiquito character varying,
	OUT o_id_funcionario_planilla integer,
	OUT o_tipo_contrato character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
  v_registros			record;
  v_planilla			record;
  v_id_funcionario_planilla	integer;
  v_columnas			record;
  v_resp	            varchar;
  v_nombre_funcion      text;
  v_mensaje_error       text;
  v_filtro_uo			varchar;
  v_existe				varchar;  
  v_tipo_planilla		record;
  v_id_columna_valor	integer;
  v_detalle		record;
BEGIN
	
    v_nombre_funcion = 'plani.f_plaprepri_valid_empleado';
   
	v_existe = 'no';
	select id_tipo_planilla, p.id_gestion, ges.fecha_ini, ges.fecha_fin, p.id_uo, p.id_usuario_reg,
    p.id_tipo_planilla, p.fecha_planilla
    into v_planilla 
    from plani.tplanilla p
    inner join param.tgestion ges
    	on p.id_gestion = ges.id_gestion
    where p.id_planilla = p_id_planilla;
    
        
    for v_registros in execute('
          WITH base_query as (
                   SELECT uofun.id_funcionario,
                          uofun.id_uo_funcionario,
                          ofi.id_lugar,
                          plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) AS fecha_primer_cont,
                          
                          (CASE
                             WHEN plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion) < '''||v_planilla.fecha_ini||''' THEN '''||v_planilla.fecha_ini||'''
                             ELSE plani.f_get_fecha_primer_contrato_empleado(NULL,uofun.id_funcionario, uofun.fecha_asignacion)
                           END) AS fecha_ini,
                          
                          (CASE
                             WHEN (uofun.fecha_finalizacion IS NULL OR  uofun.fecha_finalizacion > '''||v_planilla.fecha_fin||''') THEN '''||v_planilla.fecha_fin||'''
                             ELSE uofun.fecha_finalizacion
                           END) AS fecha_fin,
                          uofun.fecha_asignacion AS fecha_ini_real,
                          COALESCE(uofun.fecha_finalizacion,''3000-01-01'') AS fecha_fin_real,
                          uofun.tipo,
                          car.id_tipo_contrato,
                          uofun.fecha_asignacion,
                          uofun.fecha_finalizacion
                   FROM orga.tuo_funcionario uofun
                        INNER JOIN orga.tfuncionario fun ON fun.id_funcionario =
                          uofun.id_funcionario
                        INNER JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
                        INNER JOIN orga.toficina ofi ON car.id_oficina = ofi.id_oficina
                        inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato=car.id_tipo_contrato and tcon.codigo in (''PLA'',''EVE'')
                   WHERE uofun.estado_reg != ''inactivo''
                         AND uofun.tipo = ''oficial'' 
                        and uofun.id_funcionario='||p_id_funcionario||' and
                          uofun.fecha_asignacion  <= '''||v_planilla.fecha_planilla||'''  --para filtrar solo la asinacion anterioa la fecha de pago
                         
                          and  uofun.id_funcionario not in (
                                                                                select id_funcionario
                                                                                from plani.tfuncionario_planilla fp
                                                                                inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
                                                                                where fp.id_funcionario = uofun.id_funcionario and
                                                                                      p.id_tipo_planilla = '||v_planilla.id_tipo_planilla||' and
                                                                                      p.id_gestion = '||v_planilla.id_gestion||')
                   ORDER BY uofun.id_funcionario,
                            fecha_primer_cont DESC,
                            fecha_fin_real DESC,
                            uofun.id_uo_funcionario DESC
                            
                            )
                    SELECT DISTINCT ON (id_funcionario) id_funcionario,
                           id_uo_funcionario,
                           id_lugar,
                           fecha_ini,
                           fecha_fin,
                           fecha_ini_real,
                           fecha_fin_real,
                           tipo,
                           id_tipo_contrato,
                           plani.f_get_dias_aguinaldo(id_funcionario, fecha_ini, fecha_fin) dias,
                           fecha_fin - fecha_ini
                    FROM base_query ') loop
          
          select tp.*,p.id_gestion,p.estado into v_tipo_planilla
        	from plani.tplanilla p
        	inner join plani.ttipo_planilla tp
        		on tp.id_tipo_planilla = p.id_tipo_planilla
        	where p.id_planilla = p_id_planilla;
          
          --Sentencia de la insercion
        	insert into plani.tfuncionario_planilla(
			finiquito,
			forzar_cheque,
			id_funcionario,
			id_planilla,
			id_lugar,
			id_uo_funcionario,
			estado_reg,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            id_afp,
            id_cuenta_bancaria,
            tipo_contrato
          	) values(
			p_finiquito,
			p_forzar_cheque,
			p_id_funcionario,
			p_id_planilla,
			v_registros.id_lugar,
			v_registros.id_uo_funcionario,
			'activo',
			p_id_usuario,
			now(),
			null,
			null,
            plani.f_get_afp(p_id_funcionario, v_planilla.fecha_fin),
            plani.f_get_cuenta_bancaria_empleado(p_id_funcionario, v_planilla.fecha_fin),
            v_registros.tipo_contrato
							
			)RETURNING id_funcionario_planilla into o_id_funcionario_planilla;
			
			o_tipo_contrato = v_registros.tipo_contrato;
			
			for v_columnas in (	select * 
        					from plani.ttipo_columna 
                            where id_tipo_planilla = v_tipo_planilla.id_tipo_planilla and estado_reg = 'activo'  order by orden) loop
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
		                p_id_usuario,
		                'activo',
		                v_columnas.id_tipo_columna,
		                o_id_funcionario_planilla,
		                v_columnas.codigo,
		                v_columnas.formula,
		                0,
		                0
		              )returning id_columna_valor into v_id_columna_valor;
                      
                      --registrando el detalle en caso de ser necesario  
                if (v_columnas.tiene_detalle = 'si')then
                	for v_detalle in (	
                    	select ht.id_horas_trabajadas
                    	from plani.tplanilla p
                    	inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                    	inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                    	inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                    	where fp.id_funcionario = p_id_funcionario and  tp.codigo = 'PLASUE' and
                    	ht.estado_reg = 'activo' and p.id_gestion = v_tipo_planilla.id_gestion) loop
                        
                        INSERT INTO 
                            plani.tcolumna_detalle
                          (
                            id_usuario_reg,  
                            id_horas_trabajadas,
                            id_columna_valor,
                            valor,
                            valor_generado
                          ) 
                          VALUES (
                            p_id_usuario,  
                            v_detalle.id_horas_trabajadas,
                            v_id_columna_valor,
                            0,
                            0
                          );
                          
                    end loop;
                end if; 
        end loop;
		
        if (v_tipo_planilla.estado in ('calculo_columnas', 'registro_horas'))then
        	
        	execute 'select * from ' || v_tipo_planilla.funcion_calculo_horas || '(' ||
        						 p_id_planilla || ', '||p_id_usuario  || ', '|| o_id_funcionario_planilla||')'
        	into v_resp;
        
        end if;
    		
        v_existe = 'si';
            
  			  	
    end loop;
    if (v_existe = 'no') then
    	raise exception 'No se puede añadir el funcionario a la planilla ya que no tiene una asignacion de cargo para el periodo o ya esta incluido en otra planilla';
    end if;
    return;
EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$BODY$;

ALTER FUNCTION plani.f_plasue_valid_empleado(integer, integer, integer, character varying, character varying)
    OWNER TO postgres;