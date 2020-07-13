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

/***********************************I-DEP-JRR-PLANI-0-29/07/2015****************************************/
ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT fk_tprorrateo__id_oficina FOREIGN KEY (id_oficina)
    REFERENCES orga.toficina(id_oficina)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT fk_tprorrateo__id_lugar FOREIGN KEY (id_lugar)
    REFERENCES param.tlugar(id_lugar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tprorrateo_columna
  ADD CONSTRAINT fk_tprorrateo_columna__id_oficina FOREIGN KEY (id_oficina)
    REFERENCES orga.toficina(id_oficina)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE plani.tprorrateo
  ADD CONSTRAINT fk_tprorrateo_columna__id_lugar FOREIGN KEY (id_lugar)
    REFERENCES param.tlugar(id_lugar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-JRR-PLANI-0-29/07/2015****************************************/

/***********************************I-DEP-JRR-PLANI-0-22/09/2015****************************************/

ALTER TABLE plani.tplanilla_sigma
  ADD CONSTRAINT fk_tplanilla_sigma__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tplanilla_sigma
  ADD CONSTRAINT fk_tplanilla_sigma__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tplanilla_sigma
  ADD CONSTRAINT fk_tplanilla_sigma__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

 ALTER TABLE plani.tplanilla_sigma
  ADD CONSTRAINT fk_tplanilla_sigma__id_tipo_planilla FOREIGN KEY (id_tipo_planilla)
    REFERENCES plani.ttipo_planilla(id_tipo_planilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


/***********************************F-DEP-JRR-PLANI-0-22/09/2015****************************************/

/***********************************I-DEP-JRR-PLANI-0-29/10/2015****************************************/

ALTER TABLE plani.tlicencia
  ADD CONSTRAINT fk_tlicencia__id_tipo_licencia FOREIGN KEY (id_tipo_licencia)
    REFERENCES plani.ttipo_licencia(id_tipo_licencia)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-JRR-PLANI-0-29/10/2015****************************************/

/***********************************I-DEP-JRR-PLANI-0-28/04/2016****************************************/

DROP VIEW IF EXISTS plani.vcomp_dev_planilla;
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
         op.fecha,
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
         ((COALESCE(op.numero, ''::character varying)::text || ' '::text) ||
           COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS
           obs_pp,
         pp.descuento_anticipo,
         pp.descuento_inter_serv,
         op.tipo_obligacion,
         pp.id_proceso_wf,
         pp.forma_pago,
         pp.monto_ajuste_ag,
         pp.monto_ajuste_siguiente_pago,
         pp.monto_anticipo,
         ((tp.nombre::text || ' correspondiente a : '::text) || COALESCE(
           per.periodo || '/'::text, ''::text)) || ges.gestion AS desc_planilla,
         pla.id_planilla,
         (
           SELECT f_get_config_relacion_contable.ps_id_centro_costo
           FROM conta.f_get_config_relacion_contable('CCDEPCON'::character
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

/***********************************F-DEP-JRR-PLANI-0-28/04/2016****************************************/

/***********************************I-DEP-JRR-PLANI-0-25/04/2016****************************************/
DROP VIEW IF EXISTS plani.vcomp_planilla;
CREATE OR REPLACE VIEW plani.vcomp_planilla(
    id_planilla,
    id_depto_conta,
    nro_tramite,
    desc_planilla,
    obs,
    id_moneda,
    fecha_planilla,
    id_gestion_contable,
    id_gestion,
    monto,
    id_centro_costo_depto,
    nombre_pago)
AS
  SELECT pla.id_planilla,
         dcon.id_depto AS id_depto_conta,
         pw.nro_tramite,
         ((tp.nombre::text || ' correspondiente a : '::text) || COALESCE(
           per.periodo || '/'::text, ''::text)) || ges.gestion AS desc_planilla,
         pla.nro_planilla AS obs,
         param.f_get_moneda_base() AS id_moneda,
         pla.fecha_planilla,
         (
           SELECT f_get_periodo_gestion.po_id_gestion
           FROM param.f_get_periodo_gestion(pla.fecha_planilla)
             f_get_periodo_gestion(po_id_periodo, po_id_gestion,
             po_id_periodo_subsistema)
         ) AS id_gestion_contable,
         pla.id_gestion,
         sum(concol.valor) AS monto,
         (
           SELECT f_get_config_relacion_contable.ps_id_centro_costo
           FROM conta.f_get_config_relacion_contable('CCDEPCON'::character
             varying, (
                        SELECT f_get_periodo_gestion.po_id_gestion
                        FROM param.f_get_periodo_gestion(pla.fecha_planilla)
                          f_get_periodo_gestion(po_id_periodo, po_id_gestion,
                          po_id_periodo_subsistema)
                ), dcon.id_depto, NULL::integer,
                  'No existe presupuesto administrativo relacionado al departamento de RRHH'
                  ::character varying) f_get_config_relacion_contable(
                  ps_id_cuenta, ps_id_auxiliar, ps_id_partida,
                  ps_id_centro_costo, ps_nombre_tipo_relacion)
         ) AS id_centro_costo_depto,
         tp.nombre as nombre_pago
  FROM plani.tplanilla pla
       JOIN wf.tproceso_wf pw ON pw.id_proceso_wf = pla.id_proceso_wf
       JOIN plani.tconsolidado con ON con.id_planilla = pla.id_planilla
       JOIN plani.tconsolidado_columna concol ON concol.id_consolidado =
         con.id_consolidado
       LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
         pla.id_tipo_planilla
       JOIN param.tdepto dep ON dep.id_depto = pla.id_depto
       LEFT JOIN param.tdepto_depto rel ON rel.id_depto_origen = dep.id_depto
       LEFT JOIN param.tdepto dcon ON dcon.id_depto = rel.id_depto_destino
       LEFT JOIN segu.tsubsistema sub ON sub.id_subsistema = dcon.id_subsistema
         AND sub.codigo::text = 'CONTA'::text
  GROUP BY pla.id_planilla,
           dcon.id_depto,
           pw.nro_tramite,
           tp.nombre,
           per.periodo,
           ges.gestion,
           pla.nro_planilla,
           pla.fecha_planilla,
           pla.id_gestion;


DROP VIEW IF EXISTS plani.vcomp_planilla_det;
CREATE OR REPLACE VIEW plani.vcomp_planilla_det(
    id_consolidado_columna,
    id_consolidado,
    id_planilla,
    monto,
    monto_presupuestario,
    id_cc,
    id_presupuesto,
    descripcion_columna,
    id_cuenta,
    id_partida,
    id_auxiliar)
AS
  SELECT concol.id_consolidado_columna,
         concol.id_consolidado,
         con.id_planilla,
         concol.valor AS monto,
         concol.valor_ejecutado AS monto_presupuestario,
         con.id_cc,
         con.id_presupuesto,
         ((tc.nombre::text || '. Personal '::text) || tipcon.nombre::text)::
           character varying AS descripcion_columna,
           concol.id_cuenta,
           concol.id_partida,
           concol.id_auxiliar
  FROM plani.tconsolidado con
       JOIN plani.tconsolidado_columna concol ON concol.id_consolidado =
         con.id_consolidado
       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
         concol.id_tipo_columna
       JOIN orga.ttipo_contrato tipcon ON tipcon.codigo::text =
         concol.tipo_contrato::text;

ALTER TABLE plani.tplanilla
  ADD CONSTRAINT fk_tplanilla__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE plani.tconsolidado_columna
  ADD CONSTRAINT fk_tconsolidado_columna__id_int_transaccion FOREIGN KEY (id_int_transaccion)
    REFERENCES conta.tint_transaccion(id_int_transaccion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-JRR-PLANI-0-25/04/2016****************************************/
/***********************************I-DEP-JRR-PLANI-0-10/03/2017****************************************/
CREATE OR REPLACE VIEW plani.vcomp_planilla_obli (
    id_obligacion,
    id_depto_conta,
    nro_tramite,
    acreedor,
    descripcion,
    id_cuenta_bancaria,
    id_int_comprobante,
    id_moneda,
    fecha_actual,
    id_gestion,
    forma_pago,
    id_centro_costo_depto,
    monto_obligacion)
AS
SELECT o.id_obligacion,
    dcon.id_depto AS id_depto_conta,
    pro.nro_tramite,
    o.acreedor,
    o.descripcion,
    pxp.f_get_variable_global('plani_cuenta_bancaria_defecto'::character
        varying)::integer AS id_cuenta_bancaria,
    p.id_int_comprobante,
    param.f_get_moneda_base() AS id_moneda,
    now()::date AS fecha_actual,
    p.id_gestion,
        CASE
            WHEN o.tipo_pago::text = 'cheque'::text THEN 'cheque'::text
            ELSE 'transferencia'::text
        END AS forma_pago,
    (
    SELECT f_get_config_relacion_contable.ps_id_centro_costo
    FROM conta.f_get_config_relacion_contable('CCDEPCON'::character varying,
        p.id_gestion, dcon.id_depto, NULL::integer, 'No existe presupuesto administrativo relacionado al departamento de RRHH'::character varying) f_get_config_relacion_contable(ps_id_cuenta, ps_id_auxiliar, ps_id_partida, ps_id_centro_costo, ps_nombre_tipo_relacion)
    ) AS id_centro_costo_depto,
    o.monto_obligacion
FROM plani.tobligacion o
     JOIN plani.tplanilla p ON p.id_planilla = o.id_planilla
     JOIN wf.tproceso_wf pro ON pro.id_proceso_wf = p.id_proceso_wf
     JOIN param.tdepto dep ON dep.id_depto = p.id_depto
     LEFT JOIN param.tdepto_depto rel ON rel.id_depto_origen = dep.id_depto
     LEFT JOIN param.tdepto dcon ON dcon.id_depto = rel.id_depto_destino
     LEFT JOIN segu.tsubsistema sub ON sub.id_subsistema = dcon.id_subsistema
         AND sub.codigo::text = 'CONTA'::text;

/***********************************F-DEP-JRR-PLANI-0-10/03/2017****************************************/

/***********************************I-DEP-JRR-PLANI-1-10/03/2017****************************************/


CREATE OR REPLACE VIEW plani.vobligacion_presu(
    id_obligacion_columna,
    id_planilla,
    id_obligacion,
    id_centro_costo,
    id_int_transaccion,
    monto_detalle_obligacion)
AS
  SELECT oc.id_obligacion_columna,
         o.id_planilla,
         oc.id_obligacion,
         oc.id_presupuesto AS id_centro_costo,
         cc.id_int_transaccion,
         oc.monto_detalle_obligacion
  FROM plani.tobligacion_columna oc
       JOIN plani.tobligacion o ON oc.id_obligacion = o.id_obligacion
       JOIN plani.tconsolidado c ON oc.id_presupuesto = c.id_presupuesto AND
         c.id_planilla = o.id_planilla
       LEFT JOIN plani.tconsolidado_columna cc ON cc.id_tipo_columna =
         oc.id_tipo_columna AND c.id_consolidado = cc.id_consolidado AND
         cc.tipo_contrato::text = oc.tipo_contrato::text
  WHERE oc.monto_detalle_obligacion <> 0::numeric;
 DROP VIEW plani.vobligacion_pago;



CREATE OR REPLACE VIEW plani.vobligacion_pago(
    id_obligacion,
    id_planilla,
    id_cuenta,
    id_auxiliar,
    id_partida,
    nombre,
    periodo,
    gestion,
    monto_obligacion)
AS
  SELECT ob.id_obligacion,
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
       LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
         pla.id_tipo_planilla
  GROUP BY ob.id_obligacion,
           ob.id_plan_pago,
           ob.id_planilla,
           ob.id_cuenta,
           ob.id_auxiliar,
           ob.id_partida,
           tob.nombre,
           per.periodo,
           ges.gestion;


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
         ((tp.nombre::text || ' correspondiente a : '::text) || COALESCE(
           per.periodo || '/'::text, ''::text)) || ges.gestion AS desc_planilla,
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

  /***********************************F-DEP-JRR-PLANI-1-10/03/2017****************************************/

/***********************************I-DEP-CAP-PLANI-0-04/12/2018****************************************/

DROP VIEW plani.vobligacion_pago;

CREATE OR REPLACE VIEW plani.vobligacion_pago (
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
     JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion = ob.id_tipo_obligacion
     JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
     JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = pla.id_tipo_planilla
  GROUP BY ob.id_plan_pago, ob.id_planilla, ob.id_cuenta, ob.id_auxiliar, ob.id_partida, tob.nombre, per.periodo, ges.gestion;

/***********************************F-DEP-CAP-PLANI-0-04/12/2018****************************************/

/***********************************I-DEP-EGS-PLANI-0-05/02/2019****************************************/
select pxp.f_insert_testructura_gui ('AGRTO', 'DEFPLA');
/***********************************F-DEP-EGS-PLANI-0-05/02/2019****************************************/

/***********************************I-DEP-CAP-PLANI-0-08/04/2019****************************************/
CREATE OR REPLACE VIEW plani.vcomp_planilla_det (
    id_consolidado_columna,
    id_consolidado,
    id_planilla,
    monto,
    monto_presupuestario,
    id_cc,
    id_presupuesto,
    descripcion_columna,
    id_cuenta,
    id_partida,
    id_auxiliar)
AS
SELECT concol.id_consolidado_columna,
    concol.id_consolidado,
    con.id_planilla,
    concol.valor AS monto,
    concol.valor_ejecutado AS monto_presupuestario,
    con.id_cc,
    con.id_presupuesto,
    ((tc.nombre::text || '. Personal '::text) ||
        tipcon.nombre::text)::character varying AS descripcion_columna,
    concol.id_cuenta,
    concol.id_partida,
    concol.id_auxiliar
FROM plani.tconsolidado con
     JOIN plani.tconsolidado_columna concol ON concol.id_consolidado =
         con.id_consolidado
     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna = concol.id_tipo_columna
     JOIN orga.ttipo_contrato tipcon ON tipcon.codigo::text =
         concol.tipo_contrato::text;


CREATE OR REPLACE VIEW plani.vcomp_dev_planilla (
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
    op.fecha AS fecha_actual,
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
    ((COALESCE(op.numero, ''::character varying)::text || ' '::text) ||
        COALESCE(pp.obs_monto_no_pagado, ''::text))::character varying AS obs_pp,
    pp.descuento_anticipo,
    pp.descuento_inter_serv,
    op.tipo_obligacion,
    pp.id_proceso_wf,
    pp.forma_pago,
    pp.monto_ajuste_ag,
    pp.monto_ajuste_siguiente_pago,
    pp.monto_anticipo,
    ((tp.nombre::text || ' correspondiente a : '::text) || COALESCE(per.periodo
        || '/'::text, ''::text)) || ges.gestion AS desc_planilla,
    pla.id_planilla,
    (
    SELECT f_get_config_relacion_contable.ps_id_centro_costo
    FROM conta.f_get_config_relacion_contable('CCDEPCON'::character varying,
        pla.id_gestion, op.id_depto_conta) f_get_config_relacion_contable(ps_id_cuenta, ps_id_auxiliar, ps_id_partida, ps_id_centro_costo, ps_nombre_tipo_relacion)
    ) AS id_centro_costo_depto
FROM tes.tplan_pago pp
     JOIN tes.tobligacion_pago op ON pp.id_obligacion_pago = op.id_obligacion_pago
     JOIN plani.tplanilla pla ON pla.id_obligacion_pago = op.id_obligacion_pago
     LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = pla.id_tipo_planilla;

CREATE OR REPLACE VIEW plani.vcomp_planilla (
    id_planilla,
    id_depto_conta,
    nro_tramite,
    desc_planilla,
    obs,
    id_moneda,
    fecha_planilla,
    id_gestion_contable,
    id_gestion,
    monto,
    id_centro_costo_depto,
    nombre_pago)
AS
SELECT pla.id_planilla,
    dcon.id_depto AS id_depto_conta,
    pw.nro_tramite,
    ((tp.nombre::text || ' correspondiente a : '::text) || COALESCE(per.periodo
        || '/'::text, ''::text)) || ges.gestion AS desc_planilla,
    pla.nro_planilla AS obs,
    param.f_get_moneda_base() AS id_moneda,
    pla.fecha_planilla,
    (
    SELECT f_get_periodo_gestion.po_id_gestion
    FROM param.f_get_periodo_gestion(pla.fecha_planilla)
        f_get_periodo_gestion(po_id_periodo, po_id_gestion, po_id_periodo_subsistema)
    ) AS id_gestion_contable,
    pla.id_gestion,
    sum(concol.valor) AS monto,
    (
    SELECT f_get_config_relacion_contable.ps_id_centro_costo
    FROM conta.f_get_config_relacion_contable('CCDEPCON'::character varying, (
        SELECT f_get_periodo_gestion.po_id_gestion
        FROM param.f_get_periodo_gestion(pla.fecha_planilla)
            f_get_periodo_gestion(po_id_periodo, po_id_gestion, po_id_periodo_subsistema)
        ), dcon.id_depto, NULL::integer,
            'No existe presupuesto administrativo relacionado al departamento de RRHH'::character varying) f_get_config_relacion_contable(ps_id_cuenta, ps_id_auxiliar, ps_id_partida, ps_id_centro_costo, ps_nombre_tipo_relacion)
    ) AS id_centro_costo_depto,
    tp.nombre AS nombre_pago
FROM plani.tplanilla pla
     JOIN wf.tproceso_wf pw ON pw.id_proceso_wf = pla.id_proceso_wf
     JOIN plani.tconsolidado con ON con.id_planilla = pla.id_planilla
     JOIN plani.tconsolidado_columna concol ON concol.id_consolidado =
         con.id_consolidado
     LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = pla.id_tipo_planilla
     JOIN param.tdepto dep ON dep.id_depto = pla.id_depto
     LEFT JOIN param.tdepto_depto rel ON rel.id_depto_origen = dep.id_depto
     LEFT JOIN param.tdepto dcon ON dcon.id_depto = rel.id_depto_destino
     LEFT JOIN segu.tsubsistema sub ON sub.id_subsistema = dcon.id_subsistema
         AND sub.codigo::text = 'CONTA'::text
GROUP BY pla.id_planilla, dcon.id_depto, pw.nro_tramite, tp.nombre,
    per.periodo, ges.gestion, pla.nro_planilla, pla.fecha_planilla, pla.id_gestion;

CREATE OR REPLACE VIEW plani.vcomp_planilla_obli (
    id_obligacion,
    id_depto_conta,
    nro_tramite,
    acreedor,
    descripcion,
    id_cuenta_bancaria,
    id_int_comprobante,
    id_moneda,
    fecha_actual,
    id_gestion,
    forma_pago,
    id_centro_costo_depto,
    monto_obligacion,
    id_tipo_obligacion_agrupador)
AS
SELECT o.id_obligacion,
    dcon.id_depto AS id_depto_conta,
    pro.nro_tramite,
    o.acreedor,
    o.descripcion,
    pxp.f_get_variable_global('plani_cuenta_bancaria_defecto'::character
        varying)::integer AS id_cuenta_bancaria,
    p.id_int_comprobante,
    param.f_get_moneda_base() AS id_moneda,
    p.fecha_planilla AS fecha_actual,
    p.id_gestion,
        CASE
            WHEN o.tipo_pago::text = 'cheque'::text THEN 'cheque'::text
            ELSE 'transferencia'::text
        END AS forma_pago,
    (
    SELECT f_get_config_relacion_contable.ps_id_centro_costo
    FROM conta.f_get_config_relacion_contable('CCDEPCON'::character varying,
        p.id_gestion, dcon.id_depto, NULL::integer, 'No existe presupuesto administrativo relacionado al departamento de RRHH'::character varying) f_get_config_relacion_contable(ps_id_cuenta, ps_id_auxiliar, ps_id_partida, ps_id_centro_costo, ps_nombre_tipo_relacion)
    ) AS id_centro_costo_depto,
    o.monto_obligacion,
    tpo.id_tipo_obligacion_agrupador
FROM plani.tobligacion o
     JOIN plani.ttipo_obligacion tpo ON tpo.id_tipo_obligacion = o.id_tipo_obligacion
     JOIN plani.tplanilla p ON p.id_planilla = o.id_planilla
     JOIN wf.tproceso_wf pro ON pro.id_proceso_wf = p.id_proceso_wf
     JOIN param.tdepto dep ON dep.id_depto = p.id_depto
     LEFT JOIN param.tdepto_depto rel ON rel.id_depto_origen = dep.id_depto
     LEFT JOIN param.tdepto dcon ON dcon.id_depto = rel.id_depto_destino
     LEFT JOIN segu.tsubsistema sub ON sub.id_subsistema = dcon.id_subsistema
         AND sub.codigo::text = 'CONTA'::text;

CREATE OR REPLACE VIEW plani.vcomp_planilla_obli_agrupador (
    id_depto_conta,
    nro_tramite,
    acreedor,
    descripcion,
    id_cuenta_bancaria,
    id_int_comprobante,
    id_moneda,
    fecha_actual,
    id_gestion,
    forma_pago,
    id_centro_costo_depto,
    monto_obligacion,
    id_tipo_obligacion_agrupador,
    id_obligacion_agrupador,
    id_planilla)
AS
SELECT dcon.id_depto AS id_depto_conta,
    pro.nro_tramite,
    toa.nombre AS acreedor,
    toa.nombre AS descripcion,
    pxp.f_get_variable_global('plani_cuenta_bancaria_defecto'::character
        varying)::integer AS id_cuenta_bancaria,
    p.id_int_comprobante,
    param.f_get_moneda_base() AS id_moneda,
    p.fecha_planilla AS fecha_actual,
    p.id_gestion,
        CASE
            WHEN oa.tipo_pago::text = 'cheque'::text THEN 'cheque'::text
            ELSE 'transferencia'::text
        END AS forma_pago,
    (
    SELECT f_get_config_relacion_contable.ps_id_centro_costo
    FROM conta.f_get_config_relacion_contable('CCDEPCON'::character varying,
        p.id_gestion, dcon.id_depto, NULL::integer, 'No existe presupuesto administrativo relacionado al departamento de RRHH'::character varying) f_get_config_relacion_contable(ps_id_cuenta, ps_id_auxiliar, ps_id_partida, ps_id_centro_costo, ps_nombre_tipo_relacion)
    ) AS id_centro_costo_depto,
    sum(o.monto_obligacion) AS monto_obligacion,
    toa.id_tipo_obligacion_agrupador,
    oa.id_obligacion_agrupador,
    oa.id_planilla
FROM plani.tobligacion_agrupador oa
     JOIN plani.ttipo_obligacion_agrupador toa ON
         toa.id_tipo_obligacion_agrupador = oa.id_tipo_obligacion_agrupador
     JOIN plani.tplanilla p ON p.id_planilla = oa.id_planilla
     JOIN wf.tproceso_wf pro ON pro.id_proceso_wf = p.id_proceso_wf
     JOIN param.tdepto dep ON dep.id_depto = p.id_depto
     JOIN plani.tobligacion o ON o.id_obligacion_agrupador = oa.id_obligacion_agrupador
     LEFT JOIN param.tdepto_depto rel ON rel.id_depto_origen = dep.id_depto
     LEFT JOIN param.tdepto dcon ON dcon.id_depto = rel.id_depto_destino
     LEFT JOIN segu.tsubsistema sub ON sub.id_subsistema = dcon.id_subsistema
         AND sub.codigo::text = 'CONTA'::text
GROUP BY dcon.id_depto, pro.nro_tramite, toa.nombre, p.id_int_comprobante,
    p.fecha_planilla, p.id_gestion, o.tipo_pago, toa.id_tipo_obligacion_agrupador, oa.id_planilla, oa.id_obligacion_agrupador, oa.tipo_pago;

CREATE OR REPLACE VIEW plani.vobligacion_presu (
    id_obligacion_columna,
    id_planilla,
    id_obligacion,
    id_centro_costo,
    id_int_transaccion,
    monto_detalle_obligacion)
AS
SELECT oc.id_obligacion_columna,
    o.id_planilla,
    oc.id_obligacion,
    oc.id_presupuesto AS id_centro_costo,
    cc.id_int_transaccion,
    oc.monto_detalle_obligacion
FROM plani.tobligacion_columna oc
     JOIN plani.tobligacion o ON oc.id_obligacion = o.id_obligacion
     JOIN plani.tconsolidado c ON oc.id_presupuesto = c.id_presupuesto AND
         c.id_planilla = o.id_planilla
     LEFT JOIN plani.tconsolidado_columna cc ON cc.id_tipo_columna =
         oc.id_tipo_columna AND c.id_consolidado = cc.id_consolidado AND cc.tipo_contrato::text = oc.tipo_contrato::text
WHERE oc.monto_detalle_obligacion <> 0::numeric;

DROP VIEW plani.vobligacion;

CREATE OR REPLACE VIEW plani.vobligacion (
    id_obligacion,
    id_plan_pago,
    id_planilla,
    acreedor,
    descripcion,
    id_cuenta,
    id_auxiliar,
    id_partida,
    id_cuenta_haber,
    id_auxiliar_haber,
    id_partida_haber,
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
    ob.id_cuenta_haber,
    ob.id_auxiliar_haber,
    ob.id_partida_haber,
    tob.tipo_obligacion,
    ((tp.nombre::text || ' correspondiente a : '::text) || COALESCE(per.periodo || '/'::text, ''::text)) || ges.gestion AS desc_planilla,
    per.periodo,
    ges.gestion,
    ob.monto_obligacion,
    pp.id_plan_pago AS id_plan_pago_devengado
   FROM plani.tobligacion ob
     JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion = ob.id_tipo_obligacion
     JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
     JOIN tes.tobligacion_pago op ON op.id_obligacion_pago = pla.id_obligacion_pago
     JOIN tes.tplan_pago pp ON pp.id_obligacion_pago = op.id_obligacion_pago AND pp.tipo::text = 'devengado_rrhh'::text AND pp.estado_reg::text = 'activo'::text AND pp.estado::text <> 'anulado'::text
     LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = pla.id_tipo_planilla;

DROP VIEW plani.vobligacion_haber;

CREATE OR REPLACE VIEW plani.vobligacion_haber (
    id_obligacion,
    id_plan_pago,
    id_planilla,
    acreedor,
    descripcion,
    id_cuenta,
    id_auxiliar,
    id_partida,
    id_cuenta_haber,
    id_auxiliar_haber,
    id_partida_haber,
    tipo_obligacion,
    desc_planilla,
    periodo,
    gestion,
    monto_obligacion,
    id_obligacion_agrupador)
AS
 SELECT ob.id_obligacion,
    ob.id_plan_pago,
    ob.id_planilla,
    ob.acreedor,
    ob.descripcion,
    ob.id_cuenta,
    ob.id_auxiliar,
    ob.id_partida,
    ob.id_cuenta_haber,
    ob.id_auxiliar_haber,
    ob.id_partida_haber,
    tob.tipo_obligacion,
    ((tp.nombre::text || ' correspondiente a : '::text) || COALESCE(per.periodo || '/'::text, ''::text)) || ges.gestion AS desc_planilla,
    per.periodo,
    ges.gestion,
    ob.monto_obligacion,
    ob.id_obligacion_agrupador
   FROM plani.tobligacion ob
     JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion = ob.id_tipo_obligacion
     JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
     LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = pla.id_tipo_planilla;

DROP VIEW plani.vobligacion_pago;

CREATE OR REPLACE VIEW plani.vobligacion_pago (
    id_obligacion,
    id_planilla,
    id_cuenta,
    id_auxiliar,
    id_partida,
    id_cuenta_haber,
    id_auxiliar_haber,
    id_partida_haber,
    nombre,
    periodo,
    gestion,
    monto_obligacion,
    id_obligacion_agrupador)
AS
 SELECT ob.id_obligacion,
    ob.id_planilla,
    ob.id_cuenta,
    ob.id_auxiliar,
    ob.id_partida,
    ob.id_cuenta_haber,
    ob.id_auxiliar_haber,
    ob.id_partida_haber,
    tob.nombre,
    per.periodo,
    ges.gestion,
    sum(ob.monto_obligacion) AS monto_obligacion,
    ob.id_obligacion_agrupador
   FROM plani.tobligacion ob
     JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion = ob.id_tipo_obligacion
     JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
     LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
     JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla = pla.id_tipo_planilla
  GROUP BY ob.id_obligacion, ob.id_plan_pago, ob.id_planilla, ob.id_cuenta, ob.id_auxiliar, ob.id_partida, ob.id_cuenta_haber, ob.id_auxiliar_haber, ob.id_partida_haber, tob.nombre, per.periodo, ges.gestion;


/***********************************F-DEP-CAP-PLANI-0-08/04/2019****************************************/
/***********************************I-DEP-EGS-PLANI-0-24/04/2019****************************************/
select pxp.f_insert_testructura_gui ('TIPLIC', 'DEFPLA');
select pxp.f_insert_testructura_gui ('LICVOBO', 'PLANI');
select pxp.f_insert_testructura_gui ('SOLPLA', 'PLANI');

/***********************************F-DEP-EGS-PLANI-0-24/04/2019****************************************/


/***********************************I-DEP-RAC-PLANI-2-15/05/2019****************************************/

CREATE OR REPLACE VIEW plani.vincapacidad_temporal(
    monto_incapacidad,
    id_planilla,
    id_tipo_columna)
AS
  SELECT sum(cv.valor) AS monto_incapacidad,
         fp.id_planilla,
         cv.id_tipo_columna
  FROM plani.ttipo_columna tc
       JOIN plani.tcolumna_valor cv ON cv.id_tipo_columna = tc.id_tipo_columna
       JOIN plani.tfuncionario_planilla fp ON cv.id_funcionario_planilla =
         fp.id_funcionario_planilla
  WHERE tc.codigo::TEXT = 'INCAP_TEMPORAL'::TEXT AND
        tc.estado_reg::TEXT = 'activo'::TEXT AND
        fp.estado_reg::TEXT = 'activo'::TEXT
  GROUP BY fp.id_planilla,
           cv.id_tipo_columna;



CREATE OR REPLACE VIEW plani.vcomp_planilla_det_diario(
    id_consolidado_columna,
    id_consolidado,
    id_planilla,
    monto,
    monto_presupuestario,
    id_cc,
    id_presupuesto,
    descripcion_columna,
    id_cuenta,
    id_partida,
    id_auxiliar,
    id_tipo_presupuesto,
    presupuestario)
AS
  SELECT concol.id_consolidado_columna,
         concol.id_consolidado,
         con.id_planilla,
         concol.valor AS monto,
         concol.valor_ejecutado AS monto_presupuestario,
         con.id_cc,
         con.id_presupuesto,
         ((tc.nombre::TEXT || '. Personal '::TEXT) || tipcon.nombre::TEXT)::
           character VARYING AS descripcion_columna,
         concol.id_cuenta,
         concol.id_partida,
         concol.id_auxiliar,
         fc.id_tipo_presupuesto,
         CASE
           WHEN fc.id_tipo_presupuesto IS NOT NULL THEN 1
           ELSE 0
         END AS presupuestario
  FROM plani.tconsolidado con
       JOIN plani.tconsolidado_columna concol ON concol.id_consolidado =
         con.id_consolidado
       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
         concol.id_tipo_columna
       JOIN orga.ttipo_contrato tipcon ON tipcon.codigo::TEXT =
         concol.tipo_contrato::TEXT
       JOIN pre.tpresupuesto pre ON pre.id_presupuesto = con.id_presupuesto
       JOIN pre.ttipo_presupuesto tp ON pre.tipo_pres::TEXT = tp.codigo::TEXT
       LEFT JOIN plani.tfiltro_cbte fc ON fc.id_tipo_presupuesto =
         tp.id_tipo_presupuesto
  WHERE fc.id_tipo_presupuesto IS NULL;


  CREATE OR REPLACE VIEW plani.vcomp_planilla_det_presup (
    id_consolidado_columna,
    id_consolidado,
    id_planilla,
    monto,
    monto_presupuestario,
    id_cc,
    id_presupuesto,
    descripcion_columna,
    id_cuenta,
    id_partida,
    id_auxiliar,
    id_tipo_presupuesto,
    presupuestario)
AS
 SELECT concol.id_consolidado_columna,
    concol.id_consolidado,
    con.id_planilla,
    concol.valor AS monto,
    concol.valor_ejecutado AS monto_presupuestario,
    con.id_cc,
    con.id_presupuesto,
    ((tc.nombre::text || '. Personal '::text) || tipcon.nombre::text)::character varying AS descripcion_columna,
    concol.id_cuenta,
    concol.id_partida,
    concol.id_auxiliar,
    fc.id_tipo_presupuesto,
        CASE
            WHEN fc.id_tipo_presupuesto IS NOT NULL THEN 1
            ELSE 0
        END AS presupuestario
   FROM plani.tconsolidado con
     JOIN plani.tconsolidado_columna concol ON concol.id_consolidado = con.id_consolidado
     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna = concol.id_tipo_columna
     JOIN orga.ttipo_contrato tipcon ON tipcon.codigo::text = concol.tipo_contrato::text
     JOIN pre.tpresupuesto pre ON pre.id_presupuesto = con.id_presupuesto
     JOIN pre.ttipo_presupuesto tp ON pre.tipo_pres::text = tp.codigo::text
     LEFT JOIN plani.tfiltro_cbte fc ON fc.id_tipo_presupuesto = tp.id_tipo_presupuesto
  WHERE fc.id_tipo_presupuesto IS NOT NULL;


  --------------- SQL ---------------

ALTER TABLE plani.tobligacion
  ADD CONSTRAINT tobligacion__id_int_comprobante_fk FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

 --------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD CONSTRAINT tobligacion_agrupador__id_int_comprobante_fk FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RAC-PLANI-2-15/05/2019****************************************/


/***********************************I-DEP-RAC-PLANI-10-30/05/2019****************************************/

--------------- SQL ---------------

ALTER TABLE plani.tobligacion_agrupador
  ADD CONSTRAINT tobligacion_agrupador__id_afp_fk FOREIGN KEY (id_afp)
    REFERENCES plani.tafp(id_afp)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

    --------------- SQL ---------------

DROP VIEW plani.vcomp_planilla_obli_agrupador;

CREATE OR REPLACE VIEW plani.vcomp_planilla_obli_agrupador
AS
  SELECT dcon.id_depto AS id_depto_conta,
         pro.nro_tramite,
         CASE WHEN afp.id_afp IS NULL THEN toa.nombre
              ELSE toa.nombre || ' ('||afp.nombre||')'
         END  AS acreedor,
         toa.nombre AS descripcion,
         pxp.f_get_variable_global('plani_cuenta_bancaria_defecto'::character VARYING)::INTEGER AS id_cuenta_bancaria,
         p.id_int_comprobante,
         param.f_get_moneda_base() AS id_moneda,
         p.fecha_planilla AS fecha_actual,
         p.id_gestion,
         CASE
           WHEN oa.tipo_pago::TEXT = 'cheque'::TEXT THEN 'cheque'::TEXT
           ELSE 'transferencia'::TEXT
         END AS forma_pago,
         (
           SELECT f_get_config_relacion_contable.ps_id_centro_costo
           FROM conta.f_get_config_relacion_contable('CCDEPCON'::character
             VARYING, p.id_gestion, dcon.id_depto, NULL::INTEGER,
             'No existe presupuesto administrativo relacionado al departamento de RRHH'
             ::character VARYING) f_get_config_relacion_contable(ps_id_cuenta,
             ps_id_auxiliar, ps_id_partida, ps_id_centro_costo,
             ps_nombre_tipo_relacion)
         ) AS id_centro_costo_depto,
         sum(o.monto_obligacion) AS monto_obligacion,
         toa.id_tipo_obligacion_agrupador,
         oa.id_obligacion_agrupador,
         oa.id_planilla
  FROM plani.tobligacion_agrupador oa
       JOIN plani.ttipo_obligacion_agrupador toa ON
         toa.id_tipo_obligacion_agrupador = oa.id_tipo_obligacion_agrupador
       JOIN plani.tplanilla p ON p.id_planilla = oa.id_planilla
       JOIN wf.tproceso_wf pro ON pro.id_proceso_wf = p.id_proceso_wf
       JOIN param.tdepto dep ON dep.id_depto = p.id_depto
       JOIN plani.tobligacion o ON o.id_obligacion_agrupador =
         oa.id_obligacion_agrupador
       LEFT JOIN plani.tafp afp on afp.id_afp = oa.id_afp
       LEFT JOIN param.tdepto_depto rel ON rel.id_depto_origen = dep.id_depto
       LEFT JOIN param.tdepto dcon ON dcon.id_depto = rel.id_depto_destino
       LEFT JOIN segu.tsubsistema sub ON sub.id_subsistema = dcon.id_subsistema AND sub.codigo::TEXT = 'CONTA'::TEXT
  GROUP BY dcon.id_depto,
           pro.nro_tramite,
           toa.nombre,
           p.id_int_comprobante,
           p.fecha_planilla,
           p.id_gestion,
           o.tipo_pago,
           toa.id_tipo_obligacion_agrupador,
           oa.id_planilla,
           oa.id_obligacion_agrupador,
           oa.tipo_pago,
           afp.id_afp;

ALTER TABLE plani.vcomp_planilla_obli_agrupador
  OWNER TO postgres;


  --------------- SQL ---------------

CREATE OR REPLACE VIEW plani.vobligacion_agrupador
AS
SELECT ob.id_obligacion_agrupador,
         ob.id_planilla,
         ob.acreedor,
         per.periodo,
         ges.gestion,
         sum(ob.monto_obligacion) AS monto_obligacion
  FROM plani.tobligacion ob
       JOIN plani.ttipo_obligacion tob ON tob.id_tipo_obligacion =
         ob.id_tipo_obligacion
       JOIN plani.tplanilla pla ON ob.id_planilla = pla.id_planilla
       JOIN plani.tobligacion_agrupador oa ON oa.id_obligacion_agrupador = ob.id_obligacion_agrupador
       JOIN plani.ttipo_obligacion_agrupador toa on toa.id_tipo_obligacion_agrupador = oa.id_tipo_obligacion_agrupador
       LEFT JOIN param.tperiodo per ON per.id_periodo = pla.id_periodo
       JOIN param.tgestion ges ON ges.id_gestion = pla.id_gestion
       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
         pla.id_tipo_planilla


  GROUP BY ob.id_obligacion_agrupador,
           ob.id_plan_pago,
           ob.id_planilla,
           ob.acreedor,
           per.periodo,
           ges.gestion;

/***********************************F-DEP-RAC-PLANI-10-30/05/2019****************************************/
/***********************************I-DEP-MMV-PLANI-6-6/06/2019****************************************/
select pxp.f_insert_testructura_gui ('FOE', 'PLANI');
/***********************************F-DEP-MMV-PLANI-6-6/06/2019****************************************/
/***********************************I-DEP-EGS-PLANI-01-06/06/2019****************************************/
select pxp.f_insert_testructura_gui ('TIPCOLCUEP', 'RELACON');
select pxp.f_insert_testructura_gui ('PLAVOBO', 'PLANI');
/***********************************F-DEP-EGS-PLANI-01-06/06/2019****************************************/

/***********************************I-DEP-MZM-PLANI-8-06/06/2019****************************************/

  --------------- SQL ---------------

CREATE VIEW plani.vdatos_funcionarios_planilla (
    id_funcionario,
    fecha_ingreso,
    fecha_nacimiento,
    oficina,
    cargo,
    regional,
    codigo_regional,
    codigo_funcionario,
    nombre_funcionario,
    nivel,
    id_cargo,
    id_uo_funcionario)
AS
SELECT fun.id_funcionario,
    tfun.fecha_ingreso,
    tper.fecha_nacimiento,
    fun.oficina_nombre AS oficina,
    "substring"(fun.nombre_cargo::text, 1, 58)::character varying(150) AS cargo,
    fun.lugar_nombre AS regional,
    lug.codigo AS codigo_regional,
    fun.cargo_codigo AS codigo_funcionario,
    "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
    13 AS nivel,
    fun.id_cargo,
    fun.id_uo_funcionario
FROM orga.vfuncionario_cargo_lugar fun
     JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
     JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
     JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar;

  --------------- SQL ---------------

CREATE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_uo_funcionario,
    nombre_col,
    valor_col)
AS
SELECT t.id_funcionario,
    t.id_uo_funcionario,
    u.nombre_col,
    u.valor_col
FROM plani.vdatos_funcionarios_planilla t
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'codigo_regional'::text, 'nivel'::text,
         'cargo'::text, 'fecha_nacimiento'::text, 'fecha_ingreso'::text],
         ARRAY[t.nombre_funcionario, t.codigo_funcionario::text,
         t.codigo_regional::text, t.nivel || ''::text, t.cargo::text,
         t.fecha_nacimiento || ''::text, t.fecha_ingreso || ''::text])
         u(nombre_col, valor_col);

/***********************************F-DEP-MZM-PLANI-8-06/06/2019****************************************/
/***********************************I-DEP-MZM-PLANI-11-06/06/2019****************************************/

DROP VIEW plani.vdatos_func_planilla;

CREATE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            fun.id_uo_funcionario,
            plani.f_get_fecha_primer_contrato_empleado(fun.id_uo_funcionario,
                fun.id_funcionario, fun.fecha_asignacion) AS fecha_ingreso,
            tper.fecha_nacimiento,
            fun.oficina_nombre AS oficina,
            fun.nombre_cargo AS cargo,
            fun.lugar_nombre AS regional,
            lug.codigo AS codigo_regional,
            fun.cargo_codigo AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            13 AS nivel,
            fun.id_cargo,
            fp.id_planilla,
            pl.id_periodo,
            pl.id_gestion,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUB'::text AND tc.codigo::text = 'SUBPRE'::text
        ) AS subpre,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUB'::text AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBNAT'::text]))
        ) AS subsep,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUB'::text AND tc.codigo::text = 'SUBLAC'::text
        ) AS sublac,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text]))
        ) AS total_ganado,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text,
            'AFP_APPAT'::text, 'AFP_RIEPRO'::text, 'AFP_VIVIE'::text,
            'PREAGUI'::text, 'PREPRI'::text, 'CAJSAL'::text, 'PREVBS'::text]))
        ) AS total_gral,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBPRE'::text,
            'SUBLAC'::text, 'TOT_DESC'::text]))
        ) AS total_desc
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
             JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
             JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'codigo_regional'::text, 'nivel'::text,
         'cargo'::text, 'fecha_nacimiento'::text, 'fecha_ingreso'::text,
         'subpre'::text, 'subsep'::text, 'sublac'::text, 'total_ganado'::text,
         'total_gral'::text, 'total_desc'::text], ARRAY[a.nombre_funcionario,
         a.codigo_funcionario::text, a.codigo_regional::text, a.nivel ||
         ''::text, a.cargo::text, a.fecha_nacimiento || ''::text,
         a.fecha_ingreso || ''::text, round(a.subpre, 2) || ''::text,
         round(a.subsep, 2) || ''::text, round(a.sublac, 2) || ''::text,
         round(a.total_ganado, 2) || ''::text, round(a.total_gral, 2) ||
         ''::text, round(a.total_desc, 2) || ''::text]) u(nombre_col, valor_col);
