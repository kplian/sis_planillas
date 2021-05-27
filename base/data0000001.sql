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

-----------------------------------------------
--  planillas de sueldos
-------------------------------------------------

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLASUE','Planilla de Sueldos','PLASUE','plani.f_plasue_insert_empleados','hoja_calculo','plani.f_plasue_valid_empleado','si','mensual','plani.f_plasue_generar_horas_sigma',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_APNALSOL','PLASUE','AFP Aporte nacional solidario','formula','Aporte Nacional Solidario por Rangos','case when {AFP_VAR1}+{AFP_VAR2}+{AFP_VAR3} > 0 then
{AFP_VAR1}+{AFP_VAR2}+{AFP_VAR3}
else
0.00
end','si_pago','','2','26','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_APPAT','PLASUE','AFP Aporte patronal solidario','formula','Afp aporte patronal solidario del 3%','{COTIZABLE}*0.03','si','','2','20','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_APSOL','PLASUE','Afp Aporte Solidario','formula','Aporte solidario del asegurado 0.5%','{COTIZABLE}*0.005','si_pago','','2','21','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_CADM','PLASUE','AFP Costos administrativos','formula','Descuento al empleado de 0.5%','{COTIZABLE}*0.005','no','','2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_LAB','PLASUE','Suma de aportes laborales para AFP','formula','Suma laborales AFP','{AFP_APSOL}+{AFP_APNALSOL}+{AFP_LAB_COM}','no','','2','27','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_LAB_COM','PLASUE','Aportes  AFP laborales (comun)','formula','Aportes  AFP laborales (común), ','{AFP_SSO}+{AFP_RCOM}+{AFP_CADM}','si_pago','','2','26','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_PAT','PLASUE','Suma de aportes patronales para AFP','formula','Suma patronales AFP','{AFP_RIEPRO}+{AFP_VIVIE}+{AFP_APPAT}','no',NULL,'2','28','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_RCOM','PLASUE','AFP Riesgo común','formula','Afp riesgo comun descontado al empleado 1.71%','{COTIZABLE}*0.0171*{JUB65}*{MAY65}','no','','2','19','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_RIEPRO','PLASUE','AFP Riesgo profesional','formula','Riesgo profesional que paga el empleador 1.71%','{COTIZABLE}*0.0171*{JUB65}*{MAY65}','si','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_SSO','PLASUE','Afp seguro obligatorio 10%','formula','descuento del 10% al empleado por afp','{COTIZABLE}*0.1*{JUB65}*{JUB55}','no',NULL,'2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VAR1','PLASUE','AFP variable 1 para aporte nacional solidario','formula','Aporte para sueldos arriba de 13000','CASE WHEN ({COTIZABLE}-13000) > 0 THEN  ({COTIZABLE}-13000)*0.01 ELSE 0 END','no',NULL,'2','23','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VAR2','PLASUE','AFP variable 2 para aporte nacional solidario','formula','Aporte para sueldos arriba de 25000','CASE WHEN ({COTIZABLE}-25000)> 0 THEN  ({COTIZABLE}-25000)*0.05 ELSE 0 END','no',NULL,'2','24','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VAR3','PLASUE','AFP variable 3 para aporte nacional solidario','formula','Aporte para sueldos arriba de 35000','CASE WHEN ({COTIZABLE}-35000)> 0 THEN  ({COTIZABLE}-35000)*0.1 ELSE 0 END','no',NULL,'2','25','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VIVIE','PLASUE','Afp Vivienda 2%','formula','Afp Vivienda 2%','{COTIZABLE}*0.02','si',NULL,'2','22','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','APLICADES','PLASUE','Aplicar Descuento en calculo impositivo','basica','1: Si se aplica descuento en planilla impositiva en calculo del rc-iva
0: Si no aplica el descuento y va acumulando saldo para el fisco','','no','','2','30','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','APORVOLUN','PLASUE','Aportes Voluntariado','variable','Descuento por Aportes Voluntariado,  ','','si_pago','','2','0','ejecutar','no','si','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','APSIND','PLASUE','Aporte Sindical','formula','Aporte sindical','{HABBAS}*0.01','si_pago','monto_fijo_indefinido','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIB','PLASUE','Sociedad de Ingenieros Bolivia','variable','aportes realizados a la Sociedad de Ingenieros Bolivia','','si_pago','monto_fijo_indefinido','2','48','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIGCAJA','PLASUE','Asginacion de caja chica','variable','Asignación de caja chica','','no','monto_fijo_indefinido','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIGCAJA_IT','PLASUE','Asignación  de caja chica   con incapacidad temporal','formula','Asignación  de caja chica   con incapacidad temporal','CASE WHEN {INCAP_DIAS} > 0    THEN  {ASIGCAJA} - ({ASIGCAJA} * ({INCAP_DIAS} *{HORDIA}/{CARHOR}) * ({INCAP_PORC}))  ELSE {ASIGCAJA} END','si','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIGESP','PLASUE','Asignaciones especiales','variable','Asignaciones espaciales','','no','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIGESP_IT','PLASUE','Asignaciones especiales  con incapacidad temporal','formula','Asignaciones especiales  con incapacidad temporal','CASE WHEN {INCAP_DIAS} > 0    THEN   {ASIGESP} - ({ASIGESP} * ({INCAP_DIAS} *{HORDIA}/{CARHOR}) * ({INCAP_PORC})) ELSE  {ASIGESP} END','si','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIGNACIONES','PLASUE','Asignaciones','formula','Total Asignaciones','{ASIGTRA_IT} + {ASIGCAJA_IT} + {ASIGESP_IT}','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIGTRA','PLASUE','Asignación por sitio de trabajo','variable','Asignación por sitio de trabajo','','no','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','ASIGTRA_IT','PLASUE','Asignación por sitio de trabajo con incapacidad temporal','formula','Asignación por sitio de trabajo con incapacidad temporal','CASE WHEN {INCAP_DIAS} > 0    THEN {ASIGTRA} - ({ASIGTRA} *({INCAP_DIAS} *{HORDIA}/{CARHOR}) * ({INCAP_PORC})) ELSE {ASIGTRA}  END','si','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BONANT','PLASUE','Bono antiguedad','formula','Bono de Antigüedad del empleado a partir de 3 salarios mínimos nacionales con incapacidad temporal','CASE WHEN {INCAP_DIAS} > 0    THEN  {BONOANTG} - ({BONOANTG} * ({INCAP_DIAS} *{HORDIA}/{HOREFEC}) * ({INCAP_PORC}))  ELSE {BONOANTG} END','si','','2','5','restar_ejecutado','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BONFRONTERA','PLASUE','Sub. frontera','formula','bono de frontera para los empleados que correspondan','{SUELDOMES}*0.2*{FACFRONTERA}','si','','2','7','restar_ejecutado','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BONO1','PLASUE','Bono 1','variable','BONO1','','no','','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BONOANTG','PLASUE','Bono Antigüedad completo','basica','Calculo de bueno de antigüedad completo en función a al mínimo nacional','','no','','2','4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BP-RCIVA','PLASUE','Bono RC-IVA','basica','Bono produccion RC-IVA (Suma del RC-IVA de las planillas de bono de producción y se aplica como descuento)','','no','','2','1','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CACSELFIJO','PLASUE','CACSEL Aporte fijo','variable','Aporte Fijos CACSEL','','si_pago','monto_fijo_indefinido','2','48','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CACSELPRES','PLASUE','CACSEL Descuento préstamo','variable','Descuento por Prestamos CACSEL','','si_pago','monto_fijo_indefinido','2','48','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CACSELVAR','PLASUE','CACSEL Aporte porcentual','formula','Aporte Variable CACSEL (4% del total ganado)','{COTIZABLE}*0.04','si_pago','monto_fijo_indefinido','2','48','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CAJSAL','PLASUE','Caja de salud','formula','Aporte Patronal por Caja de Salud','{COTIZABLE}*0.1','si','','2','29','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CARHOR','PLASUE','Carga Horaria','basica','Carga Horaria asignada al empleado','','no','','0','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CONTPER','PLASUE','Contribuciones del Personal','variable','Descuento por contribuciones del Personal ','','si_pago','','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','COTIZABLE','PLASUE','Cotizable','formula','Cotizable sobre el que se aplican afps e impuestos','{SUELDOMES} + {BONANT}+ {BONFRONTERA} + {EXTRA}+{NOCTURNO} + {ASIGNACIONES} + {DISPONIBILIDAD} + {INCAP_TEMPORAL} + {REINTEGRO1}','no','','2','10','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','COTIZABLE_ANT','PLASUE','Cotizable anterior','basica','Cotizable  planilla anterior ','','no','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','COTIZABLE_INCAPT','PLASUE','Cotizable  para Incapacidad Temporal','formula','Cotizable  para Incapacidad Temporal','({HABBAS}*{HOREFEC}/{CARHOR}) + {BONOANTG} + ({HABBAS}*{HOREFEC}/{CARHOR}*0.2*{FACFRONTERA}) + ({HABBAS}*({HOREXT}/{CARHOR})*2) + ({HABBAS}*({HORNOC}/{CARHOR})*{FACNOCT}) + ({ASIGCAJA}+{ASIGTRA}+{ASIGESP}) + ({HABBAS}* {DIASDISP} * {FACTDISP})','no','','2','8','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESCANTC','PLASUE','Descuento Anticipo','variable','Descuento Anticipo','','si_pago','','2','49','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESCCHEQ','PLASUE','Descuento por Cheque','variable','Descuento por Impresión de Cheques',NULL,'si_pago',NULL,'2','50','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESC_LEY','PLASUE','Descuentos de ley','formula','Descuentos por AFP y RC-IVA','{IMPURET}+{AFP_LAB}','no','','2','56','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESEMPEÑO','PLASUE','Bono de desempeño','variable','Bono de desempeño','','no','','2','10','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESPAR','PLASUE','Descuento por Parqueo','variable','Descuento por Parqueo','','si_pago','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESVAR','PLASUE','Descuentos Varios','variable','Descuentos Varios','','si_pago','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DIASDISP','PLASUE','Días Disponibilidad','variable','Días de Disponibilidad','','no','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DISPONIBILIDAD','PLASUE','Disponibilidad','formula','Bono por Disponibilidad','{SUELSCL}* {DIASDISP} * {FACTDISP}','si','','2','4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','EXTRA','PLASUE','Sobretiempo','formula','Sueldo por horas extra empleado','{SUELSCL}*({HOREXT}/{HORLAB})*2','si','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_ACT','PLASUE','Factor de Actualizacion','basica','Factor de Actualizacion para saldo a favor del dependiente',NULL,'no',NULL,'10','41','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERA','PLASUE','Factor del bono de Frontera','basica','Factor que corresponde al empleado del bono de frontera','','no','','2','6','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACNOCT','PLASUE','Factor de horas nocturnas','basica','Factor de horas nocturnas, entre 0.25 a 0.5','','no','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACTDISP','PLASUE','Factor disponibilidad (entre   0 - 1)','basica','Factor disponibilidad (entre   0 - 1)','','no','','4','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACTIEMPO','PLASUE','Factor de  tiempo efectivo trabajado','formula','Factor de  tiempo efectivo trabajado','{HORNORM} / {CARHOR}','no','','10','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACTORANTI','PLASUE','Factor de Antiguedad','basica','Factor de antiguedad de acuerdo al tiempo que trabaja el empleado en la empresa','','no','','2','4','restar_ejecutado','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_ZONAFRAN','PLASUE','Factor Zona Franca','basica','Factor Zona Franca',NULL,'no',NULL,'0','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_ZONAFRAN','PLASUE','Factor Zona Franca','basica','Factor que se calcula a partir del tiempo y sueldo que trabajo el empleado en zona franca',NULL,'no',NULL,'2','33','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','HABBAS','PLASUE','Haber según escala salarial','basica','Haber según escala salarial a la fecha de la planilla','','no','','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','HORDIA','PLASUE','Horas de Dia','formula','Horas de trabajo por día según carga horaria mensual','{CARHOR}/30','no','','0','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','HOREFEC','PLASUE','Horas efectivas de trabajo','basica','Calcula las horas efectivas segun hora de tiempo','','no','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','HOREXT','PLASUE','Horas extra','basica','Horas Extra','','no','','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','HORNOC','PLASUE','Horas nocturnas','basica','Horas Nocturnas','','no','','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','HORNORM','PLASUE','Horas normales','basica','Horas Normales del Empleado','','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','PLASUE','Impuesto Determinado','formula','Impuesto Determinado','(({IMPSUJIMP})*0.13*{FAC_ZONAFRAN} ) + {REI-RCIVA} + {PRI-RCIVA}  + {BP-RCIVA}','no','','2','34','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC13','PLASUE','13% del Importe de Facturas','variable','13% del Importe presentado en Facturas','','no','','2','37','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPSUJIMP','PLASUE','Importe Sujeto a Impuesto','formula','sujeto a impuesto resta entre el sueldo neto y el minimo no imponible','CASE WHEN {SUELNETO}-{MINNOIMP} > 0  THEN {SUELNETO}-{MINNOIMP} ELSE 0 END','no',NULL,'2','32','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPURET','PLASUE','Impuesto RC-IVA','formula','Impuesto Retenido','CASE WHEN {APLICADES}=1 THEN  (CASE WHEN ({SALDOTOTALDEP}-{SALDOPERIFIS}>0) THEN 0 ELSE {SALDOPERIFIS}-{SALDOTOTALDEP} END)
else
0
end','si_pago','','2','45','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPURET_REP','PLASUE','Retención de impuestos reportes','formula','Retención de impuestos reportes','CASE WHEN ({SALDOTOTALDEP}-{SALDOPERIFIS}>0) THEN
0
ELSE
{SALDOPERIFIS}-{SALDOTOTALDEP}
END','no','','2','45','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','INCAP_DIAS','PLASUE','Días de incapacidad (de 0 a 30 días)','variable','Días de incapacidad (de 0 a 30 días)','','no','','0','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','INCAP_PORC','PLASUE','Incapacidad temporal Porcentual','formula','0.9 accidente de trabajo y maternidad, 0.75 enfermedad (sin considerar 3 días)','CASE
WHEN {INCAP_TIPO}=1 THEN 0.9
WHEN {INCAP_TIPO}=2 THEN 0.75
WHEN {INCAP_TIPO}=3 THEN 0.9
ELSE 0
END','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','INCAP_TEMPORAL','PLASUE','Incapacidad Temporal','formula','Incapacidad Temporal','{COTIZABLE_INCAPT} * {INCAP_PORC} * ({INCAP_DIAS} *{HORDIA}/{HOREFEC})','si_pago','','2','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','INCAP_TIPO','PLASUE','tipo  incapacidad (1, accidente, 2 enfermedad, 3 maternidad)','variable','tipo  incapacidad (1, accidente, 2 enfermedad, 3 maternidad)','','no','','0','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','JUB55','PLASUE','Es jubilado de 55','basica','0 si es jubilado de 55 y 1 si no es jubilado de 55',NULL,'no',NULL,'0','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','JUB65','PLASUE','Es jubilado de 65','basica','0 si es jubilado de 65 y 1 si no es',NULL,'no',NULL,'0','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LACYPRE','PLASUE','Lactancia y Prenatal','formula','Total a entregar en especie','{SUBLAC}+{SUBPRE}','no',NULL,'2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LICENCIA','PLASUE','Licencias sin goce de haberes','variable','Licencias sin goce de haberes','','si_pago','','2','49','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PLASUE','Liquido pagable','formula','Liquido Pagable','{TOTGAN}-{TOT_DESC}','si_pago','','2','58','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','MANTVAL','PLASUE','Mantenimiento de Valor','formula','Mantenimiento de Valor del saldo del periodo anterior','{SALDOPERIANTACT}-{SALDOPERIANTDEP}','no',NULL,'2','43','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','MAY55','PLASUE','Mayor de 55','basica','Indica 0 si es mayor de 55 años y 1 si es mayor de 65 años',NULL,'no',NULL,'2','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','MAY65','PLASUE','Mayor de 65','basica','0 si es mayor de 65 y 1 si no',NULL,'no',NULL,'0','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','MINNOIMP','PLASUE','Minimo no Imponible','formula','Minimo no imponible igual a 4 salarios minimos nacionales','(CASE WHEN {SUELNETO} < ({SALMIN}*2) THEN
  {SUELNETO}
ELSE
  {SALMIN}*2
END)','no',NULL,'2','31','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','MUL_ATRA','PLASUE','Multas y Atrasos','variable','Multas y Atrasos','','si_pago','','2','49','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','NATYSEP','PLASUE','Natalidad y Sepelio Pagable','formula','Liquido por  Natalidad y Sepelio Pagable  al Empleado','{SUBNAT}+{SUBSEP}','no','','0','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','NOCTURNO','PLASUE','Recargo nocturno','formula','Monto Horas Nocturnas','{SUELSCL}*({HORNOC}/{HORLAB})*{FACNOCT}','si','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','NOTCOB','PLASUE','Nota de Cobro','variable','Nota de Cobro',NULL,'si_pago','monto_fijo_indefinido','2','51','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTRO_DESC','PLASUE','Descuentos varios','formula','Otros Descuentos','{APORVOLUN}+{DESPAR}+{DESVAR} +{CONTPER}','no','','2','55','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PORDOSNAL','PLASUE','13 % Dos Mínimos Nacionales','formula','13% de dos salarios mínimos nacionales','CASE WHEN ({IMPDET}) < (2*{SALMIN}*0.13) THEN
({IMPDET})
ELSE
2*{SALMIN}*0.13
END','no','','2','35','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREAGUI','PLASUE','Previsión de aguinaldos','formula','Previsión de aguinaldos','{COTIZABLE}*0.0833','si','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRI','PLASUE','Previsión de prima','formula','Previsión de prima','{COTIZABLE}*0.0833','si','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRESPER','PLASUE','Prestamos al Personal','variable','Descuentos por prestamos al personal','','si_pago','monto_fijo_indefinido','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREVBS','PLASUE','Previsión beneficios sociales','formula','Previsión beneficios sociales','{COTIZABLE}*0.0833','si','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRI-RCIVA','PLASUE','Prima RC-IVA','basica','Prima RC-IVA (Suma del RC-IVA de las planillas prima y se aplica como descuento)','','no','','2','1','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINBANT','PLASUE','Reintegro Bono de Antiguedad','variable','Reintegro Bono de Antiguedad','','si','','2','8','restar_ejecutado','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINT_ASIG','PLASUE','Reintegro Asignaciones','variable','Esta columna se utiliza cuando se requiera compensar el pago de asignaciones al funcionario (el monto debe ser insertado de forma manual)','','si','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINT_BONOANT','PLASUE','Reintegro Bono Antigüedad','variable','Esta columna se utiliza cuando se requiera compensar el bono antigüedad del funcionario (el monto debe ser insertado de forma manual)','','si','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINT_DISP','PLASUE','Reintegro Disponibilidad','variable','Esta columna se utiliza cuando se requiera compensar la asignación de disponibilidad del funcionario (el monto debe ser insertado de forma manual)','','si','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINTEGRO1','PLASUE','Reintegro 1','formula','Totalizador de reintegros al personal que afectan al cotizable (desglosado para generar relaciones contables individuales) - DEBE IR AL COTIZABLE','{REINT_SUELDO}+{REINT_SUBFRO}+{REINT_DISP}+{REINT_BONOANT}+{REINT_EXTRA}+{REINT_NOC}+{REINT_ASIG}','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINTEGRO2','PLASUE','Reintegro 2','variable','introducción manual - NO DEBE IR AL COTIZABLE','','si','','2','0','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINT_EXTRA','PLASUE','Reintegro Sobretiempo','variable','Esta columna se utiliza cuando se requiera compensar el pago de horas extra del funcionario (el monto debe ser insertado de forma manual)','','si','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINT_NOC','PLASUE','Reintegro Recargo Nocturno','variable','Esta columna se utiliza cuando se requiera compensar el pago de horas nocturnas del funcionario (el monto debe ser insertado de forma manual)','','si','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINT_SUBFRO','PLASUE','Reintegro Sub. Frontera','variable','Esta columna se utiliza cuando se requiera compensar el subsidio frontera del funcionario (el monto debe ser insertado de forma manual)','','si','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINT_SUELDO','PLASUE','Reintegro Sueldo Mes','variable','Esta columna se utiliza cuando se requiera compensar el sueldo del funcionario (el monto debe ser insertado de forma manual)','','si','','2','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REI-PLT','PLASUE','Reintegro total para RC-IVA','variable','Suma del total cotizable de las planillas de reintegros','','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REI-RCIVA','PLASUE','Reintegro RC-IVA','basica','Reintegro RC-IVA (Suma del RC-IVA de las planillas reintegros se aplicado como descuento)','','no','','2','1','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','RETJUD','PLASUE','Retencion judicial','variable','Retención Judicial','','si_pago','monto_fijo_indefinido','2','48','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOACUMFIS','PLASUE','Saldo Acumulado a favor del Fisco','basica','Saldo acumulado para el fisco','','no','','2','37','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDODEPMOSTRAR','PLASUE','Saldo Periodo Siguiente','formula','si aplica descuento entonces el saldo, sino es 0 (para fines de reportes)','case when ({APLICADES}=0) then 0
else
{SALDODEPSIGPER}
end','no','','2','50','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDODEPSIGPER','PLASUE','Saldo Periodo Siguiente','formula','Saldo RC-IVA Periodo Siguiente a favor del dependiente','CASE WHEN ({SALDOPERIFIS}-{SALDOTOTALDEP}>0) THEN 0 ELSE {SALDOTOTALDEP}-{SALDOPERIFIS} END','no','','2','47','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOPERIANTACT','PLASUE','Saldo Anterior Actualizado','formula','Saldo Anterior Actualizado del dependiente','{SALDOPERIANTDEP}*{FAC_ACT}','no',NULL,'2','42','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOPERIANTDEP','PLASUE','Saldo del Periodo Anterior','basica','Saldo RC-IVA del Periodo Anterior del dependiente','','no','','2','40','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOPERIDEP','PLASUE','Saldo del Periodo a favor del Dependiente','formula','Saldo del Periodo a favor del Dependiente','CASE WHEN ({IMPDET}-{PORDOSNAL}<0) THEN
{IMPOFAC13}
WHEN ({PORDOSNAL}+{IMPOFAC13}-{IMPDET} >=0) THEN
({PORDOSNAL}+{IMPOFAC13}-{IMPDET})
ELSE 0 END','no','','2','38','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOPERIFIS','PLASUE','Saldo a Favor del Fisco del Periodo','formula','Saldo a Favor del Fisco del Periodo','CASE WHEN ({IMPOFAC13}+{PORDOSNAL}-({IMPDET})>=0) THEN 0 ELSE {IMPDET}-{IMPOFAC13}-{PORDOSNAL} END','no','','2','39','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOSIGPERFIS','PLASUE','Saldo del Fisco para el siguiente periodo','formula','si no se debe descontar (aplica_des=0), ir acumulando el saldo que pudiera tener a favor del fisco, sino (significa que se tiene q descontar) entonces la variable no acumula nada','CASE WHEN  {APLICADES} = 0 THEN
CASE WHEN ({SALDOTOTALDEP}-{SALDOPERIFIS}>0) THEN
0 + {SALDOACUMFIS}
ELSE
({SALDOPERIFIS}-{SALDOTOTALDEP}) +  {SALDOACUMFIS}
END
ELSE
0
END','no','','2','45','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOTOTALDEP','PLASUE','Saldo Total del Dependiente','formula','Saldo Total del Dependiente','{SALDOPERIDEP}+{SALDOPERIANTACT}','no',NULL,'2','44','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDO_UTI','PLASUE','Saldo Utilizado','formula','Saldo Utilizado','CASE WHEN {SALDOPERIFIS}>0 and {SALDOPERIANTACT}>={SALDOPERIFIS} THEN
{SALDOPERIFIS}
WHEN {SALDOPERIFIS}>0 and {SALDOPERIANTACT}<{SALDOPERIFIS} THEN
{SALDOPERIANTACT}
ELSE
0
END','no',NULL,'2','46','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBLAC','PLASUE','Subsidio de Lactancia','formula','Contiene el valor del subsidio de lactancia','{MONTOSUB}*{TIENELAC}','si_pago','monto_fijo_por_fechas','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBLACF','PLASUE','Credito Fiscal Lactancia','formula','Credito Fiscal Lactancia','(CASE WHEN {FAC_ZONAFRAN}=1 THEN
{SUBLAC}*0.13
ELSE
0
END)','si_contable','','2','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBLACGAS','PLASUE','Gasto del Subsidio de Lactancia','formula','Gasto del Subsidio de Lactancia','{SUBLAC}-{SUBLACF}','si',NULL,'2','10','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBNAT','PLASUE','Subsidio de Natalidad','variable','Subsidio de Natalidad',NULL,'si',NULL,'0','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBPRE','PLASUE','Subsidio Prenatal','formula','Subsidio Prenatal','{MONTOSUB}*{TIENEPRE}','si_pago','monto_fijo_por_fechas','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBPRECF','PLASUE','Credito Fiscal Prenatal','formula','Credito Fiscal Generado por Subsidio Prenatal','(CASE WHEN {FAC_ZONAFRAN}=1 THEN
{SUBPRE}*0.13
ELSE
0
END)','si_contable','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBPREGAS','PLASUE','Gasto del Subsidio Prenatal','formula','Gasto del Subsidio Prenatal','{SUBPRE}-{SUBPRECF}','si',NULL,'2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUBSEP','PLASUE','Subsidio de Sepelio','variable','Subsidio de Sepelio',NULL,'si',NULL,'0','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUELDOMES','PLASUE','Sueldo Mes (efectivo mes sin incapacidad temporal)','basica','Sueldo Mes (efectivo mes sin incapacidad temporal)','','si','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUELNETO','PLASUE','Sueldo Neto','formula','Total Ganado menos AFP','{COTIZABLE}-{AFP_LAB}+{DESEMPEÑO}+{REI-PLT}+{VAC_FIN}+{VIATICO}','no','','2','30','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUELSCL','PLASUE','Sueldo Según Escala (sin incapacidad temporal)','basica','Sueldo Según Escala (sin incapacidad temporal)','','no','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUHORA','PLASUE','Sueldo por hora','basica','Costo por hora empleado',NULL,'no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TIENELAC','PLASUE','Tiene Lactancia','basica','Tiene Lactancia',NULL,'no',NULL,'0','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TIENEPRE','PLASUE','Tiene Prenatal','basica','Tiene Prenatal',NULL,'no',NULL,'0','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOT_DESC','PLASUE','Total descuentos','formula','Total Descuentos','{OTRO_DESC}+{IMPURET}+{AFP_LAB}+{DESCANTC}+{RETJUD}+{MUL_ATRA}+{DESCCHEQ}+{NOTCOB} +{CACSELVAR}+{CACSELFIJO}+{CACSELPRES}+{ASIB}+{APSIND}+{PRESPER}+{LICENCIA}+{TOTSUB}','no','','2','56','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTGAN','PLASUE','Total Ganado','formula','Total Ganado, incluye subsidios','{TOTSUB} + {COTIZABLE} + {REINTEGRO2}','no','','2','57','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTSUB','PLASUE','Total Subsidios','formula','Total Subsidios','{SUBNAT}+{SUBPRE}+{SUBLAC}+{SUBSEP}','no',NULL,'2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','UFV_FIN','PLASUE','UFV Final','basica','UFV Final','','no','','20','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','UFV_INI','PLASUE','UFV inicial','basica','UFV inicial','','no','','20','0','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','VAC_FIN','PLASUE','Vacación pagada','variable','Vacación pagada','','no','','2','10','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','VIATICO','PLASUE','Viáticos al 100% para calculo de RC-IVA','variable','Viáticos al 100% para calculo de RC-IVA','','no','','2','33','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','APORVOLUN','PLASUE','Pago por Aportes voluntariado','pago_comun','no','no',NULL,'Pago por Aportes voluntariado','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','ASIB','PLASUE','Aporte Sociedad de Ingenieros','pago_comun','no','si',NULL,'Aporte Sociedad de Ingenieros','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','CACSEL','PLASUE','CACSEL','pago_comun','no','si','CACSEL','CACSEL FIJO','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','CACSELPRES','PLASUE','CACSEL','pago_comun','no','si','CACSEL','CACSEL PRESTAMO','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','CACSELVAR','PLASUE','CACSEL','pago_comun','no','si','CACSEL','CACSEL VARIABLE','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','CAJSAL','PLASUE','Pago Caja de Salud','pago_comun','si','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','CONTPER','PLASUE','Pago por contribuciones del Personal','pago_comun','no','no',NULL,'Pago por contribuciones del Personal','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','DESC_ANTIC','PLASUE','Descuento por anticipos','una_obligacion_x_empleado','no','no',NULL,'Descuenta del liquido pagable los anticipos del empleado','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','DESCHEQ','PLASUE','Obligación por descuento por cheques','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','DESPAR','PLASUE','Descuentos por Parqueo','una_obligacion_x_empleado','no','no',NULL,'Descuentos por Parqueo','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','DESVAR','PLASUE','Descuentos Varios','una_obligacion_x_empleado','no','no',NULL,'Descuentos Varios','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','IMPU','PLASUE','Pago de Impuestos','pago_comun','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','PLASUE','Liquido Pagable Natalidad/Sepelio','una_obligacion_x_empleado','no','si',NULL,'Liquido Pagable Natalidad/Sepelio','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','MUL_ATRA','PLASUE','Obligación de Multas y Atrasos','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','NOTCOB','PLASUE','Obligación por notas de cobro','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','OBLICEN','PLASUE','Obligación Licencias sin goce de haberes','pago_comun','no','no',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','PAGO_AFP_APNALSOL','PLASUE','Pago AFP Aportes Nacional Solidario','pago_afp','no','si','AFP','Pago AFP Aportes Nacional Solidario','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','PAGO_AFP_APPAT','PLASUE','Pago AFP Aporte Patronal Solidario','pago_afp','no','si','AFP','Pago AFP Aporte Patronal Solidario','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','PAGO_AFP_APSOL','PLASUE','Pago AFP Aporte Laboral Solidario','pago_afp','no','si','AFP','Pago AFP Aporte Laboral Solidario','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','PAGO_AFP_LAB','PLASUE','Pago AFP Aportes Laborales (Comunes)','pago_afp','no','si','AFP','Pago AFP Aportes Laborales Comunes','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','PAGO_AFP_RIEPRO','PLASUE','Pago AFP Riesgo Profesional','pago_afp','no','si','AFP','Pago AFP Riesgo Profesional','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','PAGO_AFP_VIVIE','PLASUE','Pago AFP Vivienda','pago_afp','no','si','AFP','Pago AFP Vivienda','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','PRESPER','PLASUE','Prestamos al personal','una_obligacion_x_empleado','no','no',NULL,'descuentos por Prestamos al personal','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','PREV_AGUI','PLASUE','Previsión para aguinaldos','pago_comun','no','no',NULL,'Previsión para aguinaldos','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','PREV_BS','PLASUE','Previsión para beneficios sociales','pago_comun','no','no',NULL,'Previsión para beneficios sociales','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','PREV_PRIMA','PLASUE','Previsión para prima','pago_comun','no','no',NULL,'Previsión para prima','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','RETJUD','PLASUE','Pago Retenciones Judiciales','una_obligacion_x_empleado','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','SINDICATO','PLASUE','Pago Sindicato','pago_comun','no','no',NULL,'Pago sindicato por descuento de planillas','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','SUBSI','PLASUE','Pago Lacteosbol','pago_comun','si','si',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','SUEL','PLASUE','Pago Sueldo Líquido','pago_empleados','no','si',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','APORVOLUN','APORVOLUN','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','APORVOLUN','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','APORVOLUN','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','ASIB','ASIB','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','ASIB','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','ASIB','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','CACSELFIJO','CACSEL','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','CACSEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','CACSEL','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','CACSELPRES','CACSELPRES','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','CACSELPRES','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','CACSELPRES','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','CACSELVAR','CACSELVAR','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','CACSELVAR','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','CACSELVAR','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','CAJSAL','CAJSAL','PLASUE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','CONTPER','CONTPER','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','CONTPER','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','CONTPER','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','DESCANTC','DESC_ANTIC','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','DESC_ANTIC','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','DESC_ANTIC','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','DESCCHEQ','DESCHEQ','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','DESCHEQ','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','DESCHEQ','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','DESPAR','DESPAR','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','DESPAR','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','DESPAR','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','DESVAR','DESVAR','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','DESVAR','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','DESVAR','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','IMPURET','IMPU','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','IMPU','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','IMPU','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBNAT','LIQPAG','PLASUE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBSEP','LIQPAG','PLASUE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','MUL_ATRA','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','MUL_ATRA','MUL_ATRA','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','MUL_ATRA','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','NOTCOB','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','NOTCOB','NOTCOB','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','NOTCOB','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','OBLICEN','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LICENCIA','OBLICEN','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','OBLICEN','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_APNALSOL','PAGO_AFP_APNALSOL','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','PAGO_AFP_APNALSOL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','PAGO_AFP_APNALSOL','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_APPAT','PAGO_AFP_APPAT','PLASUE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_APSOL','PAGO_AFP_APSOL','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','PAGO_AFP_APSOL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','PAGO_AFP_APSOL','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_LAB_COM','PAGO_AFP_LAB','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','PAGO_AFP_LAB','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','PAGO_AFP_LAB','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_RIEPRO','PAGO_AFP_RIEPRO','PLASUE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_VIVIE','PAGO_AFP_VIVIE','PLASUE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','PRESPER','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRESPER','PRESPER','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','PRESPER','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PREAGUI','PREV_AGUI','PLASUE','si','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PREVBS','PREV_BS','PLASUE','si','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PREPRI','PREV_PRIMA','PLASUE','si','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','RETJUD','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','RETJUD','RETJUD','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','RETJUD','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','APSIND','SINDICATO','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','SINDICATO','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','SINDICATO','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBLAC','SUBSI','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBLACF','SUBSI','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBLACGAS','SUBSI','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBPRE','SUBSI','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBPRECF','SUBSI','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUBPREGAS','SUBSI','PLASUE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','ASIGCAJA_IT','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','ASIGESP_IT','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','ASIGTRA_IT','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONANT','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONFRONTERA','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','DISPONIBILIDAD','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','EXTRA','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','INCAP_TEMPORAL','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','SUEL','PLASUE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','NOCTURNO','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REINBANT','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REINTEGRO1','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REINTEGRO2','SUEL','PLASUE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','SUELDOMES','SUEL','PLASUE','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','Planilla de Sueldos','PLASUE','no','carta_horizontal','si','no','si','si','gerencia','nombre','activo',216,249,'Planilla de Sueldos',NULL,'planilla',NULL,NULL,NULL,NULL,NULL,'BS',NULL,NULL);
select plani.f_import_treporte('insert','BOLETA DE PAGO','PLASUE','no','carta_vertical','no','no','no','no','distrito','nombre','activo',0,186,'BOLETA DE PAGO','','boleta','si','plani.vdatos_func_planilla',8,NULL,NULL,'BS',NULL,NULL);
select plani.f_import_treporte('insert','Planilla de Subsidios','PLASUE','no','carta_horizontal','si','no','si','si','gerencia','nombre','activo',175,249,'Planilla de Subsidios','','planilla',NULL,NULL,NULL,NULL,NULL,'BS',NULL,NULL);
select plani.f_import_treporte('insert','RESUMEN RELACION DE SALDOS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'RESUMEN RELACION DE SALDOS','relacion_saldos','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','RELACION DE SALDOS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',1,186,'RELACION DE SALDOS','relacion_saldos_det','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','31: DESIGNACION DE CARGOS','PLASUE','no','carta_horizontal','no','no','no','no','ninguno','nombre','activo',0,249,'31: DESIGNACION DE CARGOS','asignacion_cargos','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','32: DIRECTORIO DE EMPLEADOS POR CENTRO','PLASUE','no','carta_horizontal','no','no','no','no','centro','nombre','activo',0,249,'32: DIRECTORIO DE EMPLEADOS POR CENTRO','directorio_empleados','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','23: MOVIMIENTOS DE PERSONAL','PLASUE','no','carta_horizontal','no','no','no','no','centro','nombre','activo',0,249,'23: MOVIMIENTOS DE PERSONAL','movimiento_personal','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','20: APORTE PORCENTUAL SINDICATO','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',200,186,'20: APORTE PORCENTUAL SINDICATO','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',1,7.00);
select plani.f_import_treporte('insert','27: NOMINA DEPENDIENTES','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'27: NOMINA DEPENDIENTES','dependientes','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','02: CURVA SALARIAL POR CENTRO','PLASUE','no','oficio_horizontal','no','no','no','no','ninguno','nombre','activo',0,300,'02: CURVA SALARIAL POR CENTRO','curva_salarial_centro','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','28: GRUPO FAMILIAR - Clasificación de los hijos según edades','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'28: GRUPO FAMILIAR - Clasificación de los hijos según edades','dependientes_edad','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','10: CARGOS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'10: CARGOS','lista_cargos','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','30: CLASIFICACION DE PERSONAL POR PROFESIONES','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'30: CLASIFICACION DE PERSONAL POR PROFESIONES','profesiones','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','20: NOMINA PERSONAL NO SINDICALIZADO','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'20: NOMINA PERSONAL NO SINDICALIZADO','no_sindicato','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','09: FRECUENCIA DE CARGOS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'09: FRECUENCIA DE CARGOS','frecuencia_cargos','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','PERSONAL RETIRADO','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'PERSONAL RETIRADO','personal_ret','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','01: CURVA SALARIAL','PLASUE','no','oficio_horizontal','no','no','no','no','ninguno','nombre','activo',0,300,'01: CURVA SALARIAL','curva_salarial','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','APORTE AFP - PERSONAL VIGENTE','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'APORTE AFP - PERSONAL VIGENTE','aporte_afp','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','03: BENEFICIOS SOCIALES - RESUMEN','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'03: BENEFICIOS SOCIALES - RESUMEN','reserva_beneficios2','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','14: DESCUENTOS ACUMULADOS PTM CACSEL','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',180,186,'14: DESCUENTOS ACUMULADOS PTM CACSEL','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',1,7.00);
select plani.f_import_treporte('insert','18: DESCUENTOS ACUMULADOS APORTE VOLUNTARIADO','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',180,186,'18: DESCUENTOS ACUMULADOS APORTE VOLUNTARIADO','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',1,7.00);
select plani.f_import_treporte('insert','Planilla de Sueldos Multilinea','PLASUE','no','carta_horizontal','no','no','no','no','centro','organigrama','activo',0,249,'Planilla de Sueldos Multilinea','','planilla','si','plani.vdatos_func_planilla',11,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','11: LISTADO POR DISTRITOS','PLASUE','no','carta_vertical','no','no','no','no','distrito','nombre','activo',200,186,'11: LISTADO POR DISTRITOS','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',0,10.00);
select plani.f_import_treporte('insert','15: DESCUENTOS ACUMULADOS SIB','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',180,186,'15: DESCUENTOS ACUMULADOS SIB','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',1,7.00);
select plani.f_import_treporte('insert','19: PERSONAL DISPONIBLE','PLASUE','no','carta_vertical','no','no','no','no','distrito','codigo_empleado','activo',180,186,'19: PERSONAL DISPONIBLE','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',1,7.00);
select plani.f_import_treporte('insert','AFP - FONDO SOLIDARIO','PLASUE','no','carta_horizontal','no','no','no','no','ninguno','nombre','activo',0,249,'AFP - FONDO SOLIDARIO','fondo_solidario','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','24: FECHA DE NACIMIENTO POR AÑO','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'24: FECHA DE NACIMIENTO POR AÑO','nacimiento_ano','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','24: FECHA DE NACIMIENTO POR MES','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'24: FECHA DE NACIMIENTO POR MES','nacimiento_mes','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','PERSONAL INCORPORADO','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'PERSONAL INCORPORADO','personal_inc','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','Planilla Tributaria','PLASUE','no','carta_horizontal','si','si','no','no','gerencia','nombre','activo',160,249,'Planilla Tributaria','planilla_tributaria','formato_especifico','no','planilla_tributaria',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','Planilla Impositiva','PLASUE','no','oficio_horizontal','no','no','no','no','ninguno','nombre','activo',342,300,'Planilla Impositiva','','planilla','no','plani.vdatos_func_planilla',0,'si','no','BS',0,7.00);
select plani.f_import_treporte('insert','25: ANTIGUEDAD DE LOS EMPLEADOS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'25: ANTIGUEDAD DE LOS EMPLEADOS','empleado_antiguedad','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','16: NOMINA DE SALARIOS BC','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'16: NOMINA DE SALARIOS BC','nomina_salario','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','16: NOMINA DE SALARIOS CT','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'16: NOMINA DE SALARIOS CT','nomina_salario1','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','29: CLASIFICACION DEL PERSONAL POR EDADES','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'29: CLASIFICACION DEL PERSONAL POR EDADES','empleado_edad','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','03: BENEFICIOS SOCIALES - 1 MES','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'03: BENEFICIOS SOCIALES - 1 MES','reserva_beneficios','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','03: PLANILLA DE RESERVA PARA BENEFICIOS SOCIALES','PLASUE','no','carta_horizontal','no','no','no','no','ninguno','nombre','activo',0,249,'03: PLANILLA DE RESERVA PARA BENEFICIOS SOCIALES','reserva_beneficios3','formato_especifico','no','',0,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','08: TOTAL HORAS TRABAJADAS','PLASUE','no','carta_horizontal','no','no','no','no','centro','organigrama','activo',258,249,'08: TOTAL HORAS TRABAJADAS','','planilla','no','plani.vdatos_horas_funcionario',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','Planilla de Sueldos Multilinea por Distrito','PLASUE','no','carta_horizontal','no','no','no','no','distrito','organigrama','activo',0,249,'Planilla de Sueldos Multilinea por Distrito','','planilla','si','plani.vdatos_func_planilla',11,'no','no','BS',NULL,NULL);
select plani.f_import_treporte('insert','14: DESCUENTOS ACUMULADOS CACSEL','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',180,186,'14: DESCUENTOS ACUMULADOS CACSEL','','planilla','no','plani.vdatos_func_planilla',0,'no','no','$us',1,7.00);
select plani.f_import_treporte('insert','14: APORTE PORCENTUAL CACSEL','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',180,186,'14: APORTE PORCENTUAL CACSEL','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','21: DESCUENTOS ACUMULADOS VARIOS 1','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',180,186,'21: DESCUENTOS ACUMULADOS VARIOS 1','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',1,7.00);
select plani.f_import_treporte('insert','22: LISTA ALFABETICA EMP CI','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',200,186,'22: LISTA ALFABETICA EMP CI','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',0,10.00);
select plani.f_import_treporte('insert','DESCUENTOS ACUMULADOS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',110,186,'DESCUENTOS ACUMULADOS','','bono_descuento','no','plani.vdatos_func_planilla',0,'no','no','BS',0,5.00);
select plani.f_import_treporte('insert','Saldos Acumulados Rc-IVA','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'Saldos Acumulados Rc-IVA','saldo_fisco','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','LISTADO POR CENTROS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'LISTADO POR CENTROS','listado_centros','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','17: DECLARACIONES FORMULARIO 101','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',200,186,'17: DECLARACIONES FORMULARIO 101','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',1,7.00);
select plani.f_import_treporte_columna('insert','HORNORM','Planilla de Sueldos','PLASUE','si',15,1,'activo','Horas','Normales','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SUELDOMES','Planilla de Sueldos','PLASUE','si',20,2,'activo','Haber','Básico','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','BONANT','Planilla de Sueldos','PLASUE','si',15,3,'activo','Bono','Antig','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','BONFRONTERA','Planilla de Sueldos','PLASUE','si',15,4,'activo','Bono','Front','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','COTIZABLE','Planilla de Sueldos','PLASUE','si',20,5,'activo','Total','Ingresos','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','IMPURET','Planilla de Sueldos','PLASUE','si',15,6,'activo','RC-IVA',' ','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','AFP_LAB','Planilla de Sueldos','PLASUE','si',15,7,'activo','AFP',' ','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','OTRO_DESC','Planilla de Sueldos','PLASUE','si',18,8,'activo','Otros','Descuentos','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','TOT_DESC','Planilla de Sueldos','PLASUE','si',18,10,'activo','Total','Descuentos','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','LIQPAG','Planilla de Sueldos','PLASUE','si',15,11,'activo','Liquido','Pagable','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SUBLAC','Planilla de Subsidios','PLASUE','si',20,1,'activo','Subsidio','Lactancia','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SUBPRE','Planilla de Subsidios','PLASUE','si',20,2,'activo','Subsidio','Prenatal','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','LACYPRE','Planilla de Subsidios','PLASUE','si',20,3,'activo','Total','Lac-Pre','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SUBNAT','Planilla de Subsidios','PLASUE','si',20,4,'activo','Subsidio','Natal','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SUBSEP','Planilla de Subsidios','PLASUE','si',20,5,'activo','Subsidio','Sepelio','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','NATYSEP','Planilla de Subsidios','PLASUE','si',20,6,'activo','Liquido','Pagable','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','TOTSUB','Planilla de Subsidios','PLASUE','si',20,7,'activo','total','Subsidios','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SALDOPERIFIS','Planilla Impositiva','PLASUE','si',18,12,'activo','Saldo a favor','Fisco','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDODEPSIGPER','Planilla Impositiva','PLASUE','si',18,21,'activo','Saldo Mes','Siguiente','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOPERIANTDEP','Planilla Impositiva','PLASUE','si',18,14,'activo','Saldo Tot a','Mes Ant.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOPERIDEP','Planilla Impositiva','PLASUE','si',18,13,'activo','Saldo a favor','Dependiente','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','IMPOFAC13','Planilla Impositiva','PLASUE','si',18,9,'activo','Comp.','Form 110','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','IMPSUJIMP','Planilla Impositiva','PLASUE','si',18,7,'activo','Dif. Sujeta','a Impuesto','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','MINNOIMP','Planilla Impositiva','PLASUE','si',18,5,'activo','Minimo no','Imponible','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PORDOSNAL','Planilla Impositiva','PLASUE','si',18,11,'activo','13% sobre','dos SMN','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','DESCANTC','Planilla de Sueldos','PLASUE','si',15,9,'activo','Anticipo',' ','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','AFP_APPAT','Planilla de Sueldos Multilinea','PLASUE','si',0,1,'activo','Solidario','Pat','otro',10,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','no',0,2,'activo','Fech.','Ingreso','otro',0,'fecha_ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','si',0,6,'activo','Prenatal',' ','otro',2,'subpre','vista_externa');
select plani.f_import_treporte_columna('insert','IMPURET','Planilla de Sueldos Multilinea','PLASUE','si',0,7,'activo','Imp.','RCIVA','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRESPER','Planilla de Sueldos Multilinea','PLASUE','si',0,52,'activo','Préstamo',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_SSO','Planilla de Sueldos Multilinea','PLASUE','si',0,9,'activo','Cuota','Indiv','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','ASIB','Planilla de Sueldos Multilinea','PLASUE','si',0,10,'activo','S.I.B.',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_RIEPRO','Planilla de Sueldos Multilinea','PLASUE','si',0,12,'activo','Riesgo','Prof.','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','no',0,13,'activo','Cd','Empleado','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','si',0,17,'activo','Lactancia',' ','otro',0,'sublac','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','si',0,18,'activo','Prdt.','Lact.','otro',0,'sublac','vista_externa');
select plani.f_import_treporte_columna('insert','AFP_RCOM','Planilla de Sueldos Multilinea','PLASUE','si',0,20,'activo','Riesgo','Común','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','CAJSAL','Planilla de Sueldos Multilinea','PLASUE','si',0,23,'activo','CPS',' ','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','no',0,24,'activo','Fech.','Nac.','otro',0,'fecha_nacimiento','vista_externa');
select plani.f_import_treporte_columna('insert','HABBAS','Planilla de Sueldos Multilinea','PLASUE','si',0,25,'activo','Sueldo','Base','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','HOREXT','Planilla de Sueldos Multilinea','PLASUE','si',0,26,'activo','Hrs.','Extras','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','EXTRA','Planilla de Sueldos Multilinea','PLASUE','si',0,27,'activo','Sobretiempo',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','si',0,28,'activo','Natalidad','/Sepelio','otro',0,'subsep','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','si',0,29,'activo','Prenatal',' ','otro',0,'subpre','vista_externa');
select plani.f_import_treporte_columna('insert','CACSELPRES','Planilla de Sueldos Multilinea','PLASUE','si',0,30,'activo','Ptm','CACSEL','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_CADM','Planilla de Sueldos Multilinea','PLASUE','si',0,31,'activo','Cuota','Adm.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','APSIND','Planilla de Sueldos Multilinea','PLASUE','si',0,32,'activo','Ap.','Sindicato','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','DESCANTC','Planilla de Sueldos Multilinea','PLASUE','si',0,33,'activo','Anticipos',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUELDOMES','Planilla de Sueldos Multilinea','PLASUE','si',0,36,'activo','Sueldo','Mes','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','HORNOC','Planilla de Sueldos Multilinea','PLASUE','si',0,37,'activo','Hrs.','Nocturnas','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','NOCTURNO','Planilla de Sueldos Multilinea','PLASUE','si',0,38,'activo','Recargo','Noct.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','OTRO_DESC','Planilla de Sueldos Multilinea','PLASUE','si',0,44,'activo','Desc.','Varios','otro',3,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRI','Planilla de Sueldos Multilinea','PLASUE','si',0,45,'activo','Prima',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','BONFRONTERA','Planilla de Sueldos Multilinea','PLASUE','si',0,47,'activo','Sub.','Frontera','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO1','Planilla de Sueldos Multilinea','PLASUE','si',0,48,'activo','Reintegro','1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_APNALSOL','Planilla de Sueldos Multilinea','PLASUE','si',0,53,'activo','Nac.','Solidario','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','TOT_DESC','Planilla de Sueldos Multilinea','PLASUE','si',0,55,'activo','Tot.','Desc.','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREAGUI','Planilla de Sueldos Multilinea','PLASUE','si',0,56,'activo','P.','Aguinaldo','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','DISPONIBILIDAD','Planilla de Sueldos Multilinea','PLASUE','si',0,58,'activo','Disponibilidad',' ','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO2','Planilla de Sueldos Multilinea','PLASUE','si',0,59,'activo','Reintegro','2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_APSOL','Planilla de Sueldos Multilinea','PLASUE','si',0,64,'activo','Solidario','Aseg.','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','LICENCIA','Planilla de Sueldos Multilinea','PLASUE','si',0,65,'activo','Licencias',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_VIVIE','Planilla de Sueldos Multilinea','PLASUE','si',0,67,'activo','PROVI','Pat','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','BONANT','Planilla de Sueldos Multilinea','PLASUE','si',0,69,'activo','B.','Antiguedad','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','ASIGNACIONES','Planilla de Sueldos Multilinea','PLASUE','si',0,71,'activo','Asignaciones',' ','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','MUL_ATRA','Planilla de Sueldos Multilinea','PLASUE','si',0,74,'activo','Multas',' ','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','COTIZABLE_ANT','Planilla de Sueldos Multilinea','PLASUE','si',0,78,'activo','Cotiz.','Ant.','otro',3,'','columna_planilla');
select plani.f_import_treporte_columna('insert','HORNORM','Planilla de Sueldos Multilinea','PLASUE','si',0,81,'activo','Hrs.','Normales','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELFIJO','Planilla de Sueldos Multilinea','PLASUE','si',0,19,'activo','Cuot.','CACSEL','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','RETJUD','Planilla de Sueldos Multilinea','PLASUE','si',0,51,'activo','Ret','Judicial','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','INCAP_TEMPORAL','Planilla de Sueldos Multilinea','PLASUE','si',0,16,'activo','Incap','Temp','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','no',0,15,'activo','Cargo',' ','otro',0,'cargo','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','no',0,4,'activo','Nombre','Empleado','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','SUBNAT','Planilla de Sueldos Multilinea','PLASUE','si',0,40,'activo','Natalidad',' ','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','COTIZABLE','Planilla de Sueldos Multilinea','PLASUE','si',0,82,'activo','Cotizable',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','LICENCIA','BOLETA DE PAGO','PLASUE','si',0,24,'activo',' ','Licencias','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','no',0,35,'activo','Nivel',' - CS','otro',0,'nivel','vista_externa');
select plani.f_import_treporte_columna('insert','PREAGUI','Planilla de Sueldos Multilinea','PLASUE','si',0,34,'activo','Reserva','BS','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea','PLASUE','si',0,89,'activo','Total','General','otro',0,'total_gral','vista_externa');
select plani.f_import_treporte_columna('insert','LIQPAG','Planilla de Sueldos Multilinea','PLASUE','si',0,88,'activo','Lq.','Pagable','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO','PLASUE','no',0,1,'activo','Nombre:',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO','PLASUE','no',0,2,'activo','Cargo:',' ','otro',2,'cargo','vista_externa');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO','PLASUE','no',0,3,'activo','Fecha','Ingreso:','otro',2,'fecha_ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','DESC_LEY','BOLETA DE PAGO','PLASUE','si',0,46,'activo','Total','Desc Ley','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','BONANT','BOLETA DE PAGO','PLASUE','si',0,10,'activo','B.','Antigüedad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO1','BOLETA DE PAGO','PLASUE','si',0,14,'activo','Reint.','1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_CADM','BOLETA DE PAGO','PLASUE','si',0,15,'activo','Cuot','Adm0.5%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELPRES','BOLETA DE PAGO','PLASUE','si',0,16,'activo','Ptm','CACSEL','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRESPER','BOLETA DE PAGO','PLASUE','si',0,19,'activo','Otros','Ptmos','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','NOCTURNO','BOLETA DE PAGO','PLASUE','si',0,23,'activo','Rec.','Nocturno','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','TOT_DESC','BOLETA DE PAGO','PLASUE','si',0,44,'activo','Tot.','Desc.','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','INCAP_TEMPORAL','BOLETA DE PAGO','PLASUE','si',0,45,'activo','Incap.','Temp.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO2','BOLETA DE PAGO','PLASUE','si',0,17,'activo','Reint.','2','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','DISPONIBILIDAD','BOLETA DE PAGO','PLASUE','si',0,25,'activo',' ','Disponibilidad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDO_UTI','Planilla Impositiva','PLASUE','si',18,19,'activo','Saldo','Utilizado','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO','PLASUE','no',0,5,'activo','Nivel',' ','otro',1,'nivel','vista_externa');
select plani.f_import_treporte_columna('insert','ASIB','BOLETA DE PAGO','PLASUE','si',0,13,'activo',' ','S.I.B.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','ASIGESP','BOLETA DE PAGO','PLASUE','no',0,28,'activo','Asig.','Esp.','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUBSEP','BOLETA DE PAGO','PLASUE','si',0,36,'activo','Natalidad/','Sepelio','otro',6,'subsep','vista_externa');
select plani.f_import_treporte_columna('insert','CACSELVAR','Planilla de Sueldos Multilinea','PLASUE','si',0,8,'activo','Fond.','CACSEL','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla Impositiva','PLASUE','no',14,1,'activo','Cod. Emp.',' ','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','IMPDET','Planilla Impositiva','PLASUE','si',18,8,'activo','Impuesto','13%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOPERIANTACT','Planilla Impositiva','PLASUE','si',18,16,'activo','Saldo Ant','Actualiz','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOTOTALDEP','Planilla Impositiva','PLASUE','si',18,18,'activo','Saldo Favor','Dependiente','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUELNETO','Planilla Impositiva','PLASUE','si',18,4,'activo','Sueldo','Neto','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','IMPURET','BOLETA DE PAGO','PLASUE','si',0,40,'activo','Descto','RC-IVA','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO','PLASUE','no',0,4,'activo','Codigo:',' ','otro',1,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','MANTVAL','Planilla Impositiva','PLASUE','si',18,15,'activo','Actualiz',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla Impositiva','PLASUE','no',58,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','EXTRA','BOLETA DE PAGO','PLASUE','si',0,20,'activo',' ','Sobretiempos','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','MUL_ATRA','BOLETA DE PAGO','PLASUE','si',0,38,'activo',' ','Multas','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','DESCANTC','BOLETA DE PAGO','PLASUE','si',0,22,'activo',' ','Anticipos','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUELDOMES','BOLETA DE PAGO','PLASUE','si',0,6,'activo','Sueldo','Base','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_RCOM','BOLETA DE PAGO','PLASUE','si',0,11,'activo','R.','Com1.71%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELVAR','BOLETA DE PAGO','PLASUE','si',0,12,'activo','Cuot.','CACSEL','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_APSOL','BOLETA DE PAGO','PLASUE','si',0,21,'activo','Ap. Sol','Aseg.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','HORNORM','BOLETA DE PAGO','PLASUE','si',0,26,'activo','Hrs.','Normales','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','HOREXT','BOLETA DE PAGO','PLASUE','si',0,29,'activo','Hrs.','Extras','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','OTRO_DESC','BOLETA DE PAGO','PLASUE','si',0,39,'activo','Desc.','Varios','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUBLAC','BOLETA DE PAGO','PLASUE','si',0,35,'activo','Sub.','Lactancia','otro',2,'sublac','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_SSO','BOLETA DE PAGO','PLASUE','si',0,7,'activo','C.','Indiv.10%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELFIJO','BOLETA DE PAGO','PLASUE','si',0,8,'activo','Fond.','CACSEL','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','APSIND','BOLETA DE PAGO','PLASUE','si',0,9,'activo','Ap.','Sindicato','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','RETJUD','BOLETA DE PAGO','PLASUE','si',0,30,'activo','Ret.','Judicial','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO','PLASUE','si',0,31,'activo','Sub.','Prenatal','otro',2,'subpre','vista_externa');
select plani.f_import_treporte_columna('insert','HORNOC','BOLETA DE PAGO','PLASUE','si',0,32,'activo','Hrs.','Nocturnas','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUBNAT','BOLETA DE PAGO','PLASUE','si',0,33,'activo',' ','Natalidad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','BONFRONTERA','BOLETA DE PAGO','PLASUE','si',0,41,'activo','Sub.','Frontera','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','tot','BOLETA DE PAGO','PLASUE','si',0,47,'activo','Total','Ganado','otro',4,'total_ganado','vista_externa');
select plani.f_import_treporte_columna('insert','LIQPAG','BOLETA DE PAGO','PLASUE','si',0,48,'activo','Liquido','Pagable','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_APNALSOL','BOLETA DE PAGO','PLASUE','si',0,18,'activo','Aporte Nal','Sol.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','LIQPAG','RELACION DE SALDOS','PLASUE','no',1,1,'activo','1','1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','08: TOTAL HORAS TRABAJADAS','PLASUE','no',18,1,'activo','Código',' ','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','08: TOTAL HORAS TRABAJADAS','PLASUE','no',120,2,'activo',' ','Nombre','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','08: TOTAL HORAS TRABAJADAS','PLASUE','si',20,3,'activo','Horas','Comp','otro',0,'horas_comp','vista_externa');
select plani.f_import_treporte_columna('insert','','08: TOTAL HORAS TRABAJADAS','PLASUE','si',20,4,'activo','Horas','Normales','otro',0,'horas_normales','vista_externa');
select plani.f_import_treporte_columna('insert','HOREXT','08: TOTAL HORAS TRABAJADAS','PLASUE','si',20,5,'activo','Horas','Extra','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','HORNOC','08: TOTAL HORAS TRABAJADAS','PLASUE','si',20,6,'activo','Horas','Nocturnas','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','08: TOTAL HORAS TRABAJADAS','PLASUE','si',20,7,'activo','Horas Extra','Vacacion','otro',0,'horas_extra_vacacion','vista_externa');
select plani.f_import_treporte_columna('insert','','08: TOTAL HORAS TRABAJADAS','PLASUE','si',20,8,'activo','Horas Noct','Vacacion','otro',0,'horas_noct_vacacion','vista_externa');
select plani.f_import_treporte_columna('insert','SUELNETO','Planilla Tributaria','PLASUE','si',15,3,'activo','Sueldo','Neto','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','MINNOIMP','Planilla Tributaria','PLASUE','no',15,4,'activo','Minimo','No Imp','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','IMPSUJIMP','Planilla Tributaria','PLASUE','no',15,5,'activo','Dif Sujeto','a Impuesto','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','IMPOFAC13','Planilla Tributaria','PLASUE','no',15,6,'activo','Impuesto','13%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PORDOSNAL','Planilla Tributaria','PLASUE','no',15,8,'activo','13%sobre','2 SMN','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOPERIFIS','Planilla Tributaria','PLASUE','no',15,9,'activo','Saldo a favor','Fisco','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOPERIDEP','Planilla Tributaria','PLASUE','no',15,10,'activo','Sald Ant a fav','Dependiente','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOPERIANTDEP','Planilla Tributaria','PLASUE','no',15,11,'activo','Saldo Tot','mes Ant','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDOPERIANTACT','Planilla Tributaria','PLASUE','no',15,12,'activo','Saldo','Actualiz','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_APPAT','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,1,'activo','Solidario','Pat','otro',10,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','IMPURET','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,7,'activo','Imp.','RCIVA','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','PRESPER','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,52,'activo','Préstamo',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_SSO','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,9,'activo','Cuota','Indiv','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','ASIB','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,10,'activo','S.I.B.',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_RIEPRO','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,12,'activo','Riesgo','Prof.','otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_RCOM','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,20,'activo','Riesgo','Común','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','CAJSAL','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,23,'activo','CPS',NULL,'otro',2,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','HABBAS','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,25,'activo','Sueldo','Base','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','HOREXT','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,26,'activo','Hrs.','Extras','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','EXTRA','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,27,'activo','Sobretiempo',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELPRES','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,30,'activo','Ptm','CACSEL','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_CADM','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,31,'activo','Cuota','Adm.','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','APSIND','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,32,'activo','Ap.','Sindicato','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','DESCANTC','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,33,'activo','Anticipos',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','SUELDOMES','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,36,'activo','Sueldo','Mes','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','HORNOC','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,37,'activo','Hrs.','Nocturnas','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','NOCTURNO','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,38,'activo','Recargo','Noct.','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','OTRO_DESC','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,44,'activo','Desc.','Varios','otro',3,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRI','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,45,'activo','Prima',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','BONFRONTERA','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,47,'activo','Sub.','Frontera','otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO1','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,48,'activo','Reintegro','1','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_APNALSOL','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,53,'activo','Nac.','Solidario','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','TOT_DESC','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,55,'activo','Tot.','Desc.','otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','PREAGUI','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,56,'activo','P.','Aguinaldo','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','DISPONIBILIDAD','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,58,'activo','Disponibilidad',NULL,'otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO2','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,59,'activo','Reintegro','2','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_APSOL','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,64,'activo','Solidario','Aseg.','otro',4,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','LICENCIA','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,65,'activo','Licencias',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','AFP_VIVIE','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,67,'activo','PROVI','Pat','otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','BONANT','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,69,'activo','B.','Antiguedad','otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','ASIGNACIONES','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,71,'activo','Asignaciones',NULL,'otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','MUL_ATRA','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,74,'activo','Multas',NULL,'otro',2,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','COTIZABLE_ANT','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,78,'activo','Cotiz.','Ant.','otro',3,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','HORNORM','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,81,'activo','Hrs.','Normales','otro',2,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELFIJO','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,19,'activo','Cuot.','CACSEL','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','RETJUD','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,51,'activo','Ret','Judicial','otro',2,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','INCAP_TEMPORAL','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,16,'activo','Incap','Temp','otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','SUBNAT','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,40,'activo','Natalidad',NULL,'otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','COTIZABLE','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,82,'activo','Cotizable',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','PREAGUI','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,34,'activo','Reserva','BS','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','LIQPAG','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,88,'activo','Lq.','Pagable','otro',4,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELVAR','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,8,'activo','Fond.','CACSEL','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,89,'activo','Total','General','otro',0,'total_gral','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,28,'activo','Natalidad','/Sepelio','otro',0,'subsep','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,6,'activo','Prenatal',' ','otro',2,'subpre','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,29,'activo','Prenatal',' ','otro',0,'subpre','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,17,'activo','Lactancia',' ','otro',0,'sublac','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,18,'activo','Prdt.','Lact.','otro',0,'sublac','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','no',0,4,'activo','Nombre','Empleado','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','no',0,35,'activo','Nivel',' - CS','otro',0,'nivel','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','no',0,24,'activo','Fech.','Nac.','otro',0,'fecha_nacimiento','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','no',0,2,'activo','Fech.','Ingreso','otro',0,'fecha_ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','no',0,13,'activo','Cd','Empleado','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','Planilla de Sueldos Multilinea por Distrito','PLASUE','no',0,15,'activo','Cargo',' ','otro',0,'cargo','vista_externa');
select plani.f_import_treporte_columna('insert','','20: APORTE PORCENTUAL SINDICATO','PLASUE','no',18,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','20: APORTE PORCENTUAL SINDICATO','PLASUE','no',80,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','20: APORTE PORCENTUAL SINDICATO','PLASUE','no',20,3,'activo','C.I.',' ','otro',0,'num_documento','vista_externa');
select plani.f_import_treporte_columna('insert','','20: APORTE PORCENTUAL SINDICATO','PLASUE','no',62,4,'activo','Distrito',' ','otro',0,'distrito','vista_externa');
select plani.f_import_treporte_columna('insert','APSIND','20: APORTE PORCENTUAL SINDICATO','PLASUE','si',20,5,'activo','Aporte','(Bs.)','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELPRES','14: DESCUENTOS ACUMULADOS PTM CACSEL','PLASUE','si',50,3,'activo','Monto','(Bs.)','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','TOTGAN','Planilla de Sueldos Multilinea','PLASUE','si',0,83,'activo','Tot.','Ganado','otro',0,'total_ganado','columna_planilla');
select plani.f_import_treporte_columna('insert','TOTGAN','Planilla de Sueldos Multilinea por Distrito','PLASUE','si',0,83,'activo','Tot.','Ganado','otro',0,'total_ganado','columna_planilla');
select plani.f_import_treporte_columna('insert','','11: LISTADO POR DISTRITOS','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','CACSELFIJO','14: DESCUENTOS ACUMULADOS CACSEL','PLASUE','si',50,3,'activo','Aporte','(B.s)','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','14: APORTE PORCENTUAL CACSEL','PLASUE','no',40,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','14: APORTE PORCENTUAL CACSEL','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','22: LISTA ALFABETICA EMP CI','PLASUE','no',30,2,'activo','C.I.',' ','otro',0,'num_documento','vista_externa');
select plani.f_import_treporte_columna('insert','','11: LISTADO POR DISTRITOS','PLASUE','no',25,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','14: DESCUENTOS ACUMULADOS CACSEL','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','22: LISTA ALFABETICA EMP CI','PLASUE','no',85,3,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','22: LISTA ALFABETICA EMP CI','PLASUE','no',60,4,'activo','Firma',' ','otro',0,'firma','vista_externa');
select plani.f_import_treporte_columna('insert','','22: LISTA ALFABETICA EMP CI','PLASUE','no',25,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','11: LISTADO POR DISTRITOS','PLASUE','no',60,4,'activo',' ',' ','otro',0,'firma','vista_externa');
select plani.f_import_treporte_columna('insert','','11: LISTADO POR DISTRITOS','PLASUE','no',25,3,'activo','C.I.',' ','otro',0,'num_documento','vista_externa');
select plani.f_import_treporte_columna('insert','CACSELVAR','14: APORTE PORCENTUAL CACSEL','PLASUE','si',50,3,'activo','Aporte','(Bs.)','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','14: DESCUENTOS ACUMULADOS CACSEL','PLASUE','no',40,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','14: DESCUENTOS ACUMULADOS PTM CACSEL','PLASUE','no',40,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','14: DESCUENTOS ACUMULADOS PTM CACSEL','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','15: DESCUENTOS ACUMULADOS SIB','PLASUE','no',40,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','15: DESCUENTOS ACUMULADOS SIB','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','ASIB','15: DESCUENTOS ACUMULADOS SIB','PLASUE','si',50,3,'activo','Monto','(Bs.)','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','17: DECLARACIONES FORMULARIO 101','PLASUE','no',30,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','17: DECLARACIONES FORMULARIO 101','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','IMPOFAC13','17: DECLARACIONES FORMULARIO 101','PLASUE','si',40,3,'activo','Form','101','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SALDODEPSIGPER','17: DECLARACIONES FORMULARIO 101','PLASUE','si',40,4,'activo','Saldo','Mes Sig.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','18: DESCUENTOS ACUMULADOS APORTE VOLUNTARIADO','PLASUE','no',40,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','18: DESCUENTOS ACUMULADOS APORTE VOLUNTARIADO','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','APORVOLUN','18: DESCUENTOS ACUMULADOS APORTE VOLUNTARIADO','PLASUE','si',50,3,'activo','Monto','(Bs.)','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','DIASDISP','19: PERSONAL DISPONIBLE','PLASUE','si',50,3,'activo','Dias','Disponibilidad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','19: PERSONAL DISPONIBLE','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','21: DESCUENTOS ACUMULADOS VARIOS 1','PLASUE','no',40,1,'activo','Cod.','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','19: PERSONAL DISPONIBLE','PLASUE','no',40,1,'activo','Codigo','Empl.','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','21: DESCUENTOS ACUMULADOS VARIOS 1','PLASUE','no',90,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','DESVAR','21: DESCUENTOS ACUMULADOS VARIOS 1','PLASUE','si',50,3,'activo','Monto','(Bs.)','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','DESCUENTOS ACUMULADOS','PLASUE','no',30,1,'activo','Cod.','Empl','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','DESCUENTOS ACUMULADOS','PLASUE','no',80,2,'activo','Nombre','Empleado','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','SALDODEPMOSTRAR','BOLETA DE PAGO','PLASUE','si',0,37,'activo','Saldo','CredFiscal','otro',0,'','columna_planilla');

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

----------------------------------------------------
-- planila de retroactivo
----------------------------------------------------
----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAREISU','Planilla de Retroactivo','PLANRINT','plani.f_plareisu_insert_empleados','retroactivo_sueldo','plani.f_plareisu_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_APNALSOL','PLAREISU','Afp Aporte Nacional Solidario','formula','Aporte Nacional Solidario por Rangos','case when {AFP_VAR1}+{AFP_VAR2}+{AFP_VAR3} > 0 then
{AFP_VAR1}+{AFP_VAR2}+{AFP_VAR3}
else
0.00
end','no',NULL,'2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_APPAT','PLAREISU','Afp Aporte Patronal Solidario','formula','Afp aporte patronal solidario del 3%','{COTIZABLE}*0.03','si',NULL,'2','11','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_APSOL','PLAREISU','Afp Aporte Solidario','formula','Aporte solidario del asegurado 0.5%','{COTIZABLE}*0.005','no',NULL,'2','12','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_CADM','PLAREISU','Afp Costos Administrativos 0.5%','formula','Descuento al empleado de 0.5%','{COTIZABLE}*0.005','no',NULL,'2','8','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_LAB','PLAREISU','Suma de aportes laborales para AFP','formula','Suma laborales AFP','{AFP_SSO}+{AFP_RCOM}+{AFP_CADM}+{AFP_APSOL}+{AFP_APNALSOL}','si_pago',NULL,'2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_PAT','PLAREISU','Suma de aportes patronales para AFP','formula','Suma patronales AFP','{AFP_RIEPRO}+{AFP_VIVIE}+{AFP_APPAT}','no',NULL,'2','19','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_RCOM','PLAREISU','Afp Riesgo Común','formula','Afp riesgo comun descontado al empleado 1.71%','{COTIZABLE}*0.0171*{JUB65}','no',NULL,'2','10','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_RIEPRO','PLAREISU','Afp Riesgo Profesional','formula','Riesgo profesional que paga el empleador 1.71%','{COTIZABLE}*0.0171*{JUB65}','si',NULL,'2','9','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_SSO','PLAREISU','Afp seguro obligatorio 10%','formula','descuento del 10% al empleado por afp','{COTIZABLE}*0.1*{JUB65}*{JUB55}','no',NULL,'2','7','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VAR1','PLAREISU','AFP variable 1 para aporte nacional solidario','formula','Aporte para sueldos arriba de 13000','CASE WHEN {COTIZABLE_MES} > 13000 THEN
{COTIZABLE}*0.01
WHEN ({COTIZABLE_MES} <= 13000 AND ({COTIZABLE_MES} + {COTIZABLE}) > 13000) THEN
({COTIZABLE_MES} + {COTIZABLE} - 13000) * 0.01
ELSE 0 END','no',NULL,'2','14','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VAR2','PLAREISU','AFP variable 2 para aporte nacional solidario','formula','Aporte para sueldos arriba de 25000','CASE WHEN {COTIZABLE_MES} > 25000 THEN
{COTIZABLE}*0.05
WHEN ({COTIZABLE_MES} <= 25000 AND ({COTIZABLE_MES} + {COTIZABLE}) > 25000) THEN
({COTIZABLE_MES} + {COTIZABLE} - 25000) * 0.05
ELSE 0 END','no',NULL,'2','15','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VAR3','PLAREISU','AFP variable 3 para aporte nacional solidario','formula','Aporte para sueldos arriba de 35000','CASE WHEN {COTIZABLE_MES} > 35000 THEN
{COTIZABLE}*0.1
WHEN ({COTIZABLE_MES} <= 35000 AND ({COTIZABLE_MES} + {COTIZABLE}) > 35000) THEN
({COTIZABLE_MES} + {COTIZABLE} - 35000) * 0.1
ELSE 0 END','no',NULL,'2','16','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','AFP_VIVIE','PLAREISU','Afp Vivienda 2%','formula','Afp Vivienda 2%','{COTIZABLE}*0.02','si',NULL,'2','13','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BONFRONTERA','PLAREISU','Reintegro Bono de Frontera','basica','reintegro de bono  de frontera para los empleados que correspondan',NULL,'si',NULL,'2','2','restar_ejecutado','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CAJSAL','PLAREISU','Caja de Salud','formula','Aporte Patronal por Caja de Salud','{COTIZABLE}*0.1','si',NULL,'2','20','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','COTIZABLE','PLAREISU','Cotizable','formula','Cotizable sobre el que se aplican afps e impuestos','{REISUELDOBA}+{BONFRONTERA}+{REINBANT}','no',NULL,'2','4','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','COTIZABLE_MES','PLAREISU','Cotizable Mensual','basica','Contiene el cotizable mensual antes del incremento',NULL,'no',NULL,'2','4','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESCCHEQ','PLAREISU','Descuento por Cheque','variable','Descuento por Cheque',NULL,'no',NULL,'2','37','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_ZONAFRAN','PLAREISU','Factor Zona Franca','basica','Factor que se calcula a partir del tiempo y sueldo que trabajo el empleado en zona franca',NULL,'no',NULL,'2','23','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','PLAREISU','Impuesto Determinado','formula','Impuesto Determinado','{IMPSUJIMP}*0.13*{FAC_ZONAFRAN}','no',NULL,'2','24','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','PLAREISU','100 % del Importe en Facturas','variable','100% del importe en facturas presentadas por el empleado',NULL,'no',NULL,'2','25','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC13','PLAREISU','13% del Importe de Facturas','formula','13% del Importe presentado en Facturas','{IMPOFAC}*0.13','no',NULL,'2','26','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPSUJIMP','PLAREISU','Importe Sujeto a Impuesto','formula','sujeto a impuesto resta entre el sueldo neto y el minimo no imponible','CASE WHEN {SUELNETO} > 0  THEN {SUELNETO} ELSE 0 END','no',NULL,'2','22','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPURET','PLAREISU','Impuesto Retenido','formula','Impuesto Retenido','CASE WHEN ({SALDOTOTALDEP}-{SALDOPERIFIS}>0) THEN 0 ELSE {SALDOPERIFIS}-{SALDOTOTALDEP} END','si_pago',NULL,'0','34','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','JUB55','PLAREISU','Es jubilado de 55','basica','0 si es jubilado de 55 y 1 si no es jubilado de 55',NULL,'no',NULL,'0','6','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','JUB65','PLAREISU','Es jubilado de 65','basica','0 si es jubilado de 65 y 1 si no es',NULL,'no',NULL,'0','5','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PLAREISU','Liquido Pagable','formula','Liquido Pagable','{COTIZABLE}-{TOT_DESC}','si_pago',NULL,'2','39','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REINBANT','PLAREISU','Reintegro Bono de Antiguedad','basica','Reintegro Bono de Antiguedad',NULL,'si',NULL,'2','3','restar_ejecutado','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','REISUELDOBA','PLAREISU','Reintegro Sueldo','basica','Monto de Reintegro calculado a partir de los pagos realizados durante los meses anteriores al reintegro',NULL,'si',NULL,'2','1','ejecutar','si','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDODEPSIGPER','PLAREISU','Saldo Periodo Siguiente','formula','Saldo Periodo Siguiente a favor del dependiente','CASE WHEN ({SALDOPERIFIS}-{SALDOTOTALDEP}>0) THEN 0 ELSE {SALDOTOTALDEP}-{SALDOPERIFIS} END','no',NULL,'0','36','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOPERIANTDEP','PLAREISU','Saldo del Periodo Anterior','basica','Saldo del Periodo Anterior del dependiente',NULL,'no',NULL,'2','29','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOPERIDEP','PLAREISU','Saldo del Periodo a favor del Dependiente','formula','Saldo del Periodo a favor del Dependiente','CASE WHEN({IMPOFAC13}-{IMPDET} <0) THEN 0 ELSE ({IMPOFAC13}-{IMPDET}) END','no',NULL,'2','27','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOPERIFIS','PLAREISU','Saldo a Favor del Fisco del Periodo','formula','Saldo a Favor del Fisco del Periodo','CASE WHEN ({IMPOFAC13}-{IMPDET}>=0) THEN 0 ELSE {IMPDET}-{IMPOFAC13} END','no',NULL,'2','28','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDOTOTALDEP','PLAREISU','Saldo Total del Dependiente','formula','Saldo Total del Dependiente','{SALDOPERIDEP}+{SALDOPERIANTDEP}','no',NULL,'2','33','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SALDO_UTI','PLAREISU','Saldo Utilizado','formula','Saldo Utilizado','CASE WHEN {SALDOPERIFIS}>0 and {SALDOPERIANTDEP}>={SALDOPERIFIS} THEN
{SALDOPERIFIS}
WHEN {SALDOPERIFIS}>0 and {SALDOPERIANTDEP} <{SALDOPERIFIS} THEN
{SALDOPERIANTDEP}
ELSE
0
END','no',NULL,'2','35','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SUELNETO','PLAREISU','Sueldo Neto','formula','Total Ganado menos AFP','{COTIZABLE}-{AFP_LAB}','no',NULL,'2','21','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOT_DESC','PLAREISU','Total Descuentos','formula','Total Descuentos','{IMPURET}+{AFP_LAB}+{DESCCHEQ}','no',NULL,'2','38','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','RETAFPLAB','PLAREISU','Pago AFP Laboral','pago_afp','no','si',NULL,NULL,'CUEAFP','CUEAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RETAFPPAT','PLAREISU','Pago AFP Patronal','pago_afp','no','si',NULL,NULL,'CUEAFP','CUEAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RETCAJSAL','PLAREISU','Pago Caja de Salud','pago_comun','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','RETIMPU','PLAREISU','Pago de Impuestos','pago_comun','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','RETLIQ','PLAREISU','Pago de Retroactivo Líquido','pago_empleados','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_LAB','RETAFPLAB','PLAREISU','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REINBANT','RETAFPLAB','PLAREISU','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REISUELDOBA','RETAFPLAB','PLAREISU','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_APPAT','RETAFPPAT','PLAREISU','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_RIEPRO','RETAFPPAT','PLAREISU','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AFP_VIVIE','RETAFPPAT','PLAREISU','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','CAJSAL','RETCAJSAL','PLAREISU','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','IMPURET','RETIMPU','PLAREISU','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REINBANT','RETIMPU','PLAREISU','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REISUELDOBA','RETIMPU','PLAREISU','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONFRONTERA','RETLIQ','PLAREISU','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','RETLIQ','PLAREISU','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REINBANT','RETLIQ','PLAREISU','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','REISUELDOBA','RETLIQ','PLAREISU','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','Planilla Impositiva de Retroactivos','PLAREISU','no','oficio_horizontal','si','no','si','si','gerencia','nombre','activo',200,300,'Planilla Impositiva de Retroactivos',NULL,'planilla',NULL,NULL,NULL,NULL,NULL,'BS',NULL,NULL);
select plani.f_import_treporte('insert','Planilla de Retroactivos','PLAREISU','no','carta_horizontal','si','no','si','si','gerencia','nombre','activo',175,249,'Planilla de Retroactivos',NULL,'planilla',NULL,NULL,NULL,NULL,NULL,'BS',NULL,NULL);
select plani.f_import_treporte_columna('insert','REINBANT','Planilla de Retroactivos','PLAREISU','si',20,3,'activo','Bono','Antiguedad','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','REISUELDOBA','Planilla de Retroactivos','PLAREISU','si',20,2,'activo','Reintegro','del Básico','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','BONFRONTERA','Planilla de Retroactivos','PLAREISU','si',20,4,'activo','Bono','Frontera','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','COTIZABLE','Planilla de Retroactivos','PLAREISU','si',20,5,'activo','Total','Ingresos','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','IMPURET','Planilla de Retroactivos','PLAREISU','si',20,6,'activo','RC-IVA',NULL,'otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','AFP_LAB','Planilla de Retroactivos','PLAREISU','si',20,7,'activo','AFP',NULL,'otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','LIQPAG','Planilla de Retroactivos','PLAREISU','si',20,10,'activo','Liquido','Pagable','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','COTIZABLE','Planilla Impositiva de Retroactivos','PLAREISU','si',15,1,'activo','Total','Ganado','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SALDOPERIDEP','Planilla Impositiva de Retroactivos','PLAREISU','si',15,8,'activo','Saldo','Dependiente','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SUELNETO','Planilla Impositiva de Retroactivos','PLAREISU','si',15,2,'activo','Sueldo','Neto','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','IMPSUJIMP','Planilla Impositiva de Retroactivos','PLAREISU','si',15,4,'activo','Sujeto a','Impuesto','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','IMPOFAC13','Planilla Impositiva de Retroactivos','PLAREISU','si',15,5,'activo','Form','87','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SALDOPERIFIS','Planilla Impositiva de Retroactivos','PLAREISU','si',15,7,'activo','Saldo','Fisco','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','IMPURET','Planilla Impositiva de Retroactivos','PLAREISU','si',15,11,'activo','Impuesto','Retenido','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SALDOPERIANTDEP','Planilla Impositiva de Retroactivos','PLAREISU','si',15,9,'activo','Saldo','Anterior','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SALDOTOTALDEP','Planilla Impositiva de Retroactivos','PLAREISU','si',15,10,'activo','Saldo','total','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SALDO_UTI','Planilla Impositiva de Retroactivos','PLAREISU','si',15,12,'activo','Saldo','Utilizado','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','SALDODEPSIGPER','Planilla Impositiva de Retroactivos','PLAREISU','si',15,13,'activo','Saldo Mes','Siguiente','otro',NULL,NULL,NULL);

----------------------------------------------------
-- planila de retroactivo Mensual
----------------------------------------------------
----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLANRE','Planilla de Reintegros Mensual','PLASUE','plani.f_planre_insert_empleados','hoja_calculo','plani.f_planre_valid_empleado_xx','si','mensual','plani.f_plasue_generar_horas_sigma',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_ZONAFRAN','PLANRE','Factor Zona Franca','basica','Factor que se calcula a partir del tiempo y sueldo que trabajo el empleado en zona franca','','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','JUB55','PLANRE','Es jubilado de 55','basica','0 si es jubilado de 55 y 1 si no es jubilado de 55','','no','','0','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','JUB65','PLANRE','Es jubilado de 65','basica','0 si es jubilado de 65 y 1 si no es','','no','','0','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_APNALSOL','PLANRE','Afp Aporte Nacional Solidario','formula','Aporte Nacional Solidario por Rangos','case when {PRMAFP_VAR1}+{PRMAFP_VAR2}+{PRMAFP_VAR3} > 0 then
{PRMAFP_VAR1}+{PRMAFP_VAR2}+{PRMAFP_VAR3}
else
0.00
end','si_pago','','2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_APPAT','PLANRE','Afp Aporte Nacional Solidario','formula','Afp aporte nacional solidario del 3%','{PRMCOTIZABLE}*0.03','si','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_APSOL','PLANRE','Afp aporte solidario','formula','Aporte solidario del asegurado 0.5%','{PRMCOTIZABLE}*0.005','si_pago','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_CADM','PLANRE','Afp costos administrativos 0.5%','formula','Descuento al empleado de 0.5%','{PRMCOTIZABLE}*0.005','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_LAB','PLANRE','Suma de Aportes Laborales para AFP','formula','Suma laborales AFP','{PRMAFP_SSO}+{PRMAFP_RCOM}+{PRMAFP_CADM}','si_pago','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_PAT','PLANRE','Suma de Aportes Patronales para AFP','formula','Suma aportes patronales AFP','{PRMAFP_RIEPRO}+{PRMAFP_VIVIE}+{PRMAFP_APPAT}','no','','2','19','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_RCOM','PLANRE','Afp riesgo comun','formula','Afp riesgo comun descontado al empleado 1.71%','{PRMCOTIZABLE}*0.0171*{JUB65}','no','','2','10','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_RIEPRO','PLANRE','Afp riesgo profesional','formula','Riesgo profesional que paga el empleador 1.71%','{PRMCOTIZABLE}*0.0171*{JUB65}','si','','2','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_SSO','PLANRE','Afp seguro obligatorio 10%','formula','Descuento del 10% al empleado por AFP','{PRMCOTIZABLE}*0.1*{JUB65}*{JUB55}','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_VAR1','PLANRE','Afp variable 1 para aporte nacional solidario','formula','Aporte para sueldo arriba de 13000','CASE WHEN {PRMCOTIZABLE_MES} > 13000 THEN
{PRMCOTIZABLE}*0.01
WHEN ({PRMCOTIZABLE_MES} <= 13000 AND ({PRMCOTIZABLE_MES} + {PRMCOTIZABLE}) > 13000) THEN
({PRMCOTIZABLE_MES} + {PRMCOTIZABLE} - 13000) * 0.01
ELSE 0 END','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_VAR2','PLANRE','Afp variable 2 para aporte nacional solidario','formula','Aporte para sueldos arriba de 25000','CASE WHEN {PRMCOTIZABLE_MES} > 25000 THEN
{PRMCOTIZABLE}*0.05
WHEN ({PRMCOTIZABLE_MES} <= 25000 AND ({PRMCOTIZABLE_MES} + {PRMCOTIZABLE}) > 25000) THEN
({PRMCOTIZABLE_MES} + {PRMCOTIZABLE} - 25000) * 0.05
ELSE 0 END','no','','2','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_VAR3','PLANRE','Afp variable 3 para aporte nacional solidario','formula','Aporte para sueldos arriba de 35000','CASE WHEN {PRMCOTIZABLE_MES} > 35000 THEN
{PRMCOTIZABLE}*0.1
WHEN ({PRMCOTIZABLE_MES} <= 35000 AND ({PRMCOTIZABLE_MES} + {PRMCOTIZABLE}) > 35000) THEN
({PRMCOTIZABLE_MES} + {PRMCOTIZABLE} - 35000) * 0.1
ELSE 0 END','no','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMAFP_VIVIE','PLANRE','Afp Vivienda 2%','formula','Afp Vivienda 2%','{PRMCOTIZABLE}*0.02','si','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMASIGTRA','PLANRE','Reintegro Asignación de Trabajo','basica','Reintegro Asignación de Trabajo','','si','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMBANT','PLANRE','Reintegro Bono de Antiguedad','basica','Reintegro Bono de Antiguedad','','no','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMBONFRONTERA','PLANRE','reintegro de bono  de frontera para los empleados que correspondan','basica','reintegro de bono  de frontera para los empleados que correspondan','','si','','2','1','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMBONOANTG','PLANRE','Retroactivo Bono de Antigüedad','basica','Calculo de Retroactivo Bono de Antigüedad para planilla mensual','','si','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMCAJSAL','PLANRE','Caja de Salud','formula','Aporte Patronal por Caja de Salud','{PRMCOTIZABLE}*0.1','si','','2','20','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMCOSTO_TOTAL','PLANRE','Costo Total del Reintegro','formula','Suma de columnas de costo para el reporte','{PRMSUELDOBA}+{PRMBONOANTG}+{PRMEXTRA}+{PRMDISPONIBILIDAD}+{PRMNOCTURNO}+{PRMBONFRONTERA}+{PRMASIGTRA}+{PRMAFP_VIVIE}+{PRMAFP_APPAT}+{PRMAFP_RIEPRO}+{PRMCAJSAL}+{PRMPREPRI}+{PRMPREAGUI}+{PRMPREVBS}','si_pago','','2','27','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMCOTIZABLE','PLANRE','Cotizable','formula','Cotizable sobre el que se aplican AFPs e impuestos','{PRMSUELDOBA}+{PRMBONFRONTERA}+{PRMBANT} + {PRMEXTRA} + {PRMNOCTURNO} + {PRMDISPONIBILIDAD}+{PRMASIGTRA}','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMCOTIZABLE_MES','PLANRE','Cotizable Mensual','basica','Contiene el cotizable mensual antes del incremento','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMDISPONIBILIDAD','PLANRE','Reintegro de Disponibilidad','basica','Reintegro de Disponibilidad','','si','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMEXTRA','PLANRE','Reintegro horas extra','basica','Reintegro horas extra','','si','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMIMPRCIVA','PLANRE','Importe RC-IVA','formula','Importe RC-IVA','{PRMSUELNETO}*0.13','no','','2','26','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMLACPRE','PLANRE','Retroactivo de Prenatal y Lactancia','basica','Retroactivo de Prenatal y Lactancia','','si_pago','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMLACPRE_CF','PLANRE','Crédito Fiscal por Lactancia/Prenatal','formula','Crédito Fiscal por Lactancia/Prenatal','(CASE WHEN {FAC_ZONAFRAN}=1 THEN
{PRMLACPRE}*0.13
ELSE
0
END)','si_contable','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMLACPRE_GAS','PLANRE','Gasto por Reintegro Lac/Pre','formula','Gasto por Reintegro de subsidio de Lactancia / Prenatal','{PRMLACPRE}-{PRMLACPRE_CF}','si','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMLIQPAG','PLANRE','Liquido Pagable','formula','Liquido Pagable','{PRMCOTIZABLE}-{PRMTOT_DESC}','si_pago','','2','25','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMLIQPAGSUB','PLANRE','Liquido Nat/Sep','formula','Liquido Pagable','{PRMNATSEP}','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMNATSEP','PLANRE','Retroactivo de Natalidad y Sepelio','basica','Retroactivo de Natalidad y Sepelio','','si','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMNOCTURNO','PLANRE','Reintegro de horas nocturnas','basica','Reintegro de horas nocturnas planilla mensual','','si','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMPREAGUI','PLANRE','Previsión de aguinaldos','formula','Previsión de aguinaldos','{PRMCOTIZABLE}*0.0833','si','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMPREPRI','PLANRE','Previsión de prima','formula','Previsión de prima','{PRMCOTIZABLE}*0.0833','si','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMPREVBS','PLANRE','Previsión benificios sociales','formula','Previsión benificios sociales','{PRMCOTIZABLE}*0.0833','si','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMSUELDOBA','PLANRE','Reintegro Sueldo','basica','Monto de Reintegro calculado a partir de los pagos realizados durante los meses anteriores al reintegro','','si','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMSUELNETO','PLANRE','Sueldo Neto','formula','Total Ganado menos AFP','{PRMCOTIZABLE}-{PRMAFP_LAB}','no','','2','21','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMTOT_DESC','PLANRE','Total Descuentos','formula','Total Descuentos','{PRMAFP_LAB}+{PRMAFP_APSOL}+{PRMAFP_APNALSOL}','no','','2','24','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRMTOTSUB','PLANRE','Total Subsidios','formula','Total Subsidios','{PRMLACPRE}+{PRMNATSEP}','no','','2','3','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','REINATSEP','PLANRE','Reintegro Liquido Pagable Natalidad/Sepelio','una_obligacion_x_empleado','no','si',NULL,'Reintegro Liquido Pagable Natalidad/Sepeli','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','REIPREV_AGUI','PLANRE','Previsión para aguinaldos','pago_comun','no','no',NULL,'Previsión para aguinaldos','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','REIPREV_BS','PLANRE','Previsión para beneficios sociales','pago_comun','no','no',NULL,'Previsión para beneficios sociales','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','REIPREV_PRI','PLANRE','Previsión para prima','pago_comun','no','no',NULL,'Previsión para prima','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','RET_AFP_APNALSOL','PLANRE','Pago AFP Aportes Nacional Solidario','pago_afp','no','si','AFP','Retroactivo Pago AFP Aportes Nacional Solidario','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RET_AFP_APPAT','PLANRE','Pago AFP Aportes Patronales','pago_afp','no','si','AFP','Retroactivo Pago AFP Aportes Patronales','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RET_AFP_APSOL','PLANRE','Pago AFP Aportes Nacional Solidario','pago_afp','no','si','AFP','Retroactivo Pago AFP Aportes Nacional Solidario','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RET_AFP_LAB','PLANRE','Pago AFP Aportes Laborales (Comunes)','pago_afp','no','si','AFP','Retroactivo Pago AFP Aportes Laborales (Comunes)','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RET_AFP_RIEPRO','PLANRE','Pago AFP Riesgo Profesional','pago_afp','no','si','AFP','Retroactivo Pago AFP Riesgo Profesional','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RET_AFP_VIVIE','PLANRE','Pago AFP Vivienda','pago_afp','no','si','AFP','Retroactivo Pago AFP Vivienda','CUEOLBIAFP','CUEOLBIAFP','activo');
select plani.f_import_ttipo_obligacion('insert','RETCAJSAL','PLANRE','Retroactivo Pago Caja de Salud','pago_comun','si','si',NULL,'Retroactivo Pago Caja de Salud','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','RETLIQ','PLANRE','Pago de Retroactivo Liquido','pago_empleados','no','si',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','RET_SUBSI','PLANRE','Pagos Lacteosbol','pago_comun','no','si',NULL,'Pagos Lacteosbol','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMNATSEP','REINATSEP','PLANRE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMPREAGUI','REIPREV_AGUI','PLANRE','si','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMPREVBS','REIPREV_BS','PLANRE','si','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMPREPRI','REIPREV_PRI','PLANRE','si','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMAFP_APNALSOL','RET_AFP_APNALSOL','PLANRE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMSUELDOBA','RET_AFP_APNALSOL','PLANRE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMAFP_APPAT','RET_AFP_APPAT','PLANRE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMAFP_APSOL','RET_AFP_APSOL','PLANRE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMSUELDOBA','RET_AFP_APSOL','PLANRE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMAFP_LAB','RET_AFP_LAB','PLANRE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMSUELDOBA','RET_AFP_LAB','PLANRE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMAFP_RIEPRO','RET_AFP_RIEPRO','PLANRE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMAFP_VIVIE','RET_AFP_VIVIE','PLANRE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMCAJSAL','RETCAJSAL','PLANRE','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMASIGTRA','RETLIQ','PLANRE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMBONFRONTERA','RETLIQ','PLANRE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMBONOANTG','RETLIQ','PLANRE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMDISPONIBILIDAD','RETLIQ','PLANRE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMEXTRA','RETLIQ','PLANRE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMLIQPAG','RETLIQ','PLANRE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMSUELDOBA','RETLIQ','PLANRE','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMLACPRE','RET_SUBSI','PLANRE','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMLACPRE_CF','RET_SUBSI','PLANRE','no','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRMLACPRE_GAS','RET_SUBSI','PLANRE','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','APORTES AL FONDO SOLIDARIO POR PAGO RETROACTIVO DE SUELDOS','PLANRE','no','oficio_horizontal','no','no','no','no','ninguno','nombre','activo',0,300,'APORTES AL FONDO SOLIDARIO POR PAGO RETROACTIVO DE SUELDOS','fondo_solidario','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si','carta_horizontal','no','no','no','no','distrito','nombre','activo',276,249,'APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','aporte_afp','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','LISTADO GENERAL BANCO: REPORTE DE BANCOS POR REINTEGRO','PLANRE','no','carta_vertical','no','no','no','no','distrito_banco','nombre','activo',0,186,'LISTADO GENERAL BANCO: REPORTE DE BANCOS POR REINTEGRO','relacion_saldos_det_ci','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','no','oficio_horizontal','no','no','no','no','distrito','nombre','activo',336,300,'PLANILLA DE REINTEGRO DE SUELDOS','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','REPORTE POR BANCOS POR REINTEGRO','PLANRE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'REPORTE POR BANCOS POR REINTEGRO','relacion_saldos_det','formato_especifico','no','',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','no','carta_horizontal','no','no','no','no','distrito','nombre','activo',264,249,'RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','BOLETA DE PAGO DE REINTEGRO','PLANRE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'BOLETA DE PAGO DE REINTEGRO','','boleta','si','plani.vdatos_func_planilla',8,'no','no','BS',NULL,5.00);
select plani.f_import_treporte_columna('insert','','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','no',12,1,'activo','Cod.','Emp','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','no',50,2,'activo','Nombre','','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','no',20,3,'activo','CI-RUN EXP','','otro',0,'num_documento','vista_externa');
select plani.f_import_treporte_columna('insert','','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','no',12,4,'activo','NUA','','otro',0,'codigo_rciva','vista_externa');
select plani.f_import_treporte_columna('insert','PRMSUELDOBA','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',17,5,'activo','Reintegro','Suel. Basico','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMBANT','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',17,7,'activo','Reintegro','Antiguedad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMEXTRA','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',17,8,'activo','Reintegro','Sobretiempo','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMNOCTURNO','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',17,9,'activo','Reintegro','R. Nocturno','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMDISPONIBILIDAD','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',17,10,'activo','Reintegro','Disponib.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMBONFRONTERA','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',17,11,'activo','Reintegro','Frontera','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMASIGTRA','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',15,12,'activo','Reintegro','Asignacion','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMCOTIZABLE','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',15,13,'activo','Total','Reintegro','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_VIVIE','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',14,14,'activo','Fondo de','Vivienda','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APPAT','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',12,15,'activo','Fond','Pat3%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APSOL','APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',14,16,'activo','Solidario','Ase05%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO DE REINTEGRO','PLANRE','no',0,1,'activo','Nombre:','','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO DE REINTEGRO','PLANRE','no',0,2,'activo','Cargo:','','otro',2,'cargo','vista_externa');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO DE REINTEGRO','PLANRE','no',0,3,'activo','Codigo:','','otro',2,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO DE REINTEGRO','PLANRE','no',0,4,'activo','','','otro',1,'vacio','vista_externa');
select plani.f_import_treporte_columna('insert','','BOLETA DE PAGO DE REINTEGRO','PLANRE','no',0,5,'activo','','','otro',1,'vacio','vista_externa');
select plani.f_import_treporte_columna('insert','PRMAFP_SSO','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,8,'activo','Cuota','Indiv10%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMBONOANTG','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,10,'activo','B.','Antiguedad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMEXTRA','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,14,'activo','Sobretiempos','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','no',10,1,'activo','Cod','Emp','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','no',70,2,'activo','Nombre','','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','PRMCOTIZABLE','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,3,'activo','Total','Reintegro','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APPAT','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,4,'activo','Solidario','Patronal','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_RIEPRO','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,5,'activo','Riesgo','Prof.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_VIVIE','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,6,'activo','Fondo','Vivienda','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMCAJSAL','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,7,'activo','Caja','Petrolera','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMPREVBS','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,8,'activo','Res Benef','Sociales','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMPREPRI','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,9,'activo','Prima','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMPREAGUI','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,10,'activo','Aguinaldo','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMCOSTO_TOTAL','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,11,'activo','Costo','Total','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APSOL','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,12,'activo','Solidario','Asegurado','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_SSO','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,13,'activo','Cotizable','Mensual','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_RCOM','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,14,'activo','Riesgo','Comun','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_CADM','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,15,'activo','Comision','Admin','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APNALSOL','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,16,'activo','Nacional','Solidario','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMTOT_DESC','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,17,'activo','Total','Descuento','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMLIQPAG','PLANILLA DE REINTEGRO DE SUELDOS','PLANRE','si',16,18,'activo','Liquido','Pagable','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMLIQPAG','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,20,'activo','Liquido','Pagable','otro',8,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMTOT_DESC','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,19,'activo','Total','Descuentos','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMCOTIZABLE','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,18,'activo','Total','Reintegro','otro',6,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMSUELDOBA','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,6,'activo','Reint.','S. Basico','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMDISPONIBILIDAD','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,7,'activo',' ','Disponibilidad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APNALSOL','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,9,'activo','Solidario','Nacional','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMBONFRONTERA','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,11,'activo','Bono','Frontera','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_RCOM','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,12,'activo','Riesgo','Com. 1.71%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APSOL','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,13,'activo','Solidario','Aseg.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','no',12,1,'activo','Cod','Emp','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','no',70,2,'activo','Nombre','','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','PRMSUELDOBA','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',22,3,'activo','Reintegro','Sueldo Basico','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,4,'activo','Reintegro','Bonificacion','otro',0,'reintegro_bonificacion','vista_externa');
select plani.f_import_treporte_columna('insert','PRMBANT','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,5,'activo','Reintegro','Antiguedad','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMEXTRA','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,6,'activo','Reintegro','Sobretiempo','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMNOCTURNO','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,7,'activo','Reintegro','Rec.Noct.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMDISPONIBILIDAD','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,8,'activo','Reintegro','Disponib.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMBONFRONTERA','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,9,'activo','Reintegro','Frontera','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMASIGTRA','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,10,'activo','Reintegro','Asignacion','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMCOTIZABLE','RESUMEN DE REINTEGROS POR PAGO RETROACTIVO DE SALARIOS','PLANRE','si',20,11,'activo','Total','Reintegro','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_CADM','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,16,'activo','Cuota','Adm0.5%','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMNOCTURNO','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,17,'activo','Rec.','Nocturno','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMASIGTRA','BOLETA DE PAGO DE REINTEGRO','PLANRE','si',0,15,'activo','Asig. Sitio','de Trab.','otro',0,'','columna_planilla');


----------------------------------------------------
-- planila de  prevision de primas
----------------------------------------------------
----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAPREPRI','Planilla de Prevision de Prima','PLASUB','plani.f_plaprepri_insert_empleados','prorrateo_aguinaldo','plani.f_plaprepri_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS1','PLAPREPRI','Dias para calculo','basica','Dias para calculo',NULL,'no',NULL,'2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','PLAPREPRI','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT11','PLAPREPRI','Prevision Cotizable1','basica','Prevision de primer sueldo para promedio',NULL,'no',NULL,'2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT12','PLAPREPRI','Prevision Cotizable2','basica','Prevision de segundo sueldo para promedo',NULL,'no',NULL,'2','2','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT13','PLAPREPRI','Prevision cotizable3','basica','prevision de tercer sueldo para promedio',NULL,'no',NULL,'2','3','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','PLAPREPRI','Prevision Cotizable1','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','PLAPREPRI','Prevision Cotizable1 2do contrato','basica','PENULTIMO COTIZABLE DE SEGUNDO CONTRATO ','','no','','2','5','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','PLAPREPRI','antepenultimo Cotizable de segundo contrato','basica','antepenultimo Cotizable de segundo contrato','','no','','2','6','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRIMA','PLAPREPRI','Prima a pagar','formula','prima a pagar','((({PREPROME1}/360*{PREDIAS1})+({PREPROME2}/360*{PREDIAS2})) *({PORCENTAJEPRIM}/100))','no','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PLAPREPRI','Promedio','formula','Promedio de 3 ultimos sueldos','(({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3)+{TP1}','no','','2','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PLAPREPRI','Promedio del ultimo contrato','formula','promedio de 3 ultimos sueldos ultimo contrato','(({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3)+{TP2}','no','','2','10','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP1','PLAPREPRI','Ajuste por Reintegros','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del primer contrato','','no','','2','-4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','PLAPREPRI','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------



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


----------------------------------------------------
-- planila de  prima no vigentes
----------------------------------------------------
----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PRINOVIG','Planilla de Prima NO vigentes','PLASUB','plani.f_prinovig_insert_empleados','prorrateo_aguinaldo','plani.f_prinovig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERAPRI','PRINOVIG','Factor Frontera','basica','Factor Frontera','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_FRONTERAPRI','PRINOVIG','Zona Franca','basica','Zona Franca','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','PRINOVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> ({PRIMA}*0.13) then 0 else
({PRIMA}*0.13)-{IMPOFAC}*{FAC_FRONTERAPRI} end','si_pago','','2','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','PRINOVIG','Certificado RC-IVA','variable','Importe de Facturas al 100 porciento','','no','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PRINOVIG','Prima Liquida','formula','Prima Liquida','{PRIMA} - COALESCE({TOTDESC},0)','si_pago','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','PRINOVIG','Otros Descuentos','variable','Otros Descuentos','','si_pago','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS1','PRINOVIG','Dias para calculo','basica','Días para calculo','','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','PRINOVIG','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT11','PRINOVIG','Prevision Cotizable1','basica','Previsión de primer sueldo para promedio','','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT12','PRINOVIG','Prevision Cotizable2','basica','Previsión de segundo sueldo para promedio','','no','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT13','PRINOVIG','Prevision Cotizable3','basica','Previsión de tercer sueldo para promedio','','no','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','PRINOVIG','Prevision Cotizable 21','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','PRINOVIG','Prevision Cotizable 22','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','PRINOVIG','Prevision Cotizable 23','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PRINOVIG','Promedio C1','formula','Promedio de 3 ultimos sueldos','(({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3)+{TP1}','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PRINOVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','(({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3)+{TP2}','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRIMA','PRINOVIG','Prima a pagar','formula','Prima a pagar','((({PREPROME1}/360*{PREDIAS1})+({PREPROME2}/360*{PREDIAS2})) *({PORCENTAJEPRIM}/100))','si_contable','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','PRINOVIG','Total Descuentos','formula','Total Descuentos','{OTDESC} + {IMPDET}','no','','2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP1','PRINOVIG','Ajuste por Reintegros','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del primer contrato','','no','','2','-4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','PRINOVIG','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','DESCHEQ','PRINOVIG','Descuento por Cheque','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','IMPDET','PRINOVIG','Impuesto Retenido','pago_comun','no','si',NULL,'Pago de impeustos retenidos','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','PRINOVIG','Liquido Prima','una_obligacion_x_empleado','no','si',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','PRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','DESCHEQ','PRINOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','IMPDET','IMPDET','PRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','IMPDET','PRINOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','PRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','LIQPAG','PRINOVIG','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','PLANILLA DE PRIMA','PRINOVIG','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE PRIMA','planilla_prima','formato_especifico','no','',0,'no','no','BS',0,7.00);

----------------------------------------------------
-- planila de prima vigentes
----------------------------------------------------
----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAPRIVIG','Planilla de Prima Vigentes','PLASUB','plani.f_plaprivig_insert_empleados','prorrateo_aguinaldo','plani.f_plaprivig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERAPRI','PLAPRIVIG','Factor Frontera','basica','Factor Frontera','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_FRONTERAPRI','PLAPRIVIG','Zona Franca','basica','Si es zona_franca','','no','','2','14','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','PLAPRIVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> {PRIMA} then 0 else
({PRIMA}-{IMPOFAC})*13/100*{FAC_FRONTERAPRI} end','si_pago','','2','15','ejecutar','no','no','no','activo');
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
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PLAPRIVIG','Promedio C1','formula','Promedio de 3 ultimos sueldos','(({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3)+{TP1}','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PLAPRIVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','(({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3)+{TP2}','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRIMA','PLAPRIVIG','Prima a pagar','formula','Prima a pagar','((({PREPROME1}/360*{PREDIAS1})+({PREPROME2}/360*{PREDIAS2})) *({PORCENTAJEPRIM}/100))','si_contable','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','PLAPRIVIG','Total Descuentos','formula','Total Descuentos','{OTDESC}','no','','2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP1','PLAPRIVIG','Ajuste por Reintegros','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del primer contrato','','no','','2','-4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','PLAPRIVIG','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','DESCHEQ','PLAPRIVIG','Descuento por Cheque','pago_comun','no','no',NULL,'','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','PLAPRIVIG','Liquido Prima','pago_empleados','no','si',NULL,'','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','PLAPRIVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','DESCHEQ','PLAPRIVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','PLAPRIVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','LIQPAG','PLAPRIVIG','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','PLANILLA DE PRIMA','PLAPRIVIG','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE PRIMA','planilla_prima','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','PRIMA POR DISTRITO - BANCO : PLANILLA DE PRIMA','PLAPRIVIG','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'PRIMA POR DISTRITO - BANCO : PLANILLA DE PRIMA','relacion_saldos','formato_especifico','no','',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','BOLETA DE PAGO : PRIMA ANUAL','PLAPRIVIG','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',70,186,'BOLETA DE PAGO : PRIMA ANUAL','','boleta','no','plani.vdatos_func_planilla',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte_columna('insert','PRIMA','BOLETA DE PAGO : PRIMA ANUAL','PLAPRIVIG','no',70,1,'activo','TOTAL','PRIMA','otro',0,'','columna_planilla');


----------------------------------------------------
-- planila de prima boa
----------------------------------------------------


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAPRI','Planilla de Prima','PLASUB','plani.f_plapri_insert_empleados_etr','prorrateo_aguinaldo','plani.f_plapri_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','DIASAGUI','PLAPRI','Dias para Cálculo de Prima','basica','Dias para Cálculo de Prima',NULL,'no',NULL,'2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERAPRI','PLAPRI','Factor Frontera','basica','Factor Frontera',NULL,'no',NULL,'2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','PLAPRI','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> {PRIMA} then 0 else
({PRIMA}-{IMPOFAC})*13/100*{FACFRONTERAPRI} end','si_pago','','0','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','PLAPRI','Importe de Facturas al 100 porciento','variable','Importe de Facturas al 100 porciento',NULL,'no',NULL,'2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PLAPRI','Prima Liquida','formula','Prima Liquida','{PRIMA}-{TOTDESC}','si_pago',NULL,'2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','PLAPRI','Otros Descuentos','variable','Otros Descuentos',NULL,'si_pago',NULL,'2','10','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRICOTI1','PLAPRI','Cotizable 1','basica','El primer sueldo que se tomará como promedio','','no','','2','1','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRICOTI2','PLAPRI','Cotizable 2','basica','El segundo sueldo que se tomará como promedio','','no','','2','2','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRICOTI3','PLAPRI','Cotizable 3','basica','El tercer sueldo que se tomará como promedio','','no','','2','3','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRIMA','PLAPRI','Prima a pagar','formula','Prima a pagar','(({PROMEPRI}/360*{DIASAGUI})*{PORCENTAJEPRIM})/100','si_contable','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROMEPRI','PLAPRI','Promedio','formula','Promedio de los 3 últimos sueldos','({PRICOTI1}+{PRICOTI2}+{PRICOTI3})/3','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','PLAPRI','Total Descuentos','formula','Total Descuentos','{OTDESC}','no','','2','11','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','DESCHEQ','PLAPRI','Descuento por Cheque','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','PLAPRI','Liquido Prima','pago_empleados','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','PLAPRI','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','DESCHEQ','PLAPRI','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','PLAPRI','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','LIQPAG','PLAPRI','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','BOLETA DE PAGO : PRIMA ANUAL','PLAPRI','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',70,186,'BOLETA DE PAGO : PRIMA ANUAL','','boleta','no','plani.vdatos_func_planilla',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','PRIMA POR DISTRITO - BANCO : RESUMEN - RELACIÓN DE SALDOS','PLAPRI','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'PRIMA POR DISTRITO - BANCO : RESUMEN - RELACIÓN DE SALDOS','relacion_saldos','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','PLANILLA DE PRIMA','PLAPRI','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE PRIMA','','planilla','si','plani.vdatos_func_planilla',12,'no','no','BS',0,7.00);
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,1,'activo','Codigo',' ','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,2,'activo','Nombre',' ','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,3,'activo','Fecha',' ','otro',2,'fecha_ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','DIASAGUI','PLANILLA DE PRIMA','PLAPRI','si',0,4,'activo','Tiempo',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRICOTI2','PLANILLA DE PRIMA','PLAPRI','si',0,6,'activo','Cotizable',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PROMEPRI','PLANILLA DE PRIMA','PLAPRI','si',0,8,'activo','Cotizable',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRIMA','PLANILLA DE PRIMA','PLAPRI','si',0,10,'activo','Total',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,11,'activo','Cargo',' ','otro',1,'cargo','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,12,'activo','Ingreso',' ','otro',2,'ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,13,'activo','Trab.',' ','otro',0,'trab','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,14,'activo','Octubre',' ','otro',0,'oct','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,15,'activo','Noviembre',' ','otro',0,'nov','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,16,'activo','Diciembre',' ','otro',0,'dic','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,17,'activo','Promedio',' ','otro',0,'prom','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,18,'activo','Parcial',' ','otro',0,'Parcial','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE PRIMA','PLAPRI','no',0,19,'activo','Total (Bs)',' ','otro',0,'Total (Bs)','vista_externa');
select plani.f_import_treporte_columna('insert','PRIMA','BOLETA DE PAGO : PRIMA ANUAL','PLAPRI','no',70,1,'activo','TOTAL','PRIMA','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRICOTI3','PLANILLA DE PRIMA','PLAPRI','si',0,5,'activo','Cotizable',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRICOTI1','PLANILLA DE PRIMA','PLAPRI','si',0,7,'activo','Cotizable',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRIMA','PLANILLA DE PRIMA','PLAPRI','si',0,9,'activo','Monto',' ','otro',0,'','columna_planilla');
----------------------------------------------------
-- planila de aguinaldo
----------------------------------------------------

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAGUIN','Planilla de Aguinaldo','PLASUB','plani.f_plaguin_insert_empleados_etr','prorrateo_aguinaldo','plani.f_plaguin_valid_empleado','no','anual','plani.f_plasue_generar_horas_sigma',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','AGUINA','PLAGUIN','Aguinaldo a Pagar','formula','Aguinaldo a Pagar','{PROME}/360*{DIASAGUI}','si_contable','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESCCHEQ','PLAGUIN','Descuento por Cheque','variable','Descuento por Cheque',NULL,'si_pago',NULL,'2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DIASAGUI','PLAGUIN','Dias para Cálculo de Aguinaldo','basica','Dias para Cálculo de Aguinaldo',NULL,'no',NULL,'2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PLAGUIN','Liquido Pagable','formula','Liquido Pagable','{AGUINA}-{DESCCHEQ}','si_pago',NULL,'2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROMCOTI1','PLAGUIN','Cotizable 1','basica','El primer cotizable  que se tomará para promediar','','no','','2','1','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROMCOTI2','PLAGUIN','Cotizable 2','basica','El segundo cotizable  que se tomará para promediar','','no','','2','2','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROMCOTI3','PLAGUIN','Cotizable 3','basica','El tercer cotizable  que se tomará para promediar ','','no','','2','3','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROME','PLAGUIN','Promedio','formula','Promedio de los 3 últimos sueldos','({PROMCOTI1}+{PROMCOTI2}+{PROMCOTI3})/3','no','','2','4','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','AGUIN','PLAGUIN','Pago Liquido Aguinaldo','pago_empleados','no','si',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','OBLICHEQ','PLAGUIN','Descuentos por cheque','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AGUINA','AGUIN','PLAGUIN','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','AGUIN','PLAGUIN','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AGUINA','OBLICHEQ','PLAGUIN','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','DESCCHEQ','OBLICHEQ','PLAGUIN','si','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','BOLETA DE PAGO : AGUINALDO','PLAGUIN','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',70,186,'BOLETA DE PAGO : AGUINALDO','','boleta','no','plani.vdatos_func_planilla',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','DETALLE DE AGUINALDO','PLAGUIN','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'DETALLE DE AGUINALDO','detalle_aguinaldo','formato_especifico','no','',0,'no','no','BS',NULL,5.00);
select plani.f_import_treporte('insert','RESUMEN PLANILLA DE AGUINALDO','PLAGUIN','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'RESUMEN PLANILLA DE AGUINALDO','relacion_saldos','formato_especifico','no','',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','PLANILLA DE AGUINALDO','PLAGUIN','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE AGUINALDO','','planilla','si','plani.vdatos_func_planilla',12,'no','no','BS',NULL,7.00);
select plani.f_import_treporte_columna('insert','AGUINA','BOLETA DE PAGO : AGUINALDO','PLAGUIN','si',70,1,'activo','TOTAL','AGUINALDO','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,1,'activo','Codigo','','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,2,'activo','Nombre','','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,11,'activo','Cargo','','otro',1,'cargo','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,12,'activo','Ingreso','','otro',2,'ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,3,'activo','Fecha','','otro',2,'fecha_ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','PROMCOTI2','PLANILLA DE AGUINALDO','PLAGUIN','si',0,6,'activo','Cotizable','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,16,'activo','Noviembre','','otro',0,'nov','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,15,'activo','Octubre','','otro',0,'oct','vista_externa');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,14,'activo','Septiembre','','otro',0,'sept','vista_externa');
select plani.f_import_treporte_columna('insert','DIASAGUI','PLANILLA DE AGUINALDO','PLAGUIN','si',0,4,'activo','Tiempo','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,13,'activo','Trab.','','otro',0,'trab','vista_externa');
select plani.f_import_treporte_columna('insert','PROME','PLANILLA DE AGUINALDO','PLAGUIN','si',0,8,'activo','Cotizable','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,17,'activo','Promedio','','otro',0,'Promedio','vista_externa');
select plani.f_import_treporte_columna('insert','AGUINA','PLANILLA DE AGUINALDO','PLAGUIN','si',0,9,'activo','Monto','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','PLANILLA DE AGUINALDO','PLAGUIN','no',0,18,'activo','Parcial','','otro',0,'Parcial','vista_externa');
select plani.f_import_treporte_columna('insert','AGUINA','PLANILLA DE AGUINALDO','PLAGUIN','si',0,10,'activo','Aguinaldo','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','Total (Bs)','PLANILLA DE AGUINALDO','PLAGUIN','no',0,19,'activo','Total (Bs)','','otro',0,'Total (Bs)','vista_externa');
select plani.f_import_treporte_columna('insert','PROMCOTI1','PLANILLA DE AGUINALDO','PLAGUIN','si',0,7,'activo','Cotizable',' ','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PROMCOTI3','PLANILLA DE AGUINALDO','PLAGUIN','si',0,5,'activo','Cotizable',' ','otro',0,'','columna_planilla');


----------------------------------------------------
-- planila de ajuste de beneficios socilaes
----------------------------------------------------

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLAJTBFS','Planilla de Ajuste de Beneficios Sociales','PLASUE','plani.f_plasue_insert_empleados','hoja_calculo','plani.f_plasue_valid_empleado','si','mensual','plani.f_plasue_generar_horas_sigma',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','AJUBNFS','PLAJTBFS','Ajuste beneficio social','variable','Ajuste beneficio social','','si','','2','1','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','AJUSPRE_BS','PLAJTBFS','Ajuste Previsión beneficios sociales','pago_comun','no','no',NULL,'ajuste de previsión beneficios sociales','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AJUBNFS','AJUSPRE_BS','PLAJTBFS','si','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------



----------------------------------------------------
-- planila de reintegro de subsidios
----------------------------------------------------

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLARETSUB','Planilla de Retroactivo de Subsidios','PLASUB','plani.f_plaretsub_insert_empleados','ultimo_activo_gestion','plani.f_plaretsub_valid_empleado','no','anual',NULL,NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PLARETSUB','Liquido Pagable','formula','Liquido Pagable','{RETNATSEP}','no',NULL,'2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','RETLACPRE','PLARETSUB','Retroactivo de Prenatal y Lactancia','basica','Retroactivo de Prenatal y Lactancia',NULL,'si',NULL,'2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','RETNATSEP','PLARETSUB','Retroactivo de Natalidad y Sepelio','basica','Retroactivo de Natalidad y Sepelio',NULL,'si',NULL,'2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTSUB','PLARETSUB','Total Subsidios','formula','Total Subsidios','{RETLACPRE}+{RETNATSEP}','no',NULL,'2','3','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','LIQPAG','PLARETSUB','Liquido Pagable','pago_empleados','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','PAGSUB','PLARETSUB','Pago de Subsidios','pago_comun','si','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','RETNATSEP','LIQPAG','PLARETSUB','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','RETLACPRE','PAGSUB','PLARETSUB','si','si','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','Planilla de Retroactivo de Subsidios','PLARETSUB','no','carta_vertical','si','no','si','si','gerencia','nombre','activo',135,186,'Planilla de Retroactivo de Subsidios',NULL,'planilla',NULL,NULL,NULL,NULL,NULL,'BS',NULL,NULL);
select plani.f_import_treporte_columna('insert','RETLACPRE','Planilla de Retroactivo de Subsidios','PLARETSUB','si',25,1,'activo','Prenatal y','Lactancia','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','RETNATSEP','Planilla de Retroactivo de Subsidios','PLARETSUB','si',25,2,'activo','Natalidad y','Sepelio','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','TOTSUB','Planilla de Retroactivo de Subsidios','PLARETSUB','si',25,3,'activo','Total','Subsidios','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','LIQPAG','Planilla de Retroactivo de Subsidios','PLARETSUB','si',25,4,'activo','Liquido','Pagable','otro',NULL,NULL,NULL);

----------------------------------------------------
-- planila de ajuste de bonis de produccion
----------------------------------------------------


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PREBOPRO','Planilla de Prevision de Bono de Producción','PLASUB','plani.f_prebopro_insert_empleados','prorrateo_aguinaldo','plani.f_prebopro_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','APCAJ','PREBOPRO','Aporte Caja','formula','Aporte Caja','{PREBONO}*0.1','no','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CTOTAL','PREBOPRO','Costo Total','formula','Costo Total','{PREBONO}+{APCAJ}','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PORCBONO','PREBOPRO','Pocentaje de Bono','variable','Porcentaje del bono de producción por funcionario','','no','','2','11','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREBONO','PREBOPRO','Bono a pagar','formula','Bono a pagar','(({PREPROME2}/360*{PREDIAS2}) *({PORCBONO}/100))','no','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','PREBOPRO','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','PREBOPRO','Prevision Cotizable1','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','PREBOPRO','Prevision Cotizable1 2do contrato','basica','PENULTIMO COTIZABLE DE SEGUNDO CONTRATO ','','no','','2','5','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','PREBOPRO','antepenultimo Cotizable de segundo contrato','basica','antepenultimo Cotizable de segundo contrato','','no','','2','6','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PREBOPRO','Promedio del ultimo contrato','formula','promedio de 3 ultimos sueldos ultimo contrato','({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3','no',NULL,'2','10','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------



----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','Planilla Previsoria de Bono','PREBOPRO','no','carta_horizontal','no','no','no','no','ninguno','nombre','activo',238,249,'Planilla Previsoria de Bono','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',0,7.00);
select plani.f_import_treporte_columna('insert','PREDIAS2','Planilla Previsoria de Bono','PREBOPRO','si',10,9,'activo','Dias','Ctto2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT22','Planilla Previsoria de Bono','PREBOPRO','si',20,7,'activo','Ctto2','Cot2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPROME2','Planilla Previsoria de Bono','PREBOPRO','si',20,11,'activo','Prom','Cot2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla Previsoria de Bono','PREBOPRO','no',68,1,'activo','Nombre','Emp.','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','PREPRICOT23','Planilla Previsoria de Bono','PREBOPRO','si',20,6,'activo','Ctto2','Cot1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRICOT21','Planilla Previsoria de Bono','PREBOPRO','si',20,8,'activo','Ctto2','Cot3','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','APCAJ','Planilla Previsoria de Bono','PREBOPRO','si',20,13,'activo','Aporte ','Caja','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','CTOTAL','Planilla Previsoria de Bono','PREBOPRO','si',20,14,'activo','costo','Total','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PORCBONO','Planilla Previsoria de Bono','PREBOPRO','si',20,2,'activo','Porcentaje','Bono','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREBONO','Planilla Previsoria de Bono','PREBOPRO','si',20,12,'activo','Prev.','Bono','otro',0,'','columna_planilla');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','BONOVIG','Planilla de Bono Producción Vigentes','PLASUB','plani.f_bonovig_insert_empleados','prorrateo_aguinaldo','plani.f_bonovig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','APCAJ','BONOVIG','Aporte Pat. CPS','formula','Aporte Patronal CPS','{BONO}*0.10','si_contable','','2','20','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BONO','BONOVIG','Bono a pagar','formula','Bono a pagar','(({PREPROME2}/360*{PREDIAS2}) *({PORCBONO}/100))','si_contable','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CTOTAL','BONOVIG','Costo Total','formula','Costo Total de Planilla','{BONO}+{APCAJ}','no','','2','21','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_FRONTERAPRI','BONOVIG','Zona Franca','basica','Si es zona_franca','','no','','2','15','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','BONOVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> {BONO} then 0 else
({BONO}-{IMPOFAC})*13/100*{FAC_FRONTERAPRI} end','si_pago','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','BONOVIG','Importe de Facturas al 100 porciento','variable','Importe de Facturas al 100 porciento','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','BONOVIG','Bono Liquido','formula','Bono Liquido','{BONO}-{TOTDESC}','si_pago','','2','19','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','BONOVIG','Otros Descuentos','variable','Otros Descuentos','','si_pago','','2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PORCBONO','BONOVIG','Porcentaje Bono','variable','Porcentaje de bono por funcionario','','no','','2','12','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','BONOVIG','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','BONOVIG','Prevision Cotizable 21','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','BONOVIG','Prevision Cotizable 22','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','BONOVIG','Prevision Cotizable 23','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','BONOVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','BONOVIG','Total Descuentos','formula','Total Descuentos','{OTDESC}','no','','2','18','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','CAJA','BONOVIG','Pago Caja de salud','pago_comun','si','si',NULL,'Pago del 10% por caja','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','DESCHEQ','BONOVIG','Descuento por Cheque','pago_comun','no','no',NULL,'','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','BONOVIG','Liquido Bono','pago_empleados','no','si',NULL,'','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion_columna('insert','APCAJ','CAJA','BONOVIG','si','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONO','DESCHEQ','BONOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','BONOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONO','LIQPAG','BONOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','BONOVIG','si','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','PLANILLA DE BONO','BONOVIG','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE BONO','planilla_prima','formato_especifico','no','',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','BOLETA DE PAGO : INCENTIVO POR EL DESEMPEÑO','BONOVIG','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',70,186,'BOLETA DE PAGO : INCENTIVO POR EL DESEMPEÑO','','boleta','no','plani.vdatos_func_planilla',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','BONO POR DISTRITO - BANCO : PLANILLA DE BONO','BONOVIG','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'BONO POR DISTRITO - BANCO : PLANILLA DE BONO','relacion_saldos','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte_columna('insert','BONO','BOLETA DE PAGO : INCENTIVO POR EL DESEMPEÑO','BONOVIG','no',70,1,'activo',' ','TOTAL','otro',0,'','columna_planilla');



----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','BONONOVIG','Planilla de Bono NO vigentes','PLASUB','plani.f_bononovig_insert_empleados','prorrateo_aguinaldo','plani.f_bononovig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','APCAJ','BONONOVIG','Aporte Caja','formula','Aporte Caja','{BONO}*0.10','si_contable','','2','19','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','BONO','BONONOVIG','Bono a pagar','formula','Bono a pagar','(({PREPROME2}/360*{PREDIAS2}) *({PORCBONO}/100))','si_contable','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','CTOTAL','BONONOVIG','Costo Total','formula','Costo Total','{BONO}+{APCAJ}','no','','2','20','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_FRONTERAPRI','BONONOVIG','Zona Franca','basica','Zona Franca','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','BONONOVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> ({BONO}*0.13) then 0 else
({BONO}*0.13)-{IMPOFAC}*{FAC_FRONTERAPRI} end','si_pago','','2','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','BONONOVIG','Certificado RC-IVA','variable','Importe de Facturas al 100 porciento','','no','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','BONONOVIG','Bono Liquido','formula','Bono Liquido','{BONO} - COALESCE({TOTDESC},0)','si_pago','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','BONONOVIG','Otros Descuentos','variable','Otros Descuentos','','si_pago','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PORCBONO','BONONOVIG','Porcentaje Bono Funcionario','variable','Porcentaje Bono por Funcionario','','no','','2','11','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREDIAS2','BONONOVIG','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT21','BONONOVIG','Prevision Cotizable 21','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT22','BONONOVIG','Prevision Cotizable 22','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRICOT23','BONONOVIG','Prevision Cotizable 23','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','BONONOVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','BONONOVIG','Total Descuentos','formula','Total Descuentos','{OTDESC} + {IMPDET}','no','','2','17','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','CAJA','BONONOVIG','Pago Caja de salud','pago_comun','si','si',NULL,'Pago del 10% por caja','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','DESCHEQ','BONONOVIG','Descuento por Cheque','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','IMPDET','BONONOVIG','Impuesto Retenido','pago_comun','no','si',NULL,'Pago de impeustos retenidos','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','BONONOVIG','Liquido Bono','una_obligacion_x_empleado','no','si',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','APCAJ','CAJA','BONONOVIG','si','si','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONO','DESCHEQ','BONONOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','BONONOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONO','IMPDET','BONONOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','IMPDET','IMPDET','BONONOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','BONO','LIQPAG','BONONOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','BONONOVIG','si','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','PLANILLA DE BONO','BONONOVIG','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE BONO','planilla_prima','formato_especifico','no','',0,'no','no','BS',0,7.00);
----------------------------------------------------
-- planila de ajuste de beneficios socilaes
----------------------------------------------------



----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','PLASEGAGUI','Planilla de Segundo Aguinaldo','PLASUB','plani.f_plaguin_insert_empleados_etr','hoja_calculo','plani.f_plasegagui_valid_empleado','no','mensual','plani.f_plasue_generar_horas_sigma',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','AGUINA','PLASEGAGUI','Aguinaldo a Pagar','formula','Aguinaldo a Pagar','{PROME}/360*{DIASAGUI}','si',NULL,'2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DESCCHEQ','PLASEGAGUI','Descuento por cheque','variable','Descuento por cheque',NULL,'si_pago',NULL,'2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','DIASAGUI','PLASEGAGUI','Dias para Cálculo de Aguinaldo','basica','Dias para Cálculo de Aguinaldo',NULL,'no',NULL,'2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','PLASEGAGUI','Liquido Pagable','formula','Liquido Pagable','{AGUINA}-{DESCCHEQ}','si_pago',NULL,'2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROME','PLASEGAGUI','Promedio','formula','Promedio de los 3 últimos sueldos','({PROMHAB1}+{PROMHAB2}+{PROMHAB3})/3','no',NULL,'2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROMHAB1','PLASEGAGUI','Basico Promedio 1','basica','El primer haber básico que se tomará como promedio',NULL,'no',NULL,'2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROMHAB2','PLASEGAGUI','Basico Promedio 2','basica','El segundo haber básico que se tomará como promedio',NULL,'no',NULL,'2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PROMHAB3','PLASEGAGUI','Basico Promedio 3','basica','El tercer haber básico que se tomará como promedio',NULL,'no',NULL,'2','1','ejecutar','no','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','OBLICHEQ','PLASEGAGUI','Descuento por cheques','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','SEGAGUIN','PLASEGAGUI','Pago Liquido de Segundo Aguinaldo','pago_empleados','no','si',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AGUINA','OBLICHEQ','PLASEGAGUI','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','DESCCHEQ','OBLICHEQ','PLASEGAGUI','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','AGUINA','SEGAGUIN','PLASEGAGUI','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','SEGAGUIN','PLASEGAGUI','si','no','no','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','Reporte Segundo Aguinaldo','PLASEGAGUI','si','carta_horizontal','si','no','si','si','gerencia','nombre','activo',220,249,'Reporte Segundo Aguinaldo',NULL,'planilla',NULL,NULL,NULL,NULL,NULL,'BS',NULL,NULL);
select plani.f_import_treporte_columna('insert','DIASAGUI','Reporte Segundo Aguinaldo','PLASEGAGUI','no',25,1,'activo','Dias','Trabajados','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','PROMHAB1','Reporte Segundo Aguinaldo','PLASEGAGUI','si',25,2,'activo','Haber','Basico 1','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','PROMHAB2','Reporte Segundo Aguinaldo','PLASEGAGUI','si',25,3,'activo','Haber','Basico 2','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','PROMHAB3','Reporte Segundo Aguinaldo','PLASEGAGUI','si',25,4,'activo','Haber','Basico 3','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','AGUINA','Reporte Segundo Aguinaldo','PLASEGAGUI','si',25,5,'activo','Aguinaldo','a Pagar','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','AGUINA','Reporte Segundo Aguinaldo','PLASEGAGUI','si',25,7,'activo','Liquido','Pagable','otro',NULL,NULL,NULL);
select plani.f_import_treporte_columna('insert','DESCCHEQ','Reporte Segundo Aguinaldo','PLASEGAGUI','si',25,6,'activo','Total','Descuentos','otro',NULL,NULL,NULL);

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

/***********************************F-DAT-RAC-PLANI-113-30/04/2020****************************************/



/***********************************I-DAT-RAC-PLANI-113-05/05/2020****************************************/

select wf.f_import_testructura_estado ('insert','calculo_validado','obligaciones_generadas','PLASUB',1,'"{$tabla.codigo}" != "PLAPREPRI"');
select wf.f_import_testructura_estado ('insert','calculo_validado','planilla_finalizada','PLASUB',1,'"{$tabla.codigo}" = "PLAPREPRI"');



/***********************************F-DAT-RAC-PLANI-113-05/05/2020****************************************/



/***********************************I-DAT-RAC-PLANI-113-06/05/2020****************************************/


CREATE INDEX tobligacion_columna__id_obligacion_idx ON plani.tobligacion_columna
  USING btree (id_obligacion);

  --------------- SQL ---------------

CREATE INDEX tprorrateo__id_funcionario_plan_idx ON plani.tprorrateo
  USING btree (id_funcionario_planilla);

CREATE INDEX tprorrateo_columna_codigo_columna_idx ON plani.tprorrateo_columna
  USING btree (codigo_columna COLLATE pg_catalog."default");


--------------- SQL ---------------

CREATE INDEX tprorrateo_columna_idx ON plani.tprorrateo_columna
  USING btree (id_tipo_columna);

--------------- SQL ---------------

CREATE INDEX tprorrateo_columna__id_prorrateo_idx1 ON plani.tprorrateo_columna
  USING btree (id_prorrateo);

  --------------- SQL ---------------

CREATE INDEX ttipo_columna__id_tipo_plan_idx ON plani.ttipo_columna
  USING btree (id_tipo_planilla);


--------------- SQL ---------------

CREATE INDEX tfuncionario_planilla__id_planilla_idx ON plani.tfuncionario_planilla
  USING btree (id_planilla);

--------------- SQL ---------------

CREATE INDEX tfuncionario_planilla__id_funcionario_idx ON plani.tfuncionario_planilla
  USING btree (id_funcionario);


--------------- SQL ---------------

CREATE INDEX tplanilla__id_tipo_planillas_idx ON plani.tplanilla
  USING btree (id_tipo_planilla);

--------------- SQL ---------------

CREATE INDEX tplanilla_id_gestion_periodo_dx ON plani.tplanilla
  USING btree (id_periodo, id_gestion);


--------------- SQL ---------------

CREATE INDEX tplanilla_i_id_estado_wf_dx ON plani.tplanilla
  USING btree (id_estado_wf);


--------------- SQL ---------------

CREATE INDEX ttipo_obligacion_idx ON plani.ttipo_obligacion
  USING btree (codigo);


--------------- SQL ---------------

CREATE INDEX ttipo_obligacion_columna_idx ON plani.ttipo_obligacion_columna
  USING btree (codigo_columna);



/***********************************F-DAT-RAC-PLANI-113-07/05/2020****************************************/



/***********************************I-DAT-RAC-PLANI-124-18/05/2020****************************************/




select param.f_import_tdocumento ('insert','PREBOPRO','Prevision de Bono de Producción','PLANI','depto','gestion','',NULL);
select param.f_import_tdocumento ('insert','PRINOVIG','Prima Personal No Vigente','PLANI','depto','gestion','',NULL);





/***********************************F-DAT-RAC-PLANI-124-18/05/2020****************************************/



/***********************************I-DAT-RAC-PLANI-129-27/05/2020****************************************/


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'plani_reset_variables_modificadas', E'false', E'resetar valores modificads por el usario al volver al estado registro de funcionarios');

/***********************************F-DAT-RAC-PLANI-129-27/05/2020****************************************/




/************I-DAT-MZM-PLANI-137-10/06/2020*************/

select plani.f_import_treporte('insert','LISTADO POR CENTROS','PLASUE','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'LISTADO POR CENTROS','listado_centros','formato_especifico','no','',0,'no','no','BS',0,7.00);

/************F-DAT-MZM-PLANI-137-10/06/2020*************/


/************I-DAT-RAC-PLANI-137-10/06/2020*************/

select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PLAPREPRI','Promedio','formula','Promedio de 3 ultimos sueldos','(({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3)+{TP1}','no','','2','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PLAPREPRI','Promedio del ultimo contrato','formula','promedio de 3 ultimos sueldos ultimo contrato','(({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3)+{TP2}','no','','2','10','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP1','PLAPREPRI','Ajuste por Reintegros','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del primer contrato','','no','','2','-4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','PLAPREPRI','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');


select plani.f_import_ttipo_columna_planilla ('insert','TP1','PRINOVIG','Ajuste por Reintegros','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del primer contrato','','no','','2','-4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','PRINOVIG','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','PRINOVIG','Promedio C1','formula','Promedio de 3 ultimos sueldos','(({PREPRICOT11}+{PREPRICOT12}+{PREPRICOT13})/3)+{TP1}','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME2','PRINOVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','(({PREPRICOT21}+{PREPRICOT22}+{PREPRICOT23})/3)+{TP2}','no','','2','8','ejecutar','no','no','no','activo');


/************F-DAT-RAC-PLANI-137-10/06/2020*************/

************I-DAT-RAC-PLANI-137-15/06/2020*************/

select plani.f_import_ttipo_columna_planilla ('insert','BONANT','PLASUE','Bono antiguedad','formula','Bono de Antigüedad del empleado a partir de 3 salarios mínimos nacionales con incapacidad temporal','CASE WHEN {INCAP_DIAS} > 0    THEN  {BONOANTG} - ({BONOANTG} * ({INCAP_DIAS} *{HORDIA}/{HOREFEC}) * ({INCAP_PORC}))  ELSE {BONOANTG} END','si','','2','5','restar_ejecutado','no','no','si','activo');

************F-DAT-RAC-PLANI-137-15/06/2020*************/

************I-DAT-RAC-PLANI-137-29/06/2020*************/
select plani.f_import_ttipo_columna_planilla ('insert','PORDOSSMN','PLASUE','2 Salarios Mínimos Nacionales','formula','2 Salarios Mínimos Nacionales','2*{SALMIN}*0.13','no','','2','40','ejecutar','no','si','si','activo');
select plani.f_import_treporte_columna('insert','PORDOSSMN','Planilla Impositiva','PLASUE','si',18,11,'activo','13% sobre','dos SMN','otro',0,'','columna_planilla');
************F-DAT-RAC-PLANI-137-29/06/2020*************/


************I-DAT-RAC-PLANI-145-03/07/2020*************/


select param.f_import_tdocumento ('insert','SPLAPREPRI','Planillas de Previsión de Primas Simple','PLANI','depto','gestion','',NULL);
select param.f_import_tdocumento ('insert','SPLAPRIVIG','Planilla de Primas Simple','PLANI','depto','gestion','',NULL);
select param.f_import_tdocumento ('insert','SPRINOVIG','Planilla  Simple de Prima No vigentes','PLANI','depto','gestion','',NULL);


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','SPLAPREPRI','Planilla de Previsión de Prima Simple','PLASUB','plani.f_splaprepri_insert_empleados','prorrateo_aguinaldo','plani.f_plaprepri_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPRIMA','SPLAPREPRI','Prima a pagar','formula','prima a pagar','CASE
WHEN ({SPREDIAS1}+{SPREDIAS2})>=90 THEN
({PREPROME1}/360*({SPREDIAS1}+{SPREDIAS2}) *({PORCENTAJEPRIM}/100))
ELSE 0 END
','no','','2','11','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME1','SPLAPREPRI','Promedio','formula','Promedio de 3 ultimos sueldos','(({SPREPRICOT1}+{SPREPRICOT2}+{SPREPRICOT3})/3)+{TP2}','no','','2','9','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREDIAS1','SPLAPREPRI','Dias para calculo','basica','Dias para calculo',NULL,'no',NULL,'2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREDIAS2','SPLAPREPRI','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT1','SPLAPREPRI','Prevision Cotizable1','basica','Prevision de primer sueldo para promedio',NULL,'no',NULL,'2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT2','SPLAPREPRI','Prevision Cotizable2','basica','Prevision de segundo sueldo para promedo','','no','','2','2','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT3','SPLAPREPRI','Prevision cotizable3','basica','prevision de tercer sueldo para promedio','','no','','2','3','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP1','SPLAPREPRI','Ajuste por Reintegros','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del primer contrato','','no','','2','-4','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','SPLAPREPRI','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------



----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','Planilla Previsoria de Prima','SPLAPREPRI','no','carta_horizontal','no','no','no','no','ninguno','nombre','activo',188,249,'Planilla Previsoria de Prima','','planilla','no','plani.vdatos_func_planilla',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','Planilla de Prevision de Prima','SPLAPREPRI','no','carta_horizontal','no','no','no','no','ninguno','nombre','activo',0,249,'Planilla de Prevision de Prima','planilla_prevision','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte_columna('insert','SPREPRICOT2','Planilla Previsoria de Prima','SPLAPREPRI','si',20,3,'activo','Ctto1','Cot2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SPREPRICOT3','Planilla Previsoria de Prima','SPLAPREPRI','si',20,4,'activo','Ctto1','Cot3','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SPREDIAS1','Planilla Previsoria de Prima','SPLAPREPRI','si',10,5,'activo','Dias','Ctto1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SPREDIAS2','Planilla Previsoria de Prima','SPLAPREPRI','si',10,9,'activo','Dias','Ctto2','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPRIMA','Planilla Previsoria de Prima','SPLAPREPRI','si',20,12,'activo','Prev.','Prima','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Planilla Previsoria de Prima','SPLAPREPRI','no',68,1,'activo','Nombre','Emp.','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','SPREPRICOT1','Planilla Previsoria de Prima','SPLAPREPRI','si',20,2,'activo','Ctto1','Cot1','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PREPROME1','Planilla Previsoria de Prima','SPLAPREPRI','si',20,11,'activo','Prom','Cot2','otro',0,'','columna_planilla');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','SPLAPRIVIG','Planilla de Prima Vigentes Simple','PLASUB','plani.f_splaprivig_insert_empleados','prorrateo_aguinaldo','plani.f_plaprivig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERAPRI','SPLAPRIVIG','Factor Frontera','basica','Factor Frontera','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_FRONTERAPRI','SPLAPRIVIG','Zona Franca','basica','Si es zona_franca','','no','','2','14','ejecutar','no','no','si','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','SPLAPRIVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> {PRIMA} then 0 else
({PRIMA}-{IMPOFAC})*13/100*{FAC_FRONTERAPRI} end','si_pago','','2','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','SPLAPRIVIG','Importe de Facturas al 100 porciento','variable','Importe de Facturas al 100 porciento','','no','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','SPLAPRIVIG','Prima Liquida','formula','Prima Liquida','{PRIMA}-{TOTDESC}','si_pago','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','SPLAPRIVIG','Otros Descuentos','variable','Otros Descuentos','','si_pago','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME','SPLAPRIVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','(({SPREPRICOT1}+{SPREPRICOT2}+{SPREPRICOT3})/3)+{TP2}','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRIMA','SPLAPRIVIG','Prima a pagar','formula','Prima a pagar','CASE
WHEN ({SPREDIAS1}+{SPREDIAS2})>=90 THEN
({PREPROME}/360*({SPREDIAS1}+{SPREDIAS2}) *({PORCENTAJEPRIM}/100))
ELSE 0 END
','si_contable','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREDIAS1','SPLAPRIVIG','Dias para calculo','basica','Días para calculo','','no','','2','7','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREDIAS2','SPLAPRIVIG','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT1','SPLAPRIVIG','Prevision Cotizable 21','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT2','SPLAPRIVIG','Prevision Cotizable 22','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT3','SPLAPRIVIG','Prevision Cotizable 23','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','SPLAPRIVIG','Total Descuentos','formula','Total Descuentos','{OTDESC}','no','','2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','SPLAPRIVIG','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','DESCHEQ','SPLAPRIVIG','Descuento por Cheque','pago_comun','no','no',NULL,'','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','SPLAPRIVIG','Liquido Prima','pago_empleados','no','si',NULL,'','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','SPLAPRIVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','DESCHEQ','SPLAPRIVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','SPLAPRIVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','LIQPAG','SPLAPRIVIG','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','PLANILLA DE PRIMA','SPLAPRIVIG','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE PRIMA','planilla_prima','formato_especifico','no','',0,'no','no','BS',0,7.00);
select plani.f_import_treporte('insert','PRIMA POR DISTRITO - BANCO : PLANILLA DE PRIMA','SPLAPRIVIG','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',0,186,'PRIMA POR DISTRITO - BANCO : PLANILLA DE PRIMA','relacion_saldos','formato_especifico','no','',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte('insert','BOLETA DE PAGO : PRIMA ANUAL','SPLAPRIVIG','no','carta_vertical','no','no','no','no','ninguno','nombre','activo',70,186,'BOLETA DE PAGO : PRIMA ANUAL','','boleta','no','plani.vdatos_func_planilla',0,'no','no','BS',NULL,7.00);
select plani.f_import_treporte_columna('insert','PRIMA','BOLETA DE PAGO : PRIMA ANUAL','SPLAPRIVIG','no',70,1,'activo','TOTAL','PRIMA','otro',0,'','columna_planilla');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion TIPO PLANILLA
---------------------------------

select plani.f_import_ttipo_planilla ('insert','SPRINOVIG','Planilla de Prima NO vigentes Simple','PLASUB','plani.f_sprinovig_insert_empleados','prorrateo_aguinaldo','plani.f_prinovig_valid_empleado','no','anual','',NULL,'activo');
select plani.f_import_ttipo_columna_planilla ('insert','FACFRONTERAPRI','SPRINOVIG','Factor Frontera','basica','Factor Frontera','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','FAC_FRONTERAPRI','SPRINOVIG','Zona Franca','basica','Zona Franca','','no','','2','14','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPDET','SPRINOVIG','Impuesto Determinado','formula','Impuesto Determinado','case when {IMPOFAC}> ({PRIMA}*0.13) then 0 else
({PRIMA}*0.13)-{IMPOFAC}*{FAC_FRONTERAPRI} end','si_pago','','2','15','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','IMPOFAC','SPRINOVIG','Certificado RC-IVA','variable','Importe de Facturas al 100 porciento','','no','','2','13','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','LIQPAG','SPRINOVIG','Prima Liquida','formula','Prima Liquida','{PRIMA} - COALESCE({TOTDESC},0)','si_pago','','2','18','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','OTDESC','SPRINOVIG','Otros Descuentos','variable','Otros Descuentos','','si_pago','','2','16','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PREPROME','SPRINOVIG','Promedio C2','formula','Promedio de 3 últimos sueldos (Penultimo contrato)','(({SPREPRICOT1}+{SPREPRICOT2}+{SPREPRICOT3})/3)+{TP2}','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','PRIMA','SPRINOVIG','Prima a pagar','formula','Prima a pagar','CASE
WHEN ({SPREDIAS1}+{SPREDIAS2})>=90 THEN
({PREPROME}/360*({SPREDIAS1}+{SPREDIAS2}) *({PORCENTAJEPRIM}/100))
ELSE 0 END
','si_contable','','2','12','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREDIAS1','SPRINOVIG','Dias de primer contrato','basica','dias de primer contrato','','no','','2','1','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREDIAS2','SPRINOVIG','Dias para calculo para ultimo contrato','basica','Dias para calculo para ultimo contrato','','no','','2','8','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT1','SPRINOVIG','Prevision Cotizable 21','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','4','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT2','SPRINOVIG','Prevision Cotizable 22','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','5','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','SPREPRICOT3','SPRINOVIG','Prevision Cotizable 23','basica','COTIZABLE DE UN CONTRATO ANTERIOR','','no','','2','6','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TOTDESC','SPRINOVIG','Total Descuentos','formula','Total Descuentos','{OTDESC} + {IMPDET}','no','','2','17','ejecutar','no','no','no','activo');
select plani.f_import_ttipo_columna_planilla ('insert','TP2','SPRINOVIG','Ajuste por Reintegros2','variable','Columna temporal para cargar el ajuste del cotizable por reintegros del segundo contrato','','no','','2','-3','ejecutar','no','no','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion OBLIGACIONES
---------------------------------

select plani.f_import_ttipo_obligacion('insert','DESCHEQ','SPRINOVIG','Descuento por Cheque','pago_comun','no','no',NULL,NULL,'CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion('insert','IMPDET','SPRINOVIG','Impuesto Retenido','pago_comun','no','si',NULL,'Pago de impeustos retenidos','CUEOBLI','CUEOBLIHAB','activo');
select plani.f_import_ttipo_obligacion('insert','LIQPAG','SPRINOVIG','Liquido Prima','una_obligacion_x_empleado','no','si',NULL,'','CUEOBLI','CUEOBLI','activo');
select plani.f_import_ttipo_obligacion_columna('insert','OTDESC','DESCHEQ','SPRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','DESCHEQ','SPRINOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','IMPDET','IMPDET','SPRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','IMPDET','SPRINOVIG','no','si','si','activo');
select plani.f_import_ttipo_obligacion_columna('insert','LIQPAG','LIQPAG','SPRINOVIG','si','no','no','activo');
select plani.f_import_ttipo_obligacion_columna('insert','PRIMA','LIQPAG','SPRINOVIG','no','si','si','activo');


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE
--Configuracion REPORTES
---------------------------------

select plani.f_import_treporte('insert','PLANILLA DE PRIMA','SPRINOVIG','no','carta_horizontal','no','no','no','no','distrito_banco','nombre','activo',0,249,'PLANILLA DE PRIMA','planilla_prima','formato_especifico','no','',0,'no','no','BS',0,7.00);
************F-DAT-RAC-PLANI-145-03/07/2020*************/



************I-DAT-MZM-PLANI-4096-27/05/2021*************/

select plani.f_import_treporte('insert','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no','carta_horizontal','no','no','no','no','distrito','organigrama','activo',0,249,'Multilinea por Distrito: Planilla de Reintegros','','planilla','si','plani.nvdatos_func_planilla',11,'no','no','BS',0,5.00);
select plani.f_import_treporte_columna('insert','TOTGAN','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,83,'activo','Tot.','Ganado','otro',0,'total_ganado','columna_planilla');
select plani.f_import_treporte_columna('insert','ASIGNACIONES','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,71,'activo','Asignaciones',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','INGVAR','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,70,'activo','Ingr.','Varios','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no',0,2,'activo','Fech.','Ingreso','otro',0,'fecha_ingreso','vista_externa');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no',0,4,'activo','Nombre','Empleado','otro',0,'nombre_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','PRMIMPRCIVA','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,7,'activo','Imp.','RCIVA','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_SSO','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,9,'activo','Cuota','Indiv','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_RIEPRO','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,12,'activo','Riesgo','Prof.','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no',0,13,'activo','Cd','Empleado','otro',0,'codigo_funcionario','vista_externa');
select plani.f_import_treporte_columna('insert','PRMAFP_APPAT','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,1,'activo','Solidario','Pat','otro',10,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUBPRE','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,6,'activo','Prenatal','','otro',2,'SUBPRE','vista_externa');
select plani.f_import_treporte_columna('insert','cac','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,8,'activo','Fond.','CACSEL','otro',0,'CACSELVAR','vista_externa');
select plani.f_import_treporte_columna('insert','sib','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,10,'activo','S.I.B.','','otro',0,'ASIB','vista_externa');
select plani.f_import_treporte_columna('insert','PRESPER','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,52,'activo','Préstamo',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','ASIB','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,10,'activo','S.I.B.',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','HORNOC','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,37,'activo','Hrs.','Nocturnas','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','OTRO_DESC','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,44,'activo','Desc.','Varios','otro',3,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO1','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,48,'activo','Reintegro','1','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','REINTEGRO2','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,59,'activo','Reintegro','2','otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','LICENCIA','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,65,'activo','Licencias',NULL,'otro',0,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','MUL_ATRA','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,74,'activo','Multas',NULL,'otro',2,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','COTIZABLE_ANT','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,78,'activo','Cotiz.','Ant.','otro',3,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','HORNORM','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,81,'activo','Hrs.','Normales','otro',2,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','RETJUD','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,51,'activo','Ret','Judicial','otro',2,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','SUBNAT','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,40,'activo','Natalidad',NULL,'otro',1,NULL,'columna_planilla');
select plani.f_import_treporte_columna('insert','PRMNATSEP','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,28,'activo','Natalidad','/Sepelio','otro',0,'subsep','columna_planilla');
select plani.f_import_treporte_columna('insert','CACSELPRES','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,30,'activo','Ptm','CACSEL','otro',0,'CACSELPRES','vista_externa');
select plani.f_import_treporte_columna('insert','PRMAFP_CADM','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,31,'activo','Cuota','Adm.','otro',0,'cad','columna_planilla');
select plani.f_import_treporte_columna('insert','APSIND','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,32,'activo','Ap.','Sindicato','otro',0,'APSIND','vista_externa');
select plani.f_import_treporte_columna('insert','DESCANTC','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,33,'activo','Anticipos','','otro',0,'DESCANTC','vista_externa');
select plani.f_import_treporte_columna('insert','PRMPREAGUI','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,34,'activo','Reserva','BS','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMSUELDOBA','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,36,'activo','Sueldo','Mes','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMNOCTURNO','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,38,'activo','Recargo','Noct.','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMPREPRI','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,45,'activo','Prima','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APNALSOL','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,53,'activo','Nac.','Solidario','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMTOT_DESC','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,55,'activo','Tot.','Desc.','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMPREAGUI','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,56,'activo','P.','Aguinaldo','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMDISPONIBILIDAD','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,58,'activo','Disponibilidad','','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_APSOL','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,64,'activo','Solidario','Aseg.','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMAFP_VIVIE','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,67,'activo','PROVI','Pat','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMBONOANTG','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,69,'activo','B.','Antiguedad','otro',1,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMCOTIZABLE','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,82,'activo','Cotizable','','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMLIQPAG','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,88,'activo','Lq.','Pagable','otro',4,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no',0,15,'activo','Cargo','','otro',0,'cargo','vista_externa');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,16,'activo','Incap','Temp','otro',1,'INCAP_TEMPORAL','vista_externa');
select plani.f_import_treporte_columna('insert','sub','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,17,'activo','Lactancia','','otro',0,'SUBLAC','vista_externa');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,18,'activo','Prdt.','Lact.','otro',0,'sublac','vista_externa');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,19,'activo','Cuot.','CACSEL','otro',0,'CACSELFIJO','vista_externa');
select plani.f_import_treporte_columna('insert','PRMAFP_RCOM','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,20,'activo','Riesgo','Común','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','PRMCAJSAL','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,23,'activo','CPS','','otro',2,'','columna_planilla');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no',0,24,'activo','Fech.','Nac.','otro',0,'fecha_nacimiento','vista_externa');
select plani.f_import_treporte_columna('insert','HAB','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,25,'activo','Sueldo','Base','otro',0,'HABBAS','vista_externa');
select plani.f_import_treporte_columna('insert','PRMEXTRA','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,26,'activo','Hrs.','Extras','otro',0,'HOREXT','vista_externa');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,27,'activo','Sobretiempo','','otro',0,'EXTRA','vista_externa');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no',0,35,'activo','Carnet','Ident','otro',0,'num_documento','vista_externa');
select plani.f_import_treporte_columna('insert','','Multilinea por Distrito: Planilla de Reintegros','PLANRE','no',0,46,'activo','Nivel','- CS','otro',0,'nivel','vista_externa');
select plani.f_import_treporte_columna('insert','PRMCOSTO_TOTAL','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,89,'activo','Total','General','otro',0,'','columna_planilla');
select plani.f_import_treporte_columna('insert','SUBPRE','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,29,'activo','Prenatal','','otro',0,'subpre','vista_externa');
select plani.f_import_treporte_columna('insert','PRMBONFRONTERA','Multilinea por Distrito: Planilla de Reintegros','PLANRE','si',0,47,'activo','Sub.','Frontera','otro',0,'','columna_planilla');
************F-DAT-MZM-PLANI-4096-27/05/2021*************/