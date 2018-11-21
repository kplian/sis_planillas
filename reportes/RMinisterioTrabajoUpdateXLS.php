<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RMinisterioTrabajoUpdateXLS
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

        $sheetId = 1;
        $this->docexcel->createSheet(NULL, $sheetId);
        $this->docexcel->setActiveSheetIndex($sheetId);
        $this->docexcel->getActiveSheet()->setTitle('OVTPLA-T01');

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
        $this->docexcel->getActiveSheet()->setTitle('OVTPLA-T02');
        $datos = $this->objParam->getParametro('datos');
        $datos_cabecera = $this->objParam->getParametro('datos_cabecera');
        $columnas = 0;
        $this->docexcel->setActiveSheetIndex(0);



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
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(15);
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
        $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AJ')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('AT')->setWidth(25);

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

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ));

        //$this->docexcel->getActiveSheet()->getStyle('A1:L2')->applyFromArray($styleTitulos2);

        /*$this->docexcel->getActiveSheet()->setCellValue('A1','NOMBRE O RAZÓN SOCIAL  :  ' . $datos_cabecera[0]['nombre_entidad']);
        $this->docexcel->getActiveSheet()->setCellValue('A2','Nº IDENTIFICADOR DEL EMPLEADOR ANTE EL MINISTERIO DE TRABAJO  :  ' . $datos_cabecera[0]['identificador_min_trabajo']);
        $this->docexcel->getActiveSheet()->setCellValue('L1','Nº DE NIT  :  ' . $datos_cabecera[0]['nit']);
        $this->docexcel->getActiveSheet()->setCellValue('L2','Nº DE EMPLEADOR (Caja de Salud)  :  ' . $datos_cabecera[0]['identificador_caja_salud']);*/
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ));

        /*$this->docexcel->getActiveSheet()->mergeCells('A4:X4');
        $this->docexcel->getActiveSheet()->getStyle('A4')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->setCellValue('A4','PLANILLA DE SUELDOS');*/

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => false,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ));
        /*$this->docexcel->getActiveSheet()->mergeCells('A5:X5');
        $this->docexcel->getActiveSheet()->getStyle('A5')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->setCellValue('A5','(En Bolivianos)');*/

        $this->docexcel->getActiveSheet()->getStyle('A1:AT1')->getAlignment()->setWrapText(true);

        $this->docexcel->getActiveSheet()->getStyle('A1:AT1')->applyFromArray($styleTitulos);
        $styleTitulos['fill']['color']['rgb'] = '8DB4E2';
        $this->docexcel->getActiveSheet()->getStyle('AT1')->applyFromArray($styleTitulos);
        $styleTitulos['fill']['color']['rgb'] = '8DB4E2';
        $this->docexcel->getActiveSheet()->getStyle('P1:AT1')->applyFromArray($styleTitulos);

        //$this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,0);
        $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,2);
        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A1','Nro');
        $this->docexcel->getActiveSheet()->setCellValue('B1','Tipo de documento de identidad');
        $this->docexcel->getActiveSheet()->setCellValue('C1','Número de documento de identidad');
        $this->docexcel->getActiveSheet()->setCellValue('D1','Lugar de expedición');
        $this->docexcel->getActiveSheet()->setCellValue('E1','Fecha de nacimiento');//M8
        $this->docexcel->getActiveSheet()->setCellValue('F1','Apellido Paterno');//G8
        $this->docexcel->getActiveSheet()->setCellValue('G1','Apellido Materno');//H8
        $this->docexcel->getActiveSheet()->setCellValue('H1','Nombres');//
        $this->docexcel->getActiveSheet()->setCellValue('I1','País de nacionalidad');//
        $this->docexcel->getActiveSheet()->setCellValue('J1','Sexo');
        $this->docexcel->getActiveSheet()->setCellValue('K1','Jubilado');//E8
        $this->docexcel->getActiveSheet()->setCellValue('L1','¿Aporta a la AFP?');
        $this->docexcel->getActiveSheet()->setCellValue('M1','¿Persona con discapacidad?');
        $this->docexcel->getActiveSheet()->setCellValue('N1','Tutor de persona con discapacidad');
        $this->docexcel->getActiveSheet()->setCellValue('O1','Fecha de ingreso');//Cargo, Clasificación laboral
        $this->docexcel->getActiveSheet()->setCellValue('P1','Fecha de retiro');
        $this->docexcel->getActiveSheet()->setCellValue('Q1','Motivo retiro');
        $this->docexcel->getActiveSheet()->setCellValue('R1','Caja de salud');//Modalidad de contrato
        $this->docexcel->getActiveSheet()->setCellValue('S1','AFP a la que aporta');//Horas pagadas (día)
        $this->docexcel->getActiveSheet()->setCellValue('T1','NUA/CUA');//
        $this->docexcel->getActiveSheet()->setCellValue('U1','Sucursal o ubicacion adicional');//Nº de dominicales
        $this->docexcel->getActiveSheet()->setCellValue('V1','Clasificación laboral');//
        $this->docexcel->getActiveSheet()->setCellValue('W1','Cargo');//Horas extra
        $this->docexcel->getActiveSheet()->setCellValue('X1','Modalidad de contrato');//Horas de recargo nocturno
        $this->docexcel->getActiveSheet()->setCellValue('Y1','Tipo contrato');//Horas extra dominicales
        $this->docexcel->getActiveSheet()->setCellValue('Z1','Días pagados');//Haber básico
        $this->docexcel->getActiveSheet()->setCellValue('AA1','Horas pagadas');//Salario dominical
        $this->docexcel->getActiveSheet()->setCellValue('AB1','Haber Básico');//Monto pagado por domingo trabajado
        $this->docexcel->getActiveSheet()->setCellValue('AC1','Bono de antigüedad');//Monto pagado por horas extra
        $this->docexcel->getActiveSheet()->setCellValue('AD1','Horas extra');//Monto pagado por horas nocturnas
        $this->docexcel->getActiveSheet()->setCellValue('AE1','Monto horas extra');//Monto pagado por horas extra dominicales
        $this->docexcel->getActiveSheet()->setCellValue('AF1','Horas recargo nocturno');//Bono de antiguedad
        $this->docexcel->getActiveSheet()->setCellValue('AG1','Monto horas extra nocturnas');//Bono de producción
        $this->docexcel->getActiveSheet()->setCellValue('AH1','Horas extra dominicales');//Subsidio de frontera
        $this->docexcel->getActiveSheet()->setCellValue('AI1','Monto horas extra dominicales');//Otros bonos o pagos
        $this->docexcel->getActiveSheet()->setCellValue('AJ1','Domingos trabajados');//Total ganado
        $this->docexcel->getActiveSheet()->setCellValue('AK1','Monto domingo trabajado');//Aporte a las AFPs
        $this->docexcel->getActiveSheet()->setCellValue('AL1','Nro. Dominicales');//RC-IVA
        $this->docexcel->getActiveSheet()->setCellValue('AM1','Salario dominical');//Otros descuentos
        $this->docexcel->getActiveSheet()->setCellValue('AN1','Bono producción');//Total descuentos
        $this->docexcel->getActiveSheet()->setCellValue('AO1','Subsidio frontera');//Líqido pagable
        $this->docexcel->getActiveSheet()->setCellValue('AP1','Otros bonos y pagos');//Sucursal o ubicación adicional
        $this->docexcel->getActiveSheet()->setCellValue('AQ1','RC-IVA');
        $this->docexcel->getActiveSheet()->setCellValue('AR1','Aporte Caja Salud');
        $this->docexcel->getActiveSheet()->setCellValue('AS1','Aporte AFP');
        $this->docexcel->getActiveSheet()->setCellValue('AT1','Otros descuentos');

        //*************************************Detalle*****************************************
        $numero = 0;
        $columna = 0;
        $fila = 1;
        $this->resumen['basico'] = 0;
        $this->resumen['antiguedad'] = 0;
        $this->resumen['frontera'] = 0;
        $this->resumen['otros_bonos'] = 0;
        $this->resumen['total_ganado'] = 0;
        $this->resumen['afp'] = 0;
        $this->resumen['caja'] = 0;
        $this->resumen['iva'] = 0;
        $this->resumen['otros_descuentos'] = 0;
        $this->resumen['total_descuentos'] = 0;
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

        $this->orden=[];
        $numberFormat = '#0.00;[Red]-##0.00';
        //$this->docexcel->getStyle('AB10:AT1700')->getNumberFormat()->setFormatCode($numberFormat);

        foreach($datos as $value) {

            if ($numero != $value['fila']) {
                $fila++;
                $columna = 0;
                $this->armaResumenRegional($value['lugar'], $value);
                if ($value['sexo']== 'M') {
                    $this->resumen['trabajadores_varones']++;
                    if ($value['jubilado']== 1) {
                        $this->resumen['jubilados_varones']++;
                    }

                    if ($value['nacionalidad']!= 'Bolivia') {
                        $this->resumen['extranjeros_varones']++;
                    }

                    if ($value['discapacitado']== 1) {
                        $this->resumen['discapacitados_varones']++;
                    }

                    if ($value['contrato_periodo']== 'si') {
                        $this->resumen['contrato_varones']++;
                    }

                    if ($value['retiro_periodo']== 'si') {
                        $this->resumen['retiro_varones']++;
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
                    if ($value['discapacitado']== 1) {
                        $this->resumen['discapacitados_mujeres']++;
                    }

                    if ($value['contrato_periodo']== 'si') {
                        $this->resumen['contrato_mujeres']++;
                    }

                    if ($value['retiro_periodo']== 'si') {
                        $this->resumen['retiro_mujeres']++;
                    }
                }
                foreach ($value as $key => $val) {

                    if ($key != 'codigo_columna' /*&& $key != 'valor' && $key != 'oficina' && $key != 'discapacitado'*/ && $key != 'contrato_periodo' && $key != 'retiro_periodo'
                        && $key != 'edad'&& $key != 'lugar'){
                        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$val);
                        $columna++;
                    }
                }
                $numero = $value['fila'];

            }

            if ($value['codigo_columna'] == 'BONFRONTERA') {
                $this->resumen['frontera'] = $this->resumen['frontera'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'SUELDOBA') {
                $this->resumen['basico'] = $this->resumen['basico'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'BONANT') {
                $this->resumen['antiguedad'] = $this->resumen['antiguedad'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'REINBANT') {
                $this->resumen['otros_bonos'] = $this->resumen['otros_bonos'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'COTIZABLE') {
                $this->resumen['total_ganado'] = $this->resumen['total_ganado'] + $value['valor'];
                $this->resumen_regional[$value['lugar']]['total_ganado'] = $this->resumen_regional[$value['lugar']]['total_ganado'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'AFP_LAB') {
                $this->resumen['afp'] = $this->resumen['afp'] + $value['valor'];
                $this->resumen_regional[$value['lugar']]['afp'] = $this->resumen_regional[$value['lugar']]['afp'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'IMPURET') {
                $this->resumen['iva'] = $this->resumen['iva'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'OTRO_DESC') {
                $this->resumen['otros_descuentos'] = $this->resumen['otros_descuentos'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'TOT_DESC') {
                $this->resumen['total_descuentos'] = $this->resumen['total_descuentos'] + $value['valor'];
            }
            if ($value['codigo_columna'] == 'LIQPAG') {
                $this->resumen['liquido_pagable'] = $this->resumen['liquido_pagable'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'CAJSAL') {
                $this->resumen_regional[$value['lugar']]['caja'] = $this->resumen_regional[$value['lugar']]['caja'] + $value['valor'];
                $this->resumen['caja'] = $this->resumen['caja'] + $value['valor'];
            }

            if ($value['codigo_columna'] == 'SUELDOBA' || $value['codigo_columna'] == 'BONANT' || $value['codigo_columna'] == 'BONFRONTERA' ||
                $value['codigo_columna'] == 'AFP_LAB' || $value['codigo_columna'] == 'CAJSAL' || $value['codigo_columna'] == 'IMPURET' ||
                $value['codigo_columna'] == 'OTRO_DESC') {

                if($value['codigo_columna'] == 'SUELDOBA' || $value['codigo_columna'] == 'BONANT' || $value['codigo_columna'] == 'BONFRONTERA') {

                    if($value['codigo_columna'] == 'SUELDOBA'){
                        $this->docexcel->getActiveSheet()->getStyle('AB'.$fila)->getNumberFormat()->setFormatCode($numberFormat);
                    }else if($value['codigo_columna'] == 'BONANT'){
                        $this->docexcel->getActiveSheet()->getStyle('AC'.$fila)->getNumberFormat()->setFormatCode($numberFormat);
                    }else if($value['codigo_columna'] == 'BONFRONTERA'){
                        $this->docexcel->getActiveSheet()->getStyle('AO'.$fila)->getNumberFormat()->setFormatCode($numberFormat);
                    }
                    $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna, $fila, $value['valor']);
                    $columna++;
                }else{

                    if($value['codigo_columna'] == 'AFP_LAB') {
                        $this->orden[2] = $value['valor'];
                    }else if($value['codigo_columna'] == 'CAJSAL'){
                        $this->orden[1] = $value['valor'];
                    }else if($value['codigo_columna'] == 'IMPURET'){
                        $this->orden[0] = $value['valor'];
                    }else if($value['codigo_columna'] == 'OTRO_DESC'){
                        $this->orden[3] = $value['valor'];
                        for($i = 0;$i<count($this->orden);$i++){
                            // var_dump($i.'======>'.$this->orden[$i].'col:'.$columna.'row:'.$fila."\n");
                            if($i == 0){
                                $this->docexcel->getActiveSheet()->getStyle('AQ'.$fila)->getNumberFormat()->setFormatCode($numberFormat);
                            }else if($i==1){
                                $this->docexcel->getActiveSheet()->getStyle('AR'.$fila)->getNumberFormat()->setFormatCode($numberFormat);
                            }else if($i==2){
                                $this->docexcel->getActiveSheet()->getStyle('AS'.$fila)->getNumberFormat()->setFormatCode($numberFormat);
                            }else if($i==3){
                                $this->docexcel->getActiveSheet()->getStyle('AT'.$fila)->getNumberFormat()->setFormatCode($numberFormat);
                            }
                            $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna, $fila, $this->orden[$i]);
                            $columna++;
                        }
                    }
                }
            }

            if ($columna == 29) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }

            if ($columna == 30) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 31) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 32) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 33) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 34) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 35) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 36) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 37) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 38) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
            if ($columna == 39) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }

            if ($columna == 41) {
                $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }
        }


        //************************************************Fin Detalle***********************************************
    }

    /*function imprimeDatosSueldoReducido(){

        $datos = $this->objParam->getParametro('datos');
        $columnas = 0;
        $this->docexcel->setActiveSheetIndex(1);
        //reducido menos 23,24,26,27,29,30,32,33
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
        $this->docexcel->getActiveSheet()->getStyle('A1:AH1')->getAlignment()->setWrapText(true);

        $this->docexcel->getActiveSheet()->getStyle('A1:N1')->applyFromArray($styleTitulos);
        $styleTitulos['fill']['color']['rgb'] = '8DB4E2';
        $this->docexcel->getActiveSheet()->getStyle('O1')->applyFromArray($styleTitulos);
        $styleTitulos['fill']['color']['rgb'] = 'FFFFFF';
        $this->docexcel->getActiveSheet()->getStyle('P1:AH1')->applyFromArray($styleTitulos);
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
        $this->docexcel->getActiveSheet()->setCellValue('U1','Horas pagadas (día)');
        $this->docexcel->getActiveSheet()->setCellValue('V1','Días pagados (mes)');
        $this->docexcel->getActiveSheet()->setCellValue('W1','Horas extra');
        $this->docexcel->getActiveSheet()->setCellValue('X1','Haber básico');
        $this->docexcel->getActiveSheet()->setCellValue('Y1','Monto pagado por horas extra');
        $this->docexcel->getActiveSheet()->setCellValue('Z1','Bono de antiguedad');
        $this->docexcel->getActiveSheet()->setCellValue('AA1','Otros bonos o pagos');
        $this->docexcel->getActiveSheet()->setCellValue('AB1','Total ganado');
        $this->docexcel->getActiveSheet()->setCellValue('AC1','Aporte a las AFPs');
        $this->docexcel->getActiveSheet()->setCellValue('AD1','RC-IVA');
        $this->docexcel->getActiveSheet()->setCellValue('AE1','Otros descuentos');
        $this->docexcel->getActiveSheet()->setCellValue('AF1','Total descuentos');
        $this->docexcel->getActiveSheet()->setCellValue('AG1','Líqido pagable');
        $this->docexcel->getActiveSheet()->setCellValue('AH1','Sucursal o ubicación adicional');




        //*************************************Detalle*****************************************
        $numero = 0;
        $columna = 0;
        $fila = 1;

        foreach($datos as $value) {

            if ($numero != $value['fila']) {
                $fila++;
                $columna = 0;
                foreach ($value as $key => $val) {
                    if ($key != 'codigo_columna' && $key != 'valor'&& $key != 'oficina'&& $key != 'discapacitado'&& $key != 'contrato_periodo'&& $key != 'retiro_periodo'
                        && $key != 'edad'&& $key != 'lugar') {
                        $this->docexcel->setActiveSheetIndex(1)->setCellValueByColumnAndRow($columna,$fila,$val);
                        $columna++;
                    }
                }
                $numero = $value['fila'];

            }

            if ($value['codigo_columna'] != 'BONFRONTERA' && $value['codigo_columna'] != 'CAJSAL') {
                $this->docexcel->setActiveSheetIndex(1)->setCellValueByColumnAndRow($columna,$fila,$value['valor']);
                $columna++;
            }

            if ($columna == 22) {
                $this->docexcel->setActiveSheetIndex(1)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }

            if ($columna == 24) {
                $this->docexcel->setActiveSheetIndex(1)->setCellValueByColumnAndRow($columna,$fila,0);
                $columna++;
            }

            if ($columna == 33) {
                $this->docexcel->setActiveSheetIndex(1)->setCellValueByColumnAndRow($columna,$fila,$value['oficina']);
                $columna++;
            }
        }
        //************************************************Fin Detalle***********************************************
    }*/
    function imprimeResumenRegional(){
        $sheetId = 3;
        $this->docexcel->createSheet(NULL, $sheetId);
        $this->docexcel->setActiveSheetIndex($sheetId);
        $this->docexcel->getActiveSheet()->setTitle('Resumen Regional');

        $this->docexcel->setActiveSheetIndex(3);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);

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

        $this->docexcel->getActiveSheet()->getStyle('A1:K1')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A1:A16')->applyFromArray($styleTitulos);

        $this->docexcel->getActiveSheet()->setCellValue('A2','# TOTAL TRABAJADORES');
        $this->docexcel->getActiveSheet()->setCellValue('A3','# HOMBRES');
        $this->docexcel->getActiveSheet()->setCellValue('A4','# MUJERES');
        $this->docexcel->getActiveSheet()->setCellValue('A5','# EXTRANJEROS');
        $this->docexcel->getActiveSheet()->setCellValue('A6','# TRABAJADORES FIJOS');
        $this->docexcel->getActiveSheet()->setCellValue('A7','# TRABAJADORES EVENTUALES');
        $this->docexcel->getActiveSheet()->setCellValue('A8','MENORES 18 AÑOS');
        $this->docexcel->getActiveSheet()->setCellValue('A9','MAYORES 60 AÑOS');
        $this->docexcel->getActiveSheet()->setCellValue('A10','PERSONAL TRABAJANDO JUBILADO');
        $this->docexcel->getActiveSheet()->setCellValue('A11','PERSONAL CON CAPACIDADES DIFERENTES');
        $this->docexcel->getActiveSheet()->setCellValue('A12','TOTAL GANADO EN LA PLANILLA');
        $this->docexcel->getActiveSheet()->setCellValue('A13','# ASEGURADOS EN CAJA DE SALUD');
        $this->docexcel->getActiveSheet()->setCellValue('A14','MONTO APORTADO EN BS.');
        $this->docexcel->getActiveSheet()->setCellValue('A15','# ASEGURADOS AFP');
        $this->docexcel->getActiveSheet()->setCellValue('A16','MONTO APORTADO AFP');
        $this->docexcel->getActiveSheet()->setCellValue('A1','ITEM');

        $columna = 1;
        foreach ($this->resumen_regional as $key => $value) {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,1,$key);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,2,$value['varones'] + $value['mujeres']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,3,$value['varones']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,4,$value['mujeres']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,5,$value['extranjeros']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,6,$value['varones'] + $value['mujeres']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,7,0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,8,$value['menores_18']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,9,$value['mayores_60']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,10,$value['jubilados']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,11,$value['discapacitados']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,12,$value['total_ganado']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,13,$value['varones'] + $value['mujeres']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,14,$value['caja']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,15,$value['varones'] + $value['mujeres']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,16,$value['afp']);
            $columna++;
        }


    }
    function imprimeResumen(){
        $sheetId = 2;
        $this->docexcel->createSheet(NULL, $sheetId);
        $this->docexcel->setActiveSheetIndex($sheetId);
        $this->docexcel->getActiveSheet()->setTitle('Resumen');

        $this->docexcel->setActiveSheetIndex(2);

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
                    'rgb' => 'c5d9f1'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->docexcel->getActiveSheet()->getStyle('A1:F1')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A5:C5')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A8:F8')->applyFromArray($styleTitulos);

        $this->docexcel->getActiveSheet()->getStyle('C16:D16')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('D18:F18')->applyFromArray($styleTitulos);

        $this->docexcel->getActiveSheet()->setCellValue('A1','Seguro social a corto plazo');

        $this->docexcel->getActiveSheet()->setCellValue('A2','4.1.1 N°asegurados al ente gestor');
        $this->docexcel->getActiveSheet()->setCellValue('B2',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('C2','4.2.1 monto aportado');
        $this->docexcel->getActiveSheet()->setCellValue('D2',$this->resumen['caja']);
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
        $this->docexcel->getActiveSheet()->setCellValue('D6',$this->resumen['afp']);

        $this->docexcel->getActiveSheet()->setCellValue('A8','5. COMPOSICIÓN SALARIAL');
        $this->docexcel->getActiveSheet()->setCellValue('C8','6. TRABAJADORES');

        $this->docexcel->getActiveSheet()->setCellValue('A10','Concepto');
        $this->docexcel->getActiveSheet()->setCellValue('B10','Monto (Bs)');
        $this->docexcel->getActiveSheet()->setCellValue('D10','Varones');
        $this->docexcel->getActiveSheet()->setCellValue('E10','Mujeres');
        $this->docexcel->getActiveSheet()->setCellValue('F10','Total');

        $this->docexcel->getActiveSheet()->setCellValue('A11','5.1 Haber básico');
        $this->docexcel->getActiveSheet()->setCellValue('B11',$this->resumen['basico']);
        $this->docexcel->getActiveSheet()->setCellValue('C11','6.1 Total trabajadores');
        $this->docexcel->getActiveSheet()->setCellValue('D11',$this->resumen['trabajadores_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E11',$this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F11',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A12','5.2 Bono de antigüedad');
        $this->docexcel->getActiveSheet()->setCellValue('B12',$this->resumen['antiguedad']);
        $this->docexcel->getActiveSheet()->setCellValue('C12','6.2 Personas jubiladas');
        $this->docexcel->getActiveSheet()->setCellValue('D12',$this->resumen['jubilados_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E12',$this->resumen['jubilados_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F12',$this->resumen['jubilados_mujeres'] + $this->resumen['jubilados_varones']);

        $this->docexcel->getActiveSheet()->setCellValue('A13','5.3 Bono de producción');
        $this->docexcel->getActiveSheet()->setCellValue('B13',0);
        $this->docexcel->getActiveSheet()->setCellValue('C13','6.3 Personas extranjeras');
        $this->docexcel->getActiveSheet()->setCellValue('D13',$this->resumen['extranjeros_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E13',$this->resumen['extranjeros_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F13',$this->resumen['extranjeros_varones'] + $this->resumen['extranjeros_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A14','5.4 Subsidio de frontera');
        $this->docexcel->getActiveSheet()->setCellValue('B14',$this->resumen['frontera']);
        $this->docexcel->getActiveSheet()->setCellValue('C14','6.4 Personas con discapacidad');
        $this->docexcel->getActiveSheet()->setCellValue('D14',$this->resumen['discapacitados_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E14',$this->resumen['discapacitados_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F14',$this->resumen['discapacitados_varones'] + $this->resumen['discapacitados_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A15','5.5 Trabajo extraordinario y nocturno');
        $this->docexcel->getActiveSheet()->setCellValue('B15',0);
        $this->docexcel->getActiveSheet()->setCellValue('C15','');
        $this->docexcel->getActiveSheet()->setCellValue('D15','');
        $this->docexcel->getActiveSheet()->setCellValue('E15','');
        $this->docexcel->getActiveSheet()->setCellValue('F15','');

        $this->docexcel->getActiveSheet()->setCellValue('A16','5.6 Pago dominical y domingo trabajado');
        $this->docexcel->getActiveSheet()->setCellValue('B16',0);
        $this->docexcel->getActiveSheet()->setCellValue('C16','7. INFORMACIÓN TRIMESTRAL, ACCIDENTES Y ENFERMEDADES DE TRABAJO');
        $this->docexcel->getActiveSheet()->setCellValue('D16','');
        $this->docexcel->getActiveSheet()->setCellValue('E16','');
        $this->docexcel->getActiveSheet()->setCellValue('F16','');

        $this->docexcel->getActiveSheet()->setCellValue('A17','5.7 Otros bonos');
        $this->docexcel->getActiveSheet()->setCellValue('B17',$this->resumen['otros_bonos']);
        $this->docexcel->getActiveSheet()->setCellValue('C17','');
        $this->docexcel->getActiveSheet()->setCellValue('D17','');
        $this->docexcel->getActiveSheet()->setCellValue('E17','');
        $this->docexcel->getActiveSheet()->setCellValue('F17','');

        $this->docexcel->getActiveSheet()->setCellValue('A18','5.8 Total ganado');
        $this->docexcel->getActiveSheet()->setCellValue('B18',$this->resumen['total_ganado']);
        $this->docexcel->getActiveSheet()->setCellValue('C18','');
        $this->docexcel->getActiveSheet()->setCellValue('D18','Varones');
        $this->docexcel->getActiveSheet()->setCellValue('E18','Mujeres');
        $this->docexcel->getActiveSheet()->setCellValue('F18','Total');

        $this->docexcel->getActiveSheet()->setCellValue('A19','5.9 Aporte a las AFPs');
        $this->docexcel->getActiveSheet()->setCellValue('B19',$this->resumen['afp']);
        $this->docexcel->getActiveSheet()->setCellValue('C19','7.1 Personas contratadas en el trimestre');
        $this->docexcel->getActiveSheet()->setCellValue('D19',$this->resumen['contrato_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E19',$this->resumen['contrato_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F19',$this->resumen['contrato_varones'] + $this->resumen['contrato_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A20','5.10 RC-IVA');
        $this->docexcel->getActiveSheet()->setCellValue('B20',$this->resumen['iva']);
        $this->docexcel->getActiveSheet()->setCellValue('C20','7.2 Personas retiradas en el trimestre');
        $this->docexcel->getActiveSheet()->setCellValue('D20',$this->resumen['retiro_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E20',$this->resumen['retiro_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F20',$this->resumen['retiro_varones'] + $this->resumen['retiro_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A21','5.11 Otros descuentos');
        $this->docexcel->getActiveSheet()->setCellValue('B21',$this->resumen['otros_descuentos']);
        $this->docexcel->getActiveSheet()->setCellValue('C21','');
        $this->docexcel->getActiveSheet()->setCellValue('D21','');
        $this->docexcel->getActiveSheet()->setCellValue('E21','');
        $this->docexcel->getActiveSheet()->setCellValue('F21','');

        $this->docexcel->getActiveSheet()->setCellValue('A22','5.12 Total descuentos');
        $this->docexcel->getActiveSheet()->setCellValue('B22',$this->resumen['total_descuentos']);
        $this->docexcel->getActiveSheet()->setCellValue('C22','');
        $this->docexcel->getActiveSheet()->setCellValue('D22','');
        $this->docexcel->getActiveSheet()->setCellValue('E22','');
        $this->docexcel->getActiveSheet()->setCellValue('F22','');

        $this->docexcel->getActiveSheet()->setCellValue('A23','5.13 Líquido pagable');
        $this->docexcel->getActiveSheet()->setCellValue('B23',$this->resumen['liquido_pagable']);
        $this->docexcel->getActiveSheet()->setCellValue('C23','');
        $this->docexcel->getActiveSheet()->setCellValue('D23','');
        $this->docexcel->getActiveSheet()->setCellValue('E23','');
        $this->docexcel->getActiveSheet()->setCellValue('F23','');
    }
    function armaResumenRegional($lugar, $value){
        if (!array_key_exists($lugar, $this->resumen_regional)) {
            $this->resumen_regional[$lugar]['varones'] = 0;
            $this->resumen_regional[$lugar]['mujeres'] = 0;
            $this->resumen_regional[$lugar]['mayores_60'] = 0;
            $this->resumen_regional[$lugar]['menores_18'] = 0;
            $this->resumen_regional[$lugar]['jubilados'] = 0;
            $this->resumen_regional[$lugar]['extranjeros'] = 0;
            $this->resumen_regional[$lugar]['discapacitados'] = 0;
            $this->resumen_regional[$lugar]['total_ganado'] = 0;
            $this->resumen_regional[$lugar]['afp'] = 0;
            $this->resumen_regional[$lugar]['caja'] = 0;
        }
        if ($value['sexo']== 'M') {
            $this->resumen_regional[$lugar]['varones']++;
        } else {
            $this->resumen_regional[$lugar]['mujeres']++;
        }

        if ($value['edad'] > 60) {
            $this->resumen_regional[$lugar]['mayores_60']++;
        }

        if ($value['edad'] < 18) {
            $this->resumen_regional[$lugar]['menores_18']++;
        }

        if ($value['jubilado']== 1) {
            $this->resumen_regional[$lugar]['jubilados']++;
        }

        if ($value['nacionalidad']!= 'Bolivia') {
            $this->resumen_regional[$lugar]['extranjeros']++;
        }

        if ($value['discapacitado']== 1) {
            $this->resumen_regional[$lugar]['discapacitados']++;
        }
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