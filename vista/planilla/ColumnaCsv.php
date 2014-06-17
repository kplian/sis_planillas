<?php
/**
*@package pXP
*@file    SubirArchivo.php
*@author  Freddy Rojas 
*@date    22-03-2012
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ColumnaCsv=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_planillas/control/ColumnaValor/modificarColumnaCsv',

    constructor:function(config)
    {   
        Phx.vista.ColumnaCsv.superclass.constructor.call(this,config);
        this.init();    
        this.loadValoresIniciales();
        this.getComponente('id_tipo_columna').store.setBaseParam('id_tipo_planilla',this.id_tipo_planilla);       
        
    },
    
    loadValoresIniciales:function()
    {        
        Phx.vista.ColumnaCsv.superclass.loadValoresIniciales.call(this);
        this.getComponente('id_planilla').setValue(this.id_planilla);     
    },
    
    successSave:function(resp)
    {
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
    },
                
    
    Atributos:[
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_planilla'
            },
            type:'Field',
            form:true
        },
        {
			config: {
				name: 'id_tipo_columna',
				fieldLabel: 'Columna a Subir',
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
					fields: ['id_tipo_columna', 'nombre', 'codigo', 'tipo_descuento_bono'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipcol.nombre#tipcol.codigo',tipo_dato : 'variable',columnas:"'SALDOPERIANTDEP'"}
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
                fieldLabel: "Documento (archivo csv separado por |)",
                gwidth: 130,
                inputType:'file',
                name: 'archivo',
                buttonText: '', 
                maxLength:150,
                anchor:'100%'                   
            },
            type:'Field',
            form:true 
        },      
    ],
    title:'Subir Archivo',    
    fileUpload:true
    
}
)    
</script>