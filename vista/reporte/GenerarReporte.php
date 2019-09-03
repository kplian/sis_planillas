<?php
/**
 *@package pXP
 *@file    ItemEntRec.php
 *@author  RCM
 *@date    07/08/2013
 *@description Reporte Material Entregado/Recibido
 * #33	etr			MZM		02.09.2019	Adicion de control para reporte multilinea (opcion totales)
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.GenerarReporte = Ext.extend(Phx.frmInterfaz, {
		Atributos : [ 
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_contrato'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre_tipo_contrato'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_reporte'
			},
			type:'Field',
			form:true 
		},
		{
   			config:{
   				name:'id_depto',
   				 hiddenName: 'id_depto',
   				 //url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
	   				origen:'DEPTO',
	   				allowBlank:false,
	   				fieldLabel: 'Depto',	   				
	   				width:250,   			        
	   				baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'ORGA'}//parametros adicionales que se le pasan al store
	      			
   			},
   			//type:'TrigguerCombo',
   			type:'ComboRec',
   			id_grupo:0,   			
   			form:true
       	},	
		{
			config: {
				name: 'id_tipo_planilla',
				fieldLabel: 'Tipo Planilla',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_tipo_planilla',
				allowBlank: false,
				emptyText: 'Lista de Planillas...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/TipoPlanilla/listarTipoPlanilla',
					id: 'id_tipo_planilla',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_planilla', 'nombre', 'codigo','periodicidad'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tippla.nombre#tippla.codigo'}
				}),
				valueField: 'id_tipo_planilla',
				displayField: 'nombre',				
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,				
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},	
		{
			config: {
				name: 'id_tipo_contrato',
				fieldLabel: 'Tipo Contrato',
				allowBlank: true,
				emptyText: 'Dejar en blanco para todos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_organigrama/control/TipoContrato/listarTipoContrato',
					id: 'id_tipo_contrato',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_contrato', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'tipcon.nombre#tipcon.codigo'}
				}),
				valueField: 'id_tipo_contrato',
				displayField: 'nombre',
				gdisplayField: 'nombre_tipo_contrato',
				hiddenName: 'id_tipo_contrato',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				minChars: 2,
				
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},
		
		{
			config: {
				name: 'id_reporte',
				fieldLabel: 'Tipo Reporte',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_reporte',
				allowBlank: false,
				emptyText: 'Reportes Disponibles...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/Reporte/listarReporte',
					id: 'id_reporte',
					root: 'datos',
					sortInfo: {
						field: 'titulo_reporte',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_reporte', 'titulo_reporte','tipo_reporte','multilinea'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'repo.titulo_reporte'}
				}),
				valueField: 'id_reporte',
				displayField: 'titulo_reporte',				
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				disabled : true
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},	
		{
   			config:{
       		    name:'id_uo',
       		    hiddenName: 'id_uo',
          		origen:'UO',
   				fieldLabel:'UO',
   				gdisplayField:'desc_uo',//mapea al store del grid
   				gwidth:200,
   				emptyText:'Dejar blanco para toda la empresa...',
   				anchor: '80%',
   				baseParams: {nivel: '0,1,2'},
   				allowBlank:true   			     
       	     },
   			type:'ComboRec',
   			id_grupo:0,   			
   			form:true
   	      },	
		{
	   			config:{
	   				name : 'id_gestion',
	   				origen : 'GESTION',
	   				fieldLabel : 'Gestion',
	   				allowBlank : false	   				
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,
	   			form : true
	   	},
		{
	   			config:{
	   				name : 'id_periodo',
	   				origen : 'PERIODO',
	   				fieldLabel : 'Periodo',
	   				allowBlank : true	   				
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,	   			
	   			form : true
	   },
	   {
			config:{
				name: 'formato_reporte',
				fieldLabel: 'Formato de Reporte',
				allowBlank:false,
				emptyText:'Formato...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['pdf','xls']
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		},
		{
			config:{//#33
				name: 'totales',
				fieldLabel: 'Totales?',
				allowBlank:false,
				emptyText:'Totales...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no']
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		}
		],
		title : 'Generar Reporte',
		ActSave : '../../sis_planillas/control/Reporte/generarReporteDesdeForm',
		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte</b>',
		constructor : function(config) {
			Phx.vista.GenerarReporte.superclass.constructor.call(this, config);
			this.init();
			
			this.ocultarComponente(this.Cmp.totales);
			this.Cmp.id_tipo_planilla.on('select',function(c,r,i) {
				if (r.data.periodicidad == 'anual') {
					this.ocultarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = true;
					this.Cmp.id_periodo.reset();					
				} else {
					this.mostrarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = false;		
	
				}
				this.Cmp.id_reporte.setDisabled(false);
				this.Cmp.id_reporte.reset();
				this.Cmp.id_reporte.store.baseParams.id_tipo_planilla = r.data.id_tipo_planilla;
				this.Cmp.id_reporte.modificado = true;
			},this);
			
			this.Cmp.id_gestion.on('select',function(c,r,i){
				this.Cmp.id_periodo.reset();
				this.Cmp.id_periodo.store.baseParams.id_gestion = r.data.id_gestion;
				this.Cmp.id_periodo.modificado = true;
			},this);
			
			this.Cmp.id_tipo_contrato.on('select',function(c,r,i){
				this.Cmp.tipo_contrato.setValue(r.data.codigo);
				this.Cmp.nombre_tipo_contrato.setValue(r.data.nombre);
			},this);
			
			this.Cmp.id_reporte.on('select',function(c,r,i){ //#33
				this.Cmp.tipo_reporte.setValue(r.data.tipo_reporte);
				if(r.data.tipo_reporte=='planilla' && r.data.multilinea=='si' ){
					this.mostrarComponente(this.Cmp.totales);
					this.Cmp.totales.allowBlank = false;	
				}else{
					this.ocultarComponente(this.Cmp.totales);
					this.Cmp.totales.setValue('no');
				}
			},this);			
			
			
			
		},
		tipo : 'reporte',
		clsSubmit : 'bprint'
})
</script>