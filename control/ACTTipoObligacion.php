<?php
/**
*@package pXP
*@file gen-ACTTipoObligacion.php
*@author  (admin)
*@date 17-01-2014 19:43:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoObligacion extends ACTbase{    
			
	function listarTipoObligacion(){
		$this->objParam->defecto('ordenacion','id_tipo_obligacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("tipobli.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoObligacion','listarTipoObligacion');
		} else{
			$this->objFunc=$this->create('MODTipoObligacion');
			
			$this->res=$this->objFunc->listarTipoObligacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoObligacion(){
		$this->objFunc=$this->create('MODTipoObligacion');	
		if($this->objParam->insertar('id_tipo_obligacion')){
			$this->res=$this->objFunc->insertarTipoObligacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoObligacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoObligacion(){
			$this->objFunc=$this->create('MODTipoObligacion');	
		$this->res=$this->objFunc->eliminarTipoObligacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>