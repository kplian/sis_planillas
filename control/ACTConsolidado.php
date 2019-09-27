<?php
/**
*@package pXP
*@file gen-ACTConsolidado.php
*@author  (jrivera)
*@date 14-07-2014 19:04:07
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 * 
 
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION
 #0             14/07/2014        GUY       Creacion
 #53 ETR        26/09/2019        RAC       agregar centro de csoto techo y totalizadores
 
***************************************************************************
*/
require_once(dirname(__FILE__).'/../reportes/RDetalleEjecucionXLS.php');
require_once(dirname(__FILE__).'/../reportes/RContabilizacionXLS.php');
class ACTConsolidado extends ACTbase{    
			
	function listarConsolidado(){
		$this->objParam->defecto('ordenacion','id_consolidado');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("conpre.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConsolidado','listarConsolidado');
		} else{
			$this->objFunc=$this->create('MODConsolidado');
			
			$this->res=$this->objFunc->listarConsolidado($this->objParam);
		}
		
		//#53  añade sumatorias		
		if($this->objParam->getParametro('resumen') != 'no'){
			//adicionar una fila al resultado con el summario
			$temp = Array();
			$temp['suma'] = $this->res->extraData['total_suma'];
			$temp['suma_ejecutado'] = $this->res->extraData['total_ejecutado'];
			$temp['glosa'] = 'Sumas iguales';
			$temp['tipo_reg'] = 'summary';
			$temp['id_consolidado'] = 0;

			$this->res->total++;
			$this->res->addLastRecDatos($temp);
		}
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConsolidado(){
		$this->objFunc=$this->create('MODConsolidado');	
		if($this->objParam->insertar('id_consolidado')){
			$this->res=$this->objFunc->insertarConsolidado($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConsolidado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConsolidado(){
			$this->objFunc=$this->create('MODConsolidado');	
		$this->res=$this->objFunc->eliminarConsolidado($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarDetalleEjecucionPeriodo(){
		
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
		}
		
		if ($this->objParam->getParametro('id_gestion') != '') {
			$this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
		}	
		
		if ($this->objParam->getParametro('id_periodo') != '') {
			$this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
		}
		
		$this->objFunc=$this->create('MODConsolidado');	
		
		
		
				
		$this->res=$this->objFunc->listarDetalleEjecucionPeriodo($this->objParam);		
		$this->objParam->addParametro('datos',$this->res->datos);			
		
			
		//obtener titulo del reporte
		$titulo = 'RepDetalleEjecucion';
		
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);		
		
		$this->objReporteFormato=new RDetalleEjecucionXLS($this->objParam);
		$this->objReporteFormato->imprimeDatos();		
		
		
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}

	function reporteContabilizacion(){
		
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
		}
		
		if ($this->objParam->getParametro('id_gestion') != '') {
			$this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
		}	
		
		if ($this->objParam->getParametro('id_periodo') != '') {
			$this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
		}
		
		if ($this->objParam->getParametro('tipo_contrato') != '') {
			$this->objParam->addFiltro("concol.tipo_contrato = ''". $this->objParam->getParametro('tipo_contrato')."''");
		}
		
		$this->objFunc=$this->create('MODConsolidado');					
		$this->res=$this->objFunc->listarDetalleEjecucionPeriodo($this->objParam);	
		$this->objParam->addParametro('datos_ejecucion',$this->res->datos);	
		
		
		$this->objFunc=$this->create('MODConsolidado');					
		$this->res=$this->objFunc->listarColumnasEjecucion($this->objParam);
		$this->objParam->addParametro('columnas',$this->res->datos);
		
		$this->objFunc=$this->create('MODConsolidado');					
		$this->res=$this->objFunc->listarObligaciones($this->objParam);
		$this->objParam->addParametro('obligaciones',$this->res->datos);
		
		$this->objFunc=$this->create('MODConsolidado');					
		$this->res=$this->objFunc->listarDetalleEjecucionCategoria($this->objParam);
		$this->objParam->addParametro('ejecucion_categoria',$this->res->datos);
			
		
		
			
		//obtener titulo del reporte
		$titulo = 'RepDetalleEjecucion';
		
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);		
		
		$this->objReporteFormato=new RContabilizacionXLS($this->objParam);
			
		$this->objReporteFormato->imprimeDatos();
		$this->objReporteFormato->imprimeObligaciones();
		$this->objReporteFormato->imprimeEjecucionCategoria();		
		
		
		$this->objReporteFormato->generarReporte();
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}
			
}

?>