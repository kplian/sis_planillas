<?php
/**
*@package pXP
*@file gen-ACTReporte.php
*@author  (admin)
*@date 17-01-2014 22:07:28
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenerica.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenericaXls.php');
require_once(dirname(__FILE__).'/../reportes/RBoletaGenerica.php');

class ACTReporte extends ACTbase{    
			
	function listarReporte(){
		$this->objParam->defecto('ordenacion','id_reporte');

		$this->objParam->defecto('dir_ordenacion','asc');
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("repo.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
		}	
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
	
	function reportePlanilla($id_reporte,$tipo_reporte)	{
		
		if ($this->objParam->getParametro('id_proceso_wf') != '') {
			$this->objParam->addFiltro("plani.id_proceso_wf = ". $this->objParam->getParametro('id_proceso_wf'));
		}
		
		$this->objParam->addFiltro("repo.id_reporte = ". $id_reporte);
		
		$this->objFunc=$this->create('MODReporte');	
		
		$this->res=$this->objFunc->listarReporteMaestro($this->objParam);
		
		
		$this->objFunc=$this->create('MODReporte');	
		$this->res2=$this->objFunc->listarReporteDetalle($this->objParam);
		//obtener titulo del reporte
		$titulo = $this->res->datos[0]['titulo_reporte'];
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		
		
		//obtener tamaño y orientacion
		if ($this->res->datos[0]['hoja_posicion'] == 'carta_vertical') {
			$tamano = 'LETTER';
			$orientacion = 'P';
		} else if ($this->res->datos[0]['hoja_posicion'] == 'carta_horizontal') {
			$tamano = 'LETTER';
			$orientacion = 'L';
		} else if ($this->res->datos[0]['hoja_posicion'] == 'oficio_vertical') {
			$tamano = 'LEGAL';
			$orientacion = 'P';
		} else {
			$tamano = 'LEGAL';
			$orientacion = 'L';
		}
		
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);
		
		
		if ($tipo_reporte == 'pdf') {
			$nombreArchivo.='.pdf';
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			//Instancia la clase de pdf
			$this->objReporteFormato=new RPlanillaGenerica($this->objParam);
			$this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos);
			//$this->objReporteFormato->renderDatos($this->res2->datos);
			$this->objReporteFormato->gerencia = $this->res2->datos[0]['gerencia'];
			$this->objReporteFormato->generarReporte();
			$this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
		} else {
			
			$nombreArchivo.='.xls';
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$this->objParam->addParametro('config',$this->res->datos[0]);
			$this->objParam->addParametro('datos',$this->res2->datos);
			
			//Instancia la clase de excel
			$this->objReporteFormato=new RPlanillaGenericaXls($this->objParam);
			$this->objReporteFormato->imprimeDatos();
			$this->objReporteFormato->generarReporte();			
		}
		

		
		
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
				
	}

	function reporteBoleta()	{
		
		if ($this->objParam->getParametro('id_funcionario') != '') {
			$this->objParam->addFiltro("planifun.id_funcionario = ". $this->objParam->getParametro('id_funcionario'));
		}
		
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
		}
		
		if ($this->objParam->getParametro('id_gestion') != '') {
			$this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
		}
		
		if ($this->objParam->getParametro('id_periodo') != '') {
			$this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
		}
				
		$this->objFunc=$this->create('MODReporte');	
		
		$this->res=$this->objFunc->listarReporteMaestroBoleta($this->objParam);
		
		
		$this->objFunc=$this->create('MODReporte');	
		$this->res2=$this->objFunc->listarReporteDetalleBoleta($this->objParam);
		
		
		//obtener titulo del reporte
		$titulo = $this->res->datos[0]['titulo_reporte'];
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
				
			
		$this->objParam->addParametro('titulo_archivo',$titulo);
		
		$nombreArchivo.='.pdf';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		//Instancia la clase de pdf
		$this->objReporteFormato=new RBoletaGenerica($this->objParam);
		$this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos);		
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