<?php
/**
*@package pXP
*@file gen-DescuentoBono.php
*@author  (admin)
*@date 20-01-2014 18:26:40
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DescuentoBono=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DescuentoBono.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag, id_funcionario :this.maestro.id_funcionario}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_descuento_bono'
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
                name:'id_moneda',
                origen:'MONEDA',
                 allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:80,
                 renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type:'ComboRec',
            id_grupo:1,
            filters:{   
                pfiltro:'mon.codigo',
                type:'string'
            },
            grid:true,
            form:true
        },
		{
			config: {
				name: 'id_tipo_columna',
				fieldLabel: 'Código Columna',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_tipo_columna',
				allowBlank: false,
				emptyText: 'Lista de Columnas...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/TipoColumna/listarTipoColumna',
					id: 'id_tipo_columna',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_columna', 'nombre', 'codigo', 'tipo_descuento_bono','tipo_dato'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipcol.nombre#tipcol.codigo',tipo_descuento_bono:'si'}
				}),
				valueField: 'id_tipo_columna',
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
				pfiltro: 'tipcol.codigo',
				type: 'string'
			},
			grid: true,
			form: true
		},
		
		{
			config:{
				name: 'valor_por_cuota',
				fieldLabel: 'Valor X Cuota',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:7
			},
				type:'NumberField',
				filters:{pfiltro:'desbon.valor_por_cuota',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'monto_total',
				fieldLabel: 'Monto Total',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'NumberField',
				filters:{pfiltro:'desbon.monto_total',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'desbon.fecha_ini',type:'date'},
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
				filters:{pfiltro:'desbon.fecha_fin',type:'date'},
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
				filters:{pfiltro:'desbon.estado_reg',type:'string'},
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
				filters:{pfiltro:'desbon.fecha_reg',type:'date'},
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
				filters:{pfiltro:'desbon.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Bono Descuento',
	ActSave:'../../sis_planillas/control/DescuentoBono/insertarDescuentoBono',
	ActDel:'../../sis_planillas/control/DescuentoBono/eliminarDescuentoBono',
	ActList:'../../sis_planillas/control/DescuentoBono/listarDescuentoBono',
	id_store:'id_descuento_bono',
	fields: [
		{name:'id_descuento_bono', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_tipo_columna', type: 'numeric'},
		{name:'valor_por_cuota', type: 'numeric'},
		{name:'monto_total', type: 'numeric'},
		{name:'num_cuotas', type: 'numeric'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado_reg', type: 'string'},
		{name:'desc_moneda', type: 'string'},
		{name:'tipo_descuento_bono', type: 'string'},
		{name:'codigo_columna', type: 'string'},
		{name:'tipo_dato', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_descuento_bono',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onButtonEdit : function () {
		var rec=this.sm.getSelected();
    	this.Cmp.id_tipo_columna.fireEvent('select',this.Cmp.id_tipo_columna,rec);
    	Phx.vista.DescuentoBono.superclass.onButtonEdit.call(this);
    	this.mostrarComponente(this.Cmp.fecha_fin);
    	this.Cmp.fecha_fin.allowBlank = true;    	
    	this.ocultarComponente(this.Cmp.fecha_ini);
    	this.ocultarComponente(this.Cmp.monto_total);
    	this.Cmp.monto_total.allowBlank = true;  
    	this.ocultarComponente(this.Cmp.valor_por_cuota);
    	this.ocultarComponente(this.Cmp.id_tipo_columna);
    	
    	if (rec.data.tipo_dato == 'basica' || rec.data.tipo_dato == 'formula') {
			this.ocultarComponente(this.Cmp.monto_total);
			this.Cmp.monto_total.reset();
			this.Cmp.monto_total.allowBlank = true;
			
			this.ocultarComponente(this.Cmp.valor_por_cuota);
			this.Cmp.valor_por_cuota.allowBlank = true;
			this.Cmp.valor_por_cuota.setValue(0);
			
		} else {
			this.mostrarComponente(this.Cmp.monto_total);
			this.Cmp.monto_total.allowBlank = true;
			this.mostrarComponente(this.Cmp.valor_por_cuota);
			this.Cmp.valor_por_cuota.allowBlank = false;
		}
    },
    onButtonNew : function () {
    	this.mostrarComponente(this.Cmp.id_tipo_columna);
    	Phx.vista.DescuentoBono.superclass.onButtonNew.call(this);
    },
    loadValoresIniciales:function()
    {	
        this.Cmp.id_funcionario.setValue(this.maestro.id_funcionario);   
        //this.Cmp.tipo_jubilado.setValue('no');    
        Phx.vista.DescuentoBono.superclass.loadValoresIniciales.call(this);
    },
    iniciarEventos : function () {
		this.Cmp.id_tipo_columna.on('select',function (c, r, i) {
				
			if (r.data.tipo_descuento_bono == 'monto_fijo_indefinido') {				
				this.mostrarComponente(this.Cmp.fecha_ini);
				this.ocultarComponente(this.Cmp.fecha_fin);			
				this.Cmp.fecha_ini.allowBlank = false;
				this.Cmp.fecha_fin.allowBlank = true;
				this.Cmp.fecha_ini.reset();
				this.Cmp.fecha_fin.reset();				
			} else {
				this.mostrarComponente(this.Cmp.fecha_ini);
				this.mostrarComponente(this.Cmp.fecha_fin);				
				this.Cmp.fecha_ini.allowBlank = false;
				this.Cmp.fecha_fin.allowBlank = false;				
			}
			
			if (r.data.tipo_dato == 'basica' || r.data.tipo_dato == 'formula') {
				this.ocultarComponente(this.Cmp.monto_total);
				this.Cmp.monto_total.reset();
				this.Cmp.monto_total.allowBlank = true;
				
				this.ocultarComponente(this.Cmp.valor_por_cuota);
				this.Cmp.valor_por_cuota.allowBlank = true;
				this.Cmp.valor_por_cuota.setValue(0);
			} else {
				this.mostrarComponente(this.Cmp.monto_total);
				this.Cmp.monto_total.allowBlank = true;
				
				this.mostrarComponente(this.Cmp.valor_por_cuota);
				this.Cmp.valor_por_cuota.allowBlank = false;
			}
			
		}, this);    	
    }
}
)
</script>
		
		