<?php
/**
 *@package pXP
 *@file gen-ACTPlanilla.php
 *@author  (admin)
 *@date 22-01-2014 16:11:04
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 *
 *
    HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
#38             10/09/2019        RAC KPLIAN     lsitado de vobo_conta, metodos paragenerar cbte contable
#47    ETR      24-09-2019        Manuel Guerra  reporte de verificacion presupuestaria
#78    ETR      18/11/2019       MZM             Adicionar listado de backups de planilla
#83    ETR      11.12.2019       MZM             Adicion de filtro a listado de backup de planilla para reportes
#107   ETR      16.03.2020       MZM             Adicion de filtro id_tipo_planilla para obtener gestion/periodo de la ultima planilla del tipo consultado
 * */
require_once(dirname(__FILE__).'/../reportes/RMinisterioTrabajoXLS.php');
require_once(dirname(__FILE__).'/../reportes/RMinisterioTrabajoUpdateXLS.php');
require_once(dirname(__FILE__).'/../reportes/RPrimaXLS.php');
require_once(dirname(__FILE__).'/../reportes/RAguinaldoXLS.php');
require_once(dirname(__FILE__).'/../reportes/RSegAguinaldoXLS.php');
require_once(dirname(__FILE__).'/../reportes/RCertificacionPresupuestaria.php');
require_once(dirname(__FILE__).'/../reportes/RVerificacionPresupuestaria.php');


class ACTPlanilla extends ACTbase{

    function listarPlanilla(){
        $this->objParam->defecto('ordenacion','id_planilla');

        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('pes_estado') == 'otro') {
            $this->objParam->addFiltro("plani.estado in (''registro_funcionarios'', ''registro_horas'', ''calculo_columnas'')");
        } else if ($this->objParam->getParametro('pes_estado') == 'vbrh') {
            $this->objParam->addFiltro("plani.estado  in (''calculo_validado'')");
        } else if ($this->objParam->getParametro('pes_estado') == 'planilla_finalizada') {
            $this->objParam->addFiltro("plani.estado  in (''planilla_finalizada'')");
        } else if ($this->objParam->getParametro('pes_estado') == 'comprobante_generado') {
            $this->objParam->addFiltro("plani.estado  in (''comprobante_generado'',''suppresu'',''vbpresupuestos'',''vobo_conta'')");//#38 anhade vobo_conta
        } else if($this->objParam->getParametro('pes_estado') == 'vbpoa'){
            $this->objParam->addFiltro("plani.estado  in (''vbpoa'')");
        } else if($this->objParam->getParametro('pes_estado') == 'suppresu'){
            $this->objParam->addFiltro("plani.estado  in (''suppresu'')");
        } else if($this->objParam->getParametro('pes_estado') == 'vbpresupuestos'){
            $this->objParam->addFiltro("plani.estado  in (''vbpresupuestos'')");
        } else if($this->objParam->getParametro('pes_estado') == 'vobo_conta'){  //#38 añade vobo conta
            $this->objParam->addFiltro("plani.estado   in (''vobo_conta'')");
        }
        else if($this->objParam->getParametro('pes_estado') == 'consultas'){
            $this->objParam->addFiltro("plani.estado  not in (''todos'')");
        }


