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
  id_reporte_columna INTEGER NOT NULL, 
  id_reporte INTEGER NOT NULL, 
  codigo_columna VARCHAR(30) NOT NULL, 
  sumar_total VARCHAR(2) NOT NULL, 
  ancho_columna INTEGER NOT NULL, 
  orden INTEGER NOT NULL
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

/***********************************F-SCP-JRR-PLANI-0-16/01/2014****************************************/