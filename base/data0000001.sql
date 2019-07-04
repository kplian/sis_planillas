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

  