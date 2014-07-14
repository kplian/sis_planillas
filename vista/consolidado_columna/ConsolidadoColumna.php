<?php
/**
*@package pXP
*@file gen-ConsolidadoColumna.php
*@author  (jrivera)
*@date 14-07-2014 19:04:10
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ConsolidadoColumna=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		//this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ConsolidadoColumna.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_consolidado_columna'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_consolidado'
			},
			type:'Field',
			form:true 
		},					
		
		{
			config:{
				name: 'codigo_columna',
				fieldLabel: 'Cod. Columna',				
				gwidth: 110
			},
				type:'TextField',
				filters:{pfiltro:'concol.codigo_columna',type:'string'},				
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
				name: 'codigo',
				fieldLabel: 'Cod. Partida',				
				gwidth: 110
			},
				type:'TextField',
				filters:{pfiltro:'par.codigo',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'nombre_partida',
				fieldLabel: 'Nombre Partida',				
				gwidth: 180
			},
				type:'TextField',
				filters:{pfiltro:'par.nombre_partida',type:'string'},				
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
				filters:{pfiltro:'concol.tipo_contrato',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'valor',
				fieldLabel: 'Valor',				
				gwidth: 135
			},
				type:'NumberField',
				filters:{pfiltro:'concol.valor',type:'numeric'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'valor_ejecutado',
				fieldLabel: 'Valor Ejecutado',				
				gwidth: 135
			},
				type:'NumberField',
				filters:{pfiltro:'concol.valor_ejecutado',type:'numeric'},				
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
				filters:{pfiltro:'concol.estado_reg',type:'string'},
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
				filters:{pfiltro:'concol.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'concol.usuario_ai',type:'string'},
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
				filters:{pfiltro:'concol.fecha_reg',type:'date'},
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
				filters:{pfiltro:'concol.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Consolidado por Columna',
	ActSave:'../../sis_planillas/control/ConsolidadoColumna/insertarConsolidadoColumna',
	ActDel:'../../sis_planillas/control/ConsolidadoColumna/eliminarConsolidadoColumna',
	ActList:'../../sis_planillas/control/ConsolidadoColumna/listarConsolidadoColumna',
	id_store:'id_consolidado_columna',
	fields: [
		{name:'id_consolidado_columna', type: 'numeric'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_consolidado', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_tipo_columna', type: 'numeric'},
		{name:'valor', type: 'numeric'},
		{name:'codigo_columna', type: 'string'},		
		{name:'codigo', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'nombre_partida', type: 'string'},		
		{name:'tipo_contrato', type: 'string'},
		{name:'valor_ejecutado', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_consolidado_columna',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bedit:false,
	bnew:false,
	onReloadPage:function(m){       
		this.maestro=m;
		this.load({params:{start:0, limit:this.tam_pag,id_consolidado:this.maestro.id_consolidado}});
	},
	}
)
</script>
		
		