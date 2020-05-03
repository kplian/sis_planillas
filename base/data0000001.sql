/***********************************I-DAT-JRR-PLANI-0-16/01/2014****************************************/

INSERT INTO segu.tsubsistema ( codigo, nombre, fecha_reg, prefijo, estado_reg, nombre_carpeta, id_subsis_orig)
VALUES ('PLANI', 'Sistema de Planillas', '2014-01-16', 'PLA', 'activo', 'planillas', NULL);


select wf.f_insert_tproceso_macro ('PLASUE', 'Planilla de Sueldos', 'si', 'activo', 'Sistema de Planillas');
select wf.f_insert_ttipo_proceso ('', 'Planilla de Sueldos', 'PLASUE', 'plani.tplanilla', 'id_planilla', 'activo', 'si', 'PLASUE');
select wf.f_insert_ttipo_estado ('registro_funcionarios', 'Registro de Funcionarios', 'si', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('registro_horas', 'Registro Horas Trabajadas', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('calculo_columnas', 'Calculo de Columnas', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('calculo_validado', 'Calculo Validado', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('presupuestos', 'Presupuestos', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('presupuestos_validado', 'Presupuestos Validado', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('obligaciones', 'Obligaciones', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('obligaciones_validado', 'Obligaciones Validado', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('comprobante_presupuestario', 'Comprobante Presupuestario', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('comprobante_presupuestario_validado', 'Comprobante Presupuestario Validado', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('comprobante_obligaciones', 'Comprobante Obligaciones', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_ttipo_estado ('planilla_finalizada', 'Planilla Finalizada', 'no', 'no', 'no', 'ninguno', '', 'ninguno', '', '', 'activo', 'PLASUE', '');
select wf.f_insert_testructura_estado ('registro_funcionarios', 'PLASUE', 'registro_horas', 'PLASUE', 1, '', 'activo');
select wf.f_insert_testructura_estado ('registro_horas', 'PLASUE', 'calculo_columnas', 'PLASUE', 1, '', 'activo');
select wf.f_insert_testructura_estado ('calculo_columnas', 'PLASUE', 'calculo_validado', 'PLASUE', 1, '', 'activo');
select wf.f_insert_testructura_estado ('calculo_validado', 'PLASUE', 'presupuestos', 'PLASUE', 1, '', 'activo');
select wf.f_insert_testructura_estado ('presupuestos', 'PLASUE', 'presupuestos_validado', 'PLASUE', 1, '', 'activo');
select wf.f_insert_testructura_estado ('presupuestos_validado', 'PLASUE', 'obligaciones', 'PLASUE', 1, '', 'activo');
select wf.f_insert_testructura_estado ('obligaciones', 'PLASUE', 'obligaciones_validado', 'PLASUE', 1, '', 'activo');
select wf.f_insert_testructura_estado ('obligaciones_validado', 'PLASUE', 'comprobante_presupuestario', 'PLASUE', NULL, '', 'activo');
select wf.f_insert_testructura_estado ('comprobante_presupuestario', 'PLASUE', 'comprobante_presupuestario_validado', 'PLASUE', NULL, '', 'activo');
select wf.f_insert_testructura_estado ('comprobante_presupuestario_validado', 'PLASUE', 'comprobante_obligaciones', 'PLASUE', NULL, '', 'activo');
select wf.f_insert_testructura_estado ('comprobante_obligaciones', 'PLASUE', 'planilla_finalizada', 'PLASUE', NULL, '', 'activo');



select pxp.f_insert_tgui ('SISTEMA DE PLANILLAS', '', 'PLANI', 'si', NULL, '', 1, '', '', 'PLANI');
select pxp.f_insert_tgui ('Definición de Planillas', 'Definición de Planillas', 'DEFPLA', 'si', 1, '', 2, '', '', 'PLANI');
select pxp.f_insert_tgui ('Tipo Planilla', 'Tipo Planilla', 'TIPPLA', 'si', 1, 'sis_planillas/vista/tipo_planilla/TipoPlanilla.php', 3, '', 'TipoPlanilla', 'PLANI');
select pxp.f_insert_tgui ('Parametro Valor', 'Parametro Valor', 'PLAPARVAR', 'si', 2, 'sis_planillas/vista/parametro_valor/ParametroValor.php', 3, '', 'ParametroValor', 'PLANI');
select pxp.f_insert_tgui ('Registro de AFP', 'Registro de AFP', 'REGAFP', 'si', 2, 'sis_planillas/vista/afp/Afp.php', 2, '', 'Afp', 'PLANI');
select pxp.f_insert_tgui ('Definición Antiguedad', 'Definición Antiguedad', 'DEFANTI', 'si', 3, 'sis_planillas/vista/antiguedad/Antiguedad.php', 2, '', 'Antiguedad', 'PLANI');
select pxp.f_delete_tgui ('FUNPLA');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'FUNPLAN', 'si', 1, 'sis_planillas/vista/funcionario/FuncionarioPlanilla.php', 2, '', 'FuncionarioPlanilla', 'PLANI');
select pxp.f_insert_tgui ('Tipo Columna', 'Tipo Columna', 'TIPPLA.1', 'no', 0, 'sis_planillas/vista/tipo_columna/TipoColumna.php', 4, '', '60%', 'PLANI');
select pxp.f_insert_tgui ('Obligaciones a generar para el tipo de Planilla', 'Obligaciones a generar para el tipo de Planilla', 'TIPPLA.2', 'no', 0, 'sis_planillas/vista/tipo_obligacion/TipoObligacion.php', 4, '', '90%', 'PLANI');
select pxp.f_insert_tgui ('Diseño de Reportes para la Planilla', 'Diseño de Reportes para la Planilla', 'TIPPLA.3', 'no', 0, 'sis_planillas/vista/reporte/Reporte.php', 4, '', '90%', 'PLANI');
select pxp.f_insert_tgui ('Tipo Columna Obligación', 'Tipo Columna Obligación', 'TIPPLA.2.1', 'no', 0, 'sis_planillas/vista/tipo_obligacion_columna/TipoObligacionColumna.php', 5, '', '50%', 'PLANI');
select pxp.f_insert_tgui ('Reporte Columna', 'Reporte Columna', 'TIPPLA.3.1', 'no', 0, 'sis_planillas/vista/reporte_columna/ReporteColumna.php', 5, '', '55%', 'PLANI');
select pxp.f_insert_tgui ('AFP', 'AFP', 'FUNPLAN.1', 'no', 0, 'sis_planillas/vista/funcionario_afp/FuncionarioAfp.php', 3, '', 'FuncionarioAfp', 'PLANI');
select pxp.f_insert_tgui ('Descuento/Bono', 'Descuento/Bono', 'FUNPLAN.2', 'no', 0, 'sis_planillas/vista/descuento_bono/DescuentoBono.php', 3, '', 'DescuentoBono', 'PLANI');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'FUNPLAN.3', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 3, '', 'FuncionarioCuentaBancaria', 'PLANI');
select pxp.f_insert_tgui ('Personas', 'Personas', 'FUNPLAN.4', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 3, '', 'persona', 'PLANI');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'FUNPLAN.3.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 4, '', 'Institucion', 'PLANI');
select pxp.f_insert_tgui ('Personas', 'Personas', 'FUNPLAN.3.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'PLANI');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'FUNPLAN.3.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_parametro_valor_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_parametro_valor_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_planilla_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_existe_columna', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_columna_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_obligacion_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_obligacion_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_reporte_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_reporte_get_ancho_total_hoja', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_reporte_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_reporte_calcular_ancho_utilizado', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_obligacion_columna_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_obligacion_columna_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_reporte_columna_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_reporte_columna_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_planilla_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_afp_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_afp_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_antiguedad_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_antiguedad_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_funcionario_afp_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_descuento_bono_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_descuento_bono_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_funcionario_afp_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_tipo_columna_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tprocedimiento ('PLA_PARVAR_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_parametro_valor_sel');
select pxp.f_insert_tprocedimiento ('PLA_PARVAR_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_parametro_valor_sel');
select pxp.f_insert_tprocedimiento ('PLA_PARVAR_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_parametro_valor_ime');
select pxp.f_insert_tprocedimiento ('PLA_PARVAR_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_parametro_valor_ime');
select pxp.f_insert_tprocedimiento ('PLA_PARVAR_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_parametro_valor_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPPLA_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_tipo_planilla_sel');
select pxp.f_insert_tprocedimiento ('PLA_TIPPLA_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_tipo_planilla_sel');
select pxp.f_insert_tprocedimiento ('PLA_TIPCOL_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_tipo_columna_sel');
select pxp.f_insert_tprocedimiento ('PLA_TIPCOL_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_tipo_columna_sel');
select pxp.f_insert_tprocedimiento ('PLA_TIPOBLI_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_tipo_obligacion_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPOBLI_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_tipo_obligacion_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPOBLI_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_tipo_obligacion_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPOBLI_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_tipo_obligacion_sel');
select pxp.f_insert_tprocedimiento ('PLA_TIPOBLI_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_tipo_obligacion_sel');
select pxp.f_insert_tprocedimiento ('PLA_REPO_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_reporte_sel');
select pxp.f_insert_tprocedimiento ('PLA_REPO_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_reporte_sel');
select pxp.f_insert_tprocedimiento ('PLA_REPO_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_reporte_ime');
select pxp.f_insert_tprocedimiento ('PLA_REPO_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_reporte_ime');
select pxp.f_insert_tprocedimiento ('PLA_REPO_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_reporte_ime');
select pxp.f_insert_tprocedimiento ('PLA_OBCOL_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_tipo_obligacion_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_OBCOL_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_tipo_obligacion_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_OBCOL_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_tipo_obligacion_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_OBCOL_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_tipo_obligacion_columna_sel');
select pxp.f_insert_tprocedimiento ('PLA_OBCOL_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_tipo_obligacion_columna_sel');
select pxp.f_insert_tprocedimiento ('PLA_REPCOL_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_reporte_columna_sel');
select pxp.f_insert_tprocedimiento ('PLA_REPCOL_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_reporte_columna_sel');
select pxp.f_insert_tprocedimiento ('PLA_REPCOL_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_reporte_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_REPCOL_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_reporte_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_REPCOL_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_reporte_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPPLA_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_tipo_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPPLA_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_tipo_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPPLA_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_tipo_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_AFP_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_afp_ime');
select pxp.f_insert_tprocedimiento ('PLA_AFP_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_afp_ime');
select pxp.f_insert_tprocedimiento ('PLA_AFP_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_afp_ime');
select pxp.f_insert_tprocedimiento ('PLA_AFP_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_afp_sel');
select pxp.f_insert_tprocedimiento ('PLA_AFP_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_afp_sel');
select pxp.f_insert_tprocedimiento ('PLA_ANTI_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_antiguedad_ime');
select pxp.f_insert_tprocedimiento ('PLA_ANTI_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_antiguedad_ime');
select pxp.f_insert_tprocedimiento ('PLA_ANTI_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_antiguedad_ime');
select pxp.f_insert_tprocedimiento ('PLA_ANTI_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_antiguedad_sel');
select pxp.f_insert_tprocedimiento ('PLA_ANTI_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_antiguedad_sel');
select pxp.f_insert_tprocedimiento ('PLA_FUNAFP_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_funcionario_afp_ime');
select pxp.f_insert_tprocedimiento ('PLA_FUNAFP_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_funcionario_afp_ime');
select pxp.f_insert_tprocedimiento ('PLA_FUNAFP_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_funcionario_afp_ime');
select pxp.f_insert_tprocedimiento ('PLA_DESBON_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_descuento_bono_ime');
select pxp.f_insert_tprocedimiento ('PLA_DESBON_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_descuento_bono_ime');
select pxp.f_insert_tprocedimiento ('PLA_DESBON_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_descuento_bono_ime');
select pxp.f_insert_tprocedimiento ('PLA_DESBON_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_descuento_bono_sel');
select pxp.f_insert_tprocedimiento ('PLA_DESBON_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_descuento_bono_sel');
select pxp.f_insert_tprocedimiento ('PLA_FUNAFP_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_funcionario_afp_sel');
select pxp.f_insert_tprocedimiento ('PLA_FUNAFP_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_funcionario_afp_sel');
select pxp.f_insert_tprocedimiento ('PLA_TIPCOL_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_tipo_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPCOL_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_tipo_columna_ime');
select pxp.f_insert_tprocedimiento ('PLA_TIPCOL_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_tipo_columna_ime');


/* Data for the 'plani.ttipo_planilla' table  (Records 1 - 2) */


INSERT INTO plani.ttipo_planilla ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_planilla", "codigo", "nombre", "id_proceso_macro", "funcion_obtener_empleados", "tipo_presu_cc", "funcion_validacion_nuevo_empleado", "periodicidad", "calculo_horas")
VALUES (1, NULL, E'2014-01-22 20:40:51.747', NULL, E'activo', 1, E'PLASUE', E'Planilla de Sueldos', (select id_proceso_macro from wf.tproceso_macro where codigo = 'PLASUE'), E'plani.f_plasue_insert_empleados', E'parametrizacion', E'plani.f_plasue_valid_empleado', E'mensual', E'si');

INSERT INTO param.tdocumento ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_subsistema", "codigo", "descripcion", "periodo_gestion", "tipo", "tipo_numeracion", "formato")
VALUES (1, NULL, E'2014-01-23 00:32:26', E'2014-01-23 00:32:26', E'activo', 13, E'PLASUE', E'Planilla de Sueldos', E'periodo', NULL, E'depto', NULL);

select pxp.f_insert_tgui ('Registro de Planillas', 'Registro de Planillas', 'REGPLAN', 'si', 1, 'sis_planillas/vista/planilla/Planilla.php', 2, '', 'Planilla', 'PLANI');
select pxp.f_insert_testructura_gui ('REGPLAN', 'PLANI');

/* Data for the 'orga.ttipo_contrato' table  (Records 1 - 2) */

INSERT INTO orga.ttipo_contrato ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_contrato", "codigo", "nombre")
VALUES (1, NULL, E'2014-01-23 13:17:13.799', NULL, E'activo', 1, E'PLA', E'Planta');

INSERT INTO orga.ttipo_contrato ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_contrato", "codigo", "nombre")
VALUES (1, NULL, E'2014-01-23 13:17:20.394', NULL, E'activo', 2, E'EVE', E'Eventual');

INSERT INTO param.tdepto ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_subsistema", "codigo", "nombre", "nombre_corto")
VALUES (1, NULL, E'2014-01-23 00:00:00', E'2014-01-23 13:35:24.774', E'activo', 4, E'RRHH01', E'Departamento Recursos Humanos Cochabamba', E'Depto RRHH Cbba');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'plani_tiene_presupuestos', E'si', NULL);

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'plani_tiene_costos', E'si', NULL);

INSERT INTO plani.tparametro_valor ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "codigo", "nombre", "fecha_ini", "fecha_fin", "valor")
VALUES (1, NULL, E'2014-01-25 23:32:48.771', NULL, E'activo', E'HORLAB', E'Horas Laborales Mensuales', E'2013-12-01', NULL, '240');

INSERT INTO plani.tparametro_valor ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "codigo", "nombre", "fecha_ini", "fecha_fin", "valor")
VALUES (1, NULL, E'2014-01-25 23:32:48.771', NULL, E'activo', E'SALMIN', E'Salario Minimo Nacional', E'2013-12-01', NULL, '1200');

/* Data for the 'plani.tantiguedad' table  (Records 1 - 7) */

INSERT INTO plani.tantiguedad ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "valor_min", "valor_max", "porcentaje")
VALUES (1, NULL, E'2014-01-28 14:41:37.681', NULL, E'activo', 2, 4, 5);

INSERT INTO plani.tantiguedad ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "valor_min", "valor_max", "porcentaje")
VALUES (1, NULL, E'2014-01-28 14:41:50.306', NULL, E'activo', 5, 7, 11);

INSERT INTO plani.tantiguedad ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "valor_min", "valor_max", "porcentaje")
VALUES (1, NULL, E'2014-01-28 14:42:04.620', NULL, E'activo', 8, 10, 18);

INSERT INTO plani.tantiguedad ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "valor_min", "valor_max", "porcentaje")
VALUES (1, NULL, E'2014-01-28 14:42:22.560', NULL, E'activo', 11, 14, 26);

INSERT INTO plani.tantiguedad ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "valor_min", "valor_max", "porcentaje")
VALUES (1, NULL, E'2014-01-28 14:42:36.705', NULL, E'activo', 15, 19, 34);

INSERT INTO plani.tantiguedad ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "valor_min", "valor_max", "porcentaje")
VALUES (1, NULL, E'2014-01-28 14:42:55.651', NULL, E'activo', 20, 24, 42);