/***********************************F-DEP-MZM-PLANI-8-11/06/2019****************************************/

/***********************************I-DEP-MZM-PLANI-17-11/06/2019****************************************/
ALTER TABLE plani.treporte
DROP CONSTRAINT chk__treporte__ordenar_por RESTRICT;

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__ordenar_por CHECK (((ordenar_por)::text = 'nombre'::text) OR ((ordenar_por)::text = 'doc_id'::text) OR ((ordenar_por)::text = 'codigo_cargo'::text) OR ((ordenar_por)::text = 'codigo_empleado'::text) OR ((ordenar_por)::text = 'centro'::text));

/***********************************F-DEP-MZM-PLANI-17-11/06/2019****************************************/



/***********************************I-DEP-RAC-PLANI-16-01/07/2019****************************************/


CREATE OR REPLACE VIEW plani.vrep_funcionario
AS
 SELECT uofunc.id_uo_funcionario,
         uofunc.id_uo,
         uofunc.id_funcionario,
         funcio.ci,
         funcio.codigo,
         funcio.desc_funcionario1,
         funcio.desc_funcionario2,
         funcio.num_doc,
         uofunc.fecha_asignacion,
         uofunc.fecha_finalizacion,
         uofunc.estado_reg,
         uofunc.fecha_mod,
         uofunc.fecha_reg,
         uofunc.id_usuario_mod,
         uofunc.id_usuario_reg,
         cargo.id_cargo,
         uofunc.observaciones_finalizacion,
         uofunc.nro_documento_asignacion,
         uofunc.fecha_documento_asignacion,
         uofunc.tipo,
         (COALESCE((('Cod: '::TEXT || cargo.codigo::TEXT) || '---Id: '::TEXT) ||
           cargo.id_cargo, 'Id: '::TEXT || cargo.id_cargo) || ' -- '::TEXT) ||
           cargo.nombre::TEXT AS TEXT,
         cargo.codigo AS codigo_cargo,
         cargo.nombre AS nombre_cargo,
         lug.nombre AS nombre_lugar,
         uog.codigo_gerencia,
         uog.nombre_unidad_gerencia,
         uop.codigo_uo_pre,
         uop.nombre_uo_pre,
         uoc.codigo_uo_centro,
         uoc.nombre_uo_centro,
         ''         AS firma,
         fun.interno,
         fun.id_biometrico,
         fun.email_empresa,
         fun.telefono_ofi,
         fun.codigo_rciva,
         fun.profesion,
         afp.id_afp,
         afp.nombre AS nombre_afp,
         fafp.nro_afp,
         fafp.tipo_jubilado,
         date_part('year'::TEXT, age(per.fecha_nacimiento::TIMESTAMP WITH TIME
           ZONE)) AS edad,
         per.carnet_discapacitado,
         per.celular1 AS celular_personal,
         per.correo AS correo_personal,
         per.estado_civil,
         per.expedicion,
         per.genero,
         per.direccion,
         per.fecha_nacimiento,
         date_part('year'::TEXT, per.fecha_nacimiento) AS ano_nacimiento,
         pxp.f_obtener_literal_periodo(date_part('month'::TEXT,
           per.fecha_nacimiento)::INTEGER, 0) AS mes_nacimiento,
         date_part('month'::TEXT, per.fecha_nacimiento)::INTEGER AS mes_numero,
         uoc.uo_centro_orden,
         tc.codigo as codigo_tipo_contrato,
         tc.nombre as nombre_tipo_contrato,
         uofunc.tipo as tipo_asignacion
  FROM orga.tuo_funcionario uofunc
       JOIN orga.tuo uo ON uo.id_uo = uofunc.id_uo
       JOIN orga.vuo_gerencia uog ON uog.id_uo = uo.id_uo
       JOIN orga.vuo_presu uop ON uop.id_uo = uo.id_uo
       JOIN orga.vuo_centro uoc ON uoc.id_uo = uo.id_uo
       JOIN orga.vfuncionario funcio ON funcio.id_funcionario =
         uofunc.id_funcionario
       JOIN orga.tfuncionario fun ON fun.id_funcionario = funcio.id_funcionario
       JOIN segu.tpersona per ON per.id_persona = fun.id_persona
       LEFT JOIN plani.tfuncionario_afp fafp ON fafp.id_funcionario =
         fun.id_funcionario AND fafp.estado_reg::TEXT = 'activo'::TEXT
       LEFT JOIN plani.tafp afp ON afp.id_afp = fafp.id_afp
       LEFT JOIN orga.tcargo cargo ON cargo.id_cargo = uofunc.id_cargo
       LEFT JOIN param.tlugar lug ON lug.id_lugar = cargo.id_lugar
       LEFT JOIN orga.ttipo_contrato tc ON tc.id_tipo_contrato = cargo.id_tipo_contrato
  WHERE uofunc.estado_reg::TEXT <> 'inactivo'::TEXT;


