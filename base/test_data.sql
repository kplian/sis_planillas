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


/* Data for the 'orga.ttemporal_jerarquia_aprobacion' table  (Records 1 - 1) */

INSERT INTO orga.ttemporal_jerarquia_aprobacion ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_temporal_jerarquia_aprobacion", "nombre", "numero", "estado")
VALUES (1, NULL, E'2014-01-23 13:20:03.747', NULL, E'activo', 1, E'prueba', 1, E'activo');

/* Data for the 'orga.ttemporal_cargo' table  (Records 1 - 1) */

INSERT INTO orga.ttemporal_cargo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_temporal_cargo", "nombre", "estado", "id_temporal_jerarquia_aprobacion")
VALUES (1, NULL, E'2014-01-23 13:20:18.231', NULL, E'activo', 1, E'cargo de prueba', E'activo', 1);

/* Data for the 'orga.tcategoria_salarial' table  (Records 1 - 1) */

INSERT INTO orga.tcategoria_salarial ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_categoria_salarial", "codigo", "nombre")
VALUES (1, NULL, E'2014-01-23 13:18:48.645', NULL, E'activo', 1, E'EJE', E'Ejecutivo');

/* Data for the 'orga.tescala_salarial' table  (Records 1 - 2) */

INSERT INTO orga.tescala_salarial ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_escala_salarial", "id_categoria_salarial", "codigo", "nombre", "haber_basico", "fecha_ini", "fecha_fin", "aprobado", "nro_casos")
VALUES (1, NULL, E'2014-01-23 13:19:15.871', NULL, E'activo', 1, 1, E'GER', E'Gerente General', 13000, E'2014-01-23', NULL, E'si', 5);

INSERT INTO orga.tescala_salarial ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_escala_salarial", "id_categoria_salarial", "codigo", "nombre", "haber_basico", "fecha_ini", "fecha_fin", "aprobado", "nro_casos")
VALUES (1, NULL, E'2014-01-23 13:19:41.472', NULL, E'activo', 2, 1, E'GERA', E'Gerente de Area', 20000, E'2014-01-23', NULL, E'si', 5);

/* Data for the 'orga.toficina' table  (Records 1 - 1) */

INSERT INTO orga.toficina ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_oficina", "codigo", "nombre", "id_lugar", "aeropuerto", "frontera", "zona_franca")
VALUES (1, NULL, E'2014-01-23 13:26:52.386', NULL, E'activo', 1, E'CBBACEN', E'Oficina Central Cbba', 3, E'no', E'no', E'no');

/* Data for the 'orga.tcargo' table  (Records 1 - 1) */

INSERT INTO orga.tcargo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_cargo", "id_uo", "id_tipo_contrato", "id_escala_salarial", "codigo", "nombre", "fecha_ini", "fecha_fin", "id_lugar", "id_temporal_cargo", "id_oficina")
VALUES (1, NULL, E'2014-01-23 13:28:09.957', NULL, E'activo', 1, 4, 1, 2, E'1', E'cargo de prueba', E'2013-01-23', NULL, 3, 1, 1);

INSERT INTO orga.tcargo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_cargo", "id_uo", "id_tipo_contrato", "id_escala_salarial", "codigo", "nombre", "fecha_ini", "fecha_fin", "id_lugar", "id_temporal_cargo", "id_oficina")
VALUES (1, NULL, E'2014-01-23 13:28:09.957', NULL, E'activo', 2, 4, 1, 1, E'2', E'cargo de prueba2', E'2013-01-23', NULL, 3, 1, 1);

