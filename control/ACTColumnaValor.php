<?php
/**
*@package pXP
*@file gen-ACTColumnaValor.php
*@author  (admin)
*@date 27-01-2014 04:53:54
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTColumnaValor extends ACTbase{    
			
	function listarColumnaValor(){
		$this->objParam->defecto('ordenacion','id_columna_valor');

		$this->objParam->defecto('dir_ordenacion','asc');
		if ($this->objParam->getParametro('id_funcionario_planilla') != '') {
			$this->objParam->addFiltro("colval.id_funcionario_planilla = ". $this->objParam->getParametro('id_funcionario_planilla'));
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODColumnaValor','listarColumnaValor');
		} else{
			$this->objFunc=$this->create('MODColumnaValor');
			
			$this->res=$this->objFunc->listarColumnaValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarColumnaValor(){
		$this->objFunc=$this->create('MODColumnaValor');	
		if($this->objParam->insertar('id_columna_valor')){
			$this->res=$this->objFunc->insertarColumnaValor($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarColumnaValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarColumnaValor(){
			$this->objFunc=$this->create('MODColumnaValor');	
		$this->res=$this->objFunc->eliminarColumnaValor($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>