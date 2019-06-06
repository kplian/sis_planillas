<?php
/**
*@package pXP
*@file gen-ACTFiltroCbte.php
*@author  (miguel.mamani)
*@date 15-05-2019 22:18:29
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#6	ETR			15-05-2019 22:18:29		MMV Kplian			Identifica los presupeusto que entran al abte de diario presupeustario para planillas, los que noesten presente iran al  cbte de diraio
#*/

class ACTFiltroCbte extends ACTbase{    
			
	function listarFiltroCbte(){
		$this->objParam->defecto('ordenacion','id_filtro_cbte');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFiltroCbte','listarFiltroCbte');
		} else{
			$this->objFunc=$this->create('MODFiltroCbte');
			
			$this->res=$this->objFunc->listarFiltroCbte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFiltroCbte(){
		$this->objFunc=$this->create('MODFiltroCbte');	
		if($this->objParam->insertar('id_filtro_cbte')){
			$this->res=$this->objFunc->insertarFiltroCbte($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFiltroCbte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFiltroCbte(){
			$this->objFunc=$this->create('MODFiltroCbte');	
		$this->res=$this->objFunc->eliminarFiltroCbte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>