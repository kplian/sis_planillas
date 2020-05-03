<?php
/**
*@package pXP
*@file MODExportarPlantilla.php
*@author  (egs)
*@date
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*     ISSUE        FECHA            AUTOR            DESCRIPCION
#9             23/05/2019        EGS         creacion
#11  ETR       05/06/2019        EGS         actualizaciones de registros activos
#121 ETR       30/04/2020        RAC         Incluir la configuración de reportes al exportar las configuracion de tipo planillas para facilitar las pruebas y puestas en producción.
*/

class MODExportarPlantilla extends MODbase{

        function __construct(CTParametro $pParam){
            parent::__construct($pParam);
        }

        function exportarDatosTipoPlanilla() {

             $this->procedimiento='plani.f_exportar_plantilla';
             $this->transaccion='PLA_EXPTIPL_SEL';
             $this->tipo_procedimiento='SEL';
             $this->setCount(false);

             $this->setParametro('id_tipo_planilla','id_tipo_planilla','integer');

            //Definicion de la lista del resultado del query
            $this->captura('tipo_reg','varchar');
            $this->captura('codigo','varchar');
            $this->captura('nombre','varchar');
            $this->captura('codigo_proceso_macro','varchar');
            $this->captura('funcion_obtener_empleados','varchar');
            $this->captura('tipo_presu_cc','varchar');
            $this->captura('funcion_validacion_nuevo_empleado','varchar');
            $this->captura('calculo_horas','varchar');
            $this->captura('periodicidad','varchar');
            $this->captura('funcion_calculo_horas','varchar');
            $this->captura('recalcular_desde','integer');
            $this->captura('estado_reg','varchar');


            $this->armarConsulta();
            $this->ejecutarConsulta();

            ////////////////////////////

            if($this->respuesta->getTipo() == 'ERROR'){
                return $this->respuesta;
            }
            else {
                $this->procedimiento = 'plani.f_exportar_plantilla';
                $this->transaccion = 'PLA_EXPTIPLDE_SEL';
                $this->tipo_procedimiento = 'SEL';
                $this->setCount(false);
                $this->resetCaptura();
                $this->addConsulta();



                $this->captura('tipo_reg','varchar');
                $this->captura('codigo','varchar');
                $this->captura('codigo_tipo_pla','varchar');
                $this->captura('nombre','varchar');
                $this->captura('tipo_dato','varchar');
                $this->captura('descripcion','text');
                $this->captura('formula','varchar');
                $this->captura('compromete','varchar');
                $this->captura('tipo_descuento_bono','varchar');
                $this->captura('decimales_redondeo','integer');
                $this->captura('orden','integer');
                $this->captura('finiquito','varchar');
                $this->captura('tiene_detalle','varchar');
                $this->captura('recalcular','varchar');
                $this->captura('estado_reg','varchar');
                $this->captura('editable','varchar'); //#11



                $this->armarConsulta();
                $consulta=$this->getConsulta();

                $this->ejecutarConsulta($this->respuesta);
            }
            return $this->respuesta;

    }

