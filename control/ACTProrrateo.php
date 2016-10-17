<?php
/**
*@package pXP
*@file gen-ACTProrrateo.php
*@author  (jrivera)
*@date 17-02-2016 16:12:04
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProrrateo extends ACTbase{    
			
	function listarProrrateo(){
		$this->objParam->defecto('ordenacion','id_prorrateo');
		$this->objParam->defecto('dir_ordenacion','asc');
		if ($this->objParam->getParametro('id_funcionario_planilla') != '') {
			$this->objParam->addFiltro("pro.id_funcionario_planilla = ". $this->objParam->getParametro('id_funcionario_planilla'));
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProrrateo','listarProrrateo');
		} else{
			$this->objFunc=$this->create('MODProrrateo');
			
			$this->res=$this->objFunc->listarProrrateo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarProrrateo(){
		$this->objFunc=$this->create('MODProrrateo');	
		if($this->objParam->insertar('id_prorrateo')){
			$this->res=$this->objFunc->insertarProrrateo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarProrrateo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarProrrateo(){
			$this->objFunc=$this->create('MODProrrateo');	
		$this->res=$this->objFunc->eliminarProrrateo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>