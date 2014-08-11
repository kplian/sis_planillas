CREATE OR REPLACE FUNCTION plani.f_calcular_basica (
  p_id_funcionario_planilla integer,
  p_fecha_ini date,
  p_fecha_fin date,
  p_id_tipo_columna integer,
  p_codigo varchar
)
RETURNS numeric AS
$body$
/**************************************************************************
 PLANI
***************************************************************************
 SCRIPT:
 COMENTARIOS:
 AUTOR: Jaim Rivera (Kplian)
 DESCRIP: Calcula columnas básicas que necesitan estar definidas en esta funcion
 Fecha: 27/01/2014

*/
DECLARE
	v_resp	            	varchar;
  	v_nombre_funcion      	text;
  	v_mensaje_error       	text;	
	v_registros 			record;
	v_resultado				numeric;
    v_cantidad_horas_mes	integer;
    v_id_uo_funcionario		integer;
    v_gestion				numeric;
    v_periodo				numeric;
    v_fecha_ini				date;
    v_id_funcionario		integer;
    v_planilla				record;
    v_id_periodo_anterior	integer;
    v_fecha_fin				date;
    	
BEGIN
	v_nombre_funcion = 'plani.f_calcular_basica';
    v_resultado = 0;
    v_cantidad_horas_mes = plani.f_get_valor_parametro_valor('HORLAB', p_fecha_ini)::integer;
    
    select p.*,fp.id_funcionario into v_planilla 
    from plani.tplanilla p
    inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
    where fp.id_funcionario_planilla = p_id_funcionario_planilla;
    
    --Sueldo Básico
    IF (p_codigo = 'SUELDOBA') THEN
       	select sum(ht.sueldo / v_cantidad_horas_mes * ht.horas_normales)
        into v_resultado
        from plani.thoras_trabajadas ht
        where ht.id_funcionario_planilla = p_id_funcionario_planilla;
    
    --Horas Trabajadas
    ELSIF (p_codigo = 'HORNORM') THEN
    	select sum(ht.horas_normales)
        into v_resultado
        from plani.thoras_trabajadas ht
        where ht.id_funcionario_planilla = p_id_funcionario_planilla;
    
    --Factor de Antiguedad
    ELSIF (p_codigo = 'FACTORANTI') THEN
    	select fp.id_uo_funcionario, fp.id_funcionario, uf.fecha_asignacion
        into v_id_uo_funcionario, v_id_funcionario,v_fecha_ini
        from plani.tfuncionario_planilla fp
        inner join orga.tuo_funcionario uf on uf.id_uo_funcionario = fp.id_uo_funcionario
        where fp.id_funcionario_planilla = p_id_funcionario_planilla; 
    	
        v_fecha_ini = plani.f_get_fecha_primer_contrato_empleado(v_id_uo_funcionario, v_id_funcionario, v_fecha_ini);
       	v_gestion:= (select (date_part('year', age(p_fecha_ini, v_fecha_ini))));
       	v_periodo:= (select (date_part('month',age(p_fecha_ini, v_fecha_ini))));
   
    	v_periodo:= v_periodo + (select coalesce(antiguedad_anterior,0) from orga.tfuncionario f where id_funcionario=v_id_funcionario);

		v_periodo:=(select floor(v_periodo/12));
    	v_gestion:=v_gestion+v_periodo;
        
        select porcentaje
    	into v_resultado
    	from plani.tantiguedad
    	where v_gestion BETWEEN valor_min and valor_max;
    --Jubilado de 55
    ELSIF (p_codigo = 'JUB55') THEN
    	
        select fp.id_funcionario
        into  v_id_funcionario
        from plani.tfuncionario_planilla fp
        where fp.id_funcionario_planilla = p_id_funcionario_planilla;
    	
         select fp.id_funcionario
        into  v_id_funcionario
        from plani.tfuncionario_planilla fp
        where fp.id_funcionario_planilla = p_id_funcionario_planilla;
    	
        if (exists (select 1
			        from plani.tfuncionario_afp fa
			        where fa.estado_reg = 'activo' and fa.tipo_jubilado = 'jubilado_55' AND
			        id_funcionario = v_id_funcionario and fa.fecha_ini < p_fecha_ini and
			        (fa.fecha_fin is null or fa.fecha_fin > p_fecha_ini))) then
			v_resultado = 0;       
		else
			v_resultado = 1;
		end if;
        
    --Jubilado de 65
    ELSIF (p_codigo = 'JUB65') THEN
    	
        select fp.id_funcionario
        into  v_id_funcionario
        from plani.tfuncionario_planilla fp
        where fp.id_funcionario_planilla = p_id_funcionario_planilla;
    	
        if (exists (select 1
			        from plani.tfuncionario_afp fa
			        where fa.estado_reg = 'activo' and fa.tipo_jubilado = 'jubilado_65' AND
			        id_funcionario = v_id_funcionario and fa.fecha_ini < p_fecha_ini and
			        (fa.fecha_fin is null or fa.fecha_fin > p_fecha_ini))) then
			v_resultado = 0;       
		else
			v_resultado = 1;
		end if;
    --Factor del bono de frontera    
    ELSIF (p_codigo = 'FACFRONTERA') THEN 	
        select coalesce (sum(ht.porcentaje_sueldo),0)
        into v_resultado
        from plani.thoras_trabajadas ht
        where ht.id_funcionario_planilla = p_id_funcionario_planilla and
        		ht.frontera = 'si';
        
        v_resultado = v_resultado/100;
    --Factor actualizacion UFV  
    ELSIF (p_codigo = 'FAC_ACT') THEN 
    	v_fecha_ini:=(select pxp.f_ultimo_dia_habil_mes((p_fecha_ini- interval '1 day')::date));
    	v_fecha_fin:=(select pxp.f_ultimo_dia_habil_mes(p_fecha_fin));	
        
        v_resultado = param.f_get_factor_actualizacion_ufv(v_fecha_ini, v_fecha_fin);
    --Saldo del periodo anterior del dependiente
    ELSIF (p_codigo = 'SALDOPERIANTDEP') THEN 	
        
        v_id_periodo_anterior = param.f_get_id_periodo_anterior(v_planilla.id_periodo);
        
        
        select cv.valor into v_resultado
        from plani.tplanilla p
        inner join plani.tfuncionario_planilla fp 
        	on p.id_planilla = fp.id_planilla and fp.id_funcionario = v_planilla.id_funcionario 
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla and 
        									cv.codigo_columna = 'SALDODEPSIGPER'
        where p.id_periodo = v_id_periodo_anterior and tp.codigo = 'PLASUE';
    
    --Factor del zona franca    
    ELSIF (p_codigo = 'FAC_ZONAFRAN') THEN 	
        select coalesce (sum(ht.porcentaje_sueldo),0)
        into v_resultado
        from plani.thoras_trabajadas ht
        where ht.id_funcionario_planilla = p_id_funcionario_planilla and
        		ht.zona_franca = 'si';
        
        v_resultado = 1-(v_resultado/100);
                 
    ELSE
    	raise exception 'No hay una definición para la columna básica %',p_codigo;
	END IF;
	    
  	return coalesce (v_resultado, 0.00);
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