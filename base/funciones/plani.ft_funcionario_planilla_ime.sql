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
   SISTEMA:     Sistema de Planillas
   FUNCION:         plani.ft_funcionario_planilla_ime
   DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'plani.tfuncionario_planilla'
   AUTOR:        (admin)
   FECHA:           22-01-2014 16:11:08
   COMENTARIOS:
  ***************************************************************************

   HISTORIAL DE MODIFICACIONES:
ISSUE            FECHA:              AUTOR                 DESCRIPCION
#29 ETR        22-01-2014               GUY          Creacion
#61 ETR        02/10/2019               RAC          Funcionalidad para actualizar bancos y AFP , de funcionarios que no tiene el dato a la fecha de la planilla
#129 ETR       28.05.2020               RAC          Funcionalidad para actulizar formulas y columnas sn eliminas la planillas

  ***************************************************************************/

  DECLARE

    v_nro_requerimiento     integer;
    v_parametros            record;
    v_id_requerimiento      integer;
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_funcionario_planilla   integer;
    v_tipo_planilla         record;
    v_id_uo_funcionario     integer;
    v_func_planilla         record;
    v_columnas              record;
    v_id_columna_valor      integer;
    v_detalle               record;
    v_estado_planilla       varchar;
    v_id_afp                integer; --#61
    v_id_cuenta_bancaria    integer; --#61
    v_registros             record;  --#61
    v_planilla              record;  --#129
    v_cont_insert           integer;   --#129
    v_cont_update           integer;   --#129
    v_formula_old           varchar;   --#129

  BEGIN

    v_nombre_funcion = 'plani.ft_funcionario_planilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PLA_FUNPLAN_INS'
     #DESCRIPCION:  Insercion de registros
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
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
     #DESCRIPCION:  Modificacion de registros
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
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
     #DESCRIPCION:  Eliminacion de registros
     #AUTOR:        admin
     #FECHA:        22-01-2014 16:11:08
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
     #DESCRIPCION:  #61 ,  sincronizacion de banco y afp despues de creada la palnilla
     #AUTOR:        rac
     #FECHA:        02-10-2019
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

    /*********************************
     #TRANSACCION:  'PLA_SINCFGCL_IME'
     #DESCRIPCION:  sincronizacion de  configuracion de columnas
     #AUTOR:        rac
     #FECHA:        28-05-2020
    ***********************************/

    elsif(p_transaccion='PLA_SINCFGCL_IME')then

      begin

        select
            p.id_planilla,
            p.id_tipo_planilla,
            p.estado,
            p.id_gestion
        into
           v_planilla
        from plani.tplanilla p
        where p.id_planilla = v_parametros.id_planilla;

        if (v_planilla.estado not in('registro_funcionarios'))then
          raise exception 'No es posible sincronizar columnas en estados diferentes de registro de funcionarios';
        end if;

        v_cont_insert := 0;
        v_cont_update := 0;
        --recorre todos los funcionaros de la planilla
        --recorre todas las columnas configuradas para la planilla
        FOR v_registros in (
                            SELECT
                              fp.id_funcionario,
                              fp.id_funcionario_planilla,
                              tc.id_tipo_columna,
                              tc.tipo_dato,
                              tc.tiene_detalle,
                              cv.id_columna_valor,
                              tc.codigo,
                              tc.formula,
                              cv.formula as formula_old
                            FROM plani.tfuncionario_planilla fp
                            JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
                            JOIN plani.ttipo_columna tc ON     tc.id_tipo_planilla = pl.id_tipo_planilla
                                                           AND tc.estado_reg = 'activo'
                            LEFT JOIN  plani.tcolumna_valor cv ON     cv.id_tipo_columna = tc.id_tipo_columna
                                                                  AND cv.id_funcionario_planilla = fp.id_funcionario_planilla
                            WHERE fp.id_planilla = v_planilla.id_planilla
                              AND fp.estado_reg= 'activo') LOOP




                    IF v_registros.id_columna_valor IS NULL THEN
                          --si la columna no existe la isnertamos
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
                            v_registros.id_tipo_columna,
                            v_registros.id_funcionario_planilla,
                            v_registros.codigo,
                            v_registros.formula,
                            0,
                            0
                          )returning id_columna_valor into v_id_columna_valor;

                          v_cont_insert := v_cont_insert  + 1;


                          --registrando el detalle en caso de ser necesario
                          if (v_registros.tiene_detalle = 'si')then
                              for v_detalle in (
                                  select ht.id_horas_trabajadas
                                  from plani.tplanilla p
                                  inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
                                  inner join plani.tfuncionario_planilla fp on fp.id_planilla = p.id_planilla
                                  inner join plani.thoras_trabajadas ht on ht.id_funcionario_planilla = fp.id_funcionario_planilla
                                  where
                                             fp.id_funcionario = v_registros.id_funcionario
                                        and  tp.codigo = 'PLASUE'
                                        and  ht.estado_reg = 'activo'
                                        and p.id_gestion = v_planilla.id_gestion) loop

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


                    ELSE

                        --si la columnas ya existe y es de tipo formula la actulizamos
                        IF v_registros.tipo_dato = 'formula' AND v_registros.formula_old != v_registros.formula  THEN
                          UPDATE plani.tcolumna_valor c SET
                              formula = v_registros.formula,
                              obs_dba = obs_dba ||' - formula modificada: '|| v_registros.formula_old
                          WHERE id_columna_valor = v_registros.id_columna_valor;
                          v_cont_update := v_cont_update  + 1;
                        END IF;

                    END IF;


        END LOOP;


        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','sincronizacion ejecutada,  columnas modificadas = '|| v_cont_update::varchar || ', columnas insertadas = '||v_cont_insert::varchar);
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
PARALLEL UNSAFE
COST 100;