/* Data for the 'plani.ttipo_columna' table  (Records 1 - 41) */

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-27 14:08:40.643', NULL, E'activo', 4, 1, E'HORNORM', E'Horas Normales', E'basica', E'Horas Normales del Empleado', E'', E'no', E'', 0, 1, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 22:55:03.741', E'2014-01-29 22:57:10.274', E'activo', 9, 1, E'COTIZABLE', E'Cotizable', E'formula', E'Cotizable sobre el que se aplican afps e impuestos', E'{SUELDOBA}+{BONANT}+{BONFRONTERA}', E'no', E'', 2, 10, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:59:55.711', E'2014-01-29 00:00:35.798', E'activo', 24, 1, E'AFP_VIVIE', E'Afp Vivienda 2%', E'formula', E'Afp Vivienda 2%', E'{COTIZABLE}*0.02', E'si', E'', 2, 19, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:39:04.080', E'2014-01-29 00:01:00.640', E'activo', 20, 1, E'AFP_VAR2', E'AFP variable 2 para aporte nacional solidario', E'formula', E'Aporte para sueldos arriba de 25000', E'CASE WHEN ({COTIZABLE}-25000)> 0 THEN  ({COTIZABLE}-25000)*0.05 ELSE 0 END', E'no', E'', 2, 21, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:54:00', E'2014-01-29 23:55:00', E'activo', 36, 1, E'SALDOPERIANTACT', E'Saldo Anterior Actualizado', E'formula', E'Saldo Anterior Actualizado del dependiente', E'{SALDOPERIANTDEP}*{FAC_ACT}', E'no', E'', 2, 40, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:39:49.889', E'2014-01-29 00:01:09.645', E'activo', 21, 1, E'AFP_VAR3', E'AFP variable 3 para aporte nacional solidario', E'formula', E'Aporte para sueldos arriba de 35000', E'CASE WHEN ({COTIZABLE}-35000)> 0 THEN  ({COTIZABLE}-35000)*0.1 ELSE 0 END', E'no', E'', 2, 22, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:08:48.530', E'2014-01-29 23:10:35.030', E'activo', 27, 1, E'SUELNETO', E'Sueldo Neto', E'formula', E'Total Ganado menos AFP', E'{COTIZABLE}-({AFP_SSO}+{AFP_RCOM}+{AFP_CADM}+{AFP_APSOL})', E'no', E'', 2, 30, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:48:35.175', E'2014-01-29 00:01:40.817', E'activo', 22, 1, E'AFP_LAB', E'Suma de aportes laborales para AFP', E'formula', E'Suma laborales AFP', E'{AFP_SSO}+{AFP_RCOM}+{AFP_CADM}+{AFP_APSOL}+{AFP_APNALSOL}', E'no', E'', 2, 24, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 14:36:34.774', NULL, E'activo', 7, 1, E'FACTORANTI', E'Factor de Antiguedad', E'basica', E'Factor de antiguedad de acuerdo al tiempo que trabaja el empleado en la empresa', E'', E'no', E'', 2, 3, E'restar_ejecutado');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 14:51:52.572', NULL, E'activo', 8, 1, E'BONANT', E'Bono de Antiguedad', E'formula', E'Bono de Antiguedad dle empleado a partir de 3 salarios minimos nacionales', E'({SALMIN}*{FACTORANTI}/100*3)*({HORNORM}/{HORLAB})', E'si', E'', 2, 4, E'restar_ejecutado');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 23:00:28.666', NULL, E'activo', 10, 1, E'JUB65', E'Es jubilado de 65', E'basica', E'0 si es jubilado de 65 y 1 si no es', E'', E'no', E'', 0, 11, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-27 14:07:02.961', E'2014-01-28 23:00:50.734', E'activo', 3, 1, E'SUELDOBA', E'Sueldo Básico', E'basica', E'Sueldo básico del empleado', E'', E'si_devengado', E'', 2, 2, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 23:02:14.254', NULL, E'activo', 11, 1, E'JUB55', E'Es jubilado de 55', E'basica', E'0 si es jubilado de 55 y 1 si no es jubilado de 55', E'', E'no', E'', 0, 12, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 23:04:39.034', NULL, E'activo', 12, 1, E'AFP_SSO', E'Afp seguro obligatorio 10%', E'formula', E'descuento del 10% al empleado por afp', E'{COTIZABLE}*0.1*{JUB65}*{JUB55}', E'no', E'', 2, 13, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 23:07:12.477', NULL, E'activo', 13, 1, E'AFP_CADM', E'Afp Costos Administrativos 0.5%', E'formula', E'Descuento al empleado de 0.5%', E'{COTIZABLE}*0.005', E'no', E'', 2, 14, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:10:40.965', E'2014-01-28 23:10:53.271', E'activo', 14, 1, E'AFP_RIEPRO', E'Afp Riesgo Profesional', E'formula', E'Riesgo profesional que paga el empleador 1.71%', E'{COTIZABLE}*0.0171*{JUB65}', E'si', E'', 2, 15, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 23:13:29.731', NULL, E'activo', 15, 1, E'AFP_RCOM', E'Afp Riesgo Común', E'formula', E'Afp riesgo comun descontado al empleado 1.71%', E'{COTIZABLE}*0.0171*{JUB65}', E'no', E'', 2, 16, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 23:20:13.628', NULL, E'activo', 16, 1, E'AFP_APPAT', E'Afp Aporte Patronal Solidario', E'formula', E'Afp aporte patronal solidario del 3%', E'{COTIZABLE}*0.03', E'si', E'', 2, 17, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-28 23:23:34.777', NULL, E'activo', 17, 1, E'AFP_APSOL', E'Afp Aporte Solidario', E'formula', E'Aporte solidario del asegurado 0.5%', E'{COTIZABLE}*0.005', E'no', E'', 2, 18, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:14:33.781', E'2014-01-29 23:14:58.848', E'activo', 28, 1, E'MINNOIMP', E'Minimo no Imponible', E'formula', E'Minimo no imponible igual a 4 salarios minimos nacionales', E'{SALMIN}*4', E'no', E'', 2, 31, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:21:08.032', E'2014-01-30 10:15:12.738', E'activo', 30, 1, E'IMPDET', E'Impuesto Determinado', E'formula', E'Impuesto Determinado', E'{IMPSUJIMP}*0.13*{FAC_ZONAFRAN}', E'no', E'', 2, 34, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:49:34.921', E'2014-01-29 00:01:54.937', E'activo', 23, 1, E'AFP_PAT', E'Suma de aportes patronales para AFP', E'formula', E'Suma patronales AFP', E'{AFP_RIEPRO}+{AFP_VIVIE}+{AFP_APPAT}', E'no', E'', 2, 25, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:28:40.383', E'2014-01-29 00:01:23.270', E'activo', 18, 1, E'AFP_APNALSOL', E'Afp Aporte Nacional Solidario ', E'formula', E'Aporte Nacional Solidario por Rangos', E'case when {AFP_VAR1}+{AFP_VAR2}+{AFP_VAR3} > 0 then\r\n{AFP_VAR1}+{AFP_VAR2}+{AFP_VAR3}\r\nelse\r\n0.00\r\nend', E'no', E'', 2, 23, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-29 08:31:22.944', NULL, E'activo', 25, 1, E'FACFRONTERA', E'Factor del bono de Frontera', E'basica', E'Factor que corresponde al empleado del bono de frontera', E'', E'no', E'', 2, 5, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 08:41:14.577', E'2014-01-29 08:41:34.722', E'activo', 26, 1, E'BONFRONTERA', E'Bono de Frontera', E'formula', E'bono de frontera para los empleados que correspondan', E'{SUELDOBA}*0.2*{FACFRONTERA}', E'si', E'', 2, 6, E'restar_ejecutado');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:17:32.234', E'2014-01-29 23:17:48.981', E'activo', 29, 1, E'IMPSUJIMP', E'Importe Sujeto a Impuesto', E'formula', E'sujeto a impuesto resta entre el sueldo neto y el minimo no imponible', E'CASE WHEN {SUELNETO}-{MINNOIMP} > 0  THEN {SUELNETO}-{MINNOIMP} ELSE 0 END', E'no', E'', 2, 32, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-28 23:38:33.423', E'2014-01-29 00:00:52.784', E'activo', 19, 1, E'AFP_VAR1', E'AFP variable 1 para aporte nacional solidario', E'formula', E'Aporte para sueldos arriba de 13000', E'CASE WHEN ({COTIZABLE}-13000) > 0 THEN  ({COTIZABLE}-13000)*0.01 ELSE 0 END', E'no', E'', 2, 20, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:24:11.132', E'2014-01-29 23:26:35.978', E'activo', 31, 1, E'IMPOFAC', E'13% del Importe en Facturas', E'variable', E'13% del importe en facturas presentadas por el empleado', E'', E'no', E'', 2, 35, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:43:00', E'2014-01-29 23:43:00', E'activo', 32, 1, E'SALDOPERIDEP', E'Saldo del Periodo a favor del Dependiente', E'formula', E'Saldo del Periodo a favor del Dependiente', E'CASE WHEN ({IMPDET}-{IMPOFAC}>=0) THEN 0 ELSE {IMPOFAC}-{IMPDET} END', E'no', E'', 2, 36, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:47:00', E'2014-01-29 23:43:00', E'activo', 33, 1, E'SALDOPERIFIS', E'Saldo a Favor del Fisco del Periodo', E'formula', E'Saldo a Favor del Fisco del Periodo', E'CASE WHEN ({IMPOFAC}-{IMPDET}>0) THEN 0 ELSE {IMPDET}-{IMPOFAC} END', E'no', E'', 2, 37, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:51:00', E'2014-01-29 23:43:00', E'activo', 34, 1, E'SALDOPERIANTDEP', E'Saldo del Periodo Anterior', E'basica', E'Saldo del Periodo Anterior del dependiente', E'', E'no', E'', 2, 38, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:53:00', E'2014-01-29 23:43:00', E'activo', 35, 1, E'FAC_ACT', E'Factor de Actualizacion', E'basica', E'Factor de Actualizacion para saldo a favor del dependiente', E'', E'no', E'', 6, 39, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-29 23:59:00', E'2014-01-29 23:59:00', E'activo', 37, 1, E'SALDOTOTALDEP', E'Saldo Total del Dependiente', E'formula', E'Saldo Total del Dependiente', E'{SALDOPERIDEP}+{SALDOPERIANTACT}', E'no', E'', 2, 41, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-30 00:02:00', E'2014-01-30 00:08:00', E'activo', 38, 1, E'IMPURET', E'Impuesto Retenido', E'formula', E'Impuesto Retenido', E'CASE WHEN ({SALDOTOTALDEP}-{SALDOPERIFIS}>0) THEN 0 ELSE {SALDOPERIFIS}-{SALDOTOTALDEP} END', E'no', E'', 2, 42, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-30 00:03:00', E'2014-01-30 00:09:00', E'activo', 39, 1, E'SALDODEPSIGPER', E'Saldo Periodo Siguiente', E'formula', E'Saldo Periodo Siguiente a favor del dependiente', E'CASE WHEN ({SALDOPERIFIS}-{SALDOTOTALDEP}>0) THEN 0 ELSE {SALDOTOTALDEP}-{SALDOPERIFIS} END', E'no', E'', 2, 43, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-30 10:14:07.279', NULL, E'activo', 40, 1, E'FAC_ZONAFRAN', E'Factor Zona Franca', E'basica', E'Factor que se calcula a partir del tiempo y sueldo que trabajo el empleado en zona franca', E'', E'no', E'', 2, 33, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-30 13:19:41.879', E'2014-01-30 13:20:20.207', E'activo', 41, 1, E'RETJUD', E'Retencion Judicial', E'variable', E'Retención Judicial', E'', E'no', E'monto_fijo_indefinido', 2, 44, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-30 13:27:32.627', NULL, E'activo', 42, 1, E'MUL_ATRA', E'Multas y Atrasos', E'variable', E'Multas y Atrasos', E'', E'no', E'', 2, 45, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-30 13:32:57.302', NULL, E'activo', 45, 1, E'LIQPAG', E'Liquido Pagable', E'formula', E'Liquido Pagable', E'{COTIZABLE}-{TOT_DESC}', E'no', E'', 2, 48, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, NULL, E'2014-01-30 13:30:30.866', NULL, E'activo', 43, 1, E'OTRO_DESC', E'Otros Descuentos', E'formula', E'Otros Descuentos', E'{RETJUD}+{MUL_ATRA}', E'no', E'', 2, 46, E'ejecutar');

