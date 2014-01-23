<?php
/**
*@package pXP
*@file gen-HorasTrabajadas.php
*@author  (admin)
*@date 22-01-2014 16:11:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.HorasTrabajadas=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.HorasTrabajadas.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_horas_trabajadas'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_funcionario_planilla',
				fieldLabel: 'id_funcionario_planilla',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_funcionario_planilla',
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
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_uo_funcionario',
				fieldLabel: 'id_uo_funcionario',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_/control/Clase/Metodo',
					id: 'id_',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
				}),
				valueField: 'id_',
				displayField: 'nombre',
				gdisplayField: 'desc_',
				hiddenName: 'id_uo_funcionario',
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
					return String.format('{0}', record.data['desc_']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'tipo_contrato',
				fieldLabel: 'tipo_contrato',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'hortra.tipo_contrato',type:'string'},
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
				filters:{pfiltro:'hortra.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'horas_nocturnas',
				fieldLabel: 'horas_nocturnas',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_nocturnas',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'horas_disponibilidad',
				fieldLabel: 'horas_disponibilidad',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_disponibilidad',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'horas_extras',
				fieldLabel: 'horas_extras',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_extras',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'horas_normales',
				fieldLabel: 'horas_normales',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_normales',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
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
				filters:{pfiltro:'hortra.fecha_reg',type:'date'},
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
				filters:{pfiltro:'hortra.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Horas Trabajadas',
	ActSave:'../../sis_planillas/control/HorasTrabajadas/insertarHorasTrabajadas',
	ActDel:'../../sis_planillas/control/HorasTrabajadas/eliminarHorasTrabajadas',
	ActList:'../../sis_planillas/control/HorasTrabajadas/listarHorasTrabajadas',
	id_store:'id_horas_trabajadas',
	fields: [
		{name:'id_horas_trabajadas', type: 'numeric'},
		{name:'id_funcionario_planilla', type: 'numeric'},
		{name:'id_uo_funcionario', type: 'numeric'},
		{name:'tipo_contrato', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'horas_nocturnas', type: 'numeric'},
		{name:'horas_disponibilidad', type: 'numeric'},
		{name:'horas_extras', type: 'numeric'},
		{name:'horas_normales', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_horas_trabajadas',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		