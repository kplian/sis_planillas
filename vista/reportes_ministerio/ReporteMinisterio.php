<?php
/**
 *@package pXP
 *@file    ItemEntRec.php
 *@author  RCM
 *@date    07/08/2013
 *@description Reporte Material Entregado/Recibido
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.ReporteMinisterio = Ext.extend(Phx.frmInterfaz, {
		Atributos : [
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
	   	}
		],
		title : 'Generar Reporte',
		ActSave : '../../sis_planillas/control/Planilla/listarReportePlanillaMinisterio',
		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte</b>',
		constructor : function(config) {
			Phx.vista.ReporteMinisterio.superclass.constructor.call(this, config);
			this.init();
			this.Cmp.id_tipo_planilla.on('select',function(c,r,i) {
				if (r.data.periodicidad == 'anual') {
					this.ocultarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = true;
					this.Cmp.id_periodo.reset();
					this.mostrarComponente(this.Cmp.fecha_planilla);
					this.Cmp.fecha_planilla.allowBlank = false;
				} else {
					this.mostrarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = false;
					this.ocultarComponente(this.Cmp.fecha_planilla);
					this.Cmp.fecha_planilla.allowBlank = true;
	
				}
			},this);
			
			this.Cmp.id_gestion.on('select',function(c,r,i){
				this.Cmp.id_periodo.reset();
				this.Cmp.id_periodo.store.baseParams.id_gestion = r.data.id_gestion;
			},this);
			
			
		},
		tipo : 'reporte',
		clsSubmit : 'bprint'
})
</script>