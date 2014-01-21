<?php
/**
*@package pXP
*@file gen-Antiguedad.php
*@author  (admin)
*@date 20-01-2014 03:47:41
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Antiguedad=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Antiguedad.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_antiguedad'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'valor_min',
				fieldLabel: 'Desde (Años)',
				allowBlank: false,
				anchor: '80%',
				gwidth: 110,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'anti.valor_min',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'valor_max',
				fieldLabel: 'Hasta (Años)',
				allowBlank: false,
				anchor: '80%',
				gwidth: 110,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'anti.valor_max',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'porcentaje',
				fieldLabel: 'Porcentaje (Minimo Nacional)',
				allowBlank: false,
				anchor: '80%',
				gwidth: 200,
				maxLength:3
			},
				type:'NumberField',
				filters:{pfiltro:'anti.porcentaje',type:'numeric'},
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
				filters:{pfiltro:'anti.estado_reg',type:'string'},
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
				filters:{pfiltro:'anti.fecha_reg',type:'date'},
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
				filters:{pfiltro:'anti.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Definición Periodos Antiguedad',
	ActSave:'../../sis_planillas/control/Antiguedad/insertarAntiguedad',
	ActDel:'../../sis_planillas/control/Antiguedad/eliminarAntiguedad',
	ActList:'../../sis_planillas/control/Antiguedad/listarAntiguedad',
	id_store:'id_antiguedad',
	fields: [
		{name:'id_antiguedad', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'valor_max', type: 'numeric'},
		{name:'porcentaje', type: 'numeric'},
		{name:'valor_min', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_antiguedad',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		