/***********************************F-DEP-RAC-PLANI-16-01/07/2019****************************************/


/***********************************I-DEP-EGS-PLANI-2-04/07/2019****************************************/
select pxp.f_insert_testructura_gui ('REPFUN', 'REPPLA');
/***********************************F-DEP-EGS-PLANI-2-04/07/2019****************************************/

/***********************************I-DEP-MZM-PLANI-8-17/07/2019****************************************/
CREATE OR REPLACE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            fun.id_uo_funcionario,
            plani.f_get_fecha_primer_contrato_empleado(fun.id_uo_funcionario,
                fun.id_funcionario, fun.fecha_asignacion) AS fecha_ingreso,
            tper.fecha_nacimiento,
            fun.oficina_nombre AS oficina,
            fun.descripcion_cargo AS cargo,
            fun.lugar_nombre AS regional,
            lug.codigo AS codigo_regional,
            fun.cargo_codigo AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            13 AS nivel,
            fun.id_cargo,
            fp.id_planilla,
            pl.id_periodo,
            pl.id_gestion,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUB'::text AND tc.codigo::text = 'SUBPRE'::text
        ) AS subpre,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUB'::text AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBNAT'::text]))
        ) AS subsep,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUB'::text AND tc.codigo::text = 'SUBLAC'::text
        ) AS sublac,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text]))
        ) AS total_ganado,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text,
            'AFP_APPAT'::text, 'AFP_RIEPRO'::text, 'AFP_VIVIE'::text,
            'PREAGUI'::text, 'PREPRI'::text, 'CAJSAL'::text, 'PREVBS'::text]))
        ) AS total_gral,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBPRE'::text,
            'SUBLAC'::text, 'TOT_DESC'::text]))
        ) AS total_desc,
            tfun.codigo_rciva,
            tper.tipo_documento,
            tper.num_documento
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
             JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
             JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'codigo_regional'::text, 'nivel'::text,
         'cargo'::text, 'fecha_nacimiento'::text, 'fecha_ingreso'::text,
         'subpre'::text, 'subsep'::text, 'sublac'::text, 'total_ganado'::text,
         'total_gral'::text, 'total_desc'::text, 'codigo_rciva'::text,
         'tipo_documento'::text, 'num_documento'::text],
         ARRAY[a.nombre_funcionario, a.codigo_funcionario::text,
         a.codigo_regional::text, a.nivel::text || ''::text, a.cargo::text,
         a.fecha_nacimiento || ''::text, a.fecha_ingreso || ''::text,
         round(a.subpre, 2) || ''::text, round(a.subsep, 2) || ''::text,
         round(a.sublac, 2) || ''::text, round(a.total_ganado, 2) || ''::text,
         round(a.total_gral, 2) || ''::text, round(a.total_desc, 2) ||
         ''::text, a.codigo_rciva::text, a.tipo_documento::text,
         a.num_documento::text]) u(nombre_col, valor_col);
