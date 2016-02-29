<?php
/**
*@package pXP
*@file gen-Reporte.php
*@author  (admin)
*@date 17-01-2014 22:07:28
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Reporte=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Reporte.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag,id_tipo_planilla : this.maestro.id_tipo_planilla}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_reporte'
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
				name: 'titulo_reporte',
				fieldLabel: 'Título',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'repo.titulo_reporte',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'control_reporte',
				fieldLabel: 'Control',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'repo.control_reporte',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},				
		{
			config:{
				name: 'hoja_posicion',
				fieldLabel: 'Hoja y Posición',
				allowBlank:false,
				emptyText:'Tipo hoja...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['carta_vertical','carta_horizontal','oficio_vertical','oficio_horizontal']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['carta_vertical','carta_horizontal','oficio_vertical','oficio_horizontal'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},	
		
		{
			config:{
				name: 'ancho_total',
				fieldLabel: 'Ancho Total',
				gwidth: 120
			},
				type:'NumberField',
				filters:{pfiltro:'repo.ancho total',type:'numeric'},
				grid:true,
				form:false
		},
		{
			config:{
				name: 'ancho_utilizado',
				fieldLabel: 'Ancho Utilizado',
				gwidth: 120
			},
				type:'NumberField',
				filters:{pfiltro:'repo.ancho_utilizado',type:'numeric'},
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'numerar',
				fieldLabel: 'Numerar',
				allowBlank:false,
				emptyText:'numerar reporte...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 80,
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
				name: 'mostrar_nombre',
				fieldLabel: 'Nombre',
				allowBlank:false,
				emptyText:'Añadir nombre...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 80,
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
				name: 'mostrar_codigo_empleado',
				fieldLabel: 'Cod. Empleado',
				allowBlank:false,
				emptyText:'Añadir codigo de empleado...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 80,
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
				name: 'mostrar_doc_id',
				fieldLabel: 'Doc. Id',
				allowBlank:false,
				emptyText:'Añadir doc. identidad...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 80,
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
				name: 'mostrar_codigo_cargo',
				fieldLabel: 'Cod. Cargo',
				allowBlank:false,
				emptyText:'Añadir cod. cargo...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 80,
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
				name: 'agrupar_por',
				fieldLabel: 'agrupar_por',
				allowBlank:false,
				emptyText:'dividir...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 120,
				store:['gerencia','gerencia_presupuesto']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['gerencia','gerencia_presupuesto'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'ordenar_por',
				fieldLabel: 'ordenar_por',
				allowBlank:false,
				emptyText:'dividir...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 120,
				store:['nombre','doc_id','codigo_cargo','codigo_empleado']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['nombre','doc_id','codigo_cargo','codigo_empleado'],	
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
				filters:{pfiltro:'repo.estado_reg',type:'string'},
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
				filters:{pfiltro:'repo.fecha_reg',type:'date'},
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
				filters:{pfiltro:'repo.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'tipo_reporte',
				fieldLabel: 'Tipo de Reporte',
				allowBlank:false,
				emptyText:'Tipo hoja...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['planilla','boleta','archivo_texto']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['planilla','boleta','archivo_texto'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},	
	],
	tam_pag:50,	
	title:'Reportes de Planilla',
	ActSave:'../../sis_planillas/control/Reporte/insertarReporte',
	ActDel:'../../sis_planillas/control/Reporte/eliminarReporte',
	ActList:'../../sis_planillas/control/Reporte/listarReporte',
	id_store:'id_reporte',
	fields: [
		{name:'id_reporte', type: 'numeric'},
		{name:'id_tipo_planilla', type: 'numeric'},
		{name:'numerar', type: 'string'},
		{name:'hoja_posicion', type: 'string'},
		{name:'mostrar_nombre', type: 'string'},
		{name:'mostrar_codigo_empleado', type: 'string'},
		{name:'mostrar_doc_id', type: 'string'},
		{name:'mostrar_codigo_cargo', type: 'string'},
		{name:'control_reporte', type: 'string'},
		{name:'agrupar_por', type: 'string'},
		{name:'ordenar_por', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'ancho_utilizado', type: 'numeric'},
		{name:'ancho_total', type: 'numeric'},
		{name:'titulo_reporte', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'tipo_reporte', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_reporte',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	loadValoresIniciales:function()
    {
    	this.Cmp.id_tipo_planilla.setValue(this.maestro.id_tipo_planilla);       
        Phx.vista.Reporte.superclass.loadValoresIniciales.call(this);        
    },
    south:{
		  url:'../../../sis_planillas/vista/reporte_columna/ReporteColumna.php',
		  title:'Reporte Columna', 
		  height:'55%',
		  cls:'ReporteColumna'
	}
	}
)
</script>
		
		