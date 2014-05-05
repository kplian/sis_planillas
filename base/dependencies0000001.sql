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