/***********************************F-DEP-MZM-PLANI-8-17/07/2019****************************************/

/***********************************I-DEP-MZM-PLANI-8-21/08/2019****************************************/
CREATE OR REPLACE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            fun.id_uo_funcionario,
            plani.f_get_fecha_primer_contrato_empleado(fun.id_uo_funcionario,
                fun.id_funcionario, fun.fecha_asignacion) AS fecha_ingreso,
            tper.fecha_nacimiento,
            fun.oficina_nombre AS oficina,
            fun.descripcion_cargo AS cargo,
            fun.lugar_nombre AS regional,
            lug.codigo AS codigo_regional,
            fun.cargo_codigo AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            13 AS nivel,
            fun.id_cargo,
            fp.id_planilla,
            pl.id_periodo,
            pl.id_gestion,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUB'::text AND tc.codigo::text = 'SUBPRE'::text
        ) AS subpre,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBNAT'::text]))
        ) AS subsep,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND tc.codigo::text = 'SUBLAC'::text
        ) AS sublac,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text]))
        ) AS total_ganado,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text,
            'AFP_APPAT'::text, 'AFP_RIEPRO'::text, 'AFP_VIVIE'::text,
            'PREAGUI'::text, 'PREPRI'::text, 'CAJSAL'::text, 'PREVBS'::text]))
        ) AS total_gral,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBPRE'::text,
            'SUBLAC'::text, 'TOT_DESC'::text]))
        ) AS total_desc,
            tfun.codigo_rciva,
            tper.tipo_documento,
            tper.num_documento
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
             JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
             JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'codigo_regional'::text, 'nivel'::text,
         'cargo'::text, 'fecha_nacimiento'::text, 'fecha_ingreso'::text,
         'subpre'::text, 'subsep'::text, 'sublac'::text, 'total_ganado'::text,
         'total_gral'::text, 'total_desc'::text, 'codigo_rciva'::text,
         'tipo_documento'::text, 'num_documento'::text],
         ARRAY[a.nombre_funcionario, a.codigo_funcionario::text,
         a.codigo_regional::text, a.nivel::text || ''::text, a.cargo::text,
         a.fecha_nacimiento || ''::text, a.fecha_ingreso || ''::text,
         round(a.subpre, 2) || ''::text, round(a.subsep, 2) || ''::text,
         round(a.sublac, 2) || ''::text, round(a.total_ganado, 2) || ''::text,
         round(a.total_gral, 2) || ''::text, round(a.total_desc, 2) ||
         ''::text, a.codigo_rciva::text, a.tipo_documento::text,
         a.num_documento::text]) u(nombre_col, valor_col);
