<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FuncionarioPlanilla = {
    require:'../../../sis_organigrama/vista/funcionario/Funcionario.php',
	requireclase:'Phx.vista.funcionario',
	title:'Funcionario',
	nombreVista: 'FuncionarioPlanilla',
	
	constructor: function(config) {
	    
	    
        Phx.vista.FuncionarioPlanilla.superclass.constructor.call(this,config);
        this.addButton('btnAfp',
        {
            text: 'AFP',
            iconCls: 'blist',
            disabled: true,
            handler: this.onBtnAfp,
            tooltip: 'Asignación de AFP'
        });
        
        this.addButton('btnBonoDesc',
        {
            text: 'Bono/Descuento',
            iconCls: 'blist',
            disabled: true,
            handler: this.onBtnBonoDesc,
            tooltip: 'Asignación de Bonos o Descuentos por Empleado'
        });
   },
   onBtnAfp: function(){
			var rec = {maestro: this.sm.getSelected().data};
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/funcionario_afp/FuncionarioAfp.php',
                    'AFP',
                    {
                        width:700,
                        height:450
                    },
                    rec,
                    this.idContenedor,
                    'FuncionarioAfp');
	},
	onBtnBonoDesc: function(){
			var rec = {maestro: this.sm.getSelected().data}; 
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/descuento_bono/DescuentoBono.php',
                    'Descuento/Bono',
                    {
                        width:700,
                        height:450
                    },
                    rec,
                    this.idContenedor,
                    'DescuentoBono');
	},
	preparaMenu:function()
    {	
        this.getBoton('btnAfp').enable();  
        this.getBoton('btnBonoDesc').enable();    
        Phx.vista.FuncionarioPlanilla.superclass.preparaMenu.call(this);
    },
    liberaMenu:function()
    {	
        this.getBoton('btnAfp').disable();
        this.getBoton('btnBonoDesc').disable();       
        Phx.vista.FuncionarioPlanilla.superclass.liberaMenu.call(this);
    }
};
</script>
