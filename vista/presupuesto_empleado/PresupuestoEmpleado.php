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
Phx.vista.PresupuestoEmpleado = {
    require:'../../../sis_planillas/vista/funcionario_planilla/FuncionarioPlanilla.php',
	requireclase:'Phx.vista.FuncionarioPlanilla',
	title:'Funcionario Planilla',
	nombreVista: 'PresupuestoEmpleado',
	
	constructor: function(config) {	    
		this.id_gestion = config.maestro.id_gestion;
        Phx.vista.PresupuestoEmpleado.superclass.constructor.call(this,config);
        this.store.baseParams.id_planilla = this.maestro.id_planilla;
        
        this.load({params:{start:0, limit:this.tam_pag}});
        
  },
  bnew:false,
  bedit:false,
  bsave:false,
  bdel:false,
  south:{
		  url:'../../../sis_planillas/vista/presupuesto_empleado/Presupuesto.php',
		  title:'Presupuestos', 
		  height:'50%',
		  cls:'Presupuesto',
		  params:{'id_gestion' : this.id_gestion}
	}
   
	
};
</script>