/***********************************F-DEP-MZM-PLANI-8-21/08/2019****************************************/

/***********************************I-DEP-MZM-PLANI-8-23/08/2019****************************************/

CREATE OR REPLACE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            fun.id_uo_funcionario,
            plani.f_get_fecha_primer_contrato_empleado(fun.id_uo_funcionario,
                fun.id_funcionario, fun.fecha_asignacion) AS fecha_ingreso,
            tper.fecha_nacimiento,
            fun.oficina_nombre AS oficina,
            fun.descripcion_cargo AS cargo,
            fun.lugar_nombre AS regional,
            lug.codigo AS codigo_regional,
            fun.cargo_codigo AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            13 AS nivel,
            fun.id_cargo,
            fp.id_planilla,
            pl.id_periodo,
            pl.id_gestion,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND tc.codigo::text = 'SUBPRE'::text
        ) AS subpre,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBNAT'::text]))
        ) AS subsep,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND tc.codigo::text = 'SUBLAC'::text
        ) AS sublac,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text]))
        ) AS total_ganado,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text,
            'AFP_APPAT'::text, 'AFP_RIEPRO'::text, 'AFP_VIVIE'::text,
            'PREAGUI'::text, 'PREPRI'::text, 'CAJSAL'::text, 'PREVBS'::text]))
        ) AS total_gral,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBPRE'::text,
            'SUBLAC'::text, 'TOT_DESC'::text]))
        ) AS total_desc,
            tfun.codigo_rciva,
            tper.tipo_documento,
            tper.num_documento
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
             JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
             JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'codigo_regional'::text, 'nivel'::text,
         'cargo'::text, 'fecha_nacimiento'::text, 'fecha_ingreso'::text,
         'subpre'::text, 'subsep'::text, 'sublac'::text, 'total_ganado'::text,
         'total_gral'::text, 'total_desc'::text, 'codigo_rciva'::text,
         'tipo_documento'::text, 'num_documento'::text],
         ARRAY[a.nombre_funcionario, a.codigo_funcionario::text,
         a.codigo_regional::text, a.nivel::text || ''::text, a.cargo::text,
         a.fecha_nacimiento || ''::text, a.fecha_ingreso || ''::text,
         round(a.subpre, 2) || ''::text, round(a.subsep, 2) || ''::text,
         round(a.sublac, 2) || ''::text, round(a.total_ganado, 2) || ''::text,
         round(a.total_gral, 2) || ''::text, round(a.total_desc, 2) ||
         ''::text, a.codigo_rciva::text, a.tipo_documento::text,
         a.num_documento::text]) u(nombre_col, valor_col);

/***********************************F-DEP-MZM-PLANI-8-23/08/2019****************************************/


/***********************************I-DEP-MZM-PLANI-8-26/08/2019****************************************/
CREATE OR REPLACE VIEW plani.vdatos_func_planilla(
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
  SELECT a.id_funcionario,
         a.id_funcionario_planilla,
         u.nombre_col,
         u.valor_col
  FROM (
         SELECT fun.id_funcionario,
                fp.id_funcionario_planilla,
                fun.id_uo_funcionario,
                plani.f_get_fecha_primer_contrato_empleado(fun.id_uo_funcionario
                , fun.id_funcionario, fun.fecha_asignacion) AS fecha_ingreso,
                tper.fecha_nacimiento,
                fun.oficina_nombre AS oficina,
                fun.descripcion_cargo AS cargo,
                fun.lugar_nombre AS regional,
                lug.codigo AS codigo_regional,
                fun.cargo_codigo AS codigo_funcionario,
                "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
                esc.codigo AS nivel,
                fun.id_cargo,
                fp.id_planilla,
                pl.id_periodo,
                pl.id_gestion,
                (
                  SELECT cv.valor
                  FROM plani.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN plani.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN plani.tplanilla p ON p.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        p.id_tipo_planilla
                  WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND
                        p.id_periodo = pl.id_periodo AND
                        p.id_gestion = pl.id_gestion AND
                        tp.codigo::text = 'PLASUE' ::text AND
                        tc.codigo::text = 'SUBPRE' ::text
                ) AS subpre,
                (
                  SELECT sum(cv.valor) AS sum
                  FROM plani.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN plani.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN plani.tplanilla p ON p.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        p.id_tipo_planilla
                  WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND
                        p.id_periodo = pl.id_periodo AND
                        p.id_gestion = pl.id_gestion AND
                        tp.codigo::text = 'PLASUE' ::text AND
                        (tc.codigo::text = ANY (ARRAY [ 'SUBSEP' ::text,
                         'SUBNAT' ::text ]))
                ) AS subsep,
                (
                  SELECT cv.valor
                  FROM plani.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN plani.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN plani.tplanilla p ON p.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        p.id_tipo_planilla
                  WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND
                        p.id_periodo = pl.id_periodo AND
                        p.id_gestion = pl.id_gestion AND
                        tp.codigo::text = 'PLASUE' ::text AND
                        tc.codigo::text = 'SUBLAC' ::text
                ) AS sublac,
                (
                  SELECT sum(cv.valor) AS sum
                  FROM plani.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN plani.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN plani.tplanilla p ON p.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        p.id_tipo_planilla
                  WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND
                        p.id_periodo = pl.id_periodo AND
                        p.id_gestion = pl.id_gestion AND
                        (tp.codigo::text = ANY (ARRAY [ 'PLASUB' ::character
                         varying::text, 'PLASUE' ::character varying::text ])) AND

                        (tc.codigo::text = ANY (ARRAY [ 'SUBSEP' ::text,
                         'SUBPRE' ::text, 'SUBLAC' ::text, 'SUBNAT' ::text,
                          'COTIZABLE' ::text ]))
                ) AS total_ganado,
                (
                  SELECT sum(cv.valor) AS sum
                  FROM plani.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN plani.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN plani.tplanilla p ON p.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        p.id_tipo_planilla
                  WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND
                        p.id_periodo = pl.id_periodo AND
                        p.id_gestion = pl.id_gestion AND
                        (tp.codigo::text = ANY (ARRAY [ 'PLASUB' ::character
                         varying::text, 'PLASUE' ::character varying::text ])) AND

                        (tc.codigo::text = ANY (ARRAY [ 'SUBSEP' ::text,
                         'SUBPRE' ::text, 'SUBLAC' ::text, 'SUBNAT' ::text,
                          'COTIZABLE' ::text, 'AFP_APPAT' ::text, 'AFP_RIEPRO'
                           ::text, 'AFP_VIVIE' ::text, 'PREAGUI' ::text,
                            'PREPRI' ::text, 'CAJSAL' ::text, 'PREVBS' ::text ])
                            )
                ) AS total_gral,
                (
                  SELECT sum(cv.valor) AS sum
                  FROM plani.tcolumna_valor cv
                       JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                        cv.id_tipo_columna
                       JOIN plani.tfuncionario_planilla fp_1 ON
                        fp_1.id_funcionario_planilla =
                         cv.id_funcionario_planilla
                       JOIN plani.tplanilla p ON p.id_planilla =
                        fp_1.id_planilla
                       JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                        p.id_tipo_planilla
                  WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND
                        p.id_periodo = pl.id_periodo AND
                        p.id_gestion = pl.id_gestion AND
                        (tp.codigo::text = ANY (ARRAY [ 'PLASUB' ::character
                         varying::text, 'PLASUE' ::character varying::text ])) AND

                        (tc.codigo::text = ANY (ARRAY [ 'SUBPRE' ::text,
                         'SUBLAC' ::text, 'TOT_DESC' ::text ]))
                ) AS total_desc,
                tfun.codigo_rciva,
                tper.tipo_documento,
                tper.num_documento
         FROM orga.vfuncionario_cargo_lugar fun
              JOIN orga.tfuncionario tfun ON tfun.id_funcionario =
               fun.id_funcionario
              JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
               tfun.id_funcionario AND fp.id_uo_funcionario =
                fun.id_uo_funcionario
              JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
              JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
              JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar
              JOIN orga.tcargo car ON car.id_cargo = fun.id_cargo
              JOIN orga.tescala_salarial esc ON esc.id_escala_salarial =
               car.id_escala_salarial
       ) a
       CROSS JOIN LATERAL UNNEST(ARRAY [ 'nombre_funcionario' ::text,
        'codigo_funcionario' ::text, 'codigo_regional' ::text, 'nivel' ::text,
         'cargo' ::text, 'fecha_nacimiento' ::text, 'fecha_ingreso' ::text,
          'subpre' ::text, 'subsep' ::text, 'sublac' ::text, 'total_ganado'
           ::text, 'total_gral' ::text, 'total_desc' ::text, 'codigo_rciva'
            ::text, 'tipo_documento' ::text, 'num_documento' ::text ], ARRAY [
             a.nombre_funcionario, a.codigo_funcionario::text,
              a.codigo_regional::text, a.nivel::text || '' ::text, a.cargo::text
              , a.fecha_nacimiento || '' ::text, a.fecha_ingreso || '' ::text,
               round(a.subpre, 2) || '' ::text, round(a.subsep, 2) || '' ::text,
                round(a.sublac, 2) || '' ::text, round(a.total_ganado, 2) || ''
                 ::text, round(a.total_gral, 2) || '' ::text, round(a.total_desc
                 , 2) || '' ::text, a.codigo_rciva::text, a.tipo_documento::text
                 , a.num_documento::text ]) u(nombre_col, valor_col);

/***********************************F-DEP-MZM-PLANI-8-26/08/2019****************************************/

/***********************************I-DEP-MZM-PLANI-40-12/09/2019****************************************/
/*
ALTER TABLE plani.treporte
  DROP CONSTRAINT chk__treporte__agrupar_por RESTRICT;

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__agrupar_por CHECK (((agrupar_por)::text = 'gerencia'::text) OR ((agrupar_por)::text = 'gerencia_presupuesto'::text) or agrupar_por='ninguno');*/
/***********************************F-DEP-MZM-PLANI-40-12/09/2019****************************************/

/***********************************I-DEP-MZM-PLANI-46-23/09/2019****************************************/
/*
ALTER TABLE plani.treporte
  DROP CONSTRAINT chk__treporte__agrupar_por RESTRICT;

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__agrupar_por CHECK (agrupar_por = 'gerencia' OR agrupar_por = 'gerencia_presupuesto' OR agrupar_por = 'ninguno' or agrupar_por='distrito');


  ALTER TABLE plani.treporte
  DROP CONSTRAINT chk__treporte__agrupar_por RESTRICT;*/

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__agrupar_por CHECK (((agrupar_por)::text = 'gerencia'::text) OR ((agrupar_por)::text = 'gerencia_presupuesto'::text) OR ((agrupar_por)::text = 'ninguno'::text) OR ((agrupar_por)::text = 'distrito'::text) OR ((agrupar_por)::text = 'centro'::text));

/***********************************F-DEP-MZM-PLANI-46-23/09/2019****************************************/

/***********************************I-DEP-MZM-PLANI-66-15/10/2019****************************************/
CREATE OR REPLACE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            fun.id_uo_funcionario,
            plani.f_get_fecha_primer_contrato_empleado(fun.id_uo_funcionario,
                fun.id_funcionario, fun.fecha_asignacion) AS fecha_ingreso,
            tper.fecha_nacimiento,
            fun.oficina_nombre AS oficina,
            fun.descripcion_cargo AS cargo,
            fun.lugar_nombre AS regional,
            lug.codigo AS codigo_regional,
            fun.cargo_codigo AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            esc.codigo AS nivel,
            fun.id_cargo,
            fp.id_planilla,
            pl.id_periodo,
            pl.id_gestion,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND tc.codigo::text = 'SUBPRE'::text
        ) AS subpre,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBNAT'::text]))
        ) AS subsep,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo::text
            = 'PLASUE'::text AND tc.codigo::text = 'SUBLAC'::text
        ) AS sublac,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text]))
        ) AS total_ganado,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBSEP'::text,
            'SUBPRE'::text, 'SUBLAC'::text, 'SUBNAT'::text, 'COTIZABLE'::text,
            'AFP_APPAT'::text, 'AFP_RIEPRO'::text, 'AFP_VIVIE'::text,
            'PREAGUI'::text, 'PREPRI'::text, 'CAJSAL'::text, 'PREVBS'::text]))
        ) AS total_gral,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo::text
            = ANY (ARRAY['PLASUB'::character varying::text, 'PLASUE'::character
            varying::text])) AND (tc.codigo::text = ANY (ARRAY['SUBPRE'::text,
            'SUBLAC'::text, 'TOT_DESC'::text]))
        ) AS total_desc,
            tfun.codigo_rciva,
            tper.tipo_documento,
            (tper.ci::text || ' '::text) || tper.expedicion::text AS num_documento,
            ofi.nombre AS distrito
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
             JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
             JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar
             JOIN orga.tcargo car ON car.id_cargo = fun.id_cargo
             JOIN orga.tescala_salarial esc ON esc.id_escala_salarial =
                 car.id_escala_salarial
             JOIN orga.toficina ofi ON ofi.id_oficina = car.id_oficina
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'codigo_regional'::text, 'nivel'::text,
         'cargo'::text, 'fecha_nacimiento'::text, 'fecha_ingreso'::text,
         'subpre'::text, 'subsep'::text, 'sublac'::text, 'total_ganado'::text,
         'total_gral'::text, 'total_desc'::text, 'codigo_rciva'::text,
         'tipo_documento'::text, 'num_documento'::text, 'distrito'::text],
         ARRAY[a.nombre_funcionario, a.codigo_funcionario::text,
         a.codigo_regional::text, a.nivel::text || ''::text, a.cargo::text,
         a.fecha_nacimiento || ''::text, a.fecha_ingreso || ''::text,
         round(a.subpre, 2) || ''::text, round(a.subsep, 2) || ''::text,
         round(a.sublac, 2) || ''::text, round(a.total_ganado, 2) || ''::text,
         round(a.total_gral, 2) || ''::text, round(a.total_desc, 2) ||
         ''::text, a.codigo_rciva::text, a.tipo_documento::text,
         a.num_documento, a.distrito::text]) u(nombre_col, valor_col);
