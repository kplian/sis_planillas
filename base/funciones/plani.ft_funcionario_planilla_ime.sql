CREATE OR REPLACE FUNCTION plani.ft_funcionario_planilla_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Planillas
 FUNCION: 		plani.ft_funcionario_planilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tfuncionario_planilla'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2014 16:11:08
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_funcionario_planilla	integer;
	v_tipo_planilla			record;
	v_id_uo_funcionario		integer;
	v_func_planilla			record;
	v_columnas				record;
    v_id_columna_valor		integer;
    v_detalle				record;
			    
BEGIN

    v_nombre_funcion = 'plani.ft_funcionario_planilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	if(p_transaccion='PLA_FUNPLAN_INS')then
					
        begin
        	select tp.*,p.id_gestion into v_tipo_planilla
        	from plani.tplanilla p
        	inner join plani.ttipo_planilla tp
        		on tp.id_tipo_planilla = p.id_tipo_planilla
        	where p.id_planilla = v_parametros.id_planilla;
        	
        	execute 'select * from ' || v_tipo_planilla.funcion_validacion_nuevo_empleado || '(' ||
        						 v_parametros.id_funcionario  || ', '|| v_parametros.id_planilla||')'
        	into v_func_planilla;
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
            id_cuenta_bancaria
          	) values(
			v_parametros.finiquito,
			v_parametros.forzar_cheque,
			v_parametros.id_funcionario,
			v_parametros.id_planilla,
			v_func_planilla.o_id_lugar,
			v_func_planilla.o_id_uo_funcionario,
			'activo',
			p_id_usuario,
			now(),
			null,
			null,
            v_func_planilla.o_id_afp,
            v_func_planilla.o_id_cuenta_bancaria
							
			)RETURNING id_funcionario_planilla into v_id_funcionario_planilla;
			
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
		                v_id_funcionario_planilla,
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
                    	where fp.id_funcionario = v_parametros.id_funcionario and  tp.codigo = 'PLASUE' and
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
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla almacenado(a) con exito (id_funcionario_planilla'||v_id_funcionario_planilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_id_funcionario_planilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	elsif(p_transaccion='PLA_FUNPLAN_MOD')then

		begin
			--Sentencia de la modificacion
			update plani.tfuncionario_planilla set
			finiquito = v_parametros.finiquito,
			forzar_cheque = v_parametros.forzar_cheque,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_funcionario_planilla=v_parametros.id_funcionario_planilla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_parametros.id_funcionario_planilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PLA_FUNPLAN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		22-01-2014 16:11:08
	***********************************/

	elsif(p_transaccion='PLA_FUNPLAN_ELI')then

		begin
			--Sentencia de la eliminacion
			v_resp = plani.f_eliminar_funcionario_planilla(v_parametros.id_funcionario_planilla);
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_parametros.id_funcionario_planilla::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

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