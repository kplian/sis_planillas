<?php
class RGeneralPlanillaXLS
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    var $datos_detalle;
    var $datos_titulo;
    public  $url_archivo;
    function __construct(CTParametro $objParam)
    {
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


        $this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
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

    public function addHoja($name,$index){
        //$index = $this->docexcel->getSheetCount();
        //echo($index);
        $this->docexcel->createSheet($index)->setTitle($name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function imprimeCabecera() {
        /*$this->docexcel->createSheet(0);
        $this->docexcel->setActiveSheetIndex(0);
        $this->docexcel->getActiveSheet()->setTitle('Detalle');*/

        /*$this->docexcel->createSheet(1);
        $this->docexcel->setActiveSheetIndex(1);
        $this->docexcel->getActiveSheet()->setTitle('Totales');

        $this->docexcel->setActiveSheetIndex(0);*/




        /*$styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );


        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),

        );*/

        //titulos

        /*$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'BOLIVIANA DE AVIACIÓN - BOA' );
        $this->docexcel->getActiveSheet()->getStyle('A2:H2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:H2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Bienes de Consumo' );
        $this->docexcel->getActiveSheet()->getStyle('A3:H3')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A3:H3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'AL: '. $this->obtenerFechaEnLetra($this->objParam->getParametro('fecha_hasta')));
        $this->docexcel->getActiveSheet()->getStyle('A4:H4')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A4:H4');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'(Expresado en Bolivianos)' );
        $this->docexcel->getActiveSheet()->getStyle('A5:H5')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A5:H5');*/

        /*$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);*/



    }

    function generarDatos()
    {
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '626eba'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '3287c1'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->numero = 1;
        $fila = 2;
        $datos = $this->objParam->getParametro('datos');//var_dump($datos);exit;
        //subtotales
        $estacion = '';
        $contadorCostoGrupo = 0;
        $contadorCostoTotal = 0;
        $this->imprimeCabecera(0);

        $numberFormat = '#,##0.00';
        $cant_datos = count($datos);
        $cont_total = 1;
        $fila_total = 1;
       // $this->addHoja('Resumen',0);
        $index = 0;
        $color_pestana = array('ff0000','1100ff','55ff00','3ba3ff','ff4747','697dff','78edff','ba8cff',
            'ff80bb','ff792b','ffff5e','52ff97','bae3ff','ffaf9c','bfffc6','b370ff','ffa8b4','7583ff','9aff17','ff30c8');
        $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,2);
        foreach ($datos as $value)
        {

            if($estacion != $value['codigo']){
                $this->addHoja($value['codigo'],$index);
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
                $this->docexcel->getActiveSheet()->getStyle('A1:J1')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A1:J1')->applyFromArray($styleTitulos3);
                $fila=2;
                $this->numero=1;
                $this->docexcel->getActiveSheet()->setTitle($value['codigo']);
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(35);//gerencia
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);//contrato
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(40);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(40);//documento
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(35);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);//correo
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(30);//correo_personal
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(25);//telefonos
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(25);//celulares

                $this->docexcel->getActiveSheet()->setCellValue('A1','Nro');
                $this->docexcel->getActiveSheet()->setCellValue('B1','Gerencia');
                $this->docexcel->getActiveSheet()->setCellValue('C1','Tipo Contrato');
                $this->docexcel->getActiveSheet()->setCellValue('D1','Funcionario');
                $this->docexcel->getActiveSheet()->setCellValue('E1','Documento');
                $this->docexcel->getActiveSheet()->setCellValue('F1','Cargo');
                $this->docexcel->getActiveSheet()->setCellValue('G1','Correo BoA');
                $this->docexcel->getActiveSheet()->setCellValue('H1','Correo Personal');
                $this->docexcel->getActiveSheet()->setCellValue('I1','Telefonos');
                $this->docexcel->getActiveSheet()->setCellValue('J1','Celulares');

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['gerencia']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['contrato']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_funcionario']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['documento']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['cargo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['email_empresa']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['correo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['telefonos']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['celulares']);
                $fila++;
                $this->numero++;
                $index++;

            }else {

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['gerencia']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['contrato']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_funcionario']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['documento']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['cargo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['email_empresa']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['correo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['telefonos']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['celulares']);
                $fila++;
                $this->numero++;
            }



            $estacion = $value['codigo'];
        }

        $this->addHoja('Resumen',$index);

        $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
        $this->docexcel->getActiveSheet()->getStyle('A1:K1')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A1:K1')->applyFromArray($styleTitulos3);
        $fila=2;
        $this->numero=1;
        $this->docexcel->getActiveSheet()->setTitle('Resumen');
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(35);//gerencia
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);//contrato
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(40);//funcionario
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(40);//documento
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(35);//cargo
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);//correo
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(30);//correo_personal
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(25);//telefonos
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(25);//celulares
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(25);//celulares

        $this->docexcel->getActiveSheet()->setCellValue('A1','Nro');
        $this->docexcel->getActiveSheet()->setCellValue('B1','Gerencia');
        $this->docexcel->getActiveSheet()->setCellValue('C1','Tipo Contrato');
        $this->docexcel->getActiveSheet()->setCellValue('D1','Funcionario');
        $this->docexcel->getActiveSheet()->setCellValue('E1','Documento');
        $this->docexcel->getActiveSheet()->setCellValue('F1','Cargo');
        $this->docexcel->getActiveSheet()->setCellValue('G1','Correo BoA');
        $this->docexcel->getActiveSheet()->setCellValue('H1','Correo Personal');
        $this->docexcel->getActiveSheet()->setCellValue('I1','Telefonos');
        $this->docexcel->getActiveSheet()->setCellValue('J1','Celulares');
        $this->docexcel->getActiveSheet()->setCellValue('K1','Lugar Trabajo');

        foreach ($datos as $value)
        {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['gerencia']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['contrato']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_funcionario']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['documento']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['cargo']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['email_empresa']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['correo']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['telefonos']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['celulares']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['lugar_trabajo']);
            $fila++;
            $this->numero++;
        }


    }
    function obtenerFechaEnLetra($fecha){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $dia= date("d", strtotime($fecha));
        $anno = date("Y", strtotime($fecha));
        // var_dump()
        $mes = array('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre');
        $mes = $mes[(date('m', strtotime($fecha))*1)-1];
        return $dia.' de '.$mes.' del '.$anno;
    }
    function generarReporte(){
        $this->generarDatos();
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        //$this->imprimeCabecera(0);

    }

}
?>