/***********************************F-DEP-MZM-PLANI-66-15/10/2019****************************************/

/***********************************I-DEP-MZM-PLANI-69-29/10/2019****************************************/
CREATE VIEW plani.vdatos_horas_funcionario (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            fun.cargo_codigo AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            (
        SELECT sum(th.total_normal) AS sum
        FROM asis.vtotales_horas th
        WHERE th.id_funcionario = fun.id_funcionario AND th.id_periodo =
            pl.id_periodo AND th.estado::text = 'aprobado'::text
        ) AS horas_normales,
            (
        SELECT sum(de.total_comp) AS sum
        FROM asis.tmes_trabajo_det de
                     JOIN asis.tmes_trabajo ta ON ta.id_mes_trabajo = de.id_mes_trabajo
        WHERE ta.id_funcionario = fun.id_funcionario AND ta.id_periodo =
            pl.id_periodo AND ta.estado::text = 'aprobado'::text
        ) AS horas_comp
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla AND
                 (pl.id_tipo_planilla IN (
        SELECT ttipo_planilla.id_tipo_planilla
        FROM plani.ttipo_planilla
        WHERE ttipo_planilla.codigo::text = 'PLASUE'::text
        )) AND pl.estado::text <> 'borrador'::text AND pl.estado::text <>
            'registro_funcionarios'::text
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'horas_normales'::text,
         'horas_comp'::text], ARRAY[a.nombre_funcionario,
         a.codigo_funcionario::text, a.horas_normales || ''::text, a.horas_comp
         || ''::text]) u(nombre_col, valor_col);
/***********************************F-DEP-MZM-PLANI-69-29/10/2019****************************************/

/***********************************I-DEP-MZM-PLANI-76-06/11/2019****************************************/
CREATE OR REPLACE VIEW plani.vorden_planilla (
    ruta,
    id_uo,
    id_uo_padre,
    codigo,
    nombre_unidad,
    nivel,
    orden_centro,
    nombre_nivel,
    uo_centro_orden,
    desc_funcionario2,
    valor_col,
    niveln,
    id_funcionario_planilla,
    id_periodo,
    id_tipo_contrato,
    id_funcionario,
    id_cargo,
    id_uo_centro,
    nombre_uo_centro)
AS
 WITH RECURSIVE orden_plani AS (
SELECT c1.id_uo || '' AS ruta,
            c1.id_uo,
            c11.id_uo_padre,
            c1.codigo,
            c1.nombre_unidad,
            1 AS nivel,
            c1.orden_centro,
            c111.nombre_nivel || '' AS niveln
FROM orga.tuo c1
             JOIN orga.testructura_uo c11 ON c11.id_uo_hijo = c1.id_uo
             JOIN orga.tnivel_organizacional c111 ON
                 c111.id_nivel_organizacional = c1.id_nivel_organizacional
WHERE c1.estado_reg = 'activo' AND c11.id_uo_padre = 0
UNION
SELECT pxp.f_iif(c211.numero_nivel < 7, ((c1.ruta || '->') ||
    c2.id_uo), c1.ruta) AS ruta,
            c2.id_uo,
            c21.id_uo_padre,
            c2.codigo,
            c2.nombre_unidad,
            CAST(pxp.f_iif(c211.numero_nivel <= 7, ((c1.nivel + 1) ||
                '') , (c1.nivel || '')
                ) as integer) AS nivel,
            c2.orden_centro,
            pxp.f_iif(c211.nombre_nivel ilike '%base%',
                'base' , c211.nombre_nivel) AS niveln
FROM orga.tuo c2,
            orga.testructura_uo c21,
            orga.tnivel_organizacional c211,
            orden_plani c1
WHERE c2.estado_reg = 'activo' AND c21.id_uo_hijo = c2.id_uo AND
    c21.id_uo_padre = c1.id_uo AND c21.id_uo_padre <> 0 AND
    c211.id_nivel_organizacional = c2.id_nivel_organizacional
        )
    SELECT orden_plani.ruta,
    orden_plani.id_uo,
    orden_plani.id_uo_padre,
    orden_plani.codigo,
    orden_plani.nombre_unidad,
    orden_plani.nivel,
    orden_plani.orden_centro,
    orden_plani.niveln AS nombre_nivel,
    cen.uo_centro_orden,
    fun.desc_funcionario2,
    func.valor_col,
    orden_plani.niveln,
    fp.id_funcionario_planilla,
    plani.id_periodo,
    plani.id_tipo_contrato,
    fun.id_funcionario,
    uofun.id_cargo,
    cen.id_uo_centro,
    cen.nombre_uo_centro
    FROM orden_plani
     JOIN orga.tuo_funcionario uofun ON uofun.id_uo = orden_plani.id_uo
     JOIN orga.vuo_centro cen ON cen.id_uo = uofun.id_uo
     JOIN orga.vfuncionario fun ON fun.id_funcionario = uofun.id_funcionario
     JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
         fun.id_funcionario AND fp.id_uo_funcionario = uofun.id_uo_funcionario
     JOIN plani.tplanilla plani ON plani.id_planilla = fp.id_planilla
     JOIN plani.vdatos_func_planilla func ON func.id_funcionario_planilla =
         fp.id_funcionario_planilla AND func.nombre_col = 'fecha_ingreso'
    ORDER BY cen.uo_centro_orden, (pxp.f_iif(orden_plani.orden_centro =
        cen.uo_centro_orden, (cen.uo_centro_orden || '')
        , ((cen.uo_centro_orden + 0.1) || '')
        )), (orden_plani.ruta || orden_plani.nivel), func.valor_col,
        fun.desc_funcionario2;
/***********************************F-DEP-MZM-PLANI-76-06/11/2019****************************************/

/***********************************I-DEP-MZM-PLANI-76-07/11/2019****************************************/
CREATE OR REPLACE VIEW plani.vorden_planilla (
    ruta,
    id_uo,
    id_uo_padre,
    codigo,
    nombre_unidad,
    nivel,
    orden_centro,
    nombre_nivel,
    uo_centro_orden,
    desc_funcionario2,
    valor_col,
    niveln,
    id_funcionario_planilla,
    id_periodo,
    id_tipo_contrato,
    id_funcionario,
    id_cargo,
    id_uo_centro,
    nombre_uo_centro,
    oficina,
    orden_oficina,
    id_oficina)
AS
 WITH RECURSIVE orden_plani AS (
SELECT c1.id_uo || ''::text AS ruta,
            c1.id_uo,
            c11.id_uo_padre,
            c1.codigo,
            c1.nombre_unidad,
            1 AS nivel,
            c1.orden_centro,
            c111.nombre_nivel::text || ''::text AS niveln
FROM orga.tuo c1
             JOIN orga.testructura_uo c11 ON c11.id_uo_hijo = c1.id_uo
             JOIN orga.tnivel_organizacional c111 ON
                 c111.id_nivel_organizacional = c1.id_nivel_organizacional
WHERE c1.estado_reg::text = 'activo'::text AND c11.id_uo_padre = 0
UNION
SELECT pxp.f_iif(c211.numero_nivel >= 8, c1.ruta::character varying, ((c1.ruta
    || '->'::text) || c2.id_uo)::character varying) AS ruta,
            c2.id_uo,
            c21.id_uo_padre,
            c2.codigo,
            c2.nombre_unidad,
            c1.nivel + 1 AS nivel,
            c2.orden_centro,
            pxp.f_iif(c211.nombre_nivel::text ~~* '%base%'::text,
                'base'::character varying, c211.nombre_nivel) AS niveln
FROM orga.tuo c2,
            orga.testructura_uo c21,
            orga.tnivel_organizacional c211,
            orden_plani c1
WHERE c2.estado_reg::text = 'activo'::text AND c21.id_uo_hijo = c2.id_uo AND
    c21.id_uo_padre = c1.id_uo AND c21.id_uo_padre <> 0 AND
    c211.id_nivel_organizacional = c2.id_nivel_organizacional
        )
    SELECT orden_plani.ruta,
    orden_plani.id_uo,
    orden_plani.id_uo_padre,
    orden_plani.codigo,
    orden_plani.nombre_unidad,
    orden_plani.nivel,
    orden_plani.orden_centro,
    orden_plani.niveln AS nombre_nivel,
    cen.uo_centro_orden,
    fun.desc_funcionario2,
    func.valor_col,
    orden_plani.niveln,
    fp.id_funcionario_planilla,
    plani.id_periodo,
    plani.id_tipo_contrato,
    fun.id_funcionario,
    uofun.id_cargo,
    cen.id_uo_centro,
    cen.nombre_uo_centro,
    ofi.nombre AS oficina,
    ofi.orden AS orden_oficina,
    ofi.id_oficina
    FROM orden_plani
     JOIN orga.tuo_funcionario uofun ON uofun.id_uo = orden_plani.id_uo
     JOIN orga.vuo_centro cen ON cen.id_uo = uofun.id_uo
     JOIN orga.vfuncionario fun ON fun.id_funcionario = uofun.id_funcionario
     JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
         fun.id_funcionario AND fp.id_uo_funcionario = uofun.id_uo_funcionario
     JOIN plani.tplanilla plani ON plani.id_planilla = fp.id_planilla
     JOIN plani.vdatos_func_planilla func ON func.id_funcionario_planilla =
         fp.id_funcionario_planilla AND func.nombre_col = 'fecha_ingreso'::text
     JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
     JOIN orga.toficina ofi ON ofi.id_lugar = fp.id_lugar AND ofi.id_lugar =
         car.id_lugar
    ORDER BY cen.uo_centro_orden, (pxp.f_iif(orden_plani.orden_centro =
        cen.uo_centro_orden, (cen.uo_centro_orden || ''::text)::character
        varying, ((cen.uo_centro_orden + 0.1) || ''::text)::character
        varying)), orden_plani.ruta, ((orden_plani.ruta || orden_plani.nivel)
        || orden_plani.id_uo), func.valor_col, fun.desc_funcionario2;

/***********************************F-DEP-MZM-PLANI-76-07/11/2019****************************************/


/***********************************I-DEP-MZM-PLANI-77-15/11/2019****************************************/
drop view plani.vorden_planilla;
CREATE OR REPLACE VIEW plani.vorden_planilla (
    ruta,
    id_uo,
    id_uo_padre,
    codigo,
    nombre_unidad,
    nivel,
    orden_centro,
    uo_centro_orden,
    desc_funcionario2,
    valor_col,
    id_funcionario_planilla,
    id_periodo,
    id_tipo_contrato,
    id_funcionario,
    id_cargo,
    id_uo_centro,
    nombre_uo_centro,
    oficina,
    orden_oficina,
    id_oficina,
    prioridad)
