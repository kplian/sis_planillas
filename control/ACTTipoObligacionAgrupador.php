<?php
/**
*@package pXP
*@file gen-ACTTipoObligacionAgrupador.php
*@author  (eddy.gutierrez)
*@date 05-02-2019 20:20:47
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
  ISSUE 	FORK		FECHA			AUTHOR			DESCRIPCION
  #3		EndeEtr		05/02/2019		EGS				creacion
*/

class ACTTipoObligacionAgrupador extends ACTbase{    
			
	function listarTipoObligacionAgrupador(){
		$this->objParam->defecto('ordenacion','id_tipo_obligacion_agrupador');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoObligacionAgrupador','listarTipoObligacionAgrupador');
		} else{
			$this->objFunc=$this->create('MODTipoObligacionAgrupador');
			
			$this->res=$this->objFunc->listarTipoObligacionAgrupador($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoObligacionAgrupador(){
		$this->objFunc=$this->create('MODTipoObligacionAgrupador');	
		if($this->objParam->insertar('id_tipo_obligacion_agrupador')){
			$this->res=$this->objFunc->insertarTipoObligacionAgrupador($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoObligacionAgrupador($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoObligacionAgrupador(){
			$this->objFunc=$this->create('MODTipoObligacionAgrupador');	
		$this->res=$this->objFunc->eliminarTipoObligacionAgrupador($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>