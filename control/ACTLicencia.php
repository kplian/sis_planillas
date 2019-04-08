<?php
/**
*@package pXP
*@file gen-ACTLicencia.php
*@author  (admin)
*@date 07-03-2019 13:53:18
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTLicencia extends ACTbase{    
			
	function listarLicencia(){
		$this->objParam->defecto('ordenacion','id_licencia');

		$this->objParam->defecto('dir_ordenacion','asc');		
		//$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
		 		
		if ($this->objParam->getParametro('estado') != '') {
					$this->objParam->addFiltro("lice.estado = ''" . $this->objParam->getParametro('estado') . "''");		
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODLicencia','listarLicencia');
		} else{
			$this->objFunc=$this->create('MODLicencia');
			
			$this->res=$this->objFunc->listarLicencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarLicencia(){
		$this->objFunc=$this->create('MODLicencia');	
		if($this->objParam->insertar('id_licencia')){
			$this->res=$this->objFunc->insertarLicencia($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarLicencia($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarLicencia(){
			$this->objFunc=$this->create('MODLicencia');	
		$this->res=$this->objFunc->eliminarLicencia($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
		
	function siguienteEstado(){
        $this->objFunc=$this->create('MODLicencia');  
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function anteriorEstado(){
        $this->objFunc=$this->create('MODLicencia');  
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>