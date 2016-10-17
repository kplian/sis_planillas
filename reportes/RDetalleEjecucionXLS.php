<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RDetalleEjecucionXLS
{
    private $docexcel;
    private $objWriter;
    private $nombre_archivo;
    private $hoja;
    private $columnas=array();
    private $fila;
    private $equivalencias=array();

    private $indice, $m_fila, $titulo;
    private $swEncabezado=0; //variable que define si ya se imprimió el encabezado
    private $objParam;
    public  $url_archivo;


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

    function imprimeDatos(){
        $this->docexcel->getActiveSheet()->setTitle('EJECUCION');
        $datos = $this->objParam->getParametro('datos');
        $columnas = 0;
        $this->docexcel->setActiveSheetIndex(0);



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


        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);


        $this->docexcel->getActiveSheet()->getStyle('A1:D1')->getAlignment()->setWrapText(true);

        $this->docexcel->getActiveSheet()->getStyle('A1:D1')->applyFromArray($styleTitulos);


        //*************************************Cabecera*****************************************

        $this->docexcel->getActiveSheet()->setCellValue('B1','Planta');
        $this->docexcel->getActiveSheet()->setCellValue('C1','Eventual');
        $this->docexcel->getActiveSheet()->setCellValue('D1','Total');


        //*************************************Detalle*****************************************
        $fila = 2;
        $presupuesto = '';
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
                    'rgb' => 'FFFFFF'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $planta_presupuesto = 0;
        $eventual_presupuesto = 0;

        $planta_total = 0;
        $eventual_total = 0;

        $ultima_columna = '';

        foreach($datos as $value) {
            if ($value['columna'] != $ultima_columna || $presupuesto != $value['codigo_cc']) {
                if ($ultima_columna != ''){
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$total_fila);
                }
                if ($presupuesto != $value['codigo_cc']) {
                    if ($presupuesto != '') {
                        $fila++;

                        $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($styleTitulos);
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'TOTAL');
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$planta_presupuesto);
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$eventual_presupuesto);
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$eventual_presupuesto + $planta_presupuesto);

                        $planta_presupuesto = 0;
                        $eventual_presupuesto = 0;

                    }
                    $fila++;
                    $presupuesto = $value['codigo_cc'];
                    $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($styleTitulos);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$value['codigo_cc']);

                }

                $fila++;
                $ultima_columna = $value['columna'];
                $total_fila = 0;
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$value['columna']);
            }

            if ($value['tipo_contrato'] == 'EVE') {
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$value['ejecutado']);
                $total_fila += $value['ejecutado'];
                $eventual_presupuesto += $value['ejecutado'];
                $eventual_total += $value['ejecutado'];

            } else {

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$value['ejecutado']);
                $total_fila += $value['ejecutado'];
                $planta_presupuesto += $value['ejecutado'];
                $planta_total += $value['ejecutado'];

            }



        }
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$total_fila);
        $fila++;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$total_fila);

        $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'TOTAL');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$planta_presupuesto);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$eventual_presupuesto);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$eventual_presupuesto + $planta_presupuesto);

        $fila++;
        $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'TOTAL PLANILLA');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$planta_total);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$eventual_total);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$eventual_total + $planta_total);



        //************************************************Fin Detalle***********************************************

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