INSERT INTO plani.tantiguedad ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "valor_min", "valor_max", "porcentaje")
VALUES (1, NULL, E'2014-01-28 14:43:12.233', NULL, E'activo', 25, 100, 50);

/***********************************F-DAT-JRR-PLANI-0-16/01/2014****************************************/

/***********************************I-DAT-JRR-PLANI-0-24/04/2014****************************************/
select pxp.f_insert_tgui ('SISTEMA DE PLANILLAS', '', 'PLANI', 'si', 80, '', 1, '', '', 'PLANI');
select pxp.f_insert_tgui ('Horas Trabajadas por Empleado', 'Horas Trabajadas por Empleado', 'REGPLAN.1', 'no', 0, 'sis_planillas/vista/horas_trabajadas/HorasTrabajadas.php', 3, '', '90%', 'PLANI');
select pxp.f_insert_tgui ('Detalle de Columnas por Empleado', 'Detalle de Columnas por Empleado', 'REGPLAN.2', 'no', 0, 'sis_planillas/vista/funcionario_planilla/FuncionarioPlanillaColumna.php', 3, '', '90%', 'PLANI');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'REGPLAN.3', 'no', 0, 'sis_planillas/vista/funcionario_planilla/FuncionarioPlanilla.php', 3, '', '50%', 'PLANI');
select pxp.f_insert_tgui ('Columnas', 'Columnas', 'REGPLAN.2.1', 'no', 0, 'sis_planillas/vista/columna_valor/ColumnaValor.php', 4, '', '50%', 'PLANI');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'REGPLAN.2.2', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'PLANI');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'REGPLAN.2.2.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'PLANI');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REGPLAN.2.2.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'PLANI');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'REGPLAN.2.2.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'PLANI');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REGPLAN.2.2.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'PLANI');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REGPLAN.2.2.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'PLANI');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'REGPLAN.3.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'PLANI');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'FUNPLAN.4.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 4, '', 'subirFotoPersona', 'PLANI');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REGPLAN.2.2.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'PLANI');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'REGPLAN.3.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'PLANI');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REGPLAN.3.1.2', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'PLANI');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'REGPLAN.3.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'PLANI');
select pxp.f_insert_tgui ('Personas', 'Personas', 'REGPLAN.3.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'PLANI');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REGPLAN.3.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'PLANI');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'REGPLAN.3.1.2.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 6, '', 'subirFotoPersona', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_plasue_generar_horas', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_columna_valor_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_get_fecha_primer_contrato_empleado', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_get_valor_parametro_valor', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_horas_trabajadas_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_calcular_descuento_bono', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_plasue_insert_empleados', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_funcionario_planilla_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_calcular_formula', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_plasue_valid_empleado', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_planilla_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_horas_trabajadas_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_columna_valor_sel', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_funcionario_planilla_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_calcular_basica', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_planilla_calcular', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_planilla_cambiar_estado', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.f_eliminar_funcionario_planilla', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tfuncion ('plani.ft_planilla_ime', 'Funcion para tabla     ', 'PLANI');
select pxp.f_insert_tprocedimiento ('PLA_COLVAL_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_columna_valor_ime');
select pxp.f_insert_tprocedimiento ('PLA_COLVAL_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_columna_valor_ime');
select pxp.f_insert_tprocedimiento ('PLA_COLVAL_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_columna_valor_ime');
select pxp.f_insert_tprocedimiento ('PLA_HORTRA_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_horas_trabajadas_sel');
select pxp.f_insert_tprocedimiento ('PLA_HORTRA_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_horas_trabajadas_sel');
select pxp.f_insert_tprocedimiento ('PLA_FUNPLAN_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_funcionario_planilla_sel');
select pxp.f_insert_tprocedimiento ('PLA_FUNPLAN_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_funcionario_planilla_sel');
select pxp.f_insert_tprocedimiento ('PLA_PLANI_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_planilla_sel');
select pxp.f_insert_tprocedimiento ('PLA_PLANI_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_planilla_sel');
select pxp.f_insert_tprocedimiento ('PLA_HORTRA_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_horas_trabajadas_ime');
select pxp.f_insert_tprocedimiento ('PLA_HORTRA_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_horas_trabajadas_ime');
select pxp.f_insert_tprocedimiento ('PLA_HORTRA_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_horas_trabajadas_ime');
select pxp.f_insert_tprocedimiento ('PLA_COLVAL_SEL', 'Consulta de datos', 'si', '', '', 'plani.ft_columna_valor_sel');
select pxp.f_insert_tprocedimiento ('PLA_COLVAL_CONT', 'Conteo de registros', 'si', '', '', 'plani.ft_columna_valor_sel');
select pxp.f_insert_tprocedimiento ('PLA_FUNPLAN_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_funcionario_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_FUNPLAN_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_funcionario_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_FUNPLAN_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_funcionario_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_PLANI_INS', 'Insercion de registros', 'si', '', '', 'plani.ft_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_PLANI_MOD', 'Modificacion de registros', 'si', '', '', 'plani.ft_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_PLANI_ELI', 'Eliminacion de registros', 'si', '', '', 'plani.ft_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_PLANIGENHOR_MOD', 'Generación de Horas Trabajadas para la planilla', 'si', '', '', 'plani.ft_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_PLANIVALHOR_MOD', 'Validación de Horas Trabajadas para la planilla', 'si', '', '', 'plani.ft_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_PLANICALCOL_MOD', 'Calcular Columnas para la planilla', 'si', '', '', 'plani.ft_planilla_ime');
select pxp.f_insert_tprocedimiento ('PLA_PLANIVALCOL_MOD', 'Validación del calculo de columnas', 'si', '', '', 'plani.ft_planilla_ime');


/***********************************F-DAT-JRR-PLANI-0-24/04/2014****************************************/

/***********************************I-DAT-JRR-PLANI-0-14/07/2016****************************************/

select pxp.f_insert_tgui ('Reportes', 'Reportes', 'REPPLA', 'si', 7, '', 2, '', '', 'PLANI');
select pxp.f_insert_tgui ('Ministerio de Trabajo', 'Ministerio de Trabajo', 'REPPLAMINTRA', 'si', 1, 'sis_planillas/vista/reportes_ministerio/ReporteMinisterio.php', 3, '', 'ReporteMinisterio', 'PLANI');
select pxp.f_insert_tgui ('Subir Planilla Sigma', 'Subir Planilla Sigma', 'PLASIGUPL', 'si', 3, 'sis_planillas/vista/sigma/SubirPlanillaSigma.php', 3, '', 'SubirPlanillaSigma', 'PLANI');
select pxp.f_insert_tgui ('Comparación Sigma-ERP', 'Comparación Sigma-ERP', 'DIFSIGERP', 'si', 5, 'sis_planillas/vista/sigma/DiferenciasPlanillaSigma.php', 3, '', 'DiferenciasPlanillaSigma', 'PLANI');
select pxp.f_insert_tgui ('Detalle Ejecucion', 'Detalle Ejecucion', 'DETEJEPLA', 'si', 6, 'sis_planillas/vista/reportes_presupuestos/DetalleEjecucionPlanilla.php', 3, '', 'DetalleEjecucionPlanilla', 'PLANI');
select pxp.f_insert_tgui ('Movimientos por Periodo', 'Movimientos por Periodo', 'MOVPERPLA', 'si', 1, 'sis_planillas/vista/reporte_cambios_periodo/ReporteCambiosPeriodo.php', 3, '', 'ReporteCambiosPeriodo', 'PLANI');
select pxp.f_insert_tgui ('Reporte Previsiones', 'Reporte Previsiones', 'REPREPLA', 'si', 8, 'sis_planillas/vista/reporte_previsiones/ReportePrevisiones.php', 3, '', 'ReportePrevisiones', 'PLANI');


select pxp.f_insert_testructura_gui ('REPPLA', 'PLANI');
select pxp.f_insert_testructura_gui ('REPPLAMINTRA', 'REPPLA');
select pxp.f_insert_testructura_gui ('MOVPERPLA', 'REPPLA');
select pxp.f_insert_testructura_gui ('PLASIGUPL', 'REPPLA');
select pxp.f_insert_testructura_gui ('DIFSIGERP', 'REPPLA');
select pxp.f_insert_testructura_gui ('DETEJEPLA', 'REPPLA');
select pxp.f_insert_testructura_gui ('REPREPLA', 'REPPLA');

/***********************************F-DAT-JRR-PLANI-0-14/07/2016****************************************/

/***********************************I-DAT-JRR-PLANI-0-21/09/2016****************************************/
select pxp.f_insert_tgui ('Planilla Actualizada de Item', 'Planilla Actualizada de Item', 'RPAI', 'si', 9, 'sis_planillas/vista/reporte_planilla_actualizada_item/ReportePlanillaActualizadaItem.php', 3, '', 'PlanillaActualizadaItem', 'PLANI');
select pxp.f_insert_testructura_gui ('RPAI', 'REPPLA');
/***********************************F-DAT-JRR-PLANI-0-21/09/2016****************************************/

/***********************************I-DAT-JRR-PLANI-0-21/09/2016****************************************/
select pxp.f_insert_tgui ('Planilla Actualizada de Item', 'Planilla Actualizada de Item', 'RPAI', 'si', 9, 'sis_planillas/vista/reporte_planilla_actualizada_item/ReportePlanillaActualizadaItem.php', 3, '', 'PlanillaActualizadaItem', 'PLANI');
select pxp.f_insert_testructura_gui ('RPAI', 'REPPLA');
/***********************************F-DAT-JRR-PLANI-0-21/09/2016****************************************/

/***********************************I-DAT-JRR-PLANI-0-17/10/2016****************************************/

select pxp.f_insert_tgui ('Reporte Contabilizacion', 'Reporte Contabilizacion', 'PLANRCONTA', 'si', 4, 'sis_planillas/vista/reportes_presupuestos/ReporteContabilizacion.php', 3, '', 'ReporteContabilizacion', 'PLANI');

select pxp.f_insert_tgui ('Generar Reportes de Planillas', 'Genera Reportes Configurados de Planillas', 'GERREPPLA', 'si', 1, 'sis_planillas/vista/reporte/GenerarReporte.php', 3, '', 'GenerarReporte', 'PLANI');
select pxp.f_insert_testructura_gui ('PLANRCONTA', 'REPPLA');
select pxp.f_insert_testructura_gui ('GERREPPLA', 'REPPLA');

/***********************************F-DAT-JRR-PLANI-0-17/10/2016****************************************/

/***********************************I-DAT-JRR-PLANI-0-25/01/2017****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'plani_carga_presupuesto_from_uo', E'no', E'Carga el presupuesto automaticamente de la primera uo con presupuesto que encuentre para el cargo');

/***********************************F-DAT-JRR-PLANI-0-25/01/2017****************************************/

/***********************************I-DAT-JRR-PLANI-0-10/03/2017****************************************/
/*
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'plani_cuenta_bancaria_defecto', E'1', E'Cuenta bancaria por defecto para pagos generados por planillas');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'plani_generar_comprobante_obligaciones', E'no', E'bandera para generar comprobante de obligaciones');
*/
/***********************************F-DAT-JRR-PLANI-0-10/03/2017****************************************/


/***********************************I-DAT-RAC-PLANI-1-24/01/2019****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'plani_generar_comprobante_obligaciones', E'si', E'genera cbte de obligaciones al validar cbte de planilla');


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'plani_cuenta_bancaria_defecto', E'1', E'Cuenta bancaria por defecto para pagos generados por planillas');

/***********************************F-DAT-RAC-PLANI-1-24/01/2019****************************************/
/***********************************I-DAT-EGS-PLANI-0-05/02/2019****************************************/
select pxp.f_insert_tgui ('Agrupador de Obligaciones', 'Agrupa el tipo de Obligacion ', 'AGRTO', 'si', 3, 'sis_planillas/vista/tipo_obligacion_agrupador/TipoObligacionAgrupador.php', 3, '', 'TipoObligacionAgrupador', 'PLANI');
/***********************************F-DAT-EGS-PLANI-0-05/02/2019****************************************/
/***********************************I-DAT-EGS-PLANI-0-24/04/2019****************************************/
select pxp.f_insert_tgui ('Tipo Licencia', 'Tipo Lincencia', 'TIPLIC', 'si', 1, 'sis_planillas/vista/tipo_licencia/TipoLicencia.php', 3, '', 'TipoLicencia', 'PLANI');
select pxp.f_insert_tgui ('Licencia VoBo', 'Licencia Visto Bueno', 'LICVOBO', 'si', 6, 'sis_planillas/vista/licencia/LicenciaVobo.php', 2, '', 'LicenciaVobo', 'PLANI');
select pxp.f_insert_tgui ('Solicitud Licencia', 'Solicitud Lincenia', 'SOLPLA', 'si', 7, 'sis_planillas/vista/licencia/LicenciaReq.php', 2, '', 'LicenciaReq', 'PLANI');

------PROCESO WF
select wf.f_import_tproceso_macro ('insert','LIC', 'PLANI', 'Licencias','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','LICE',NULL,NULL,'LIC','Licencia','','','si','','','','LICE',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','LICE','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vobo','LICE','Visto Bueno','no','no','no','funcion_listado','plani.f_lista_funcionario_wf','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','LICE','Finalizado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','vobo','LICE',1,'');
select wf.f_import_testructura_estado ('insert','vobo','finalizado','LICE',1,'');

------------------------------------------------
--catalog de AFP para dividir la obligaciones
-------------------------------------------------

select param.f_import_tcatalogo_tipo ('insert','tafp_empleado','PLANI','tafp');
select param.f_import_tcatalogo ('insert','PLANI','AFP Futuro','FUTURO','tafp_empleado');
select param.f_import_tcatalogo ('insert','PLANI','AFP Prevision','PREV','tafp_empleado');


/***********************************F-DAT-EGS-PLANI-0-24/04/2019****************************************/




/***********************************I-DAT-RAC-PLANI-7-08/05/2019****************************************/

select pxp.f_insert_tgui ('Tipo Columna (Planillas)', 'Tipo Columna (Planillas)', 'TIPCOLCUEP', 'si', 7, 'sis_contabilidad/vista/tipo_columna_cuenta/TipoColumnaCuenta.php', 3, '', 'TipoColumnaCuenta', 'CONTA');
select pxp.f_insert_tgui ('Planilla VoBo', 'Planilla VoBo', 'PLAVOBO', 'si', 2, 'sis_planillas/vista/planilla/PlanillaVb.php', 2, '', 'PlanillaVb', 'PLANI');

select conta.f_import_ttipo_relacion_contable ('insert','INCAPTEMP',NULL,'Incapacidad Temporal por Cobrar','activo','no','si','si','flujo','recurso_gasto','no','no','no',NULL);

select conta.f_import_ttipo_relacion_contable ('insert','SALXPALI',NULL,'Salario por Aplicar','activo','no','si','no','flujo','recurso_gasto','no','no','no',NULL);

select conta.f_import_ttipo_relacion_contable ('insert','CCCLMCTA','TTIP','Centro de costos columnas solo contables','activo','si-unico','no','no','','','no','no','no','');
/***********************************F-DAT-RAC-PLANI-7-08/05/2019****************************************/
/***********************************I-DAT-MMA-PLANI-6-06/06/2019****************************************/
select pxp.f_insert_tgui ('Filtro Cbte', 'Filtro Cbte', 'FOE', 'si', 7, 'sis_planillas/vista/filtro_cbte/FiltroCbte.php', 2, '', 'FiltroCbte', 'PLANI');
/***********************************F-DAT-MMA-PLANI-6-06/06/2019****************************************/

/***********************************I-DAT-EGS-PLANI-1-04/07/2019****************************************/

select pxp.f_insert_tgui ('Reporte Funcionario Planillas', 'Reporte Funcionario Planillas', 'REPFUN', 'si', 10, 'sis_planillas/vista/reporte_funcionario/FuncionarioPlanillaReporte.php', 3, '', 'FuncionarioPlanillaReporte', 'PLANI');

/***********************************F-DAT-EGS-PLANI-6-04/07/2019****************************************/



/***********************************I-DAT-RAC-PLANI-19-04/07/2019****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'plani_csv_imp_columna', E'CI', E'Define la columnas por la que se importan los archivos csv a planillas, CI o CODIGO,   carnet de identidad o codigo de empleado ');

/***********************************F-DAT-RAC-PLANI-19-04/07/2019****************************************/


/***********************************I-DAT-RAC-PLANI-21-17/07/2019****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'plani_csv_imp_pref_codemp', E'', E'los datos de esta configuracion se eliminan del frepijo de empleado para facilitar la introduccion de datos al importar columnas desde CSV');


/***********************************F-DAT-RAC-PLANI-21-17/07/2019****************************************/




/***********************************I-DAT-RAC-PLANI-38-10/09/2019****************************************/

INSERT INTO pxp.variable_global ("variable", "descripcion", "valor")
VALUES
  (E'plani_cbte_independiente', E'Si el cbte se genera N veces independiente al flujo de planilla, SI/NO', E'NO');


/***********************************F-DAT-RAC-PLANI-38-10/09/2019****************************************/



/***********************************I-DAT-RAC-PLANI-38-16/09/2019****************************************/
select pxp.f_insert_tgui ('VoBo Planillas (Conta)', 'VoBo Planillas (Conta)', 'PLAVOBOCTA', 'si', 3, 'sis_planillas/vista/planilla/PlanillaVbConta.php', 2, '', 'PlanillaVbConta', 'PLANI');
select pxp.f_insert_testructura_gui ('PLAVOBOCTA', 'PLANI');
/***********************************F-DAT-RAC-PLANI-38-16/09/2019****************************************/


/***********************************I-DAT-RAC-PLANI-113-20/04/2020****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'plani_dividir_antiguedad_tipo_contrato', E'si', E'no o si, si dividimos la antiguedad del contrato segun  el tipo de contrato en la funcion f_get_fecha_primer_contrato_empleado'),
  (E'plani_dividir_antiguedad_carga_horaria', E'si', E'no o si, si  consideramos separar la antiguedad de contratos con diferente carga horaria en la funcion f_get_fecha_primer_contrato_empleado');

/***********************************F-DAT-RAC-PLANI-113-20/04/2020****************************************/



/***********************************I-DAT-RAC-PLANI-113-30/04/2020****************************************/

select param.f_import_tdocumento ('insert','PLAPREPRI','Planilla de Prevision de Primas','PLANI','depto','gestion','',NULL);
select param.f_import_tdocumento ('insert','PLAPRIVIG','Planilla de Prima Personal Vigente','PLANI','depto','gestion','',NULL);
select param.f_import_tdocumento ('insert','PRINOVIG','Prima Personal No Vigente','PLANI','depto','gestion','',NULL);

-------------------------------------
--planillas de prevision de primas---
-------------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAPREPRI','Planilla de Prevision de Prima','PLASUB','plani.f_plaprepri_insert_empleados','prorrateo_aguinaldo','plani.f_plapri_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS1','PLAPREPRI','Dias para calculo','basica','Dias para calculo',NULL,'no',NULL,'2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','PLAPREPRI','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT11','PLAPREPRI','Prevision Cotizable1','basica','Prevision de primer sueldo para promedio',NULL,'no',NULL,'2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT12','PLAPREPRI','Prevision Cotizable2','basica','Prevision de segundo sueldo para promedo',NULL,'no',NULL,'2','2','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT13','PLAPREPRI','Prevision cotizable3','basica','prevision de tercer sueldo para promedio',NULL,'no',NULL,'2','3','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','PLAPREPRI','Prevision Cotizable1','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','PLAPREPRI','Prevision Cotizable1 2do contrato','basica','PENULTIMO COTIZABLE DE SEGUNDO CONTRATO ','','no','','2','5','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','PLAPREPRI','antepenultimo Cotizable de segundo contrato','basica','antepenultimo Cotizable de segundo contrato','','no','','2','6','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRIMA','PLAPREPRI','Prima a pagar','formula','prima a pagar','((({PREPROME1}/360*{PREDIAS1})+({PREPROME2}/360*{PREDIAS2})) *({PORCENTAJEPRIM}/100))','si_contable','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PLAPREPRI','Promedio','formula','Promedio de 3 ultimos sueldos','({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3','no','','2','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PLAPREPRI','Promedio del ultimo contrato','formula','promedio de 3 ultimos sueldos ultimo contrato','({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3','no',NULL,'2','10','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','Planilla Previsoria de Prima','PLAPREPRI','no','carta_horizontal','no','no','no','no','ninguno','nombre','activo',268,249,'Planilla Previsoria de Prima','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',0,7.00);
select plani.f_import_treporte_columna('insert','PREDIAS1','Planilla Previsoria de Prima','PLAPREPRI','si',10,5,'activo','Dias','Ctto1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREDIAS2','Planilla Previsoria de Prima','PLAPREPRI','si',10,9,'activo','Dias','Ctto2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT11','Planilla Previsoria de Prima','PLAPREPRI','si',20,2,'activo','Ctto1','Cot1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT12','Planilla Previsoria de Prima','PLAPREPRI','si',20,3,'activo','Ctto1','Cot2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT13','Planilla Previsoria de Prima','PLAPREPRI','si',20,4,'activo','Ctto1','Cot3','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT21','Planilla Previsoria de Prima','PLAPREPRI','si',20,6,'activo','Ctto2','Cot1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT22','Planilla Previsoria de Prima','PLAPREPRI','si',20,7,'activo','Ctto2','Cot2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT23','Planilla Previsoria de Prima','PLAPREPRI','si',20,8,'activo','Ctto2','Cot3','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPROME1','Planilla Previsoria de Prima','PLAPREPRI','si',20,10,'activo','Prom','Ctto1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPROME2','Planilla Previsoria de Prima','PLAPREPRI','si',20,11,'activo','Prom','Cot2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRIMA','Planilla Previsoria de Prima','PLAPREPRI','si',20,12,'activo','Prev.','Prima','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla Previsoria de Prima','PLAPREPRI','no',68,1,'activo','Nombre','Emp.','otro',0,'nombre_funcionario','vista_externa');

---------------------------------------
--planilla de personas vigente
---------------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAPRIVIG','Planilla de Prima Vigentes','PLASUB','plani.f_plaprivig_insert_empleados','prorrateo_aguinaldo','plani.f_plaprivig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERAPRI','PLAPRIVIG','Factor Frontera','basica','Factor Frontera','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','PLAPRIVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> {PRIMA} then 0 else
({PRIMA}-{IMPOFAC})*13/100*{FACFRONTERAPRI} end','si_pago','','0','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','PLAPRIVIG','Importe de Facturas al 100 porciento','variable','Importe de Facturas al 100 porciento','','no','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PLAPRIVIG','Prima Liquida','formula','Prima Liquida','{PRIMA}-{TOTDESC}','si_pago','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','PLAPRIVIG','Otros Descuentos','variable','Otros Descuentos','','si_pago','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS1','PLAPRIVIG','Dias para calculo','basica','Días para calculo','','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','PLAPRIVIG','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT11','PLAPRIVIG','Prevision Cotizable1','basica','Previsión de primer sueldo para promedio','','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT12','PLAPRIVIG','Prevision Cotizable2','basica','Previsión de segundo sueldo para promedio','','no','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT13','PLAPRIVIG','Prevision Cotizable3','basica','Previsión de tercer sueldo para promedio','','no','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','PLAPRIVIG','Prevision Cotizable 21','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','PLAPRIVIG','Prevision Cotizable 22','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','PLAPRIVIG','Prevision Cotizable 23','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PLAPRIVIG','Promedio C1','formula','Promedio de 3 ultimos sueldos','({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PLAPRIVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRIMA','PLAPRIVIG','Prima a pagar','formula','Prima a pagar','((({PREPROME1}/360*{PREDIAS1})+({PREPROME2}/360*{PREDIAS2})) *({PORCENTAJEPRIM}/100))','si_contable','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','PLAPRIVIG','Total Descuentos','formula','Total Descuentos','{OTDESC}','no','','2','17','ejecutar','no','no','no','activo');


--Configuracion Tipo Obligacion

select plani.f_import_ttipo_obligacion('insert','DESCHEQ','PLAPRIVIG','Descuento por Cheque','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','PLAPRIVIG','Liquido Prima','pago_empleados','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','PLAPRIVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','DESCHEQ','PLAPRIVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','PLAPRIVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','LIQPAG','PLAPRIVIG','no','si','si','activo');




---------------------------------------------
--   planilla de personla no vigente
----------------------------------------------

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion Tipo Planilla
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PRINOVIG','Planilla de Prima NO vigentes','PLASUB','plani.f_prinovig_insert_empleados','prorrateo_aguinaldo','plani.f_prinovig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERAPRI','PRINOVIG','Factor Frontera','basica','Factor Frontera','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','PRINOVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> {PRIMA} then 0 else
({PRIMA}-{IMPOFAC})*13/100*{FACFRONTERAPRI} end','si_pago','','0','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','PRINOVIG','Importe de Facturas al 100 porciento','variable','Importe de Facturas al 100 porciento','','no','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PRINOVIG','Prima Liquida','formula','Prima Liquida','{PRIMA}-{TOTDESC}','si_pago','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','PRINOVIG','Otros Descuentos','variable','Otros Descuentos','','si_pago','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS1','PRINOVIG','Dias para calculo','basica','Días para calculo','','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','PRINOVIG','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT11','PRINOVIG','Prevision Cotizable1','basica','Previsión de primer sueldo para promedio','','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT12','PRINOVIG','Prevision Cotizable2','basica','Previsión de segundo sueldo para promedio','','no','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT13','PRINOVIG','Prevision Cotizable3','basica','Previsión de tercer sueldo para promedio','','no','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','PRINOVIG','Prevision Cotizable 21','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','PRINOVIG','Prevision Cotizable 22','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','PRINOVIG','Prevision Cotizable 23','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PRINOVIG','Promedio C1','formula','Promedio de 3 ultimos sueldos','({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PRINOVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRIMA','PRINOVIG','Prima a pagar','formula','Prima a pagar','((({PREPROME1}/360*{PREDIAS1})+({PREPROME2}/360*{PREDIAS2})) *({PORCENTAJEPRIM}/100))','si_contable','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','PRINOVIG','Total Descuentos','formula','Total Descuentos','{OTDESC} - {IMPDET}','no','','2','17','ejecutar','no','no','no','activo');
----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion Tipo Obligacion
---------------------------------

select plani.f_import_ttipo_obligacion('insert','DESCHEQ','PRINOVIG','Descuento por Cheque','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','PRINOVIG','Liquido Prima','pago_empleados','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','PRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','DESCHEQ','PRINOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','PRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','LIQPAG','PRINOVIG','no','si','si','activo');


/***********************************F-DAT-RAC-PLANI-113-30/04/2020****************************************/



