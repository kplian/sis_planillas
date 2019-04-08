<?php
/**
*@package pXP
*@file gen-ACTTipoLicencia.php
*@author  (admin)
*@date 07-03-2019 13:52:26
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoLicencia extends ACTbase{    
			
	function listarTipoLicencia(){
		$this->objParam->defecto('ordenacion','id_tipo_licencia');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoLicencia','listarTipoLicencia');
		} else{
			$this->objFunc=$this->create('MODTipoLicencia');
			
			$this->res=$this->objFunc->listarTipoLicencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoLicencia(){
		$this->objFunc=$this->create('MODTipoLicencia');	
		if($this->objParam->insertar('id_tipo_licencia')){
			$this->res=$this->objFunc->insertarTipoLicencia($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoLicencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoLicencia(){
			$this->objFunc=$this->create('MODTipoLicencia');	
		$this->res=$this->objFunc->eliminarTipoLicencia($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>