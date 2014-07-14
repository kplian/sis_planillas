<?php
/**
*@package pXP
*@file gen-ACTDetalleTransferencia.php
*@author  (jrivera)
*@date 14-07-2014 20:28:39
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDetalleTransferencia extends ACTbase{    
			
	function listarDetalleTransferencia(){
		$this->objParam->defecto('ordenacion','id_detalle_transferencia');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_obligacion') != '') {
			$this->objParam->addFiltro("detran.id_obligacion = ". $this->objParam->getParametro('id_obligacion'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDetalleTransferencia','listarDetalleTransferencia');
		} else{
			$this->objFunc=$this->create('MODDetalleTransferencia');
			
			$this->res=$this->objFunc->listarDetalleTransferencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDetalleTransferencia(){
		$this->objFunc=$this->create('MODDetalleTransferencia');	
		if($this->objParam->insertar('id_detalle_transferencia')){
			$this->res=$this->objFunc->insertarDetalleTransferencia($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDetalleTransferencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDetalleTransferencia(){
			$this->objFunc=$this->create('MODDetalleTransferencia');	
		$this->res=$this->objFunc->eliminarDetalleTransferencia($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>