<?php
/**
 *@package pXP
 *@file gen-ACTReporte.php
 *@author  (admin)
 *@date 17-01-2014 22:07:28
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 *
 ISSUE            AUTHOR            FECHA                DESCRIPCION
 * #40            MZM            16/09/2019                Modificacion a formato de cabecera en reporte totales multicel
   #56            MZM            02.10.2019                Reporte Resumen Relacion de saldos
 * #66            MZM            15.10.2019                Adicion de filtro id_tipo_contrato en reportes especificos
 * #67            MZM            16.10.2019                Reporte asignacion de cargos
 * #71            MZM            08.11.2019                Refactorizacion para reportes de planillas anuales
 * #72            MZM            04.11.2019                Cambio en el orden de defnicion de variable nombre_arhivo para reporte
 * #77            MZM            15.11.2019                Ajuste reportes
 * #80            MZM            22.11.2019                Reporte para bono/descuento
 * #83            MZM            09.12.2019                Habilitacion de Reporte para backup de planillas
 * #87            MZM            09.01.2020                Reporte detalle de aguinaldos
 * #99            MZM            03.03.2020                Adicion de filtro sesion de funcionario
* #103            RAC KPLIAN     02/04/2020                envio de boletas de pago
 * #98			  MZM KPLIAN	 03.04.2020  				Adicion de opciones estado_funcionario (activo, retirado, todos)
 * #115			  MZM KPLIAN     20.04.2020					REporte listado por centros
 * #119			  MZM KPLIAN	 23.04.2020					Reporte Listado de saldos Rc-Iva acumulado
 * #123	ETR		  MZM-KPLIAN	 06.05.2020					Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019)
 * #131 ETR       RAC KPLIAN     02.06.2020                 Marcar planillas donde ya fueron despachados los correos de boletas de pago
 * #133 ETR       MZM KPLIAN     03.06.2020                 Reporte para prevision de primas
 * #135	ETR		  MZM KPLIAN	 04.06.2020					Reporte de prevision de primas (detalle)
 * #144	ETR		  MZM KPLIAN	 29.06.2020					Reporte ingresos/egresos por funcionario
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
require_once(dirname(__FILE__).'/../reportes/RPlanillaAsignacionCargos.php'); //#67
require_once(dirname(__FILE__).'/../reportes/RPlanillaEmpleadoXls.php'); //#77
require_once(dirname(__FILE__).'/../reportes/RPlanillaAportesXls.php');//#77
require_once(dirname(__FILE__).'/../reportes/RPlanillaAsignacionCargosXls.php');//#77
require_once(dirname(__FILE__).'/../reportes/RPlanillaPersonalXls.php');//#77
require_once(dirname(__FILE__).'/../reportes/RAntiguedadFuncionarioXls.php');//#77
require_once(dirname(__FILE__).'/../reportes/RRelacionSaldosXls.php'); //#77
require_once(dirname(__FILE__).'/../reportes/RRelacionSaldosDetXls.php'); //#77
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenericaTribXls.php');
require_once(dirname(__FILE__).'/../reportes/RDetalleAguinaldo.php');//#87
require_once(dirname(__FILE__).'/../reportes/RPlanillaSaldoIva.php');//#119
require_once(dirname(__FILE__).'/../reportes/RPlanillaPrima.php');//#125
require_once(dirname(__FILE__).'/../reportes/RPlanillaPrimaXls.php');//#125


//·103   para envio de bolestas por correo eletronico
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.phpmailer.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.smtp.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');

require_once(dirname(__FILE__).'/../reportes/RPlanillaPrevisionPrima.php');//#135

require_once(dirname(__FILE__).'/../reportes/RPlanillaIngresoEgreso.php');//#144

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

    function reportePlanilla($id_reporte,$tipo_reporte,$esquema)    {//#83

        if ($this->objParam->getParametro('id_proceso_wf') != '') {
            $this->objParam->addFiltro("plani.id_proceso_wf = ". $this->objParam->getParametro('id_proceso_wf'));
        }

        $this->objParam->addFiltro("repo.id_reporte = ". $id_reporte);

        $this->objParam->addParametro('esquema',$esquema);//#83

        $this->objFunc=$this->create('MODReporte');

        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);


        $this->objFunc=$this->create('MODReporte');
        $this->res2=$this->objFunc->listarReporteDetalle($this->objParam);


        $this->objFunc=$this->create('MODReporte');
        $this->res3=$this->objFunc->listarFirmasReporte($this->objParam);//#39


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
                //echo "entra por multilinea    "; exit;
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
        //    }


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
                //echo "entra por multilinea    "; exit;
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

    function reporteBoleta()    {

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

        //#98
        if ($this->objParam->getParametro('consolidar')=='no' || $this->objParam->getParametro('consolidar')==''){

            if ($this->objParam->getParametro('id_periodo') != '') {
                $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
            }
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

        //#83
        $this->objParam->addParametro('esquema',$this->objParam->getParametro('esquema')?$this->objParam->getParametro('esquema'):'plani');
        if ($this->objParam->getParametro('id_tipo_contrato') != '') {
            $this->objParam->addFiltro("plani.id_tipo_contrato = ". $this->objParam->getParametro('id_tipo_contrato'));
        }


        //#99
        if ($this->objParam->getParametro('origen') == 'boleta_personal') {
            //echo "llega aqui".$_SESSION["ss_id_funcionario"]; exit;
            //var_dump($_SESSION['ss_id_funcionario']); exit;
            $this->objParam->addFiltro("fp.id_funcionario = ". $_SESSION['ss_id_funcionario']. " and repo.tipo_reporte= ''boleta'' ");
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
        if($this->res->datos[0]['multilinea']=='si' || $this->res->datos[0]['id_periodo']==''){
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


        $this->objParam->addFiltro("plani.estado not in (''registro_funcionarios'', ''registro_horas'')
        and plani.observaciones not in (''ocultar'')
        "); //plani.estado = ''planilla_finalizada''  //#123

        //#83
        if($this->objParam->getParametro('tipo_reporte') == 'formato_especifico' && $this->objParam->getParametro('control_reporte')=='fondo_solidario'){
        }else{
            if ($this->objParam->getParametro('id_tipo_planilla') != '') {
                $this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
            }
        }



            if ($this->objParam->getParametro('id_gestion') != '') {
                $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
            }

                       //#98
            if ($this->objParam->getParametro('consolidar')=='no'){
                if ($this->objParam->getParametro('id_periodo') != '') {
                    $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
                }

            }

            ///////**********
            if ($this->objParam->getParametro('id_funcionario_planilla') != '') {
                $this->objParam->addFiltro("fp.id_funcionario_planilla= ". $this->objParam->getParametro('id_funcionario_planilla'));
            }

            //#83
            if ($this->objParam->getParametro('id_planillabk') != '') {
                $this->objParam->addFiltro("plani.id_planilla= ". $this->objParam->getParametro('id_planillabk'));

            }

        //**********
        if ($this->objParam->getParametro('tipo_reporte') == 'formato_especifico') {

			if($this->objParam->getParametro('control_reporte')=='planilla_prima'|| $this->objParam->getParametro('control_reporte')=='planilla_prevision'  ){ //#135
				$this->reportePlanillaPrima($this->objParam->getParametro('id_reporte'),$this->objParam->getParametro('esquema'));//#83
			}else{
				$this->listarFuncionarioReporte($this->objParam->getParametro('id_reporte'),$this->objParam->getParametro('esquema'));//#83
			}


        }else{
            if ($this->objParam->getParametro('tipo_reporte') == 'bono_descuento') {//#80
                $this->reporteBonoDesc($this->objParam->getParametro('id_reporte'), $this->objParam->getParametro('formato_reporte'));
            }else{

                if ($this->objParam->getParametro('tipo_reporte') == 'planilla') {
                    $this->reportePlanilla($this->objParam->getParametro('id_reporte'), $this->objParam->getParametro('formato_reporte'),$this->objParam->getParametro('esquema'));//#83
                } else {
                    $this->reporteBoleta();
                }
            }

        }
    }

    function listarReportePrevisiones()    {
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
            $this->objParam->addParametro('tamano','LETTER    ');
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
    function reportePlanillaMultiCell($id_reporte,$tipo_reporte)    {

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
function listarFuncionarioReporte($id_reporte,$esquema){//#56 #83


        //obtener titulo del reporte
        $titulo = $this->objParam->getParametro('control_reporte');
        $fecha=$this->objParam->getParametro('fecha');
        $rango_ini=$this->objParam->getParametro('rango_inicio');
        $rango_fin=$this->objParam->getParametro('rango_fin');
        $id_afp=$this->objParam->getParametro('id_afp');
        $id_gestion=$this->objParam->getParametro('id_gestion');
        //03.09.2019
        $id_tipo_contrato=$this->objParam->getParametro('id_tipo_contrato');

        //#77
        $id_periodo=$this->objParam->getParametro('id_periodo');
        $formato_reporte=$this->objParam->getParametro('formato_reporte');


        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);


        //obtener tamaño y orientacion
        if($this->objParam->getParametro('codigo_planilla')=='PLANRE'){//#83
            $tamano = 'LEGAL';
        }else{
            $tamano = 'LETTER';
        }

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

        //#83
		if( $this->objParam->getParametro('control_reporte')=='fondo_solidario' ||  $this->objParam->getParametro('control_reporte')=='aporte_afp'  || $this->objParam->getParametro('control_reporte')=='saldo_fisco' ){
        }else{
        	$this->objParam->addFiltro("repo.id_reporte = ". $id_reporte); //#83
		}


        $this->objParam->addParametro('tipo_reporte',$this->objParam->getParametro('control_reporte'));//****
        $this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);
        $this->objParam->addParametro('id_reporte',$id_reporte);
       //#77
        $this->objParam->addParametro('id_periodo',$id_periodo);
        $this->objParam->addParametro('esquema',$esquema);//#83
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);


        //#77
        $this->objFunc=$this->create('MODReporte');
        $this->resM=$this->objFunc->listarReporteMaestro($this->objParam);

        $titulo_para_reporte=$this->resM->datos[0]['titulo_reporte'];
        $borde_para_reporte=$this->resM->datos[0]['bordes'];
        $interlineado_para_reporte=$this->resM->datos[0]['interlineado'];


        $this->objParam->addParametro('titulo_para_reporte',$titulo_para_reporte);
        $this->objParam->addParametro('borde_para_reporte',$borde_para_reporte);
        $this->objParam->addParametro('interlineado_para_reporte',$interlineado_para_reporte);

        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res=$this->objFunc->listarFuncionarioReporte($this->objParam);

            //Instancia la clase de pdf

        if($this->objParam->getParametro('control_reporte')=='empleado_antiguedad' ||  $this->objParam->getParametro('control_reporte')=='empleado_edad' ){
            if($this->objParam->getParametro('formato_reporte')=='pdf'){
                $nombreArchivo.='.pdf';
                $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

                $this->objReporteFormato=new RAntiguedadFuncionarioPDF($this->objParam);

                $this->objReporteFormato->setDatos($this->res->datos, $this->resM->datos);//#80
                $this->objReporteFormato->generarReporte();
                $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
            }else{
                //$titulo ='Reserva';
                //Genera el nombre del archivo (aleatorio + titulo)
                $nombreArchivo=uniqid(md5(session_id()).$titulo);
                $nombreArchivo.='.xls';
                $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                $this->objReporteFormato=new RAntiguedadFuncionarioXls($this->objParam);
               // $this->objReporteFormato->imprimeDatos();
                $this->objReporteFormato->generarReporte($this->res->datos, $this->resM->datos);//#83
            }


            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());


        }
        else{
            if($this->objParam->getParametro('control_reporte')=='planilla_tributaria' ){

                $this->reportePlanillaTrib($titulo,$id_periodo); //#77

            }else{
                if($this->objParam->getParametro('control_reporte')=='aporte_afp' || $this->objParam->getParametro('control_reporte')=='fondo_solidario' ){
                    $this->reportePlanillaAFP($titulo,$fecha,$id_afp,$id_tipo_contrato,$id_periodo ); //nomina salarios BC, CT //#77
                }else{
                    if($this->objParam->getParametro('control_reporte')=='personal_ret' || $this->objParam->getParametro('control_reporte')=='personal_inc' ){
                        $this->reportePlanillaPersonal($titulo,$id_gestion); //nomina salarios BC, CT
                    }else{
                        if($this->objParam->getParametro('control_reporte')=='planilla_tributaria'){
                            $this->reportePlanillaTrib($titulo,$id_periodo); //#77
                        }else{
                            if($this->objParam->getParametro('control_reporte')=='dependientes' || $this->objParam->getParametro('control_reporte')=='dependientes_edad' ){
                                $this->reportePlanillaDep($titulo,$fecha,$id_tipo_contrato);//#66
                            }else{
                                if($this->objParam->getParametro('control_reporte')=='curva_salarial' || $this->objParam->getParametro('control_reporte')=='curva_salarial_centro'   ){
                                    $this->reporteCurvaSalarial($titulo,$fecha,$id_tipo_contrato,$id_periodo,$esquema); //#77 //#83
                                }else{
                                    if($this->objParam->getParametro('control_reporte')=='relacion_saldos'   ){//#56
                                            $this->reporteBancos($titulo,$fecha);
                                    }else{ 
                                        if($this->objParam->getParametro('control_reporte')=='relacion_saldos_det' || $this->objParam->getParametro('control_reporte')=='relacion_saldos_det_ci'  ){//#56
                                            $this->reporteBancosDet($titulo,$fecha);
                                        }else{
                                            if($this->objParam->getParametro('control_reporte')=='asignacion_cargos' ||  $this->objParam->getParametro('control_reporte')=='movimiento_personal' ||  $this->objParam->getParametro('control_reporte')=='frecuencia_cargos' ||  $this->objParam->getParametro('control_reporte')=='lista_cargos' ||  $this->objParam->getParametro('control_reporte')=='profesiones' ||  $this->objParam->getParametro('control_reporte')=='directorio_empleados' ||  $this->objParam->getParametro('control_reporte')=='nacimiento_ano' ||  $this->objParam->getParametro('control_reporte')=='nacimiento_mes' ||  $this->objParam->getParametro('control_reporte')=='frecuencia_profesiones' ||  $this->objParam->getParametro('control_reporte')=='listado_centros'){//#67

                                                $this->reporteAsignacionCargos($titulo,$id_gestion,$id_tipo_contrato);
                                            }else{
                                                if($this->objParam->getParametro('control_reporte')=='detalle_bono_desc'){
                                                    $this->reporteDetalleBonoDesc($titulo,$id_tipo_contrato,$id_reporte);
                                                }else{
                                                     if($this->objParam->getParametro('control_reporte')=='detalle_aguinaldo'){
                                                        $this->reporteDetalleAguinaldo($titulo,$fecha,$id_tipo_contrato,$id_gestion,$esquema);
                                                     }else{
                                                     	if($this->objParam->getParametro('control_reporte')=='saldo_fisco' ){

                        									$this->reporteSaldoAcumuladoRcIva($titulo,$id_periodo, $id_tipo_contrato, $esquema); //saldo_fisco
														}elseif ($this->objParam->getParametro('control_reporte')=='relacion_saldos_prevision')
														
															$this->reporteBancosPrev($titulo,$fecha);
														elseif ($this->objParam->getParametro('control_reporte')=='ingreso_egreso')
															$this->reporteIngresoEgreso($id_tipo_contrato,$id_periodo); //ingreso-egreso
														else
                                                         	$this->reportePlanillaFun($titulo,$fecha,$id_tipo_contrato,$id_periodo); //nomina salarios BC, CT //#77
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

            }
        }

    }

    //#56
    function reportePlanillaFun($tipo_reporte,$fecha,$id_tipo_contrato,$id_periodo)    {//#77

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

         $this->objParam->addParametro('fecha',$fecha);
        $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
        $this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);

        $this->objParam->addParametro('id_periodo',$id_periodo);//#77

        $this->objFunc=$this->create('MODReporte');
        $this->resM=$this->objFunc->listarReporteMaestro($this->objParam);

        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res=$this->objFunc->listarDatosReporteDetalle($this->objParam);


        if($this->objParam->getParametro('formato_reporte')=='pdf'){
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaEmpleado($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos,$this->resM->datos);//#83
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        } else{
            $titulo ='Reserva';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaEmpleadoXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos,$this->resM->datos);//#83


        }


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }


    function reportePlanillaAFP($tipo_reporte,$fecha,$id_afp,$id_tipo_contrato,$id_periodo)    { //#77



        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

         $this->objParam->addParametro('fecha',$fecha);
        $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
        $this->objParam->addParametro('id_afp',$id_afp);
        $this->objParam->addParametro('id_periodo',$id_periodo);//#77
        $this->objParam->addParametro('orientacion','L');


        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res=$this->objFunc->listarDatosAportes($this->objParam);

        if($this->objParam->getParametro('formato_reporte')=='pdf'){
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
               $this->objReporteFormato=new RPlanillaAportes($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');

        }else{
            $titulo ='AporteAFP';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaAportesXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos);
        }




        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }



    function reportePlanillaPersonal($tipo_reporte,$id_gestion)    {



        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));


        $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
        $this->objParam->addParametro('id_gestion',$id_gestion);
        $this->objParam->addParametro('orientacion','L');

            $this->objFunc=$this->create('MODFuncionarioReporte');


        $this->res=$this->objFunc->listarDatosPersonal($this->objParam);

       if($this->objParam->getParametro('formato_reporte')=='pdf'){//#77
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

               $this->objReporteFormato=new RPlanillaPersonal($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');

       }else{
               $titulo ='Personal';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaPersonalXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos);
       }




        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    function reportePlanillaTrib($tipo_reporte,$id_periodo)    {

        $this->objParam->addFiltro("(repo.titulo_reporte ilike ''%tributaria%''
        )

        and plani.id_periodo =".$id_periodo." ");
         //(select po_id_periodo from param.f_get_periodo_gestion(''".$fecha."''))
        $tamano = 'LEGAL';
        $orientacion = 'L';


        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('id_periodo',$id_periodo);
        $this->objParam->addParametro('tipo_reporte',$tipo_reporte);



        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);

        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res2=$this->objFunc->listarDatosPlaniTrib($this->objParam);

        $titulo = $this->res->datos[0]['titulo_reporte'];
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        if($this->objParam->getParametro('formato_reporte')=='pdf'){//#77
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);


            $this->objReporteFormato=new RPlanillaGenericaTrib($this->objParam);

            $this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos);
                //$this->objReporteFormato->renderDatos($this->res2->datos);
            $this->objReporteFormato->gerencia = $this->res2->datos[0]['gerencia'];
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        }else{
            $titulo ='Planilla Tributaria';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaGenericaTribXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos[0], $this->res2->datos);

        }



        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }



function reportePlanillaDep($tipo_reporte,$fecha,$id_tipo_contrato)    {



        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

         $this->objParam->addParametro('fecha',$fecha);
        $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
        $this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);

            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $this->objFunc=$this->create('MODReporte');
        $this->res1=$this->objFunc->listarReporteMaestro($this->objParam);

             $this->objFunc=$this->create('MODFuncionarioReporte');


        $this->res=$this->objFunc->listarDatosReporteDep($this->objParam);

               $this->objReporteFormato=new REmpleadoDep($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');






        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }




        function reporteCurvaSalarial($tipo_reporte,$fecha,$id_tipo_contrato,$id_periodo,$esquema)    {//#77 #83


            $titulo ='Curva Salarial';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

            $this->objParam->addParametro('titulo_archivo',$titulo);
            $this->objParam->addParametro('datos',$this->res->datos);
            $this->objParam->addParametro('fecha',$fecha);
            $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
            $this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);
            $this->objParam->addParametro('id_periodo',$id_periodo); //#77
            $this->objParam->addParametro('esquema',$esquema); //#83
            //Instancia la clase de excel
            $this->objFunc=$this->create('MODFuncionarioReporte');

            $this->res=$this->objFunc->listarDatosCurva($this->objParam);
            $this->objReporteFormato=new RPlanillaCurvaXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos);


            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }


    function reporteBancos()    { //#56

        //obtener titulo del reporte
        $titulo = 'RESUMEN - RELACION DE SALDOS';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $this->objParam->addParametro('titulo_archivo',$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);


        //#71
        /*if ($this->objParam->getParametro('id_tipo_contrato')!= '') {
            $this->objParam->addFiltro("plani.id_tipo_contrato= ". $this->objParam->getParametro('id_tipo_contrato'));
        }*/


        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

        		//#98
		if ($this->objParam->getParametro('consolidar')=='no' || $this->objParam->getParametro('consolidar')==''){

	        if ($this->objParam->getParametro('id_periodo') != '') {
	            $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
	        }
		}



        if ($this->objParam->getParametro('id_reporte') != '') {
            $this->objParam->addFiltro("repo.id_reporte = ". $this->objParam->getParametro('id_reporte'));
        }

        //#56 - 10.10.2019
        if ($this->objParam->getParametro('control_reporte') != '') {
            $this->objParam->addFiltro("repo.control_reporte = ''". $this->objParam->getParametro('control_reporte')."''");
        }

        if ($this->objParam->getParametro('id_obligacion') != '') {
            $this->objParam->addFiltro("plani.id_planilla = (select o.id_planilla from plani.tobligacion o
            inner join plani.ttipo_obligacion tipobl on tipobl.id_tipo_obligacion=o.id_tipo_obligacion

            where id_obligacion=". $this->objParam->getParametro('id_obligacion').")");
        }
        //fin #56


        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);



        $this->objFunc=$this->create('MODObligacion');

        $this->res1=$this->objFunc->listarReporteBancos($this->objParam);


        //#71
        $this->objFunc=$this->create('MODReporte');
        $this->res3=$this->objFunc->listarFirmasReporte($this->objParam);

		//#127
		if($this->objParam->getParametro('codigo_planilla')=='BONOVIG'){//#127
            $this->objParam->addParametro('orientacion','L');}
        else{
            $this->objParam->addParametro('orientacion','P');
        }

        if($this->objParam->getParametro('formato_reporte')=='pdf'){//#77
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
            $this->objReporteFormato=new RRelacionSaldos($this->objParam);

            $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos,$this->res3->datos);
           // $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        }else{
            $titulo ='Personal';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RRelacionSaldosXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos,$this->res1->datos);
        }

            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());



    }


