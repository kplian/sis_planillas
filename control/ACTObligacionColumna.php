<?php
/**
*@package pXP
*@file gen-ACTObligacionColumna.php
*@author  (jrivera)
*@date 14-07-2014 20:28:37
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTObligacionColumna extends ACTbase{    
			
	function listarObligacionColumna(){
		$this->objParam->defecto('ordenacion','id_obligacion_columna');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_obligacion') != '') {
			$this->objParam->addFiltro("oblicol.id_obligacion = ". $this->objParam->getParametro('id_obligacion'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacionColumna','listarObligacionColumna');
		} else{
			$this->objFunc=$this->create('MODObligacionColumna');
			
			$this->res=$this->objFunc->listarObligacionColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarObligacionColumna(){
		$this->objFunc=$this->create('MODObligacionColumna');	
		if($this->objParam->insertar('id_obligacion_columna')){
			$this->res=$this->objFunc->insertarObligacionColumna($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObligacionColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObligacionColumna(){
			$this->objFunc=$this->create('MODObligacionColumna');	
		$this->res=$this->objFunc->eliminarObligacionColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>