INSERT INTO plani.ttipo_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_columna", "id_tipo_planilla", "codigo", "nombre", "tipo_dato", "descripcion", "formula", "compromete", "tipo_descuento_bono", "decimales_redondeo", "orden", "finiquito")
VALUES (1, 1, E'2014-01-30 13:31:54.152', E'2014-01-30 13:33:51.031', E'activo', 44, 1, E'TOT_DESC', E'Total Descuentos', E'formula', E'Total Descuentos', E'{OTRO_DESC}+{IMPURET}+{AFP_LAB}', E'no', E'', 2, 47, E'ejecutar');

INSERT INTO orga.tuo_funcionario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_uo_funcionario", "id_uo", "id_funcionario", "fecha_asignacion", "fecha_finalizacion","tipo","id_cargo")
VALUES (1, 8, E'2012-11-10 00:00:00', E'2013-02-04 16:59:47', E'activo', 229, 4, 12, E'2009-01-20', E'2013-12-24', E'oficial',1);

INSERT INTO orga.tuo_funcionario ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_uo_funcionario", "id_uo", "id_funcionario", "fecha_asignacion", "fecha_finalizacion","tipo","id_cargo")
VALUES (1, 8, E'2012-11-10 00:00:00', E'2013-02-04 16:59:47', E'activo', 809, 4, 12, E'2013-12-25', NULL, E'oficial',2);

