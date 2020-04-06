<?php
/**
*@package pXP
*@file gen-ReporteColumna.php
*@author  (admin)
*@date 18-01-2014 02:56:10
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * 
 * 
 * ISSUE            FECHA:		      AUTOR       DESCRIPCION
* #23  etr 	     29/07/2019			RAC 		reparar bug al cambiar de pagina , no manda el id del reporte  
*
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReporteColumna=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ReporteColumna.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_reporte_columna'
			},
			type:'Field',
			form:true 
		},
		
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
			config:{
				name: 'origen',
				fieldLabel: 'Origen',
				allowBlank:false,
				emptyText:'Origen...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['vista_externa','columna_planilla'],	
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['vista_externa','columna_planilla'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'codigo_columna',
				fieldLabel: 'Código Columna',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'codigo_columna',
				allowBlank: false,
				emptyText: 'Lista de Procesos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/TipoColumna/listarTipoColumna',
					id: 'id_tipo_columna',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_columna', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipcol.nombre#tipcol.codigo'}
				}),
				valueField: 'codigo',
				displayField: 'nombre',
				gdisplayField: 'codigo_columna',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'repcol.codigo_columna',
				type: 'string'
			},
			grid: true,
			form: true
		},	{
			config:{
				name: 'columna_vista',
				fieldLabel: 'Columna de Vista',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'repcol.columna_vista',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},	
		{
			config:{
				name: 'sumar_total',
				fieldLabel: 'Totalizar',
				allowBlank:false,
				emptyText:'Mostrar total...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
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
				name: 'ancho_columna',
				fieldLabel: 'Ancho Columna',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'repcol.ancho_columna',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'titulo_reporte_superior',
				fieldLabel: 'Titulo Superior',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'repcol.titulo_reporte_superior',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tipo_columna',
				fieldLabel: 'Tipo de Columna',
				allowBlank:false,
				emptyText:'Tipo de Columna...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['ingreso','descuento_ley','otros_descuentos','iva','otro'],	
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['ingreso','descuento_ley','otros_descuentos','iva','otro'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'titulo_reporte_inferior',
				fieldLabel: 'Titulo Inferior',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'repcol.titulo_reporte_inferior',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'orden',
				fieldLabel: 'Orden',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'repcol.orden',type:'numeric'},
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
				filters:{pfiltro:'repcol.estado_reg',type:'string'},
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
				filters:{pfiltro:'repcol.fecha_reg',type:'date'},
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
				filters:{pfiltro:'repcol.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},{
			config:{
				name: 'espacio_previo',
				fieldLabel: 'Espacio Previo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'repcol.espacio_previo',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		}
		
	],
	tam_pag:50,	
	title:'Reporte Columna',
	ActSave:'../../sis_planillas/control/ReporteColumna/insertarReporteColumna',
	ActDel:'../../sis_planillas/control/ReporteColumna/eliminarReporteColumna',
	ActList:'../../sis_planillas/control/ReporteColumna/listarReporteColumna',
	id_store:'id_reporte_columna',
	fields: [
		{name:'id_reporte_columna', type: 'numeric'},
		{name:'id_reporte', type: 'numeric'},
		{name:'sumar_total', type: 'string'},
		{name:'tipo_columna', type: 'string'},
		{name:'ancho_columna', type: 'numeric'},
		{name:'orden', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo_columna', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'titulo_reporte_superior', type: 'string'},
		{name:'titulo_reporte_inferior', type: 'string'},
		{name:'espacio_previo', type: 'numeric'},
		{name:'columna_vista', type: 'string'},
		{name:'origen', type: 'string'}
		
		
	],
	sortInfo:{
		field: 'orden',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_reporte:this.maestro.id_reporte}; //#23 manda el id_reporte como parametro para todas las paginas
		if (this.maestro.tipo_reporte == 'boleta') {
			
			
			this.mostrarComponente(this.Cmp.tipo_columna);
			this.Cmp.tipo_columna.allowBlank = false;
						
		} else {
			this.ocultarComponente(this.Cmp.tipo_columna);
			this.Cmp.tipo_columna.allowBlank = true;
		}
		this.load({params:{start:0, limit:this.tam_pag}});
		this.Cmp.codigo_columna.store.baseParams.id_tipo_planilla = this.maestro.id_tipo_planilla;			
	},
	loadValoresIniciales:function()
    {
    	this.Cmp.tipo_columna.setValue('otro');  
    	this.Cmp.id_reporte.setValue(this.maestro.id_reporte);       
        Phx.vista.ReporteColumna.superclass.loadValoresIniciales.call(this); 
        
        
     
          
               
    },
    iniciarEventos:function(){
    	this.Cmp.codigo_columna.allowBlank=true;
		this.Cmp.columna_vista.allowBlank=true;
    	//this.ocultarComponente(this.Cmp.codigo_columna);
    	//this.ocultarComponente(this.Cmp.columna_vista);
    	this.Cmp.espacio_previo.setValue(0);
    	
    	
    	this.Cmp.origen.on('select',function(cmp,rec){
    		if(rec.json=='vista_externa'){
    			this.Cmp.origen.setValue('vista_externa');
    			this.mostrarComponente(this.Cmp.columna_vista);
				this.ocultarComponente(this.Cmp.codigo_columna);
				this.Cmp.codigo_columna.allowBlank=true;
				this.Cmp.columna_vista.allowBlank=false;
				
    		}else{
    			this.Cmp.origen.setValue('columna_planilla');
    			this.mostrarComponente(this.Cmp.codigo_columna);
				this.ocultarComponente(this.Cmp.columna_vista);
				this.Cmp.codigo_columna.allowBlank=false;
				this.Cmp.columna_vista.allowBlank=true;
    		}
    	
			
    		},this);
			
			
			
			
    }
	}
)
</script>
		
		