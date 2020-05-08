<?php
/**
*@package pXP
*@file ACTExportarPlantilla.php
*@author  (EGS)
*@date
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*  ISSUE          FECHA            AUTOR            DESCRIPCION
* #9              22/05/2019        EGS        creacion
* #11   endeetr   05/06/2019        EGS        actualizaciones de registros activos
* #121  ETR       30/04/2020        RAC        Incluir la configuración de reportes al exportar las configuracion de tipo planillas para facilitar las pruebas y puestas en producción.
*
*/

class ACTExportarPlantilla extends ACTbase{

    function exportarDatosTipoPlanilla(){

        //recupera datos de tipo planilla y  suscolumnas
        $this->objFunPlanillas = $this->create('MODExportarPlantilla');
        $this->res = $this->objFunPlanillas->exportarDatosTipoPlanilla();

        if($this->res->getTipo()=='ERROR'){
            $this->res->imprimirRespuesta($this->res->generarJson());
            exit;
        }

        //recupera datos de obligaciones
        $objFunPlanillas2 = $this->create('MODExportarPlantilla');
        $this->res2 = $objFunPlanillas2->exportarDatosTipoObligacion();

        if($this->res2->getTipo()=='ERROR'){
            $this->res2->imprimirRespuesta($this->res2->generarJson());
            exit;
        }

        //recuepra datos de reportes
        $objFunPlanillas3 = $this->create('MODExportarPlantilla');
        $this->res3 = $objFunPlanillas3->exportarDatosReportePlanilla();

        if($this->res3->getTipo()=='ERROR'){
            $this->res3->imprimirRespuesta($this->res3->generarJson());
            exit;
        }

        $nombreArchivo = $this->crearArchivoExportacionTipoPlanilla($this->res, $this->res2, $this->res3);

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
                                        'Se genero con exito el sql'.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);

