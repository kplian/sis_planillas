<?php
/**
*@package pXP
*@file gen-DetalleTransferencia.php
*@author  (jrivera)
*@date 14-07-2014 20:28:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DetalleTransferencia=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DetalleTransferencia.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag, id_obligacion:this.maestro.id_obligacion}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_detalle_transferencia'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_obligacion'
			},
			type:'Field',
			form:true 
		},	
		{
			config:{
				name: 'ci',
				fieldLabel: 'CI',				
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'fun.ci',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'desc_funcionario1',
				fieldLabel: 'Funcionario',				
				gwidth: 250
			},
				type:'TextField',
				filters:{pfiltro:'fun.desc_funcionario1',type:'string'},				
				grid:true,
				form:false
		},
		
		
		
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Banco',				
				gwidth: 150
			},
				type:'TextField',
				filters:{pfiltro:'ins.nombre',type:'string'},				
				grid:true,
				form:false
		},
		
		
			
		{
			config:{
				name: 'nro_cuenta',
				fieldLabel: 'No cuenta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 180,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'detran.nro_cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				egrid:true,
				form:true
		},
		{
			config:{
				name: 'monto_transferencia',
				fieldLabel: 'Monto Transferencia',				
				gwidth: 150
			},
				type:'NumberField',
				filters:{pfiltro:'detran.monto_transferencia',type:'numeric'},				
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
				filters:{pfiltro:'detran.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'detran.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'detran.usuario_ai',type:'string'},
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
				filters:{pfiltro:'detran.fecha_reg',type:'date'},
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
				filters:{pfiltro:'detran.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Detalle de Transferencia a Empleados',
	ActSave:'../../sis_planillas/control/DetalleTransferencia/insertarDetalleTransferencia',
	ActDel:'../../sis_planillas/control/DetalleTransferencia/eliminarDetalleTransferencia',
	ActList:'../../sis_planillas/control/DetalleTransferencia/listarDetalleTransferencia',
	id_store:'id_detalle_transferencia',
	fields: [
		{name:'id_detalle_transferencia', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'id_institucion', type: 'numeric'},
		{name:'id_obligacion', type: 'numeric'},
		{name:'nro_cuenta', type: 'string'},
		{name:'ci', type: 'string'},
		{name:'desc_funcionario1', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'monto_transferencia', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_detalle_transferencia',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		