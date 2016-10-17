<?php
/**
*@package pXP
*@file gen-Prorrateo.php
*@author  (jrivera)
*@date 17-02-2016 16:12:04
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Presupuesto=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		console.log(config);
		this.id_gestion = config.id_gestion;
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Presupuesto.superclass.constructor.call(this,config);		
		this.init();
		
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_prorrateo'
			},
			type:'Field',
			form:true 
		},
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
					name: 'id_horas_trabajadas'
			},
			type:'Field',
			form:true 
		},
		
		        
        {
            config:{
                    name:'id_cc',
                    origen:'CENTROCOSTO',
                    //baseParams:{id_gestion:'grupo_ep'},
                    fieldLabel: 'Centro de Costos',
                    url: '../../sis_parametros/control/CentroCosto/listarCentroCosto',
                    emptyText : 'Centro Costo...',
                    allowBlank:false,
                    gdisplayField:'codigo_cc',//mapea al store del grid
                    gwidth:400,
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'cc.codigo_cc',type:'string'},
            grid:true,
            form:true
        },                  
			
		
		
		{
			config:{
				name: 'porcentaje',
				fieldLabel: 'porcentaje',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:327682
			},
				type:'NumberField',
				filters:{pfiltro:'pro.porcentaje',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},	
		
		
		{
			config:{
				name: 'tipo_contrato',
				fieldLabel: 'tipo_contrato',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'pro.tipo_contrato',type:'string'},
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
				filters:{pfiltro:'pro.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
		
	],
	tam_pag:50,	
	title:'Prorrateo',
	ActSave:'../../sis_planillas/control/Prorrateo/insertarProrrateo',
	ActDel:'../../sis_planillas/control/Prorrateo/eliminarProrrateo',
	ActList:'../../sis_planillas/control/Prorrateo/listarProrrateo',
	id_store:'id_prorrateo',
	fields: [
		{name:'id_prorrateo', type: 'numeric'},		
		{name:'id_cc', type: 'numeric'},
		{name:'codigo_cc', type: 'varchar'},
		{name:'id_funcionario_planilla', type: 'numeric'},
		{name:'id_horas_trabajadas', type: 'numeric'},
		{name:'id_presupuesto', type: 'numeric'},		
		{name:'porcentaje', type: 'numeric'},		
		{name:'tipo_contrato', type: 'string'},
		{name:'estado_reg', type: 'string'},		
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},		
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'}		
		
	],
	sortInfo:{
		field: 'id_prorrateo',
		direction: 'ASC'
	},
	bdel:false,
	bnew:false,
	bedit:true,
	bsave:false,
	onReloadPage:function(m){  		 
		this.maestro=m;
		this.Cmp.id_cc.store.baseParams.id_gestion = this.id_gestion;
		this.store.baseParams.id_funcionario_planilla = this.maestro.id_funcionario_planilla;
		this.load({params:{start:0, limit:this.tam_pag}});


	}
	}
)
</script>
		
		