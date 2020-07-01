<?php
/**
*@package pXP
*@file gen-ACTFuncionarioPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 * HISTORIAL DE MODIFICACIONES:
ISSUE            FECHA:              AUTOR                 DESCRIPCION
#0             22-01-2014              GUY              creacion
#53 ETR        26/09/2019              RAC              listado para Interface que identifica empleado según centro de costo
#61 ETR        01/10/2019              RAC              Funcionalidad para actualizar bancos y AFP , de funcionarios que no tiene el dato a la fecha de la planilla
#129 ETR       28.05.2020               RAC             Funcionalidad para actulizar formulas y columnas sn eliminas la planillas

 * */
require_once(dirname(__FILE__).'/../reportes/RCambiosPeriodoXLS.php');

class ACTFuncionarioPlanilla extends ACTbase{

	function listarFuncionarioPlanilla(){
		$this->objParam->defecto('ordenacion','id_funcionario_planilla');

		$this->objParam->defecto('dir_ordenacion','asc');
		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("funplan.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}
		//#144
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("funplan.id_planilla in  (select id_planilla from plani.tplanilla where id_tipo_planilla=". $this->objParam->getParametro('id_tipo_planilla')." and id_periodo=".$this->objParam->getParametro('id_periodo'). " and id_gestion=".$this->objParam->getParametro('id_gestion'). " )
                        and tc.id_tipo_contrato=".$this->objParam->getParametro('id_tipo_contrato') );
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

		$this->objFunc=$this->create('MODFuncionarioPlanilla');
		$this->res=$this->objFunc->listarReporteBajasPeriodo($this->objParam);
		$this->objParam->addParametro('bajas',$this->res->datos);

		$this->objFunc=$this->create('MODFuncionarioPlanilla');
		$this->res=$this->objFunc->listarReporteMovimientosPeriodo($this->objParam);
		$this->objParam->addParametro('movimientos',$this->res->datos);

		$this->objFunc=$this->create('MODFuncionarioPlanilla');
		$this->res=$this->objFunc->listarReporteAntiguedadPeriodo($this->objParam);
		$this->objParam->addParametro('antiguedad',$this->res->datos);


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


   //#52  listado de funcionarios por centro de costos
   function listarFuncionarioPlanillaPorCC(){
		$this->objParam->defecto('ordenacion','id_funcionario_planilla');

		$this->objParam->defecto('dir_ordenacion','asc');

		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("funplan.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}

		if ($this->objParam->getParametro('id_presupuesto') != '') {
			$this->objParam->addFiltro("pro.id_presupuesto = ". $this->objParam->getParametro('id_presupuesto'));
		}


		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFuncionarioPlanilla','listarFuncionarioPlanillaPorCC');
		} else{
			$this->objFunc=$this->create('MODFuncionarioPlanilla');

			$this->res=$this->objFunc->listarFuncionarioPlanillaPorCC($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   //#61
   function sincBancosAfp(){
		$this->objFunc=$this->create('MODFuncionarioPlanilla');
		$this->res=$this->objFunc->sincBancosAfp($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
   }

   //#129
   function sincColumnas(){
        $this->objFunc=$this->create('MODFuncionarioPlanilla');
        $this->res=$this->objFunc->sincColumnas($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
   }


}

?>