-- FUNCTION: plani.f_inserta_detalle_obligaciones(character varying, integer, integer)

-- DROP FUNCTION plani.f_inserta_detalle_obligaciones(character varying, integer, integer);

CREATE OR REPLACE FUNCTION plani.f_inserta_detalle_obligaciones(
	p_nombre_tabla character varying,
	p_id_tipo_obligacion integer,
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
   AUTOR: Jaim Rivera (Kplian)
   DESCRIP:  inserta el detalle de obligacion de apgo de planilla
   Fecha: 27/01/2014

    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               27/01/2014        GUY BOA             Creacion 
 #7               13-05-2019        Rarteaga            considera la obligacion de pago contable (no tiene prorrateo de costos) al validar pago de obligaciones
 #153			  21.07.2020		MZM-KPLIAN			Considerar el cambio que se pueda hacer en funcionario_planilla (opcion forzar_cheque), para que en las obligaciones que son por banco, se genere una obligacion de cheque
 ********************************************************************************/
DECLARE
	v_planilla			   record;
    v_sql				   text;
    v_resp	               varchar;
    v_registros			   record;
    v_nombre_funcion       text;
    v_mensaje_error        text;
    v_columnas_pago		   text;
    v_columnas_presupuesto text;
    v_nombre_obligacion	   varchar;
    v_suma_pago				numeric;
    v_suma_detalle			numeric;
    v_tipo_contrato			varchar;
    v_join_ht				varchar;
    v_max_tipo_columna		integer;
    v_consulta				varchar;
    v_suma_detalle_si		numeric;
    v_valor_columna_resta	numeric;
    v_suma_pago_contable    numeric; --#7

BEGIN
	select * into v_planilla
    from plani.tplanilla p
    inner join plani.ttipo_planilla tp
    	on tp.id_tipo_planilla = p.id_tipo_planilla
    where p.id_planilla = p_id_planilla;
    
    
    /*
    --#7 la tabla temporal tiene la siguiente estrcutura 
    
    CREATE TEMPORARY TABLE 
    		(	id_tipo_obligacion INTEGER,
            	id_funcionario INTEGER,
                nombre_funcionario TEXT,
                id_funcionario_planilla INTEGER,
                id_presupuesto INTEGER,
                id_cc INTEGER,
                tipo_contrato VARCHAR(10),
                id_tipo_columna INTEGER,
                codigo_columna VARCHAR(30),
                porcentaje NUMERIC,
                valor NUMERIC,
                es_ultimo VARCHAR(2),
                id_lugar INTEGER,
                nombre_lugar VARCHAR(100),
                id_afp INTEGER,
                nombre_afp VARCHAR(300),
                nro_afp VARCHAR(100),
                nombre_banco VARCHAR(100),
                id_institucion INTEGER,
                nro_cuenta VARCHAR,
                compromete VARCHAR(15)
  			) ON COMMIT DROP
    
    
    */

	v_nombre_funcion = 'plani.f_inserta_detalle_obligaciones';
	--inserta el detalle de los pagos presupuestarios en la tabla temporal para las obligaciones indicadas
 
    if (v_planilla.tipo_presu_cc = 'parametrizacion' ) then
    	v_tipo_contrato = 'ht.tipo_contrato';
        v_join_ht = 'inner join plani.thoras_trabajadas ht
                  on ht.id_horas_trabajadas = pro.id_horas_trabajadas
              inner join plani.tfuncionario_planilla fp
                  on fp.id_funcionario_planilla = ht.id_funcionario_planilla';
    else
    	v_tipo_contrato = 'fp.tipo_contrato';
        v_join_ht = '
              inner join plani.tfuncionario_planilla fp
                  on fp.id_funcionario_planilla = pro.id_funcionario_planilla';
    end if;

    EXECUTE('INSERT into ' || p_nombre_tabla || '
    		 select 	
                  toc.id_tipo_obligacion,
                  fp.id_funcionario,
                  fun.desc_funcionario2 as nombre_funcionario,
                  fp.id_funcionario_planilla,
                  pro.id_presupuesto,	
                  pro.id_cc, 
                  ' || v_tipo_contrato ||',
                  cv.id_tipo_columna,
                  cv.codigo_columna,
                  procol.porcentaje,
                  cv.valor*procol.porcentaje/100 as valor,
                  toc.es_ultimo,
                  lug.id_lugar, 
                  lug.nombre as nombre_lugar, 
                  afp.id_afp ,
                  afp.nombre as nombre_afp, 
                  fafp.nro_afp,
                  ins.nombre as nombre_banco,
                  ins.id_institucion, 
                  (case when fp.forzar_cheque=''si'' then ''''
                  else 
                  fcu.nro_cuenta
                  end) as nro_cuenta, --#153
                  
                  tc.compromete

              from plani.tprorrateo pro
              ' || v_join_ht || '
              inner join plani.tcolumna_valor cv
                  on cv.id_funcionario_planilla = fp.id_funcionario_planilla
              inner join plani.ttipo_columna tc
                  on tc.id_tipo_columna = cv.id_tipo_columna
              inner join plani.ttipo_obligacion_columna toc
                  on toc.codigo_columna = cv.codigo_columna and toc.id_tipo_obligacion = ' || p_id_tipo_obligacion || ' and toc.presupuesto = ''si''
              inner join plani.tprorrateo_columna procol
                  on procol.id_prorrateo = pro.id_prorrateo and procol.id_tipo_columna = cv.id_tipo_columna
              inner join param.tlugar lug
                  on lug.id_lugar = fp.id_lugar
              left join plani.tfuncionario_afp fafp
                  on fafp.id_funcionario_afp = fp.id_afp
              left join plani.tafp afp
                  on afp.id_afp = fafp.id_afp
              inner join orga.vfuncionario fun
                  on fun.id_funcionario = fp.id_funcionario
              left join orga.tfuncionario_cuenta_bancaria fcu
                  on fcu.id_funcionario_cuenta_bancaria = fp.id_cuenta_bancaria
              left join param.tinstitucion ins
                  on ins.id_institucion = fcu.id_institucion
              where fp.id_planilla = ' || p_id_planilla);

     -- solo entra al for si existe una tipo_cobligacion_columna que se reste en el ultimo pago
     if (exists (	select 1
     				from plani.ttipo_obligacion_columna toc
                    where id_tipo_obligacion = p_id_tipo_obligacion and
                    	toc.es_ultimo = 'si' and toc.presupuesto = 'si')) then
        --Se recorre todos los registros para actualizar el monto presupeustario a pagar en caso de ser por resta
        for v_registros in (SELECT fp.id_funcionario_planilla, sum(coalesce(cv.valor,0.00)) as suma_pago
                from plani.tfuncionario_planilla fp
                inner join plani.tcolumna_valor cv on fp.id_funcionario_planilla = cv.id_funcionario_planilla
                inner join plani.ttipo_obligacion_columna toc
                      on toc.codigo_columna = cv.codigo_columna and toc.id_tipo_obligacion = p_id_tipo_obligacion and toc.pago = 'si'
                where fp.id_planilla = p_id_planilla
                group by fp.id_funcionario_planilla)loop

                --sumar los montos registrados para pago por funcionario menos los ultimos
                execute('	select coalesce(sum(valor))
                			from ' || p_nombre_tabla || '
                            where id_funcionario_planilla = ' || v_registros.id_funcionario_planilla || '
                            	  and id_tipo_obligacion = ' || p_id_tipo_obligacion || '
                            		and es_ultimo = ''no''') into v_suma_detalle;

                --si es mas de una ultima columna entonces obtner cual es el valor mas grande
                execute ('	select id_tipo_columna,valor
                			from ' || p_nombre_tabla || '
                            where id_funcionario_planilla = ' || v_registros.id_funcionario_planilla || '
                            	and id_tipo_obligacion = ' || p_id_tipo_obligacion || '
                            		and es_ultimo = ''si''  and valor >= 0
                            order by valor desc
                            limit 1') into v_max_tipo_columna,v_valor_columna_resta;
                -- Si existe una columna de resta cuyo valor es mayor a 0
                if (v_max_tipo_columna is not null)then
                	--Si la columna de resta es mayor o igual a la obligacion cubrimos el total con la columna de resta
                	IF (v_valor_columna_resta >= v_registros.suma_pago) THEN
                    	execute('	update  ' || p_nombre_tabla || '
                        				set valor = 0
                                    where id_funcionario_planilla = ' || v_registros.id_funcionario_planilla || '
                                          and id_tipo_obligacion = ' || p_id_tipo_obligacion || '
                                            and es_ultimo = ''si'' and id_tipo_columna != ' || v_max_tipo_columna);
                    --sino cubrimos parte con la columna de resta menor y lo sobrante con la columna de resta mayor
                    else
                       --sumar los montos registrados para pago por funcionario que son ultimos pero no seran calculados por diferencia

                        execute('	select coalesce(sum(valor),0)
                                    from ' || p_nombre_tabla || '
                                    where id_funcionario_planilla = ' || v_registros.id_funcionario_planilla || '
                                          and id_tipo_obligacion = ' || p_id_tipo_obligacion || '
                                            and es_ultimo = ''si'' and id_tipo_columna != ' || v_max_tipo_columna) into v_suma_detalle_si;
                        v_suma_detalle = v_suma_detalle + v_suma_detalle_si;
                    end if;

                    --actualizar el monto de pago para el ultimo tipo columna de la resta del total a pagar
                    --menos la suma de montos menos el ultimo y multiplicar por el porcentaje
                	execute('	update ' || p_nombre_tabla || '
                                set valor = ' || v_registros.suma_pago - coalesce(v_suma_detalle, 0.00) || ' * porcentaje/100
                                where id_funcionario_planilla = ' || v_registros.id_funcionario_planilla || '
                                and id_tipo_obligacion = ' || p_id_tipo_obligacion || '
                                and es_ultimo = ''si'' and id_tipo_columna = ' || v_max_tipo_columna );
                end if;

        end loop;
     end if;
     --Validar si la suma de pagos es igual a la suma de detalles

      SELECT sum(cv.valor) into v_suma_pago
      from plani.tfuncionario_planilla fp
      inner join plani.tcolumna_valor cv on fp.id_funcionario_planilla = cv.id_funcionario_planilla
      inner join plani.ttipo_obligacion_columna toc
            on toc.codigo_columna = cv.codigo_columna and toc.id_tipo_obligacion = p_id_tipo_obligacion and toc.pago = 'si'
      where fp.id_planilla = p_id_planilla;
      
      --#7 condiera los pagos contable para la valicion de la boligacion
    SELECT coalesce(sum(cv.valor), 0)
    into v_suma_pago_contable
      from plani.tfuncionario_planilla fp
      inner join plani.tcolumna_valor cv on fp.id_funcionario_planilla = cv.id_funcionario_planilla
      inner join plani.ttipo_obligacion_columna toc
            on toc.codigo_columna = cv.codigo_columna and toc.id_tipo_obligacion = p_id_tipo_obligacion and toc.pago = 'si_contable'
      where fp.id_planilla = p_id_planilla;
      
      

      EXECUTE('select coalesce(sum(valor), 0.00)
              from ' || p_nombre_tabla
              || ' where id_tipo_obligacion = ' || p_id_tipo_obligacion) into v_suma_detalle;
              
              
 	--raise exception ' p_nombre_tabla -> %, v_suma_pago: %, v_suma_detalle: %',p_nombre_tabla, v_suma_pago, v_suma_detalle;
     
      if (round(v_suma_pago,2) <> round((v_suma_detalle + v_suma_pago_contable), 2)) then
      	select tob.nombre
        into v_nombre_obligacion
        from plani.ttipo_obligacion tob
        where id_tipo_obligacion = p_id_tipo_obligacion;
      	 raise exception 'Los montos presupuestarios no igualan a los montos de pago para la obligacion: %, diferencia: %, v_suma_pago: %, v_suma_detalle: %',v_nombre_obligacion,round(v_suma_pago,2) - round((v_suma_detalle + v_suma_pago_contable),2), v_suma_pago, v_suma_detalle;
      end if;

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

ALTER FUNCTION plani.f_inserta_detalle_obligaciones(character varying, integer, integer)
    OWNER TO postgres;