<?php
/**
*@package pXP
*@file gen-ACTObligacion.php
*@author  (jrivera)
*@date 14-07-2014 20:30:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTObligacion extends ACTbase{    
			
	function listarObligacion(){
		$this->objParam->defecto('ordenacion','id_obligacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("obli.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacion','listarObligacion');
		} else{
			$this->objFunc=$this->create('MODObligacion');
			
			$this->res=$this->objFunc->listarObligacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarObligacion(){
		$this->objFunc=$this->create('MODObligacion');	
		if($this->objParam->insertar('id_obligacion')){
			$this->res=$this->objFunc->insertarObligacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObligacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObligacion(){
			$this->objFunc=$this->create('MODObligacion');	
		$this->res=$this->objFunc->eliminarObligacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>