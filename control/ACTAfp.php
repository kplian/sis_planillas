<?php
/**
*@package pXP
*@file gen-ACTAfp.php
*@author  (admin)
*@date 20-01-2014 03:46:54
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAfp extends ACTbase{    
			
	function listarAfp(){
		$this->objParam->defecto('ordenacion','id_afp');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAfp','listarAfp');
		} else{
			$this->objFunc=$this->create('MODAfp');
			
			$this->res=$this->objFunc->listarAfp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAfp(){
		$this->objFunc=$this->create('MODAfp');	
		if($this->objParam->insertar('id_afp')){
			$this->res=$this->objFunc->insertarAfp($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAfp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAfp(){
			$this->objFunc=$this->create('MODAfp');	
		$this->res=$this->objFunc->eliminarAfp($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>