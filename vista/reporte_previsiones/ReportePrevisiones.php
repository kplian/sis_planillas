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
	Phx.vista.ReportePrevisiones = Ext.extend(Phx.frmInterfaz, {
		Atributos : [
		
		{
   			config:{
       		    name:'id_uo',
       		    hiddenName: 'id_uo',
          		origen:'UO',
   				fieldLabel:'UO',
   				gdisplayField:'desc_uo',//mapea al store del grid
   				gwidth:200,
   				emptyText:'Dejar blanco para toda la empresa...',
   				anchor: '50%',
   				baseParams: {gerencia: 'si'},
   				allowBlank:true,
   			     renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}
       	     },
   			type:'ComboRec',
   			id_grupo:1,
   			filters:{	
		        pfiltro:'uo.codigo#uo.nombre_unidad',
				type:'string'
			},
   		     grid:true,
   			form:true
   	      },
   	      {
			config: {
				name: 'id_tipo_contrato',
				fieldLabel: 'Tipo Contrato',
				allowBlank: true,
				emptyText: 'Dejar en blanco para todos los tipos...',
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
				hiddenName: 'id_tipo_contrato',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '50%',				
				minChars: 2
				
			},
			type: 'ComboBox',
			id_grupo: 1,			
			form: true
		},
   	      
   	      {
			config:{
				name: 'fecha',
				allowBlank:false,
				fieldLabel: 'Fecha Reporte',
				allowBlank:'Fecha a la que se generara el reporte',
				anchor: '30%',
				gwidth: 100,
				format: 'd/m/Y'
							
			},
				type:'DateField',				
				id_grupo:1,				
				form:true
		},
		{
	       		config:{
	       			name:'tipo_reporte',
	       			fieldLabel:'Tipo de Archivo',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',	
	       		    anchor: '30%',       		    
	       		    store:['pdf','excel']
	       		    
	       		},
	       		type:'ComboBox',
	       		id_grupo:1,	       		
	       		form:true
	       	},
		
		],
		title : 'Generar Reporte',
		ActSave : '../../sis_planillas/control/Reporte/listarReportePrevisiones',
		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte</b>',
		constructor : function(config) {
			Phx.vista.ReportePrevisiones.superclass.constructor.call(this, config);
			this.init();			
		},
		tipo : 'reporte',
		clsSubmit : 'bprint',
		agregarArgsExtraSubmit: function() {
    		this.argumentExtraSubmit.uo = this.Cmp.id_uo.getRawValue();
    		this.argumentExtraSubmit.tipo_contrato = this.Cmp.id_tipo_contrato.getRawValue();
    		
    	},
})
</script>