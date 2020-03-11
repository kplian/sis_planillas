<?php
/**
*@package pXP
*@file gen-ACTTipoPlanilla.php
*@author  (admin)
*@date 17-01-2014 15:36:53
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 ISSUE			AUTHOR			FECHA				DESCRIPCION
 #100			MZM				05.03.2020			Adicion de filtro habilitar_impresion_boleta
*/

class ACTTipoPlanilla extends ACTbase{    
			
	function listarTipoPlanilla(){
		$this->objParam->defecto('ordenacion','id_tipo_planilla');
		$this->objParam->defecto('dir_ordenacion','asc');
		//#100
		if ($this->objParam->getParametro('habilitar_impresion_boleta') != '') {
			 $this->objParam->addFiltro("tippla.habilitar_impresion_boleta = ''". $this->objParam->getParametro('habilitar_impresion_boleta')."''");
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoPlanilla','listarTipoPlanilla');
		} else{
			$this->objFunc=$this->create('MODTipoPlanilla');
			
			$this->res=$this->objFunc->listarTipoPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function listarTipoPlanilla2(){
        $this->objParam->defecto('ordenacion','id_tipo_planilla');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODTipoPlanilla','listarTipoPlanilla2');
        } else{
            $this->objFunc=$this->create('MODTipoPlanilla');

            $this->res=$this->objFunc->listarTipoPlanilla2($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
				
	function insertarTipoPlanilla(){
		$this->objFunc=$this->create('MODTipoPlanilla');	
		if($this->objParam->insertar('id_tipo_planilla')){
			$this->res=$this->objFunc->insertarTipoPlanilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoPlanilla(){
			$this->objFunc=$this->create('MODTipoPlanilla');	
		$this->res=$this->objFunc->eliminarTipoPlanilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>