function reporteBancosDet()    { //#56
//echo "reporteBancosDet"; exit;
        //obtener titulo del reporte
        $titulo = 'RELACION DE SALDOS';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $this->objParam->addParametro('titulo_archivo',$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);


        //#71
        /*if ($this->objParam->getParametro('id_tipo_contrato')!= '') {
            $this->objParam->addFiltro("plani.id_tipo_contrato= ". $this->objParam->getParametro('id_tipo_contrato'));
        }*/


        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

        		//#98
		if ($this->objParam->getParametro('consolidar')=='no' || $this->objParam->getParametro('consolidar')==''){

	        if ($this->objParam->getParametro('id_periodo') != '') {
	            $this->objParam->addFiltro("plani.id_periodo = ". $this->objParam->getParametro('id_periodo'));
	        }
		}



            //***************
        if ($this->objParam->getParametro('id_reporte') != '') {
            $this->objParam->addFiltro("repo.id_reporte = ". $this->objParam->getParametro('id_reporte'));
        }else{
            $this->objParam->addFiltro("repo.control_reporte = ". $this->objParam->getParametro('control_reporte'));
        }


        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);



        $this->objFunc=$this->create('MODObligacion');

        $this->res1=$this->objFunc->listarReporteBancosDet($this->objParam);
        if($this->objParam->getParametro('formato_reporte')=='pdf'){//#77
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
            $this->objReporteFormato=new RRelacionSaldosDet($this->objParam);


            $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        }else{
            $titulo ='Personal';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RRelacionSaldosDetXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos,$this->res1->datos);
        }
            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());



    }