AS
 WITH RECURSIVE orden_plani AS (
SELECT (((1 || '.0'::text) || c1.orden_centro) || '.0'::text) ||
    c1.orden_centro AS ruta,
            c1.id_uo,
            c11.id_uo_padre,
            c1.codigo,
            c1.nombre_unidad,
            1 AS nivel,
            c1.orden_centro,
            c1.centro,
            c1.orden_centro AS uo_orden_centro
FROM orga.tuo c1
             JOIN orga.testructura_uo c11 ON c11.id_uo_hijo = c1.id_uo
             JOIN orga.tnivel_organizacional c111 ON
                 c111.id_nivel_organizacional = c1.id_nivel_organizacional
WHERE c1.estado_reg::text = 'activo'::text AND c11.id_uo_padre = 0
UNION
SELECT (((((c1.ruta || '->'::text) || c1.nivel) || '.'::text) ||
    pxp.f_iif(cen2.uo_centro_orden < 100::numeric, ('0'::text ||
    cen2.uo_centro_orden)::character varying, (cen2.uo_centro_orden ||
    ''::text)::character varying)::text) || '.'::text) ||
    pxp.f_iif(c2.orden_centro < 100::numeric, ('0'::text ||
    c2.orden_centro)::character varying, (c2.orden_centro ||
    ''::text)::character varying)::text AS ruta,
            c2.id_uo,
            c21.id_uo_padre,
            c2.codigo,
            c2.nombre_unidad,
            c1.nivel + 1 AS nivel,
            c2.orden_centro,
            c2.centro,
            cen2.uo_centro_orden AS uo_orden_centro
FROM orga.tuo c2,
            orga.testructura_uo c21,
            orga.tnivel_organizacional c211,
            orga.vuo_centro cen2,
            orden_plani c1
WHERE c2.estado_reg::text = 'activo'::text AND c21.id_uo_hijo = c2.id_uo AND
    c21.id_uo_padre = c1.id_uo AND c21.id_uo_padre <> 0 AND
    c211.id_nivel_organizacional = c2.id_nivel_organizacional AND
    cen2.uo_centro_orden = c1.uo_orden_centro
        )
    SELECT orden_plani.ruta,
    orden_plani.id_uo,
    orden_plani.id_uo_padre,
    orden_plani.codigo,
    orden_plani.nombre_unidad,
    orden_plani.nivel,
    orden_plani.orden_centro,
    cen.uo_centro_orden,
    fun.desc_funcionario2,
    func.valor_col,
    fp.id_funcionario_planilla,
    plani.id_periodo,
    plani.id_tipo_contrato,
    fun.id_funcionario,
    uofun.id_cargo,
    cen.id_uo_centro,
    cen.nombre_uo_centro,
    ofi.nombre AS oficina,
    ofi.orden AS orden_oficina,
    ofi.id_oficina,
    uofun.prioridad
    FROM orden_plani
     JOIN orga.tuo_funcionario uofun ON uofun.id_uo = orden_plani.id_uo
     JOIN orga.vuo_centro cen ON cen.id_uo = uofun.id_uo
     JOIN orga.vfuncionario fun ON fun.id_funcionario = uofun.id_funcionario
     JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
         fun.id_funcionario AND fp.id_uo_funcionario = uofun.id_uo_funcionario
     JOIN plani.tplanilla plani ON plani.id_planilla = fp.id_planilla
     JOIN plani.vdatos_func_planilla func ON func.id_funcionario_planilla =
         fp.id_funcionario_planilla AND func.nombre_col = 'fecha_ingreso'::text
     JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
     JOIN orga.toficina ofi ON ofi.id_lugar = fp.id_lugar AND ofi.id_oficina =
         car.id_oficina
    ORDER BY orden_plani.ruta, uofun.prioridad, func.valor_col, fun.desc_funcionario2;



CREATE OR REPLACE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            fun.id_uo_funcionario,
            plani.f_get_fecha_primer_contrato_empleado(fun.id_uo_funcionario,
                fun.id_funcionario, fun.fecha_asignacion) AS fecha_ingreso,
            tper.fecha_nacimiento,
            fun.oficina_nombre AS oficina,
            fun.descripcion_cargo AS cargo,
            fun.lugar_nombre AS regional,
            lug.codigo AS codigo_regional,
            fun.cargo_codigo AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            esc.codigo AS nivel,
            fun.id_cargo,
            fp.id_planilla,
            pl.id_periodo,
            pl.id_gestion,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo
            = 'PLASUE' AND tc.codigo = 'SUBPRE'
        ) AS subpre,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo
            = 'PLASUE' AND (tc.codigo = ANY (ARRAY['SUBSEP',
            'SUBNAT']))
        ) AS subsep,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND tp.codigo
            = 'PLASUE' AND tc.codigo = 'SUBLAC'
        ) AS sublac,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo
            = ANY (ARRAY['PLASUB', 'PLASUE'
            ])) AND (tc.codigo = ANY (ARRAY['SUBSEP',
            'SUBPRE', 'SUBLAC', 'SUBNAT', 'COTIZABLE']))
        ) AS total_ganado,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo
            = ANY (ARRAY['PLASUB', 'PLASUE'
            ])) AND (tc.codigo = ANY (ARRAY['SUBSEP',
            'SUBPRE', 'SUBLAC', 'SUBNAT', 'COTIZABLE',
            'AFP_APPAT', 'AFP_RIEPRO', 'AFP_VIVIE',
            'PREAGUI', 'PREPRI', 'CAJSAL', 'PREVBS']))
        ) AS total_gral,
            (
        SELECT sum(cv.valor) AS sum
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
                     JOIN plani.ttipo_planilla tp ON tp.id_tipo_planilla =
                         p.id_tipo_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND (tp.codigo
            = ANY (ARRAY['PLASUB', 'PLASUE'
            ])) AND (tc.codigo = ANY (ARRAY['SUBPRE',
            'SUBLAC', 'TOT_DESC']))
        ) AS total_desc,
            tfun.codigo_rciva,
            tper.tipo_documento,
            (tper.ci || ' ') || tper.expedicion AS num_documento,
            ofi.nombre AS distrito
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla
             JOIN segu.tpersona tper ON tper.id_persona = tfun.id_persona
             JOIN param.tlugar lug ON lug.id_lugar = fun.id_lugar
             JOIN orga.tcargo car ON car.id_cargo = fun.id_cargo
             JOIN orga.tescala_salarial esc ON esc.id_escala_salarial =
                 car.id_escala_salarial
             JOIN orga.toficina ofi ON ofi.id_oficina = car.id_oficina
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario',
         'codigo_funcionario', 'codigo_regional', 'nivel',
         'cargo', 'fecha_nacimiento', 'fecha_ingreso',
         'subpre', 'subsep', 'sublac', 'total_ganado',
         'total_gral', 'total_desc', 'codigo_rciva',
         'tipo_documento', 'num_documento', 'distrito',
         'firma'], ARRAY[a.nombre_funcionario,
         a.codigo_funcionario, a.codigo_regional, a.nivel ||
         '', a.cargo, a.fecha_nacimiento || '',
         a.fecha_ingreso || '', round(a.subpre, 2) || '',
         round(a.subsep, 2) || '', round(a.sublac, 2) || '',
         round(a.total_ganado, 2) || '', round(a.total_gral, 2) ||
         '', round(a.total_desc, 2) || '', a.codigo_rciva,
         a.tipo_documento, a.num_documento, a.distrito,
         '_________________________________']) u(nombre_col, valor_col);

/***********************************F-DEP-MZM-PLANI-77-15/11/2019****************************************/

/***********************************I-DEP-MZM-PLANI-80-29/11/2019****************************************/
CREATE or replace VIEW plani.vdatos_horas_funcionario (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            btrim(fun.codigo::text, 'FUNODTPR'::text) AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            (
        SELECT sum(th.total_normal) AS sum
        FROM asis.vtotales_horas th
        WHERE th.id_funcionario = fun.id_funcionario AND th.id_periodo =
            pl.id_periodo AND th.estado::text = 'aprobado'::text
        ) AS horas_normales,
            (
        SELECT sum(de.total_comp) AS sum
        FROM asis.tmes_trabajo_det de
                     JOIN asis.tmes_trabajo ta ON ta.id_mes_trabajo = de.id_mes_trabajo
        WHERE ta.id_funcionario = fun.id_funcionario AND ta.id_periodo =
            pl.id_periodo AND ta.estado::text = 'aprobado'::text
        ) AS horas_comp
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla AND
                 (pl.id_tipo_planilla IN (
        SELECT ttipo_planilla.id_tipo_planilla
        FROM plani.ttipo_planilla
        WHERE ttipo_planilla.codigo::text = 'PLASUE'::text
        )) AND pl.estado::text <> 'borrador'::text AND pl.estado::text <>
            'registro_funcionarios'::text
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'horas_normales'::text,
         'horas_comp'::text], ARRAY[a.nombre_funcionario, a.codigo_funcionario,
         a.horas_normales || ''::text, a.horas_comp || ''::text]) u(nombre_col,
         valor_col);
/***********************************F-DEP-MZM-PLANI-80-29/11/2019****************************************/



/***********************************I-DEP-MZM-PLANI-84-16/12/2019****************************************/

ALTER TABLE plani.treporte
  DROP CONSTRAINT chk__treporte__agrupar_por RESTRICT;

ALTER TABLE plani.treporte
  ADD CONSTRAINT chk__treporte__agrupar_por CHECK (((agrupar_por)::text = 'gerencia'::text) OR ((agrupar_por)::text = 'gerencia_presupuesto'::text) OR ((agrupar_por)::text = 'ninguno'::text) OR ((agrupar_por)::text = 'distrito'::text) OR ((agrupar_por)::text = 'centro'::text) OR ((agrupar_por)::text = 'distrito_banco'::text));

CREATE OR REPLACE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fp.id_funcionario,
            fp.id_funcionario_planilla,
            fp.id_uo_funcionario,
            to_char(plani.f_get_fecha_primer_contrato_empleado(fp.id_uo_funcionario,
                fp.id_funcionario, uofun.fecha_asignacion)::timestamp without
                time zone, 'dd/mm/YYYY'::text) AS fecha_ingreso,
            per.fecha_nacimiento,
            ofi.nombre AS oficina,
            car.nombre AS cargo,
            lu.nombre AS regional,
            lu.codigo AS codigo_regional,
            btrim(fun.codigo::text, 'FUNODTPR'::text) AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            esc.codigo AS nivel,
            car.id_cargo,
            fp.id_planilla,
            plani.id_periodo,
            plani.id_gestion,
            (
        SELECT tcolumna_valor.valor
        FROM plani.tcolumna_valor
        WHERE tcolumna_valor.id_funcionario_planilla =
            fp.id_funcionario_planilla AND tcolumna_valor.codigo_columna::text
            = 'SUBPRE'::text
        ) AS subpre,
            (
        SELECT sum(tcolumna_valor.valor) AS sum
        FROM plani.tcolumna_valor
        WHERE tcolumna_valor.id_funcionario_planilla =
            fp.id_funcionario_planilla AND (tcolumna_valor.codigo_columna::text
            = ANY (ARRAY['SUBSEP'::character varying::text, 'SUBNAT'::character
            varying::text]))
        ) AS subsep,
            (
        SELECT tcolumna_valor.valor
        FROM plani.tcolumna_valor
        WHERE tcolumna_valor.id_funcionario_planilla =
            fp.id_funcionario_planilla AND tcolumna_valor.codigo_columna::text
            = 'SUBLAC'::text
        ) AS sublac,
            (
        SELECT tcolumna_valor.valor
        FROM plani.tcolumna_valor
        WHERE tcolumna_valor.id_funcionario_planilla =
            fp.id_funcionario_planilla AND tcolumna_valor.codigo_columna::text
            = 'TOTGAN'::text
        ) AS total_ganado,
            (
        SELECT sum(tcolumna_valor.valor) AS sum
        FROM plani.tcolumna_valor
        WHERE tcolumna_valor.id_funcionario_planilla =
            fp.id_funcionario_planilla AND (tcolumna_valor.codigo_columna::text
            = ANY (ARRAY['TOTGAN'::character varying::text,
            'AFP_PAT'::character varying::text, 'PREAGUI'::character
            varying::text, 'PREPRI'::character varying::text,
            'PREVBS'::character varying::text, 'CAJSAL'::character varying::text]))
        ) AS total_gral,
            (
        SELECT sum(tcolumna_valor.valor) AS sum
        FROM plani.tcolumna_valor
        WHERE tcolumna_valor.id_funcionario_planilla =
            fp.id_funcionario_planilla AND (tcolumna_valor.codigo_columna::text
            = ANY (ARRAY['TOT_DESC'::character varying::text,
            'SUBPRE'::character varying::text, 'SUBLAC'::character varying::text]))
        ) AS total_desc,
            (
        SELECT DISTINCT tfuncionario_afp.nro_afp
        FROM plani.tfuncionario_afp
        WHERE tfuncionario_afp.id_funcionario = fp.id_funcionario AND
            plani.fecha_planilla >= tfuncionario_afp.fecha_ini AND
            plani.fecha_planilla <= COALESCE(tfuncionario_afp.fecha_fin,
            plani.fecha_planilla)
        LIMIT 1
        ) AS codigo_rciva,
            per.tipo_documento,
            (per.ci::text || ' '::text) || per.expedicion::text AS num_documento,
            ofi.nombre AS distrito
    FROM plani.tplanilla plani
             JOIN plani.tfuncionario_planilla fp ON fp.id_planilla = plani.id_planilla
             JOIN orga.vfuncionario fun ON fun.id_funcionario = fp.id_funcionario
             JOIN orga.tuo_funcionario uofun ON uofun.id_funcionario =
                 fun.id_funcionario AND fp.id_uo_funcionario =
                 uofun.id_uo_funcionario AND fp.id_funcionario = uofun.id_funcionario
             JOIN orga.tfuncionario tf ON tf.id_funcionario =
                 fun.id_funcionario AND tf.id_funcionario = fp.id_funcionario
             JOIN segu.tpersona per ON per.id_persona = tf.id_persona
             JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
             JOIN orga.toficina ofi ON car.id_oficina = ofi.id_oficina
             JOIN param.tlugar lu ON lu.id_lugar = ofi.id_lugar
             JOIN orga.tescala_salarial esc ON esc.id_escala_salarial =
                 car.id_escala_salarial
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'codigo_regional'::text, 'nivel'::text,
         'cargo'::text, 'fecha_nacimiento'::text, 'fecha_ingreso'::text,
         'subpre'::text, 'subsep'::text, 'sublac'::text, 'total_ganado'::text,
         'total_gral'::text, 'total_desc'::text, 'codigo_rciva'::text,
         'tipo_documento'::text, 'num_documento'::text, 'distrito'::text,
         'firma'::text], ARRAY[a.nombre_funcionario, a.codigo_funcionario,
         a.codigo_regional::text, a.nivel::text || ''::text, a.cargo::text,
         a.fecha_nacimiento || ''::text, a.fecha_ingreso || ''::text,
         round(a.subpre, 2) || ''::text, round(a.subsep, 2) || ''::text,
         round(a.sublac, 2) || ''::text, round(a.total_ganado, 2) || ''::text,
         round(a.total_gral, 2) || ''::text, round(a.total_desc, 2) ||
         ''::text, a.codigo_rciva::text, a.tipo_documento::text,
         a.num_documento, a.distrito::text, '_________________________'::text])
         u(nombre_col, valor_col);




