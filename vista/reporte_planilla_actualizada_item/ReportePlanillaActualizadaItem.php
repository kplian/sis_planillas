<?php
/**
 *@package pXP
 *@file    ItemEntRec.php
 *@author  admin
 *@date    13/09/2016
 *@description Reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PlanillaActualizadaItem= Ext.extend(Phx.frmInterfaz, {
        Atributos : [

            {
                config:{
                    name:'id_uo',
                    hiddenName: 'id_uo',
                    origen:'UO',
                    fieldLabel:'UO',
                    gdisplayField:'desc_uo',//mapea al store del grid
                    gwidth:200,
                    emptyText:'Dejar blanco para toda la empresa...',
                    anchor: '50%',
                    baseParams: {gerencia: 'si'},
                    allowBlank:true,
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}
                },
                type:'ComboRec',
                id_grupo:1,
                filters:{
                    pfiltro:'uo.codigo#uo.nombre_unidad',
                    type:'string'
                },
                grid:true,
                form:true
            },
            {
                config:{
                    name:'agrupar_por',
                    fieldLabel:'Agrupar Por',
                    allowBlank:false,
                    emptyText:'Tipo...',

                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    anchor: '30%',
                    store:['Organigrama','Regional','Regional oficina']

                },
                type:'ComboBox',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name: 'fecha',
                    allowBlank:false,
                    fieldLabel: 'Fecha Reporte',
                    allowBlank:'Fecha a la que se generara el reporte',
                    anchor: '30%',
                    gwidth: 100,
                    format: 'd/m/Y'

                },
                type:'DateField',
                id_grupo:1,
                form:true
            }
        ],
        title : 'Generar Reporte',
        ActSave : '../../sis_planillas/control/Reporte/ListarReportePlanillaActualizadaItem',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Generar Excel</b>',
        constructor : function(config) {
            Phx.vista.PlanillaActualizadaItem.superclass.constructor.call(this, config);
            this.init();
        },

        tipo : 'reporte',
        clsSubmit : 'bprint',

        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.uo = this.Cmp.id_uo.getRawValue();
           // this.argumentExtraSubmit.tipo_contrato = this.Cmp.id_tipo_contrato.getRawValue();

        }
    })
</script>
