CREATE OR REPLACE FUNCTION plani.ft_planilla_sigma_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_planilla_sigma_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tplanilla_sigma'
 AUTOR: 		 (jrivera)
 FECHA:	        22-09-2015 14:58:50
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro			varchar;
    v_codigo_tipo_planilla	varchar;
    v_codigo_columna		varchar;
			    
BEGIN

	v_nombre_funcion = 'plani.ft_planilla_sigma_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_PLASI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		22-09-2015 14:58:50
	***********************************/

	if(p_transaccion='PLA_PLASI_SEL')then
     				
    	begin
        	if (pxp.f_existe_parametro(p_tabla,'id_periodo') = FALSE) then
            	v_filtro = 'pla.id_gestion = ' || v_parametros.id_gestion || '  and pla.id_tipo_planilla = ' || v_parametros.id_tipo_planilla;
            else
            	if (v_parametros.id_periodo is null) then
                	v_filtro = 'pla.id_gestion = ' || v_parametros.id_gestion || '  and pla.id_tipo_planilla = ' || v_parametros.id_tipo_planilla;
                else
            		v_filtro = 'pla.id_gestion = ' || v_parametros.id_gestion || ' and pla.id_periodo = ' || v_parametros.id_periodo || '  and pla.id_tipo_planilla = ' || v_parametros.id_tipo_planilla;
                end if;
            end if;
            
            
            select tp.codigo into v_codigo_tipo_planilla
            from plani.ttipo_planilla tp
            where tp.id_tipo_planilla = v_parametros.id_tipo_planilla;
            
            if (v_codigo_tipo_planilla in ('PLASUE','PLAREISU','PLAGUIN','PLAPRI','PLASEGAGUI','PLAQUIN')) then
            	v_codigo_columna = 'LIQPAG';            
            --elsif () then
            
            else
            	raise exception 'No se puede sacar el reporte de este tipo de planillas'; 
            end if;
    		--Sentencia de la consulta
            v_consulta:='	with 
            				  detalle_erp as(
                                  select fp.id_funcionario, cv.valor as liquido_erp,fp.id_uo_funcionario
                                  from plani.tplanilla pla
                                  inner join plani.tfuncionario_planilla fp on fp.id_planilla = pla.id_planilla
                                  inner join plani.tcolumna_valor cv on cv.id_funcionario_planilla = fp.id_funcionario_planilla
                                  where cv.codigo_columna = ''LIQPAG'' and cv.estado_reg = ''activo'' and 
                                  ' || v_filtro || '),
                              detalle_sigma as (
                                  select pla.id_funcionario,sum(pla.sueldo_liquido) as liquido_sigma
                                  from plani.tplanilla_sigma pla
                                  where ' || v_filtro || '
                                  group by pla.id_funcionario)
                              
                              select uo.nombre_unidad, fun.ci, tc.nombre as tipo_contrato, fun.desc_funcionario1,
                              		de.liquido_erp,ds.liquido_sigma
                              from detalle_erp de
                              left join detalle_sigma ds on de.id_funcionario = ds.id_funcionario
                              inner join orga.tuo_funcionario uofun  on uofun.id_uo_funcionario = de.id_uo_funcionario
                              inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                              inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = car.id_tipo_contrato
                              inner join orga.vfuncionario fun on fun.id_funcionario = de.id_funcionario
                              inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,now()::date)
                              where de.liquido_erp != ds.liquido_sigma or ds.liquido_sigma is null
                              
                              union all 
                              
                              select NULL::varchar, fun.ci, NULL::varchar, fun.desc_funcionario1,
                              		NULL::numeric,ds.liquido_sigma
                              from detalle_sigma ds
                              inner join orga.vfuncionario fun on fun.id_funcionario = ds.id_funcionario
                              where ds.id_funcionario not in (select id_funcionario from detalle_erp)';
			raise notice '%',v_consulta;
			
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_PLASI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		22-09-2015 14:58:50
	***********************************/

	elsif(p_transaccion='PLA_PLASI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_planilla_sigma)
					    from plani.tplanilla_sigma plasi
					    inner join segu.tusuario usu1 on usu1.id_usuario = plasi.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plasi.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
					
	else
					     
		raise exception 'Transaccion inexistente';
					         
	end if;
					
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