        if ($this->objParam->getParametro('id_gestion') != '') {

            $this->objParam->addFiltro("plani.id_gestion = ". $this->objParam->getParametro('id_gestion'));

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

    function listarReportePlanillaMinisterio(){ //var_dump($this->objParam->getParametro('id_tipo_planilla'));exit;
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

    //Reporte Certificación Presupuestaria Planilla(F.E.A) 28/02/2018
    function reporteCertificacionP (){
        $this->objFunc=$this->create('MODPlanilla');
        $dataSource=$this->objFunc->reporteCertificacionP();
        $this->dataSource=$dataSource->getDatos();

        $nombreArchivo = uniqid(md5(session_id()).'[Planilla - Certificación Presupuestaria]').'.pdf';
        $this->objParam->addParametro('orientacion','P');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $this->objReporte = new RCertificacionPresupuestaria($this->objParam);
        $this->objReporte->setDatos($this->dataSource);
        $this->objReporte->generarReporte();
        $this->objReporte->output($this->objReporte->url_archivo,'F');


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

    //(f.e.a)13/3/2017 modificar datos poa de planilla
    function modificarObsPoa(){
        $this->objFunc=$this->create('MODPlanilla');
        $this->res=$this->objFunc->modificarObsPoa($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    //(f.e.a)13/3/2017
    function listarPartidaObjetivo(){

        /*$this->objParam->defecto('ordenacion','id_objetivo');
        $this->objParam->defecto('dir_ordenacion','asc');*/

        /////////////////
        //    FILTROS
        ////////////////
        /*if($this->objParam->getParametro('id_gestion')!='') {
            $this->objParam->addFiltro("obj.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }
        if($this->objParam->getParametro('sw_transaccional')!='') {
            $this->objParam->addFiltro("obj.sw_transaccional = ''".$this->objParam->getParametro('sw_transaccional')."''");
        }*/
        /////////////////////
        //Llamada al Modelo
        /////////////////////
        $this->objFunc=$this->create('MODPlanilla');
        $this->res=$this->objFunc->listarPartidaObjetivo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    #38 +
    function generarCbteContable(){
        $this->objFunc=$this->create('MODPlanilla');
        $this->res=$this->objFunc->generarCbteContable($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    //#47
    function listaVerPresu(){
        if($this->objParam->getParametro('id_planilla')!=''){
            $this->objParam->addFiltro("conpre.id_planilla =".$this->objParam->getParametro('id_planilla'));
        }
        $this->objFunc=$this->create('MODPlanilla');
        $cbteHeader = $this->objFunc->listaVerPresu($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }
    }
    //#47
    function reporteVerifPresu(){
        $nombreArchivo = uniqid(md5(session_id()).'[Planilla - Verificacion Presupuestaria]').'.pdf';
        $dataSource = $this->listaVerPresu();
        $orientacion = 'P';
        $tamano = 'LETTER';
        $titulo = 'Consolidado';
        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $reporte = new RVerificacionPresupuestaria($this->objParam);
        $reporte->datosHeader($dataSource->getDatos());
        $reporte->generarReporte();
        $reporte->output($reporte->url_archivo,'F');
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genera con exito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

    #78 listarPlanillaBk
    function listarPlanillaBk(){
        $this->objParam->defecto('ordenacion','id_planilla');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_planilla_original') != '') {
            $this->objParam->addFiltro("plani.id_planilla_original = ". $this->objParam->getParametro('id_planilla_original'));
        }
        //#83
        if ($this->objParam->getParametro('id_tipo_planilla') != '') {
            $this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
        }
        if ($this->objParam->getParametro('id_periodo') != '') {
            $this->objParam->addFiltro("per.id_periodo = ". $this->objParam->getParametro('id_periodo'));
        }
        if ($this->objParam->getParametro('id_tipo_contrato') != '') {
            $this->objParam->addFiltro("tc.id_tipo_contrato = ". $this->objParam->getParametro('id_tipo_contrato'));
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPlanilla','listarPlanillaBk');
        } else{
            $this->objFunc=$this->create('MODPlanilla');

            $this->res=$this->objFunc->listarPlanillaBk($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }


    function listarPlanillaUltima(){//#107
        $this->objParam->defecto('ordenacion','id_planilla');

        $this->objParam->defecto('dir_ordenacion','asc');



        if ($this->objParam->getParametro('id_tipo_planilla') != '') {
            $this->objParam->addFiltro("plani.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPlanilla','listarPlanillaUltima');
        } else{
            $this->objFunc=$this->create('MODPlanilla');

            $this->res=$this->objFunc->listarPlanillaUltima($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>