<?php
/**
*@package pXP
*@file gen-ACTPlanillaSigma.php
*@author  (jrivera)
*@date 22-09-2015 14:58:50
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlanillaSigma extends ACTbase{    
			
	function listarPlanillaSigma(){
		$this->objParam->defecto('ordenacion','id_planilla_sigma');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanillaSigma','listarPlanillaSigma');
		} else{
			$this->objFunc=$this->create('MODPlanillaSigma');
			
			$this->res=$this->objFunc->listarPlanillaSigma($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlanillaSigma(){
		$this->objFunc=$this->create('MODPlanillaSigma');	
		if($this->objParam->insertar('id_planilla_sigma')){
			$this->res=$this->objFunc->insertarPlanillaSigma($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlanillaSigma($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlanillaSigma(){
			$this->objFunc=$this->create('MODPlanillaSigma');	
		$this->res=$this->objFunc->eliminarPlanillaSigma($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>