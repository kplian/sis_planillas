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
Phx.vista.FuncionarioPlanillaColumna = {
    require:'../../../sis_planillas/vista/funcionario_planilla/FuncionarioPlanilla.php',
	requireclase:'Phx.vista.FuncionarioPlanilla',
	title:'Funcionario Planilla',
	nombreVista: 'FuncionarioPlanillaColumna',
	
	constructor: function(config) {	    
        Phx.vista.FuncionarioPlanillaColumna.superclass.constructor.call(this,config);
        this.load({params:{start:0, limit:this.tam_pag,id_planilla :this.maestro.id_planilla}});
        
  },
  bnew:false,
  bedit:false,
  bsave:false,
  bdel:false,
  south:{
		  url:'../../../sis_planillas/vista/columna_valor/ColumnaValor.php',
		  title:'Columnas', 
		  height:'50%',
		  cls:'ColumnaValor'
	}
   
	
};
</script>
