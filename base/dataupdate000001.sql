/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/


/********************************************I-DAUP-MZM-PLANI-0-01/02/2021********************************************/
--commit
select  wf.f_registra_estado_wf(795,
                                                             null,
                                                             1174635, --v_parametros.id_estado_wf_act,
                                                             346869, -- v_parametros.id_proceso_wf_act,
                                                             1,
                                                             null,
                                                             null,
                                                             null,
                                                             'RRHH01-PLAGUIN-7-2020, Finalizacion manual segun ticket ETR-2759',--COALESCE(v_planilla.nro_planilla,'--')||' Obs:'||v_obs,
                                                             null ,
                                                             null,
                                                             null,
                                                             null,
                                                             'Finalizacion manual segun ticket ETR-2759');



update plani.tplanilla  t set
       id_estado_wf =  (select id_estado_wf from wf.testado_wf where id_proceso_wf=346869 and estado_reg='activo'),
       estado = 'planilla_finalizada',
       id_usuario_mod=1,
       fecha_mod=now()
    where id_proceso_wf = 346869;
    
    
select  wf.f_registra_estado_wf(795,
                                                             null,
                                                             1174633, --v_parametros.id_estado_wf_act,
                                                             346865, -- v_parametros.id_proceso_wf_act,
                                                             1,
                                                             null,
                                                             null,
                                                             null,
                                                             'RRHH01-PLAGUIN-6-2020, Finalizacion manual segun ticket ETR-2759',--COALESCE(v_planilla.nro_planilla,'--')||' Obs:'||v_obs,
                                                             null ,
                                                             null,
                                                             null,
                                                             null,
                                                             'Finalizacion manual segun ticket ETR-2759');



update plani.tplanilla  set
       id_estado_wf =  (select id_estado_wf from wf.testado_wf where id_proceso_wf=346865 and estado_reg='activo'),
       estado = 'planilla_finalizada',
       id_usuario_mod=1,
       fecha_mod=now()
    where id_proceso_wf = 346865;
/********************************************F-DAUP-MZM-PLANI-0-01/02/2021********************************************/




/********************************************I-DAUP-MZM-PLANI-1-12/02/2021********************************************/
--rollback
--UPDATE plani.tcolumna_valor SET valor = 10818.55 WHERE id_columna_valor = 4653241;
--UPDATE plani.tcolumna_valor SET valor = 12784.55 WHERE id_columna_valor = 4653237;
--UPDATE plani.tcolumna_valor SET valor = 13336.27 WHERE id_columna_valor = 4653234;
--UPDATE plani.tcolumna_valor SET valor = 106830.66 WHERE id_columna_valor = 4653229;
--UPDATE plani.tcolumna_valor SET valor = 102586.66 WHERE id_columna_valor = 4653231;
--UPDATE plani.tcolumna_valor SET valor = 72312.33 WHERE id_columna_valor = 4653200;
--UPDATE plani.tcolumna_valor SET valor = 5375.71 WHERE id_columna_valor = 4653274;
--UPDATE plani.tcolumna_valor SET valor = 5375.71 WHERE id_columna_valor = 4653249;

--commit
UPDATE plani.tcolumna_valor SET valor =25037.95  WHERE id_columna_valor = 4653241;
UPDATE plani.tcolumna_valor SET valor =27003.95  WHERE id_columna_valor = 4653237;
UPDATE plani.tcolumna_valor SET valor =27555.67  WHERE id_columna_valor = 4653234;
UPDATE plani.tcolumna_valor SET valor =216210.66  WHERE id_columna_valor = 4653229;
UPDATE plani.tcolumna_valor SET valor =211966.66  WHERE id_columna_valor = 4653231;
UPDATE plani.tcolumna_valor SET valor =181692.33  WHERE id_columna_valor = 4653200;
UPDATE plani.tcolumna_valor SET valor =19595.11  WHERE id_columna_valor = 4653274;
UPDATE plani.tcolumna_valor SET valor =19595.11  WHERE id_columna_valor = 4653249;
/********************************************F-DAUP-MZM-PLANI-1-12/02/2021********************************************/


/********************************************I-DAUP-MZM-PLANI-1-18/03/2021********************************************/
--rollback
--update plani.tcolumna_valor set valor=771 where id_columna_valor=4786669;
--update plani.tcolumna_valor set valor=2257.84 where id_columna_valor=4786688;
--update plani.tcolumna_valor set valor=2257.84 where id_columna_valor=4786697;
--update plani.tcolumna_valor set valor=2257.84 where id_columna_valor=4786686;
--update plani.tcolumna_valor set valor=456.11 where id_columna_valor=4786671;
--update plani.tcolumna_valor set valor=2257.84 where id_columna_valor=4786677;

--commit
update plani.tcolumna_valor set valor=752 where id_columna_valor=4786669;
update plani.tcolumna_valor set valor=2238.84 where id_columna_valor=4786688;
update plani.tcolumna_valor set valor=2238.84 where id_columna_valor=4786697;
update plani.tcolumna_valor set valor=2238.84 where id_columna_valor=4786686;
update plani.tcolumna_valor set valor=437.11 where id_columna_valor=4786671;
update plani.tcolumna_valor set valor=2238.84 where id_columna_valor=4786677;
/********************************************F-DAUP-MZM-PLANI-1-18/03/2021********************************************/



/********************************************I-DAUP-MZM-PLANI-1-22/03/2021********************************************/
---rollback
--update plani.tcolumna_valor set valor=13400.73 where id_columna_valor=31419;
--update plani.tcolumna_valor set valor=33952.72 where id_columna_valor=17627;
--update plani.tcolumna_valor set valor=9763.99 where id_columna_valor=44622;
--update plani.tcolumna_valor set valor=19166.22 where id_columna_valor=44483;


--commit                                
update plani.tcolumna_valor set valor=18656.94 where id_columna_valor=31419;
update plani.tcolumna_valor set valor=33867.84 where id_columna_valor=17627;
update plani.tcolumna_valor set valor=8385.25 where id_columna_valor=44622;
update plani.tcolumna_valor set valor=18838.6 where id_columna_valor=44483;
/********************************************F-DAUP-MZM-PLANI-1-22/03/2021********************************************/


/********************************************I-DAUP-MZM-PLANI-2-24/03/2021********************************************/
---rollback
--update plani.tplanilla set envios_boleta=0
--where id_planilla=281;

--commit  
update plani.tplanilla set envios_boleta=1
where id_planilla=281;
/********************************************I-DAUP-MZM-PLANI-2-24/03/2021********************************************/