<?php
/**
*@package pXP
*@file gen-ACTReporteColumna.php
*@author  (admin)
*@date 18-01-2014 02:56:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTReporteColumna extends ACTbase{    
			
	function listarReporteColumna(){
		$this->objParam->defecto('ordenacion','id_reporte_columna');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_reporte') != '') {
			$this->objParam->addFiltro("repcol.id_reporte = ". $this->objParam->getParametro('id_reporte'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODReporteColumna','listarReporteColumna');
		} else{
			$this->objFunc=$this->create('MODReporteColumna');
			
			$this->res=$this->objFunc->listarReporteColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarReporteColumna(){
		$this->objFunc=$this->create('MODReporteColumna');	
		if($this->objParam->insertar('id_reporte_columna')){
			$this->res=$this->objFunc->insertarReporteColumna($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarReporteColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarReporteColumna(){
			$this->objFunc=$this->create('MODReporteColumna');	
		$this->res=$this->objFunc->eliminarReporteColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>