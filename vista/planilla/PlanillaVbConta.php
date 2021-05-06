<?php
/**
 *@package pXP
 *@file PlanillaVbConta.php
 *@author  (rac kplian)
 *@date 11-09-2019 1
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * 
    HISTORIAL DE MODIFICACIONES:       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION   
 #38             11/09/2019        RAC KPLIAN           creacion de cbte de debengado o de pago  independiente al wf de la planilla
 #47    ETR      24-09-2019        Manuel Guerra        reporte de verificacion presupuestaria
 #74             04-11-2019        Rensi Arteaga        esconde opciones para contadores
 #79    ETR      27/11/2019        RAC KPLIAN           nueva columnas para habilitar o des-habilitar el botón de cbte de devengados
 #ETR-2755		 02.02.2021		   MZM KPLIAN	   		Reporte de verificacion presupuestaria xls
 #ETR-3825		 06.05.2021		   MZM KPLIAN	   		Reporte de verificacion presupuestaria disgregada por CeCo
 */	

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PlanillaVbConta=Ext.extend(Phx.gridInterfaz,{

        bnew: false,
        bedit: false,
        bdel: false,
        btest: false,
        bsave: false,
        nombreVista: 'PlanillaVbConta',
        constructor:function(config){

            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.PlanillaVbConta.superclass.constructor.call(this,config);
            this.init();
            this.iniciarEventos();
            

            this.addButton('ant_estado',{grupo:[0,1],argument: {estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
            this.addButton('sig_estado',{grupo:[0],text:'Siguiente',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
            this.addButton('diagrama_gantt',{grupo:[0,1],text:'Gant',iconCls: 'bgantt',disabled:true,handler:diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});

            this.addButton('btnChequeoDocumentosWf',
                {	grupo:[0,1],
                    text: 'Documentos',
                    iconCls: 'bchecklist',
                    disabled: true,
                    handler: this.loadCheckDocumentosPlanWf,
                    tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
                }
            );
            
            this.addButton('btnPresupuestos',
            {	grupo:[0,1],
                iconCls: 'bstats',
                disabled: false,  
                text:'Presupuestos',
                tooltip: 'Gestion de Presupuestos',
                xtype: 'splitbutton',  
                menu: [{
                    text: 'Presupuesto por Empleado',
                    id: 'btnPresupuestoEmpleado-' + this.idContenedor,
                    handler: this.onButtonPresupuestoEmpleado,
                    tooltip: 'Detalle de Presupuestos por Empleado',
                    scope: this
                }, {
                    text: 'Presupuestos Consolidados',
                    id: 'btnPresupuestosCons-' + this.idContenedor,
                    handler: this.onButtonPresupuestosConsolidado,
                    tooltip: 'Presupuestos Consolidados por Columnas' ,
                    scope: this
                },
                //#47
                {   
                    text: 'Verificacion Presupuestaria',
                    id: 'btnVerPre-' + this.idContenedor,
                    handler: this.onVerPre,
                    tooltip: 'Verificacion Presupuestaria' ,
                    scope: this
                },
                {   
                    text: 'Verificacion Presupuestaria Xls',
                    id: 'btnVerPreXls-' + this.idContenedor,
                    handler: this.onVerPreXls,
                    tooltip: 'Verificacion Presupuestaria Xls' ,
                    scope: this
                },//#TR-3825
                {   
                    text: 'Verificacion Presupuestaria x CeCo Xls',
                    id: 'btnVerPreCCXls-' + this.idContenedor,
                    handler: this.onVerPreCCXls,
                    tooltip: 'Verificacion Presupuestaria x CeCo Xls' ,
                    scope: this
                }
                ]                              
            }
        );
        this.addButton('btnObligaciones',
            {	grupo:[0,1],
                iconCls: 'bmoney',
                text:'Obligaciones',
                disabled: true,                
                handler: this.onButtonObligacionesDetalle,
                tooltip: 'Detalle de Obligaciones'                
            }
        );
        
        this.addButton('btnObs',{
                grupo:[0,1],
                text :'Obs Wf.',
                iconCls : 'bchecklist',
                disabled: true,
                handler : this.onOpenObs,
                tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
         });
		//
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
            /*
            this.addButton('btnHoras',
                {	grupo:[0,1],
                    iconCls: 'bclock',
                    text:'Horas',
                    disabled: true,
                    handler: this.onButtonHorasDetalle,
                    tooltip: 'Detalle Horas Trabajadas'
                }
            );

            this.addButton('btnColumnas',
                {	grupo:[0,1],
                    iconCls: 'bcalculator',
                    disabled: false,
                    text:'Columnas',
                    tooltip: 'Gestion de Columnas (solo es posible subir csv y editar columnas si el estado es calculo_columnas)',
                    xtype: 'splitbutton',
                    menu: [{
                        text: 'Detalle Columnas',
                        id: 'btnColumnasDetalle-' + this.idContenedor,
                        handler: this.onButtonColumnasDetalle,
                        tooltip: 'Detalle de Columnas por Empleado',
                        scope: this
                    }]
                }
            );*/
            
            this.addButton('SolDev',{text:'Generar  Cbte Devengado', iconCls: 'bpagar',disabled: true, handler: this.onBtnDev ,tooltip: '<b>Solicitar Devengado</b><br/>Genera en cotabilidad el comprobante Correspondiente, devengado  '});
            
            //#78 boton de historico de BK
            this.addButton('PlaniBk',{text:'Histórico BK', iconCls: 'blist',disabled: true, handler: this.onBtnPlaniHis ,tooltip: '<b>Ver Historicos</b><br/> Muestra los backups generados para la planilla seleccionada  '});
            
            
            
            this.store.baseParams.tipo_interfaz =  this.nombreVista;            
            this.store.baseParams.pes_estado = 'vobo_conta';
            this.load({params: {start: 0, limit: this.tam_pag}});            
            this.finCons = true;
        },
        
        //#78
        onBtnPlaniHis: function() {
        	
        	var rec = {maestro: this.sm.getSelected().data, vistaPadre: this.nombreVista };
            Phx.CP.loadWindows('../../../sis_planillas/vista/planilla/PlanillaHis.php',
                    'Histórico Bk',
                    {
                        width: '90%',
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'PlanillaHis');
        	
        },
        
        onBtnDev: function() {
        	
        	var rec=this.sm.getSelected();
        	var confirmado = true;
        	if(rec) {
        	   if(confirm('¿Está seguro de generar un nuevo comprobante de devegado?')){        	   	
        	   	  //si ya existe un cbte de devegado pedimos confirmacion
        	   	  var ids_cbts = ''
        	   	  if(rec.data.id_int_comprobante || rec.data.id_int_comprobante_2){
        	   	  	
        	   	  	 if(rec.data.id_int_comprobante){
        	   	  	 	ids_cbts = rec.data.id_int_comprobante;
        	   	  	 } 
        	   	  	 if(rec.data.id_int_comprobante_2){
        	   	  	 	ids_cbts = ids_cbts + ', ' + rec.data.id_int_comprobante
        	   	  	 }
        	   	  	
        	   	  	if(confirm('¿Previamente fueron  generados los cbtes de devengado id: '+ ids_cbts+' ,continuamos?')){
        	   	  		confirmado = true;
        	   	  	}
        	   	  	else{
        	   	  		confirmado = false;
        	   	  	}        	   	  	
        	   	  } 
        	   	   
        	   	   
        	   	  if(confirmado) {	            	           
			            Phx.CP.loadingShow();
			            Ext.Ajax.request({
			                url:'../../sis_planillas/control/Planilla/generarCbteContable',
			                params: { id_planilla: rec.data.id_planilla, tipo:'devengado', id_obligacion: undefined},
			                success: this.successGenCbte,
			                failure: this.conexionFailure,
			                timeout: this.timeout,
			                scope:this
			            }); 
		           }
	            
                }
             
             }
	         else{
	            alert('no selecciono ningun registro');
	         }
         },
                            
         successGenCbte: function(resp) {
            Phx.CP.loadingHide();
            this.reload();
         },
        
         onButtonHorasDetalle : function() {
            var rec = {maestro: this.sm.getSelected().data};

            Phx.CP.loadWindows('../../../sis_planillas/vista/horas_trabajadas/HorasTrabajadas.php',
                'Horas Trabajadas por Empleado',
                {
                    width:800,
                    height:'90%'
                },
                rec,
                this.idContenedor,
                'HorasTrabajadas');
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

        onButtonColumnasDetalle : function() {
            var rec = {maestro: this.sm.getSelected().data};

            Phx.CP.loadWindows('../../../sis_planillas/vista/funcionario_planilla/FuncionarioPlanillaColumna.php',
                'Detalle de Columnas por Empleado',
                {
                    width:800,
                    height:'90%'
                },
                rec,
                this.idContenedor,
                'FuncionarioPlanillaColumna');
        },
        
        gruposBarraTareas:[
						    {name:'vobo_conta',title:'<H1 align="center"><i class="fa fa-eye"></i> En Contabilidad</h1>',grupo:0,height:0},
                            {name:'planilla_finalizada',title:'<H1 align="center"><i class="fa fa-eye"></i> Finalizadas</h1>',grupo:1,height:0}
                       
                       ],
    
    
	    actualizarSegunTab: function(name, indice){
	        if(this.finCons) {        	 
	             this.store.baseParams.pes_estado = name;                           
	             this.load({params:{start:0, limit:this.tam_pag}});
	        }
	    },
	    beditGroups: [0],
	    bdelGroups:  [0],
	    bactGroups:  [0,1,2],
	    btestGroups: [0],
	    bexcelGroups: [0,1,2],

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
	            config: {
	                name: 'id_tipo_contrato',
	                fieldLabel: 'Tipo Contrato',
	                //typeAhead: false,
	                //forceSelection: false,
	                hiddenName: 'id_tipo_planilla',
	                allowBlank: true,
	                emptyText: 'Tipo Contrato...',
	                store: new Ext.data.JsonStore({
	                    url: '../../sis_organigrama/control/TipoContrato/listarTipoContrato',
	                    id: 'id_tipo_contrato',
	                    root: 'datos',
	                    sortInfo: {
	                        field: 'codigo',
	                        direction: 'ASC'
	                    },
	                    totalProperty: 'total',
	                    fields: ['id_tipo_contrato', 'nombre', 'codigo'],
	                    // turn on remote sorting
	                    remoteSort: true,
	                    baseParams: {par_filtro: 'tipcon.nombre#tipcon.codigo'}
	                }),
	                valueField: 'id_tipo_contrato',
	                displayField: 'nombre',
	                gdisplayField: 'nombre',
	                triggerAction: 'all',
	                lazyRender: true,
	                mode: 'remote',
	                pageSize: 20,
	                queryDelay: 200,
	                listWidth:280,
	                minChars: 2,
	                gwidth: 120,
	                renderer:function (value, p, record){return String.format('{0}', record.data['tipo_contrato']);},
	            },
	            type: 'ComboBox',
	            id_grupo: 0,
	            filters: {
	                pfiltro: 'tipcon.nombre',
	                type: 'string'
	            },
	            grid: true,
	            form: true
	        },
	        {
                config:{
                    name: 'dividir_comprobante',
                    fieldLabel: 'Dividir Comprobante',
                    allowBlank: true,
                    width: 80,
                    gwidth: 80,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['si','no']
                },
                type:'ComboBox',
                id_grupo:1,
                filters:{pfiltro:'plani.apertura_cb',type:'string'},
                valorInicial: 'no',
                grid:true,
                form:true
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
            {name:'obs_poa', type: 'string'},'id_tipo_contrato','tipo_contrato','dividir_comprobante','id_int_comprobante','id_int_comprobante_2',
            'sw_devengado','sw_pago' //#79

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
        onButtonEdit : function () {
            this.ocultarComponente(this.Cmp.id_depto);
            this.ocultarComponente(this.Cmp.id_tipo_planilla);
            this.ocultarComponente(this.Cmp.id_uo);
            this.ocultarComponente(this.Cmp.id_periodo);
            this.ocultarComponente(this.Cmp.id_gestion);
            Phx.vista.PlanillaVbConta.superclass.onButtonEdit.call(this);

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


        onButtonNew : function () {
            this.mostrarComponente(this.Cmp.id_depto);
            this.mostrarComponente(this.Cmp.id_tipo_planilla);
            this.mostrarComponente(this.Cmp.id_uo);
            this.mostrarComponente(this.Cmp.id_periodo);
            this.mostrarComponente(this.Cmp.id_gestion);
            Phx.vista.Planilla.superclass.onButtonNew.call(this);

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
            this.desactivarMenu();
            Phx.vista.PlanillaVbConta.superclass.preparaMenu.call(this);

            //this.getBoton('btnHoras').enable();
            
            

            if (rec.data.estado == 'registro_funcionarios') {
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').enable();

            } else if (rec.data.estado == 'planilla_finalizada') {
                       	
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').disable();


            } else if (rec.data.estado == 'obligaciones_generadas' ||
                rec.data.estado == 'comprobante_presupuestario_validado' ||
                rec.data.estado == 'comprobante_obligaciones') {
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();

            } else {
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
            }

            if(this.nombreVista == 'planillavbpoa') {
                this.getBoton('obs_poa').enable();
            }
            
            //valida configuracion de tipo plani para habilitar o co cl bte de devegado
            if(rec.data.estado == 'vobo_conta' && rec.data.sw_devengado == 'si'){
            	this.getBoton('SolDev').enable();
            }
            else{
            	this.getBoton('SolDev').disable();
            }
            
            this.getBoton('btnObs').enable();
            this.getBoton('btnChequeoDocumentosWf').enable();

            //MANEJO DEL BOTON DE GESTION DE PRESUPUESTOS
            this.getBoton('diagrama_gantt').enable();            
            this.getBoton('btnPresupuestos').enable();           
            this.getBoton('btnObligaciones').enable(); 
           
            this.getBoton('PlaniBk').enable(); //#78

        },
        liberaMenu:function()
        {
            this.desactivarMenu();
            Phx.vista.PlanillaVbConta.superclass.liberaMenu.call(this);

        },
        desactivarMenu:function() {
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('sig_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('PlaniBk').disable();//#78
            
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
        },
        sigEstado:function(){
            var rec=this.sm.getSelected();
            this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                'Estado de Wf',
                {
                    modal:true,
                    width:700,
                    height:450
                }, {data:{
                    id_estado_wf:rec.data.id_estado_wf,
                    id_proceso_wf:rec.data.id_proceso_wf,
                    fecha_ini:rec.data.fecha_tentativa,

                }}, this.idContenedor,'FormEstadoWf',
                {
                    config:[{
                        event:'beforesave',
                        delegate: this.onSaveWizard,

                    }],

                    scope:this
                });

        },



        onSaveWizard:function(wizard,resp){
            Phx.CP.loadingShow();

            Ext.Ajax.request({
                url:'../../sis_planillas/control/Planilla/siguienteEstadoPlanilla',
                params:{

                    id_proceso_wf_act:  resp.id_proceso_wf_act,
                    id_estado_wf_act:   resp.id_estado_wf_act,
                    id_tipo_estado:     resp.id_tipo_estado,
                    id_funcionario_wf:  resp.id_funcionario_wf,
                    id_depto_wf:        resp.id_depto_wf,
                    obs:                resp.obs,
                    json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
                success:this.successWizard,
                failure: this.conexionFailure,
                argument:{wizard:wizard},
                timeout:this.timeout,
                scope:this
            });
        },

        successWizard:function(resp){
            Phx.CP.loadingHide();
            resp.argument.wizard.panel.destroy()
            this.reload();
        },

        antEstado:function(){
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
                'Estado de Wf',
                {
                    modal:true,
                    width:450,
                    height:250
                }, {data:rec.data}, this.idContenedor,'AntFormEstadoWf',
                {
                    config:[{
                        event:'beforesave',
                        delegate: this.onAntEstado,
                    }
                    ],
                    scope:this
                })
        },

        onAntEstado:function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_planillas/control/Planilla/anteriorEstadoPlanilla',
                params:{
                    id_proceso_wf:resp.id_proceso_wf,
                    id_estado_wf:resp.id_estado_wf,
                    obs:resp.obs
                },
                argument:{wizard:wizard},
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });

        },

        successEstadoSinc:function(resp){
            Phx.CP.loadingHide();
            resp.argument.wizard.panel.destroy()
            this.reload();
        },

        onButtonPresupuestoEmpleado : function() {
	    	var rec = {maestro: this.sm.getSelected().data};
							      
	            Phx.CP.loadWindows('../../../sis_planillas/vista/presupuesto_empleado/PresupuestoEmpleado.php',
	                    'Apropiacion Presupuestaria por Empleado',
	                    {
	                        width:800,
	                        height:'90%'
	                    },
	                    rec,
	                    this.idContenedor,
	                    'PresupuestoEmpleado');
	    },
    
	    onButtonPresupuestosConsolidado : function () {
	    		var rec = {maestro: this.sm.getSelected().data};
							      
	            Phx.CP.loadWindows('../../../sis_planillas/vista/consolidado/Consolidado.php',
	                    'Consolidado Presupuestario',
	                    {
	                        width:800,
	                        height:'90%'
	                    },
	                    rec,
	                    this.idContenedor,
	                    'Consolidado');
	    },
	        
         onButtonObligacionesDetalle : function () {
    		var rec = {maestro: this.sm.getSelected().data, vistaPadre: this.nombreVista };
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/obligacion/ObligacionConta.php',
                    'Obligaciones VoBo Conta',
                    {
                        width: '90%',
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'ObligacionConta');
    },

     submitObs:function() {
            Phx.CP.loadingShow();
            var data = this.getSelectedData(), url, params;

            if(this.nombreVista == 'planillavbpoa') {
                url = '../../sis_planillas/control/Planilla/modificarObsPoa';
                params = {
                    id_planilla:data.id_planilla,
                    obs_poa: this.cmbObsPoa.getValue(),
                    codigo_poa: this.cmbCodigoPoa.getValue()
                };
            }
            Ext.Ajax.request({
                url: url,
                params: params,
                success: function(resp){
                    Phx.CP.loadingHide();
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                    if(!reg.ROOT.error){
                        this.reload();
                        this.wObs.hide();
                    }
                },
                failure: function(resp1,resp2,resp3){

                    this.conexionFailure(resp1,resp2,resp3);
                    var d = this.sm.getSelected().data;


                },
                timeout:this.timeout,
                scope:this
            });

       },
        //#47
		onVerPre : function() {
			var rec = this.getSelectedData();		
			if(rec)
			{
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url:'../../sis_planillas/control/Planilla/reporteVerifPresu',
					params:{
						'id_planilla':rec.id_planilla
					},
					success:this.successExport,
					failure: this.conexionFailure,
					timeout:this.timeout,
					scope:this
				});		
			}
			else
			{
				Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
			}
		},
		onVerPreXls : function() {
			var rec = this.getSelectedData();		
			if(rec)
			{
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url:'../../sis_planillas/control/Planilla/reporteVerifPresu',
					params:{
						'id_planilla':rec.id_planilla,
						'nro_planilla':rec.nro_planilla,
						'tipo_reporte':'xls'
					},
					success:this.successExport,
					failure: this.conexionFailure,
					timeout:this.timeout,
					scope:this
				});		
			}
			else
			{
				Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
			}
		},//#ETR-3825
		onVerPreCCXls : function() {
			var rec = this.getSelectedData();		
			if(rec)
			{
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url:'../../sis_planillas/control/Planilla/reporteVerifPresuCC',
					params:{
						'id_planilla':rec.id_planilla,
						'nro_planilla':rec.nro_planilla,
						'tipo_reporte':'xls'
					},
					success:this.successExport,
					failure: this.conexionFailure,
					timeout:this.timeout,
					scope:this
				});		
			}
			else
			{
				Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
			}
		}
    })
</script>