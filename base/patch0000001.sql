/***********************************I-SCP-JRR-PLANI-0-16/01/2014****************************************/
CREATE TABLE plani.tparametro_valor (
  id_parametro_valor SERIAL,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  fecha_ini DATE NOT NULL,
  fecha_fin DATE,
  CONSTRAINT tparametro_valor_pkey PRIMARY KEY(id_parametro_valor)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.ttipo_planilla (
  id_tipo_planilla SERIAL NOT NULL,
  codigo VARCHAR(10) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  id_proceso_macro INTEGER NOT NULL,
  funcion_obtener_empleados VARCHAR(200) NOT NULL,
  tipo_presu_cc VARCHAR(50) NOT NULL,
  PRIMARY KEY(id_tipo_planilla)
) INHERITS (pxp.tbase)
WITHOUT OIDS;


ALTER TABLE plani.ttipo_planilla
  ADD CONSTRAINT chk__ttipo_planilla__tipo_presu_cc CHECK (((tipo_presu_cc)::text = 'parametrizacion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_periodo'::text));


CREATE TABLE plani.ttipo_columna (
  id_tipo_columna SERIAL NOT NULL,
  id_tipo_planilla INTEGER NOT NULL,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  tipo_dato VARCHAR(30) NOT NULL,
  descripcion TEXT NOT NULL,
  formula VARCHAR(255),
  compromete VARCHAR(15) NOT NULL,
  tipo_descuento_bono VARCHAR(30),
  decimales_redondeo INTEGER NOT NULL,
  orden INTEGER NOT NULL,
  PRIMARY KEY(id_tipo_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT chk__ttipo_columna__compromete CHECK (compromete = 'si_pago' or compromete = 'si_devengado' or compromete = 'si' or compromete = 'no');

ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT chk__ttipo_columna__tipo_dato CHECK (tipo_dato = 'basica' or
tipo_dato = 'formula' or
tipo_dato = 'variable');


ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT chk__ttipo_columna__tipo_descuento_bono CHECK (((((tipo_descuento_bono)::text = 'monto_fijo_indefinido'::text) OR ((tipo_descuento_bono)::text = 'cantidad_cuotas'::text)) OR ((tipo_descuento_bono)::text = 'monto_fijo_por_fechas'::text)) OR (tipo_descuento_bono IS NULL) OR (tipo_descuento_bono = ''));

CREATE TABLE plani.ttipo_obligacion (
  id_tipo_obligacion SERIAL,
  id_tipo_planilla INTEGER NOT NULL,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  tipo_obligacion VARCHAR(30),
  dividir_por_lugar VARCHAR(2),
  CONSTRAINT ttipo_obligacion_pkey PRIMARY KEY(id_tipo_obligacion)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.ttipo_obligacion
  ADD CONSTRAINT chk__ttipo_obligacion__tipo_obligacion CHECK (tipo_obligacion = 'pago_empleados' or
tipo_obligacion = 'pago_afp' or
tipo_obligacion = 'pago_comun' or tipo_obligacion = 'una_obligacion_x_empleado');


CREATE TABLE plani.ttipo_obligacion_columna (
  id_tipo_obligacion_columna SERIAL NOT NULL,
  id_tipo_obligacion INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  pago VARCHAR(2) NOT NULL,
  presupuesto VARCHAR(2) NOT NULL,
  PRIMARY KEY(id_tipo_obligacion_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.ttipo_obligacion_columna
  ADD CONSTRAINT chk__ttipo_obligacion_columna__presupuesto CHECK (presupuesto = 'si' or presupuesto = 'no');

ALTER TABLE plani.ttipo_obligacion_columna
  ADD CONSTRAINT chk__ttipo_obligacion_columna__pago CHECK (pago='si' or pago = 'no');

CREATE TABLE plani.treporte (
  id_reporte SERIAL,
  id_tipo_planilla INTEGER,
  hoja_posicion VARCHAR(100) NOT NULL,
  titulo_reporte VARCHAR(200) NOT NULL,
  agrupar_por VARCHAR(20) NOT NULL,
  numerar VARCHAR(2) NOT NULL,
  mostrar_nombre VARCHAR(2) NOT NULL,
  mostrar_codigo_empleado VARCHAR(2) NOT NULL,
  mostrar_doc_id VARCHAR(2) NOT NULL,
  mostrar_codigo_cargo VARCHAR(2) NOT NULL,
  ordenar_por VARCHAR(25) NOT NULL,
  CONSTRAINT treporte_pkey PRIMARY KEY(id_reporte)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__numerar CHECK (numerar='si' or numerar = 'no');

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__mostrar_nombre CHECK (mostrar_nombre='si' or mostrar_nombre = 'no');

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__mostrar_codigo_empleado CHECK (mostrar_codigo_empleado='si' or mostrar_codigo_empleado = 'no');

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__mostrar_doc_id CHECK (mostrar_doc_id='si' or mostrar_doc_id = 'no');

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__mostrar_codigo_cargo CHECK (mostrar_codigo_cargo='si' or mostrar_codigo_cargo = 'no');

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__hoja_posicion CHECK (((((hoja_posicion)::text = 'carta_vertical'::text) OR ((hoja_posicion)::text = 'carta_horizontal'::text)) OR ((hoja_posicion)::text = 'oficio_vertical'::text)) OR ((hoja_posicion)::text = 'oficio_horizontal'::text));


ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__agrupar_por CHECK (((agrupar_por)::text = 'gerencia'::text) OR ((agrupar_por)::text = 'gerencia_presupuesto'::text));

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__ordenar_por CHECK (ordenar_por = 'nombre' or
ordenar_por = 'doc_id' or
ordenar_por = 'codigo_cargo' or
ordenar_por = 'codigo_empleado');

CREATE TABLE plani.treporte_columna (
  id_reporte_columna SERIAL NOT NULL,
  id_reporte INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  sumar_total VARCHAR(2) NOT NULL,
  ancho_columna INTEGER NOT NULL,
  orden INTEGER NOT NULL,
  PRIMARY KEY(id_reporte_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.treporte_columna
  ADD CONSTRAINT chk__treporte_columna__sumar_total CHECK (sumar_total = 'si' or sumar_total = 'no');

ALTER TABLE plani.tparametro_valor
  ADD COLUMN valor NUMERIC(18,2) NOT NULL;


CREATE UNIQUE INDEX ttipo_planilla_idx ON plani.ttipo_planilla
  USING btree (codigo);

ALTER TABLE plani.treporte
  ADD COLUMN ancho_total INTEGER DEFAULT 0 NOT NULL;

ALTER TABLE plani.treporte
  ADD COLUMN ancho_utilizado INTEGER DEFAULT 0 NOT NULL;

ALTER TABLE plani.ttipo_planilla
  ADD COLUMN funcion_validacion_nuevo_empleado VARCHAR(200) NOT NULL;

ALTER TABLE plani.ttipo_planilla
  ADD COLUMN calculo_horas VARCHAR(2) NOT NULL;

ALTER TABLE plani.ttipo_planilla
  ADD COLUMN periodicidad VARCHAR(8) NOT NULL;

CREATE TABLE plani.tafp (
  id_afp SERIAL,
  nombre VARCHAR(300) NOT NULL,
  codigo VARCHAR NOT NULL,
  CONSTRAINT tafp_pkey PRIMARY KEY(id_afp)
) INHERITS (pxp.tbase) WITHOUT OIDS;

CREATE TABLE plani.tantiguedad (
  id_antiguedad SERIAL,
  valor_min INTEGER NOT NULL,
  valor_max INTEGER NOT NULL,
  porcentaje NUMERIC NOT NULL,
  CONSTRAINT tantiguedad_pkey PRIMARY KEY(id_antiguedad)
) INHERITS (pxp.tbase) WITHOUT OIDS;

CREATE TABLE plani.tfuncionario_afp (
  id_funcionario_afp SERIAL,
  id_funcionario INTEGER NOT NULL,
  id_afp INTEGER NOT NULL,
  nro_afp VARCHAR(100),
  tipo_jubilado VARCHAR NOT NULL,
  fecha_ini DATE NOT NULL,
  fecha_fin DATE,
  CONSTRAINT tfuncionario_afp_pkey PRIMARY KEY(id_funcionario_afp)
)INHERITS (pxp.tbase) WITHOUT OIDS;




CREATE TABLE plani.tdescuento_bono (
  id_descuento_bono SERIAL,
  id_tipo_columna INTEGER NOT NULL,
  id_funcionario INTEGER NOT NULL,
  id_moneda INTEGER NOT NULL,
  monto_total NUMERIC,
  num_cuotas INTEGER,
  valor_por_cuota NUMERIC,
  fecha_ini DATE,
  fecha_fin DATE,
  CONSTRAINT tdescuento_bono_pkey PRIMARY KEY(id_descuento_bono)
)INHERITS (pxp.tbase) WITHOUT OIDS;

ALTER TABLE plani.ttipo_columna
  ADD COLUMN finiquito VARCHAR(25) NOT NULL;


ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT chk__ttipo_columna__finiquito CHECK (((finiquito)::text = 'ejecutar'::text) OR ((finiquito)::text = 'restar_ejecutado'::text));

CREATE TABLE plani.tplanilla (
  id_planilla SERIAL NOT NULL,
  id_gestion INTEGER NOT NULL,
  id_depto INTEGER NOT NULL,
  id_periodo INTEGER,
  nro_planilla VARCHAR(100) NOT NULL,
  id_uo INTEGER,
  id_tipo_planilla INTEGER NOT NULL,
  observaciones TEXT,
  id_proceso_macro INTEGER NOT NULL,
  id_proceso_wf INTEGER,
  id_estado_wf INTEGER,
  estado VARCHAR(50) NOT NULL,
  PRIMARY KEY(id_planilla)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.tfuncionario_planilla (
  id_funcionario_planilla SERIAL NOT NULL,
  id_funcionario INTEGER NOT NULL,
  id_planilla INTEGER NOT NULL,
  id_uo_funcionario INTEGER NOT NULL,
  id_lugar INTEGER NOT NULL,
  forzar_cheque VARCHAR(2) NOT NULL,
  finiquito VARCHAR(2) NOT NULL,
  PRIMARY KEY(id_funcionario_planilla)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.thoras_trabajadas (
  id_horas_trabajadas SERIAL NOT NULL,
  id_uo_funcionario INTEGER NOT NULL,
  id_funcionario_planilla INTEGER NOT NULL,
  horas_normales NUMERIC(10,2) DEFAULT 0 NOT NULL,
  horas_extras NUMERIC(10,2) DEFAULT 0 NOT NULL,
  horas_nocturnas NUMERIC(10,2) DEFAULT 0 NOT NULL,
  horas_disponibilidad NUMERIC(10,2) DEFAULT 0 NOT NULL,
  tipo_contrato VARCHAR(10) NOT NULL,
  sueldo NUMERIC(18,2) NOT NULL,
  fecha_ini DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  porcentaje_sueldo NUMERIC(18,2),
  PRIMARY KEY(id_horas_trabajadas)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.tfuncionario_planilla
  ADD CONSTRAINT chk__tfuncionario_planilla__finiquito
  CHECK (finiquito = 'si' or finiquito = 'no');

ALTER TABLE plani.tfuncionario_planilla
  ADD CONSTRAINT chk__tfuncionario_planilla__forzar_cheque
  CHECK (forzar_cheque = 'si' or forzar_cheque = 'no');

CREATE TABLE plani.tcolumna_valor (
  id_columna_valor SERIAL NOT NULL,
  id_tipo_columna INTEGER NOT NULL,
  id_funcionario_planilla INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  formula VARCHAR(255),
  valor NUMERIC(18,2) NOT NULL,
  valor_generado NUMERIC(18,2) NOT NULL,
  PRIMARY KEY(id_columna_valor)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.thoras_trabajadas
  ADD COLUMN zona_franca VARCHAR(2);

ALTER TABLE plani.thoras_trabajadas
  ADD COLUMN frontera VARCHAR(2);

/***********************************F-SCP-JRR-PLANI-0-16/01/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-10/02/2014****************************************/

ALTER TABLE plani.treporte
  ADD COLUMN control_reporte VARCHAR(200);

ALTER TABLE plani.treporte_columna
  ADD COLUMN titulo_reporte_superior VARCHAR(30);

ALTER TABLE plani.treporte_columna
  ADD COLUMN titulo_reporte_inferior VARCHAR(30);

/***********************************F-SCP-JRR-PLANI-0-10/02/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-23/02/2014****************************************/

CREATE TABLE plani.tprorrateo (
  id_prorrateo SERIAL NOT NULL,
  id_funcionario_planilla INTEGER,
  id_horas_trabajadas INTEGER,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  tipo_prorrateo VARCHAR(15) NOT NULL,
  porcentaje NUMERIC(5,2) NOT NULL,
  PRIMARY KEY(id_prorrateo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.tprorrateo_columna (
  id_prorrateo_columna SERIAL NOT NULL,
  id_prorrateo INTEGER NOT NULL,
  id_tipo_columna INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  porcentaje NUMERIC(5,2) NOT NULL,
  PRIMARY KEY(id_prorrateo_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.tconsolidado (
  id_consolidado SERIAL NOT NULL,
  id_planilla INTEGER NOT NULL,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  tipo_consolidado VARCHAR(15) NOT NULL,
  PRIMARY KEY(id_consolidado)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.tconsolidado_columna (
  id_consolidado_columna SERIAL NOT NULL,
  id_consolidado INTEGER NOT NULL,
  id_tipo_columna INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  valor NUMERIC(18,2) NOT NULL,
  valor_ejecutado NUMERIC(18,2) DEFAULT 0,
  id_partida INTEGER,
  id_cuenta INTEGER,
  id_auxiliar INTEGER,
  tipo_contrato VARCHAR(20) NOT NULL,
  PRIMARY KEY(id_consolidado_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-PLANI-0-23/02/2014****************************************/
/***********************************I-SCP-JRR-PLANI-0-17/06/2014****************************************/


ALTER TABLE plani.tcolumna_valor
  ALTER COLUMN valor TYPE NUMERIC(18,10);

ALTER TABLE plani.tcolumna_valor
  ALTER COLUMN valor_generado TYPE NUMERIC(18,10);

/***********************************F-SCP-JRR-PLANI-0-17/06/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-08/07/2014****************************************/
ALTER TABLE plani.ttipo_columna
  ALTER COLUMN formula TYPE VARCHAR(500);

/***********************************F-SCP-JRR-PLANI-0-08/07/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-09/07/2014****************************************/
ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN es_pagable VARCHAR(2) DEFAULT 'si' NOT NULL;

ALTER TABLE plani.ttipo_obligacion_columna
  ADD COLUMN es_ultimo VARCHAR(2) DEFAULT 'no' NOT NULL;

ALTER TABLE plani.tprorrateo_columna
  ADD COLUMN compromete VARCHAR(2) DEFAULT 'si' NOT NULL;

ALTER TABLE plani.ttipo_columna
  DROP CONSTRAINT chk__ttipo_columna__compromete RESTRICT;

ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT chk__ttipo_columna__compromete CHECK (((((compromete)::text = 'si_pago'::text) OR ((compromete)::text = 'si_contable'::text)) OR ((compromete)::text = 'si'::text)) OR ((compromete)::text = 'no'::text));

ALTER TABLE plani.tfuncionario_planilla
  ADD COLUMN id_afp INTEGER;

ALTER TABLE plani.tfuncionario_planilla
  ADD COLUMN id_cuenta_bancaria INTEGER;

/***********************************F-SCP-JRR-PLANI-0-09/07/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-11/07/2014****************************************/
CREATE TABLE plani.tobligacion (
  id_obligacion SERIAL NOT NULL,
  id_tipo_obligacion INTEGER NOT NULL,
  id_planilla INTEGER NOT NULL,
  id_cuenta INTEGER,
  id_auxiliar INTEGER,
  tipo_pago VARCHAR(50) NOT NULL,
  acreedor VARCHAR(255) NOT NULL,
  descripcion varchar(500),
  monto_obligacion NUMERIC (18,2) NOT NULL,
  PRIMARY KEY(id_obligacion)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.tobligacion_columna (
  id_obligacion_columna SERIAL NOT NULL,
  id_obligacion INTEGER NOT NULL,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  id_tipo_columna INTEGER,
  codigo_columna VARCHAR(50) NOT NULL,
  tipo_contrato VARCHAR(5) NOT NULL,
  monto_detalle_obligacion NUMERIC (18,2) NOT NULL,
  PRIMARY KEY (id_obligacion_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.tdetalle_transferencia (
  id_detalle_transferencia SERIAL NOT NULL,
  id_obligacion INTEGER NOT NULL,
  id_institucion INTEGER NOT NULL,
  nro_cuenta VARCHAR(50) NOT NULL,
  id_funcionario INTEGER NOT NULL,
  monto_transferencia NUMERIC(18,2) NOT NULL,
  PRIMARY KEY (id_detalle_transferencia)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-PLANI-0-11/07/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-17/11/2014****************************************/

ALTER TABLE plani.tplanilla
  ADD COLUMN id_obligacion_pago INTEGER;

ALTER TABLE plani.tconsolidado_columna
  ADD COLUMN id_obligacion_det INTEGER;

ALTER TABLE plani.tobligacion
  ADD COLUMN id_plan_pago INTEGER;


/***********************************F-SCP-JRR-PLANI-0-17/11/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-20/11/2014****************************************/

ALTER TABLE plani.tplanilla
  ADD COLUMN requiere_calculo VARCHAR(2) DEFAULT 'no' NOT NULL;

ALTER TABLE plani.tobligacion
  ADD COLUMN id_partida INTEGER;

ALTER TABLE plani.tobligacion
  ADD COLUMN id_afp INTEGER;

/***********************************F-SCP-JRR-PLANI-0-20/11/2014****************************************/

/***********************************I-SCP-JRR-PLANI-0-02/12/2014****************************************/

ALTER TABLE plani.tobligacion
  ADD COLUMN id_obligacion_pago INTEGER;


/***********************************F-SCP-JRR-PLANI-0-02/12/2014****************************************/
/***********************************I-SCP-JRR-PLANI-0-04/12/2014****************************************/


ALTER TABLE plani.tplanilla
  ADD COLUMN fecha_planilla DATE;

ALTER TABLE plani.ttipo_columna
  ADD COLUMN tiene_detalle VARCHAR(2) DEFAULT 'no' NOT NULL;

CREATE TABLE plani.tcolumna_detalle (
  id_columna_detalle SERIAL NOT NULL,
  id_horas_trabajadas INTEGER NOT NULL,
  id_columna_valor INTEGER NOT NULL,
  valor NUMERIC(18,10) NOT NULL,
  valor_generado NUMERIC(18,10) NOT NULL,
  PRIMARY KEY (id_columna_detalle)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE INDEX tcolumna_detalle_idx1 ON plani.tcolumna_detalle
  USING btree (id_horas_trabajadas);

CREATE INDEX tcolumna_detalle_idx2 ON plani.tcolumna_detalle
  USING btree (id_columna_valor);

ALTER TABLE plani.tfuncionario_planilla
  ADD COLUMN tipo_contrato VARCHAR;

ALTER TABLE plani.thoras_trabajadas
  ADD COLUMN horas_normales_contrato NUMERIC(10,2);


/***********************************F-SCP-JRR-PLANI-0-04/12/2014****************************************/


/***********************************I-SCP-JRR-PLANI-0-10/07/2015****************************************/
ALTER TABLE plani.ttipo_planilla
  DROP CONSTRAINT chk__ttipo_planilla__tipo_presu_cc RESTRICT;

ALTER TABLE plani.ttipo_planilla
  ADD CONSTRAINT chk__ttipo_planilla__tipo_presu_cc CHECK (tipo_presu_cc = 'parametrizacion' OR tipo_presu_cc = 'ultimo_activo_periodo' OR tipo_presu_cc = 'prorrateo_aguinaldo' OR tipo_presu_cc = 'retroactivo_sueldo' OR tipo_presu_cc = 'retroactivo_asignaciones');

ALTER TABLE plani.tprorrateo
  ADD COLUMN tipo_contrato VARCHAR(10);

/***********************************F-SCP-JRR-PLANI-0-10/07/2015****************************************/


/***********************************I-SCP-JRR-PLANI-0-20/07/2015****************************************/

ALTER TABLE plani.tprorrateo
  ADD COLUMN porcentaje_dias NUMERIC(5,2);

/***********************************F-SCP-JRR-PLANI-0-20/07/2015****************************************/

/***********************************I-SCP-JRR-PLANI-0-29/07/2015****************************************/

ALTER TABLE plani.tprorrateo
  ADD COLUMN id_oficina INTEGER;

ALTER TABLE plani.tprorrateo
  ADD COLUMN id_lugar INTEGER;

ALTER TABLE plani.tprorrateo_columna
  ADD COLUMN id_oficina INTEGER;

ALTER TABLE plani.tprorrateo_columna
  ADD COLUMN id_lugar INTEGER;

/***********************************F-SCP-JRR-PLANI-0-29/07/2015****************************************/

/***********************************I-SCP-JRR-PLANI-0-29/08/2015****************************************/
 -- object recreation
ALTER TABLE plani.ttipo_planilla
  DROP CONSTRAINT chk__ttipo_planilla__tipo_presu_cc RESTRICT;

ALTER TABLE plani.ttipo_planilla
  ADD CONSTRAINT chk__ttipo_planilla__tipo_presu_cc CHECK (((((((tipo_presu_cc)::text = 'parametrizacion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_periodo'::text)) OR ((tipo_presu_cc)::text = 'prorrateo_aguinaldo'::text)) OR ((tipo_presu_cc)::text = 'retroactivo_sueldo'::text)) OR ((tipo_presu_cc)::text = 'retroactivo_asignaciones'::text)) OR ((tipo_presu_cc)::text = 'ultimo_activo_gestion'::text));

/***********************************F-SCP-JRR-PLANI-0-29/08/2015****************************************/


/***********************************I-SCP-JRR-PLANI-0-22/09/2015****************************************/

CREATE TABLE plani.tplanilla_sigma (
  id_planilla_sigma SERIAL NOT NULL,
  id_funcionario INTEGER NOT NULL,
  id_periodo INTEGER,
  id_gestion INTEGER NOT NULL,
  id_tipo_planilla INTEGER NOT NULL,
  sueldo_liquido numeric NOT NULL,
  PRIMARY KEY(id_planilla_sigma)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE TABLE plani.tsigma_equivalencias (
  ci_sigma VARCHAR NOT NULL,
  ci_erp VARCHAR NOT NULL
)
WITHOUT OIDS;

/***********************************F-SCP-JRR-PLANI-0-22/09/2015****************************************/

/***********************************I-SCP-JRR-PLANI-0-29/10/2015****************************************/
CREATE TABLE plani.tlicencia (
  id_licencia SERIAL NOT NULL,
  id_funcionario INTEGER NOT NULL,
  motivo TEXT NOT NULL,
  desde DATE NOT NULL,
  hasta DATE NOT NULL,
  estado VARCHAR NOT NULL,
  id_tipo_licencia INTEGER NOT NULL,
  PRIMARY KEY(id_licencia)
) INHERITS (pxp.tbase)
WITHOUT OIDS;


CREATE TABLE plani.ttipo_licencia (
  id_tipo_licencia SERIAL NOT NULL,
  codigo VARCHAR(20) NOT NULL,
  nombre VARCHAR (100) NOT NULL,
  genera_descuento VARCHAR(2) NOT NULL,
  PRIMARY KEY(id_tipo_licencia)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-PLANI-0-29/10/2015****************************************/

/***********************************I-SCP-JRR-PLANI-0-31/12/2015****************************************/

ALTER TABLE plani.ttipo_planilla
  DROP CONSTRAINT chk__ttipo_planilla__tipo_presu_cc RESTRICT;

ALTER TABLE plani.ttipo_planilla
  ADD CONSTRAINT chk__ttipo_planilla__tipo_presu_cc CHECK (((((((tipo_presu_cc)::text = 'parametrizacion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_periodo'::text)) OR ((tipo_presu_cc)::text = 'prorrateo_aguinaldo'::text)) OR ((tipo_presu_cc)::text = 'retroactivo_sueldo'::text)) OR ((tipo_presu_cc)::text = 'retroactivo_asignaciones'::text)) OR ((tipo_presu_cc)::text = 'ultimo_activo_gestion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_gestion_anterior'::text));


/***********************************F-SCP-JRR-PLANI-0-31/12/2015****************************************/

/***********************************I-SCP-JRR-PLANI-0-28/02/2016****************************************/

ALTER TABLE plani.treporte
  ADD COLUMN tipo_reporte VARCHAR(200) DEFAULT 'planilla' NOT NULL;

ALTER TABLE plani.treporte_columna
  ADD COLUMN tipo_columna VARCHAR(200) DEFAULT 'otro';

ALTER TABLE plani.treporte_columna
  ADD CONSTRAINT chk__treporte_columna__tipo_columna CHECK (tipo_columna::text = 'ingreso'::text OR tipo_columna::text = 'descuento_ley'::text OR tipo_columna::text = 'otros_descuentos'::text OR tipo_columna::text = 'iva'::text OR tipo_columna::text = 'otro'::text);

/***********************************F-SCP-JRR-PLANI-0-28/02/2016****************************************/


/***********************************I-SCP-JRR-PLANI-0-10/04/2016****************************************/

ALTER TABLE plani.ttipo_planilla
  ADD COLUMN funcion_calculo_horas VARCHAR(200);

/***********************************F-SCP-JRR-PLANI-0-10/04/2016****************************************/

/***********************************I-SCP-JRR-PLANI-0-13/04/2016****************************************/

ALTER TABLE plani.ttipo_planilla
  ADD COLUMN recalcular_desde INTEGER;

ALTER TABLE plani.ttipo_columna
  ADD COLUMN recalcular varchar(2) DEFAULT 'no' NOT NULL;

/***********************************F-SCP-JRR-PLANI-0-13/04/2016****************************************/

/***********************************I-SCP-JRR-PLANI-0-25/04/2016****************************************/

ALTER TABLE plani.tplanilla
  ADD COLUMN id_int_comprobante INTEGER;

ALTER TABLE plani.tconsolidado_columna
  ADD COLUMN id_int_transaccion INTEGER;

/***********************************F-SCP-JRR-PLANI-0-25/04/2016****************************************/

/***********************************I-SCP-JRR-PLANI-0-26/04/2016****************************************/
ALTER TABLE plani.tprorrateo_columna ALTER COLUMN compromete TYPE varchar(20);

/***********************************F-SCP-JRR-PLANI-0-26/04/2016****************************************/

/***********************************I-SCP-JRR-PLANI-0-04/05/2016****************************************/
ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT tprorrateo_chk__id_presupuesto_id_cc CHECK (id_presupuesto is not null or id_cc is not null);
/***********************************F-SCP-JRR-PLANI-0-04/05/2016****************************************/

/***********************************I-SCP-JRR-PLANI-0-10/03/2017****************************************/
ALTER TABLE plani.tobligacion
  ADD COLUMN id_int_comprobante INTEGER;

/***********************************F-SCP-JRR-PLANI-0-04/03/2017****************************************/

/***********************************I-SCP-FEA-PLANI-0-07/11/2018****************************************/
ALTER TABLE plani.tplanilla
  ADD COLUMN codigo_poa VARCHAR(25),
  ADD COLUMN obs_poa TEXT;
/***********************************F-SCP-FEA-PLANI-0-07/11/2018****************************************/
/***********************************I-SCP-EGS-PLANI-0-05/02/2019****************************************/

ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN id_tipo_obligacion_agrupador INTEGER;

CREATE TABLE plani.ttipo_obligacion_agrupador (
  id_tipo_obligacion_agrupador SERIAL,
  codigo_plantilla_comprobante VARCHAR,
  codigo VARCHAR,
  nombre VARCHAR,
  CONSTRAINT ttipo_obligacion_agrupador_pkey PRIMARY KEY(id_tipo_obligacion_agrupador),
  CONSTRAINT ttipo_obligacion_agrupador_fk FOREIGN KEY (codigo_plantilla_comprobante)
    REFERENCES conta.tplantilla_comprobante(codigo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN plani.ttipo_obligacion_agrupador.codigo_plantilla_comprobante
IS 'Codigo de la plantilla del comprobante';

--------------- SQL ---------------

CREATE TABLE plani.tobligacion_agrupador (
  id_ogligacion_agrupador SERIAL,
  id_tipo_obligacion_agrupador INTEGER,
  id_planilla INTEGER,
  monto_agrupador NUMERIC DEFAULT 0 NOT NULL,
  acreedor VARCHAR,
  descripcion VARCHAR,
  PRIMARY KEY(id_ogligacion_agrupador)
) INHERITS (pxp.tbase)
WITH (oids = false);

--------------- SQL ---------------

ALTER TABLE plani.ttipo_obligacion_agrupador
  ADD COLUMN descripcion VARCHAR;


  --------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD CONSTRAINT tobligacion_agrupador__id_planilla FOREIGN KEY (id_planilla)
    REFERENCES plani.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


 --------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD CONSTRAINT tobligacion_agrupador__it_tipo_ob_agr FOREIGN KEY (id_tipo_obligacion_agrupador)
    REFERENCES plani.ttipo_obligacion_agrupador(id_tipo_obligacion_agrupador)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

    --------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD COLUMN id_obligacion_agrupador INTEGER;


--------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD CONSTRAINT tobligacion__id_ogligacion_agrupador_fk FOREIGN KEY (id_obligacion_agrupador)
    REFERENCES plani.tobligacion_agrupador(id_ogligacion_agrupador)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

 --------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD COLUMN tipo_pago VARCHAR(50);

--------------- SQL ---------------

ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN descripcion VARCHAR;

  --------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD COLUMN id_int_comprobante INTEGER;

  --------------- SQL ---------------

--------------- SQL ---------------

ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN cotigo_tipo_relacion_debe VARCHAR DEFAULT 'CUEOBLI' NOT NULL;

COMMENT ON COLUMN plani.ttipo_obligacion.cotigo_tipo_relacion_debe
IS 'tipo de relacion contable apra genrar cbte de obligaciones con moviemiento al debe';


ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN cotigo_tipo_relacion_haber VARCHAR DEFAULT 'CUEOBLI' NOT NULL;

COMMENT ON COLUMN plani.ttipo_obligacion.cotigo_tipo_relacion_haber
IS 'tipo de relacion contable apra genrar cbte de obligaciones con moviemiento al haber';


--------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD COLUMN id_funcionario INTEGER;

COMMENT ON COLUMN plani.tobligacion.id_funcionario
IS 'para identificar obligaciones por funcionario';


--------------- SQL ---------------

COMMENT ON COLUMN plani.tobligacion.id_cuenta
IS 'cuenta para el debe';


--------------- SQL ---------------

COMMENT ON COLUMN plani.tobligacion.id_auxiliar
IS 'auxiliar para el debe';


--------------- SQL ---------------

COMMENT ON COLUMN plani.tobligacion.id_planilla
IS 'partida para el debe';

--------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD COLUMN id_cuenta_haber INTEGER;

COMMENT ON COLUMN plani.tobligacion.id_cuenta_haber
IS 'cuenta pra el haber';


--------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD COLUMN id_partida_haber INTEGER;

COMMENT ON COLUMN plani.tobligacion.id_partida_haber
IS 'partida para el haber';


--------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD COLUMN id_auxiliar_haber INTEGER;

COMMENT ON COLUMN plani.tobligacion.id_auxiliar_haber
IS 'auxiliar para el haber';
--------------- SQL ---------------
ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN codigo_tipo_relacion_debe VARCHAR DEFAULT 'CUEOBLI'::character varying NOT NULL;

COMMENT ON COLUMN plani.ttipo_obligacion.codigo_tipo_relacion_debe
IS 'tipo de relacion contable apra genrar cbte de obligaciones con moviemiento al debe';

ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN codigo_tipo_relacion_haber VARCHAR DEFAULT 'CUEOBLI'::character varying NOT NULL;

COMMENT ON COLUMN plani.ttipo_obligacion.codigo_tipo_relacion_haber
IS 'tipo de relacion contable apra genrar cbte de obligaciones con moviemiento al haber';

--------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD CONSTRAINT tobligacion__id_funcionario_fk FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


--------------- SQL ---------------

 -- object recreation
ALTER TABLE plani.ttipo_planilla
  DROP CONSTRAINT chk__ttipo_planilla__tipo_presu_cc RESTRICT;

ALTER TABLE plani.ttipo_planilla
  ADD CONSTRAINT chk__ttipo_planilla__tipo_presu_cc CHECK (((tipo_presu_cc)::text = 'parametrizacion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_periodo'::text) OR ((tipo_presu_cc)::text = 'prorrateo_aguinaldo'::text) OR ((tipo_presu_cc)::text = 'retroactivo_sueldo'::text) OR ((tipo_presu_cc)::text = 'retroactivo_asignaciones'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_gestion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_gestion_anterior'::text)  OR ((tipo_presu_cc)::text = 'hoja_calculo'::text) );


 --------------- SQL ---------------

ALTER TABLE plani.tprorrateo
  ADD COLUMN tipo_horario VARCHAR(15) DEFAULT 'normal' NOT NULL;

COMMENT ON COLUMN plani.tprorrateo.tipo_horario
IS 'normal,  extra o  nocturno,  tipo de horario prorrateado';

--------------- SQL ---------------

ALTER TABLE plani.tprorrateo
  ADD COLUMN calculado_resta VARCHAR DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN plani.tprorrateo.calculado_resta
IS 'indica se se calculo por resta';


/***********************************F-SCP-EGS-PLANI-0-05/02/2019****************************************/
/***********************************I-SCP-EGS-PLANI-1-07/03/2019****************************************/
ALTER TABLE plani.tlicencia
  ADD COLUMN id_estado_wf INTEGER;
ALTER TABLE plani.tlicencia
  ADD COLUMN id_proceso_wf INTEGER;
ALTER TABLE plani.tlicencia
  ADD COLUMN nro_tramite VARCHAR;
/***********************************F-SCP-EGS-PLANI-1-07/03/2019****************************************/

/***********************************I-SCP-CAP-PLANI-1-08/04/2019****************************************/

ALTER TABLE plani.tconsolidado_columna
  ALTER COLUMN valor TYPE NUMERIC;

ALTER TABLE plani.tconsolidado_columna
  ALTER COLUMN valor_ejecutado TYPE NUMERIC;

ALTER TABLE plani.tobligacion_agrupador
  RENAME COLUMN id_ogligacion_agrupador TO id_obligacion_agrupador;

ALTER TABLE plani.tobligacion_columna
  ALTER COLUMN monto_detalle_obligacion TYPE NUMERIC;

ALTER TABLE plani.tprorrateo
  ALTER COLUMN porcentaje TYPE NUMERIC;

ALTER TABLE plani.tprorrateo
  ALTER COLUMN porcentaje_dias TYPE NUMERIC;

ALTER TABLE plani.tprorrateo_columna
  ALTER COLUMN porcentaje TYPE NUMERIC;

ALTER TABLE plani.ttipo_obligacion
  DROP COLUMN cotigo_tipo_relacion_haber;

ALTER TABLE plani.ttipo_obligacion
  DROP COLUMN cotigo_tipo_relacion_debe;

ALTER TABLE plani.ttipo_obligacion
  ADD CONSTRAINT ttipo_obligacion__id_ob_agrp_fk FOREIGN KEY (id_tipo_obligacion_agrupador)
    REFERENCES plani.ttipo_obligacion(id_tipo_obligacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.ttipo_obligacion_columna
  ALTER COLUMN pago TYPE VARCHAR COLLATE pg_catalog."default";




/***********************************F-SCP-CAP-PLANI-1-08/04/2019****************************************/


/***********************************I-SCP-MMV-PLANI-5-30/04/2019****************************************/
ALTER TABLE plani.tplanilla
  ADD COLUMN dividir_comprobante VARCHAR(5);

ALTER TABLE plani.tplanilla
  ALTER COLUMN dividir_comprobante SET DEFAULT 'no';

ALTER TABLE plani.tplanilla
  ADD COLUMN id_tipo_contrato INTEGER;
/***********************************F-SCP-MMV-PLANI-5-30/04/2019****************************************/


/***********************************I-SCP-RAC-PLANI-2-15/05/2019****************************************/

--------------- SQL ---------------

CREATE TABLE plani.tfiltro_cbte (
  id_filtro_cbte SERIAL NOT NULL,
  id_tipo_presupuesto INTEGER NOT NULL,
  obs TEXT,
  PRIMARY KEY(id_filtro_cbte)
) INHERITS (pxp.tbase)
WITH (oids = false);

COMMENT ON COLUMN plani.tfiltro_cbte.id_tipo_presupuesto
IS 'identifica los presupeusto que entran al abte de diario presupeustario para planillas, los que noesten presente iran al  cbte de diraio contable';


--------------- SQL ---------------

ALTER TABLE plani.tplanilla
  ADD COLUMN id_int_comprobante_2 INTEGER;

COMMENT ON COLUMN plani.tplanilla.id_int_comprobante_2
IS 'se añadir por en algunos casos es necesario dividir la pnailal en dos cbte, un o presupeustario y otro solo contable,.....se divide segun tipo de presupuesto configurado en la tabla plani.tfiltro_cbte';


--------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD COLUMN obs_cbte VARCHAR;

COMMENT ON COLUMN plani.tobligacion.obs_cbte
IS 'pra describir si el c bte fue eliminado,...el FK se pierde';


--------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD COLUMN obs_cbte VARCHAR;

COMMENT ON COLUMN plani.tobligacion_agrupador.obs_cbte
IS 'pra describir si el c bte fue eliminado,...el FK se pierde';
/***********************************F-SCP-RAC-PLANI-2-15/05/2019****************************************/


/***********************************I-SCP-RAC-PLANI-10-30/05/2019****************************************/

--------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD COLUMN id_afp INTEGER;

COMMENT ON COLUMN plani.tobligacion_agrupador.id_afp
IS 'identifica los agrupadores por AFP';

--------------- SQL ---------------

ALTER TABLE plani.ttipo_columna
  ADD COLUMN editable VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN plani.ttipo_columna.editable
IS 'la columnas es editable manualmente, si o no';
/***********************************F-SCP-RAC-PLANI-10-30/05/2019****************************************/

/***********************************I-SCP-MZM-PLANI-8-31/05/2019****************************************/
ALTER TABLE plani.treporte
  ADD COLUMN multilinea VARCHAR(2);

ALTER TABLE plani.treporte
  ALTER COLUMN multilinea SET DEFAULT 'no';

ALTER TABLE plani.treporte
  ADD COLUMN vista_datos_externos VARCHAR(100);

ALTER TABLE plani.treporte
  ADD COLUMN num_columna_multilinea INTEGER;


ALTER TABLE plani.treporte_columna
  ADD COLUMN columna_vista VARCHAR(100);

ALTER TABLE plani.treporte_columna
  ADD COLUMN origen VARCHAR(30);

ALTER TABLE plani.treporte_columna
  ADD COLUMN espacio_previo INTEGER;
/***********************************F-SCP-MZM-PLANI-8-31/05/2019****************************************/


/***********************************I-SCP-RAC-PLANI-25-07/08/2019****************************************/

--------------- SQL ---------------

ALTER TABLE plani.tplanilla
  ADD COLUMN calcular_reintegro_rciva VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN plani.tplanilla.calcular_reintegro_rciva
IS 'si o no, incluye columnas marcacados como reintegro_rciva,  si no es no el valor por defecto es cero';



/***********************************F-SCP-RAC-PLANI-25-07/08/2019****************************************/



/***********************************I-SCP-MZM-PLANI-32-02/09/2019****************************************/
ALTER TABLE plani.treporte
  ADD COLUMN id_pie_firma INTEGER;

ALTER TABLE plani.treporte
  ADD CONSTRAINT fk_treporte__id_pie_firma FOREIGN KEY (id_pie_firma)
    REFERENCES param.tpie_firma(id_pie_firma)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-SCP-MZM-PLANI-32-02/09/2019****************************************/
/***********************************I-SCP-MZM-PLANI-58-30/09/2019****************************************/

ALTER TABLE plani.ttipo_obligacion
  ADD COLUMN tipo_abono VARCHAR(2);

ALTER TABLE plani.treporte
  ADD COLUMN mostrar_ufv VARCHAR(2);

ALTER TABLE plani.treporte
  ALTER COLUMN mostrar_ufv SET DEFAULT 'no';
 /***********************************F-SCP-MZM-PLANI-58-30/09/2019****************************************/


/***********************************I-SCP-MZM-PLANI-60-01/10/2019****************************************/
ALTER TABLE plani.treporte
  ADD COLUMN incluir_retirados VARCHAR(2);

ALTER TABLE plani.treporte
  ALTER COLUMN incluir_retirados SET DEFAULT 'no';
/***********************************F-SCP-MZM-PLANI-60-01/10/2019****************************************/

/***********************************I-SCP-MZM-PLANI-65-10/10/2019****************************************/
ALTER TABLE plani.treporte
  ADD COLUMN id_moneda_reporte INTEGER;
/***********************************F-SCP-MZM-PLANI-65-10/10/2019****************************************/


/***********************************I-SCP-RAC-PLANI-68-24/10/2019****************************************/

--------------- SQL ---------------

ALTER TABLE plani.tplanilla
  ADD COLUMN calcular_prima_rciva VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN plani.tplanilla.calcular_prima_rciva
IS 'si o no, incluye columnas marcadas para arrastrar el rc-iva de la planilal de prima de personal vigente';

/***********************************F-SCP-RAC-PLANI-68-24/10/2019****************************************/


/***********************************I-SCP-RAC-PLANI-78-14/11/2019****************************************/
CREATE SCHEMA planibk;

CREATE TABLE planibk.tplanilla (
  id_planilla SERIAL,
  id_planilla_original INTEGER,
  fecha_backup date default now()::DATE NOT NULL,
  id_gestion INTEGER NOT NULL,
  id_depto INTEGER NOT NULL,
  id_periodo INTEGER,
  nro_planilla VARCHAR(100) NOT NULL,
  id_uo INTEGER,
  id_tipo_planilla INTEGER NOT NULL,
  observaciones TEXT,
  id_proceso_macro INTEGER NOT NULL,
  id_proceso_wf INTEGER,
  id_estado_wf INTEGER,
  estado VARCHAR(50) NOT NULL,
  id_obligacion_pago INTEGER,
  requiere_calculo VARCHAR(2) DEFAULT 'no'::character varying NOT NULL,
  fecha_planilla DATE,
  id_int_comprobante INTEGER,
  codigo_poa VARCHAR(25),
  obs_poa TEXT,
  dividir_comprobante VARCHAR(5) DEFAULT 'no'::character varying,
  id_tipo_contrato INTEGER,
  id_int_comprobante_2 INTEGER,
  calcular_reintegro_rciva VARCHAR(2) DEFAULT 'no'::character varying NOT NULL,
  calcular_prima_rciva VARCHAR(2) DEFAULT 'no'::character varying NOT NULL,
  CONSTRAINT tplanilla_pkey PRIMARY KEY(id_planilla),
  CONSTRAINT fk__tplanilla__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tplanilla__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tplanilla__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tplanilla__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tplanilla__id_proceso_macro FOREIGN KEY (id_proceso_macro)
    REFERENCES wf.tproceso_macro(id_proceso_macro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tplanilla__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tplanilla__id_tipo_planilla FOREIGN KEY (id_tipo_planilla)
    REFERENCES plani.ttipo_planilla(id_tipo_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tplanilla__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tplanilla__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN planibk.tplanilla.id_planilla_original
IS 'id_planilla_original hace referencia a a planilla original de la que se hace copia en equema plani';



CREATE TABLE planibk.tfuncionario_planilla (
  id_funcionario_planilla SERIAL,
  id_funcionario INTEGER NOT NULL,
  id_planilla INTEGER NOT NULL,
  id_uo_funcionario INTEGER NOT NULL,
  id_lugar INTEGER NOT NULL,
  forzar_cheque VARCHAR(2) NOT NULL,
  finiquito VARCHAR(2) NOT NULL,
  id_afp INTEGER,
  id_cuenta_bancaria INTEGER,
  tipo_contrato VARCHAR,
  CONSTRAINT tfuncionario_planilla_pkey PRIMARY KEY(id_funcionario_planilla),
  CONSTRAINT uk_tfuncionario_planilla__id_funcionario__id_planilla UNIQUE(id_planilla, id_funcionario),
  CONSTRAINT chk__tfuncionario_planilla__finiquito CHECK (((finiquito)::text = 'si'::text) OR ((finiquito)::text = 'no'::text)),
  CONSTRAINT chk__tfuncionario_planilla__forzar_cheque CHECK (((forzar_cheque)::text = 'si'::text) OR ((forzar_cheque)::text = 'no'::text)),
  CONSTRAINT fk__tfuncionario_planilla__id_afp FOREIGN KEY (id_afp)
    REFERENCES plani.tfuncionario_afp(id_funcionario_afp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tfuncionario_planilla__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tfuncionario_planilla__id_lugar FOREIGN KEY (id_lugar)
    REFERENCES param.tlugar(id_lugar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tfuncionario_planilla__id_planilla FOREIGN KEY (id_planilla)
    REFERENCES planibk.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tfuncionario_planilla__id_uo_funcionario FOREIGN KEY (id_uo_funcionario)
    REFERENCES orga.tuo_funcionario(id_uo_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tfuncionario_planilla__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES orga.tfuncionario_cuenta_bancaria(id_funcionario_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);



CREATE TABLE planibk.tcolumna_valor (
  id_columna_valor SERIAL,
  id_tipo_columna INTEGER NOT NULL,
  id_funcionario_planilla INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  formula VARCHAR(255),
  valor NUMERIC(18,10) NOT NULL,
  valor_generado NUMERIC(18,10) NOT NULL,
  CONSTRAINT tcolumna_valor_pkey PRIMARY KEY(id_columna_valor),
  CONSTRAINT fk_tcolumna_valor__id_funcionario_planilla FOREIGN KEY (id_funcionario_planilla)
    REFERENCES planibk.tfuncionario_planilla(id_funcionario_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tcolumna_valor__id_tipo_columna FOREIGN KEY (id_tipo_columna)
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);


CREATE TABLE planibk.tobligacion_agrupador (
  id_obligacion_agrupador SERIAL,
  id_tipo_obligacion_agrupador INTEGER,
  id_planilla INTEGER,
  monto_agrupador NUMERIC DEFAULT 0 NOT NULL,
  acreedor VARCHAR,
  descripcion VARCHAR,
  tipo_pago VARCHAR(50),
  id_int_comprobante INTEGER,
  obs_cbte VARCHAR,
  id_afp INTEGER,
  CONSTRAINT tobligacion_agrupador_pkey PRIMARY KEY(id_obligacion_agrupador),
  CONSTRAINT tobligacion_agrupador__id_afp_fk FOREIGN KEY (id_afp)
    REFERENCES plani.tafp(id_afp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tobligacion_agrupador__id_int_comprobante_fk FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tobligacion_agrupador__id_planilla FOREIGN KEY (id_planilla)
    REFERENCES planibk.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tobligacion_agrupador__it_tipo_ob_agr FOREIGN KEY (id_tipo_obligacion_agrupador)
    REFERENCES plani.ttipo_obligacion_agrupador(id_tipo_obligacion_agrupador)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase);




CREATE TABLE planibk.tobligacion (
  id_obligacion SERIAL,
  id_tipo_obligacion INTEGER NOT NULL,
  id_planilla INTEGER NOT NULL,
  id_cuenta INTEGER,
  id_auxiliar INTEGER,
  tipo_pago VARCHAR(50) NOT NULL,
  acreedor VARCHAR(255) NOT NULL,
  descripcion VARCHAR(500),
  monto_obligacion NUMERIC(18,2) NOT NULL,
  id_plan_pago INTEGER,
  id_partida INTEGER,
  id_afp INTEGER,
  id_obligacion_pago INTEGER,
  id_int_comprobante INTEGER,
  id_obligacion_agrupador INTEGER,
  id_funcionario INTEGER,
  id_cuenta_haber INTEGER,
  id_partida_haber INTEGER,
  id_auxiliar_haber INTEGER,
  obs_cbte VARCHAR,
  CONSTRAINT tobligacion_pkey PRIMARY KEY(id_obligacion),
  CONSTRAINT fk_tobligacion__id_afp FOREIGN KEY (id_afp)
    REFERENCES plani.tafp(id_afp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tobligacion__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tobligacion__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tobligacion__id_obligacion_pago FOREIGN KEY (id_obligacion_pago)
    REFERENCES tes.tobligacion_pago(id_obligacion_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tobligacion__id_plan_pago FOREIGN KEY (id_plan_pago)
    REFERENCES tes.tplan_pago(id_plan_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tobligacion__id_planilla FOREIGN KEY (id_planilla)
    REFERENCES planibk.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tobligacion__id_tipo_obligacion FOREIGN KEY (id_tipo_obligacion)
    REFERENCES plani.ttipo_obligacion(id_tipo_obligacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tobligacion__id_funcionario_fk FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tobligacion__id_int_comprobante_fk FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tobligacion__id_ogligacion_agrupador_fk FOREIGN KEY (id_obligacion_agrupador)
    REFERENCES planibk.tobligacion_agrupador(id_obligacion_agrupador)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE planibk.tconsolidado (
  id_consolidado SERIAL,
  id_planilla INTEGER NOT NULL,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  tipo_consolidado VARCHAR(15) NOT NULL,
  CONSTRAINT tconsolidado_pkey PRIMARY KEY(id_consolidado),
  CONSTRAINT fk__tconsolidado__id_cc FOREIGN KEY (id_cc)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tconsolidado__id_planilla FOREIGN KEY (id_planilla)
    REFERENCES planibk.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tconsolidado__id_presupuesto FOREIGN KEY (id_presupuesto)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);



CREATE TABLE planibk.tconsolidado_columna (
  id_consolidado_columna SERIAL,
  id_consolidado INTEGER NOT NULL,
  id_tipo_columna INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  valor NUMERIC NOT NULL,
  valor_ejecutado NUMERIC DEFAULT 0,
  id_partida INTEGER,
  id_cuenta INTEGER,
  id_auxiliar INTEGER,
  tipo_contrato VARCHAR(20) NOT NULL,
  id_obligacion_det INTEGER,
  id_int_transaccion INTEGER,
  CONSTRAINT tconsolidado_columna_pkey PRIMARY KEY(id_consolidado_columna),
  CONSTRAINT fk__tconsolidado_columna__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tconsolidado_columna__id_consolidado FOREIGN KEY (id_consolidado)
    REFERENCES planibk.tconsolidado(id_consolidado)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tconsolidado_columna__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tconsolidado_columna__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk__tconsolidado_columna__id_tipo_columna FOREIGN KEY (id_tipo_columna)
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tconsolidado_columna__id_int_transaccion FOREIGN KEY (id_int_transaccion)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tconsolidado_columna__id_obligacion_det FOREIGN KEY (id_obligacion_det)
    REFERENCES tes.tobligacion_det(id_obligacion_det)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-RAC-PLANI-78-14/11/2019****************************************/



/***********************************I-SCP-MZM-PLANI-77-15/11/2019****************************************/

ALTER TABLE plani.treporte
  ADD COLUMN bordes INTEGER;

ALTER TABLE plani.treporte
  ADD COLUMN interlineado NUMERIC(5,2);
/***********************************F-SCP-MZM-PLANI-77-15/11/2019****************************************/



/***********************************I-SCP-RAC-PLANI-79-20/11/2019****************************************/

ALTER TABLE plani.ttipo_planilla
  ADD COLUMN sw_devengado VARCHAR(2) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN plani.ttipo_planilla.sw_devengado
IS 'si o no, si se habilita o no el boton de generacion de comprobantes de devegado';

CREATE TABLE planibk.tdetalle_transferencia (
  id_detalle_transferencia SERIAL,
  id_obligacion INTEGER NOT NULL,
  id_institucion INTEGER NOT NULL,
  nro_cuenta VARCHAR(50) NOT NULL,
  id_funcionario INTEGER NOT NULL,
  monto_transferencia NUMERIC(18,2) NOT NULL,
  CONSTRAINT tdetalle_transferencia_pkey PRIMARY KEY(id_detalle_transferencia),
  CONSTRAINT fk_tdetalle_transferencia__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tdetalle_transferencia__id_institucion FOREIGN KEY (id_institucion)
    REFERENCES param.tinstitucion(id_institucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT fk_tdetalle_transferencia__id_obligacion FOREIGN KEY (id_obligacion)
    REFERENCES planibk.tobligacion(id_obligacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);


/***********************************F-SCP-RAC-PLANI-79-20/11/2019****************************************/

/***********************************I-SCP-MZM-PLANI-82-28/11/2019****************************************/

 -- object recreation
ALTER TABLE plani.treporte
  DROP CONSTRAINT chk__treporte__ordenar_por RESTRICT;

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__ordenar_por CHECK (((ordenar_por)::text = 'nombre'::text) OR ((ordenar_por)::text = 'doc_id'::text) OR ((ordenar_por)::text = 'codigo_cargo'::text) OR ((ordenar_por)::text = 'codigo_empleado'::text) OR ((ordenar_por)::text = 'centro'::text) or (ordenar_por='organigrama'));


/***********************************F-SCP-MZM-PLANI-82-28/11/2019****************************************/

/***********************************I-SCP-MZM-PLANI-100-05/03/2020****************************************/
ALTER TABLE plani.ttipo_planilla
  ADD COLUMN habilitar_impresion_boleta VARCHAR(2);

ALTER TABLE plani.ttipo_planilla
  ALTER COLUMN habilitar_impresion_boleta SET DEFAULT 'no';
/***********************************F-SCP-MZM-PLANI-100-05/03/2020****************************************/



/***********************************I-SCP-RAC-PLANI-124-13/05/2020****************************************/

--------------- SQL ---------------

ALTER TABLE plani.tplanilla
  ADD COLUMN calcular_bono_rciva VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN plani.tplanilla.calcular_bono_rciva
IS 'si o no, incluye columnas marcadas para arrastrar el rc-iva de la planillas de bonos de personal vigente';


/***********************************F-SCP-RAC-PLANI-124-13/05/2020****************************************/



/***********************************I-SCP-RAC-PLANI-131-02/06/2020****************************************/


--------------- SQL ---------------

ALTER TABLE plani.tplanilla
  ADD COLUMN envios_boleta INTEGER DEFAULT 0 NOT NULL;

COMMENT ON COLUMN plani.tplanilla.envios_boleta
IS 'cuenta la cantidad de envios de boleta de pago por correo finalizados con exito';

--------------- SQL ---------------

ALTER TABLE plani.tplanilla
  ADD COLUMN fallos_boleta VARCHAR;

COMMENT ON COLUMN plani.tplanilla.fallos_boleta
IS 'si existen fallas en el envio de boletas guarda de manera acumulada para hacer debug';

--------------- SQL ---------------

ALTER TABLE plani.tfuncionario_planilla
  ADD COLUMN sw_boleta VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN plani.tfuncionario_planilla.sw_boleta
IS 'si o no si se mando la boleta de pago parael funcionario, si no se mando y el contador de envio esta arriba el servidor de coore tuvo algun fallo';


ALTER TABLE planibk.tplanilla
  ADD COLUMN calcular_bono_rciva VARCHAR(2) DEFAULT 'no' NOT NULL;



ALTER TABLE planibk.tplanilla
  ADD COLUMN envios_boleta INTEGER DEFAULT 0 NOT NULL;


ALTER TABLE planibk.tplanilla
  ADD COLUMN fallos_boleta VARCHAR;

ALTER TABLE planibk.tfuncionario_planilla
  ADD COLUMN sw_boleta VARCHAR(2) DEFAULT 'no' NOT NULL;


/***********************************F-SCP-RAC-PLANI-131-02/06/2020****************************************/


/***********************************I-SCP-MZM-PLANI-143-25/06/2020****************************************/
ALTER TABLE plani.ttipo_columna
  ADD COLUMN tipo_movimiento VARCHAR(10);
/***********************************F-SCP-MZM-PLANI-143-25/06/2020****************************************/