<?php
/**
*@package pXP
*@file gen-ACTReporte.php
*@author  (admin)
*@date 17-01-2014 22:07:28
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenerica.php');

class ACTReporte extends ACTbase{    
			
	function listarReporte(){
		$this->objParam->defecto('ordenacion','id_reporte');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODReporte','listarReporte');
		} else{
			$this->objFunc=$this->create('MODReporte');
			
			$this->res=$this->objFunc->listarReporte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarReporte(){
		$this->objFunc=$this->create('MODReporte');	
		if($this->objParam->insertar('id_reporte')){
			$this->res=$this->objFunc->insertarReporte($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarReporte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarReporte(){
			$this->objFunc=$this->create('MODReporte');	
		$this->res=$this->objFunc->eliminarReporte($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reportePlanilla()	{
		if ($this->objParam->getParametro('id_proceso_wf') != '') {
			$this->objParam->addFiltro("plani.id_proceso_wf = ". $this->objParam->getParametro('id_proceso_wf'));
		}
		if ($this->objParam->getParametro('id_reporte') != '') {
			$this->objParam->addFiltro("repo.id_reporte = ". $this->objParam->getParametro('id_reporte'));
		}
		$this->objFunc=$this->create('MODReporte');	
		
		$this->res=$this->objFunc->listarReporteMaestro($this->objParam);
		
		$this->objFunc=$this->create('MODReporte');	
		$this->res2=$this->objFunc->listarReporteDetalle($this->objParam);
		//obtener titulo del reporte
		$titulo = $this->res->datos[0]['titulo_reporte'];
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.pdf';
		
		//obtener tamaño y orientacion
		if ($this->res->datos[0]['hoja_posicion'] == 'carta_vertical') {
			$tamano = 'Letter';
			$orientacion = 'P';
		} else if ($this->res->datos[0]['hoja_posicion'] == 'carta_horizontal') {
			$tamano = 'Letter';
			$orientacion = 'L';
		} else if ($this->res->datos[0]['hoja_posicion'] == 'oficio_vertical') {
			$tamano = 'Legal';
			$orientacion = 'P';
		} else {
			$tamano = 'Legal';
			$orientacion = 'L';
		}
		
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		$this->objParam->addParametro('titulo_archivo',$titulo);

		//Instancia la clase de pdf
		$this->objReporteFormato=new RPlanillaGenerica($this->objParam);
		
		$this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos);
		//$this->objReporteFormato->renderDatos($this->res2->datos);
		$this->objReporteFormato->gerencia = $this->res2->datos[0]['gerencia'];
		$this->objReporteFormato->generarReporte();
		$this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
				
	}
			
}

?>