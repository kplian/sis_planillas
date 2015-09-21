<?php
/**
*@package pXP
*@file gen-ACTFuncionarioPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RCambiosPeriodoXLS.php');

class ACTFuncionarioPlanilla extends ACTbase{    
			
	function listarFuncionarioPlanilla(){
		$this->objParam->defecto('ordenacion','id_funcionario_planilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("funplan.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFuncionarioPlanilla','listarFuncionarioPlanilla');
		} else{
			$this->objFunc=$this->create('MODFuncionarioPlanilla');
			
			$this->res=$this->objFunc->listarFuncionarioPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFuncionarioPlanilla(){
		$this->objFunc=$this->create('MODFuncionarioPlanilla');	
		if($this->objParam->insertar('id_funcionario_planilla')){
			$this->res=$this->objFunc->insertarFuncionarioPlanilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFuncionarioPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFuncionarioPlanilla(){
			$this->objFunc=$this->create('MODFuncionarioPlanilla');	
		$this->res=$this->objFunc->eliminarFuncionarioPlanilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function listarReporteCambiosPeriodo(){
		$this->objFunc=$this->create('MODFuncionarioPlanilla');	
		
			
		$this->res=$this->objFunc->listarReporteAltasPeriodo($this->objParam);		
		$this->objParam->addParametro('altas',$this->res->datos);
		
			
		/*$this->res=$this->objFunc->listarReporteBajasPeriodo($this->objParam);
		$this->objParam->addParametro('bajas',$this->res->datos);
		
		$this->res=$this->objFunc->listarReporteMovimientosPeriodo($this->objParam);
		$this->objParam->addParametro('movimientos',$this->res->datos);
		
		$this->res=$this->objFunc->listarReporteAntiguedad2Periodo($this->objParam);
		$this->objParam->addParametro('antiguedad2',$this->res->datos);
		
		$this->res=$this->objFunc->listarReporteAntiguedad5Periodo($this->objParam);
		$this->objParam->addParametro('antiguedad5',$this->res->datos);
		*/
			
		//obtener titulo del reporte
		$titulo = 'RepCambiosPeriodo';
		
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);		
		
		$this->objReporteFormato=new RCambiosPeriodoXLS($this->objParam);
		$this->objReporteFormato->imprimeDatos();		
		
		
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}
	
			
}

?>