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
Phx.vista.Planilla=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbReporte,this.cmbTipoReporte];
    	//llama al constructor de la clase padre
		Phx.vista.Planilla.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag}});
			
		this.addButton('btnHoras',
            {
                iconCls: 'bclock',
                disabled: false,
                tooltip: 'Gestion de Horas Trabajadas',
                xtype: 'splitbutton',
                menu: [{
                    text: 'Generar Horas',
                    id: 'btnHorasGenerar-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'horasGenerar' },
                    tooltip: 'Generar Horas Trabajadas',
                    scope: this
                }, {
                    text: 'Detalle Horas',
                    id: 'btnHorasDetalle-' + this.idContenedor,
                    handler: this.onButtonHorasDetalle,
                    tooltip: 'Detalle Horas Trabajadas',
                    scope: this
                }, {
                    text: 'Validar Horas',
                    id: 'btnHorasValidar-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'horasValidar' },
                    tooltip: 'Detalle Horas Trabajadas',
                    scope: this
                }]
            }
        );
        
        this.addButton('btnColumnas',
            {
                iconCls: 'bcalculator',
                disabled: false,
                tooltip: 'Gestion de Columnas',
                xtype: 'splitbutton',
                menu: [{
                    text: 'Calcular Columnas',
                    id: 'btnColumnasCalcular-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'columnasCalcular' },
                    tooltip: 'Calcular Columnas',
                    scope: this
                }, {
                    text: 'Detalle Columnas',
                    id: 'btnColumnasDetalle-' + this.idContenedor,
                    handler: this.onButtonColumnasDetalle,
                    tooltip: 'Detalle de Columnas por Empleado',
                    scope: this
                }, {
                    text: 'Subir Columnas desde CSV',
                    id: 'btnColumnasCsv-' + this.idContenedor,
                    handler: this.onButtonColumnasCsv,
                    tooltip: 'Subir Columnas desde archivo Csv',
                    scope: this
                }, {
                    text: 'Validar Columnas',
                    id: 'btnColumnasValidar-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'columnasValidar' },
                    tooltip: 'Validar Calculo de Columnas',
                    scope: this
                }]
            }
        );
        
        this.addButton('btnPresupuestos',
            {
                iconCls: 'bstats',
                disabled: false,
                tooltip: 'Gestion de Presupuestos',
                xtype: 'splitbutton',
                menu: [{
                    text: 'Generar Presupuestos',
                    id: 'btnPresupuestos-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'presupuestosGenerar' },
                    tooltip: 'Generar Porcentajes Presupuestarios por Empleado y Consolidados <br>	(Estos porcentajes pueden ser revisados desde la pantalla de Gestionar Horas Trabajadas->Detalle Horas <br> o desde el detalle de funcionarios)',
                    scope: this
                }, {
                    text: 'Presupuestos Consolidados',
                    id: 'btnPresupuestosConsolidado-' + this.idContenedor,
                    handler: this.onButtonPresupuestosConsolidado,
                    tooltip: 'Presupuestos Consolidados por Columnas',
                    scope: this
                },
                {
                    text: 'Validar Presupuestos',
                    id: 'btnPresupuestosValidar-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'presupuestosValidar' },
                    scope: this
                }]
            }
        );
        this.addButton('btnObligaciones',
            {
                iconCls: 'bmoney',
                disabled: false,
                tooltip: 'Gestión de Obligaciones',
                xtype: 'splitbutton',
                menu: [{
                    text: 'Generar Obligaciones',
                    id: 'btnObligacionesGenerar-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'obligacionesGenerar' },
                    tooltip: 'Generar Obligaciones',
                    scope: this
                }, {
                    text: 'Detalle de Obligaciones',
                    id: 'btnObligacionesDetalle-' + this.idContenedor,
                    handler: this.onButtonObligacionesDetalle,
                    tooltip: 'Detalle de Obligaciones',
                    scope: this
                }, {
                    text: 'Validar Obligaciones',
                    id: 'btnObligacionesValidar-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'obligacionesValidar' },
                    tooltip: 'Validar Obligaciones de la Planilla',
                    scope: this
                }, {
                    text: 'Enviar Obligaciones',
                    id: 'btnObligacionesPago-' + this.idContenedor,
                    handler: this.onButtonAjax,
                    argument: { accion: 'obligacionesEnviar' },
                    tooltip: 'Genera las Obligaciones de Pago en Tesorería',
                    scope: this
                }]
            }
        );
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
   				name:'id_depto',
   				 hiddenName: 'id_depto',
   				 url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
	   				origen:'DEPTO',
	   				allowBlank:false,
	   				fieldLabel: 'Depto',
	   				gdisplayField:'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
	   				width:250,
   			        gwidth:180,
	   				baseParams:{estado:'activo',codigo_subsistema:'ORGA'},//parametros adicionales que se le pasan al store
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
				name: 'nro_planilla',
				fieldLabel: 'No',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'plani.nro_planilla',type:'string'},
				id_grupo:1,
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
				form:false
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
				gdisplayField: 'codigo_planilla',
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
				pfiltro: 'tippla.codigo',
				type: 'string'
			},
			grid: true,
			form: true
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
	   			form : true
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
	   			form : true
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
   				baseParams: {planilla: 'si'},
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
				form:false
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
		{name:'codigo_planilla', type: 'string'},
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
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_planilla',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
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
		
		this.cmbReporte.on('select', function (c,r,i) {
			var rec=this.sm.getSelected();
			var url_reporte = '../../sis_planillas/control/';
			if (r.data.control_reporte == '' || r.data.control_reporte == undefined) {
				url_reporte = url_reporte + 'Reporte/reportePlanilla'
			} else {
				url_reporte = url_reporte + r.data.control_reporte;
			}
			Phx.CP.loadingShow();
		    Ext.Ajax.request({
		        url:url_reporte,
		        params:{'id_proceso_wf':rec.data.id_proceso_wf, 'id_reporte' : r.data.id_reporte,
		        		'tipo_reporte':this.cmbTipoReporte.getValue()},
		        success: this.successExport,
		        failure: this.conexionFailure,
		        timeout:this.timeout,
		        scope:this
		    }); 
		    this.cmbReporte.reset();
			
		}, this);
	},
	onButtonEdit : function () {
		this.ocultarComponente(this.Cmp.id_depto);
    	this.ocultarComponente(this.Cmp.id_tipo_planilla);
    	this.ocultarComponente(this.Cmp.id_uo);
    	this.ocultarComponente(this.Cmp.id_periodo);
    	this.ocultarComponente(this.Cmp.id_gestion); 
    	Phx.vista.Planilla.superclass.onButtonEdit.call(this);
    	
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
    		var rec = {maestro: this.sm.getSelected().data};
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/obligacion/Obligacion.php',
                    'Obligaciones',
                    {
                        width:800,
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'Obligacion');
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
    preparaMenu:function()
    {	var rec = this.sm.getSelected();
        this.desactivarMenu();
        if (rec.data.estado == 'registro_horas' || rec.data.estado == 'registro_funcionarios'  || rec.data.estado == 'borrador' ) {
        	this.cmbReporte.disable();        	
        } else {
        	this.cmbReporte.enable();
        }
        
        
        //MANEJO DEL BOTON DE GESTION DE HORAS      
        if (rec.data.calculo_horas == 'si') {
        	this.getBoton('btnHoras').enable(); 
        	if (rec.data.estado == 'registro_funcionarios' ) {        		
        		this.getBoton('btnHoras').menu.items.items[0].enable();
        		this.getBoton('btnHoras').menu.items.items[1].disable();
        		this.getBoton('btnHoras').menu.items.items[2].disable();        		     		
        	} else if (rec.data.estado == 'registro_horas') {
        		this.getBoton('btnHoras').menu.items.items[0].disable();
        		this.getBoton('btnHoras').menu.items.items[1].enable();
        		this.getBoton('btnHoras').menu.items.items[2].enable();  
        	} else {
        		this.getBoton('btnHoras').menu.items.items[0].disable();
        		this.getBoton('btnHoras').menu.items.items[1].enable();
        		this.getBoton('btnHoras').menu.items.items[2].disable();
        	}
        }
        
        //MANEJO DEL BOTON DE GESTION DE COLUMNAS
        if (rec.data.estado != 'registro_horas' && rec.data.estado != 'registro_funcionarios') {
        	this.getBoton('btnColumnas').enable();
        } 
        if (rec.data.estado == 'calculo_columnas' ) { 
        	this.getBoton('btnColumnas').menu.items.items[0].enable();
        	this.getBoton('btnColumnas').menu.items.items[1].enable();
        	this.getBoton('btnColumnas').menu.items.items[2].enable();
        	this.getBoton('btnColumnas').menu.items.items[3].enable();
        	
        } else {
        	this.getBoton('btnColumnas').menu.items.items[1].enable();
        	this.getBoton('btnColumnas').menu.items.items[0].disable();
        	this.getBoton('btnColumnas').menu.items.items[2].disable();
        	this.getBoton('btnColumnas').menu.items.items[3].disable();        	
        }
        //MANEJO DEL BOTON DE GESTION DE PRESUPUESTOS
        
    	this.getBoton('btnPresupuestos').enable(); 
    	if (rec.data.estado == 'calculo_validado' ) {        		
    		this.getBoton('btnPresupuestos').menu.items.items[0].enable();
    		this.getBoton('btnPresupuestos').menu.items.items[1].disable();
    		this.getBoton('btnPresupuestos').menu.items.items[2].disable(); 
    		 
    		      		     		
    	} else if (rec.data.estado == 'presupuestos') {
    		this.getBoton('btnPresupuestos').menu.items.items[0].disable();
    		this.getBoton('btnPresupuestos').menu.items.items[1].enable();
    		this.getBoton('btnPresupuestos').menu.items.items[2].enable();
    		
    		 
    	} else if (rec.data.estado == 'obligaciones_validado') {
    		this.getBoton('btnPresupuestos').menu.items.items[0].disable();
    		this.getBoton('btnPresupuestos').menu.items.items[1].enable();
    		this.getBoton('btnPresupuestos').menu.items.items[2].disable();
    		
    		 
    	} else {
    		this.getBoton('btnPresupuestos').menu.items.items[0].disable();
    		this.getBoton('btnPresupuestos').menu.items.items[1].enable();
    		this.getBoton('btnPresupuestos').menu.items.items[2].disable();    		
    	}
        
        this.getBoton('btnObligaciones').enable(); 
        if (rec.data.estado == 'presupuestos_validado' ) {        		
    		this.getBoton('btnObligaciones').menu.items.items[0].enable();
    		this.getBoton('btnObligaciones').menu.items.items[1].enable();
    		this.getBoton('btnObligaciones').menu.items.items[2].disable();
    		this.getBoton('btnObligaciones').menu.items.items[3].disable();      		 
    		      		     		
    	} else if (rec.data.estado == 'obligaciones') {
    		this.getBoton('btnObligaciones').menu.items.items[0].disable();
    		this.getBoton('btnObligaciones').menu.items.items[1].enable();
    		this.getBoton('btnObligaciones').menu.items.items[2].enable();
    		this.getBoton('btnObligaciones').menu.items.items[3].enable();  		
    		 
    	} else {
    		this.getBoton('btnObligaciones').menu.items.items[0].disable();
    		this.getBoton('btnObligaciones').menu.items.items[1].enable();
    		this.getBoton('btnObligaciones').menu.items.items[2].disable();
    		this.getBoton('btnObligaciones').menu.items.items[3].disable(); 
    	}
    	        
        Phx.vista.Planilla.superclass.preparaMenu.call(this);
    },
    liberaMenu:function()
    {	
        this.desactivarMenu();
        this.cmbReporte.disable();
        Phx.vista.Planilla.superclass.liberaMenu.call(this);
    },
    desactivarMenu:function() {
    	
    	this.getBoton('del').disable();    	
    	this.getBoton('btnHoras').disable();     	
        this.getBoton('btnColumnas').disable();        
        this.getBoton('btnPresupuestos').disable(); 
        this.getBoton('btnObligaciones').disable(); 
        
    },
    south:{
		  url:'../../../sis_planillas/vista/funcionario_planilla/FuncionarioPlanilla.php',
		  title:'Funcionarios', 
		  height:'50%',
		  cls:'FuncionarioPlanilla'
	},
    cmbReporte:new Ext.form.ComboBox({
				fieldLabel: '',
				allowBlank: true,
				emptyText:'Reporte...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_planillas/control/Reporte/listarReporte',
					id: 'id_reporte',
					root: 'datos',
					sortInfo:{
						field: 'titulo_reporte',
						direction: 'DESC'
					},
					totalProperty: 'total',
					fields: ['id_reporte','titulo_reporte', 'control_reporte'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'titulo_reporte'}
				}),
				valueField: 'id_reporte',
				triggerAction: 'all',
				displayField: 'titulo_reporte',
			    hiddenName: 'id_reporte',
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:100
	}),
	cmbTipoReporte :new Ext.form.ComboBox({
				fieldLabel: '',
				allowBlank:false,
				emptyText:'Tipo Rep...',
	       		typeAhead: false,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				width: 80,
				store:['pdf','excel'],
				value:'pdf'
	}),
	EnableSelect : function (n, extra) {
		var selected = this.sm.getSelected().data;
		this.cmbReporte.reset();
   		this.cmbReporte.store.setBaseParam('id_tipo_planilla', selected.id_tipo_planilla);
   		this.cmbReporte.modificado = true;	
   		Phx.vista.Planilla.superclass.EnableSelect.call(this,n,extra);  
   		
   }
	
   }
)
</script>
		
		