/* Data for the 'param.ttipo_cambio' table  (Records 1 - 2) */

INSERT INTO param.ttipo_cambio ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_cambio", "id_moneda", "fecha", "oficial", "compra", "venta", "observaciones")
VALUES (1, NULL, E'2014-01-30 12:20:14', E'2014-01-30 12:20:14', E'activo', 2, 3, E'2013-11-30', '1.002', '1.002', '1.002', NULL);

INSERT INTO param.ttipo_cambio ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_tipo_cambio", "id_moneda", "fecha", "oficial", "compra", "venta", "observaciones")
VALUES (1, NULL, E'2014-01-30 12:19:54', E'2014-01-30 12:19:54', E'activo', 1, 3, E'2013-12-31', '1.001', '1.001', '1.001', NULL);

/* Data for the 'plani.tdescuento_bono' table  (Records 1 - 1) */

INSERT INTO plani.tdescuento_bono ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_descuento_bono", "id_tipo_columna", "id_funcionario", "id_moneda", "monto_total", "num_cuotas", "valor_por_cuota", "fecha_ini", "fecha_fin")
VALUES (1, NULL, E'2014-01-30 13:21:58.379', NULL, E'activo', 1, 41, 12, 1, NULL, NULL, 1236.55, NULL, NULL);

/* Data for the 'plani.treporte' table  (Records 1 - 1) */

