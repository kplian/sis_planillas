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
    	//llama al constructor de la clase padre
		Phx.vista.Planilla.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag}})
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
	   				baseParams:{estado:'activo',codigo_subsistema:'PLANI'},//parametros adicionales que se le pasan al store
	      			renderer:function (value, p, record){return String.format('{0}', record.data['nombre_depto']);}
   			},
   			//type:'TrigguerCombo',
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'depto.nombre',type:'string'},
   		    grid:false,
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
   				baseParams: {presupuesta: 'si'},
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
	},
	onButtonEdit : function () {
		this.ocultarComponente(this.Cmp.id_depto);
    	this.ocultarComponente(this.Cmp.id_tipo_planilla);
    	this.ocultarComponente(this.Cmp.id_uo);
    	this.ocultarComponente(this.Cmp.id_periodo);
    	this.ocultarComponente(this.Cmp.id_gestion); 
    	Phx.vista.Planilla.superclass.onButtonEdit.call(this);
    	
    },
    onButtonNew : function () {
    	this.mostrarComponente(this.Cmp.id_depto);
    	this.mostrarComponente(this.Cmp.id_tipo_planilla);
    	this.mostrarComponente(this.Cmp.id_uo);
    	this.mostrarComponente(this.Cmp.id_periodo);
    	this.mostrarComponente(this.Cmp.id_gestion);
    	Phx.vista.Planilla.superclass.onButtonNew.call(this);
    	
    }
   }
)
</script>
		
		