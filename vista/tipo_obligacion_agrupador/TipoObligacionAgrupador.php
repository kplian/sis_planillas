<?php
/**
*@package pXP
*@file gen-TipoObligacionAgrupador.php
*@author  (eddy.gutierrez)
*@date 05-02-2019 20:20:47
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
  ISSUE 	FORK		FECHA			AUTHOR			DESCRIPCION
 * #3		EndeEtr		05/02/2019		EGS				creacion
 	#1		EndeEtr		19/02/2019		EGS				Se agrego el campo descripcion
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoObligacionAgrupador=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoObligacionAgrupador.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_obligacion_agrupador'
			},
			type:'Field',
			form:true 
		},

		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
			},
				type:'TextField',
				filters:{pfiltro:'tiobag.codigo',type:'string'},
				bottom_filter : true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
			},
				type:'TextField',
				filters:{pfiltro:'tiobag.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
	
		{
			config: {
				name: 'codigo_plantilla_comprobante',
				fieldLabel: 'Codigo Comprobante',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/PlantillaComprobante/listarPlantillaComprobante',
					id: 'id_plantilla_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_plantilla_comprobante', 'codigo', 'desc_plantilla'],
					remoteSort: true,
					baseParams: {par_filtro: 'cmpb.codigo'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Nombre Plantilla: </b>{desc_plantilla}</p>\
		                       <p><b>Codigo Plantilla: </b>{codigo}</p>\
		                       </div></tpl>',
				valueField: 'codigo',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'codigo',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo_plantilla_comprobante']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'tiobag.codigo_plantilla_comprobante',type: 'string'},
			bottom_filter : true,
			grid: true,
			form: true
		},
		//#1
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
			},
				type:'TextField',
				filters:{pfiltro:'tiobag.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		//#1
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
				filters:{pfiltro:'tiobag.estado_reg',type:'string'},
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
				filters:{pfiltro:'tiobag.id_usuario_ai',type:'numeric'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'tiobag.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tiobag.usuario_ai',type:'string'},
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
				filters:{pfiltro:'tiobag.fecha_mod',type:'date'},
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
		}
	],
	tam_pag:50,	
	title:'Agrupador Tipo de Obligacion',
	ActSave:'../../sis_planillas/control/TipoObligacionAgrupador/insertarTipoObligacionAgrupador',
	ActDel:'../../sis_planillas/control/TipoObligacionAgrupador/eliminarTipoObligacionAgrupador',
	ActList:'../../sis_planillas/control/TipoObligacionAgrupador/listarTipoObligacionAgrupador',
	id_store:'id_tipo_obligacion_agrupador',
	fields: [
		{name:'id_tipo_obligacion_agrupador', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'codigo_plantilla_comprobante', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'codigo_tipo_obli', type: 'string'},
		{name:'descripcion', type: 'string'},

	],
	sortInfo:{
		field: 'id_tipo_obligacion_agrupador',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		