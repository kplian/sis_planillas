<?php
/**
*@package pXP
*@file gen-ACTConsolidado.php
*@author  (jrivera)
*@date 14-07-2014 19:04:07
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConsolidado extends ACTbase{    
			
	function listarConsolidado(){
		$this->objParam->defecto('ordenacion','id_consolidado');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("conpre.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConsolidado','listarConsolidado');
		} else{
			$this->objFunc=$this->create('MODConsolidado');
			
			$this->res=$this->objFunc->listarConsolidado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConsolidado(){
		$this->objFunc=$this->create('MODConsolidado');	
		if($this->objParam->insertar('id_consolidado')){
			$this->res=$this->objFunc->insertarConsolidado($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConsolidado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConsolidado(){
			$this->objFunc=$this->create('MODConsolidado');	
		$this->res=$this->objFunc->eliminarConsolidado($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>