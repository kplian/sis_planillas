<?php
/**
*@package pXP
*@file gen-TipoPlanilla.php
*@author  (admin)
*@date 17-01-2014 15:36:53
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoPlanilla=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoPlanilla.superclass.constructor.call(this,config);
		this.init();
		this.addButton('btnObligaciones',
            {
                text: 'Obligaciones',
                iconCls: 'blist',
                disabled: true,
                handler: this.onBtnObligaciones,
                tooltip: 'Obligaciones de la Planilla'
            }
        );
        
        this.addButton('btnReportes',
            {
                text: 'Reportes',
                iconCls: 'bpdf32',
                disabled: true,
                handler: this.onBtnReportes,
                tooltip: 'Diseño de Reportes para la Planilla'
            }
        );
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
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
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'tippla.codigo',type:'string'},
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
				gwidth: 150,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'tippla.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'id_proceso_macro',
				fieldLabel: 'Proceso',
				typeAhead: false,
				forceSelection: false,
				 hiddenName: 'id_proceso_macro',
				allowBlank: false,
				emptyText: 'Lista de Procesos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_workflow/control/ProcesoMacro/listarProcesoMacro',
					id: 'id_proceso_macro',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_proceso_macro', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'promac.nombre#promac.codigo',codigo_subsistema:'ADQ'}
				}),
				valueField: 'id_proceso_macro',
				displayField: 'nombre',
				gdisplayField: 'desc_proceso_macro',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				renderer: function(value, p, record) {
					return String.format('{0}', record.data['desc_proceso_macro']);
				},
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p>Codigo: <strong>{codigo}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'pm.nombre',
				type: 'string'
			},
			grid: true,
			form: true
		},		
		{
			config:{
				name: 'funcion_obtener_empleados',
				fieldLabel: 'Funcion para obtener empleados',
				allowBlank: false,
				anchor: '80%',
				gwidth: 200,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'tippla.funcion_obtener_empleados',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'tipo_presu_cc',
				fieldLabel: 'Tipo Presu. y cost.',
				allowBlank:false,
				emptyText:'Obtener de...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['parametrizacion','ultimo_activo_periodo']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['parametrizacion','ultimo_activo_periodo'],	
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
				filters:{pfiltro:'tippla.estado_reg',type:'string'},
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
				filters:{pfiltro:'tippla.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tippla.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Tipos de Planilla',
	ActSave:'../../sis_planillas/control/TipoPlanilla/insertarTipoPlanilla',
	ActDel:'../../sis_planillas/control/TipoPlanilla/eliminarTipoPlanilla',
	ActList:'../../sis_planillas/control/TipoPlanilla/listarTipoPlanilla',
	id_store:'id_tipo_planilla',
	fields: [
		{name:'id_tipo_planilla', type: 'numeric'},
		{name:'id_proceso_macro', type: 'numeric'},
		{name:'tipo_presu_cc', type: 'string'},
		{name:'funcion_obtener_empleados', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'desc_proceso_macro', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_tipo_planilla',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	south:{
		  url:'../../../sis_planillas/vista/tipo_columna/TipoColumna.php',
		  title:'Tipo Columna', 
		  height:'60%',
		  cls:'TipoColumna'
	},
	preparaMenu:function()
    {	
        this.getBoton('btnObligaciones').enable();  
        this.getBoton('btnReportes').enable();      
        Phx.vista.TipoPlanilla.superclass.preparaMenu.call(this);
    },
    liberaMenu:function()
    {	
        this.getBoton('btnObligaciones').disable(); 
        this.getBoton('btnReportes').disable();       
        Phx.vista.TipoPlanilla.superclass.liberaMenu.call(this);
    },
    onBtnObligaciones: function(){
			var rec = {maestro: this.sm.getSelected().data};
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/tipo_obligacion/TipoObligacion.php',
                    'Obligaciones a generar para el tipo de Planilla',
                    {
                        width:800,
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'TipoObligacion');
	},
	onBtnReportes: function(){
			var rec = {maestro: this.sm.getSelected().data};
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/reporte/Reporte.php',
                    'Diseño de Reportes para la Planilla',
                    {
                        width:800,
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'Reporte');
	}
	}
)
</script>
		
		