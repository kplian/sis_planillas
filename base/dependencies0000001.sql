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
    
ALTER TABLE plani.tcolumna_valor
  ADD CONSTRAINT fk_tcolumna_valor__id_tipo_columna FOREIGN KEY (id_tipo_columna)
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

ALTER TABLE plani.tcolumna_valor
  ADD CONSTRAINT fk_tcolumna_valor__id_funcionario_planilla FOREIGN KEY (id_funcionario_planilla)
    REFERENCES plani.tfuncionario_planilla(id_funcionario_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
select pxp.f_insert_testructura_gui ('PLANI', 'SISTEMA');
select pxp.f_insert_testructura_gui ('DEFPLA', 'PLANI');
select pxp.f_insert_testructura_gui ('TIPPLA', 'DEFPLA');
select pxp.f_insert_testructura_gui ('PLAPARVAR', 'DEFPLA');
select pxp.f_insert_testructura_gui ('REGAFP', 'PLANI');
select pxp.f_insert_testructura_gui ('DEFANTI', 'PLANI');
select pxp.f_delete_testructura_gui ('FUNPLA', 'REGAFP');
select pxp.f_insert_testructura_gui ('FUNPLAN', 'PLANI');
select pxp.f_insert_testructura_gui ('TIPPLA.1', 'TIPPLA');
select pxp.f_insert_testructura_gui ('TIPPLA.2', 'TIPPLA');
select pxp.f_insert_testructura_gui ('TIPPLA.3', 'TIPPLA');
select pxp.f_insert_testructura_gui ('TIPPLA.2.1', 'TIPPLA.2');
select pxp.f_insert_testructura_gui ('TIPPLA.3.1', 'TIPPLA.3');
select pxp.f_insert_testructura_gui ('FUNPLAN.1', 'FUNPLAN');
select pxp.f_insert_testructura_gui ('FUNPLAN.2', 'FUNPLAN');
select pxp.f_insert_testructura_gui ('FUNPLAN.3', 'FUNPLAN');
select pxp.f_insert_testructura_gui ('FUNPLAN.4', 'FUNPLAN');
select pxp.f_insert_testructura_gui ('FUNPLAN.3.1', 'FUNPLAN.3');
select pxp.f_insert_testructura_gui ('FUNPLAN.3.1.1', 'FUNPLAN.3.1');
select pxp.f_insert_testructura_gui ('FUNPLAN.3.1.1.1', 'FUNPLAN.3.1.1');
select pxp.f_insert_tprocedimiento_gui ('WF_PROMAC_SEL', 'TIPPLA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPPLA_INS', 'TIPPLA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPPLA_MOD', 'TIPPLA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPPLA_ELI', 'TIPPLA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPPLA_SEL', 'TIPPLA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPCOL_INS', 'TIPPLA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPCOL_MOD', 'TIPPLA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPCOL_ELI', 'TIPPLA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPCOL_SEL', 'TIPPLA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPOBLI_INS', 'TIPPLA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPOBLI_MOD', 'TIPPLA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPOBLI_ELI', 'TIPPLA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPOBLI_SEL', 'TIPPLA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPCOL_SEL', 'TIPPLA.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_OBCOL_INS', 'TIPPLA.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_OBCOL_MOD', 'TIPPLA.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_OBCOL_ELI', 'TIPPLA.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_OBCOL_SEL', 'TIPPLA.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPO_INS', 'TIPPLA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPO_MOD', 'TIPPLA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPO_ELI', 'TIPPLA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPO_SEL', 'TIPPLA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPCOL_SEL', 'TIPPLA.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPCOL_INS', 'TIPPLA.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPCOL_MOD', 'TIPPLA.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPCOL_ELI', 'TIPPLA.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_REPCOL_SEL', 'TIPPLA.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PARVAR_INS', 'PLAPARVAR', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PARVAR_MOD', 'PLAPARVAR', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PARVAR_ELI', 'PLAPARVAR', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PARVAR_SEL', 'PLAPARVAR', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_AFP_INS', 'REGAFP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_AFP_MOD', 'REGAFP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_AFP_ELI', 'REGAFP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_AFP_SEL', 'REGAFP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_ANTI_INS', 'DEFANTI', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_ANTI_MOD', 'DEFANTI', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_ANTI_ELI', 'DEFANTI', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_ANTI_SEL', 'DEFANTI', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'FUNPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'FUNPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'FUNPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'FUNPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'FUNPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'FUNPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'FUNPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_AFP_SEL', 'FUNPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNAFP_INS', 'FUNPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNAFP_MOD', 'FUNPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_AFP_ELI', 'FUNPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNAFP_SEL', 'FUNPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPCOL_SEL', 'FUNPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_DESBON_INS', 'FUNPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_DESBON_MOD', 'FUNPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_DESBON_ELI', 'FUNPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_DESBON_SEL', 'FUNPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'FUNPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'FUNPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'FUNPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'FUNPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'FUNPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'FUNPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'FUNPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'FUNPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'FUNPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'FUNPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'FUNPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'FUNPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'FUNPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'FUNPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'FUNPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'FUNPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'FUNPLAN.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'FUNPLAN.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'FUNPLAN.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'FUNPLAN.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'FUNPLAN.4', 'no');

/***********************************F-DEP-JRR-PLANI-0-16/01/2014****************************************/

/***********************************I-DEP-RAC-ADQ-00-03/02/2014*****************************************/
select pxp.f_insert_testructura_gui ('ADQ.3.2', 'ADQ.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3', 'ADQ.3');
select pxp.f_insert_testructura_gui ('ADQ.3.2.1', 'ADQ.3.2');
select pxp.f_insert_testructura_gui ('ADQ.3.3.1', 'ADQ.3.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3.2', 'ADQ.3.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3.3', 'ADQ.3.3');
select pxp.f_insert_testructura_gui ('ADQ.3.3.2.1', 'ADQ.3.3.2');
select pxp.f_insert_testructura_gui ('ADQ.3.3.3.1', 'ADQ.3.3.3');
select pxp.f_insert_testructura_gui ('VBSOL.2', 'VBSOL');
select pxp.f_insert_testructura_gui ('VBSOL.3', 'VBSOL');
select pxp.f_insert_testructura_gui ('VBSOL.2.1', 'VBSOL.2');
select pxp.f_insert_testructura_gui ('VBSOL.3.1', 'VBSOL.3');
select pxp.f_insert_testructura_gui ('VBSOL.3.2', 'VBSOL.3');
select pxp.f_insert_testructura_gui ('VBSOL.3.3', 'VBSOL.3');
select pxp.f_insert_testructura_gui ('VBSOL.3.2.1', 'VBSOL.3.2');
select pxp.f_insert_testructura_gui ('VBSOL.3.3.1', 'VBSOL.3.3');
select pxp.f_insert_testructura_gui ('ADQ.4.1', 'ADQ.4');
select pxp.f_insert_testructura_gui ('ADQ.4.2', 'ADQ.4');
select pxp.f_insert_testructura_gui ('ADQ.4.1.1', 'ADQ.4.1');
select pxp.f_insert_testructura_gui ('ADQ.4.2.1', 'ADQ.4.2');
select pxp.f_insert_testructura_gui ('PROC.3', 'PROC');
select pxp.f_insert_testructura_gui ('PROC.4', 'PROC');
select pxp.f_insert_testructura_gui ('PROC.3.1', 'PROC.3');
select pxp.f_insert_testructura_gui ('PROC.4.1', 'PROC.4');
select pxp.f_insert_testructura_gui ('PROC.4.2', 'PROC.4');
select pxp.f_insert_testructura_gui ('PROC.4.3', 'PROC.4');
select pxp.f_insert_testructura_gui ('VBCOT.1', 'VBCOT');
select pxp.f_insert_testructura_gui ('VBCOT.2', 'VBCOT');
select pxp.f_insert_testructura_gui ('VBCOT.3', 'VBCOT');
select pxp.f_insert_testructura_gui ('VBCOT.1.1', 'VBCOT.1');
select pxp.f_insert_testructura_gui ('VBCOT.1.2', 'VBCOT.1');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.1', 'VBCOT.1.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.2', 'VBCOT.1.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.3', 'VBCOT.1.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.2.1', 'VBCOT.1.2.2');
select pxp.f_insert_testructura_gui ('VBCOT.1.2.3.1', 'VBCOT.1.2.3');
select pxp.f_insert_testructura_gui ('VBCOT.2.1', 'VBCOT.2');
select pxp.f_insert_testructura_gui ('GRUP.1', 'GRUP');
select pxp.f_insert_testructura_gui ('GRUP.2', 'GRUP');
select pxp.f_insert_testructura_gui ('GRUP.2.1', 'GRUP.2');
select pxp.f_insert_testructura_gui ('GRUP.2.1.1', 'GRUP.2.1');
select pxp.f_insert_testructura_gui ('GRUP.2.1.2', 'GRUP.2.1');
select pxp.f_insert_testructura_gui ('GRUP.2.1.3', 'GRUP.2.1');
select pxp.f_insert_testructura_gui ('GRUP.2.1.1.1', 'GRUP.2.1.1');
select pxp.f_insert_testructura_gui ('PRECOM.1', 'PRECOM');
select pxp.f_insert_testructura_gui ('VBPRE.1', 'VBPRE');
select pxp.f_insert_testructura_gui ('COPRE.1', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.2', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.3', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.4', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.5', 'COPRE');
select pxp.f_insert_testructura_gui ('COPRE.2.1', 'COPRE.2');
select pxp.f_insert_testructura_gui ('COPRE.4.1', 'COPRE.4');
select pxp.f_insert_testructura_gui ('COPRE.5.1', 'COPRE.5');
select pxp.f_insert_testructura_gui ('COPRE.5.2', 'COPRE.5');
select pxp.f_insert_testructura_gui ('COPRE.5.3', 'COPRE.5');
select pxp.f_insert_testructura_gui ('COPRE.5.2.1', 'COPRE.5.2');
select pxp.f_insert_testructura_gui ('COPRE.5.3.1', 'COPRE.5.3');
select pxp.f_insert_testructura_gui ('SOLPEN', 'ADQ');
select pxp.f_insert_testructura_gui ('SOLPEN.1', 'SOLPEN');
select pxp.f_insert_testructura_gui ('SOLPEN.2', 'SOLPEN');
select pxp.f_insert_testructura_gui ('SOLPEN.3', 'SOLPEN');
select pxp.f_insert_testructura_gui ('SOLPEN.2.1', 'SOLPEN.2');
select pxp.f_insert_testructura_gui ('SOLPEN.3.1', 'SOLPEN.3');
select pxp.f_insert_testructura_gui ('SOLPEN.3.2', 'SOLPEN.3');
select pxp.f_insert_testructura_gui ('SOLPEN.3.3', 'SOLPEN.3');
select pxp.f_insert_testructura_gui ('SOLPEN.3.2.1', 'SOLPEN.3.2');
select pxp.f_insert_testructura_gui ('SOLPEN.3.3.1', 'SOLPEN.3.3');
select pxp.f_insert_testructura_gui ('OBPAGOA', 'ADQ');
select pxp.f_insert_testructura_gui ('OBPAGOA.1', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.2', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.3', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.4', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.5', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.6', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.7', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.8', 'OBPAGOA');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.1', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.2', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.3', 'OBPAGOA.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.2.3.1', 'OBPAGOA.2.3');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.1', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.2', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.4.3', 'OBPAGOA.4');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.1', 'OBPAGOA.7');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.2', 'OBPAGOA.7');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.3', 'OBPAGOA.7');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.2.1', 'OBPAGOA.7.2');
select pxp.f_insert_testructura_gui ('OBPAGOA.7.3.1', 'OBPAGOA.7.3');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.1', 'OBPAGOA.8');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.2', 'OBPAGOA.8');
select pxp.f_insert_testructura_gui ('OBPAGOA.8.1.1', 'OBPAGOA.8.1');
select pxp.f_insert_tprocedimiento_gui ('WF_PROMAC_SEL', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_INS', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_MOD', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_ELI', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'ADQ.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'ADQ.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTARPOBA_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINSOL_IME', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'ADQ.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'ADQ.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'ADQ.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'ADQ.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'ADQ.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'ADQ.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'ADQ.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ADQ.3.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.3.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGESOL_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTESOL_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBSOL', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'VBSOL.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBSOL.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBSOL.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBSOL.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBSOL.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBSOL.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBSOL.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBSOL.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBSOL.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_INS', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_MOD', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_ELI', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROVEE_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ADQ.4.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'ADQ.4.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_INS', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_MOD', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_ELI', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCSOL_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_REVPRE_IME', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINPRO_IME', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'PROC', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'PROC.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'PROC.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'PROC.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'PROC.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_OBEPUO_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILEPUO_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINREGC_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGECOT_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJTODO_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_HABPAG_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PREING_GEN', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_INS', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_MOD', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_ELI', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTEST_IME', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'PROC.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLCON_IME', 'PROC.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'PROC.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'PROC.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'PROC.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'PROC.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_TOTALADJ_IME', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJDET_IME', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_INS', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_MOD', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_ELI', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'PROC.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'PROC.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GENOC_IME', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_INS', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_MOD', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_ELI', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTEST_IME', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'VBCOT', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_SEL', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_SEL', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_INS', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_MOD', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOL_ELI', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBCOT.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_DOCSOLAR_MOD', 'VBCOT.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBCOT.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'VBCOT.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'VBCOT.1.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'VBCOT.1.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'VBCOT.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'VBCOT.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'VBCOT.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'VBCOT.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_TOTALADJ_IME', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ADJDET_IME', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_INS', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_MOD', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_ELI', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'VBCOT.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_INS', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_MOD', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_ELI', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'GRUP', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_INS', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_MOD', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_ELI', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRPA_SEL', 'GRUP.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_SEL', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_INS', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_MOD', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_ELI', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRUS_SEL', 'GRUP.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_CLASIF_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_ROL_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_INS', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_MOD', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_ELI', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUARI_SEL', 'GRUP.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'GRUP.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'GRUP.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_ROL_SEL', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_INS', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_MOD', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_ELI', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_USUROL_SEL', 'GRUP.2.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GRU_SEL', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_INS', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_MOD', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_ELI', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SG_UEP_SEL', 'GRUP.2.1.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINPRES_IME', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_INS', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_MOD', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_ELI', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RETPRES_IME', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRESREP_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'PRECOM', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_INS', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_MOD', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_ELI', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'PRECOM.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_APRPRES_IME', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_INS', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_MOD', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_ELI', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RETPRES_IME', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRESREP_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'VBPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_INS', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_MOD', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_ELI', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'VBPRE.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTARPOBA_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_FINSOL_IME', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GETGES_ELI', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'COPRE', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_APRPRES_IME', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_GRU_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_INS', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_MOD', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_ELI', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRES_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_RETPRES_IME', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRESREP_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'COPRE.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CONSOL_IME', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_INS', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_MOD', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_ELI', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PRED_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'COPRE.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'COPRE.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'COPRE.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'COPRE.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'COPRE.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'COPRE.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'COPRE.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'COPRE.5.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'COPRE.5.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'COPRE.5.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSU_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SIGESOL_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_INS', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROC_MOD', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ASIGPROC_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_ANTESOL_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CATCOMP_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_INS', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_MOD', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_ELI', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOL_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'SOLPEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_ODT_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_INS', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_MOD', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_ELI', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'SOLPEN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'SOLPEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'SOLPEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'SOLPEN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'SOLPEN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'SOLPEN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'SOLPEN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'SOLPEN.3.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'SOLPEN.3.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_GATNREP_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_INS', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_MOD', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_ELI', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAOB_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_OBTTCB_GET', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_FINREG_IME', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEOB_IME', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_IDSEXT_GET', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTOC_REP', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_CTD_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTREP_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLREP_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLD_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_SOLDETCOT_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_IME', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_PROCPED_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COT_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTPROC_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('ADQ_COTRPC_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPAGOA', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CCFILDEP_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIG_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CONIGPP_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_CTA_ARB_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_PAR_ARB_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_AUXCTA_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_INS', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_MOD', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_ELI', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBDET_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CEC_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOM_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_CECCOMFU_SEL', 'OBPAGOA.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'OBPAGOA.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPAGOA.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPAGOA.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPAGOA.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPAGOA.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPAGOA.2.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DOCWFAR_MOD', 'OBPAGOA.2.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPGSEL_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_OBPG_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_COMEJEPAG_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_MONEDA_SEL', 'OBPAGOA.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PAFPP_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('CONTA_GETDEC_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PLT_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_CTABAN_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAPA_INS', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_INS', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_MOD', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_ELI', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPA_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_TIPES_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_FUNTIPES_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SINPRE_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_SIGEPP_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_ANTEPP_IME', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PLAPAREP_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.4', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPAGOA.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_MOD', 'OBPAGOA.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('TES_PRO_SEL', 'OBPAGOA.4.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPAGOA.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPAGOA.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPAGOA.4.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_MOD', 'OBPAGOA.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_ELI', 'OBPAGOA.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('WF_DWF_SEL', 'OBPAGOA.5', 'no');
select pxp.f_insert_tprocedimiento_gui ('PRE_VERPRE_SEL', 'OBPAGOA.6', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_LUG_ARB_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_INS', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_MOD', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_ELI', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEE_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PROVEEV_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.7', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEM_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SAL_ITMALM_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_SERVIC_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_INS', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_MOD', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_ELI', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PRITSE_SEL', 'OBPAGOA.7.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'OBPAGOA.7.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.7.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.8', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.8.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.8.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'OBPAGOA.8.2', 'no');
select pxp.f_insert_tgui_rol ('VBSOL', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.3', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.3.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.2', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.2.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.3.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.2', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.2.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBSOL.1', 'ADQ - Visto Bueno Sol');
select pxp.f_insert_tgui_rol ('VBCOT', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.3', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.2', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.2.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.3', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.3.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.2', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.2.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.2.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBCOT.1.1', 'ADQ - Visto Bueno OC/COT');
select pxp.f_insert_tgui_rol ('VBPRE', 'ADQ - VioBo Presolicitud');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - VioBo Presolicitud');
select pxp.f_insert_tgui_rol ('VBPRE.1', 'ADQ - VioBo Presolicitud');
select pxp.f_insert_tgui_rol ('ADQ.3', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.3', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.2', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.2.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.2', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.2.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ.3.1', 'ADQ - Solicitud de Compra');
select pxp.f_insert_tgui_rol ('PROC', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.4.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('PROC.1.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('SOLPEN.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('ADQ.4', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.2', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.2.1', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.1', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('ADQ.4.1.1', 'ADQ - Registro Proveedores');
select pxp.f_insert_tgui_rol ('PRECOM', 'ADQ - Presolicitud de Compra');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Presolicitud de Compra');
select pxp.f_insert_tgui_rol ('PRECOM.1', 'ADQ - Presolicitud de Compra');
select pxp.f_insert_tgui_rol ('COPRE', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.3', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.3.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.2', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.2.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.5.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.4', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.4.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.3', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.2', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.2.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('COPRE.1', 'ADQ - Consolidaro Presolicitudes');
select pxp.f_insert_tgui_rol ('PROC', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('ADQ', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.4.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.3.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('PROC.1.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.6', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.5', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.2', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA.1', 'ADQ - Aux Adquisiciones');
select pxp.f_insert_tgui_rol ('OBPAGOA', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.8.1.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.7.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.6', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.5', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.4.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.3.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.2', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.2.1', 'ADQ. RESP ADQ');
select pxp.f_insert_tgui_rol ('OBPAGOA.1', 'ADQ. RESP ADQ');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_TIPES_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_FUNTIPES_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SIGESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_ANTESOL_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_GATNREP_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_DEPFILUSU_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_CATCOMP_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_INS', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_MOD', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_ELI', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOL_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLREP_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLDETCOT_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PRE_VERPRE_IME', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_MONEDA_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_DEPUSUCOMB_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'RH_FUNCIOCAR_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'RH_UO_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'RH_INIUOARB_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEEV_SEL', 'VBSOL');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_SERVIC_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITEMNOTBASE_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_LUG_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_LUG_ARB_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_INS', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_MOD', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_ELI', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEE_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PROVEEV_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_SEL', 'VBSOL.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_INS', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_MOD', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_ELI', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_INSTIT_SEL', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_SEL', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_INS', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_MOD', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_ELI', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_INS', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_MOD', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSON_ELI', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_PERSONMIN_SEL', 'VBSOL.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SEG_UPFOTOPER_MOD', 'VBSOL.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITEM_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITEMNOTBASE_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'SAL_ITMALM_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_SERVIC_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_INS', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_MOD', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_ELI', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_PRITSE_SEL', 'VBSOL.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_MOD', 'VBSOL.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_ELI', 'VBSOL.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DWF_SEL', 'VBSOL.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'WF_DOCWFAR_MOD', 'VBSOL.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CCFILDEP_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CONIG_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CONIGPP_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'CONTA_ODT_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_INS', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_MOD', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_ELI', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLD_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'ADQ_SOLDETCOT_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CEC_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CECCOM_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno Sol', 'PM_CECCOMFU_SEL', 'VBSOL.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTRPC_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_GENOC_IME', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_PROCPED_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_SOLD_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_SOLDETCOT_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTPROC_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEEV_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_INS', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_MOD', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COT_ELI', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTOC_REP', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_COTREP_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_ANTEST_IME', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_MONEDA_SEL', 'VBCOT');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_TOTALADJ_IME', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_ADJDET_IME', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_SOLDETCOT_SEL', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_INS', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_MOD', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_ELI', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_CTD_SEL', 'VBCOT.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_MOD', 'VBCOT.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_ELI', 'VBCOT.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DWF_SEL', 'VBCOT.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'WF_DOCWFAR_MOD', 'VBCOT.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_SEL', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOLAR_SEL', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_INS', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_MOD', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOL_ELI', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEEV_SEL', 'VBCOT.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_SERVIC_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_LUG_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_LUG_ARB_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_INS', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_MOD', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_ELI', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEE_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PROVEEV_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_SEL', 'VBCOT.1.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_INS', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_MOD', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_ELI', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_INSTIT_SEL', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_SEL', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_INS', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_MOD', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_ELI', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_INS', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_MOD', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSON_ELI', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_PERSONMIN_SEL', 'VBCOT.1.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SEG_UPFOTOPER_MOD', 'VBCOT.1.2.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITEM_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITEMNOTBASE_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'SAL_ITMALM_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_SERVIC_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_INS', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_MOD', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_ELI', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'PM_PRITSE_SEL', 'VBCOT.1.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Visto Bueno OC/COT', 'ADQ_DOCSOLAR_MOD', 'VBCOT.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_APRPRES_IME', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_DEPFILUSU_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_GRU_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_INS', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_MOD', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_ELI', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRES_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_RETPRES_IME', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRESREP_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_DEPUSUCOMB_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'RH_FUNCIOCAR_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'RH_UO_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'RH_INIUOARB_SEL', 'VBPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CCFILDEP_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CONIGPP_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_INS', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_MOD', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_ELI', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'ADQ_PRED_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CEC_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CECCOM_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - VioBo Presolicitud', 'PM_CECCOMFU_SEL', 'VBPRE.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_OBTARPOBA_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_FINSOL_IME', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_GETGES_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_GATNREP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_DEPFILUSU_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_CATCOMP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_INS', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_MOD', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_ELI', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOL_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLREP_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLDETCOT_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PRE_VERPRE_IME', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_MONEDA_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_DEPUSUCOMB_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'RH_FUNCIOCAR_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'RH_UO_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'RH_INIUOARB_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEEV_SEL', 'ADQ.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_SERVIC_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEMNOTBASE_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_LUG_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_LUG_ARB_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_INS', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_MOD', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_ELI', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEE_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PROVEEV_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_SEL', 'ADQ.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_INS', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_MOD', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_ELI', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_INSTIT_SEL', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_SEL', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_INS', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_MOD', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_ELI', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_INS', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_MOD', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSON_ELI', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_PERSONMIN_SEL', 'ADQ.3.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SEG_UPFOTOPER_MOD', 'ADQ.3.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEM_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITEMNOTBASE_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'SAL_ITMALM_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_SERVIC_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_INS', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_MOD', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_ELI', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_PRITSE_SEL', 'ADQ.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_MOD', 'ADQ.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_ELI', 'ADQ.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DWF_SEL', 'ADQ.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'WF_DOCWFAR_MOD', 'ADQ.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CCFILDEP_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CONIG_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CONIGPP_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'CONTA_ODT_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_INS', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_MOD', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_ELI', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLD_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'ADQ_SOLDETCOT_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CEC_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CECCOM_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Solicitud de Compra', 'PM_CECCOMFU_SEL', 'ADQ.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_GATNREP_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_INS', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_MOD', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_ELI', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROCSOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROCPED_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_REVPRE_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_FINPRO_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTPROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTRPC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSUCOMB_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_OBEPUO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPFILEPUO_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_OBTTCB_GET', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_FINREGC_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SIGECOT_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ADJTODO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_HABPAG_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PREING_GEN', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTREP_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_INS', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_MOD', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_ELI', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTPROC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTRPC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTOC_REP', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ANTEST_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_TOTALADJ_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ADJDET_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_INS', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_MOD', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_ELI', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLCON_IME', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTOC_REP', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DOCWFAR_MOD', 'PROC.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CCFILDEP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIG_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIGPP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_ODT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_INS', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_MOD', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_ELI', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CEC_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOM_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOMFU_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPES_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_FUNTIPES_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSU_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SIGESOL_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_INS', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROC_MOD', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ASIGPROC_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_ANTESOL_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_GATNREP_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPFILUSU_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CATCOMP_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_INS', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_MOD', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_ELI', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOL_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLREP_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_IME', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSUCOMB_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIOCAR_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_UO_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_INIUOARB_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'SOLPEN');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_ARB_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_INS', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_MOD', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_ELI', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'SOLPEN.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_INS', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_MOD', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_ELI', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'SOLPEN.3.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_UPFOTOPER_MOD', 'SOLPEN.3.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEM_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITMALM_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_INS', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_MOD', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_ELI', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_SEL', 'SOLPEN.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'SOLPEN.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'SOLPEN.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'SOLPEN.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DOCWFAR_MOD', 'SOLPEN.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CCFILDEP_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIG_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIGPP_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_ODT_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_INS', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_MOD', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_ELI', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CEC_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOM_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOMFU_SEL', 'SOLPEN.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_LUG_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_LUG_ARB_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_INS', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_MOD', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_ELI', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'ADQ_PROVEE_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_SEL', 'ADQ.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_INS', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_MOD', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_ELI', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'PM_INSTIT_SEL', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_SEL', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_INS', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_MOD', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_ELI', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_INS', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_MOD', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSON_ELI', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_PERSONMIN_SEL', 'ADQ.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Registro Proveedores', 'SEG_UPFOTOPER_MOD', 'ADQ.4.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_FINPRES_IME', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_GETGES_ELI', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_DEPFILUSU_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_GRU_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_INS', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_MOD', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_ELI', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRES_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_RETPRES_IME', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRESREP_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_DEPUSUCOMB_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'RH_FUNCIOCAR_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'RH_UO_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'RH_INIUOARB_SEL', 'PRECOM');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CCFILDEP_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CONIGPP_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_INS', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_MOD', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_ELI', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'ADQ_PRED_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CEC_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CECCOM_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Presolicitud de Compra', 'PM_CECCOMFU_SEL', 'PRECOM.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_OBTARPOBA_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_FINSOL_IME', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_GETGES_ELI', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_GATNREP_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPFILUSU_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_CATCOMP_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_INS', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_MOD', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_ELI', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOL_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLREP_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLDETCOT_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PRE_VERPRE_IME', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_MONEDA_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPUSUCOMB_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_FUNCIOCAR_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_UO_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_INIUOARB_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEEV_SEL', 'COPRE');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_SERVIC_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITEMNOTBASE_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_LUG_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_LUG_ARB_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_INS', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_MOD', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_ELI', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEE_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PROVEEV_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_SEL', 'COPRE.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_INS', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_MOD', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_ELI', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_INSTIT_SEL', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_SEL', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_INS', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_MOD', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_ELI', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_INS', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_MOD', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSON_ELI', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_PERSONMIN_SEL', 'COPRE.5.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SEG_UPFOTOPER_MOD', 'COPRE.5.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITEM_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITEMNOTBASE_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'SAL_ITMALM_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_SERVIC_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_INS', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_MOD', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_ELI', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_PRITSE_SEL', 'COPRE.5.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DWF_MOD', 'COPRE.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DWF_ELI', 'COPRE.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DWF_SEL', 'COPRE.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'WF_DOCWFAR_MOD', 'COPRE.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CCFILDEP_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CONIG_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CONIGPP_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'CONTA_ODT_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_INS', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_MOD', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_ELI', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLD_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_SOLDETCOT_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CEC_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOM_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOMFU_SEL', 'COPRE.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_APRPRES_IME', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPFILUSU_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_GRU_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_INS', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_MOD', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_ELI', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRES_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_RETPRES_IME', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRESREP_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_DEPUSUCOMB_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_FUNCIOCAR_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_UO_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'RH_INIUOARB_SEL', 'COPRE.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_CONSOL_IME', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CCFILDEP_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CONIGPP_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_INS', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_MOD', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_ELI', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'ADQ_PRED_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CEC_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOM_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Consolidaro Presolicitudes', 'PM_CECCOMFU_SEL', 'COPRE.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_GATNREP_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_INS', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_MOD', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_ELI', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROCSOL_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROCPED_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_REVPRE_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_FINPRO_IME', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTPROC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTRPC_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_DEPUSUCOMB_SEL', 'PROC');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_OBEPUO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_DEPFILEPUO_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_OBTTCB_GET', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_FINREGC_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SIGECOT_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_ADJTODO_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_HABPAG_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PREING_GEN', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTREP_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEEV_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_INS', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_MOD', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_ELI', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTPROC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTRPC_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTOC_REP', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_ANTEST_IME', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_MONEDA_SEL', 'PROC.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_TOTALADJ_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_ADJDET_IME', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_INS', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_MOD', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_ELI', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'PROC.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLCON_IME', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTOC_REP', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'PROC.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'PROC.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DOCWFAR_MOD', 'PROC.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CCFILDEP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIG_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIGPP_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_ODT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_INS', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_MOD', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_ELI', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CEC_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOM_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOMFU_SEL', 'PROC.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_GATNREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_INS', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_MOD', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_ELI', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPGSEL_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAOB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_OBTTCB_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_FINREG_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_ANTEOB_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_IDSEXT_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTOC_REP', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_CTD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_SOLDETCOT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_PROCPED_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTPROC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'ADQ_COTRPC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_DEPUSUCOMB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_MONEDA_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEEV_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIOCAR_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_INS', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_MOD', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_ELI', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIO_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'RH_FUNCIOCAR_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_INS', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_MOD', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_ELI', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_INS', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_MOD', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_ELI', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'OR_FUNCUE_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_INS', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_MOD', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_ELI', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_SERVIC_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_LUG_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_LUG_ARB_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_INS', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_MOD', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_ELI', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PROVEEV_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_INS', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_MOD', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_ELI', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_INSTIT_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_INS', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_MOD', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_ELI', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_INS', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_MOD', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSON_ELI', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SEG_UPFOTOPER_MOD', 'OBPAGOA.7.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITEM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'SAL_ITMALM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_SERVIC_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_INS', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_MOD', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_ELI', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PRITSE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_SEL', 'OBPAGOA.6');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PAFPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_GETDEC_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PLT_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_CTABAN_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_MOD', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_ELI', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_TIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_FUNTIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SINPRE_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SIGEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_ANTEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAREP_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_MOD', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_SEL', 'OBPAGOA.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPGSEL_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBPG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_COMEJEPAG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_MONEDA_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAREP_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PAFPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_GETDEC_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_PLT_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_CTABAN_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_MOD', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_ELI', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PLAPA_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_TIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_FUNTIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SINPRE_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_SIGEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_ANTEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_MOD', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_ELI', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DWF_SEL', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'WF_DOCWFAR_MOD', 'OBPAGOA.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_MOD', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_PRO_SEL', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_VERPRE_SEL', 'OBPAGOA.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CCFILDEP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIG_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CONIGPP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_CTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_CTA_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_PAR_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PRE_PAR_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'CONTA_AUXCTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_INS', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_MOD', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_ELI', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'TES_OBDET_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CEC_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOM_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ - Aux Adquisiciones', 'PM_CECCOMFU_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_GATNREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_INS', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_MOD', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_ELI', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPGSEL_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAOB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_OBTTCB_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_FINREG_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_ANTEOB_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_IDSEXT_GET', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTOC_REP', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_CTD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLREP_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLD_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_SOLDETCOT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_IME', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_PROCPED_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COT_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTPROC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'ADQ_COTRPC_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_DEPUSUCOMB_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIOCAR_SEL', 'OBPAGOA');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_INS', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_MOD', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_ELI', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIO_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'RH_FUNCIOCAR_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_INS', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_MOD', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_ELI', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'OR_FUNCUE_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.8.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_INS', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_MOD', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_ELI', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.8.1.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_LUG_ARB_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_INS', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_MOD', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_ELI', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEE_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PROVEEV_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.7');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_INS', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_MOD', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_ELI', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_INSTIT_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_INS', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_MOD', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSON_ELI', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_PERSONMIN_SEL', 'OBPAGOA.7.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SEG_UPFOTOPER_MOD', 'OBPAGOA.7.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITEMNOTBASE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'SAL_ITMALM_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_SERVIC_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_INS', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_MOD', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_ELI', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PRITSE_SEL', 'OBPAGOA.7.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_SEL', 'OBPAGOA.6');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'OBPAGOA.5');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PAFPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_GETDEC_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PLT_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_CTABAN_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_INS', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_MOD', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_ELI', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_FUNTIPES_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SINPRE_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SIGEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_ANTEPP_IME', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAREP_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.4');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'OBPAGOA.4.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_MOD', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.4.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_SEL', 'OBPAGOA.4.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPGSEL_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBPG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_COMEJEPAG_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_MONEDA_SEL', 'OBPAGOA.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAREP_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PAFPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_GETDEC_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_PLT_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_CTABAN_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_INS', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_MOD', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_ELI', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PLAPA_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_TIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_FUNTIPES_SEL', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SINPRE_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_SIGEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_ANTEPP_IME', 'OBPAGOA.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_MOD', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_ELI', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DWF_SEL', 'OBPAGOA.2.3');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'WF_DOCWFAR_MOD', 'OBPAGOA.2.3.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_MOD', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_PRO_SEL', 'OBPAGOA.2.2');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_VERPRE_SEL', 'OBPAGOA.2.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CCFILDEP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIG_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CONIGPP_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_CTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_CTA_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_PAR_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PRE_PAR_ARB_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'CONTA_AUXCTA_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_INS', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_MOD', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_ELI', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'TES_OBDET_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CEC_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOM_SEL', 'OBPAGOA.1');
select pxp.f_insert_trol_procedimiento_gui ('ADQ. RESP ADQ', 'PM_CECCOMFU_SEL', 'OBPAGOA.1');

/***********************************F-DEP-RAC-ADQ-00-03/02/2014*****************************************/


/***********************************I-DEP-JRR-PLANI-0-23/02/2014****************************************/


ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT fk__tprorrateo__id_funcionario_planilla FOREIGN KEY (id_funcionario_planilla)
    REFERENCES plani.tfuncionario_planilla(id_funcionario_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT fk__tprorrateo__id_horas_trabajadas FOREIGN KEY (id_horas_trabajadas)
    REFERENCES plani.thoras_trabajadas(id_horas_trabajadas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT fk__tprorrateo__id_presupuesto FOREIGN KEY (id_presupuesto)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT fk__tprorrateo__id_cc FOREIGN KEY (id_cc)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tprorrateo_columna
  ADD CONSTRAINT fk__tprorrateo_columna__id_prorrateo FOREIGN KEY (id_prorrateo)
    REFERENCES plani.tprorrateo(id_prorrateo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE plani.tprorrateo_columna
  ADD CONSTRAINT fk__tprorrateo_columna__id_tipo_columna FOREIGN KEY (id_tipo_columna)
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tconsolidado
  ADD CONSTRAINT fk__tconsolidado__id_planilla FOREIGN KEY (id_planilla)
    REFERENCES plani.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE plani.tconsolidado
  ADD CONSTRAINT fk__tconsolidado__id_presupuesto FOREIGN KEY (id_presupuesto)
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tconsolidado
  ADD CONSTRAINT fk__tconsolidado__id_cc FOREIGN KEY (id_cc)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tconsolidado_columna
  ADD CONSTRAINT fk__tconsolidado_columna__id_consolidado FOREIGN KEY (id_consolidado)
    REFERENCES plani.tconsolidado(id_consolidado)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE plani.tconsolidado_columna
  ADD CONSTRAINT fk__tconsolidado_columna__id_tipo_columna FOREIGN KEY (id_tipo_columna)
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tconsolidado_columna
  ADD CONSTRAINT fk__tconsolidado_columna__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tconsolidado_columna
  ADD CONSTRAINT fk__tconsolidado_columna__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tconsolidado_columna
  ADD CONSTRAINT fk__tconsolidado_columna__id_auxiliar FOREIGN KEY (id_auxiliar)
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

    
/***********************************F-DEP-JRR-PLANI-0-23/02/2014****************************************/



/***********************************I-DEP-JRR-PLANI-0-24/04/2014****************************************/

select pxp.f_insert_testructura_gui ('REGPLAN.1', 'REGPLAN');
select pxp.f_insert_testructura_gui ('REGPLAN.2', 'REGPLAN');
select pxp.f_insert_testructura_gui ('REGPLAN.3', 'REGPLAN');
select pxp.f_insert_testructura_gui ('REGPLAN.2.1', 'REGPLAN.2');
select pxp.f_insert_testructura_gui ('REGPLAN.2.2', 'REGPLAN.2');
select pxp.f_insert_testructura_gui ('REGPLAN.2.2.1', 'REGPLAN.2.2');
select pxp.f_insert_testructura_gui ('REGPLAN.2.2.2', 'REGPLAN.2.2');
select pxp.f_insert_testructura_gui ('REGPLAN.2.2.1.1', 'REGPLAN.2.2.1');
select pxp.f_insert_testructura_gui ('REGPLAN.2.2.1.1.1', 'REGPLAN.2.2.1.1');
select pxp.f_insert_testructura_gui ('REGPLAN.2.2.1.1.1.1', 'REGPLAN.2.2.1.1.1');
select pxp.f_insert_testructura_gui ('REGPLAN.3.1', 'REGPLAN.3');
select pxp.f_insert_testructura_gui ('FUNPLAN.4.1', 'FUNPLAN.4');
select pxp.f_insert_testructura_gui ('REGPLAN.2.2.2.1', 'REGPLAN.2.2.2');
select pxp.f_insert_testructura_gui ('REGPLAN.3.1.1', 'REGPLAN.3.1');
select pxp.f_insert_testructura_gui ('REGPLAN.3.1.2', 'REGPLAN.3.1');
select pxp.f_insert_testructura_gui ('REGPLAN.3.1.1.1', 'REGPLAN.3.1.1');
select pxp.f_insert_testructura_gui ('REGPLAN.3.1.1.1.1', 'REGPLAN.3.1.1.1');
select pxp.f_insert_testructura_gui ('REGPLAN.3.1.1.1.1.1', 'REGPLAN.3.1.1.1.1');
select pxp.f_insert_testructura_gui ('REGPLAN.3.1.2.1', 'REGPLAN.3.1.2');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPFILUSU_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_TIPPLA_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANI_INS', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANI_MOD', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANI_ELI', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANI_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANIGENHOR_MOD', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANIVALHOR_MOD', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANICALCOL_MOD', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_PLANIVALCOL_MOD', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_DEPUSUCOMB_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_GES_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_PER_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_UO_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_INIUOARB_SEL', 'REGPLAN', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_HORTRA_INS', 'REGPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_HORTRA_MOD', 'REGPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_HORTRA_ELI', 'REGPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_HORTRA_SEL', 'REGPLAN.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_INS', 'REGPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_MOD', 'REGPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_ELI', 'REGPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_SEL', 'REGPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'REGPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'REGPLAN.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_COLVAL_INS', 'REGPLAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_COLVAL_MOD', 'REGPLAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_COLVAL_ELI', 'REGPLAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_COLVAL_SEL', 'REGPLAN.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'REGPLAN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'REGPLAN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'REGPLAN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'REGPLAN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'REGPLAN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'REGPLAN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'REGPLAN.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'REGPLAN.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'REGPLAN.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'REGPLAN.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'REGPLAN.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'REGPLAN.2.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'REGPLAN.2.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'REGPLAN.2.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'REGPLAN.2.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'REGPLAN.2.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.2.2.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'REGPLAN.2.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'REGPLAN.2.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'REGPLAN.2.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.2.2.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'REGPLAN.2.2.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'REGPLAN.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'REGPLAN.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'REGPLAN.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.2.2.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_INS', 'REGPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_MOD', 'REGPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_ELI', 'REGPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('PLA_FUNPLAN_SEL', 'REGPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'REGPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'REGPLAN.3', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_INS', 'REGPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_MOD', 'REGPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_ELI', 'REGPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIO_SEL', 'REGPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'REGPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'REGPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.3.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'FUNPLAN.4.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'REGPLAN.2.2.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_INS', 'REGPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_MOD', 'REGPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_ELI', 'REGPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_FUNCUE_SEL', 'REGPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'REGPLAN.3.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_INS', 'REGPLAN.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_MOD', 'REGPLAN.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_ELI', 'REGPLAN.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('PM_INSTIT_SEL', 'REGPLAN.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_SEL', 'REGPLAN.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.3.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'REGPLAN.3.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'REGPLAN.3.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'REGPLAN.3.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.3.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'REGPLAN.3.1.1.1.1.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_INS', 'REGPLAN.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_MOD', 'REGPLAN.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSON_ELI', 'REGPLAN.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_PERSONMIN_SEL', 'REGPLAN.3.1.2', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'REGPLAN.3.1.2.1', 'no');

/***********************************F-DEP-JRR-PLANI-0-24/04/2014****************************************/

/***********************************I-DEP-JRR-PLANI-0-05/06/2014****************************************/

ALTER TABLE plani.tfuncionario_planilla
  ADD CONSTRAINT uk_tfuncionario_planilla__id_funcionario__id_planilla 
    UNIQUE (id_planilla, id_funcionario);    
    
CREATE INDEX tcolumna_valor_idx1 ON plani.tcolumna_valor
  USING btree (id_funcionario_planilla);  
  
CREATE INDEX tcolumna_valor_idx2 ON plani.tcolumna_valor
  USING btree (id_tipo_columna);  
  
CREATE INDEX ttipo_columna_idx1 ON plani.ttipo_columna
  USING btree (orden);
  
 CREATE INDEX tfuncionario_planilla_idx1 ON plani.tfuncionario_planilla
  USING btree (id_uo_funcionario);
  
 CREATE INDEX thoras_trabajadas_idx1 ON plani.thoras_trabajadas
  USING btree (id_funcionario_planilla);

/***********************************F-DEP-JRR-PLANI-0-05/06/2014****************************************/

/***********************************I-DEP-JRR-PLANI-0-10/07/2014****************************************/
ALTER TABLE plani.tfuncionario_planilla
  ADD CONSTRAINT fk__tfuncionario_planilla__id_afp FOREIGN KEY (id_afp)
    REFERENCES plani.tfuncionario_afp(id_funcionario_afp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tfuncionario_planilla
  ADD CONSTRAINT fk_tfuncionario_planilla__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES orga.tfuncionario_cuenta_bancaria(id_funcionario_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/***********************************F-DEP-JRR-PLANI-0-10/07/2014****************************************/

/***********************************I-DEP-JRR-PLANI-0-11/07/2014****************************************/




ALTER TABLE plani.tobligacion 
  ADD CONSTRAINT fk_tobligacion__id_tipo_obligacion FOREIGN KEY (id_tipo_obligacion) 
    REFERENCES plani.ttipo_obligacion(id_tipo_obligacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

ALTER TABLE plani.tobligacion 
  ADD CONSTRAINT fk_tobligacion__id_planilla FOREIGN KEY (id_planilla) 
    REFERENCES plani.tplanilla(id_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tobligacion 
  ADD CONSTRAINT fk_tobligacion__id_cuenta FOREIGN KEY (id_cuenta) 
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tobligacion 
  ADD CONSTRAINT fk_tobligacion__id_auxiliar FOREIGN KEY (id_auxiliar) 
    REFERENCES conta.tauxiliar(id_auxiliar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;



ALTER TABLE plani.tobligacion_columna 
  ADD CONSTRAINT fk_tobligacion_columna__id_obligacion FOREIGN KEY (id_obligacion) 
    REFERENCES plani.tobligacion (id_obligacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

ALTER TABLE plani.tobligacion_columna 
  ADD CONSTRAINT fk_tobligacion_columna__id_tipo_columna FOREIGN KEY (id_tipo_columna) 
    REFERENCES plani.ttipo_columna(id_tipo_columna)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tobligacion_columna 
  ADD CONSTRAINT fk_tobligacion_columna__id_cc FOREIGN KEY (id_cc) 
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tobligacion_columna 
  ADD CONSTRAINT fk_tobligacion_columna__id_presupuesto FOREIGN KEY (id_presupuesto) 
    REFERENCES pre.tpresupuesto(id_presupuesto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;




ALTER TABLE plani.tdetalle_transferencia 
  ADD CONSTRAINT fk_tdetalle_transferencia__id_obligacion FOREIGN KEY (id_obligacion) 
    REFERENCES plani.tobligacion (id_obligacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    

ALTER TABLE plani.tdetalle_transferencia 
  ADD CONSTRAINT fk_tdetalle_transferencia__id_institucion FOREIGN KEY (id_institucion) 
    REFERENCES param.tinstitucion(id_institucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tdetalle_transferencia 
  ADD CONSTRAINT fk_tdetalle_transferencia__id_funcionario FOREIGN KEY (id_funcionario) 
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/***********************************F-DEP-JRR-PLANI-0-11/07/2014****************************************/

/***********************************I-DEP-JRR-PLANI-0-17/11/2014****************************************/
ALTER TABLE plani.tobligacion 
  ADD CONSTRAINT fk_tobligacion__id_obligacion_pago FOREIGN KEY (id_obligacion_pago) 
    REFERENCES tes.tobligacion_pago(id_obligacion_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tconsolidado_columna 
  ADD CONSTRAINT fk_tconsolidado_columna__id_obligacion_det FOREIGN KEY (id_obligacion_det) 
    REFERENCES tes.tobligacion_det(id_obligacion_det)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tobligacion 
  ADD CONSTRAINT fk_tobligacion__id_plan_pago FOREIGN KEY (id_plan_pago) 
    REFERENCES tes.tplan_pago(id_plan_pago)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/***********************************F-DEP-JRR-PLANI-0-17/11/2014****************************************/

/***********************************I-DEP-JRR-PLANI-0-25/11/2014****************************************/
CREATE OR REPLACE VIEW plani.vcomp_dev_planilla(
    id_plan_pago,
    id_moneda,
    id_depto_conta,
    numero,
    fecha_actual,
    estado,
    monto_ejecutar_total_mb,
    monto_ejecutar_total_mo,
    monto,
    monto_mb,
    monto_retgar_mb,
    monto_retgar_mo,
    monto_no_pagado,
    monto_no_pagado_mb,
    otros_descuentos,
    otros_descuentos_mb,
    id_plantilla,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    nro_cheque,
    nro_cuenta_bancaria,
    num_tramite,
    tipo,
    id_gestion_cuentas,
    id_int_comprobante,
    liquido_pagable,
    liquido_pagable_mb,
    nombre_pago,
    porc_monto_excento_var,
    obs_pp,
    descuento_anticipo,
    descuento_inter_serv,
    tipo_obligacion,
    id_proceso_wf,
    forma_pago,
    monto_ajuste_ag,
    monto_ajuste_siguiente_pago,
    monto_anticipo,
    desc_planilla,
    id_planilla,
    id_centro_costo_depto)
AS
  SELECT pp.id_plan_pago,
         op.id_moneda,
         op.id_depto_conta,
         op.numero,
         now() AS fecha_actual,
         pp.estado,
         pp.monto_ejecutar_total_mb,
         pp.monto_ejecutar_total_mo,
         pp.monto,
         pp.monto_mb,
         pp.monto_retgar_mb,
         pp.monto_retgar_mo,
         pp.monto_no_pagado,
         pp.monto_no_pagado_mb,
         pp.otros_descuentos,
         pp.otros_descuentos_mb,
         pp.id_plantilla,
         pp.id_cuenta_bancaria,
         pp.id_cuenta_bancaria_mov,
         pp.nro_cheque,
         pp.nro_cuenta_bancaria,
         op.num_tramite,
         pp.tipo,
         op.id_gestion AS id_gestion_cuentas,
         pp.id_int_comprobante,
         pp.liquido_pagable,
         pp.liquido_pagable_mb,
         pp.nombre_pago,
         pp.porc_monto_excento_var,
         ((COALESCE(op.numero, '' ::character varying) ::text || ' ' ::text) ||
          COALESCE(pp.obs_monto_no_pagado, '' ::text)) ::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         pp.id_proceso_wf,
         pp.forma_pago,
         pp.monto_ajuste_ag,
         pp.monto_ajuste_siguiente_pago,
         pp.monto_anticipo,
         ((tp.nombre::text || ' correspondiente a : ' ::text) || COALESCE(
         per.periodo || '/' ::text, '' ::text)) || ges.gestion AS desc_planilla,
         pla.id_planilla,
         (
           SELECT f_get_config_relacion_contable.ps_id_centro_costo
           FROM conta.f_get_config_relacion_contable('CCDEPCON' ::character
            varying, pla.id_gestion, op.id_depto_conta)
             f_get_config_relacion_contable(ps_id_cuenta, ps_id_auxiliar,
              ps_id_partida, ps_id_centro_costo, ps_nombre_tipo_relacion)
         ) AS id_centro_costo_depto
  FROM tes.tplan_pago pp
       JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago =
        op.id_obligacion_pago
       JOIN plani.tplanilla pla ON pla.id_obligacion_pago =
        op.id_obligacion_pago
       LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
        pla.id_tipo_planilla;

CREATE OR REPLACE VIEW plani.vcomp_dev_det_planilla(
    id_concepto_ingas,
    id_partida,
    id_partida_ejecucion_com,
    monto_pago_mo,
    monto_pago_mb,
    id_centro_costo,
    descripcion,
    id_plan_pago,
    id_prorrateo,
    id_int_transaccion,
    id_orden_trabajo,
    id_cuenta,
    id_auxiliar)
AS
  SELECT od.id_concepto_ingas,
         od.id_partida,
         od.id_partida_ejecucion_com,
         pro.monto_ejecutar_mo AS monto_pago_mo,
         pro.monto_ejecutar_mb AS monto_pago_mb,
         od.id_centro_costo,
         od.descripcion,
         pro.id_plan_pago,
         pro.id_prorrateo,
         pro.id_int_transaccion,
         od.id_orden_trabajo,
         od.id_cuenta,
         od.id_auxiliar
  FROM tes.tprorrateo pro
       JOIN tes.tobligacion_det od ON od.id_obligacion_det =
        pro.id_obligacion_det;
        
CREATE OR REPLACE VIEW plani.vobligacion(
    id_obligacion,
    id_plan_pago,
    id_planilla,
    acreedor,
    descripcion,
    id_cuenta,
    id_auxiliar,
    id_partida,
    tipo_obligacion,
    desc_planilla,
    periodo,
    gestion,
    monto_obligacion,
    id_plan_pago_devengado)
AS
  SELECT ob.id_obligacion,
         ob.id_plan_pago,
         ob.id_planilla,
         ob.acreedor,
         ob.descripcion,
         ob.id_cuenta,
         ob.id_auxiliar,
         ob.id_partida,
         tob.tipo_obligacion,
         ((tp.nombre::text || ' correspondiente a : ' ::text) || COALESCE(
         per.periodo || '/' ::text, '' ::text)) || ges.gestion AS desc_planilla,
         per.periodo,
         ges.gestion,
         ob.monto_obligacion,
         pp.id_plan_pago AS id_plan_pago_devengado
  FROM plani.tobligacion ob
       JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion =
        ob.id_tipo_obligacion
       JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
       JOIN tes.tobligacion_pago op ON op.id_obligacion_pago =
        pla.id_obligacion_pago
       JOIN tes.tplan_pago pp ON pp.id_obligacion_pago = op.id_obligacion_pago
        AND pp.tipo::text = 'devengado_rrhh' ::text AND pp.estado_reg::text =
         'activo' ::text AND pp.estado::text <> 'anulado' ::text
       LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
        pla.id_tipo_planilla;
        
CREATE OR REPLACE VIEW plani.vobligacion_haber(
    id_obligacion,
    id_plan_pago,
    id_planilla,
    acreedor,
    descripcion,
    id_cuenta,
    id_auxiliar,
    id_partida,
    tipo_obligacion,
    desc_planilla,
    periodo,
    gestion,
    monto_obligacion)
AS
  SELECT ob.id_obligacion,
         ob.id_plan_pago,
         ob.id_planilla,
         ob.acreedor,
         ob.descripcion,
         ob.id_cuenta,
         ob.id_auxiliar,
         ob.id_partida,
         tob.tipo_obligacion,
         ((tp.nombre::text || ' correspondiente a : ' ::text) || COALESCE(
         per.periodo || '/' ::text, '' ::text)) || ges.gestion AS desc_planilla,
         per.periodo,
         ges.gestion,
         ob.monto_obligacion
  FROM plani.tobligacion ob
       JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion =
        ob.id_tipo_obligacion
       JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
       LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
        pla.id_tipo_planilla;
        
CREATE OR REPLACE VIEW plani.vobligacion_pago(
    id_plan_pago,
    id_planilla,
    id_cuenta,
    id_auxiliar,
    id_partida,
    nombre,
    periodo,
    gestion,
    monto_obligacion)
AS
  SELECT ob.id_plan_pago,
         ob.id_planilla,
         ob.id_cuenta,
         ob.id_auxiliar,
         ob.id_partida,
         tob.nombre,
         per.periodo,
         ges.gestion,
         sum(ob.monto_obligacion) AS monto_obligacion
  FROM plani.tobligacion ob
       JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion =
        ob.id_tipo_obligacion
       JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
       JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
        pla.id_tipo_planilla
  GROUP BY ob.id_plan_pago,
           ob.id_planilla,
           ob.id_cuenta,
           ob.id_auxiliar,
           ob.id_partida,
           tob.nombre,
           per.periodo,
           ges.gestion;


ALTER TABLE plani.tobligacion 
  ADD CONSTRAINT fk_tobligacion__id_afp FOREIGN KEY (id_afp) 
    REFERENCES plani.tafp(id_afp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
       
/***********************************F-DEP-JRR-PLANI-0-25/11/2014****************************************/


/***********************************I-DEP-JRR-PLANI-0-03/12/2014****************************************/

CREATE OR REPLACE VIEW plani.vplanilla(
    id_usuario_reg,
    id_usuario_mod,
    fecha_reg,
    fecha_mod,
    estado_reg,
    id_planilla,
    id_gestion,
    id_depto,
    id_periodo,
    nro_planilla,
    id_uo,
    id_tipo_planilla,
    observaciones,
    id_proceso_macro,
    id_proceso_wf,
    id_estado_wf,
    estado,
    id_usuario_ai,
    usuario_ai,
    requiere_calculo,
    id_obligacion_pago,
    calculo_horas,
    codigo,
    nombre,
    periodicidad,
    gestion,
    fecha_ini,
    fecha_fin)
AS
  SELECT pl.id_usuario_reg,
         pl.id_usuario_mod,
         pl.fecha_reg,
         pl.fecha_mod,
         pl.estado_reg,
         pl.id_planilla,
         pl.id_gestion,
         pl.id_depto,
         pl.id_periodo,
         pl.nro_planilla,
         pl.id_uo,
         pl.id_tipo_planilla,
         pl.observaciones,
         pl.id_proceso_macro,
         pl.id_proceso_wf,
         pl.id_estado_wf,
         pl.estado,
         pl.id_usuario_ai,
         pl.usuario_ai,
         pl.requiere_calculo,
         pl.id_obligacion_pago,
         tp.calculo_horas,
         tp.codigo,
         tp.nombre,
         tp.periodicidad,
         ges.gestion,
         per.fecha_ini,
         per.fecha_fin
  FROM plani.tplanilla pl
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = pl.id_tipo_planilla
       LEFT JOIN param.tperiodo per ON per.id_periodo = pl.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pl.id_gestion;
       
ALTER TABLE plani.tcolumna_detalle
  ADD CONSTRAINT fk_tcolumna_detalle__id_horas_trabajadas FOREIGN KEY (id_horas_trabajadas) 
    REFERENCES plani.thoras_trabajadas(id_horas_trabajadas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE plani.tcolumna_detalle
  ADD CONSTRAINT fk_tcolumna_detalle__columna_valor FOREIGN KEY (id_columna_valor) 
    REFERENCES plani.tcolumna_valor(id_columna_valor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
       
/***********************************F-DEP-JRR-PLANI-0-03/12/2014****************************************/