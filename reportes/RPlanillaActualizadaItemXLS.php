<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RPlanillaActualizadaItemXLS
{
    private $docexcel;
    private $objWriter;
    private $nombre_archivo;
    private $hoja;
    private $columnas=array();
    private $gerencias=array();
    private $genero=array();
    private $gerencuaF=array();
    private $fila;
    private $equivalencias=array();

    private $indice, $m_fila, $titulo;
    private $swEncabezado=0; //variable que define si ya se imprimió el encabezado
    private $objParam;
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
    function imprimeCabecera($sheet,$tipo) {
        $this->docexcel->createSheet($sheet);
        $this->docexcel->setActiveSheetIndex($sheet);
        $this->docexcel->getActiveSheet()->setTitle($tipo);
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
                    'rgb' => '#DC143C'
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
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            )
        );
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'Plantilla Actualizada de Item : ' . $this->objParam->getParametro('fecha'));
        $this->docexcel->getActiveSheet()->getStyle('A2:Q2')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->mergeCells('A2:Q2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Gerencia : ' . $this->objParam->getParametro('uo'));
        $this->docexcel->getActiveSheet()->getStyle('A3:Q3')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->mergeCells('A3:Q3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Tipo de Contrato : ' . $this->objParam->getParametro('tipo_contrato'));
        $this->docexcel->getActiveSheet()->getStyle('A4:Q4')->applyFromArray($styleTitulos2);
        $styleTitulos2['fill']['color']['rgb'] = 'D9D9D9';
        $this->docexcel->getActiveSheet()->mergeCells('A4:Q4');

        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(35);
        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->applyFromArray($styleTitulos);

        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A5','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B5','DESCRIPCION DEL NIVEL SALARIAL');
        $this->docexcel->getActiveSheet()->setCellValue('C5','DESCRIPCION DEL CARGO O PUESTO');
        $this->docexcel->getActiveSheet()->setCellValue('D5','ITEM');
        $this->docexcel->getActiveSheet()->setCellValue('E5','NOMBRES Y APELLIDOS');
        $this->docexcel->getActiveSheet()->setCellValue('F5','SEXO');
        $this->docexcel->getActiveSheet()->setCellValue('G5','SALARIO');
        $this->docexcel->getActiveSheet()->setCellValue('H5','BONO');
        $this->docexcel->getActiveSheet()->setCellValue('I5','B. FRONTERA');
        $this->docexcel->getActiveSheet()->setCellValue('J5','TOTAL');
        $this->docexcel->getActiveSheet()->setCellValue('K5','FECHA ');
        $this->docexcel->getActiveSheet()->setCellValue('L5','C.I.');
        $this->docexcel->getActiveSheet()->setCellValue('M5','EXP');
        $this->docexcel->getActiveSheet()->setCellValue('N5','CIUDAD');
        $this->docexcel->getActiveSheet()->setCellValue('O5','OFICINA');
    }
    function generarDatos()
    {

        $this->imprimeCabecera(0,'ADM');




         //*************************************Detalle*****************************************

        $numero = 0;
        $columna = 1;
        $fila = 6;
        $datos = $this->objParam->getParametro('datos');
        $cat= $datos[0]['categoria_programatica'];
        $ger = '';
        $dep = '';
        $sheet = 0;


        foreach($datos as $value) {

                if($value['categoria_programatica'] != $cat ) {
                    $cat = $value['categoria_programatica'];
                    $sheet++;
                    $this->imprimeCabecera($sheet, $cat);
                    $fila = 6;

                }
                if ($value['gerencia'] != $ger) {
                    $this->imprimeSubtitulo($fila,$value['gerencia']);
                    $ger = $value['gerencia'];
                    $fila++;
                }

                if ($value['departamento'] != $dep && $value['departamento'] != $value['gerencia']){
                    $this->imprimeSubtitulo($fila,$value['departamento']);
                    $dep = $value['departamento'];
                    $fila++;
                }

                if (!array_key_exists('codigo_nombre_gerencia',$this->gerencias)) {
                    $this->gerencias[$value['codigo_nombre_gerencia']] = 1;
                } else {
                    $this->gerencias[$value['codigo_nombre_gerencia']]++;
                }
            if (!array_key_exists('genero',$this->genero)) {

                $this->gerencias[$value['genero']] = 1;
            } else {
                $this->gerencias[$value['genero']]++;
            }


                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $columna);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['escala']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['cargo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nro_item']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nombre_funcionario']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['genero']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['haber_basico']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['bono_antiguedad']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['bono_frontera']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['sumatoria']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['fecha_inicio']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['ci']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['expedicion']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['codigo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['nombre']);


                $fila++;
                $columna++;


            //*************************************Fin-Detalle*****************************************


        }
        $sheet++;
        $this->imprimeResumenGerencia($sheet);
        

    }

    function imprimeSubtitulo($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ));

        $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }
    function imprimeResumenGerencia($sheet)
    {
        $this->docexcel->createSheet($sheet );
        $this->docexcel->setActiveSheetIndex($sheet );
        $this->docexcel->getActiveSheet()->setTitle('Resumen');


        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '#DC143C'
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
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '#FFE4C4'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'RESUMEN CANTIDAD DE PERSONAL');
        $this->docexcel->getActiveSheet()->getStyle('A2:B2')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('A2:B2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,2,'MASCULINO');
        $this->docexcel->getActiveSheet()->getStyle('C2:D2')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('C2:D2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,2,'FEMENINO');
        $this->docexcel->getActiveSheet()->getStyle('E2:F2')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('E2:F2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,2,'GLOBALES');
        $this->docexcel->getActiveSheet()->getStyle('G2:H2')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('G2:H2');
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(10);

        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A3','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B3','GERENCIA');
        $this->docexcel->getActiveSheet()->setCellValue('C3','Q');
        $this->docexcel->getActiveSheet()->setCellValue('D3','%');
        $this->docexcel->getActiveSheet()->setCellValue('E3','Q');
        $this->docexcel->getActiveSheet()->setCellValue('F3','%');
        $this->docexcel->getActiveSheet()->setCellValue('G3','Q');
        $this->docexcel->getActiveSheet()->setCellValue('H3','%');
        $this->docexcel->getActiveSheet()->getStyle('A3:H3')->applyFromArray($styleTitulos2);

        //*************************************Detalle*****************************************


        $columna = 1;
        $fila = 4;
        $datos = $this->objParam->getParametro('datos');

        foreach ($this->gerencias as $key => $value){

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $columna);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,$key);
            $fila++;
            $columna++;


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