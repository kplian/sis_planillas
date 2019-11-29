<?php
/**
*@package pXP
*@file gen-Reporte.php
*@author  (admin)
*@date 17-01-2014 22:07:28
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
issue 	empresa		autor	fecha	detalle
 *17	etr			MZM		28.06.2019	Adicion de opcion centro en combo ordenar_por
 * #32	etr			MZM		02.09.2019	Adicion de relacion id_pie_firma y funcion para listar firmas por tipo de reporte
 * #58	etr			MZM		30.09.2019	Adicion de campo mostrar_ufv
 * #60	etr			MZM		01.10.2019	Adicion de campo incluir_retirados
 * #65	ETR			MZM		10.10.2019	Adicion de cmpo id_moneda_reporte
 * #71	ETR			MZM		01.11.2019	Refactorizacion para planilla de prima (agrupacion en treporte distrito_banco)
 * #77	ETR			MZM		14.11.2019	Ajustes varios
 * #80	ETR			MZM		22.11.2019	Adicion de tipo_reporte (bono_descuento)
 * #82	ETR			MZM		27.11.2019	Adicion de opcion organigrama en check ordenar_por
 * */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Reporte=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Reporte.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
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
		},{
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
				store:['planilla','boleta','archivo_texto','formato_especifico','bono_descuento']//#80
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['planilla','boleta','archivo_texto','formato_especifico','bono_descuento'],	//#80
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
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
				store:['gerencia','gerencia_presupuesto','distrito','distrito_banco','centro','ninguno'] //#71
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['gerencia','gerencia_presupuesto','distrito','distrito_banco','centro','ninguno'], //#71	
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
				store:['nombre','doc_id','codigo_cargo','codigo_empleado','organigrama'] //#17 #82
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['nombre','doc_id','codigo_cargo','codigo_empleado','organigrama'], //#17 #82 	
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
				name: 'multilinea',
				fieldLabel: 'Multilinea',
				allowBlank:false,
				emptyText:'Definir Multilinea...',
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
				name: 'vista_datos_externos',
				fieldLabel: 'Vista Datos Externos',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'repo.vista_datos_externos',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'num_columna_multilinea',
				fieldLabel: 'Num Col. para Multilinea',
				minValue:0,
				gwidth: 120
			},
				type:'NumberField',
				filters:{pfiltro:'repo.num_columna_multilinea',type:'numeric'},
				grid:true,
				form:true
		},
		{//#32
			config: {
				name: 'id_pie_firma',
				fieldLabel: 'Pie de Firmas',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/PieFirma/listarPieFirma',
					id: 'id_pie_firma',
					root: 'datos',
					sortInfo: {
						field: 'pie.nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_pie_firma', 'nombre'],
					remoteSort: true,
					baseParams: {par_filtro: 'pie.nombre'}
				}),
				valueField: 'id_pie_firma',
				displayField: 'nombre',
				gdisplayField: 'nombre',
				hiddenName: 'nombre',
				forceSelection: false,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 200,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['nombre']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'tpie_firma.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{//#58
			config:{
				name: 'mostrar_ufv',
				fieldLabel: 'Mostrar UFV',
				allowBlank:false,
				emptyText:'Mostrar UFV...',
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
		{//#60
			config:{
				name: 'incluir_retirados',
				fieldLabel: 'Incluir Retirados',
				allowBlank:false,
				emptyText:'Incluir Retirados...',
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
		}
		,//#65
		{
			config : {
				name : 'id_moneda_reporte',
				origen : 'MONEDA',
				allowBlank : false,
				fieldLabel : 'Moneda del Reporte',
				gdisplayField : 'codigo', //mapea al store del grid
				gwidth : 100,
				anchor: '80%',
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo']);
				}
			},
			type : 'ComboRec',
			id_grupo : 2,
			filters : {
				pfiltro : 'mon.moneda',
				type : 'string'
			},
			grid : true,
			form : true
		} 
		,{//#77
			config:{
				name: 'bordes',
				fieldLabel: 'Bordes',
				allowBlank:false,
				emptyText:'Bordes...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 80,
				store:[0,1]
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: [0,1],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'interlineado',
				fieldLabel: 'Interlineado',
				minValue:0,
				gwidth: 120
			},
				type:'NumberField',
				filters:{pfiltro:'repo.interlineado',type:'numeric'},
				grid:true,
				form:true
		}
		
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
		{name:'multilinea', type: 'string'},
		{name:'vista_datos_externos', type: 'string'},
		{name:'num_columna_multilinea', type: 'numeric'},
		//#32
		{name:'id_pie_firma', type: 'numeric'},
		{name:'nombre', type: 'varchar'}
		,{name:'mostrar_ufv', type: 'string'}//#58
		,{name:'incluir_retirados', type: 'string'}//#60
		,{name:'id_moneda_reporte', type: 'numeric'}//#65
		,{name:'codigo', type: 'string'}//#65
		,{name:'bordes', type: 'string'}//#77
		,{name:'interlineado', type: 'string'}//#77
		
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
	},
	
	iniciarEventos:function(){
    	this.Cmp.vista_datos_externos.allowBlank=true;
		this.Cmp.num_columna_multilinea.allowBlank=true;
		this.Cmp.multilinea.setValue("no");
    	this.Cmp.num_columna_multilinea.setValue(0);
    	
    	this.Cmp.multilinea.on('select',function(cmp,rec){
    		if(rec.json=='si'){
    			this.Cmp.multilinea.setValue('si');
    			this.Cmp.num_columna_multilinea.minValue=1;
				this.mostrarComponente(this.Cmp.num_columna_multilinea);
				this.mostrarComponente(this.Cmp.vista_datos_externos);
				
    		}else{
    			this.Cmp.multilinea.setValue('no');
    			this.Cmp.num_columna_multilinea.minValue=0;
    			this.Cmp.num_columna_multilinea.setValue(0);
    			this.ocultarComponente(this.Cmp.num_columna_multilinea);
    			this.ocultarComponente(this.Cmp.vista_datos_externos);
    		}
    		
    		
			
			},this);
    }
	
	}
)
</script>
		
		