INSERT INTO plani.treporte ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte", "id_tipo_planilla", "hoja_posicion", "titulo_reporte", "agrupar_por", "numerar", "mostrar_nombre", "mostrar_codigo_empleado", "mostrar_doc_id", "mostrar_codigo_cargo", "ordenar_por", "ancho_total", "ancho_utilizado", "control_reporte")
VALUES (1, 1, E'2014-02-10 08:36:59.134', E'2014-02-13 17:12:02.680', E'activo', 2, 1, E'oficio_horizontal', E'Planilla de Sueldos', E'gerencia', E'no', E'si', E'no', E'si', E'si', E'nombre', 300, 225, E'');


/* Data for the 'plani.treporte_columna' table  (Records 1 - 10) */

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, 1, E'2014-02-10 14:35:18.440', E'2014-02-11 14:08:37.605', E'activo', 1, 2, E'HORNORM', E'si', 15, 1, E'Normales', E'Horas');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-11 15:04:44.396', NULL, E'activo', 4, 2, E'BONANT', E'si', 20, 3, E'Antiguedad', E'Bono');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, 1, E'2014-02-11 15:04:24.712', E'2014-02-11 18:44:59.981', E'activo', 3, 2, E'SUELDOBA', E'si', 20, 2, E'Básico', E'Haber');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-11 18:46:56.411', NULL, E'activo', 5, 2, E'BONFRONTERA', E'si', 20, 4, E'Frontera', E'Bono');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-11 18:48:06.965', NULL, E'activo', 6, 2, E'COTIZABLE', E'si', 20, 5, E'Ingresos', E'Total');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-11 18:52:24.702', NULL, E'activo', 7, 2, E'IMPURET', E'si', 20, 6, E' ', E'RC-IVA');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-11 18:53:20.229', NULL, E'activo', 8, 2, E'AFP_LAB', E'si', 20, 7, E' ', E'AFP');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-11 18:54:03.981', NULL, E'activo', 9, 2, E'OTRO_DESC', E'si', 20, 8, E'Descuentos', E'Otros');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-11 18:54:33.170', NULL, E'activo', 10, 2, E'TOT_DESC', E'si', 20, 9, E'Descuentos', E'Total');

INSERT INTO plani.treporte_columna ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_reporte_columna", "id_reporte", "codigo_columna", "sumar_total", "ancho_columna", "orden", "titulo_reporte_inferior", "titulo_reporte_superior")
VALUES (1, NULL, E'2014-02-13 17:12:28.642', NULL, E'activo', 12, 2, E'LIQPAG', E'si', 20, 10, E'Pagable', E'Liquido');

