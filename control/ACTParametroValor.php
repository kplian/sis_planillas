<?php
/**
*@package pXP
*@file gen-ACTParametroValor.php
*@author  (admin)
*@date 17-01-2014 15:36:56
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTParametroValor extends ACTbase{    
			
	function listarParametroValor(){
		$this->objParam->defecto('ordenacion','id_parametro_valor');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODParametroValor','listarParametroValor');
		} else{
			$this->objFunc=$this->create('MODParametroValor');
			
			$this->res=$this->objFunc->listarParametroValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarParametroValor(){
		$this->objFunc=$this->create('MODParametroValor');	
		if($this->objParam->insertar('id_parametro_valor')){
			$this->res=$this->objFunc->insertarParametroValor($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarParametroValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarParametroValor(){
			$this->objFunc=$this->create('MODParametroValor');	
		$this->res=$this->objFunc->eliminarParametroValor($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>