    function exportarDatosTipoObligacion() {

        $this->procedimiento='plani.f_exportar_plantilla';
        $this->transaccion='PLA_EXPTIOB_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);

        //var_dump($this->objParam);
        $this->setParametro('id_tipo_planilla','id_tipo_planilla','integer');
        $this->setParametro('id_tipo_obligacion','id_tipo_obligacion','integer');

        //Definicion de la lista del resultado del query
        $this->captura('tipo_reg','varchar');
        $this->captura('codigo','varchar');
        $this->captura('codigo_tipo_planilla','varchar');
        $this->captura('nombre','varchar');
        $this->captura('tipo_obligacion','varchar');
        $this->captura('dividir_por_lugar','varchar');
        $this->captura('es_pagable','varchar');
        $this->captura('codigo_tipo_obligacion_agrupador','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('codigo_tipo_relacion_debe','varchar');
        $this->captura('codigo_tipo_relacion_haber','varchar');
        $this->captura('estado_reg','varchar');


        $this->armarConsulta();
        $this->ejecutarConsulta();

        ////////////////////////////

        if($this->respuesta->getTipo() == 'ERROR'){
            return $this->respuesta;
        }
        else {
            $this->procedimiento = 'plani.f_exportar_plantilla';
            $this->transaccion = 'PLA_EXPTIOBCO_SEL';
            $this->tipo_procedimiento = 'SEL';
            $this->setCount(false);
            $this->resetCaptura();
            $this->addConsulta();



            $this->captura('tipo_reg','varchar');
            $this->captura('codigo','varchar');
            $this->captura('codigo_tipo_obligacion','varchar');
            $this->captura('codigo_tipo_planilla','varchar');
            $this->captura('pago','varchar');
            $this->captura('presupuesto','varchar');
            $this->captura('es_ultimo','varchar');
            $this->captura('estado_reg','varchar');



            $this->armarConsulta();
            $consulta=$this->getConsulta();

            $this->ejecutarConsulta($this->respuesta);
        }

        return $this->respuesta;

    }

    function exportarDatosReportePlanilla() {
        $this->procedimiento='plani.f_exportar_plantilla';
        $this->transaccion='PLA_EXREP_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);


        $this->setParametro('id_tipo_planilla','id_tipo_planilla','integer');
        $this->setParametro('id_reporte','id_reporte','integer');

        //Definicion de la lista del resultado del query
        $this->captura('id_reporte','int4');
        $this->captura('id_tipo_planilla','int4');
        $this->captura('numerar','varchar');
        $this->captura('hoja_posicion','varchar');
        $this->captura('mostrar_nombre','varchar');
        $this->captura('mostrar_codigo_empleado','varchar');
        $this->captura('mostrar_doc_id','varchar');
        $this->captura('mostrar_codigo_cargo','varchar');
        $this->captura('agrupar_por','varchar');
        $this->captura('ordenar_por','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('ancho_utilizado','int4');
        $this->captura('ancho_total','int4');
        $this->captura('titulo_reporte','varchar');
        $this->captura('control_reporte','varchar');
        $this->captura('tipo_reporte','varchar');
        $this->captura('multilinea','varchar');
        $this->captura('vista_datos_externos','varchar');
        $this->captura('num_columna_multilinea','integer');
        $this->captura('mostrar_ufv','varchar');
        $this->captura('incluir_retirados','varchar');
        $this->captura('codigo_moneda','varchar');
        $this->captura('bordes','integer');
        $this->captura('interlineado','numeric');
        $this->captura('codigo_tipo_planilla','varchar');
        $this->captura('tipo_reg','varchar');
        $this->captura('codigo_reporte','varchar');


        $this->armarConsulta();
        $this->ejecutarConsulta();



        if($this->respuesta->getTipo() == 'ERROR'){
            return $this->respuesta;
        }
        else {
            //recupera el detalle del reporte
            $this->procedimiento = 'plani.f_exportar_plantilla';
            $this->transaccion = 'PLA_EXREPDET_SEL';
            $this->tipo_procedimiento = 'SEL';
            $this->setCount(false);
            $this->resetCaptura();
            $this->addConsulta();

            $this->captura('id_reporte_columna','int4');
            $this->captura('id_reporte','int4');
            $this->captura('sumar_total','varchar');
            $this->captura('ancho_columna','int4');
            $this->captura('orden','int4');
            $this->captura('estado_reg','varchar');
            $this->captura('codigo_columna','varchar');
            $this->captura('titulo_reporte_superior','varchar');
            $this->captura('titulo_reporte_inferior','varchar');
            $this->captura('tipo_columna','varchar');
            $this->captura('espacio_previo','integer');
            $this->captura('columna_vista','varchar');
            $this->captura('origen','varchar');
            $this->captura('codigo_reporte','varchar');
            $this->captura('codigo_tipo_planilla','varchar');
            $this->captura('tipo_reg','varchar');



            $this->armarConsulta();
            $consulta=$this->getConsulta();

            $this->ejecutarConsulta($this->respuesta);
        }

        return $this->respuesta;
    }
}
?>