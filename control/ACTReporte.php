<?php
/**
 *@package pXP
 *@file gen-ACTReporte.php
 *@author  (admin)
 *@date 17-01-2014 22:07:28
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 * 
 ISSUE			AUTHOR			FECHA				DESCRIPCION	  					
 * #40 			MZM			16/09/2019	        	Modificacion a formato de cabecera en reporte totales multicel	
   #56			MZM			02.10.2019				Reporte Resumen Relacion de saldos
 * */
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
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenericaMultiCellTotales.php');


require_once(dirname(__FILE__).'/../reportes/RAntiguedadFuncionarioPDF.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaEmpleado.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenericaTrib.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaAportes.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaPersonal.php');
require_once(dirname(__FILE__).'/../reportes/REmpleadoDep.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaCurvaXls.php');


require_once(dirname(__FILE__).'/../reportes/RRelacionSaldos.php'); //#56
require_once(dirname(__FILE__).'/../reportes/RRelacionSaldosDet.php'); //#56

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
		
		//if($this->objParam->getParametro('totales')=='si'){
			$this->objFunc=$this->create('MODReporte');
			$this->res3=$this->objFunc->listarFirmasReporte($this->objParam);//#39 
		//}
		
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
            	if($this->objParam->getParametro('totales')=='si'){
            		$this->objReporteFormato=new RPlanillaGenericaMultiCellTotales($this->objParam);
            	}else{$this->objReporteFormato=new RPlanillaGenericaMultiCell2($this->objParam);}
            	
            }else{// echo "NOOO es multilinea"; exit;
            	$this->objReporteFormato=new RPlanillaGenerica($this->objParam);
            }
			
			//if($this->objParam->getParametro('totales')=='si'){
				$this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos, $this->res3->datos);//#40
			//}else{
				//$this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos, $this->res3->datos);
		//	}
			
            
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

        if ($this->objParam->getParametro('id_funcionario_planilla') != '') {
          $this->objParam->addFiltro("fp.id_funcionario_planilla = ". $this->objParam->getParametro('id_funcionario_planilla'));
        }
        
		if ($this->objParam->getParametro('tipo_reporte') != '') {
          $this->objParam->addFiltro("repo.tipo_reporte = ''". $this->objParam->getParametro('tipo_reporte')."''");
        }
        
        //////03.09.2019*********************

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
        
        
		$filtro_previo=$this->objParam->parametros_consulta['filtro']; 
		$this->objFunc=$this->create('MODReporte'); 
		if($this->res->datos[0]['multilinea']=='si'){
			$i=0;	
			 $this->res2=$this->objFunc->listarReporteDetalle($this->objParam);
			 $this->objReporteFormato->datosHeader($this->res->datos[$i], $this->res2->datos);
             $this->objReporteFormato->generarReporte();
		}else{
			for ($i = 0; $i < count($this->res->datos); $i++){  
			    $this->res2=$this->objFunc->listarReporteDetalleBoleta($this->objParam);
				$this->objReporteFormato->datosHeader($this->res->datos[$i], $this->res2->datos);
                $this->objReporteFormato->generarReporte();
			}	
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

        
            if ($this->objParam->getParametro('id_tipo_planilla') != '') {
                $this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
            }

            if ($this->objParam->getParametro('id_gestion') != '') {
                $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
            }

            if ($this->objParam->getParametro('id_periodo') != '') {
                $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
            }
			
			///////**********
			if ($this->objParam->getParametro('id_funcionario_planilla') != '') {
                $this->objParam->addFiltro("fp.id_funcionario_planilla= ". $this->objParam->getParametro('id_funcionario_planilla'));
            }
		
		//**********
		if ($this->objParam->getParametro('tipo_reporte') == 'formato_especifico') {
			$this->listarFuncionarioReporte();
		}else{
			
		
		//^*********
		
			
			if ($this->objParam->getParametro('tipo_reporte') == 'planilla') {
	            $this->reportePlanilla($this->objParam->getParametro('id_reporte'), $this->objParam->getParametro('formato_reporte'));
	        } else {
	            $this->reporteBoleta();
	        }
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


//********************
function listarFuncionarioReporte(){//#56

	//echo $this->objParam->getParametro('tipo_reporte').'*****'.$this->objParam->getParametro('control_reporte'); exit;
       
        
		
        //obtener titulo del reporte
        $titulo = $this->objParam->getParametro('control_reporte');
		$fecha=$this->objParam->getParametro('fecha');
		$rango_ini=$this->objParam->getParametro('rango_inicio');
		$rango_fin=$this->objParam->getParametro('rango_fin');
		$id_afp=$this->objParam->getParametro('id_afp');
		$id_gestion=$this->objParam->getParametro('id_gestion');
		//03.09.2019
		$id_tipo_contrato=$this->objParam->getParametro('id_tipo_contrato');
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);


        //obtener tamaño y orientacion
       
        $tamano = 'LETTER';
        $orientacion = 'P';
       if($this->objParam->getParametro('control_reporte')=='aporte_afp'){
       	$orientacion = 'L';
       } 

        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('rango_ini',$rango_ini);
		$this->objParam->addParametro('rango_fin',$rango_fin);
		//para aportes
		$this->objParam->addParametro('id_afp',$id_afp);
		$this->objParam->addParametro('id_gestion',$id_gestion);
		$this->objParam->addParametro('tipo_reporte',$this->objParam->getParametro('control_reporte'));//****
		$this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);
		
       
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		$this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res=$this->objFunc->listarFuncionarioReporte($this->objParam);
		
            //Instancia la clase de pdf
       
        if($this->objParam->getParametro('control_reporte')=='empleado_antiguedad' ||  $this->objParam->getParametro('control_reporte')=='empleado_edad' ){   
            $this->objReporteFormato=new RAntiguedadFuncionarioPDF($this->objParam);

			$this->objReporteFormato->setDatos($this->res->datos);
			$this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
 
			$this->mensajeExito=new Mensaje();
        	$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
	        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
	        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	


		}
		else{
			if($this->objParam->getParametro('control_reporte')=='planilla_tributaria' ){
				$this->reportePlanillaTrib($titulo,$fecha); //nomina salarios BC, CT
				   
			}else{
				if($this->objParam->getParametro('control_reporte')=='aporte_afp' || $this->objParam->getParametro('control_reporte')=='fondo_solidario' ){ 
					$this->reportePlanillaAFP($titulo,$fecha,$id_afp,$id_tipo_contrato ); //nomina salarios BC, CT
				}else{
					if($this->objParam->getParametro('control_reporte')=='personal_ret' || $this->objParam->getParametro('control_reporte')=='personal_inc' ){
						$this->reportePlanillaPersonal($titulo,$id_gestion); //nomina salarios BC, CT
					}else{
						if($this->objParam->getParametro('control_reporte')=='planilla_tributaria'){
							$this->reportePlanillaTrib($titulo,$fecha);
						}else{
							if($this->objParam->getParametro('control_reporte')=='dependientes' || $this->objParam->getParametro('control_reporte')=='dependientes_edad' ){
								$this->reportePlanillaDep($titulo,$fecha);
							}else{
								if($this->objParam->getParametro('control_reporte')=='curva_salarial'  ){
									$this->reporteCurvaSalarial($titulo,$fecha);
								}else{ 
									if($this->objParam->getParametro('control_reporte')=='relacion_saldos'  ){//#56
											$this->reporteBancos($titulo,$fecha);
									}else{
										if($this->objParam->getParametro('control_reporte')=='relacion_saldos_det'  ){//#56
											$this->reporteBancosDet($titulo,$fecha);
										}else{
											$this->reportePlanillaFun($titulo,$fecha,$id_tipo_contrato); //nomina salarios BC, CT
										}
										
									
									
									}
								}
								
								
							}
							
							
						}
					} 
					
				}
				 
			}
		}
			
	}
	
	//#56
	function reportePlanillaFun($tipo_reporte,$fecha,$id_tipo_contrato)	{

       

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);

        
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			 $this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosReporteDetalle($this->objParam);
        
            
           	$this->objReporteFormato=new RPlanillaEmpleado($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
	
	
	function reportePlanillaAFP($tipo_reporte,$fecha,$id_afp,$id_tipo_contrato)	{

         

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$this->objParam->addParametro('id_afp',$id_afp);
        $this->objParam->addParametro('orientacion','L');
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            
			$this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosAportes($this->objParam);
       
           	$this->objReporteFormato=new RPlanillaAportes($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
	
	
	
	function reportePlanillaPersonal($tipo_reporte,$id_gestion)	{

         

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$this->objParam->addParametro('id_gestion',$id_gestion);
        $this->objParam->addParametro('orientacion','L');
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            
			$this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosPersonal($this->objParam);
       
           	$this->objReporteFormato=new RPlanillaPersonal($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
	
	function reportePlanillaTrib($tipo_reporte,$fecha)	{
		
	    $this->objParam->addFiltro("(repo.titulo_reporte ilike ''%tributaria%''
		)
		
		and plani.id_periodo =(select po_id_periodo from param.f_get_periodo_gestion(''".$fecha."''))
		
		");
 		
        $tamano = 'LEGAL';
        $orientacion = 'L';
       

        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            

$this->objFunc=$this->create('MODReporte');
		$this->res=$this->objFunc->listarReporteMaestro($this->objParam);

        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res2=$this->objFunc->listarDatosPlaniTrib($this->objParam);
		
		$titulo = $this->res->datos[0]['titulo_reporte'];
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

		$this->objReporteFormato=new RPlanillaGenericaTrib($this->objParam);

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



function reportePlanillaDep($tipo_reporte,$fecha)	{

        

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);

        
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            
			 $this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosReporteDep($this->objParam);
       
           	$this->objReporteFormato=new REmpleadoDep($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }




		function reporteCurvaSalarial($tipo_reporte,$fecha)	{

	      

        	//Genera el nombre del archivo (aleatorio + titulo)
        	//$nombreArchivo=uniqid(md5(session_id()));

 			//$this->objParam->addParametro('fecha',$fecha);
			//$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			//$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
			//$this->objParam->addParametro('datos',$this->res->datos);
        	//$this->objParam->addParametro('titulo_archivo','titulo');
			//$nombreArchivo.='.xls';
			 /* $this->objFunc=$this->create('MODFuncionarioReporte');
	
	        
	        $this->res=$this->objFunc->listarDatosCurva($this->objParam);
        
            			
            $this->objReporteFormato=new RPlanillaCurvaXls($this->objParam);
			$this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte();*/
			
			
			
			 $titulo ='Curva Salarial';
        //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
			$nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			
            $this->objParam->addParametro('titulo_archivo',$titulo);
            $this->objParam->addParametro('datos',$this->res->datos);
			$this->objParam->addParametro('fecha',$fecha);
			$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
            //Instancia la clase de excel
             $this->objFunc=$this->create('MODFuncionarioReporte');
	
	        
	        $this->res=$this->objFunc->listarDatosCurva($this->objParam);
            $this->objReporteFormato=new RPlanillaCurvaXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte(); 
			

	        $this->mensajeExito=new Mensaje();
	        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
	            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
	        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
	        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }


	function reporteBancos()	{ //#56

        //obtener titulo del reporte
        $titulo = 'RESUMEN - RELACION DE SALDOS';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $this->objParam->addParametro('titulo_archivo',$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		
		
		if ($this->objParam->getParametro('id_tipo_contrato')!= '') { 
            $this->objParam->addFiltro("tc.id_tipo_contrato= ". $this->objParam->getParametro('id_tipo_contrato'));
        }
		
				
		if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

        if ($this->objParam->getParametro('id_periodo') != '') {
            $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
        }
		
		
			//***************
		
        
		
		
		$this->objFunc=$this->create('MODObligacion');

        $this->res=$this->objFunc->listarReporteBancos($this->objParam);
		
        //Instancia la clase de pdf
        $this->objReporteFormato=new RRelacionSaldos($this->objParam);
        
        
		    $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos);
			$this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
 
			$this->mensajeExito=new Mensaje();
        	$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
	        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
	        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	
			
			
		
    }


function reporteBancosDet()	{ //#56

        //obtener titulo del reporte
        $titulo = 'RELACION DE SALDOS';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $this->objParam->addParametro('titulo_archivo',$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		
		
		if ($this->objParam->getParametro('id_tipo_contrato')!= '') { 
            $this->objParam->addFiltro("tc.id_tipo_contrato= ". $this->objParam->getParametro('id_tipo_contrato'));
        }
		
				
		if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

        if ($this->objParam->getParametro('id_periodo') != '') {
            $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
        }
		
		
			//***************
		
        
		
		
		$this->objFunc=$this->create('MODObligacion');

        $this->res=$this->objFunc->listarReporteBancosDet($this->objParam);
		
        //Instancia la clase de pdf
        $this->objReporteFormato=new RRelacionSaldosDet($this->objParam);
        
        
		    $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos);
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