<?php
/**
 *@package pXP
 *@file PlanillaHis.php
 *@author  (rac kplian)
 *@date 11-09-2019 1
 *@description interface para los backupde la planilla 
 * 
    HISTORIAL DE MODIFICACIONES:       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION   
 #78             18-11-2019        Rensi Arteaga        Creacion
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PlanillaHis=Ext.extend(Phx.gridInterfaz,{

        bnew: false,
        bedit: false,
        bdel: false,
        btest: false,
        bsave: false,
        nombreVista: 'PlanillaHis',
        constructor:function(config) {
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.PlanillaHis.superclass.constructor.call(this,config);
            this.init();
	        this.addButton('btnObligaciones',
	            {	grupo:[0,1],
	                iconCls: 'bmoney',
	                text:'Obligaciones',
	                disabled: true,                
	                handler: this.onButtonObligacionesDetalle,
	                tooltip: 'Detalle de Obligaciones'                
	            }
	        );
	        
	        this.addButton('btnColumnas',
                {	
                    iconCls: 'bcalculator',
                    disabled: true,                    
                    tooltip: 'Gestion de Columnas (solo es posible subir csv y editar columnas si el estado es calculo_columnas)',
                    text: 'Detalle Columnas',
                    handler: this.onButtonColumnasDetalle,
                    tooltip: 'Detalle de Columnas por Empleado',
                    scope: this
                }
            );
	        
	        this.store.baseParams.id_planilla_original = this.maestro.id_planilla;
            this.store.baseParams.tipo_interfaz =  this.nombreVista;            
            this.store.baseParams.pes_estado = 'vobo_conta';
            this.load({params: {start: 0, limit: this.tam_pag}});            
            this.finCons = true;
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
                    name: 'fecha_backup',
                    fieldLabel: 'Fecha Backup',
                    allowBlank: false,                    
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'plani.fecha_backup',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
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
                form: false,
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
	            form: false
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
                form:false
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
                form:false
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
                form : false,
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
                form : false,
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
                form:false
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
                form:false
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
                form:false
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
        title: 'Planilla',
        ActList: '../../sis_planillas/control/Planilla/listarPlanillaBk',
        id_store: 'id_planilla',
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
            'id_tipo_contrato','tipo_contrato',
            'dividir_comprobante','id_int_comprobante',
            'id_int_comprobante_2','id_planilla_original',  {name:'fecha_backup', type: 'date',dateFormat:'Y-m-d'},

        ],
        sortInfo:{
            field: 'id_planilla',
            direction: 'DESC'
        },

        preparaMenu:function()
        {	var rec = this.sm.getSelected();
            this.desactivarMenu();
            Phx.vista.PlanillaHis.superclass.preparaMenu.call(this);
            
            this.getBoton('btnObligaciones').enable(); 
            this.getBoton('btnColumnas').enable(); 
            

        },
        liberaMenu:function()
        {
            Phx.vista.PlanillaHis.superclass.liberaMenu.call(this);            
            this.getBoton('btnColumnas').disable(); 

        },
        
        desactivarMenu: function() {
        	
        },
        
        onButtonColumnasDetalle : function() {
            var rec = {maestro: this.sm.getSelected().data , esquema: 'planibk'};
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

        onButtonObligacionesDetalle : function () {
    		var rec = {maestro: this.sm.getSelected().data, vistaPadre: this.nombreVista , esquema: 'planibk'};
            Phx.CP.loadWindows('../../../sis_planillas/vista/obligacion/ObligacionConta.php',
                    'Obligaciones Histórico',
                    {
                        width: '90%',
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'ObligacionConta');
        }         
    })
</script>