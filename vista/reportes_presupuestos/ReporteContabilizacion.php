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
	Phx.vista.ReporteContabilizacion = Ext.extend(Phx.frmInterfaz, {
		Atributos : [
		
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre_tipo_contrato'
			},
			type:'Field',
			form:true 
		},{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_contrato'
			},
			type:'Field',
			form:true 
		}
		],
		title : 'Generar Reporte',
		ActSave : '../../sis_planillas/control/Consolidado/reporteContabilizacion',
		topBar : true,
		botones : false,
		labelSubmit : 'Generar',
		tooltipSubmit : '<b>Generarl Excel</b>',
		constructor : function(config) {
			Phx.vista.ReporteContabilizacion.superclass.constructor.call(this, config);
			this.init();
			this.Cmp.id_tipo_planilla.on('select',function(c,r,i) {
				if (r.data.periodicidad == 'anual') {
					this.ocultarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = true;
					this.Cmp.id_periodo.reset();					
				} else {
					this.mostrarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = false;				
	
				}
			},this);
			
			this.Cmp.id_gestion.on('select',function(c,r,i){
				this.Cmp.id_periodo.reset();
				this.Cmp.id_periodo.store.baseParams.id_gestion = r.data.id_gestion;
			},this);
			this.Cmp.id_tipo_contrato.on('select',function(c,r,i){	
				this.Cmp.tipo_contrato.setValue(r.data.codigo);			
				this.Cmp.nombre_tipo_contrato.setValue(r.data.nombre);
			},this);
			
		},		
		clsSubmit : 'bprint',
		tipo:'reporte',
		fileUpload:false
})
</script>