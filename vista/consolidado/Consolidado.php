<?php
/**
*@package pXP
*@file gen-Consolidado.php
*@author  (jrivera)
*@date 14-07-2014 19:04:07
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * HISTORIAL DE MODIFICACIONES:
ISSUE            FECHA:              AUTOR                 DESCRIPCION
#29 ETR        20/08/2019               guy              creacion
#53 ETR        26/09/2019               RAC              lañade interface de empleado como hijo
 
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Consolidado=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Consolidado.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag, id_planilla: this.maestro.id_planilla}})
	},
			
	Atributos:[
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
				name: 'codigo_cc',
				fieldLabel: 'Apropiación',				
				gwidth: 350				
			},
				type:'TextField',
				filters:{pfiltro:'cc.codigo_cc',type:'string'},				
				grid:true,
				bottom_filter : true,
				form:false
		},
		{
			config:{
				name: 'codigo_techo',
				fieldLabel: 'Techo Pres.',				
				gwidth: 150				
			},
				type:'TextField',
				filters:{pfiltro:'tcc.codigo_techo#tcc.descripcion_techo',type:'string'},				
				grid:true,
				bottom_filter : true,
				form:false
		},
		/* rac comentado hasta saber cual es la diferencia con la sigueinte columna 27 09 2019
		{
			config:{
				name: 'suma_ejecutado',
				fieldLabel: 'Total Presupuestario',				
				gwidth: 100,
				galign: 'right ',
				maxLength: 100,
				renderer:function (value,p,record){
					if(record.data.tipo_reg != 'summary'){
						return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
					}
					else{
						return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
					}
				}			
			},
				type:'NumberField',							
				grid:true,
				form:false
		},*/
		{
			config:{
				name: 'suma',
				fieldLabel: 'Total',				
				gwidth: 100,
				galign: 'right ',
				maxLength: 100,
				renderer:function (value,p,record){
					if(record.data.tipo_reg != 'summary'){
						return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
					}
					else{
						return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
					}
				}				
			},
				type:'NumberField',							
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
				filters:{pfiltro:'conpre.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'conpre.fecha_reg',type:'date'},
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
				filters:{pfiltro:'conpre.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'conpre.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'conpre.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Consolidado Presupuestario',
	ActSave:'../../sis_planillas/control/Consolidado/insertarConsolidado',
	ActDel:'../../sis_planillas/control/Consolidado/eliminarConsolidado',
	ActList:'../../sis_planillas/control/Consolidado/listarConsolidado',
	id_store:'id_consolidado',
	fields: [
		{name:'id_consolidado', type: 'numeric'},
		{name:'id_cc', type: 'numeric'},
		{name:'id_planilla', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},
		{name:'codigo_cc', type: 'string'},
		{name:'suma', type: 'numeric'},
		{name:'suma_ejecutado', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo_consolidado', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'id_tipo_cc_techo','codigo_techo','descripcion_techo'
		
	],
	sortInfo:{
		field: 'id_consolidado',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false,
	
	//#53
	tabsouth : [{
			 url:'../../../sis_planillas/vista/consolidado_columna/ConsolidadoColumna.php',
		     title:'Consolidado por Columna', 
		     height:'50%',
		     cls:'ConsolidadoColumna'

		}, {
			url : '../../../sis_planillas/vista/presupuesto_empleado/PresupuestoEmpleadoDet.php',
			title : 'Empleados',
			height : '50%',
			cls : 'PresupuestoEmpleadoDet'
		}],
})
</script>
		
		