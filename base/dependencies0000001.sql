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
    
ALTER TABLE plani.tfuncionario_afp
  ADD CONSTRAINT fk__tfuncionario_afp__id_afp FOREIGN KEY (id_afp)
    REFERENCES plani.tafp(id_afp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tdescuento_bono
  ADD CONSTRAINT fk__tdescuento_bono__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tdescuento_bono
  ADD CONSTRAINT fk__tdescuento_bono__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tdescuento_bono
  ADD CONSTRAINT fk__tdescuento_bono__id_tipo_columna FOREIGN KEY (id_tipo_columna)
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_tipo_planilla FOREIGN KEY (id_tipo_planilla)
    REFERENCES plani.ttipo_planilla(id_tipo_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_proceso_macro FOREIGN KEY (id_proceso_macro)
    REFERENCES wf.tproceso_macro(id_proceso_macro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk__tplanilla__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tfuncionario_planilla  
	ADD CONSTRAINT fk__tfuncionario_planilla__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tfuncionario_planilla  
	ADD CONSTRAINT fk__tfuncionario_planilla__id_planilla FOREIGN KEY (id_planilla)
    REFERENCES plani.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tfuncionario_planilla  
	ADD CONSTRAINT fk__tfuncionario_planilla__id_lugar FOREIGN KEY (id_lugar)
    REFERENCES param.tlugar(id_lugar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tfuncionario_planilla  
	ADD CONSTRAINT fk__tfuncionario_planilla__id_uo_funcionario FOREIGN KEY (id_uo_funcionario)
    REFERENCES orga.tuo_funcionario(id_uo_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.thoras_trabajadas
	ADD CONSTRAINT fk__thoras_trabajadas__id_funcionario_planilla FOREIGN KEY (id_funcionario_planilla)
    REFERENCES plani.tfuncionario_planilla (id_funcionario_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.thoras_trabajadas
	ADD CONSTRAINT fk__thoras_trabajadas__id_uo_funcionario FOREIGN KEY (id_uo_funcionario)
    REFERENCES orga.tuo_funcionario(id_uo_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    


/***********************************F-DEP-JRR-PLANI-0-16/01/2014****************************************/