<?php
/**
*@package pXP
*@file gen-TipoObligacion.php
*@author  (admin)
*@date 17-01-2014 19:43:19
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE 	FORK		FECHA			AUTHOR			DESCRIPCION
 * #3		EndeEtr		05/02/2019		EGS				Se agrego el campo id_tipo_obligacion_agrupador
 * #1		EndeEtr		19/02/2019		EGS				Se agrego el campo descripcion	
 * #1		EndeEtr		20/02/2019		EGS				se agrego los campos codigo_tipo_relacion_debe,codigo_tipo_relacion_haber
 * #46		ETR			19.09.2019		MZM				Adicion de campo tipo_abono para reporte abono en cuenta
 * #73		ETR			04.11.2019		MZM				Omitir obligatoriedad de tipo_abono		 	
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoObligacion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoObligacion.superclass.constructor.call(this,config);
		this.init();
		
		this.load({params:{start:0, limit:this.tam_pag,id_tipo_planilla : this.maestro.id_tipo_planilla}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_obligacion'
			},
			type:'Field',
			form:true 
		},
		
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_planilla'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '50%',
				gwidth: 80,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'tipobli.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				maxLength:150
			},
				type:'TextField',
				filters:{pfiltro:'tipobli.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tipo_obligacion',
				fieldLabel: 'Tipo Obligacion',
				allowBlank:false,
				emptyText:'obligacion para...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['pago_empleados','pago_afp','pago_comun','una_obligacion_x_empleado']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['pago_empleados','pago_afp','pago_comun','una_obligacion_x_empleado'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},				
		{
			config:{
				name: 'dividir_por_lugar',
				fieldLabel: 'Dividir obligación por lugar',
				allowBlank:false,
				emptyText:'dividir...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no'],
				qtip:'Si se generará una obligación separada por lugar'
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['si','no'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'es_pagable',
				fieldLabel: 'Es Pagable',
				allowBlank:false,
				emptyText:'pagable...',
	       		typeAhead: false,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				qtipo:'Si la obligación se debe pagar a un proveedor o es un movimiento interno entre cuentas de la empresa',
				store:['si','no'],
				
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['si','no'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},
		 //#3	EGS
		{
			config: {
				name: 'id_tipo_obligacion_agrupador',
				fieldLabel: 'Codigo Agrupador',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/TipoObligacionAgrupador/listarTipoObligacionAgrupador',
					id: 'id_tipo_obligacion_agrupador',
					root: 'datos',
					sortInfo: {
						field: 'id_tipo_obligacion_agrupador',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_obligacion_agrupador', 'nombre', 'codigo','codigo_plantilla_comprobante'],
					remoteSort: true,
					baseParams: {par_filtro: 'tiobag.id_tipo_obligacion_agrupador#tiobag.nombre#tiobag.codigo#tiobag.codigo_plantilla_comprobante'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo: </b>{codigo}</p>\
		                       <p><b>Nombre : </b>{nombre}</p>\
		                       <p><b>Codigo Pla. Comprobante : </b>{codigo_plantilla_comprobante}</p>\
		                       </div></tpl>',
				valueField: 'id_tipo_obligacion_agrupador',
				displayField: 'codigo',
				gdisplayField: 'codigo_agrupador',
				hiddenName: 'id_tipo_obligacion_agrupador',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo_agrupador']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'tiobag.codigo',type: 'string'},
			grid: true,
			form: true
		},
		 //#3	EGS
		 //#1 EGS
		{
                    config: {
                        name: 'descripcion',
                        fieldLabel: 'Descripcion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 1000
                    },
                    type: 'TextArea',
                    filters: {pfiltro: 'tiobag.descripcion', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
         },		
		//#1 EGS
		{ //#1
			config: {
				name: 'codigo_tipo_relacion_debe',
				fieldLabel: 'Codigo relacion Contable Debe',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/TipoRelacionContable/listarTipoRelacionContable',
					id: 'id_tipo_relacion_contable',
					root: 'datos',
					sortInfo: {
						field: 'id_tipo_relacion_contable',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_relacion_contable', 'nombre_tipo_relacion', 'codigo_tipo_relacion'],
					remoteSort: true,
					baseParams: {par_filtro: 'tiprelco.id_tipo_relacion_contable#tiprelco.nombre_tipo_relacion#tiprelco.codigo_tipo_relacion'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo: </b>{codigo_tipo_relacion}</p>\
		                       <p><b>Nombre : </b>{nombre_tipo_relacion}</p>\
		                       </div></tpl>',
				valueField: 'codigo_tipo_relacion',
				displayField: 'codigo_tipo_relacion',
				gdisplayField: 'codigo_tipo_relacion',
				hiddenName: 'codigo_tipo_relacion',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo_tipo_relacion_debe']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'tiobag.codigo',type: 'string'},
			grid: true,
			form: true
		},
		{//#1
			config: {
				name: 'codigo_tipo_relacion_haber',
				fieldLabel: 'Codigo relacion Contable Haber',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/TipoRelacionContable/listarTipoRelacionContable',
					id: 'id_tipo_relacion_contable',
					root: 'datos',
					sortInfo: {
						field: 'id_tipo_relacion_contable',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_relacion_contable', 'nombre_tipo_relacion', 'codigo_tipo_relacion'],
					remoteSort: true,
					baseParams: {par_filtro: 'tiprelco.id_tipo_relacion_contable#tiprelco.nombre_tipo_relacion#tiprelco.codigo_tipo_relacion'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo: </b>{codigo_tipo_relacion}</p>\
		                       <p><b>Nombre : </b>{nombre_tipo_relacion}</p>\
		                       </div></tpl>',
				valueField: 'codigo_tipo_relacion',
				displayField: 'codigo_tipo_relacion',
				gdisplayField: 'codigo_tipo_relacion',
				hiddenName: 'codigo_tipo_relacion',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo_tipo_relacion_haber']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'tiobag.codigo',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'tipo_abono',
				fieldLabel: 'Tipo de Abono',
				allowBlank:true, //#73
				emptyText:'Tipo Abono...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
	       		width: 100,	
				gwidth: 150,
				store:[
				['07','07 - Abono Normal']
				,['08','08 - Prima']
				,['09','09 - Aguinaldo']
				
				]
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
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
				filters:{pfiltro:'tipobli.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'tipobli.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tipobli.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
		
	],
	tam_pag:50,	
	title:'Tipo Obligación',
	ActSave:'../../sis_planillas/control/TipoObligacion/insertarTipoObligacion',
	ActDel:'../../sis_planillas/control/TipoObligacion/eliminarTipoObligacion',
	ActList:'../../sis_planillas/control/TipoObligacion/listarTipoObligacion',
	id_store:'id_tipo_obligacion',
	fields: [
		{name:'id_tipo_obligacion', type: 'numeric'},
		{name:'tipo_obligacion', type: 'string'},
		{name:'dividir_por_lugar', type: 'string'},
		{name:'es_pagable', type: 'string'},
		{name:'id_tipo_planilla', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
     	{name:'id_tipo_obligacion_agrupador', type: 'numeric'}, //#3	EGS
		{name:'codigo_agrupador', type: 'string'}, //#3	EGS
		{name:'descripcion', type: 'string'}, //#1	EGS
		{name:'codigo_tipo_relacion_debe', type: 'string'},//#1	EGS
		{name:'codigo_tipo_relacion_haber', type: 'string'},//#1	EGS		
		{name:'tipo_abono', type: 'string'},//#46	MZM
	],
	sortInfo:{
		field: 'id_tipo_obligacion',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	loadValoresIniciales:function()
    {
    	this.Cmp.id_tipo_planilla.setValue(this.maestro.id_tipo_planilla);       
        Phx.vista.TipoObligacion.superclass.loadValoresIniciales.call(this);        
    },
    onButtonEdit:function(){
		//llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
		this.ocultarComponente(this.Cmp.codigo);
		Phx.vista.TipoObligacion.superclass.onButtonEdit.call(this);
	},
	onButtonNew:function(){
		//llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
		this.mostrarComponente(this.Cmp.codigo);
		Phx.vista.TipoObligacion.superclass.onButtonNew.call(this);
	},
	south:{
		  url:'../../../sis_planillas/vista/tipo_obligacion_columna/TipoObligacionColumna.php',
		  title:'Tipo Columna Obligación', 
		  height:'50%',
		  cls:'TipoObligacionColumna'
	},
	}
)
</script>
		
		