CREATE or REPLACE VIEW plani.vorden_planilla (
    ruta,
    id_uo,
    id_uo_padre,
    codigo,
    nombre_unidad,
    nivel,
    orden_centro,
    uo_centro_orden,
    desc_funcionario2,
    valor_col,
    id_funcionario_planilla,
    id_periodo,
    id_tipo_contrato,
    id_funcionario,
    id_cargo,
    id_uo_centro,
    nombre_uo_centro,
    oficina,
    orden_oficina,
    id_oficina,
    prioridad)
AS
 WITH RECURSIVE orden_plani AS (
SELECT (((1 || '.0'::text) || c1.orden_centro) || '.0'::text) ||
    c1.orden_centro AS ruta,
            c1.id_uo,
            c11.id_uo_padre,
            c1.codigo,
            c1.nombre_unidad,
            1 AS nivel,
            c1.orden_centro,
            c1.centro,
            c1.orden_centro AS uo_orden_centro
FROM orga.tuo c1
             JOIN orga.testructura_uo c11 ON c11.id_uo_hijo = c1.id_uo
             JOIN orga.tnivel_organizacional c111 ON
                 c111.id_nivel_organizacional = c1.id_nivel_organizacional
WHERE c1.estado_reg::text = 'activo'::text AND c11.id_uo_padre = 0
UNION
SELECT (((((c1.ruta || '->'::text) || c1.nivel) || '.'::text) ||
    pxp.f_iif(cen2.uo_centro_orden < 100::numeric, ('0'::text ||
    cen2.uo_centro_orden)::character varying, (cen2.uo_centro_orden ||
    ''::text)::character varying)::text) || '.'::text) ||
    pxp.f_iif(c2.orden_centro < 100::numeric, ('0'::text ||
    c2.orden_centro)::character varying, (c2.orden_centro ||
    ''::text)::character varying)::text AS ruta,
            c2.id_uo,
            c21.id_uo_padre,
            c2.codigo,
            c2.nombre_unidad,
            c1.nivel + 1 AS nivel,
            c2.orden_centro,
            c2.centro,
            cen2.uo_centro_orden AS uo_orden_centro
FROM orga.tuo c2,
            orga.testructura_uo c21,
            orga.tnivel_organizacional c211,
            orga.vuo_centro cen2,
            orden_plani c1
WHERE c2.estado_reg::text = 'activo'::text AND c21.id_uo_hijo = c2.id_uo AND
    c21.id_uo_padre = c1.id_uo AND c21.id_uo_padre <> 0 AND
    c211.id_nivel_organizacional = c2.id_nivel_organizacional AND
    cen2.uo_centro_orden = c1.uo_orden_centro
        )
    SELECT orden_plani.ruta,
    orden_plani.id_uo,
    orden_plani.id_uo_padre,
    orden_plani.codigo,
    orden_plani.nombre_unidad,
    orden_plani.nivel,
    orden_plani.orden_centro,
    cen.uo_centro_orden,
    fun.desc_funcionario2,
    plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario,
        fp.id_funcionario, uofun.fecha_asignacion)::text AS valor_col,
    fp.id_funcionario_planilla,
    plani.id_periodo,
    plani.id_tipo_contrato,
    fun.id_funcionario,
    uofun.id_cargo,
    cen.id_uo_centro,
    cen.nombre_uo_centro,
    ofi.nombre AS oficina,
    ofi.orden AS orden_oficina,
    ofi.id_oficina,
    uofun.prioridad
    FROM orden_plani
     JOIN orga.tuo_funcionario uofun ON uofun.id_uo = orden_plani.id_uo
     JOIN orga.vuo_centro cen ON cen.id_uo = uofun.id_uo
     JOIN orga.vfuncionario fun ON fun.id_funcionario = uofun.id_funcionario
     JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
         fun.id_funcionario AND fp.id_uo_funcionario = uofun.id_uo_funcionario
     JOIN plani.tplanilla plani ON plani.id_planilla = fp.id_planilla
     JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
     JOIN orga.toficina ofi ON ofi.id_oficina = car.id_oficina
    ORDER BY orden_plani.ruta, uofun.prioridad, fun.desc_funcionario2;


CREATE or REPLACE VIEW plani.vdatos_horas_funcionario (
    id_funcionario,
    id_funcionario_planilla,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_funcionario_planilla,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fp.id_funcionario_planilla,
            btrim(fun.codigo::text, 'FUNODTPR'::text) AS codigo_funcionario,
            "substring"(fun.desc_funcionario2, 1, 58) AS nombre_funcionario,
            (
        SELECT sum(th.total_normal) AS sum
        FROM asis.vtotales_horas th
        WHERE th.id_funcionario = fun.id_funcionario AND th.id_periodo =
            pl.id_periodo AND th.estado::text = 'aprobado'::text
        ) AS horas_normales,
            (
        SELECT sum(de.total_comp) AS sum
        FROM asis.tmes_trabajo_det de
                     JOIN asis.tmes_trabajo ta ON ta.id_mes_trabajo = de.id_mes_trabajo
        WHERE ta.id_funcionario = fun.id_funcionario AND ta.id_periodo =
            pl.id_periodo AND ta.estado::text = 'aprobado'::text
        ) AS horas_comp
    FROM orga.vfuncionario_cargo_lugar fun
             JOIN orga.tfuncionario tfun ON tfun.id_funcionario = fun.id_funcionario
             JOIN plani.tfuncionario_planilla fp ON fp.id_funcionario =
                 tfun.id_funcionario AND fp.id_uo_funcionario = fun.id_uo_funcionario
             JOIN plani.tplanilla pl ON pl.id_planilla = fp.id_planilla AND
                 (pl.id_tipo_planilla IN (
        SELECT ttipo_planilla.id_tipo_planilla
        FROM plani.ttipo_planilla
        WHERE ttipo_planilla.codigo::text = 'PLASUE'::text
        )) AND pl.estado::text <> 'borrador'::text AND pl.estado::text <>
            'registro_funcionarios'::text
    ) a
     CROSS JOIN LATERAL UNNEST(ARRAY['nombre_funcionario'::text,
         'codigo_funcionario'::text, 'horas_normales'::text,
         'horas_comp'::text], ARRAY[a.nombre_funcionario, a.codigo_funcionario,
         a.horas_normales || ''::text, a.horas_comp || ''::text]) u(nombre_col,
         valor_col);
/***********************************F-DEP-MZM-PLANI-84-16/12/2019****************************************/



/***********************************I-DEP-RAC-PLANI-113-06/05/2020****************************************/

CREATE OR REPLACE VIEW plani.vcomp_planilla_obli(
    id_obligacion,
    id_depto_conta,
    nro_tramite,
    acreedor,
    descripcion,
    id_cuenta_bancaria,
    id_int_comprobante,
    id_moneda,
    fecha_actual,
    id_gestion,
    forma_pago,
    id_centro_costo_depto,
    monto_obligacion,
    id_tipo_obligacion_agrupador,
    id_gestion_pago)
AS
  SELECT o.id_obligacion,
         dcon.id_depto AS id_depto_conta,
         pro.nro_tramite,
         o.acreedor,
         o.descripcion,
         pxp.f_get_variable_global('plani_cuenta_bancaria_defecto'::character
           VARYING)::INTEGER AS id_cuenta_bancaria,
         p.id_int_comprobante,
         param.f_get_moneda_base() AS id_moneda,
         p.fecha_planilla AS fecha_actual,
         p.id_gestion,
         CASE
           WHEN o.tipo_pago::TEXT = 'cheque'::TEXT THEN 'cheque'::TEXT
           ELSE 'transferencia'::TEXT
         END AS forma_pago,
         (
           SELECT f_get_config_relacion_contable.ps_id_centro_costo
           FROM conta.f_get_config_relacion_contable('CCDEPCON'::character
             VARYING, gesp.id_gestion, dcon.id_depto, NULL::INTEGER,
             'No existe presupuesto administrativo relacionado al departamento de RRHH'
             ::character VARYING) f_get_config_relacion_contable(ps_id_cuenta,
             ps_id_auxiliar, ps_id_partida, ps_id_centro_costo,
             ps_nombre_tipo_relacion)
         ) AS id_centro_costo_depto,
         o.monto_obligacion,
         tpo.id_tipo_obligacion_agrupador,
         gesp.id_gestion AS id_gestion_pago
  FROM plani.tobligacion o
       JOIN plani.ttipo_obligacion tpo ON tpo.id_tipo_obligacion =
         o.id_tipo_obligacion
       JOIN plani.tplanilla p ON p.id_planilla = o.id_planilla
       JOIN wf.tproceso_wf pro ON pro.id_proceso_wf = p.id_proceso_wf
       JOIN param.tdepto dep ON dep.id_depto = p.id_depto
       JOIN param.tgestion gesp ON p.fecha_planilla >= gesp.fecha_ini AND
         p.fecha_planilla <= gesp.fecha_fin
       LEFT JOIN param.tdepto_depto rel ON rel.id_depto_origen = dep.id_depto
       LEFT JOIN param.tdepto dcon ON dcon.id_depto = rel.id_depto_destino
       LEFT JOIN segu.tsubsistema sub ON sub.id_subsistema = dcon.id_subsistema
         AND sub.codigo::TEXT = 'CONTA'::TEXT;

select conta.f_import_ttipo_relacion_contable ('insert','INCAPTEMP',NULL,'Incapacidad Temporal por Cobrar','activo','no','si','si','flujo','recurso_gasto','no','no','no',NULL);
select conta.f_import_ttipo_relacion_contable ('insert','SALXPALI',NULL,'Salario por Aplicar','activo','no','si','no','flujo','recurso_gasto','no','no','no',NULL);
select conta.f_import_ttipo_relacion_contable ('insert','CCCLMCTA','TTIP','Centro de costos columnas solo contables','activo','si-unico','no','no','','','no','no','no','');


select conta.f_import_ttipo_relacion_contable ('insert','CUEOBLIHAB','TTIO','Cuenta de Obligacion Planillas Haber','activo','no','si','no','flujo','recurso','no','no','no','');
select conta.f_import_ttipo_relacion_contable ('insert','CUEOBLI','TTIO','Cuenta de Obligacion Planillas','activo','no','si','no','flujo','gasto','no','no','no','');
select conta.f_import_tplantilla_comprobante ('insert','PAGOPLA','plani.f_conta_eliminacion_comprobante_obligacion','id_obligacion','PLANI','{$tabla.descripcion}','','{$tabla.fecha_actual}','activo','{$tabla.acreedor}','{$tabla.id_depto_conta}','contable','{$tabla.id_int_comprobante}','plani.vcomp_planilla_obli','PAGOCON','{$tabla.id_moneda}','{$tabla.id_gestion_pago}','{$tabla.id_cuenta_bancaria},{$tabla.forma_pago},{$tabla.id_centro_costo_depto}','no','no','no','','','','','{$tabla.nro_tramite}','','','','','','PAGOPLA','','','','','');



/***********************************F-DEP-RAC-PLANI-113-06/05/2020****************************************/
