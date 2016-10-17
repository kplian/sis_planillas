<?php
/**
*@package pXP
*@file gen-ACTDescuentoBono.php
*@author  (admin)
*@date 20-01-2014 18:26:40
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDescuentoBono extends ACTbase{    
			
	function listarDescuentoBono(){
		$this->objParam->defecto('ordenacion','id_descuento_bono');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_funcionario') != '') {
			$this->objParam->addFiltro("desbon.id_funcionario = ". $this->objParam->getParametro('id_funcionario'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDescuentoBono','listarDescuentoBono');
		} else{
			$this->objFunc=$this->create('MODDescuentoBono');
			
			$this->res=$this->objFunc->listarDescuentoBono($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDescuentoBono(){
		$this->objFunc=$this->create('MODDescuentoBono');	
		if($this->objParam->insertar('id_descuento_bono')){
			$this->res=$this->objFunc->insertarDescuentoBono($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDescuentoBono($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDescuentoBono(){
			$this->objFunc=$this->create('MODDescuentoBono');	
		$this->res=$this->objFunc->eliminarDescuentoBono($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>