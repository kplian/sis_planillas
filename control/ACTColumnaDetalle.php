<?php
/**
*@package pXP
*@file gen-ACTColumnaDetalle.php
*@author  (jrivera)
*@date 06-12-2014 17:17:45
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTColumnaDetalle extends ACTbase{    
			
	function listarColumnaDetalle(){
		$this->objParam->defecto('ordenacion','id_columna_detalle');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_columna_valor') != '') {
			$this->objParam->addFiltro("coldet.id_columna_valor = ". $this->objParam->getParametro('id_columna_valor'));
		}	
	
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODColumnaDetalle','listarColumnaDetalle');
		} else{
			$this->objFunc=$this->create('MODColumnaDetalle');
			
			$this->res=$this->objFunc->listarColumnaDetalle($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarColumnaDetalle(){
		$this->objFunc=$this->create('MODColumnaDetalle');	
		if($this->objParam->insertar('id_columna_detalle')){
			$this->res=$this->objFunc->insertarColumnaDetalle($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarColumnaDetalle($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarColumnaDetalle(){
			$this->objFunc=$this->create('MODColumnaDetalle');	
		$this->res=$this->objFunc->eliminarColumnaDetalle($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>