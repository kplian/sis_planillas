<?php
/**
*@package pXP
*@file gen-Obligacion.php
*@author  (jrivera)
*@date 14-07-2014 20:30:19
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Obligacion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Obligacion.superclass.constructor.call(this,config);
		this.init();
		this.store.baseParams.id_planilla = this.maestro.id_planilla;
		this.load({params:{start:0, limit:this.tam_pag, id_planilla: this.maestro.id_planilla}});
		this.addButton('btnDetalle',
            {
                text: 'Detalle de Transferencias',
                iconCls: 'blist',
                disabled: true,
                handler: this.onBtnDetalle,
                tooltip: 'Detalle de transferencias en transferencias a empleados'
            }
        );
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_obligacion'
			},
			type:'Field',
			form:true 
		},
		
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_planilla'
			},
			type:'Field',
			form:true 
		},		
		
		{
			config:{
				name: 'acreedor',
				fieldLabel: 'Acreedor',
				allowBlank: false,
				anchor: '80%',
				gwidth: 170
			},
				type:'TextField',
				filters:{pfiltro:'obli.acreedor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},
		
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: true,
				anchor: '100%',
				gwidth: 250,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'obli.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},
		
		{
			config:{
				name: 'es_pagable',
				fieldLabel: 'Es pagable',				
				gwidth: 80
			},
				type:'TextField',
				filters:{pfiltro:'tipobli.es_pagable',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'tipo_pago',
				fieldLabel: 'Tipo Pago',
				allowBlank:true,
				emptyText:'tipo...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 85,
				store:['cheque','transferencia','transferencia_empleados']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['cheque','transferencia','transferencia_empleados'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},	
		
		{
			config:{
				name: 'monto_obligacion',
				fieldLabel: 'Monto',				
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'obli.monto_obligacion',type:'numeric'},				
				grid:true,
				form:false
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
				filters:{pfiltro:'obli.estado_reg',type:'string'},
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
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
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
				filters:{pfiltro:'obli.usuario_ai',type:'string'},
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
				filters:{pfiltro:'obli.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'obli.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'obli.fecha_mod',type:'date'},
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
	title:'Obligaciones',
	ActSave:'../../sis_planillas/control/Obligacion/insertarObligacion',
	ActDel:'../../sis_planillas/control/Obligacion/eliminarObligacion',
	ActList:'../../sis_planillas/control/Obligacion/listarObligacion',
	id_store:'id_obligacion',
	fields: [
		{name:'id_obligacion', type: 'numeric'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'id_planilla', type: 'numeric'},
		{name:'id_tipo_obligacion', type: 'numeric'},
		{name:'monto_obligacion', type: 'numeric'},
		{name:'acreedor', type: 'string'},
		{name:'es_pagable', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo_pago', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_obligacion',
		direction: 'ASC'
	},
	bdel:false,
	bsave:true,
	bedit:true,
	bnew:false,
	south:{
		  url:'../../../sis_planillas/vista/obligacion_columna/ObligacionColumna.php',
		  title:'Detalle de Ejecución por Obligación', 
		  height:'50%',
		  cls:'ObligacionColumna'
	},
	
	onBtnDetalle: function(){
			var rec = {maestro: this.sm.getSelected().data};
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/detalle_transferencia/DetalleTransferencia.php',
                    'Detalle de Transferencias',
                    {
                        width:800,
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'DetalleTransferencia');
	},
	preparaMenu:function()
    {	
    	var rec = this.sm.getSelected().data;
    	
    	if (rec.tipo_pago == 'transferencia_empleados') {
    		this.getBoton('btnDetalle').enable();
    	} else {
    		this.getBoton('btnDetalle').disable();
    	}     
             
        Phx.vista.Obligacion.superclass.preparaMenu.call(this);
    },
    liberaMenu:function()
    {	
        this.getBoton('btnDetalle').disable();                
        Phx.vista.Obligacion.superclass.liberaMenu.call(this);
    },
	}
)
</script>
		
		