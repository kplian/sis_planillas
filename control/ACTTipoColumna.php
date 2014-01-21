<?php
/**
*@package pXP
*@file gen-ACTTipoColumna.php
*@author  (admin)
*@date 17-01-2014 19:43:15
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoColumna extends ACTbase{    
			
	function listarTipoColumna(){
		$this->objParam->defecto('ordenacion','id_tipo_columna');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("tipcol.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
		}
		
		if ($this->objParam->getParametro('tipo_descuento_bono') == 'si') {
			$this->objParam->addFiltro("tipcol.tipo_descuento_bono is not null and tipo_descuento_bono != ''''");
		}
		
		if ($this->objParam->getParametro('presupuesto_pago') == 'si') {
			$this->objParam->addFiltro("(tipcol.compromete=''si'' or tipcol.compromete=''si_pago'')");
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoColumna','listarTipoColumna');
		} else{
			$this->objFunc=$this->create('MODTipoColumna');
			
			$this->res=$this->objFunc->listarTipoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoColumna(){
		$this->objFunc=$this->create('MODTipoColumna');	
		if($this->objParam->insertar('id_tipo_columna')){
			$this->res=$this->objFunc->insertarTipoColumna($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoColumna(){
			$this->objFunc=$this->create('MODTipoColumna');	
		$this->res=$this->objFunc->eliminarTipoColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>