<?php
/**
*@package pXP
*@file gen-ACTPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:04
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RMinisterioTrabajoXLS.php');
require_once(dirname(__FILE__).'/../reportes/RMinisterioTrabajoUpdateXLS.php');
require_once(dirname(__FILE__).'/../reportes/RPrimaXLS.php');
require_once(dirname(__FILE__).'/../reportes/RAguinaldoXLS.php');
require_once(dirname(__FILE__).'/../reportes/RSegAguinaldoXLS.php');
class ACTPlanilla extends ACTbase{
			
	function listarPlanilla(){
		$this->objParam->defecto('ordenacion','id_planilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('pes_estado') == 'otro') {
			
			$this->objParam->addFiltro("plani.estado not in (''comprobante_generado'',''planilla_finalizada'')");		
			
		} else if ($this->objParam->getParametro('pes_estado') == 'planilla_finalizada') {
			$this->objParam->addFiltro("plani.estado  in (''planilla_finalizada'')");
		} else if ($this->objParam->getParametro('pes_estado') == 'comprobante_generado') {
			$this->objParam->addFiltro("plani.estado  in (''comprobante_generado'')");
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlanilla','listarPlanilla');
		} else{
			$this->objFunc=$this->create('MODPlanilla');
			
			$this->res=$this->objFunc->listarPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarReportePlanillaMinisterio(){
		$this->objFunc=$this->create('MODPlanilla');	
		if ($this->objParam->getParametro('id_tipo_planilla') == 1) {
            if($this->objParam->getParametro('formato')=='antiguo') {
                $this->res = $this->objFunc->listarReportePlanillaMinisterio($this->objParam);
            }else if($this->objParam->getParametro('formato')=='nuevo'){
                $this->res = $this->objFunc->listarReportePlanillaMinisterioNuevo($this->objParam);
            }
			
		} else if ($this->objParam->getParametro('id_tipo_planilla') == 7) {
			$this->res=$this->objFunc->listarReportePrimaMinisterio($this->objParam);
		} else if ($this->objParam->getParametro('id_tipo_planilla') == 4) {
			$this->res=$this->objFunc->listarReporteAguinaldoMinisterio($this->objParam);
		} else if ($this->objParam->getParametro('id_tipo_planilla') == 5) {
			$this->res=$this->objFunc->listarReporteSegAguinaldoMinisterio($this->objParam);
		}
		//obtener titulo del reporte
		$titulo = 'RepMinisterioTrabajo';
		
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);		
		$this->objParam->addParametro('datos',$this->res->datos);
		
		$this->objFunc=$this->create('MODPlanilla');
		$this->res=$this->objFunc->listarReporteMinisterioCabecera($this->objParam);
		$this->objParam->addParametro('datos_cabecera',$this->res->datos);
		
		if ($this->objParam->getParametro('id_tipo_planilla') == 1) {
            //Instancia la clase de excel
		    if($this->objParam->getParametro('formato')=='antiguo'){
                $this->objReporteFormato = new RMinisterioTrabajoXLS($this->objParam);
                $this->objReporteFormato->imprimeDatosSueldo();
                $this->objReporteFormato->imprimeDatosSueldoReducido();
                $this->objReporteFormato->imprimeResumen();
                $this->objReporteFormato->imprimeResumenRegional();
            }else if($this->objParam->getParametro('formato')=='nuevo'){
                $this->objReporteFormato = new RMinisterioTrabajoUpdateXLS($this->objParam);
                $this->objReporteFormato->imprimeDatosSueldo();
                $this->objReporteFormato->imprimeResumen();
                $this->objReporteFormato->imprimeResumenRegional();
            }

		} else if ($this->objParam->getParametro('id_tipo_planilla') == 7 ) {
			
			$this->objReporteFormato=new RPrimaXLS($this->objParam);
			$this->objReporteFormato->imprimeDatosSueldo();	
			$this->objReporteFormato->imprimeResumen();	
		} else if ($this->objParam->getParametro('id_tipo_planilla') == 4) {
			
			$this->objReporteFormato=new RAguinaldoXLS($this->objParam);
			$this->objReporteFormato->imprimeDatosSueldo();	
			$this->objReporteFormato->imprimeResumen();	
		} else if ($this->objParam->getParametro('id_tipo_planilla') == 5) {
			
			$this->objReporteFormato=new RSegAguinaldoXLS($this->objParam);
			$this->objReporteFormato->imprimeDatosSueldo();	
			$this->objReporteFormato->imprimeResumen();	
		}
		
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());			
	}
				
	function insertarPlanilla(){
		$this->objFunc=$this->create('MODPlanilla');	
		if($this->objParam->insertar('id_planilla')){
			$this->res=$this->objFunc->insertarPlanilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlanilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlanilla(){
			$this->objFunc=$this->create('MODPlanilla');	
		$this->res=$this->objFunc->eliminarPlanilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function generarDescuentoCheque(){
			$this->objFunc=$this->create('MODPlanilla');	
		$this->res=$this->objFunc->generarDescuentoCheque($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function ejecutarProcesoPlanilla(){
		$this->objFunc=$this->create('MODPlanilla');
		$this->res=$this->objFunc->ejecutarProcesoPlanilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function siguienteEstadoPlanilla(){
        $this->objFunc=$this->create('MODPlanilla');  
        
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        
        $this->res=$this->objFunc->siguienteEstadoPlanilla($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    
     function anteriorEstadoPlanilla(){
        $this->objFunc=$this->create('MODPlanilla');  
        $this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
        $this->res=$this->objFunc->anteriorEstadoPlanilla($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>