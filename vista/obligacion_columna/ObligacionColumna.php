<?php
/**
*@package pXP
*@file gen-ObligacionColumna.php
*@author  (jrivera)
*@date 14-07-2014 20:28:37
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionColumna=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		//this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ObligacionColumna.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_obligacion_columna'
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
				name: 'codigo_cc',
				fieldLabel: 'Apropiación',				
				gwidth: 350				
			},
				type:'TextField',
				filters:{pfiltro:'cc.codigo_cc',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'codigo_columna',
				fieldLabel: 'Cod. Columna',				
				gwidth: 110
			},
				type:'TextField',
				filters:{pfiltro:'oblicol.codigo_columna',type:'string'},				
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre Columna',				
				gwidth: 180
			},
				type:'TextField',
				filters:{pfiltro:'tipcol.nombre',type:'string'},				
				grid:true,
				form:false
		},
				
		{
			config:{
				name: 'tipo_contrato',
				fieldLabel: 'Tipo de Contrato',				
				gwidth: 120
			},
				type:'TextField',
				filters:{pfiltro:'oblicol.tipo_contrato',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'monto_detalle_obligacion',
				fieldLabel: 'Monto',				
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'oblicol.monto_detalle_obligacion',type:'numeric'},
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
				filters:{pfiltro:'oblicol.estado_reg',type:'string'},
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
				filters:{pfiltro:'oblicol.usuario_ai',type:'string'},
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
				filters:{pfiltro:'oblicol.fecha_reg',type:'date'},
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
				filters:{pfiltro:'oblicol.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'oblicol.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Detalle de Ejecución por Obligación',
	ActSave:'../../sis_planillas/control/ObligacionColumna/insertarObligacionColumna',
	ActDel:'../../sis_planillas/control/ObligacionColumna/eliminarObligacionColumna',
	ActList:'../../sis_planillas/control/ObligacionColumna/listarObligacionColumna',
	id_store:'id_obligacion_columna',
	fields: [
		{name:'id_obligacion_columna', type: 'numeric'},
		{name:'id_cc', type: 'numeric'},
		{name:'id_obligacion', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'id_tipo_columna', type: 'numeric'},
		{name:'codigo_columna', type: 'string'},
		{name:'nombre', type: 'string'},		
		{name:'codigo_cc', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'monto_detalle_obligacion', type: 'numeric'},
		{name:'tipo_contrato', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_obligacion_columna',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false,
	onReloadPage:function(m){       
		this.maestro=m;
		this.load({params:{start:0, limit:this.tam_pag,id_obligacion:this.maestro.id_obligacion}});
	}
	}
)
</script>
		
		