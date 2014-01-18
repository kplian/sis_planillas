<?php
/**
*@package pXP
*@file gen-ACTReporte.php
*@author  (admin)
*@date 17-01-2014 22:07:28
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTReporte extends ACTbase{    
			
	function listarReporte(){
		$this->objParam->defecto('ordenacion','id_reporte');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODReporte','listarReporte');
		} else{
			$this->objFunc=$this->create('MODReporte');
			
			$this->res=$this->objFunc->listarReporte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarReporte(){
		$this->objFunc=$this->create('MODReporte');	
		if($this->objParam->insertar('id_reporte')){
			$this->res=$this->objFunc->insertarReporte($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarReporte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarReporte(){
			$this->objFunc=$this->create('MODReporte');	
		$this->res=$this->objFunc->eliminarReporte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>