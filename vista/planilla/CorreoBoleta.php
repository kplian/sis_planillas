<?php
/**

HISTORIAL DE MODIFICACIONES:

 ISSUE        FORK			FECHA:		      AUTOR                 DESCRIPCION
#103		endeetr		01/04/2020		Rensi Arteaga KPLIAN	crearonformulario de envio de boletas de pago
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CorreoBoleta=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_planillas/control/Reporte/EnviarBoletas',
    constructor:function(config)
    {
        Phx.vista.CorreoBoleta.superclass.constructor.call(this,config);
        this.init();
        this.loadValoresIniciales();
    },

    loadValoresIniciales:function()
    {

        var CuerpoCorreo = " <b>Gerencia Administrativa Financiera</b><br/>" ;
        CuerpoCorreo+= '<b>Planilla: '+ this.nro_planilla+'</b><br/>';
        CuerpoCorreo+='Se adjunta la boleta de Pago <BR/>';

        Phx.vista.CorreoBoleta.superclass.loadValoresIniciales.call(this);

        this.getComponente('asunto').setValue(' Boleta de Pago: '+ this.nombre_planilla );
        this.getComponente('body').setValue(CuerpoCorreo);
        this.getComponente('id_tipo_planilla').setValue(this.id_tipo_planilla);
        this.getComponente('id_gestion').setValue(this.id_gestion);
        this.getComponente('id_periodo').setValue(this.id_periodo);
        this.getComponente('id_planilla').setValue(this.id_planilla);

    },

    successSave:function(resp) {
        console.log('respuesta server...',resp)

        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        alert(reg.ROOT.detalle.mensaje);
    },

    Atributos:[

    	{
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_tipo_planilla'
            },
            type:'Field',
            form:true
        },
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
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_gestion'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_periodo'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                name: 'asunto',
                fieldLabel: 'Asunto',
                allowBlank: true,
                anchor: '90%',
                gwidth: 100,
                maxLength: 100
            },
            type:'TextField',
            id_grupo:1,
            form:true
        },
        {
            config:{
                name: 'body',
                fieldLabel: 'Mensaje',
                anchor: '90%'
            },
            type:'HtmlEditor',
             id_grupo:1,
            form:true
        }
    ],
    title:'Boleta de Pago'
});
</script>