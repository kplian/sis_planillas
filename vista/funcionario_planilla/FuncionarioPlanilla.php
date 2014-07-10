<?php
/**
*@package pXP
*@file gen-FuncionarioPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FuncionarioPlanilla=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.FuncionarioPlanilla.superclass.constructor.call(this,config);
		this.init();		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_funcionario_planilla'
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
       		    name:'id_funcionario',
   				origen:'FUNCIONARIO',
   				gwidth: 300,
   				fieldLabel:'Funcionario',
   				allowBlank:false,
   				  				
   				valueField: 'id_funcionario',
   			    gdisplayField: 'desc_funcionario1',
      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario1']);}
       	     },
   			type:'ComboRec',//ComboRec
   			id_grupo:0,
   			filters:{pfiltro:'funcio.desc_funcionario1',
				type:'string'
			},
   		   
   			grid:true,
   			form:true
   	      },
		 
		{
			config:{
				name: 'finiquito',
				fieldLabel: 'Finiquito',
				allowBlank: false,
				emptyText:'Tipo...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 100,
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
				name: 'forzar_cheque',
				fieldLabel: 'Forzar Cheque',
				emptyText:'Tipo...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 100,
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
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'funplan.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'lugar',
				fieldLabel: 'Lugar',				
				gwidth: 120
			},
				type:'TextField',
				filters:{pfiltro:'lug.nombre',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'afp',
				fieldLabel: 'Afp',				
				gwidth: 120
			},
				type:'TextField',
				filters:{pfiltro:'afp.nombre',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'nro_afp',
				fieldLabel: 'No AFP',				
				gwidth: 120
			},
				type:'TextField',
				filters:{pfiltro:'fafp.nro_afp',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'banco',
				fieldLabel: 'Banco',				
				gwidth: 120
			},
				type:'TextField',
				filters:{pfiltro:'ins.nombre',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'nro_cuenta',
				fieldLabel: 'No Cuenta',				
				gwidth: 120
			},
				type:'TextField',
				filters:{pfiltro:'fcb.nro_cuenta',type:'string'},				
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
				filters:{pfiltro:'funplan.fecha_reg',type:'date'},
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
				filters:{pfiltro:'funplan.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Funcionario Planilla',
	ActSave:'../../sis_planillas/control/FuncionarioPlanilla/insertarFuncionarioPlanilla',
	ActDel:'../../sis_planillas/control/FuncionarioPlanilla/eliminarFuncionarioPlanilla',
	ActList:'../../sis_planillas/control/FuncionarioPlanilla/listarFuncionarioPlanilla',
	id_store:'id_funcionario_planilla',
	fields: [
		{name:'id_funcionario_planilla', type: 'numeric'},
		{name:'finiquito', type: 'string'},
		{name:'forzar_cheque', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desc_funcionario1', type: 'string'},
		{name:'id_planilla', type: 'numeric'},
		{name:'id_lugar', type: 'numeric'},
		{name:'id_uo_funcionario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
		{name:'lugar', type: 'string'},
		{name:'afp', type: 'string'},
		{name:'nro_afp', type: 'string'},
		{name:'banco', type: 'string'},
		{name:'nro_cuenta', type: 'string'}		
		
	],
	sortInfo:{
		field: 'id_funcionario_planilla',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage:function(m){       
		this.maestro=m;
		this.load({params:{start:0, limit:this.tam_pag,id_planilla:this.maestro.id_planilla}});


	},
	loadValoresIniciales:function()
    {
        this.Cmp.id_planilla.setValue(this.maestro.id_planilla); 
        this.Cmp.forzar_cheque.setValue('no'); 
        this.Cmp.finiquito.setValue('no');       
        Phx.vista.FuncionarioPlanilla.superclass.loadValoresIniciales.call(this);
    },
    onButtonEdit : function () {
		this.ocultarComponente(this.Cmp.id_funcionario);
    	Phx.vista.FuncionarioPlanilla.superclass.onButtonEdit.call(this);
    	
    },
    onButtonNew : function () {
    	this.mostrarComponente(this.Cmp.id_funcionario);
    	Phx.vista.FuncionarioPlanilla.superclass.onButtonNew.call(this);
    	
    }
	}
)
</script>
		
		