//#67

    function reporteAsignacionCargos($tipo_reporte,$id_gestion,$id_tipo_contrato)    {


        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));
        //#77
         if($this->objParam->getParametro('control_reporte')=='frecuencia_cargos' || $this->objParam->getParametro('control_reporte')=='lista_cargos' || $this->objParam->getParametro('control_reporte')=='profesiones' || $this->objParam->getParametro('control_reporte')=='nacimiento_ano' || $this->objParam->getParametro('control_reporte')=='nacimiento_mes' || $this->objParam->getParametro('control_reporte')=='frecuencia_profesiones' || $this->objParam->getParametro('control_reporte')=='listado_centros'){//#115
            $this->objParam->addParametro('orientacion','P');}
        else{
            $this->objParam->addParametro('orientacion','L');
        }
        $this->objParam->addParametro('tamano',$this->objParam->getParametro('tamano'));
        $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
        $this->objParam->addParametro('id_gestion',$id_gestion);
        $this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);

        //

        $this->objParam->addParametro('id_periodo',$this->objParam->getParametro('id_periodo'));
         //#83
        $this->objFunc=$this->create('MODReporte');
        $this->resM=$this->objFunc->listarReporteMaestro($this->objParam);

        $this->objFunc=$this->create('MODFuncionarioReporte');


        if($this->objParam->getParametro('control_reporte')=='frecuencia_cargos'){

            $this->res=$this->objFunc->listarFrecuenciaCargos($this->objParam);
        }else{
            if($this->objParam->getParametro('control_reporte')=='lista_cargos'){
                $this->res=$this->objFunc->listarCargosRep($this->objParam);
            }else{
                if($this->objParam->getParametro('control_reporte')=='profesiones'){
                    $this->res=$this->objFunc->listarProfesiones($this->objParam);
                }else{
                    if($this->objParam->getParametro('control_reporte')=='directorio_empleados' || $this->objParam->getParametro('control_reporte')=='nacimiento_ano' || $this->objParam->getParametro('control_reporte')=='nacimiento_mes'  || $this->objParam->getParametro('control_reporte')=='listado_centros'){//#115

                        $this->res=$this->objFunc->listarDirectorioEmpleados($this->objParam);
                    }
                    elseif($this->objParam->getParametro('control_reporte')=='frecuencia_profesiones'){//#77

                        $this->res=$this->objFunc->listarFrecuenciaProfesiones($this->objParam);
                    }
                    else{
                        $this->res=$this->objFunc->listarRepAsignacionCargos($this->objParam);
                    }

                }


            }


        }


        if($this->objParam->getParametro('formato_reporte')=='pdf'){
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

               $this->objReporteFormato=new RPlanillaAsignacionCargos($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos,$this->resM->datos );//#83
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        }else{
            $titulo ='AsignacionCargos';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaAsignacionCargosXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos,$this->resM->datos );//#83

        }





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());




    }


