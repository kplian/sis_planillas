<?php
/**
 *@package pXP
 *@file gen-Planilla.php
 *@author  (admin)
 *@date 22-01-2014 16:11:04
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PlanillaConsulta=Ext.extend(Phx.gridInterfaz,{

        bnew: false,
        bedit: false,
        bdel: false,
        btest: false,
        bsave: false,

        constructor:function(config){
            this.tbarItems = ['-',
                this.cmbGestion,'-'

            ];
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.PlanillaConsulta.superclass.constructor.call(this,config);
            this.init();

            this.store.baseParams.pes_estado = 'consultas';

            var fecha = new Date();

            Ext.Ajax.request({
                url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                params:{fecha:fecha.getDate()+'/'+(fecha.getMonth()+1)+'/'+fecha.getFullYear()},
                success:function(resp){
                    var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                    console.log('respuesta',reg.ROOT.datos);
                    this.cmbGestion.setValue(reg.ROOT.datos.id_gestion);
                    this.cmbGestion.setRawValue(reg.ROOT.datos.anho);
                    this.store.baseParams.id_gestion=reg.ROOT.datos.id_gestion;
                    this.load({params:{start:0, limit:this.tam_pag}});
                },
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });

            this.cmbGestion.on('select',this.capturarEventos, this);
            this.store.baseParams.tipo_interfaz =  this.nombreVista;

            this.iniciarEventos();

            /*if(this.nombreVista != 'consultas') {
                this.load({params: {start: 0, limit: this.tam_pag}});
            }*/

            /*this.addButton('ant_estado',{grupo:[0],argument: {estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
            this.addButton('sig_estado',{grupo:[0],text:'Siguiente',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});*/
            this.addButton('diagrama_gantt',{grupo:[0,1,2],text:'Gant',iconCls: 'bgantt',disabled:true,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});

            this.addButton('btnChequeoDocumentosWf',
                {	grupo:[0,1,2],
                    text: 'Documentos',
                    iconCls: 'bchecklist',
                    disabled: true,
                    handler: this.loadCheckDocumentosPlanWf,
                    tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
                }
            );


            this.addButton('btnObs',{
                grupo:[0,1,2,3,4,5],
                text :'Obs Wf.',
                iconCls : 'bchecklist',
                disabled: true,
                handler : this.onOpenObs,
                tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
            });

            function diagramGantt(){
                var data=this.sm.getSelected().data.id_proceso_wf;
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                    params:{'id_proceso_wf':data},
                    success:this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
            }
        },

        cmbGestion : new Ext.form.ComboBox({
            name: 'gestion',
            id: 'gestion_reg',
            fieldLabel: 'Gestion',
            allowBlank: true,
            emptyText:'Gestion...',
            blankText: 'Año',
            store:new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Gestion/listarGestion',
                    id: 'id_gestion',
                    root: 'datos',
                    sortInfo:{
                        field: 'gestion',
                        direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion','gestion'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'gestion'}
                }),
            valueField: 'id_gestion',
            triggerAction: 'all',
            displayField: 'gestion',
            hiddenName: 'id_gestion',
            mode:'remote',
            pageSize:50,
            queryDelay:500,
            listWidth:'280',
            hidden:false,
            width:80
        }),

        capturarEventos: function () {
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            this.load({params:{start:0, limit:this.tam_pag}});
        },

        onOpenObs:function() {
            var rec=this.sm.getSelected();
            var data = {
                id_proceso_wf: rec.data.id_proceso_wf,
                id_estado_wf: rec.data.id_estado_wf,
                num_tramite: rec.data.nro_tramite
            }
            Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
                'Observaciones del WF',
                {
                    width:'80%',
                    height:'70%'
                },
                data,
                this.idContenedor,
                'Obs'
            )
        },


        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_planilla'
                },
                type:'Field',
                form:true
            },

            {
                config:{
                    name: 'nro_planilla',
                    fieldLabel: 'No Planilla',
                    allowBlank: false,
                    //anchor: '100%',
                    gwidth: 200,
                    maxLength:100
                },
                type:'TextField',
                filters:{pfiltro:'plani.nro_planilla',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter : true
            },

            {
                config: {
                    name: 'id_tipo_planilla',
                    fieldLabel: 'Tipo Planilla',
                    typeAhead: false,
                    forceSelection: false,
                    hiddenName: 'id_tipo_planilla',
                    allowBlank: false,
                    emptyText: 'Lista de Planillas...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_planillas/control/TipoPlanilla/listarTipoPlanilla',
                        id: 'id_tipo_planilla',
                        root: 'datos',
                        sortInfo: {
                            field: 'codigo',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_tipo_planilla', 'nombre', 'codigo','periodicidad'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {par_filtro: 'tippla.nombre#tippla.codigo'}
                    }),
                    valueField: 'id_tipo_planilla',
                    displayField: 'nombre',
                    gdisplayField: 'nombre_planilla',
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 20,
                    queryDelay: 200,
                    listWidth:280,
                    minChars: 2,
                    gwidth: 120,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {
                    pfiltro: 'tippla.nombre',
                    type: 'string'
                },
                grid: true,
                form: true,
                bottom_filter : true
            },
            {
                config:{
                    name: 'estado',
                    fieldLabel: 'Estado',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:50
                },
                type:'TextField',
                filters:{pfiltro:'plani.estado',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter : true
            },

            {
                config:{
                    name:'id_depto',
                    hiddenName: 'id_depto',
                    //url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
                    origen:'DEPTO',
                    allowBlank:false,
                    fieldLabel: 'Depto',
                    gdisplayField:'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                    width:250,
                    gwidth:180,
                    baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'ORGA'},//parametros adicionales que se le pasan al store
                    renderer:function (value, p, record){return String.format('{0}', record.data['nombre_depto']);}
                },
                //type:'TrigguerCombo',
                type:'ComboRec',
                id_grupo:0,
                filters:{pfiltro:'depto.nombre',type:'string'},
                grid:true,
                form:true
            },
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    allowBlank : false,
                    gdisplayField : 'gestion',//mapea al store del grid
                    gwidth : 100,
                    renderer : function (value, p, record){return String.format('{0}', record.data['gestion']);}
                },
                type : 'ComboRec',
                id_grupo : 0,
                filters : {
                    pfiltro : 'ges.gestion',
                    type : 'numeric'
                },

                grid : true,
                form : true,
                bottom_filter : true
            },
            {
                config:{
                    name : 'id_periodo',
                    origen : 'PERIODO',
                    fieldLabel : 'Periodo',
                    allowBlank : true,
                    gdisplayField : 'periodo',//mapea al store del grid
                    gwidth : 100,
                    renderer : function (value, p, record){return String.format('{0}', record.data['periodo']);}
                },
                type : 'ComboRec',
                id_grupo : 0,
                filters : {
                    pfiltro : 'per.periodo',
                    type : 'numeric'
                },

                grid : true,
                form : true,
                bottom_filter : true
            },
            {
                config:{
                    name: 'fecha_planilla',
                    fieldLabel: 'Fecha Planilla',
                    allowBlank: false,
                    qtip: 'Esta fecha se tomara como base para afectaciones contables y presupuestarias de esta planilla',
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'plani.fecha_planilla',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            },

            {
                config:{
                    name:'id_uo',
                    hiddenName: 'id_uo',
                    origen:'UO',
                    fieldLabel:'UO',
                    gdisplayField:'desc_uo',//mapea al store del grid
                    gwidth:200,
                    emptyText:'Dejar blanco para toda la empresa...',
                    anchor: '80%',
                    baseParams: {nivel: 'si'},
                    allowBlank:true,
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}
                },
                type:'ComboRec',
                id_grupo:1,
                filters:{
                    pfiltro:'uo.codigo#uo.nombre_unidad',
                    type:'string'
                },
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'observaciones',
                    fieldLabel: 'Observaciones',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100
                },
                type:'TextArea',
                filters:{pfiltro:'plani.observaciones',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },



            {
                config:{
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:10
                },
                type:'TextField',
                filters:{pfiltro:'plani.estado_reg',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    name: 'fecha_reg',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'plani.fecha_reg',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'usr_reg',
                    fieldLabel: 'Creado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:4
                },
                type:'NumberField',
                filters:{pfiltro:'usu1.cuenta',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter : true
            },
            {
                config:{
                    name: 'usr_mod',
                    fieldLabel: 'Modificado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:4
                },
                type:'NumberField',
                filters:{pfiltro:'usu2.cuenta',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'fecha_mod',
                    fieldLabel: 'Fecha Modif.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'plani.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],
        tam_pag:50,
        title:'Planilla',
        ActSave:'../../sis_planillas/control/Planilla/insertarPlanilla',
        ActDel:'../../sis_planillas/control/Planilla/eliminarPlanilla',
        ActList:'../../sis_planillas/control/Planilla/listarPlanilla',
        id_store:'id_planilla',
        fields: [
            {name:'id_planilla', type: 'numeric'},
            {name:'id_periodo', type: 'numeric'},
            {name:'id_depto', type: 'numeric'},
            {name:'nombre_depto', type: 'string'},
            {name:'id_gestion', type: 'numeric'},
            {name:'gestion', type: 'numeric'},
            {name:'periodo', type: 'numeric'},
            {name:'nombre_planilla', type: 'string'},
            {name:'calculo_horas', type: 'string'},
            {name:'plani_tiene_presupuestos', type: 'string'},
            {name:'plani_tiene_costos', type: 'string'},
            {name:'desc_uo', type: 'string'},
            {name:'id_uo', type: 'numeric'},
            {name:'id_tipo_planilla', type: 'numeric'},
            {name:'id_proceso_macro', type: 'numeric'},
            {name:'id_proceso_wf', type: 'numeric'},
            {name:'id_estado_wf', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'observaciones', type: 'string'},
            {name:'nro_planilla', type: 'string'},
            {name:'estado', type: 'string'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'fecha_planilla', type: 'date',dateFormat:'Y-m-d'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'codigo_poa', type: 'string'},
            {name:'obs_poa', type: 'string'},

        ],
        sortInfo:{
            field: 'id_planilla',
            direction: 'DESC'
        },

        iniciarEventos : function() {
            this.Cmp.id_tipo_planilla.on('select',function(c,r,i) {
                if (r.data.periodicidad == 'anual') {
                    this.ocultarComponente(this.Cmp.id_periodo);
                    this.Cmp.id_periodo.allowBlank = true;
                    this.Cmp.id_periodo.reset();
                } else {
                    this.mostrarComponente(this.Cmp.id_periodo);
                    this.Cmp.id_periodo.allowBlank = false;

                }
            },this);

            this.Cmp.id_gestion.on('select',function(c,r,i){
                this.Cmp.id_periodo.reset();
                this.Cmp.id_periodo.store.baseParams.id_gestion = r.data.id_gestion;
            },this);


        },

        onButtonAjax : function (params){
            var rec = this.sm.getSelected();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_planillas/control/Planilla/ejecutarProcesoPlanilla',
                success:this.successDel,
                failure:this.conexionFailure,
                params:{'id_planilla':rec.data.id_planilla, 'accion':params.argument.accion},
                timeout:this.timeout,
                scope:this
            })

        },


        onButtonColumnasCsv : function() {
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_planillas/vista/planilla/ColumnaCsv.php',
                'Subir valores para columna',
                {
                    modal:true,
                    width:450,
                    height:200
                },rec.data,this.idContenedor,'ColumnaCsv')
        },
        onButtonGenerarCheque : function() {
            var rec=this.sm.getSelected();
            Phx.CP.loadingShow();

            Ext.Ajax.request({
                url:'../../sis_planillas/control/Planilla/generarDescuentoCheque',
                params:{

                    id_planilla:  rec.data.id_planilla
                },
                success:this.successSave,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        preparaMenu:function()
        {	var rec = this.sm.getSelected();
            //this.desactivarMenu();
            Phx.vista.PlanillaConsulta.superclass.preparaMenu.call(this);


            this.getBoton('btnObs').enable();
            this.getBoton('btnChequeoDocumentosWf').enable();

            //MANEJO DEL BOTON DE GESTION DE PRESUPUESTOS
            this.getBoton('diagrama_gantt').enable();

        },
        liberaMenu:function()
        {
            this.desactivarMenu();
            Phx.vista.PlanillaConsulta.superclass.liberaMenu.call(this);

        },
        desactivarMenu:function() {

            if(this.nombreVista == 'planillavbpoa') {
                this.getBoton('obs_poa').disable();
            }
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('btnObs').disable();
        },

        loadCheckDocumentosPlanWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                'Chequear documento del WF',
                {
                    width:'90%',
                    height:500
                },
                rec.data,
                this.idContenedor,
                'DocumentoWf'
            )
        }




    })
</script>