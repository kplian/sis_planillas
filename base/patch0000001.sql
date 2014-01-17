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
  compromete VARCHAR(2) NOT NULL, 
  tipo_descuento_bono VARCHAR(30), 
  decimales_redondeo INTEGER NOT NULL, 
  fecha_ini DATE NOT NULL, 
  fecha_fin DATE, 
  orden INTEGER NOT NULL,
  PRIMARY KEY(id_tipo_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT chk__ttipo_columna__compromete CHECK (compromete = 'si' or compromete = 'no');

ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT chk__ttipo_columna__tipo_dato CHECK (tipo_dato = 'basica' or
tipo_dato = 'formula' or
tipo_dato = 'variable');

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
tipo_obligacion = 'pago_comun');


ALTER TABLE plani.ttipo_obligacion
  ADD CONSTRAINT chk__ttipo_obligacion__tipo_obligacion CHECK ((((tipo_obligacion)::text = 'pago_empleados'::text) OR ((tipo_obligacion)::text = 'pago_afp'::text)) OR ((tipo_obligacion)::text = 'pago_comun'::text));


CREATE TABLE plani.ttipo_obligacion_columna (
  id_tipo_obligacion_columna SERIAL NOT NULL, 
  id_tipo_obligacion INTEGER NOT NULL
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
/***********************************F-SCP-JRR-PLANI-0-16/01/2014****************************************/