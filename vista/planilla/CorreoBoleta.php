<?php
/**

HISTORIAL DE MODIFICACIONES:

 ISSUE        FORK			FECHA:		      AUTOR                 DESCRIPCION
#103		endeetr		01/04/2020		Rensi Arteaga KPLIAN	crearonformulario de envio de boletas de pago
#130					27/05/2020		MZM	KPLIAN				Modificacion de texto para envio por correo
#139  		   ETR      10/02/2020      MZM KPLIAN  	   		Adicion de opcion para enviar boletas de pago a los funcionarios via correo electronico
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
		//#130
        var CuerpoCorreo = " Estimado Colaborador: <br/><br/>" ;
        if (this.id_periodo > 0){//#139
        	CuerpoCorreo+='En archivo adjunto encontrará su boleta de pago correspondiente al mes de '+this.text_rep_boleta.replace('de','')+'.<BR/><br/>';
        }else{
        	CuerpoCorreo+='En archivo adjunto encontrará su boleta de pago correspondiente al '+this.text_rep_boleta.replace('Planilla de','')+'.<BR/><br/>';
        }
        
		CuerpoCorreo+= 'Gerencia de Administración y Finanzas<br/><br/>';
        Phx.vista.CorreoBoleta.superclass.loadValoresIniciales.call(this);
        this.getComponente('asunto').setValue(' Boleta de Pago '+ this.text_rep_boleta.replace('de','')  );
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