<?php
/**
*@package pXP
*@file gen-ACTFuncionarioPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFuncionarioPlanilla extends ACTbase{    
			
	function listarFuncionarioPlanilla(){
		$this->objParam->defecto('ordenacion','id_funcionario_planilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFuncionarioPlanilla','listarFuncionarioPlanilla');
		} else{
			$this->objFunc=$this->create('MODFuncionarioPlanilla');
			
			$this->res=$this->objFunc->listarFuncionarioPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFuncionarioPlanilla(){
		$this->objFunc=$this->create('MODFuncionarioPlanilla');	
		if($this->objParam->insertar('id_funcionario_planilla')){
			$this->res=$this->objFunc->insertarFuncionarioPlanilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFuncionarioPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFuncionarioPlanilla(){
			$this->objFunc=$this->create('MODFuncionarioPlanilla');	
		$this->res=$this->objFunc->eliminarFuncionarioPlanilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>