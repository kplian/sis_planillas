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
require_once(dirname(__FILE__).'/../reportes/RPrevisionesPDF.php');
require_once(dirname(__FILE__).'/../reportes/RPrevisionesXLS.php');
require_once(dirname(__FILE__).'/../reportes/RBoletaGenerica.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaActualizadaItemXLS.php');
require_once(dirname(__FILE__).'/../reportes/RGeneralPlanillaXLS.php');
require_once(dirname(__FILE__).'/../reportes/RPresupuestoRetroactivoXls.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenericaMultiCell2.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenericaMultiCellXls.php');
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
            
            if($this->res->datos[0]['multilinea']=='si'){
            	//echo "entra por multilinea	"; exit;
            	$this->objReporteFormato=new RPlanillaGenericaMultiCell2($this->objParam);
            }else{// echo "NOOO es multilinea"; exit;
            	$this->objReporteFormato=new RPlanillaGenerica($this->objParam);
            }
			
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

			if($this->res->datos[0]['multilinea']=='si'){
            	//echo "entra por multilinea	"; exit;
            	$this->objReporteFormato=new RPlanillaGenericaMultiCellXls($this->objParam);
				}else{
            //Instancia la clase de excel
            $this->objReporteFormato=new RPlanillaGenericaXls($this->objParam);
				}
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

        if ($this->objParam->getParametro('id_tipo_planilla') != '') {
            $this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
        }

        if ($this->objParam->getParametro('id_funcionario') != '') {
            $this->objParam->addFiltro("planifun.id_funcionario = ". $this->objParam->getParametro('id_funcionario'));
        }

        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

        if ($this->objParam->getParametro('id_periodo') != '') {
            $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
        }

		//10.06.2019

		if ($this->objParam->getParametro('id_proceso_wf') != '') {
            $this->objParam->addFiltro("plani.id_proceso_wf = ". $this->objParam->getParametro('id_proceso_wf'));
        }
		
		if($id_reporte!=''){
			
			$this->objParam->addFiltro("repo.id_reporte = ". $id_reporte);
		}else{	
			if ($this->objParam->getParametro('id_reporte') != '') {
				$this->objParam->addFiltro("repo.id_reporte = ". $this->objParam->getParametro('id_reporte'));
         
             }
		
			
		}
		
		


        $this->objFunc=$this->create('MODReporte');

        $this->res=$this->objFunc->listarReporteMaestroBoleta($this->objParam);

        //obtener titulo del reporte
        $titulo = $this->res->datos[0]['titulo_reporte'];
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $this->objParam->addParametro('titulo_archivo',$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        //Instancia la clase de pdf
        $this->objReporteFormato=new RBoletaGenerica($this->objParam);

        for ($i = 0; $i < count($this->res->datos); $i++){
            $this->objParam->addParametro('id_funcionario',$this->res->datos[$i]['id_funcionario']);
            $this->objFunc=$this->create('MODReporte');
            $this->res2=$this->objFunc->listarReporteDetalleBoleta($this->objParam);
            $this->objReporteFormato->datosHeader($this->res->datos[$i], $this->res2->datos);
            $this->objReporteFormato->generarReporte();
        }

        $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
    function generarReporteDesdeForm(){
        if ($this->objParam->getParametro('id_depto') != '') {
            $this->objParam->addFiltro("plani.id_depto = ". $this->objParam->getParametro('id_depto'));
        }


        $this->objParam->addFiltro("plani.estado not in (''registro_funcionarios'', ''registro_horas'')"); //plani.estado = ''planilla_finalizada''

        if ($this->objParam->getParametro('tipo_reporte') == 'planilla') {
            if ($this->objParam->getParametro('id_tipo_planilla') != '') {
                $this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
            }

            if ($this->objParam->getParametro('id_gestion') != '') {
                $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
            }

            if ($this->objParam->getParametro('id_periodo') != '') {
                $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
            }
            $this->reportePlanilla($this->objParam->getParametro('id_reporte'), $this->objParam->getParametro('formato_reporte'));
        } else {
            $this->reporteBoleta();
        }
    }

    function listarReportePrevisiones()	{
        if ($this->objParam->getParametro('id_uo') == '') {
            $this->objParam->addParametro('id_uo','-1');
            $this->objParam->addParametro('uo','TODOS');
        }

        if ($this->objParam->getParametro('id_tipo_contrato') == '') {
            $this->objParam->addParametro('id_tipo_contrato','-1');
            $this->objParam->addParametro('tipo_contrato','TODOS');
        }
        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->listarReportePrevisiones($this->objParam);


        //obtener titulo del reporte
        $titulo = 'Previsiones';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);




        if ($this->objParam->getParametro('tipo_reporte') == 'pdf') {
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('orientacion','L');
            $this->objParam->addParametro('tamano','LETTER	');
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
            $this->objReporteFormato=new RPrevisionesPDF($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');

        } else {

            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

            $this->objParam->addParametro('datos',$this->res->datos);

            //Instancia la clase de excel
            $this->objReporteFormato=new RPrevisionesXLS($this->objParam);
            $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte();
        }

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    function ListarReportePlanillaActualizadaItem (){

        if ($this->objParam->getParametro('id_tipo_contrato') == '') {
            $this->objParam->addParametro('id_tipo_contrato','-1');
            $this->objParam->addParametro('tipo_contrato','TODOS');
        }
        if($this->objParam->getParametro ('id_uo') == ''){
            $this->objParam->getParametro ('id_uo','-1');
            $this->objParam->getParametro ('uo','TODOS');
        }

        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->ListarReportePlanillaActualizadaItem ($this->objParam);
        //obtener titulo de reporte
        $titulo ='Planilla actualizada Item';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        if ($this->objParam->getParametro('agrupar_por') == 'Organigrama'){
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('datos',$this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato=new RPlanillaActualizadaItemXLS($this->objParam);
            $this->objReporteFormato->generarDatos('Organigrama');
            $this->objReporteFormato->generarReporte();

        }elseif ($this->objParam->getParametro('agrupar_por') == 'Regional'){
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('datos',$this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato=new RPlanillaActualizadaItemXLS($this->objParam);
            $this->objReporteFormato->generarDatos('Regional');
            $this->objReporteFormato->generarReporte();

        }elseif($this->objParam->getParametro('agrupar_por') == 'Regional oficina'){
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('datos',$this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato=new RPlanillaActualizadaItemXLS($this->objParam);
            $this->objReporteFormato->generarDatos('Regional oficina');
            $this->objReporteFormato->generarReporte();
        }


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    function reporteGeneralPlanilla(){

        $this->objFunc=$this->create('MODReporte');
        if($this->objParam->getParametro('configuracion_reporte') == 'contacto'){
            $this->res=$this->objFunc->reporteGeneralPlanilla($this->objParam);
            $titulo_archivo = 'Empleados con Datos de Contato';
        }else if($this->objParam->getParametro('configuracion_reporte') == 'programatica'){
            $this->res=$this->objFunc->reportePresupuestoCatProg($this->objParam);
            $titulo_archivo = 'Prespuesto Retroactivo';
        }


        $this->datos=$this->res->getDatos();

        $nombreArchivo = uniqid(md5(session_id()).$titulo_archivo).'.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $this->objParam->addParametro('titulo_archivo',$titulo_archivo);
        $this->objParam->addParametro('datos',$this->datos);

        if($this->objParam->getParametro('configuracion_reporte') == 'contacto'){
            $this->objReporte = new RGeneralPlanillaXls($this->objParam);
        }else if($this->objParam->getParametro('configuracion_reporte') == 'programatica'){
            $this->objReporte = new RPresupuestoRetroactivoXls($this->objParam);
        }

        $this->objReporte->generarReporte();


        $mensajeExito = new Mensaje();
        $mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->res = $mensajeExito;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

	/*******/
	function reportePlanillaMultiCell($id_reporte,$tipo_reporte)	{

        if ($this->objParam->getParametro('id_proceso_wf') != '') {
            $this->objParam->addFiltro("plani.id_proceso_wf = ". $this->objParam->getParametro('id_proceso_wf'));
        }
		$this->objParam->addFiltro("repo.id_reporte = ". $id_reporte);
		
       

        $this->objFunc=$this->create('MODReporte');

        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);


        $this->objFunc=$this->create('MODReporte');
        $this->res2=$this->objFunc->listarReporteDetalleMultiCell($this->objParam);
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
            
            $this->objReporteFormato=new RPlanillaGenericaMultiCell2($this->objParam);
            
            $this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos);
            //$this->objReporteFormato->renderDatos($this->res2->datos);
            $this->objReporteFormato->gerencia = $this->res2->datos[0]['gerencia'];
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        } else {
			//echo "****"; exit;
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('config',$this->res->datos[0]);
            $this->objParam->addParametro('datos',$this->res2->datos);


            //Instancia la clase de excel
            $this->objReporteFormato=new RPlanillaGenericaMultiCellXls($this->objParam);
            $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte();
        }





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }



}

?>