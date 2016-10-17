<?php
/**
*@package pXP
*@file gen-ACTConsolidadoColumna.php
*@author  (jrivera)
*@date 14-07-2014 19:04:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConsolidadoColumna extends ACTbase{    
			
	function listarConsolidadoColumna(){
		$this->objParam->defecto('ordenacion','id_consolidado_columna');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_consolidado') != '') {
			$this->objParam->addFiltro("concol.id_consolidado = ". $this->objParam->getParametro('id_consolidado'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConsolidadoColumna','listarConsolidadoColumna');
		} else{
			$this->objFunc=$this->create('MODConsolidadoColumna');
			
			$this->res=$this->objFunc->listarConsolidadoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConsolidadoColumna(){
		$this->objFunc=$this->create('MODConsolidadoColumna');	
		if($this->objParam->insertar('id_consolidado_columna')){
			$this->res=$this->objFunc->insertarConsolidadoColumna($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConsolidadoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConsolidadoColumna(){
			$this->objFunc=$this->create('MODConsolidadoColumna');	
		$this->res=$this->objFunc->eliminarConsolidadoColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>