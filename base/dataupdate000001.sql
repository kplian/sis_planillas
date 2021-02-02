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