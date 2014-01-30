<?php
/**
*@package pXP
*@file gen-TipoColumna.php
*@author  (admin)
*@date 17-01-2014 19:43:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoColumna=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoColumna.superclass.constructor.call(this,config);
		this.iniciarEventos();
		this.init();		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_columna'
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
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '50%',
				gwidth: 80,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'tipcol.codigo',type:'string'},
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
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'tipcol.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},	
		
		{
			config:{
				name: 'tipo_dato',
				fieldLabel: 'Tipo Dato',
				allowBlank:false,
				emptyText:'Columna...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['basica','formula', 'variable']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['basica','formula', 'variable'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},				
		{
			config:{
				name: 'formula',
				fieldLabel: 'Fórmula',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:255
			},
				type:'TextArea',
				filters:{pfiltro:'tipcol.formula',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'compromete',
				fieldLabel: 'Presupuesto',
				allowBlank:false,
				emptyText:'Compromete...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','si_devengado','si_pago','no']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['si','si_devengado','si_pago','no'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'finiquito',
				fieldLabel: 'En finiquito',
				allowBlank:false,
				emptyText:'Finiquito...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['ejecutar','restar_ejecutado']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['ejecutar','restar_ejecutado'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},				
		{
			config:{
				name: 'tipo_descuento_bono',
				fieldLabel: 'Tipo Descuento/Bono',
				allowBlank:true,
				emptyText:'Es descuento/...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['monto_fijo_indefinido','cantidad_cuotas','monto_fijo_por_fechas']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['monto_fijo_indefinido','cantidad_cuotas','monto_fijo_por_fechas'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},				
		{
			config:{
				name: 'orden',
				fieldLabel: 'Orden',
				allowBlank: false,
				anchor: '30%',
				gwidth: 80,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'tipcol.orden',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: false,
				anchor: '80%',
				gwidth: 250				
			},
				type:'TextArea',
				filters:{pfiltro:'tipcol.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'decimales_redondeo',
				fieldLabel: '# Decimales redondeo',
				allowBlank: false,
				anchor: '50%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'tipcol.decimales_redondeo',type:'numeric'},
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
				filters:{pfiltro:'tipcol.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'tipcol.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tipcol.fecha_mod',type:'date'},
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
		}
	],
	tam_pag:50,	
	title:'Tipo Columna',
	ActSave:'../../sis_planillas/control/TipoColumna/insertarTipoColumna',
	ActDel:'../../sis_planillas/control/TipoColumna/eliminarTipoColumna',
	ActList:'../../sis_planillas/control/TipoColumna/listarTipoColumna',
	id_store:'id_tipo_columna',
	fields: [
		{name:'id_tipo_columna', type: 'numeric'},
		{name:'id_tipo_planilla', type: 'numeric'},
		{name:'compromete', type: 'string'},
		{name:'tipo_descuento_bono', type: 'string'},
		{name:'tipo_dato', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'finiquito', type: 'string'},
		{name:'decimales_redondeo', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'orden', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'formula', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'orden',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage:function(m){
			this.maestro=m;					
			this.load({params:{start:0, limit:this.tam_pag,id_tipo_planilla:this.maestro.id_tipo_planilla}});			
	},
	loadValoresIniciales:function()
    {
    	this.Cmp.id_tipo_planilla.setValue(this.maestro.id_tipo_planilla);       
        Phx.vista.TipoColumna.superclass.loadValoresIniciales.call(this);        
    },
    onButtonEdit:function(){
		//llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
		this.ocultarComponente(this.Cmp.codigo);
		Phx.vista.TipoColumna.superclass.onButtonEdit.call(this);
		if (this.Cmp.tipo_dato.getValue() == 'formula') {
			this.mostrarComponente(this.Cmp.formula);
			this.Cmp.formula.allowBlank = false;
		} else {
			this.ocultarComponente(this.Cmp.formula);
			this.Cmp.formula.allowBlank = true;
		}
	},
	onButtonNew:function(){
		//llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
		this.mostrarComponente(this.Cmp.codigo);
		Phx.vista.TipoColumna.superclass.onButtonNew.call(this);
	},
	iniciarEventos : function() {
		this.Cmp.tipo_dato.on('select',function(c,r,i) {
			if (r.data.field1 == 'formula') {
				this.mostrarComponente(this.Cmp.formula);
				this.Cmp.formula.allowBlank = false;				
			} else {
				this.ocultarComponente(this.Cmp.formula);
				this.Cmp.formula.allowBlank = true;
				this.Cmp.formula.reset();
			}
		},this);	
	}
	
	}
)
</script>
		
		