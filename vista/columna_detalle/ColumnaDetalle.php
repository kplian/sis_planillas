<?php
/**
*@package pXP
*@file gen-ColumnaDetalle.php
*@author  (jrivera)
*@date 06-12-2014 17:17:45
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ColumnaDetalle=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ColumnaDetalle.superclass.constructor.call(this,config);
		this.init();
		
	},
	onReloadPage:function(m){       
		this.maestro=m;
		this.store.baseParams.id_columna_valor = this.maestro.id_columna_valor;
		this.load({params:{start:0, limit:this.tam_pag}});

	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_columna_detalle'
			},
			type:'Field',
			form:true 
		},
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_columna_valor'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ht.fecha_ini',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ht.fecha_ini',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'valor',
				fieldLabel: 'valor',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179658
			},
				type:'NumberField',
				filters:{pfiltro:'coldet.valor',type:'numeric'},
				id_grupo:1,
				grid:true,
				egrid:true,
				form:true
		},
		{
			config:{
				name: 'valor_generado',
				fieldLabel: 'valor_generado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179658
			},
				type:'NumberField',
				filters:{pfiltro:'coldet.valor_generado',type:'numeric'},
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
				filters:{pfiltro:'coldet.estado_reg',type:'string'},
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
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'coldet.usuario_ai',type:'string'},
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
				filters:{pfiltro:'coldet.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'coldet.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				type:'Field',
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
				filters:{pfiltro:'coldet.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Columna Detalle',
	ActSave:'../../sis_planillas/control/ColumnaDetalle/insertarColumnaDetalle',
	ActDel:'../../sis_planillas/control/ColumnaDetalle/eliminarColumnaDetalle',
	ActList:'../../sis_planillas/control/ColumnaDetalle/listarColumnaDetalle',
	id_store:'id_columna_detalle',
	fields: [
		{name:'id_columna_detalle', type: 'numeric'},
		{name:'id_horas_trabajadas', type: 'numeric'},
		{name:'id_columna_valor', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'valor_generado', type: 'numeric'},
		{name:'valor', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'fecha_ini',
		direction: 'ASC'
	},
	bdel:false,
	bnew:false,
	bedit:false,
	bsave:true
	}
)
</script>
		
		