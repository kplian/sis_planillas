<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RAguinaldoXLS
{
    private $docexcel;
    private $objWriter;
    private $nombre_archivo;
    private $hoja;
    private $columnas=array();
    private $fila;
    private $equivalencias=array();

    private $indice, $m_fila, $titulo;
    private $swEncabezado=0; //variable que define si ya se imprimi� el encabezado
    private $objParam;
    public  $url_archivo;
    private $resumen = array();
    private $resumen_regional = array();

    function __construct(CTParametro $objParam){

        //reducido menos 23,24,26,27,29,30
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        //ini_set('memory_limit','512M');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);

        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
            ->setLastModifiedBy("PXP")
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");

        //$sheetId = 1;
        //$this->docexcel->createSheet(NULL, $sheetId);
        //$this->docexcel->setActiveSheetIndex($sheetId);
        //$this->docexcel->getActiveSheet()->setTitle('Planilla Prima');

        $this->docexcel->setActiveSheetIndex(0);

        $this->equivalencias=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
            9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
            18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
            26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
            34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
            42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
            50=>'AY',51=>'AZ',
            52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
            60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
            68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
            76=>'BY',77=>'BZ');

    }

    function imprimeDatosSueldo(){
        $this->docexcel->setActiveSheetIndex(0);
        $this->docexcel->getActiveSheet()->setTitle('Planilla Aguinaldo');
        $datos = $this->objParam->getParametro('datos');

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(7);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(11);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(6);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('X')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setWidth(15);

        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 8,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'c5d9f1'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $this->docexcel->getActiveSheet()->getStyle('A1:AE1')->getAlignment()->setWrapText(true);

        $this->docexcel->getActiveSheet()->getStyle('A1:N1')->applyFromArray($styleTitulos);
        $styleTitulos['fill']['color']['rgb'] = '8DB4E2';
        $this->docexcel->getActiveSheet()->getStyle('O1')->applyFromArray($styleTitulos);
        $styleTitulos['fill']['color']['rgb'] = 'FFFFFF';
        $this->docexcel->getActiveSheet()->getStyle('P1:AE1')->applyFromArray($styleTitulos);
        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A1','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B1','Tipo de documento de identidad');
        $this->docexcel->getActiveSheet()->setCellValue('C1','Número de documento de identidad');
        $this->docexcel->getActiveSheet()->setCellValue('D1','Extensión del documento de identidad');
        $this->docexcel->getActiveSheet()->setCellValue('E1','AFP a la que aporta');
        $this->docexcel->getActiveSheet()->setCellValue('F1','NUA/CUA');
        $this->docexcel->getActiveSheet()->setCellValue('G1','Apellido Paterno');
        $this->docexcel->getActiveSheet()->setCellValue('H1','Apellido Materno');
        $this->docexcel->getActiveSheet()->setCellValue('I1','Apellido de casada');
        $this->docexcel->getActiveSheet()->setCellValue('J1','Primer nombre');
        $this->docexcel->getActiveSheet()->setCellValue('K1','Otros nombres');
        $this->docexcel->getActiveSheet()->setCellValue('L1','País de nacionalidad');
        $this->docexcel->getActiveSheet()->setCellValue('M1','Fecha de nacimiento');
        $this->docexcel->getActiveSheet()->setCellValue('N1','Sexo');
        $this->docexcel->getActiveSheet()->setCellValue('O1','Jubilado');
        $this->docexcel->getActiveSheet()->setCellValue('P1','Clasificación laboral');
        $this->docexcel->getActiveSheet()->setCellValue('Q1','Cargo');
        $this->docexcel->getActiveSheet()->setCellValue('R1','Fecha de ingreso');
        $this->docexcel->getActiveSheet()->setCellValue('S1','Modalidad de contrato');
        $this->docexcel->getActiveSheet()->setCellValue('T1','Fecha de retiro');
        $this->docexcel->getActiveSheet()->setCellValue('U1','Promedio haber básico');
        $this->docexcel->getActiveSheet()->setCellValue('V1','Promedio bono de antiguedad');
        $this->docexcel->getActiveSheet()->setCellValue('W1','Promedio bono de produccion');
        $this->docexcel->getActiveSheet()->setCellValue('X1','Promedio subsidio de frontera');
        $this->docexcel->getActiveSheet()->setCellValue('Y1','Promedio trabajo extraordinario y nocturno');
        $this->docexcel->getActiveSheet()->setCellValue('Z1','Promedio pago dominical y domingo trabajado');
        $this->docexcel->getActiveSheet()->setCellValue('AA1','Promedio otros bonos');
        $this->docexcel->getActiveSheet()->setCellValue('AB1','Promedio total ganado');
        $this->docexcel->getActiveSheet()->setCellValue('AC1','Meses Trabajados');
        $this->docexcel->getActiveSheet()->setCellValue('AD1','Total ganado despues de duodecimas');
        $this->docexcel->getActiveSheet()->setCellValue('AE1','Sucursal o ubicacion adicional');



        //*************************************Detalle*****************************************
        $numero = 0;
        $columna = 0;
        $fila = 1;
        $this->docexcel->getActiveSheet()->getRowDimension($fila+1)->setRowHeight(60);
        $this->resumen['basico'] = 0;
        $this->resumen['antiguedad'] = 0;
        $this->resumen['frontera'] = 0;
        $this->resumen['otros_bonos'] = 0;
        $this->resumen['total_ganado'] = 0;
        $this->resumen['afp'] = 0;
        $this->resumen['afp_pre'] = 0;
        $this->resumen['afp_fut'] = 0;
        $this->resumen['afp'] = 0;
        $this->resumen['iva'] = 0;

        $this->resumen['promedio_basico'] = 0;
        $this->resumen['promedio_antiguedad'] = 0;
        $this->resumen['promedio_frontera'] = 0;
        $this->resumen['promedio_total'] = 0;
        $this->resumen['liquido_pagable'] = 0;


        $this->resumen['trabajadores_varones'] = 0;
        $this->resumen['trabajadores_mujeres'] = 0;
        $this->resumen['jubilados_varones'] = 0;
        $this->resumen['jubilados_mujeres'] = 0;
        $this->resumen['extranjeros_varones'] = 0;
        $this->resumen['extranjeros_mujeres'] = 0;
        $this->resumen['discapacitados_varones'] = 0;
        $this->resumen['discapacitados_mujeres'] = 0;
        $this->resumen['contrato_varones'] = 0;
        $this->resumen['contrato_mujeres'] = 0;
        $this->resumen['retiro_varones'] = 0;
        $this->resumen['retiro_mujeres'] = 0;
        foreach($datos as $value) {

            if ($numero != $value['fila']) {

                $fila++;
                $columna = 0;
                if ($value['afp']== '1') {
                    $this->resumen['afp_pre'] ++;

                } else {
                    $this->resumen['afp_fut'] ++;
                }
                //$this->armaResumenRegional($value['lugar'], $value);
                if ($value['sexo']== '1') {
                    $this->resumen['trabajadores_varones']++;
                    if ($value['jubilado']== 1) {
                        $this->resumen['jubilados_varones']++;
                    }

                    if ($value['nacionalidad']!= 'Bolivia') {
                        $this->resumen['extranjeros_varones']++;
                    }

                    if ($value['discapacitado']== 'si') {
                        $this->resumen['discapacitados_varones']++;
                    }


                }//varon
                else {
                    $this->resumen['trabajadores_mujeres']++;
                    if ($value['jubilado']== 1) {
                        $this->resumen['jubilados_mujeres']++;
                    }
                    if ($value['nacionalidad']!= 'Bolivia') {
                        $this->resumen['extranjeros_mujeres']++;
                    }
                    if ($value['discapacitado']== 'si') {
                        $this->resumen['discapacitados_mujeres']++;
                    }


                }
                foreach ($value as $key => $val) {
                    if ($key != 'codigo_columna' && $key != 'valor'&& $key != 'oficina' && $key != 'discapacitado'&& $key != 'contrato_periodo'&& $key != 'retiro_periodo'
                        && $key != 'edad'&& $key != 'lugar') {
                        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$val);
                        $columna++;
                    }
                }
                $numero = $value['fila'];

            }

            if ($value['codigo_columna'] == 'PROMHAB') {
                $this->resumen['promedio_basico'] = $this->resumen['promedio_basico'] + $value['valor'];
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(20,$fila,$value['valor']);
            }

            if ($value['codigo_columna'] == 'PROMANT') {
                $this->resumen['promedio_antiguedad'] = $this->resumen['promedio_antiguedad'] + $value['valor'];
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(21,$fila,$value['valor']);
            }

            if ($value['codigo_columna'] == 'PROMFRO') {
                $this->resumen['promedio_frontera'] = $this->resumen['promedio_frontera'] + $value['valor'];
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(23,$fila,$value['valor']);
            }


            if ($value['codigo_columna'] == 'PROME') {
                $this->resumen['promedio_total'] = $this->resumen['promedio_total'] + $value['valor'];
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(27,$fila,$value['valor']);
            }

            if ($value['codigo_columna'] == 'LIQPAG') {
                $this->resumen['liquido_pagable'] = $this->resumen['liquido_pagable'] + $value['valor'];
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(29,$fila,$value['valor']);
            }

            if ($value['codigo_columna'] == 'DIASAGUI') {

                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(28,$fila, round($value['valor']/30,2) );
            }

            if ($columna == 21) {
                $columna++;
            }

            if ($columna == 22) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 23) {
                $columna++;
            }
            if ($columna == 24) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }

            if ($columna == 25) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }

            if ($columna == 26) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 27) {
                $columna++;
            }

            if ($columna == 28) {
                $columna++;
            }

            if ($columna == 29) {
                $columna++;
            }
            if ($columna == 30) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$value['oficina']);
                $columna++;
            }

        }

        //************************************************Fin Detalle***********************************************
    }

    function imprimeResumen(){
        $sheetId = 1;
        $this->docexcel->createSheet(NULL, $sheetId);
        $this->docexcel->setActiveSheetIndex($sheetId);
        $this->docexcel->getActiveSheet()->setTitle('Resumen');

        $this->docexcel->setActiveSheetIndex($sheetId);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(55);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(55);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);

        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 8,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'D9D9D9'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $this->docexcel->getActiveSheet()->getStyle('A1:F1')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A5:D5')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A9:C9')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A11:F11')->applyFromArray($styleTitulos);

        $this->docexcel->getActiveSheet()->setCellValue('A1','Seguro social a corto plazo');

        $this->docexcel->getActiveSheet()->setCellValue('A2','4.1.1 N°asegurados al ente gestor');
        $this->docexcel->getActiveSheet()->setCellValue('B2',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('C2','4.2.1 monto aportado');
        $this->docexcel->getActiveSheet()->setCellValue('D2',0);
        $this->docexcel->getActiveSheet()->setCellValue('E2','4.3.1 ente gestor de salud corto plazo');
        $this->docexcel->getActiveSheet()->setCellValue('F2','CORDES');

        $this->docexcel->getActiveSheet()->setCellValue('A3','4.1.1 N°asegurados al ente gestor');
        $this->docexcel->getActiveSheet()->setCellValue('B3',0);
        $this->docexcel->getActiveSheet()->setCellValue('C3','4.2.1 monto aportado');
        $this->docexcel->getActiveSheet()->setCellValue('D3',0);
        $this->docexcel->getActiveSheet()->setCellValue('E3','4.3.2 ente gestor de salud corto plazo');
        $this->docexcel->getActiveSheet()->setCellValue('F3','SEGURO UNIVERSITARIO');

        $this->docexcel->getActiveSheet()->setCellValue('A5','Seguro social a largo plazo');

        $this->docexcel->getActiveSheet()->setCellValue('A6','4.4 Nº total de afiliados al seguro a largo plazo (AFP´s)');
        $this->docexcel->getActiveSheet()->setCellValue('B6',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('C6','4.5 Monto aportado (Total aporte de los trabajadores Bs)');
        $this->docexcel->getActiveSheet()->setCellValue('D6',0);

        $this->docexcel->getActiveSheet()->setCellValue('A7','4.4.1 Nº total de afiliados al seguro a largo plazo (AFP´s PREVISION)');
        $this->docexcel->getActiveSheet()->setCellValue('B7',$this->resumen['afp_pre']);
        $this->docexcel->getActiveSheet()->setCellValue('C7','4.5.1 Monto aportado (Total aporte de los trabajadores PREVISION)');
        $this->docexcel->getActiveSheet()->setCellValue('D7',0);

        $this->docexcel->getActiveSheet()->setCellValue('A8','4.4.2 Nº total de afiliados al seguro a largo plazo (AFP´s FUTURO)');
        $this->docexcel->getActiveSheet()->setCellValue('B8',$this->resumen['afp_fut']);
        $this->docexcel->getActiveSheet()->setCellValue('C8','4.5.2 Monto aportado (Total aporte de los trabajadores FUTURO)');
        $this->docexcel->getActiveSheet()->setCellValue('D8',0);

        $this->docexcel->getActiveSheet()->setCellValue('A9','5. COMPOSICIÓN SALARIAL');
        $this->docexcel->getActiveSheet()->setCellValue('C9','6. TRABAJADORES');

        $this->docexcel->getActiveSheet()->setCellValue('A11','Concepto');
        $this->docexcel->getActiveSheet()->setCellValue('B11','Monto (Bs)');
        $this->docexcel->getActiveSheet()->setCellValue('D11','Varones');
        $this->docexcel->getActiveSheet()->setCellValue('E11','Mujeres');
        $this->docexcel->getActiveSheet()->setCellValue('F11','Total');

        $this->docexcel->getActiveSheet()->setCellValue('A12','5.1 Promedio Haber básico');
        $this->docexcel->getActiveSheet()->setCellValue('B12',round($this->resumen['promedio_basico'],2));
        $this->docexcel->getActiveSheet()->setCellValue('C12','6.1 Total trabajadores');
        $this->docexcel->getActiveSheet()->setCellValue('D12',$this->resumen['trabajadores_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E12',$this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F12',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A13','5.2 Promedio Bono de antigüedad');
        $this->docexcel->getActiveSheet()->setCellValue('B13',round($this->resumen['promedio_antiguedad'],2));
        $this->docexcel->getActiveSheet()->setCellValue('C13','6.2 Personas jubiladas');
        $this->docexcel->getActiveSheet()->setCellValue('D13',$this->resumen['jubilados_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E13',$this->resumen['jubilados_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F13',$this->resumen['jubilados_mujeres'] + $this->resumen['jubilados_varones']);

        $this->docexcel->getActiveSheet()->setCellValue('A14','5.3 Promedio Sub. de frontera');
        $this->docexcel->getActiveSheet()->setCellValue('B14',round($this->resumen['promedio_frontera'],2));
        $this->docexcel->getActiveSheet()->setCellValue('C14','6.3 Personas extranjeras');
        $this->docexcel->getActiveSheet()->setCellValue('D14',$this->resumen['extranjeros_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E14',$this->resumen['extranjeros_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F14',$this->resumen['extranjeros_varones'] + $this->resumen['extranjeros_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A15','5.4 Promedio Total Ganado');
        $this->docexcel->getActiveSheet()->setCellValue('B15',round($this->resumen['promedio_total'],2));
        $this->docexcel->getActiveSheet()->setCellValue('C15','6.4 Personas con discapacidad');
        $this->docexcel->getActiveSheet()->setCellValue('D15',$this->resumen['discapacitados_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E15',$this->resumen['discapacitados_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F15',$this->resumen['discapacitados_varones'] + $this->resumen['discapacitados_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A16','5.5 Total Ganado Despues de duodecimas');
        $this->docexcel->getActiveSheet()->setCellValue('B16',round($this->resumen['liquido_pagable'],2));
        $this->docexcel->getActiveSheet()->setCellValue('C16','');
        $this->docexcel->getActiveSheet()->setCellValue('D16','');
        $this->docexcel->getActiveSheet()->setCellValue('E16','');
        $this->docexcel->getActiveSheet()->setCellValue('F16','');








        $this->docexcel->getActiveSheet()->setCellValue('C22','');
        $this->docexcel->getActiveSheet()->setCellValue('D22','');
        $this->docexcel->getActiveSheet()->setCellValue('E22','');
        $this->docexcel->getActiveSheet()->setCellValue('F22','');


        $this->docexcel->getActiveSheet()->setCellValue('C23','');
        $this->docexcel->getActiveSheet()->setCellValue('D23','');
        $this->docexcel->getActiveSheet()->setCellValue('E23','');
        $this->docexcel->getActiveSheet()->setCellValue('F23','');


        $this->docexcel->getActiveSheet()->setCellValue('C24','');
        $this->docexcel->getActiveSheet()->setCellValue('D24','');
        $this->docexcel->getActiveSheet()->setCellValue('E24','');
        $this->docexcel->getActiveSheet()->setCellValue('F24','');
    }

    function generarReporte(){
        //echo $this->nombre_archivo; exit;
        // Set active sheet index to the first sheet, so Excel opens this as the first sheet
        $this->docexcel->setActiveSheetIndex(0);

        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }


}

?>