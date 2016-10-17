<?php
/**
*@package pXP
*@file gen-TipoObligacionColumna.php
*@author  (admin)
*@date 18-01-2014 02:57:04
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoObligacionColumna=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoObligacionColumna.superclass.constructor.call(this,config);
		this.init();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_obligacion_columna'
			},
			type:'Field',
			form:true 
		},
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
			config: {
				name: 'codigo_columna',
				fieldLabel: 'Código Columna',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'codigo_columna',
				allowBlank: false,
				emptyText: 'Lista de Procesos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/TipoColumna/listarTipoColumna',
					id: 'id_tipo_columna',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_columna', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipcol.nombre#tipcol.codigo', presupuesto_pago:'si'}
				}),
				valueField: 'codigo',
				displayField: 'nombre',
				gdisplayField: 'codigo_columna',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'obcol.codigo_columna',
				type: 'string'
			},
			grid: true,
			form: true
		},		
		{
			config:{
				name: 'presupuesto',
				fieldLabel: 'Presupuesto',
				allowBlank:false,
				emptyText:'Paga presupuesto...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no']
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
				name: 'pago',
				fieldLabel: 'Pago',
				allowBlank:false,
				emptyText:'Suma para pago...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no']
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
				name: 'es_ultimo',
				fieldLabel: 'Pagar Presupuesto por Resta',
				allowBlank:false,
				emptyText:'Por resta...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no'],
				qtip:'Paga el presupuesto de esta columna por resta entre las columnas presupuestarias y de pago'
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
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'obcol.estado_reg',type:'string'},
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
				filters:{pfiltro:'obcol.fecha_reg',type:'date'},
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
				filters:{pfiltro:'obcol.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Obligación Columna',
	ActSave:'../../sis_planillas/control/TipoObligacionColumna/insertarTipoObligacionColumna',
	ActDel:'../../sis_planillas/control/TipoObligacionColumna/eliminarTipoObligacionColumna',
	ActList:'../../sis_planillas/control/TipoObligacionColumna/listarTipoObligacionColumna',
	id_store:'id_tipo_obligacion_columna',
	fields: [
		{name:'id_tipo_obligacion_columna', type: 'numeric'},
		{name:'id_tipo_obligacion', type: 'numeric'},
		{name:'presupuesto', type: 'string'},
		{name:'pago', type: 'string'},
		{name:'es_ultimo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo_columna', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_tipo_obligacion_columna',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage:function(m){
		this.maestro=m;					
		this.load({params:{start:0, limit:this.tam_pag,id_tipo_obligacion:this.maestro.id_tipo_obligacion}});
		this.Cmp.codigo_columna.store.baseParams.id_tipo_planilla = this.maestro.id_tipo_planilla;			
	},
	loadValoresIniciales:function()
    {
    	this.Cmp.id_tipo_obligacion.setValue(this.maestro.id_tipo_obligacion);       
        Phx.vista.TipoObligacionColumna.superclass.loadValoresIniciales.call(this);        
    },
	}
)
</script>
		
		