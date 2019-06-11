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

CREATE OR REPLACE VIEW plani.vdatos_func_planilla (
    id_funcionario,
    id_uo_funcionario,
    nombre_col,
    valor_col)
AS
SELECT a.id_funcionario,
    a.id_uo_funcionario,
    u.nombre_col,
    u.valor_col
FROM (
    SELECT fun.id_funcionario,
            fun.id_uo_funcionario,
            tfun.fecha_ingreso,
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
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND
            p.id_tipo_planilla = 2 AND tc.codigo::text = 'SUBPRE'::text
        ) AS subpre,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND
            p.id_tipo_planilla = 2 AND tc.codigo::text = 'SUBSEP'::text
        ) AS subsep,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND
            p.id_tipo_planilla = 2 AND tc.codigo::text = 'SUBLAC'::text
        ) AS sublac,
            (
        SELECT cv.valor
        FROM plani.tcolumna_valor cv
                     JOIN plani.ttipo_columna tc ON tc.id_tipo_columna =
                         cv.id_tipo_columna
                     JOIN plani.tfuncionario_planilla fp_1 ON
                         fp_1.id_funcionario_planilla = cv.id_funcionario_planilla
                     JOIN plani.tplanilla p ON p.id_planilla = fp_1.id_planilla
        WHERE fp_1.id_uo_funcionario = fun.id_uo_funcionario AND p.id_periodo =
            pl.id_periodo AND p.id_gestion = pl.id_gestion AND
            p.id_tipo_planilla = 2 AND tc.codigo::text = 'SUBNAT'::text
        ) AS subnat
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
         'subpre'::text, 'subsep'::text, 'sublac'::text, 'subnat'::text],
         ARRAY[a.nombre_funcionario, a.codigo_funcionario::text,
         a.codigo_regional::text, a.nivel || ''::text, a.cargo::text,
         a.fecha_nacimiento || ''::text, a.fecha_ingreso || ''::text,
         round(a.subpre, 2) || ''::text, round(a.subsep, 2) || ''::text,
         round(a.sublac, 2) || ''::text, round(a.subnat, 2) || ''::text])
         u(nombre_col, valor_col);
         
/***********************************F-DEP-MZM-PLANI-8-11/06/2019****************************************/
