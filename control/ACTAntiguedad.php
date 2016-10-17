<?php
/**
*@package pXP
*@file gen-ACTAntiguedad.php
*@author  (admin)
*@date 20-01-2014 03:47:41
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAntiguedad extends ACTbase{    
			
	function listarAntiguedad(){
		$this->objParam->defecto('ordenacion','id_antiguedad');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAntiguedad','listarAntiguedad');
		} else{
			$this->objFunc=$this->create('MODAntiguedad');
			
			$this->res=$this->objFunc->listarAntiguedad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAntiguedad(){
		$this->objFunc=$this->create('MODAntiguedad');	
		if($this->objParam->insertar('id_antiguedad')){
			$this->res=$this->objFunc->insertarAntiguedad($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAntiguedad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAntiguedad(){
			$this->objFunc=$this->create('MODAntiguedad');	
		$this->res=$this->objFunc->eliminarAntiguedad($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>