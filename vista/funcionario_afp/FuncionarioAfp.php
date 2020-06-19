<?php
/**
*@package pXP
*@file gen-FuncionarioAfp.php
*@author  (admin)
*@date 20-01-2014 16:05:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FuncionarioAfp=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.FuncionarioAfp.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag,id_funcionario:this.maestro.id_funcionario}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_funcionario_afp'
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
			config: {
				name: 'id_afp',
				fieldLabel: 'AFP',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_afp',
				allowBlank: false,
				emptyText: 'Afp...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/Afp/listarAfp',
					id: 'id_afp',
					root: 'datos',
					sortInfo: {
						field: 'id_afp',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_afp', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'afp.nombre#afp.codigo'}
				}),
				valueField: 'id_afp',
				displayField: 'nombre',
				gdisplayField: 'nombre',
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
				pfiltro: 'afppar.nombre',
				type: 'string'
			},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'nro_afp',
				fieldLabel: 'No AFP',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'afp.nro_afp',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tipo_jubilado',
				fieldLabel: 'Jubilado',
				allowBlank:false,
				emptyText:'Jubilado...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:[['no','no'],['mayor_65','(M) Mayor 65'],['mayor_55','Mayor 55'],['jubilado_55','(J) Jubilado 55'],['jubilado_65','(N) Jubilado 65']],
				renderer:function (value,p,record){
 					if (value=='mayor_65') {return '(M) Mayor 65'}
 					else if (value=='jubilado_55') {return '(J) Jubilado 55'}
					else if (value=='jubilado_65') {return '(N) Jubilado 65'}
					else return value;

}
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['no','mayor_65','mayor_55','jubilado_55','jubilado_65']	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'afp.fecha_ini',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},		
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'afp.fecha_fin',type:'date'},
				id_grupo:1,
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
				filters:{pfiltro:'afp.estado_reg',type:'string'},
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
				filters:{pfiltro:'afp.fecha_reg',type:'date'},
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
				filters:{pfiltro:'afp.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'AFP',
	ActSave:'../../sis_planillas/control/FuncionarioAfp/insertarFuncionarioAfp',
	ActDel:'../../sis_planillas/control/FuncionarioAfp/eliminarFuncionarioAfp',
	ActList:'../../sis_planillas/control/FuncionarioAfp/listarFuncionarioAfp',
	id_store:'id_funcionario_afp',
	fields: [
		{name:'id_funcionario_afp', type: 'numeric'},
		{name:'id_afp', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'tipo_jubilado', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado_reg', type: 'string'},
		{name:'nro_afp', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'nombre', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_funcionario_afp',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onButtonEdit : function () {
    	this.ocultarComponente(this.Cmp.fecha_ini); 
    	Phx.vista.FuncionarioAfp.superclass.onButtonEdit.call(this);
    	
    },
    onButtonNew : function () {
    	this.mostrarComponente(this.Cmp.fecha_ini); 
    	Phx.vista.FuncionarioAfp.superclass.onButtonNew.call(this);
    },
    loadValoresIniciales:function()
    {	
        this.Cmp.id_funcionario.setValue(this.maestro.id_funcionario);   
        this.Cmp.tipo_jubilado.setValue('no');    
        Phx.vista.FuncionarioAfp.superclass.loadValoresIniciales.call(this);
    }
	}
)
</script>
		
		