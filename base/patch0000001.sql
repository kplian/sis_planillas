/***********************************I-SCP-JRR-PLANI-0-16/01/2014****************************************/
CREATE TABLE plani.tparametro_valor (
  id_parametro_valor SERIAL,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  fecha_ini DATE NOT NULL,
  fecha_fin DATE,
  valor NUMERIC(18,2) NOT NULL,
  CONSTRAINT tparametro_valor_pkey PRIMARY KEY(id_parametro_valor)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
-----------
CREATE TABLE plani.ttipo_planilla (
  id_tipo_planilla SERIAL NOT NULL,
  codigo VARCHAR(10) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  id_proceso_macro INTEGER NOT NULL,
  funcion_obtener_empleados VARCHAR(200) NOT NULL,
  tipo_presu_cc VARCHAR(50) NOT NULL,
  funcion_validacion_nuevo_empleado VARCHAR(200) NOT NULL,
  calculo_horas VARCHAR(2) NOT NULL,
  periodicidad VARCHAR(8) NOT NULL,
  funcion_calculo_horas varchar(200) NULL,
  recalcular_desde INTEGER,
  sw_devengado VARCHAR(2) DEFAULT 'si' NOT NULL,
  habilitar_impresion_boleta VARCHAR(2) DEFAULT 'no',
  PRIMARY KEY(id_tipo_planilla),
  CONSTRAINT chk__ttipo_planilla__tipo_presu_cc CHECK (((tipo_presu_cc)::text = 'parametrizacion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_periodo'::text) OR ((tipo_presu_cc)::text = 'prorrateo_aguinaldo'::text) OR ((tipo_presu_cc)::text = 'retroactivo_sueldo'::text) OR ((tipo_presu_cc)::text = 'retroactivo_asignaciones'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_gestion'::text) OR ((tipo_presu_cc)::text = 'ultimo_activo_gestion_anterior'::text)  OR ((tipo_presu_cc)::text = 'hoja_calculo'::text) )
) INHERITS (pxp.tbase)
WITHOUT OIDS;

CREATE UNIQUE INDEX ttipo_planilla_idx ON plani.ttipo_planilla
  USING btree (codigo);

COMMENT ON COLUMN plani.ttipo_planilla.sw_devengado
IS 'si o no, si se habilita o no el boton de generacion de comprobantes de devegado';
---------------------

CREATE TABLE plani.ttipo_columna (
  id_tipo_columna SERIAL NOT NULL,
  id_tipo_planilla INTEGER NOT NULL,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  tipo_dato VARCHAR(30) NOT NULL,
  descripcion TEXT NOT NULL,
  formula VARCHAR(500),
  compromete VARCHAR(15) NOT NULL,
  tipo_descuento_bono VARCHAR(30),
  decimales_redondeo INTEGER NOT NULL,
  orden INTEGER NOT NULL,
  finiquito VARCHAR(25) NOT NULL,
  tiene_detalle VARCHAR(2) DEFAULT 'no' NOT NULL,
  recalcular varchar(2) DEFAULT 'no' NOT NULL,
  editable VARCHAR(2) DEFAULT 'no' NOT NULL,
  tipo_movimiento VARCHAR(10),
  PRIMARY KEY(id_tipo_columna),
  CONSTRAINT chk__ttipo_columna__compromete CHECK (((((compromete)::text = 'si_pago'::text) OR ((compromete)::text = 'si_contable'::text)) OR ((compromete)::text = 'si'::text)) OR ((compromete)::text = 'no'::text)),
  CONSTRAINT chk__ttipo_columna__tipo_dato CHECK (tipo_dato = 'basica' or tipo_dato = 'formula' or tipo_dato = 'variable'),
  CONSTRAINT chk__ttipo_columna__tipo_descuento_bono CHECK (((((tipo_descuento_bono)::text = 'monto_fijo_indefinido'::text) OR ((tipo_descuento_bono)::text = 'cantidad_cuotas'::text)) OR ((tipo_descuento_bono)::text = 'monto_fijo_por_fechas'::text)) OR (tipo_descuento_bono IS NULL) OR (tipo_descuento_bono = '')),
  CONSTRAINT chk__ttipo_columna__finiquito CHECK (((finiquito)::text = 'ejecutar'::text) OR ((finiquito)::text = 'restar_ejecutado'::text))
) INHERITS (pxp.tbase)
WITHOUT OIDS;
COMMENT ON COLUMN plani.ttipo_columna.editable
IS 'la columnas es editable manualmente, si o no';
-----
CREATE TABLE plani.ttipo_obligacion (
  id_tipo_obligacion SERIAL,
  id_tipo_planilla INTEGER NOT NULL,
  codigo VARCHAR(30) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  tipo_obligacion VARCHAR(30),
  dividir_por_lugar VARCHAR(2),
  es_pagable VARCHAR(2) DEFAULT 'si' NOT NULL,
  id_tipo_obligacion_agrupador INTEGER,
  descripcion VARCHAR,
  codigo_tipo_relacion_debe VARCHAR DEFAULT 'CUEOBLI'::character varying NOT NULL,
  codigo_tipo_relacion_haber VARCHAR DEFAULT 'CUEOBLI'::character varying NOT NULL,
  tipo_abono VARCHAR(2),
  CONSTRAINT ttipo_obligacion_pkey PRIMARY KEY(id_tipo_obligacion)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.ttipo_obligacion
  ADD CONSTRAINT chk__ttipo_obligacion__tipo_obligacion CHECK (tipo_obligacion = 'pago_empleados' or
tipo_obligacion = 'pago_afp' or
tipo_obligacion = 'pago_comun' or tipo_obligacion = 'una_obligacion_x_empleado');

COMMENT ON COLUMN plani.ttipo_obligacion.codigo_tipo_relacion_debe
IS 'tipo de relacion contable apra genrar cbte de obligaciones con moviemiento al debe';

COMMENT ON COLUMN plani.ttipo_obligacion.codigo_tipo_relacion_haber
IS 'tipo de relacion contable apra genrar cbte de obligaciones con moviemiento al haber';

------------

CREATE TABLE plani.ttipo_obligacion_columna (
  id_tipo_obligacion_columna SERIAL NOT NULL,
  id_tipo_obligacion INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  pago VARCHAR(2) NOT NULL,
  presupuesto VARCHAR(2) NOT NULL,
  es_ultimo VARCHAR(2) DEFAULT 'no' NOT NULL,
  PRIMARY KEY(id_tipo_obligacion_columna),
  CONSTRAINT chk__ttipo_obligacion_columna__pago CHECK (pago='si' or pago = 'no'),
  CONSTRAINT chk__ttipo_obligacion_columna__presupuesto CHECK (presupuesto = 'si' or presupuesto = 'no')
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.ttipo_obligacion_columna
ALTER COLUMN pago TYPE VARCHAR COLLATE pg_catalog."default";
-------------
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
  ancho_total INTEGER DEFAULT 0 NOT NULL,
  ancho_utilizado INTEGER DEFAULT 0 NOT NULL,
  control_reporte VARCHAR(200),
  tipo_reporte VARCHAR(200) DEFAULT 'planilla' NOT NULL,
  multilinea VARCHAR(2) DEFAULT 'no',
  vista_datos_externos VARCHAR(100),
  num_columna_multilinea INTEGER,
  id_pie_firma INTEGER,
  mostrar_ufv VARCHAR(2) DEFAULT 'no',
  incluir_retirados VARCHAR(2) DEFAULT 'no',
  id_moneda_reporte INTEGER,
  bordes INTEGER,
  interlineado NUMERIC(5,2),
  CONSTRAINT treporte_pkey PRIMARY KEY(id_reporte),
  CONSTRAINT chk__treporte__numerar CHECK (numerar='si' or numerar = 'no'),
  CONSTRAINT chk__treporte__mostrar_nombre CHECK (mostrar_nombre='si' or mostrar_nombre = 'no'),
  CONSTRAINT chk__treporte__mostrar_codigo_empleado CHECK (mostrar_codigo_empleado='si' or mostrar_codigo_empleado = 'no'),
  CONSTRAINT chk__treporte__mostrar_doc_id CHECK (mostrar_doc_id='si' or mostrar_doc_id = 'no'),
  CONSTRAINT chk__treporte__mostrar_codigo_cargo CHECK (mostrar_codigo_cargo='si' or mostrar_codigo_cargo = 'no'),
  CONSTRAINT chk__treporte__hoja_posicion CHECK (((((hoja_posicion)::text = 'carta_vertical'::text) OR ((hoja_posicion)::text = 'carta_horizontal'::text)) OR ((hoja_posicion)::text = 'oficio_vertical'::text)) OR ((hoja_posicion)::text = 'oficio_horizontal'::text)),
  CONSTRAINT chk__treporte__agrupar_por CHECK ((((agrupar_por)::text = 'gerencia'::text) OR ((agrupar_por)::text = 'gerencia_presupuesto'::text) OR ((agrupar_por)::text = 'ninguno'::text) OR ((agrupar_por)::text = 'distrito'::text) OR ((agrupar_por)::text = 'centro'::text) OR ((agrupar_por)::text = 'distrito_banco'::text))),
  CONSTRAINT chk__treporte__ordenar_por CHECK ((((ordenar_por)::text = 'nombre'::text) OR ((ordenar_por)::text = 'doc_id'::text) OR ((ordenar_por)::text = 'codigo_cargo'::text) OR ((ordenar_por)::text = 'codigo_empleado'::text) OR ((ordenar_por)::text = 'centro'::text) OR ((ordenar_por)::text = 'organigrama'::text)))



) INHERITS (pxp.tbase)
WITHOUT OIDS;

--------

CREATE TABLE plani.treporte_columna (
  id_reporte_columna SERIAL NOT NULL,
  id_reporte INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  sumar_total VARCHAR(2) NOT NULL,
  ancho_columna INTEGER NOT NULL,
  orden INTEGER NOT NULL,
  titulo_reporte_superior VARCHAR(30),
  titulo_reporte_inferior VARCHAR(30),
  tipo_columna VARCHAR(200) DEFAULT 'otro',
  columna_vista VARCHAR(100),
  origen VARCHAR(30),
  espacio_previo INTEGER,
  PRIMARY KEY(id_reporte_columna),
  CONSTRAINT chk__treporte_columna__sumar_total CHECK (sumar_total = 'si' or sumar_total = 'no'),
  CONSTRAINT chk__treporte_columna__tipo_columna CHECK (tipo_columna::text = 'ingreso'::text OR tipo_columna::text = 'descuento_ley'::text OR tipo_columna::text = 'otros_descuentos'::text OR tipo_columna::text = 'iva'::text OR tipo_columna::text = 'otro'::text)
) INHERITS (pxp.tbase)
WITHOUT OIDS;


------------




CREATE TABLE plani.tafp (
  id_afp SERIAL,
  nombre VARCHAR(300) NOT NULL,
  codigo VARCHAR NOT NULL,
  CONSTRAINT tafp_pkey PRIMARY KEY(id_afp)
) INHERITS (pxp.tbase) WITHOUT OIDS;
-----------
CREATE TABLE plani.tantiguedad (
  id_antiguedad SERIAL,
  valor_min INTEGER NOT NULL,
  valor_max INTEGER NOT NULL,
  porcentaje NUMERIC NOT NULL,
  CONSTRAINT tantiguedad_pkey PRIMARY KEY(id_antiguedad)
) INHERITS (pxp.tbase) WITHOUT OIDS;
----
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
------



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
-----

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
  id_obligacion_pago INTEGER,
  requiere_calculo VARCHAR(2) DEFAULT 'no' NOT NULL,
  fecha_planilla DATE,
  id_int_comprobante INTEGER,
  codigo_poa VARCHAR(25),
  obs_poa TEXT,
  dividir_comprobante VARCHAR(5) DEFAULT 'no',
  id_tipo_contrato INTEGER,
  id_int_comprobante_2 INTEGER,
  calcular_reintegro_rciva VARCHAR(2) DEFAULT 'no' NOT NULL,
  calcular_prima_rciva VARCHAR(2) DEFAULT 'no' NOT NULL,
  calcular_bono_rciva VARCHAR(2) DEFAULT 'no' NOT NULL,
  envios_boleta INTEGER DEFAULT 0 NOT NULL,
  fallos_boleta VARCHAR,
  PRIMARY KEY(id_planilla)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
COMMENT ON COLUMN plani.tplanilla.id_int_comprobante_2
IS 'se añadir por en algunos casos es necesario dividir la pnailal en dos cbte, un o presupeustario y otro solo contable,.....se divide segun tipo de presupuesto configurado en la tabla plani.tfiltro_cbte';

COMMENT ON COLUMN plani.tplanilla.calcular_reintegro_rciva
IS 'si o no, incluye columnas marcacados como reintegro_rciva,  si no es no el valor por defecto es cero';

COMMENT ON COLUMN plani.tplanilla.calcular_prima_rciva
IS 'si o no, incluye columnas marcadas para arrastrar el rc-iva de la planilal de prima de personal vigente';

COMMENT ON COLUMN plani.tplanilla.calcular_bono_rciva
IS 'si o no, incluye columnas marcadas para arrastrar el rc-iva de la planillas de bonos de personal vigente';

COMMENT ON COLUMN plani.tplanilla.envios_boleta
IS 'cuenta la cantidad de envios de boleta de pago por correo finalizados con exito';

COMMENT ON COLUMN plani.tplanilla.fallos_boleta
IS 'si existen fallas en el envio de boletas guarda de manera acumulada para hacer debug';
---------------

CREATE TABLE plani.tfuncionario_planilla (
  id_funcionario_planilla SERIAL NOT NULL,
  id_funcionario INTEGER NOT NULL,
  id_planilla INTEGER NOT NULL,
  id_uo_funcionario INTEGER NOT NULL,
  id_lugar INTEGER NOT NULL,
  forzar_cheque VARCHAR(2) NOT NULL,
  finiquito VARCHAR(2) NOT NULL,
  id_afp INTEGER,
  id_cuenta_bancaria INTEGER,
  tipo_contrato VARCHAR,
  sw_boleta VARCHAR(2) DEFAULT 'no' NOT NULL,
  PRIMARY KEY(id_funcionario_planilla),
  CONSTRAINT chk__tfuncionario_planilla__finiquito CHECK (finiquito = 'si' or finiquito = 'no'),
  CONSTRAINT chk__tfuncionario_planilla__forzar_cheque CHECK (forzar_cheque = 'si' or forzar_cheque = 'no'),
  CONSTRAINT uk_tfuncionario_planilla__id_funcionario__id_planilla UNIQUE (id_planilla, id_funcionario)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
COMMENT ON COLUMN plani.tfuncionario_planilla.sw_boleta
IS 'si o no si se mando la boleta de pago parael funcionario, si no se mando y el contador de envio esta arriba el servidor de coore tuvo algun fallo';

-------------

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
  zona_franca VARCHAR(2),
  frontera VARCHAR(2),
  horas_normales_contrato NUMERIC(10,2),
  PRIMARY KEY(id_horas_trabajadas)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
-------

CREATE TABLE plani.tcolumna_valor (
  id_columna_valor SERIAL NOT NULL,
  id_tipo_columna INTEGER NOT NULL,
  id_funcionario_planilla INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  formula VARCHAR(255),
  valor NUMERIC(18,10) NOT NULL,
  valor_generado NUMERIC(18,10) NOT NULL,
  PRIMARY KEY(id_columna_valor)
) INHERITS (pxp.tbase)
WITHOUT OIDS;



/***********************************F-SCP-JRR-PLANI-0-16/01/2014****************************************/


/***********************************I-SCP-JRR-PLANI-0-23/02/2014****************************************/

CREATE TABLE plani.tprorrateo (
  id_prorrateo SERIAL NOT NULL,
  id_funcionario_planilla INTEGER,
  id_horas_trabajadas INTEGER,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  tipo_prorrateo VARCHAR(15) NOT NULL,
  porcentaje NUMERIC NOT NULL,
  tipo_contrato VARCHAR(10),
  porcentaje_dias NUMERIC,
  id_oficina INTEGER,
  id_lugar INTEGER,
  tipo_horario VARCHAR(15) DEFAULT 'normal' NOT NULL,
  calculado_resta VARCHAR DEFAULT 'no' NOT NULL,
  PRIMARY KEY(id_prorrateo),
  CONSTRAINT tprorrateo_chk__id_presupuesto_id_cc CHECK (id_presupuesto is not null or id_cc is not null)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN plani.tprorrateo.tipo_horario
IS 'normal,  extra o  nocturno,  tipo de horario prorrateado';

COMMENT ON COLUMN plani.tprorrateo.calculado_resta
IS 'indica se se calculo por resta';
-------------

CREATE TABLE plani.tprorrateo_columna (
  id_prorrateo_columna SERIAL NOT NULL,
  id_prorrateo INTEGER NOT NULL,
  id_tipo_columna INTEGER NOT NULL,
  codigo_columna VARCHAR(30) NOT NULL,
  porcentaje NUMERIC NOT NULL,
  compromete VARCHAR(20) DEFAULT 'si' NOT NULL,
  id_oficina INTEGER,
  id_lugar INTEGER,
  PRIMARY KEY(id_prorrateo_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
------------

CREATE TABLE plani.tconsolidado (
  id_consolidado SERIAL NOT NULL,
  id_planilla INTEGER NOT NULL,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  tipo_consolidado VARCHAR(15) NOT NULL,
  PRIMARY KEY(id_consolidado)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
-----------

CREATE TABLE plani.tconsolidado_columna (
  id_consolidado_columna SERIAL NOT NULL,
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
  PRIMARY KEY(id_consolidado_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-PLANI-0-23/02/2014****************************************/


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
  PRIMARY KEY(id_obligacion)
) INHERITS (pxp.tbase)
WITHOUT OIDS;


COMMENT ON COLUMN plani.tobligacion.id_funcionario
IS 'para identificar obligaciones por funcionario';

COMMENT ON COLUMN plani.tobligacion.id_cuenta
IS 'cuenta para el debe';

COMMENT ON COLUMN plani.tobligacion.id_auxiliar
IS 'auxiliar para el debe';

COMMENT ON COLUMN plani.tobligacion.id_planilla
IS 'partida para el debe';

COMMENT ON COLUMN plani.tobligacion.id_cuenta_haber
IS 'cuenta pra el haber';

COMMENT ON COLUMN plani.tobligacion.id_partida_haber
IS 'partida para el haber';


COMMENT ON COLUMN plani.tobligacion.id_auxiliar_haber
IS 'auxiliar para el haber';

COMMENT ON COLUMN plani.tobligacion.obs_cbte
IS 'pra describir si el c bte fue eliminado,...el FK se pierde';
-----------
CREATE TABLE plani.tobligacion_columna (
  id_obligacion_columna SERIAL NOT NULL,
  id_obligacion INTEGER NOT NULL,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  id_tipo_columna INTEGER,
  codigo_columna VARCHAR(50) NOT NULL,
  tipo_contrato VARCHAR(5) NOT NULL,
  monto_detalle_obligacion NUMERIC NOT NULL,
  PRIMARY KEY (id_obligacion_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
----------
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



/***********************************I-SCP-JRR-PLANI-0-04/12/2014****************************************/





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




/***********************************F-SCP-JRR-PLANI-0-04/12/2014****************************************/



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
  id_estado_wf INTEGER,
  id_proceso_wf INTEGER,
  nro_tramite VARCHAR,
  PRIMARY KEY(id_licencia)
) INHERITS (pxp.tbase)
WITHOUT OIDS;
----

CREATE TABLE plani.ttipo_licencia (
  id_tipo_licencia SERIAL NOT NULL,
  codigo VARCHAR(20) NOT NULL,
  nombre VARCHAR (100) NOT NULL,
  genera_descuento VARCHAR(2) NOT NULL,
  PRIMARY KEY(id_tipo_licencia)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-PLANI-0-29/10/2015****************************************/



/***********************************I-SCP-EGS-PLANI-0-05/02/2019****************************************/



CREATE TABLE plani.ttipo_obligacion_agrupador (
  id_tipo_obligacion_agrupador SERIAL,
  codigo_plantilla_comprobante VARCHAR,
  codigo VARCHAR,
  nombre VARCHAR,
  descripcion VARCHAR,
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
  PRIMARY KEY(id_obligacion_agrupador)
) INHERITS (pxp.tbase)
WITH (oids = false);

COMMENT ON COLUMN plani.tobligacion_agrupador.obs_cbte
IS 'pra describir si el c bte fue eliminado,...el FK se pierde';

COMMENT ON COLUMN plani.tobligacion_agrupador.id_afp
IS 'identifica los agrupadores por AFP';


/***********************************F-SCP-EGS-PLANI-0-05/02/2019****************************************/

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


/***********************************F-SCP-RAC-PLANI-2-15/05/2019****************************************/


/***********************************I-SCP-RAC-PLANI-78-14/11/2019****************************************/
/*CREATE OR REPLACE SCHEMA planibk if not EXISTS;*/

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
  calcular_bono_rciva VARCHAR(2) DEFAULT 'no' NOT NULL,
  envios_boleta INTEGER DEFAULT 0 NOT NULL,
  fallos_boleta VARCHAR,
  CONSTRAINT tplanilla_pkey PRIMARY KEY(id_planilla)
  
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
  sw_boleta VARCHAR(2) DEFAULT 'no' NOT NULL,
  CONSTRAINT tfuncionario_planilla_pkey PRIMARY KEY(id_funcionario_planilla),
  CONSTRAINT uk_tfuncionario_planilla__id_funcionario__id_planilla UNIQUE(id_planilla, id_funcionario),
  CONSTRAINT chk__tfuncionario_planilla__finiquito CHECK (((finiquito)::text = 'si'::text) OR ((finiquito)::text = 'no'::text)),
  CONSTRAINT chk__tfuncionario_planilla__forzar_cheque CHECK (((forzar_cheque)::text = 'si'::text) OR ((forzar_cheque)::text = 'no'::text))
  
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
  CONSTRAINT tcolumna_valor_pkey PRIMARY KEY(id_columna_valor)
  
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
  CONSTRAINT tobligacion_agrupador_pkey PRIMARY KEY(id_obligacion_agrupador)
  
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
  CONSTRAINT tobligacion_pkey PRIMARY KEY(id_obligacion)
  
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE planibk.tconsolidado (
  id_consolidado SERIAL,
  id_planilla INTEGER NOT NULL,
  id_presupuesto INTEGER,
  id_cc INTEGER,
  tipo_consolidado VARCHAR(15) NOT NULL,
  CONSTRAINT tconsolidado_pkey PRIMARY KEY(id_consolidado)
  
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
  CONSTRAINT tconsolidado_columna_pkey PRIMARY KEY(id_consolidado_columna)
  
) INHERITS (pxp.tbase)

WITH (oids = false);

/***********************************F-SCP-RAC-PLANI-78-14/11/2019****************************************/


/***********************************I-SCP-RAC-PLANI-79-20/11/2019****************************************/


CREATE TABLE planibk.tdetalle_transferencia (
  id_detalle_transferencia SERIAL,
  id_obligacion INTEGER NOT NULL,
  id_institucion INTEGER NOT NULL,
  nro_cuenta VARCHAR(50) NOT NULL,
  id_funcionario INTEGER NOT NULL,
  monto_transferencia NUMERIC(18,2) NOT NULL,
  CONSTRAINT tdetalle_transferencia_pkey PRIMARY KEY(id_detalle_transferencia)
  
) INHERITS (pxp.tbase)
WITH (oids = false);


/***********************************F-SCP-RAC-PLANI-79-20/11/2019****************************************/
