<?php
/**
*@package pXP
*@file gen-HorasTrabajadas.php
*@author  (admin)
*@date 26-01-2014 21:35:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.HorasTrabajadas=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.HorasTrabajadas.superclass.constructor.call(this,config);
		this.init();
		this.store.baseParams.id_planilla = this.maestro.id_planilla;
		this.load({params:{start:0, limit:this.tam_pag}});
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_horas_trabajadas'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_uo_funcionario'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_funcionario'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'tipo_contrato',
				fieldLabel: 'Tipo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 60,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'hortra.tipo_contrato',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
            config:{
                name: 'ci',
                fieldLabel: 'CI',
                allowBlank: true,
                gwidth: 130
            },
                type:'TextField',
                filters:{pfiltro:'fun.ci',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter : true
        },  
		{
			config:{
				name: 'desc_funcionario',
				fieldLabel: 'Funcionario',
				allowBlank: true,
				gwidth: 130
			},
				type:'TextField',
				filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
				id_grupo:1,
				grid:true,
				form:false,
                bottom_filter : true
		},		
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Desde',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'hortra.fecha_ini',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Hasta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'hortra.fecha_fin',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'sueldo',
				fieldLabel: 'Haber Básico',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.sueldo',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'horas_normales',
				fieldLabel: 'Horas',
				allowBlank: false,
				anchor: '80%',
				gwidth: 80,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_normales',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},
		{
			config:{
				name: 'horas_extras',
				fieldLabel: 'H. Extras',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_extras',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},
		{
			config:{
				name: 'horas_nocturnas',
				fieldLabel: 'H. Nocturnas',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_nocturnas',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},
		{
			config:{
				name: 'horas_disponibilidad',
				fieldLabel: 'H. Disponibilidad',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:655362
			},
				type:'NumberField',
				filters:{pfiltro:'hortra.horas_disponibilidad',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
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
				filters:{pfiltro:'hortra.estado_reg',type:'string'},
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
				filters:{pfiltro:'hortra.fecha_reg',type:'date'},
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
				filters:{pfiltro:'hortra.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Horas Trabajadas',
	ActSave:'../../sis_planillas/control/HorasTrabajadas/insertarHorasTrabajadas',
	ActDel:'../../sis_planillas/control/HorasTrabajadas/eliminarHorasTrabajadas',
	ActList:'../../sis_planillas/control/HorasTrabajadas/listarHorasTrabajadas',
	id_store:'id_horas_trabajadas',
	fields: [
		{name:'id_horas_trabajadas', type: 'numeric'},
		{name:'id_funcionario_planilla', type: 'numeric'},
		{name:'id_uo_funcionario', type: 'numeric'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'horas_extras', type: 'numeric'},
		{name:'horas_disponibilidad', type: 'numeric'},
		{name:'horas_nocturnas', type: 'numeric'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'tipo_contrato', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'horas_normales', type: 'numeric'},
		{name:'sueldo', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_funcionario', type: 'string'},
		{name:'ci', type: 'string'},
		
	],
	sortInfo:{
		field: 'desc_funcionario1,id_horas_trabajadas',
		direction: 'ASC'
	},
	bdel:false,
	bnew:false,
	bedit:false,
	bsave:true,
	preparaMenu : function () {
		
		if (this.maestro.estado == 'registro_horas' || this.maestro.estado == 'calculo_columnas') {
			this.getBoton('save').enable();  
		} else {
			this.getBoton('save').disable();  
		}
		Phx.vista.HorasTrabajadas.superclass.preparaMenu.call(this);
	}, 
	liberaMenu : function () {	
		
		Phx.vista.HorasTrabajadas.superclass.liberaMenu.call(this);
		this.getBoton('save').disable(); 	
	}
	}
)
</script>
		
		