        $this->res->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    function crearArchivoExportacionTipoPlanilla($res, $res2, $res3) {
        $data = $res -> getDatos();
        $dataObligacion = $res2 -> getDatos();
        $dataReporte = $res3 -> getDatos();


        $fileName = uniqid(md5(session_id()).'PlantillaTipoPlanilla').'.sql';
        //create file
        $file = fopen("../../../reportes_generados/$fileName", 'w');

        $sw_gui = 0;
        $sw_funciones=0;
        $sw_procedimiento=0;
        $sw_rol=0;
        $sw_rol_pro=0;
        fwrite ($file,"----------------------------------\r\n".
                          "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
                          "--Configuracion TIPO PLANILLA   \n---------------------------------\r\n".
                          "\r\n" );
        foreach ($data as $row) {
             if ($row['tipo_reg'] == 'maestro' ) {

                if ($row['estado_reg'] == 'activo') {
                    fwrite ($file,
                    "select plani.f_import_ttipo_planilla ('insert','".
                                $row['codigo']."'," .
                             (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
                             (is_null($row['codigo_proceso_macro'])?'NULL':"'".$row['codigo_proceso_macro']."'") ."," .
                             (is_null($row['funcion_obtener_empleados'])?'NULL':"'".$row['funcion_obtener_empleados']."'") ."," .
                             (is_null($row['tipo_presu_cc'])?'NULL':"'".$row['tipo_presu_cc']."'") ."," .
                             (is_null($row['funcion_validacion_nuevo_empleado'])?'NULL':"'".$row['funcion_validacion_nuevo_empleado']."'") ."," .
                             (is_null($row['calculo_horas'])?'NULL':"'".$row['calculo_horas']."'") ."," .
                             (is_null($row['periodicidad'])?'NULL':"'".$row['periodicidad']."'") ."," .
                             (is_null($row['funcion_calculo_horas'])?'NULL':"'".$row['funcion_calculo_horas']."'") ."," .
                             (is_null($row['recalcular_desde'])?'NULL':"'".$row['recalcular_desde']."'") ."," .
                             (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'").");\r\n");
                }
             } else if ($row['tipo_reg'] == 'detalle') {
                if ($row['estado_reg'] == 'activo') {

                    fwrite ($file,
                     "select plani.f_import_ttipo_columna_planilla ('insert',".
                             (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
                             (is_null($row['codigo_tipo_pla'])?'NULL':"'".$row['codigo_tipo_pla']."'") ."," .
                             (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
                             (is_null($row['tipo_dato'])?'NULL':"'".$row['tipo_dato']."'") ."," .
                             (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .
                             (is_null($row['formula'])?'NULL':"'".$row['formula']."'") ."," .
                             (is_null($row['compromete'])?'NULL':"'".$row['compromete']."'") ."," .
                             (is_null($row['tipo_descuento_bono'])?'NULL':"'".$row['tipo_descuento_bono']."'") ."," .
                             (is_null($row['decimales_redondeo'])?'NULL':"'".$row['decimales_redondeo']."'") ."," .
                             (is_null($row['orden'])?'NULL':"'".$row['orden']."'") ."," .
                             (is_null($row['finiquito'])?'NULL':"'".$row['finiquito']."'") ."," .
                             (is_null($row['tiene_detalle'])?'NULL':"'".$row['tiene_detalle']."'") ."," .
                             (is_null($row['recalcular'])?'NULL':"'".$row['recalcular']."'") ."," .
                             (is_null($row['editable'])?'NULL':"'".$row['editable']."'") ."," .        // --#11
                             (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") .");\r\n");
                }
            }
         } //end for

         fwrite ($file,"\r\n\r\n----------------------------------\r\n".
                          "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
                          "--Configuracion OBLIGACIONES\n---------------------------------\r\n".
                          "\r\n" );


         foreach ($dataObligacion as $row) {
             if ($row['tipo_reg'] == 'maestro_tipo_obli' ) {

                if ($row['estado_reg'] == 'activo') {
                    fwrite ($file,
                    "select plani.f_import_ttipo_obligacion('insert','".
                                $row['codigo']."'," .
                             (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
                             (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
                             (is_null($row['tipo_obligacion'])?'NULL':"'".$row['tipo_obligacion']."'") ."," .
                             (is_null($row['dividir_por_lugar'])?'NULL':"'".$row['dividir_por_lugar']."'") ."," .
                             (is_null($row['es_pagable'])?'NULL':"'".$row['es_pagable']."'") ."," .
                             (is_null($row['codigo_tipo_obligacion_agrupador'])?'NULL':"'".$row['codigo_tipo_obligacion_agrupador']."'") ."," .
                             (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .
                             (is_null($row['codigo_tipo_relacion_debe'])?'NULL':"'".$row['codigo_tipo_relacion_debe']."'") ."," .
                             (is_null($row['codigo_tipo_relacion_haber'])?'NULL':"'".$row['codigo_tipo_relacion_haber']."'") ."," .
                             (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'").");\r\n");


                }
             } else if ($row['tipo_reg'] == 'detalle_tipo_obli_colum') {
                if ($row['estado_reg'] == 'activo') {

                    fwrite ($file,
                     "select plani.f_import_ttipo_obligacion_columna('insert',".
                             (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
                             (is_null($row['codigo_tipo_obligacion'])?'NULL':"'".$row['codigo_tipo_obligacion']."'") ."," .
                             (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
                             (is_null($row['pago'])?'NULL':"'".$row['pago']."'") ."," .
                             (is_null($row['presupuesto'])?'NULL':"'".$row['presupuesto']."'") ."," .
                             (is_null($row['es_ultimo'])?'NULL':"'".$row['es_ultimo']."'") ."," .
                             (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") .");\r\n");


                }
            }
         } //end for

          fwrite ($file,"\r\n\r\n----------------------------------\r\n".
                          "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
                          "--Configuracion REPORTES\n---------------------------------\r\n".
                          "\r\n" );


         foreach ($dataReporte as $row) {
             if ($row['tipo_reg'] == 'maestro_reporte' ) {

                fwrite ($file,
                "select plani.f_import_treporte('insert','".
                          $row['codigo_reporte']."'," .
                         (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
                         //collumnas no basicas
                         (is_null($row['numerar'])?'NULL':"'".$row['numerar']."'") ."," .
                         (is_null($row['hoja_posicion'])?'NULL':"'".$row['hoja_posicion']."'") ."," .
                         (is_null($row['mostrar_nombre'])?'NULL':"'".$row['mostrar_nombre']."'") ."," .
                         (is_null($row['mostrar_codigo_empleado'])?'NULL':"'".$row['mostrar_codigo_empleado']."'") ."," .
                         (is_null($row['mostrar_doc_id'])?'NULL':"'".$row['mostrar_doc_id']."'") ."," .
                         (is_null($row['mostrar_codigo_cargo'])?'NULL':"'".$row['mostrar_codigo_cargo']."'") ."," .
                         (is_null($row['agrupar_por'])?'NULL':"'".$row['agrupar_por']."'") ."," .
                         (is_null($row['ordenar_por'])?'NULL':"'".$row['ordenar_por']."'") ."," .
                         (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") ."," .
                         (is_null($row['ancho_utilizado'])?'NULL':$row['ancho_utilizado']) ."," .
                         (is_null($row['ancho_total'])?'NULL':$row['ancho_total']) ."," .
                         (is_null($row['titulo_reporte'])?'NULL':"'".$row['titulo_reporte']."'") ."," .
                         (is_null($row['control_reporte'])?'NULL':"'".$row['control_reporte']."'") ."," .
                         (is_null($row['tipo_reporte'])?'NULL':"'".$row['tipo_reporte']."'") ."," .
                         (is_null($row['multilinea'])?'NULL':"'".$row['multilinea']."'") ."," .
                         (is_null($row['vista_datos_externos'])?'NULL':"'".$row['vista_datos_externos']."'") ."," .
                         (is_null($row['num_columna_multilinea'])?'NULL':$row['num_columna_multilinea']) ."," .
                         (is_null($row['mostrar_ufv'])?'NULL':"'".$row['mostrar_ufv']."'") ."," .
                         (is_null($row['incluir_retirados'])?'NULL':"'".$row['incluir_retirados']."'") ."," .
                         (is_null($row['codigo_moneda'])?'NULL':"'".$row['codigo_moneda']."'") ."," .
                         (is_null($row['bordes'])?'NULL':$row['bordes']) ."," .
                         (is_null($row['interlineado'])?'NULL':$row['interlineado']).");\r\n");


             } else if ($row['tipo_reg'] == 'detalle_reporte') {

                fwrite ($file,
                 "select plani.f_import_treporte_columna('insert',".
                         (is_null($row['codigo_columna'])?'NULL':"'".$row['codigo_columna']."'") ."," .
                         (is_null($row['codigo_reporte'])?'NULL':"'".$row['codigo_reporte']."'") ."," .
                         (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
                         //columnas extra
                         (is_null($row['sumar_total'])?'NULL':"'".$row['sumar_total']."'") ."," .
                         (is_null($row['ancho_columna'])?'NULL':$row['ancho_columna']) ."," .
                         (is_null($row['orden'])?'NULL':$row['orden']) ."," .
                         (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") ."," .
                         (is_null($row['titulo_reporte_superior'])?'NULL':"'".$row['titulo_reporte_superior']."'") ."," .
                         (is_null($row['titulo_reporte_inferior'])?'NULL':"'".$row['titulo_reporte_inferior']."'") ."," .
                         (is_null($row['tipo_columna'])?'NULL':"'".$row['tipo_columna']."'") ."," .
                         (is_null($row['espacio_previo'])?'NULL':$row['espacio_previo']) ."," .
                         (is_null($row['columna_vista'])?'NULL':"'".$row['columna_vista']."'") ."," .
                         (is_null($row['origen'])?'NULL':"'".$row['origen']."'").");\r\n");

            }
         } //end for


        return $fileName;
    }
    ///Se creo la logica para crear exportador de plantilla de tipo de obligacion separado del exportador tipo de planilla solo falta agregar el boton y
    //mandara la id_tipo_obligacion como parametro desde la vista
    function exportarDatosTipoObligacion(){

        //crea el objetoFunPlanillas que contiene todos los metodos del sistema de workflow
        $this->objFunPlanillas=$this->create('MODExportarPlantilla');

        $this->res = $this->objFunPlanillas->exportarDatosTipoObligacion();

        if($this->res->getTipo()=='ERROR'){
            $this->res->imprimirRespuesta($this->res->generarJson());
            exit;
        }

        $nombreArchivo = $this->crearArchivoExportacionTipoObligacion($this->res);

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
                                        'Se genero con exito el sql'.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);

        $this->res->imprimirRespuesta($this->mensajeExito->generarJson());

    }
    function crearArchivoExportacionTipoObligacion($res) {
        $data = $res -> getDatos();
        //var_dump($data);
        $fileName = uniqid(md5(session_id()).'PlantillaTipoObligacion').'.sql';
        //create file
        $file = fopen("../../../reportes_generados/$fileName", 'w');

        $sw_gui = 0;
        $sw_funciones=0;
        $sw_procedimiento=0;
        $sw_rol=0;
        $sw_rol_pro=0;
        fwrite ($file,"----------------------------------\r\n".
                          "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
                          "---------------------------------\r\n".
                          "\r\n" );
        foreach ($data as $row) {
              if ($row['tipo_reg'] == 'maestro_tipo_obli' ) {

                if ($row['estado_reg'] == 'activo') {
                    fwrite ($file,
                    "select plani.f_import_ttipo_obligacion('insert','".
                                $row['codigo']."'," .
                             (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
                             (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
                             (is_null($row['tipo_obligacion'])?'NULL':"'".$row['tipo_obligacion']."'") ."," .
                             (is_null($row['dividir_por_lugar'])?'NULL':"'".$row['dividir_por_lugar']."'") ."," .
                             (is_null($row['es_pagable'])?'NULL':"'".$row['es_pagable']."'") ."," .
                             (is_null($row['codigo_tipo_obligacion_agrupador'])?'NULL':"'".$row['codigo_tipo_obligacion_agrupador']."'") ."," .
                             (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .
                             (is_null($row['codigo_tipo_relacion_debe'])?'NULL':"'".$row['codigo_tipo_relacion_debe']."'") ."," .
                             (is_null($row['codigo_tipo_relacion_haber'])?'NULL':"'".$row['codigo_tipo_relacion_haber']."'") ."," .
                             (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'").");\r\n");


                }
             } else if ($row['tipo_reg'] == 'detalle_tipo_obli_colum') {
                if ($row['estado_reg'] == 'activo') {

                    fwrite ($file,
                     "select plani.f_import_ttipo_obligacion_columna('insert',".
                             (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
                             (is_null($row['codigo_tipo_obligacion'])?'NULL':"'".$row['codigo_tipo_obligacion']."'") ."," .
                             (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
                             (is_null($row['pago'])?'NULL':"'".$row['pago']."'") ."," .
                             (is_null($row['presupuesto'])?'NULL':"'".$row['presupuesto']."'") ."," .
                             (is_null($row['es_ultimo'])?'NULL':"'".$row['es_ultimo']."'") ."," .
                             (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") .");\r\n");


                }
            }
         } //end for


        return $fileName;
    }


}

?>