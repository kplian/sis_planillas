<?php
/**
*@package pXP
*@file gen-ACTPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:04
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlanilla extends ACTbase{    
			
	function listarPlanilla(){
		$this->objParam->defecto('ordenacion','id_planilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanilla','listarPlanilla');
		} else{
			$this->objFunc=$this->create('MODPlanilla');
			
			$this->res=$this->objFunc->listarPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlanilla(){
		$this->objFunc=$this->create('MODPlanilla');	
		if($this->objParam->insertar('id_planilla')){
			$this->res=$this->objFunc->insertarPlanilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlanilla(){
			$this->objFunc=$this->create('MODPlanilla');	
		$this->res=$this->objFunc->eliminarPlanilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>