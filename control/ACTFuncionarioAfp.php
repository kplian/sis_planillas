<?php
/**
*@package pXP
*@file gen-ACTFuncionarioAfp.php
*@author  (admin)
*@date 20-01-2014 16:05:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFuncionarioAfp extends ACTbase{    
			
	function listarFuncionarioAfp(){
		$this->objParam->defecto('ordenacion','id_funcionario_afp');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_funcionario') != '') {
			$this->objParam->addFiltro("afp.id_funcionario = ". $this->objParam->getParametro('id_funcionario'));
		}	
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFuncionarioAfp','listarFuncionarioAfp');
		} else{
			$this->objFunc=$this->create('MODFuncionarioAfp');
			
			$this->res=$this->objFunc->listarFuncionarioAfp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFuncionarioAfp(){
		$this->objFunc=$this->create('MODFuncionarioAfp');	
		if($this->objParam->insertar('id_funcionario_afp')){
			$this->res=$this->objFunc->insertarFuncionarioAfp($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFuncionarioAfp($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFuncionarioAfp(){
			$this->objFunc=$this->create('MODFuncionarioAfp');	
		$this->res=$this->objFunc->eliminarFuncionarioAfp($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>