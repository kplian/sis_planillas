<?php
/**
*@package pXP
*@file gen-ACTTipoObligacionColumna.php
*@author  (admin)
*@date 18-01-2014 02:57:04
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoObligacionColumna extends ACTbase{    
			
	function listarTipoObligacionColumna(){
		$this->objParam->defecto('ordenacion','id_tipo_obligacion_columna');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_tipo_columna') != '') {
			$this->objParam->addFiltro("obcol.id_tipo_columna = ". $this->objParam->getParametro('id_tipo_columna'));
		}
		
		if ($this->objParam->getParametro('id_tipo_obligacion') != '') {
			$this->objParam->addFiltro("obcol.id_tipo_obligacion = ". $this->objParam->getParametro('id_tipo_obligacion'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoObligacionColumna','listarTipoObligacionColumna');
		} else{
			$this->objFunc=$this->create('MODTipoObligacionColumna');
			
			$this->res=$this->objFunc->listarTipoObligacionColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoObligacionColumna(){
		$this->objFunc=$this->create('MODTipoObligacionColumna');	
		if($this->objParam->insertar('id_tipo_obligacion_columna')){
			$this->res=$this->objFunc->insertarTipoObligacionColumna($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoObligacionColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoObligacionColumna(){
			$this->objFunc=$this->create('MODTipoObligacionColumna');	
		$this->res=$this->objFunc->eliminarTipoObligacionColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>