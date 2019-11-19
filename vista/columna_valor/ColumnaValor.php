<?php
/**
*@package pXP
*@file gen-ColumnaValor.php
*@author  (admin)
*@date 27-01-2014 04:53:54
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * 
 * HISTORIAL DE MODIFICACIONES:
   	
 ISSUE            FECHA:		      AUTOR                 DESCRIPCION
 ---------------------------------------------------------------------------------------------   
 #00  ETR       27-01-2014        JRR               creacion  
 #14  ETR       10/06/2019        RAC KPLIAN        aumenta capacidad de decimales en columnas editables 
 #78 ETR        18-11-2019        RAC               considerar esquema para origen de datos
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ColumnaValor=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		console.log('config -->',config)
    	//llama al constructor de la clase padre
    	this.esquema = Phx.CP.getPagina(config.idContenedorPadre).esquema?Phx.CP.getPagina(config.idContenedorPadre).esquema:'plani';
    	
    	//#78 si es el esquema de planilla habilita el detalle de columnas
    	this.east=((this.esquema === 'plani')?{
												  url:'../../../sis_planillas/vista/columna_detalle/ColumnaDetalle.php',
												  title:'Columna Detalle', 
												  width:'50%',
												  cls:'ColumnaDetalle',
												  collapsed:true
											  }:undefined);
    	
		Phx.vista.ColumnaValor.superclass.constructor.call(this,config);	
		
		
		this.store.baseParams.esquema = this.esquema?this.esquema:'plani'; //si no existe el dato por defecto recupera de PLANI
		this.init();
		//#78
        if(this.esquema === 'plani'){
        	this.getBoton('save').enable(); 
        } else {
        	this.getBoton('save').disable(); 
        }
        
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_columna_valor'
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
			config:{
				name: 'codigo_columna',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'colval.codigo_columna',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'nombre_columna',
				fieldLabel: 'Nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 180,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'tipcol.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'formula',
				fieldLabel: 'Fórmula',
				allowBlank: true,
				anchor: '80%',
				gwidth: 180,
				maxLength:255
			},
				type:'TextField',
				filters:{pfiltro:'colval.formula',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'valor',
				fieldLabel: 'Valor',
				allowBlank: false,
				allowDecimals: true, //#14 +
				decimalPrecision:20, //#14 +
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'colval.valor',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},
		{
			config:{
				name: 'valor_generado',
				fieldLabel: 'Valor Generado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'colval.valor_generado',type:'numeric'},
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
				filters:{pfiltro:'colval.estado_reg',type:'string'},
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
				filters:{pfiltro:'colval.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'colval.fecha_mod',type:'date'},
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
	title:'Columna Valor',
	ActSave:'../../sis_planillas/control/ColumnaValor/insertarColumnaValor',
	ActDel:'../../sis_planillas/control/ColumnaValor/eliminarColumnaValor',
	ActList:'../../sis_planillas/control/ColumnaValor/listarColumnaValor',
	id_store:'id_columna_valor',
	fields: [
		{name:'id_columna_valor', type: 'numeric'},
		{name:'id_tipo_columna', type: 'numeric'},
		{name:'id_funcionario_planilla', type: 'numeric'},
		{name:'codigo_columna', type: 'string'},
		{name:'nombre_columna', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'valor', type: 'numeric'},
		{name:'valor_generado', type: 'numeric'},
		{name:'formula', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'estado_planilla', type: 'string'},

		
	],
	sortInfo:{
		field: 'tipcol.orden',
		direction: 'ASC'
	},
	    
	bdel:false,
	bnew:false,
	bedit:false,
	bsave: true,
	preparaMenu:function() { //#78	
		    var rec = this.sm.getSelected();
            Phx.vista.ColumnaValor.superclass.preparaMenu.call(this);
            console.log('ESQUEMA...', this.esquema)
            if(this.esquema === 'plani'){
	        	this.getBoton('save').enable(); 
	        } else {
	        	this.getBoton('save').disable(); 
	        }
    },
    liberaMenu:function() { //#78	
           Phx.vista.ColumnaValor.superclass.liberaMenu.call(this);
           if(this.esquema === 'plani'){
	       	this.getBoton('save').enable(); 
	       } else {
	       	this.getBoton('save').disable(); 
	       }
     },
	onReloadPage:function(m, x){  		 
		this.maestro=m;
		this.store.baseParams.id_funcionario_planilla = this.maestro.id_funcionario_planilla;
		this.load({params:{start:0, limit:this.tam_pag}});
		//#78 habilta opcion de modificar si es el quema principal
		if(this.esquema === 'plani'){
	       this.getBoton('save').enable(); 
	    } else {
	       this.getBoton('save').disable(); 
	    }
	}
}
)
</script>
		
		