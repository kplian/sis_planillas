<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *HISTORIAL DE MODIFICACIONES:
ISSUE            FECHA:              AUTOR                 DESCRIPCION
53 ETR        26/09/2019               RAC                 creacion
 
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresupuestoEmpleadoDet = {
    require:'../../../sis_planillas/vista/funcionario_planilla/FuncionarioPlanilla.php',
	requireclase: 'Phx.vista.FuncionarioPlanilla',
	title: 'Funcionario Planilla',
	nombreVista: 'PresupuestoEmpleadoDet',
	ActList:'../../sis_planillas/control/FuncionarioPlanilla/listarFuncionarioPlanillaPorCC',	
	constructor: function(config) {	
        Phx.vista.PresupuestoEmpleadoDet.superclass.constructor.call(this,config);
        this.init();
        this.bloquearMenus();
		if(Phx.CP.getPagina(this.idContenedorPadre)){
      	 var dataMaestro=Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
	 	 if(dataMaestro){ 
	 	 	this.onEnablePanel(this,dataMaestro)
	 	 }
	    }
       
  },
  bnew:false,
  bedit:false,
  bsave:false,
  bdel:false,
  onReloadPage:function(m){       
		this.maestro=m;
		this.store.baseParams.id_planilla = this.maestro.id_planilla;
        this.store.baseParams.id_presupuesto = this.maestro.id_presupuesto;        
		this.load({params:{ 
			               start:0, 
			               limit:this.tam_pag,
			               id_planilla: this.maestro.id_planilla,
			               id_presupuesto: this.maestro.id_presupuesto 
			              }
			        });
   },
 
	
};
</script>
