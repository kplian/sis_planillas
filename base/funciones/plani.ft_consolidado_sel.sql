CREATE OR REPLACE FUNCTION plani.ft_consolidado_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_consolidado_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'plani.tconsolidado'
 AUTOR: 		 (jrivera)
 FECHA:	        14-07-2014 19:04:07
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
			    
BEGIN

	v_nombre_funcion = 'plani.ft_consolidado_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_CONPRE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:07
	***********************************/

	if(p_transaccion='PLA_CONPRE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						conpre.id_consolidado,
						conpre.id_cc,
						conpre.id_planilla,
						conpre.id_presupuesto,
						conpre.estado_reg,
						conpre.tipo_consolidado,
						conpre.id_usuario_reg,
						conpre.fecha_reg,
						conpre.usuario_ai,
						conpre.id_usuario_ai,
						conpre.id_usuario_mod,
						conpre.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cc.codigo_cc,
                        sum(concol.valor) as suma,
                        sum(concol.valor_ejecutado) as suma_ejecutado	
						from plani.tconsolidado conpre
                        inner join param.vcentro_costo cc 
                        	on cc.id_centro_costo = conpre.id_presupuesto
                        inner join plani.tconsolidado_columna concol
                        	on concol.id_consolidado = conpre.id_consolidado
						inner join segu.tusuario usu1 on usu1.id_usuario = conpre.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conpre.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta = v_consulta || ' group by conpre.id_consolidado,
						conpre.id_cc,
						conpre.id_planilla,
						conpre.id_presupuesto,
						conpre.estado_reg,
						conpre.tipo_consolidado,
						conpre.id_usuario_reg,
						conpre.fecha_reg,
						conpre.usuario_ai,
						conpre.id_usuario_ai,
						conpre.id_usuario_mod,
						conpre.fecha_mod,
						usu1.cuenta,
						usu2.cuenta,
                        cc.codigo_cc ';
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_CONPRE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:07
	***********************************/

	elsif(p_transaccion='PLA_CONPRE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(*)
					    from plani.tconsolidado conpre
                        inner join param.vcentro_costo cc 
                        	on cc.id_centro_costo = conpre.id_presupuesto                        
					    inner join segu.tusuario usu1 on usu1.id_usuario = conpre.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conpre.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
			
			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************    
 	#TRANSACCION:  'PLA_DETEJEREP_SEL'
 	#DESCRIPCION:	Listado de ejecucion presupeustaria por tipo de planilla, periodo y gestion
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	elsif(p_transaccion='PLA_DETEJEREP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						(pre.codigo_cc || '' '' || pre.nombre_uo)::text,
                        tipcol.nombre,
						concol.tipo_contrato,
                        
						concol.valor_ejecutado,
                        tipcol.codigo
						from plani.tconsolidado_columna concol
						inner join plani.ttipo_columna tipcol
							on tipcol.id_tipo_columna = concol.id_tipo_columna
                        inner join plani.tconsolidado con 
                        	on concol.id_consolidado = con.id_consolidado
                        inner join plani.tplanilla plani 
                        	on plani.id_planilla = con.id_planilla 
                        inner join param.vcentro_costo pre 
                        	on pre.id_centro_costo = con.id_presupuesto                      
												
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by pre.codigo_cc, tipcol.descripcion, concol.tipo_contrato';

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	 /*********************************    
 	#TRANSACCION:  'PLA_DETOBLIREP_SEL'
 	#DESCRIPCION:	Listado de obligaciones por planilla y periodo
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	elsif(p_transaccion='PLA_DETOBLIREP_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tob.nombre as tipo_obligacion,
                        obli.acreedor,
                        sum(concol.monto_detalle_obligacion) as monto
						from plani.tobligacion obli
						inner join plani.ttipo_obligacion tob
							on tob.id_tipo_obligacion = obli.id_tipo_obligacion
                        inner join plani.tobligacion_columna concol 
                        	on concol.id_obligacion = obli.id_obligacion
                        inner join plani.tplanilla plani 
                        	on plani.id_planilla = obli.id_planilla 
                        where concol.monto_detalle_obligacion > 0 and   ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' group by tob.nombre,
                        obli.acreedor 
                        
                        order by tipo_obligacion, acreedor';

			--Devuelve la respuesta
			return v_consulta;
						
		end;        
    /*********************************    
 	#TRANSACCION:  'PLA_COLEJE_SEL'
 	#DESCRIPCION:	Listado de columnas de ejecucion presupuestaria
 	#AUTOR:		jrivera	
 	#FECHA:		14-07-2014 19:04:10
	***********************************/

	elsif(p_transaccion='PLA_COLEJE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tipcol.codigo,
                        tipcol.descripcion::varchar
						from plani.tconsolidado_columna concol
						inner join plani.ttipo_columna tipcol
							on tipcol.id_tipo_columna = concol.id_tipo_columna
                        inner join plani.tconsolidado con 
                        	on concol.id_consolidado = con.id_consolidado
                        inner join plani.tplanilla plani 
                        	on plani.id_planilla = con.id_planilla 
                                        
												
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' group by tipcol.codigo,
                        tipcol.descripcion ';
			v_consulta:=v_consulta||' order by tipcol.descripcion ';

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