//#80
function reporteBonoDesc($id_reporte,$tipo_reporte)    {



        $this->objParam->addFiltro("repo.id_reporte = ". $id_reporte);

        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);

        if ($this->objParam->getParametro('id_tipo_columna') != '') {
            $this->objParam->addParametro('id_tipo_columna',$this->objParam->getParametro('id_tipo_columna'));
        }

        $this->objFunc=$this->create('MODReporte');
        $this->res2=$this->objFunc->listarReporteDetalle($this->objParam);


        $this->objFunc=$this->create('MODReporte');
        $this->res3=$this->objFunc->listarFirmasReporte($this->objParam);//#39

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
            $this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos, $this->res3->datos);//#40
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        } else {

            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('config',$this->res->datos[0]);
            $this->objParam->addParametro('datos',$this->res2->datos);

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



//#80
function reporteDetalleBonoDesc($tipo_reporte,$id_tipo_contrato,$id_reporte)    {

      //  $this->objParam->addFiltro("repo.id_reporte = ". $id_reporte);

        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);

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

        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res1=$this->objFunc->listarDetalleBonoDesc($this->objParam);

        //if ($tipo_reporte == 'pdf') {
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
            $this->objReporteFormato=new REmpleadoDep($this->objParam);
            $this->objReporteFormato->setDatos($this->res1->datos, $this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        /*} else {

            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('config',$this->res->datos[0]);
            $this->objParam->addParametro('datos',$this->res2->datos);

            $this->objReporteFormato=new RPlanillaGenericaXls($this->objParam);
            $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte();
        }*/


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

//#87
function reporteDetalleAguinaldo($tipo_reporte,$fecha,$id_tipo_contrato,$id_gestion,$esquema)    {


            $titulo ='DetalleAguinaldo';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

            $this->objParam->addParametro('titulo_archivo',$titulo);
            $this->objParam->addParametro('datos',$this->res->datos);
            $this->objParam->addParametro('fecha',$fecha);
            $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
            $this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);
            $this->objParam->addParametro('id_gestion',$id_gestion);
            $this->objParam->addParametro('esquema',$esquema);
            //Instancia la clase de excel
            $this->objFunc=$this->create('MODFuncionarioReporte');

            $this->res=$this->objFunc->listarDetalleAguinaldo($this->objParam);
            $this->objReporteFormato=new RDetalleAguinaldo($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos);


            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }



    function EnviarBoletas(){
        //destinatario
        $email = $this->objParam->getParametro('email');
        $body = $this->objParam->getParametro('body');
        $asunto = $this->objParam->getParametro('asunto');
        $id_tipo_planilla = $this->objParam->getParametro('id_tipo_planilla');
        $id_periodo = $this->objParam->getParametro('id_periodo');
        $id_gestion = $this->objParam->getParametro('id_gestion');

        $this->objFunc = $this->create('MODReporte');
        $res = $this->objFunc->listarFunPlanillaAll($this->objParam);
        $contador = 0;
        $contadorFallas = 0;
        $fallas = '0';   //iniciamos con cero , no existe el id_funcioanrio cero pero facilita la concatenacion

        if($res->getTipo() == 'EXITO') {

                 for ($j = 0; $j < count($res->datos); $j++) {
                      //genera archivo adjunto
                      $file = $this->reporteBoletaCorreo($res->datos[$j]['id_funcionario'],$id_tipo_planilla,$id_gestion,$id_periodo);
                       if($file != 'ERROR') {
                          $correo = new CorreoExterno();
                          $correo->addDestinatario($res->datos[$j]['email_empresa']);
                          $correo->setMensaje($body);
                          $correo->setAsunto($asunto);
                          $correo->addAdjunto($file);
                          $correo->setDefaultPlantilla();
                          $respCorreo=$correo->enviarCorreo(); //envia el correo con la boleta de pago
                          if ($respCorreo == "OK"){
                              $contador ++;
                          } else {
                               $contadorFallas ++;
                               $fallas = $fallas.'|'.$res->datos[$j]['id_funcionario'];
                          }

                      } else {
                          $contadorFallas ++;
                          $fallas = $fallas.'|'.$res->datos[$j]['id_funcionario'];
                      }
                 }
                 //#131 almacenar resulado en base de datos
                 $this->objParam->addParametro('contador',$contador);
                 $this->objParam->addParametro('contador_fallas',$contadorFallas);
                 $this->objParam->addParametro('fallas',$fallas);
                 $this->objFuncPlanilla = $this->create('MODPlanilla');
                 $this->resActPlanilla = $this->objFuncPlanilla->actualizarPlanillaEnvioBoleta($this->objParam);

                 if($this->resActPlanilla->getTipo() == 'EXITO') {
                     if($contador > 0) {
                            $mensajeExito = new Mensaje();
                            $mensajeExito->setMensaje('EXITO','ACTReporte.php','Se mandaron: '.$contador.' correos y fallaron: '.$contadorFallas,
                            'Se mando el correo con exito: OK'.$contadorFallas,'control' );
                            $this->res = $mensajeExito;
                            $this->res->imprimirRespuesta($this->res->generarJson());
                            unlink($file);
                     } else {
                          echo "{\"ROOT\":{\"error\":true,\"detalle\":{\"mensaje\":\" Error al enviar correo (id: $fallos)\"}}}";
                     }
                 } else {
                     $this->resActPlanilla->imprimirRespuesta($this->resActPlanilla->generarJson());
                 }
        } else {
            $res->imprimirRespuesta($res->generarJson());
        }
        exit;
   }

   function reporteBoletaCorreo($id_funcionario,$id_tipo_planilla,$id_gestion,$id_periodo) {

        $this->objParam->parametros_consulta['filtro']=' 0=0 ';//reset filter
        $this->objParam->addFiltro("plani.id_tipo_planilla = ". $id_tipo_planilla);
        $this->objParam->addFiltro("plani.id_gestion = ". $id_gestion);
        $this->objParam->addFiltro("plani.id_periodo = ". $id_periodo);
        $this->objParam->addFiltro("fp.id_funcionario = ". $id_funcionario. " and repo.tipo_reporte= ''boleta'' ");

        $this->objFunc=$this->create('MODReporte');
        $this->res = $this->objFunc->listarReporteMaestroBoleta($this->objParam);

        if($this->res->getTipo()=='EXITO'){
            //obtener titulo del reporte
            $titulo = $this->res->datos[0]['titulo_reporte'];
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo = uniqid(md5(session_id()));
            $this->objParam->addParametro('titulo_archivo',$titulo);
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
            $this->objReporteFormato = new RBoletaGenerica($this->objParam);

            $filtro_previo = $this->objParam->parametros_consulta['filtro'];
            $this->objFunc = $this->create('MODReporte');

            if($this->res->datos[0]['multilinea'] == 'si' || $this->res->datos[0]['id_periodo'] == ''){
                 $i = 0;
                 $this->res2 = $this->objFunc->listarReporteDetalle($this->objParam);
                 $this->objReporteFormato->datosHeader($this->res->datos[$i], $this->res2->datos);
                 $this->objReporteFormato->generarReporte();
            } else {
                for ($i = 0; $i < count($this->res->datos); $i++){
                    $this->res2 = $this->objFunc->listarReporteDetalleBoleta($this->objParam);
                    $this->objReporteFormato->datosHeader($this->res->datos[$i], $this->res2->datos);
                    $this->objReporteFormato->generarReporte();
                }
            }


            if($this->res2->getTipo()=='EXITO'){
                $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                return dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo;
            } else {
                $this->res->imprimirRespuesta($this->res->generarJson());
                return 'ERROR';
            }


        } else {
            $this->res->imprimirRespuesta($this->res->generarJson());
            return 'ERROR';
        }

    }



	function reporteSaldoAcumuladoRcIva($titulo,$id_periodo, $id_tipo_contrato, $esquema){


        //obtener titulo del reporte
        $titulo = 'Saldo Acumulado Rc-IVA';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);


        $tamano = 'LETTER';
        $orientacion = 'P';


        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
		$this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res1=$this->objFunc->listarSaldoAcumuladoRcIva($this->objParam);

        //if ($tipo_reporte == 'pdf') {
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
            $this->objReporteFormato=new RPlanillaSaldoIva($this->objParam);
            $this->objReporteFormato->setDatos($this->res1->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');



        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }



//#125

    function reportePlanillaPrima($id_reporte,$esquema)    {


        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));


        $this->objParam->addParametro('orientacion','L');

        $this->objParam->addParametro('tamano',$this->objParam->getParametro('tamano'));
        $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
        $this->objParam->addParametro('id_gestion',$id_gestion);
        $this->objParam->addParametro('id_tipo_contrato',$this->objParam->getParametro('id_tipo_contrato'));
		$this->objParam->addParametro('id_tipo_planilla',$this->objParam->getParametro('id_tipo_planilla'));


		if($this->objParam->getParametro('codigo_planilla')=='PLAPREPRI'){//#135
			$this->objParam->addParametro('estado',$this->objParam->getParametro('personal_activo'));
		}

        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res=$this->objFunc->listarPlanillaPrima($this->objParam);


        if($this->objParam->getParametro('formato_reporte')=='pdf'){
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			if($this->objParam->getParametro('codigo_planilla')=='PLAPREPRI'){
				$this->objReporteFormato=new RPlanillaPrevisionPrima($this->objParam);	
			}else{
				$this->objReporteFormato=new RPlanillaPrima($this->objParam);	
			}
            
            $this->objReporteFormato->setDatos($this->res->datos,$this->res->datos);//#83
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        }else{
            $titulo ='AsignacionCargos';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaPrimaXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos);//#83

        }

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());




    }

     //#133
     function reporteBancosPrev()    { 

        //obtener titulo del reporte
        $titulo = 'RESUMEN - RELACION DE SALDOS';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $this->objParam->addParametro('titulo_archivo',$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));
        }

       
        if ($this->objParam->getParametro('id_reporte') != '') {
            $this->objParam->addFiltro("repo.id_reporte = ". $this->objParam->getParametro('id_reporte'));
        }

        
        if ($this->objParam->getParametro('control_reporte') != '') {
            $this->objParam->addFiltro("repo.control_reporte = ''". $this->objParam->getParametro('control_reporte')."''");
        }

        
        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->listarReporteMaestro($this->objParam);
        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res1=$this->objFunc->listarResumenPrevision($this->objParam);


        //#71
        $this->objFunc=$this->create('MODReporte');
        $this->res3=$this->objFunc->listarFirmasReporte($this->objParam);

		$this->objParam->addParametro('orientacion','P');
        
        if($this->objParam->getParametro('formato_reporte')=='pdf'){//#77
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
            $this->objReporteFormato=new RRelacionSaldos($this->objParam);

            $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos,$this->res3->datos);
           // $this->objReporteFormato->setDatos($this->res->datos,$this->res1->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        }else{
            $titulo ='Personal';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RRelacionSaldosXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos,$this->res1->datos);
        }

            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());



    }

//#144
function reporteIngresoEgreso()    {


        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));


        $this->objParam->addParametro('orientacion','P');

        $this->objParam->addParametro('tamano',$this->objParam->getParametro('tamano'));
        
        $this->objParam->addParametro('id_periodo',$this->objParam->getParametro('id_periodo'));
		
		$this->objParam->addParametro('id_gestion',$this->objParam->getParametro('id_gestion'));
		//$this->objParam->addParametro('id_reporte',$id_reporte);
        $this->objParam->addParametro('id_tipo_contrato',$this->objParam->getParametro('id_tipo_contrato'));
		$this->objParam->addParametro('id_tipo_planilla',$this->objParam->getParametro('id_tipo_planilla'));


		
        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res=$this->objFunc->listarIngresoEgreso($this->objParam);


        if($this->objParam->getParametro('formato_reporte')=='pdf'){
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			
			$this->objReporteFormato=new RPlanillaIngresoEgreso($this->objParam);	
			
            
            $this->objReporteFormato->setDatos($this->res->datos,$this->res->datos);//#83
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        }else{
            $titulo ='Ingreso/Egreso';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objReporteFormato=new RPlanillaIngresoEgresoXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte($this->res->datos);//#83

        }

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());




    }

}


?>