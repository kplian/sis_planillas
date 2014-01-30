<?php
/**
*@package pXP
*@file gen-ACTHorasTrabajadas.php
*@author  (admin)
*@date 26-01-2014 21:35:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTHorasTrabajadas extends ACTbase{    
			
	function listarHorasTrabajadas(){
		$this->objParam->defecto('ordenacion','id_horas_trabajadas');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("funplan.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODHorasTrabajadas','listarHorasTrabajadas');
		} else{
			$this->objFunc=$this->create('MODHorasTrabajadas');
			
			$this->res=$this->objFunc->listarHorasTrabajadas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarHorasTrabajadas(){
		$this->objFunc=$this->create('MODHorasTrabajadas');	
		if($this->objParam->insertar('id_horas_trabajadas')){
			$this->res=$this->objFunc->insertarHorasTrabajadas($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarHorasTrabajadas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarHorasTrabajadas(){
			$this->objFunc=$this->create('MODHorasTrabajadas');	
		$this->res=$this->objFunc->eliminarHorasTrabajadas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>