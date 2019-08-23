<?php
/**
*@package pXP
*@file gen-FiltroCbte.php
*@author  (miguel.mamani)
*@date 15-05-2019 22:18:29
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#6	ETR			15-05-2019 22:18:29		MMV Kplian			Identifica los presupeusto que entran al abte de diario presupeustario para planillas, los que noesten presente iran al  cbte de diraio
#28 ETR         22-08-2019              RAC Kplian          añade qtip para explicar la funcionalidad de la interface 
#*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FiltroCbte=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.FiltroCbte.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
        {
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_filtro_cbte'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                name: 'id_tipo_presupuesto',
                fieldLabel: 'Tipo de Presupuesto',
                qtip: 'identifica los presupeusto que entran al cbte de diario presupeustario para planillas, los que noe sten presente iran al  cbte de diraio ',
                allowBlank: false,
                emptyText:'Filtro...',
                store : new Ext.data.JsonStore({
                    url:'../../sis_presupuestos/control/TipoPresupuesto/listarTipoPresupuesto',
                    id : 'codigo',
                    root: 'datos',
                    sortInfo:{
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_presupuesto','codigo', 'nombre', 'movimiento'],
                    remoteSort: true,
                    baseParams: { par_filtro:'nombre' }
                }),
                valueField : 'id_tipo_presupuesto',
                displayField : 'nombre',
                hiddenName : 'codigo',
                enableMultiSelect : true,
                triggerAction : 'all',
                lazyRender : true,
                mode : 'remote',
                pageSize : 20,
                width : 150,
                anchor : '80%',
                listWidth : '280',
                resizable : true,
                minChars : 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['tipo_presupuesto']);
                }
            },
            type:'ComboBox',
            id_grupo:0,
            grid: true,
            form: true
        },
        {
            config:{
                name: 'obs',
                fieldLabel: 'obs',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
            type:'TextField',
            filters:{pfiltro:'foe.obs',type:'string'},
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
            filters:{pfiltro:'foe.estado_reg',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'id_usuario_ai',
                fieldLabel: '',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'foe.id_usuario_ai',type:'numeric'},
            id_grupo:1,
            grid:false,
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
            filters:{pfiltro:'foe.usuario_ai',type:'string'},
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
            filters:{pfiltro:'foe.fecha_reg',type:'date'},
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
            filters:{pfiltro:'foe.fecha_mod',type:'date'},
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
	title:'Filtro Cbte',
	ActSave:'../../sis_planillas/control/FiltroCbte/insertarFiltroCbte',
	ActDel:'../../sis_planillas/control/FiltroCbte/eliminarFiltroCbte',
	ActList:'../../sis_planillas/control/FiltroCbte/listarFiltroCbte',
	id_store:'id_filtro_cbte',
	fields: [
		{name:'id_filtro_cbte', type: 'numeric'},
		{name:'id_tipo_presupuesto', type: 'numeric'},
		{name:'tipo_presupuesto', type: 'string'},
        {name:'obs', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_filtro_cbte',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		