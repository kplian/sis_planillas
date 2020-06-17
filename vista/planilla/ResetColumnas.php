<?php
/**
*@package pXP
*@file    ResetColumnas.php
*@author  
*@date    29.05.2020
*@description permites subir archivos a la tabla de documento_sol
 #ISSUE                FECHA                AUTOR                DESCRIPCION 
 #132	 ETR		  01/06/2020			MZM KPLIAN			Habilitacion de opcion para reseteo de valores de columnas variables
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ResetColumnas=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_planillas/control/ColumnaValor/resetColumnaValor',

    constructor:function(config)
    {   
        Phx.vista.ResetColumnas.superclass.constructor.call(this,config);
        this.init();    
        this.loadValoresIniciales();
        this.getComponente('id_tipo_columna').store.setBaseParam('id_tipo_planilla',this.id_tipo_planilla);       
            
        	 
    },
    
    loadValoresIniciales:function()
    {        
        Phx.vista.ResetColumnas.superclass.loadValoresIniciales.call(this);
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
				fieldLabel: 'Columna a Resetear',
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
					baseParams: {par_filtro: 'tipcol.nombre#tipcol.codigo',tipo_dato : 'variable',columnas:"''SALDOPERIANTDEP''"}
				}),
				valueField: 'id_tipo_columna',
				displayField: 'nombre',
				gdisplayField: 'codigo_columna',
				triggerAction: 'all',
				lazyRender: true,
				enableMultiSelect : true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				
				tpl : new Ext.XTemplate('<tpl for="."><div class="awesomecombo-5item {checked}">', '<p> {codigo} - {nombre}</p>',  '</div></tpl>'),
				itemSelector : 'div.awesomecombo-5item',
			},
			type: 'AwesomeCombo',
			id_grupo: 0,
			filters: {
				pfiltro: 'tipcol.codigo',
				type: 'string'
			},
			grid: true,
			form: true
		} 
    ],
    title:'Subir Archivo',    
    fileUpload:false,
    
    
}
)    
</script>