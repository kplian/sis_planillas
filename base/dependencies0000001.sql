/***********************************I-DEP-JRR-PLANI-0-16/01/2014****************************************/

ALTER TABLE plani.ttipo_planilla
  ADD CONSTRAINT fk_ttipo_planilla__id_proceso_macro FOREIGN KEY (id_proceso_macro)
    REFERENCES wf.tproceso_macro(id_proceso_macro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.ttipo_columna
  ADD CONSTRAINT fk__ttipo_columna__id_tipo_planilla FOREIGN KEY (id_tipo_planilla)
    REFERENCES plani.ttipo_planilla(id_tipo_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.ttipo_obligacion
  ADD CONSTRAINT fk__ttipo_obligacion__id_tipo_planilla FOREIGN KEY (id_tipo_planilla)
    REFERENCES plani.ttipo_planilla(id_tipo_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

ALTER TABLE plani.ttipo_obligacion_columna
  ADD CONSTRAINT fk__ttipo_obligacion_columna__id_tipo_obligacion FOREIGN KEY (id_tipo_obligacion)
    REFERENCES plani.ttipo_obligacion(id_tipo_obligacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.treporte
  ADD CONSTRAINT fk__treporte__id_tipo_planilla FOREIGN KEY (id_tipo_planilla)
    REFERENCES plani.ttipo_planilla(id_tipo_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.treporte_columna
  ADD CONSTRAINT fk__treporte_columna__id_reporte FOREIGN KEY (id_reporte)
    REFERENCES plani.treporte(id_reporte)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-JRR-PLANI-0-16/01/2014****************************************/