--------------- SQL ---------------

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
ISSUE            FECHA:              AUTOR                 DESCRIPCION
#29 ETR        22-01-2014               GUY          Creacion
#61 ETR        02/10/2019               RAC          Funcionalidad para actualizar bancos y AFP , de funcionarios que no tiene el dato a la fecha de la planilla
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
    v_estado_planilla		varchar;
    v_id_afp                integer; --#61
    v_id_cuenta_bancaria    integer; --#61
    v_registros             record;  --#61

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
        select tp.*,p.id_gestion,p.estado into v_tipo_planilla
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        where p.id_planilla = v_parametros.id_planilla;


        if (v_tipo_planilla.estado not in('registro_funcionarios','registro_horas','calculo_columnas', 'vbpoa', 'suppresu', 'vbpresupuestos'))then
          raise exception 'No es posible ingresar un funcionario con la planilla en este estado. Intentelo retrocediento la planilla a un estado anterior';
        end if;

        execute 'select * from ' || v_tipo_planilla.funcion_validacion_nuevo_empleado || '(' ||
                p_id_usuario || ', '||v_parametros.id_funcionario  || ', '|| v_parametros.id_planilla
                || ', '''|| v_parametros.forzar_cheque || ''', '''|| v_parametros.finiquito||''')'
        into v_func_planilla;


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla almacenado(a) con exito (id_funcionario_planilla'||v_func_planilla.o_id_funcionario_planilla||')');
        v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_func_planilla.o_id_funcionario_planilla::varchar);

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
        select p.estado into v_estado_planilla
        from plani.tfuncionario_planilla fp
          inner join plani.tplanilla p on p.id_planilla = fp.id_planilla
        where fp.id_funcionario_planilla = v_parametros.id_funcionario_planilla;

        if (v_estado_planilla not in('registro_funcionarios','registro_horas','calculo_columnas'))then
          raise exception 'No es posible eliminar un funcionario con la planilla en este estado. Intentelo retrocediento la planilla a un estado anterior';
        end if;
        --Sentencia de la eliminacion
        v_resp = plani.f_eliminar_funcionario_planilla(v_parametros.id_funcionario_planilla);

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Planilla eliminado(a)');
        v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_planilla',v_parametros.id_funcionario_planilla::varchar);

        --Devuelve la respuesta
        return v_resp;

      end;
      
    /*********************************
     #TRANSACCION:  'PLA_SINBANAFP_IME'
     #DESCRIPCION:	#61 ,  sincronizacion de banco y afp despues de creada la palnilla
     #AUTOR:		rac
     #FECHA:		02-10-2019
    ***********************************/

    elsif(p_transaccion='PLA_SINBANAFP_IME')then

      begin
        
        select p.estado 
        into   v_estado_planilla
        from plani.tplanilla p  
        where p.id_planilla = v_parametros.id_planilla;

        if (v_estado_planilla not in('registro_funcionarios','registro_horas','calculo_columnas'))then
          raise exception 'No es posible sincronizar bancos y afp con la planilla en este estado. Intentelo retrocediento la planilla a un estado anterior';
        end if;
        
        FOR v_registros in ( 
                            SELECT
                              fp.id_funcionario,
                              fp.id_afp,
                              fp.id_cuenta_bancaria,
                              fp.id_funcionario_planilla,
                              pl.fecha_planilla
                            FROM plani.tfuncionario_planilla fp
                            JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
                            WHERE fp.id_planilla = v_parametros.id_planilla
                            AND  ( fp.id_cuenta_bancaria is null OR fp.id_afp is NULL)) LOOP
        
            --recuepra afp y  planilla a la fecha de la planilla
            IF v_registros.id_cuenta_bancaria IS NULL  THEN
               
               v_id_cuenta_bancaria = plani.f_get_cuenta_bancaria_empleado(v_registros.id_funcionario, v_registros.fecha_planilla);
               UPDATE plani.tfuncionario_planilla fp SET
                  id_cuenta_bancaria = v_id_cuenta_bancaria                   
               WHERE fp.id_funcionario_planilla =  v_registros.id_funcionario_planilla;
            
            END IF;
            
             IF v_registros.id_afp IS NULL   THEN
               
               v_id_afp = plani.f_get_afp( v_registros.id_funcionario, v_registros.fecha_planilla);
               UPDATE plani.tfuncionario_planilla fp SET
                  id_afp = v_id_afp                   
               WHERE fp.id_funcionario_planilla =  v_registros.id_funcionario_planilla;
            
            END IF;
            
            
        
        END LOOP;
        
            
        

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','sincronizacion de banco y afp para la planilla');
        v_resp = pxp.f_agrega_clave(v_resp,'id_planilla',v_parametros.id_planilla::varchar);

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