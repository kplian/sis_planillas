<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RPlanillaActualizadaItemXLS
{
    private $docexcel;
    private $objWriter;
    private $hoja;
    private $columnas=array();
    private $gerenciasPLA=array();
    private $gerenciasEVE=array();
    private $numero;
    private $gerenciaMasPLA=array();
    private $gerenciaMasEVE=array();
    private $gerenciaFemPLA=array();
    private $gerenciaFemEVE=array();
    private $empleadosOficinaPLA=array();
    private $empleadosOficinaEVE=array();
    private $ciudadesOfiPLA=array();
    private $ciudadesOfiEVE=array();
    private $fila;
    private $equivalencias=array();
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
                    'rgb' => 'C0C0C0 '
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
            ),
             $styleTitulos8 = array(
                 'font'  => array(
                     'bold'  => true,
                     'size'  => 11,
                     'name'  => 'Arial',
                     'color' => array('rgb' => 'FFFFFF')

                 ),
                 'alignment' => array(
                     'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                     'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
                 ),
                 'fill' => array(
                     'type' => PHPExcel_Style_Fill::FILL_SOLID,
                     'color' => array(
                         'rgb' => '003366'
                     )
                 )
             ),
            $styleTitulos3 = array(
                'font'  => array(
                    'size'  => 11,
                    'name'  => 'Arial'
                ),
                'alignment' => array(
                    'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                    'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
                ),
            )
        );

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'Plantilla Actualizada de Item : ' . $this->objParam->getParametro('fecha'));
        $this->docexcel->getActiveSheet()->getStyle('A2:P2')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->mergeCells('A2:P2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Agrupado por : ' . $this->objParam->getParametro('agrupar_por'));
        $this->docexcel->getActiveSheet()->getStyle('A3:P3')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A3:P3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Gerencia : ' . $this->objParam->getParametro('uo'));
        $this->docexcel->getActiveSheet()->getStyle('A4:P4')->applyFromArray($styleTitulos8);
        $this->docexcel->getActiveSheet()->mergeCells('A4:P4');
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(55);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(8);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(47);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(8);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(25);
        $this->docexcel->getActiveSheet()->getStyle('A5:P5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:P5')->applyFromArray($styleTitulos);

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
        $this->docexcel->getActiveSheet()->setCellValue('P5','FECHA FIN');
    }

    function generarDatos($agrupar)
    {
        $styleTitulos10 = array(
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FFFF99'
                )
            )
        );

        //*************************************Detalle*****************************************
        $this->numero = 1;
        $fila = 6;
        $datos = $this->objParam->getParametro('datos');
        $cat= $datos[0]['categoria_programatica'];
        $ger = '';
        $dep = '';
        $reg= '';
        $ofi= '';
        $sheet = 0;
        $this->imprimeCabecera(0, $cat);
        foreach($datos as $value) {

                if($value['categoria_programatica'] != $cat ) {
                    $cat = $value['categoria_programatica'];
                    $sheet++;
                    $this->imprimeCabecera($sheet, $cat);
                    $fila = 6;

                }
                if ($agrupar == 'Organigrama'){
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

                } elseif ($agrupar == 'Regional'){
                if ($value['codigo'] != $reg) {
                    $this->imprimeSubtitulo($fila,$value['codigo']);
                    $reg = $value['codigo'];
                    $fila++;
                   }

                 } elseif ($agrupar == 'Regional oficina'){
                        if ($value['codigo'] != $reg) {
                        $this->imprimeSubtitulo($fila,$value['codigo']);
                        $reg = $value['codigo'];
                        $fila++;}

                        if ($value['nombre'] != $ofi && $value['nombre'] != $value['codigo']){
                            $this->imprimeSubtitulo($fila,$value['nombre']);
                            $ofi = $value['nombre'];
                            $fila++;
                        }
                 }

                 if($value['nombre_funcionario'] != 'ACEFALO') {

                    if($value['nro_item'] == '0' ){
                        if (!array_key_exists($value['codigo_nombre_gerencia'], $this->gerenciasEVE)) {

                            $this->gerenciasEVE[$value['codigo_nombre_gerencia']] = 1;
                        } else {

                            $this->gerenciasEVE[$value['codigo_nombre_gerencia']]++;
                        }
                    } else {
                        if (!array_key_exists($value['codigo_nombre_gerencia'], $this->gerenciasPLA)) {

                            $this->gerenciasPLA[$value['codigo_nombre_gerencia']] = 1;
                        } else {

                            $this->gerenciasPLA[$value['codigo_nombre_gerencia']]++;
                        }
                    }
                }
                if ($value['genero']=='M') {
                    if($value['nro_item'] == '0' ){
                        if (!array_key_exists($value['codigo_nombre_gerencia'], $this->gerenciaMasEVE)) {

                            $this->gerenciaMasEVE[$value['codigo_nombre_gerencia']] = 1;
                        } else {

                            $this->gerenciaMasEVE[$value['codigo_nombre_gerencia']]++;
                        }

                    } else {
                        if (!array_key_exists($value['codigo_nombre_gerencia'], $this->gerenciaMasPLA)) {

                            $this->gerenciaMasPLA[$value['codigo_nombre_gerencia']] = 1;
                        } else {

                            $this->gerenciaMasPLA[$value['codigo_nombre_gerencia']]++;
                        }
                    }
                }
                if ($value['genero']=='F') {
                    if($value['nro_item'] == '0' ){
                        if (!array_key_exists($value['codigo_nombre_gerencia'], $this->gerenciaFemEVE)) {
                            $this->gerenciaFemEVE[$value['codigo_nombre_gerencia']] = 1;
                        } else {

                            $this->gerenciaFemEVE[$value['codigo_nombre_gerencia']]++;
                        }

                    }else{
                        if (!array_key_exists($value['codigo_nombre_gerencia'], $this->gerenciaFemPLA)) {
                            $this->gerenciaFemPLA[$value['codigo_nombre_gerencia']] = 1;
                        } else {

                            $this->gerenciaFemPLA[$value['codigo_nombre_gerencia']]++;
                        }
                    }
                }

                if($value['nombre_funcionario'] != 'ACEFALO') {
                    if($value['nro_item'] == '0' ){
                        if (!array_key_exists($value['codigo_nombre_gerencia'], $this->empleadosOficinaEVE) ||
                            !array_key_exists($value['codigo'], $this->empleadosOficinaEVE[$value['codigo_nombre_gerencia']]) ||
                            !array_key_exists($value['nombre'], $this->empleadosOficinaEVE[$value['codigo_nombre_gerencia']][$value['codigo']])
                        ) {
                            $this->empleadosOficinaEVE[$value['codigo_nombre_gerencia']][$value['codigo']][$value['nombre']] = 1;
                        } else {
                            $this->empleadosOficinaEVE[$value['codigo_nombre_gerencia']][$value['codigo']][$value['nombre']]++;
                        }
                        if (!array_key_exists($value['codigo'], $this->ciudadesOfiEVE) ||
                            !array_key_exists($value['nombre'], $this->ciudadesOfiEVE[$value['codigo']]))
                        {
                            $this->ciudadesOfiEVE[$value['codigo']][$value['nombre']] = 1;
                        }
                    }
                        else{
                            if (!array_key_exists($value['codigo_nombre_gerencia'], $this->empleadosOficinaPLA) ||
                                !array_key_exists($value['codigo'], $this->empleadosOficinaPLA[$value['codigo_nombre_gerencia']]) ||
                                !array_key_exists($value['nombre'], $this->empleadosOficinaPLA[$value['codigo_nombre_gerencia']][$value['codigo']])
                            ) {
                                $this->empleadosOficinaPLA[$value['codigo_nombre_gerencia']][$value['codigo']][$value['nombre']] = 1;
                            } else {
                                $this->empleadosOficinaPLA[$value['codigo_nombre_gerencia']][$value['codigo']][$value['nombre']]++;
                            }
                            if (!array_key_exists($value['codigo'], $this->ciudadesOfiPLA) ||
                                !array_key_exists($value['nombre'], $this->ciudadesOfiPLA[$value['codigo']]))
                            {
                                $this->ciudadesOfiPLA[$value['codigo']][$value['nombre']] = 1;
                            }
                        }

                }
            if($value['nombre_funcionario'] == 'ACEFALO') {
                $this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->applyFromArray($styleTitulos10);
            }
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
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
                if($value['nro_item'] == '0' ) {
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, $value['fecha_finalizacion']);
                }

            $fila++;
            $this->numero++;

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
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FFFF00'
                )
            )
        );
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '9999FF'
                )
            )
        );
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FFFF00'
                )
            )
        );
        $styleTitulos4 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '00CCFF'
                )
            )
        );
        $styleTitulos5 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'CC99FF'
                )
            )
        );
        $styleTitulos6 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '00CCFF'
                )
            )
        );
        $styleTitulos7 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'CCFFFF'
                )
            )
        );
        $styleTitulos8 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '99CC00'
                )
            )
        );
        $styleTitulos9 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '99CC00'
                )
            )
        );
        $styleTitulos10 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'CCFFCC'
                )
            )
        );
        $styleTitulos11 = array(
        'font'  => array(
            'bold'  => true,
            'size'  => 10,
            'name'  => 'Arial'
        ),
        'alignment' => array(
            'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
            'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
        ),
        'fill' => array(
            'type' => PHPExcel_Style_Fill::FILL_SOLID,
            'color' => array(
                'rgb' => 'FFFF00'
            )
        )
    );
        //*************************************Cabecera Planta *****************************************
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'RESUMEN CANTIDAD DE PERSONAL DE PLANTA ');
        $this->docexcel->getActiveSheet()->getStyle('A2:B2')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A4:A14')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A2:B2');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,2,'MASCULINO');
        $this->docexcel->getActiveSheet()->getStyle('C2:D2')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('C2:D3')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->mergeCells('C2:D2');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,2,'FEMENINO');
        $this->docexcel->getActiveSheet()->getStyle('E2:F2')->applyFromArray($styleTitulos4);
        $this->docexcel->getActiveSheet()->getStyle('E3:F3')->applyFromArray($styleTitulos6);
        $this->docexcel->getActiveSheet()->mergeCells('E2:F2');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,2,'GLOBALES');
        $this->docexcel->getActiveSheet()->getStyle('G2:H2')->applyFromArray($styleTitulos8);
        $this->docexcel->getActiveSheet()->getStyle('G3:H3')->applyFromArray($styleTitulos9);
        $this->docexcel->getActiveSheet()->mergeCells('G2:H2');

        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(10);

        $this->docexcel->getActiveSheet()->setCellValue('A3','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B3','GERENCIA');
        $this->docexcel->getActiveSheet()->setCellValue('C3','Q');
        $this->docexcel->getActiveSheet()->setCellValue('D3','%');
        $this->docexcel->getActiveSheet()->setCellValue('E3','Q');
        $this->docexcel->getActiveSheet()->setCellValue('F3','%');
        $this->docexcel->getActiveSheet()->setCellValue('G3','Q');
        $this->docexcel->getActiveSheet()->setCellValue('H3','%');
        $this->docexcel->getActiveSheet()->getStyle('A3:B3')->applyFromArray($styleTitulos11);

        $fila = 4;
        $cantidad_ger = count($this->gerenciasPLA);
        foreach ($this->gerenciasPLA as $key => $value){
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos2);
            $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($styleTitulos5);
            $this->docexcel->getActiveSheet()->getStyle("C$fila:C$fila")->applyFromArray($styleTitulos5);
            $this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->applyFromArray($styleTitulos7);
            $this->docexcel->getActiveSheet()->getStyle("F$fila:F$fila")->applyFromArray($styleTitulos7);
            $this->docexcel->getActiveSheet()->getStyle("G$fila:G$fila")->applyFromArray($styleTitulos10);
            $this->docexcel->getActiveSheet()->getStyle("H$fila:H$fila")->applyFromArray($styleTitulos10);
            $fila++;
            if ($fila == ($cantidad_ger + 3)) {
                $this->docexcel->getActiveSheet()->getStyle("C". ($fila+1) . ":" . "D" . ($fila+1))->applyFromArray($styleTitulos2);
                $this->docexcel->getActiveSheet()->getStyle("E" . ($fila+1) . ":" . "F" . ($fila+1))->applyFromArray($styleTitulos6);
                $this->docexcel->getActiveSheet()->getStyle("G" . ($fila+1) . ":" . "H" . ($fila+1))->applyFromArray($styleTitulos9);

            }

        }
        //*************************************Fim Cabecera Planta *****************************************

        //*************************************Detalle-Planta******************************************************

        $nro = 1;
        $fila = 4;
        $columna=0;

        foreach ($this->gerenciasPLA as $key => $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $nro);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,$key);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila,$value);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila,round($value/$this->numero*100,2));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,round($this->gerenciaMasPLA[$key]/$value*100,2));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila,round($this->gerenciaFemPLA[$key]/$value*100,2));

            if (array_key_exists($key,$this->gerenciaMasPLA)) {
                $masculino = $this->gerenciaMasPLA[$key];
            } else {
                $masculino = 0;
            }

            if (array_key_exists($key,$this->gerenciaFemPLA)) {
                $femenino = $this->gerenciaFemPLA[$key];
            } else {
                $femenino = 0;

            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,$masculino);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,$femenino);

            $fila++;
            $nro++;
            $columna++;
        }
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,'=SUM(C4:C' .($fila-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila,'=SUM(E4:E' .($fila-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila,'=SUM(G4:G' .($fila-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila,round($fila/$fila*100));
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila, '=ROUND(C'.$fila.'/G'.$fila.'*100,2)');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila, '=ROUND(E'.$fila.'/G'.$fila.'*100,2)');
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:B$fila");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'RESUMEN CANTIDAD DE PERSONAL');
        $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($styleTitulos);


        //*************************************Fin-Detalle-Planta***********************************************


        //*************************************Cabecera Eventual *****************************************
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,23,'RESUMEN CANTIDAD DE PERSONAL DE EVENTUAL ');
        $this->docexcel->getActiveSheet()->getStyle('A23:B23')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A4:A14')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A23:B23');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,23,'MASCULINO');
        $this->docexcel->getActiveSheet()->getStyle('C23:D23')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('C24:D24')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->mergeCells('C23:D23');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,23,'FEMENINO');
        $this->docexcel->getActiveSheet()->getStyle('E23:F23')->applyFromArray($styleTitulos4);
        $this->docexcel->getActiveSheet()->getStyle('E24:F24')->applyFromArray($styleTitulos6);
        $this->docexcel->getActiveSheet()->mergeCells('E23:F23');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,23,'GLOBALES');
        $this->docexcel->getActiveSheet()->getStyle('G23:H23')->applyFromArray($styleTitulos8);
        $this->docexcel->getActiveSheet()->getStyle('G24:H24')->applyFromArray($styleTitulos9);
        $this->docexcel->getActiveSheet()->mergeCells('G23:H23');

        $this->docexcel->getActiveSheet()->setCellValue('A24','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B24','GERENCIA');
        $this->docexcel->getActiveSheet()->setCellValue('C24','Q');
        $this->docexcel->getActiveSheet()->setCellValue('D24','%');
        $this->docexcel->getActiveSheet()->setCellValue('E24','Q');
        $this->docexcel->getActiveSheet()->setCellValue('F24','%');
        $this->docexcel->getActiveSheet()->setCellValue('G24','Q');
        $this->docexcel->getActiveSheet()->setCellValue('H24','%');
        $this->docexcel->getActiveSheet()->getStyle('A24:B24')->applyFromArray($styleTitulos11);

        $fila = 25;
        $cantidad_ger = count($this->gerenciasEVE);
        foreach ($this->gerenciasEVE as $key => $value){
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos11);
            $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($styleTitulos5);
            $this->docexcel->getActiveSheet()->getStyle("C$fila:C$fila")->applyFromArray($styleTitulos5);
            $this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->applyFromArray($styleTitulos7);
            $this->docexcel->getActiveSheet()->getStyle("F$fila:F$fila")->applyFromArray($styleTitulos7);
            $this->docexcel->getActiveSheet()->getStyle("G$fila:G$fila")->applyFromArray($styleTitulos10);
            $this->docexcel->getActiveSheet()->getStyle("H$fila:H$fila")->applyFromArray($styleTitulos10);
            $fila++;
            if ($fila == ($cantidad_ger + 24)) {
                $this->docexcel->getActiveSheet()->getStyle("C". ($fila+1) . ":" . "D" . ($fila+1))->applyFromArray($styleTitulos2);
                $this->docexcel->getActiveSheet()->getStyle("E" . ($fila+1) . ":" . "F" . ($fila+1))->applyFromArray($styleTitulos6);
                $this->docexcel->getActiveSheet()->getStyle("G" . ($fila+1) . ":" . "H" . ($fila+1))->applyFromArray($styleTitulos9);

            }

        }
        //*************************************Fim Cabecera Eventual *****************************************

        //*************************************Detalle Eventual***********************************************
        $nro = 1;
        $fila = 25;
        $columna=0;

        foreach ($this->gerenciasEVE as $key => $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $nro);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,$key);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila,$value);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila,round($value/$this->numero*100,2));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,round($this->gerenciaMasEVE[$key]/$value*100,2));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila,round($this->gerenciaFemEVE[$key]/$value*100,2));

            if (array_key_exists($key,$this->gerenciaMasEVE)) {
                $masculino = $this->gerenciaMasEVE[$key];
            } else {
                $masculino = 0;
            }

            if (array_key_exists($key,$this->gerenciaFemEVE)) {
                $femenino = $this->gerenciaFemEVE[$key];
            } else {
                $femenino = 0;

            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,$masculino);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,$femenino);

            $fila++;
            $nro++;
            $columna++;
        }

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,'=SUM(C25:C' .($fila-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila,'=SUM(E25:E' .($fila-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila,'=SUM(G25:G' .($fila-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila,round($fila/$fila*100));
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila, '=ROUND(C'.$fila.'/G'.$fila.'*100,2)');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila, '=ROUND(E'.$fila.'/G'.$fila.'*100,2)');
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:B$fila");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'RESUMEN CANTIDAD DE PERSONAL');
        $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($styleTitulos);
        //*************************************Fin-Detalle Eventual*****************************************

        $sheet++;
        $this->imprimeResumenOficionas($sheet);


    }

    function imprimeResumenOficionas($sheet)
    { $this->docexcel->createSheet($sheet );
        $this->docexcel->setActiveSheetIndex($sheet );
        $this->docexcel->getActiveSheet()->setTitle('Personal por Oficina');

        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FFFF00'
                )
            )
        );
        $styleTitulos2 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FFFF00'
                )
            )
        );
        $styleTitulos6 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '00CCFF'
                )
            )
        );
        $styleTitulos7 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'CCFFFF'
                )
            )
        );
        $styleTitulos9 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '99CC00'
                )
            )
        );
        $styleTitulos10 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'CCFFCC'
                )
            )
        );

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'RESUMEN CANTIDAD DE PERSONAL DE PLANTA');
        $this->docexcel->getActiveSheet()->getStyle('A2:B2')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('A2:B2');
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(45);

        //*************************************Cabecera-Planta*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A3','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B3','GERENCIA');
        $this->docexcel->getActiveSheet()->getStyle('A3:B3')->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle('A4')->applyFromArray($styleTitulos2);

        $columna = 2;
        $fila = 5;

        foreach ($this->ciudadesOfiPLA as $key=>$value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, 2, $key);
            $columnaInicial = $columna;
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos2);
            $fila++;
            foreach ($value as $nombreOfi=>$valorOfi) {

                $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columna])->setWidth(20);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna].'3')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, 3, $nombreOfi);
                $columna++;
            }

            $this->docexcel->getActiveSheet()->mergeCells($this->equivalencias[$columnaInicial] . "2:" . $this->equivalencias[$columna - 1] . "2");
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columnaInicial] . "2:" . $this->equivalencias[$columna - 1] . "2")->applyFromArray($styleTitulos);

        }

        //*************************************Fin-Cabecera-Planta*****************************************
        //*************************************Detalle-Planta**********************************************
        $nro = 1;
        $fila = 4;
        $columna=2;
        $par_impar = 1;
        $cantidad_ger = count($this->empleadosOficinaPLA);


        foreach ($this->empleadosOficinaPLA as $key => $gerencia) {

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $nro);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $key);


            $columna=2;
            foreach ($this->ciudadesOfiPLA as $ciudad=>$value2){

                foreach ($value2 as $oficina=>$value3){


                    if ($par_impar == 1) {
                        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . $fila . ":" . $this->equivalencias[$columna] . $fila)->applyFromArray($styleTitulos7);
                        if ($fila == 4) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-1) . ":" . $this->equivalencias[$columna] . ($fila-1))->applyFromArray($styleTitulos6);
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-2) . ":" . $this->equivalencias[$columna] . ($fila-2))->applyFromArray($styleTitulos6);
                        }
                        if ($fila == ($cantidad_ger + 3)) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila+1) . ":" . $this->equivalencias[$columna] . ($fila+1))->applyFromArray($styleTitulos6);
                        }
                    } else {
                        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . $fila . ":" . $this->equivalencias[$columna] . $fila)->applyFromArray($styleTitulos10);
                        if ($fila == 4) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-1) . ":" . $this->equivalencias[$columna] . ($fila-1))->applyFromArray($styleTitulos9);
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-2) . ":" . $this->equivalencias[$columna] . ($fila-2))->applyFromArray($styleTitulos9);
                        }
                        if ($fila == ($cantidad_ger + 3)) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila+1) . ":" . $this->equivalencias[$columna] . ($fila+1))->applyFromArray($styleTitulos9);
                        }
                    }

                    if (array_key_exists($ciudad,$gerencia) && array_key_exists($oficina,$gerencia[$ciudad])) {
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$gerencia[$ciudad][$oficina]);

                        $columna++;
                    } else {
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,'0');
                        $columna++;
                    }
                }
                $par_impar = $par_impar * -1;

            }
            $nro++;
            $fila++;
            $par_impar = 1;


        }
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:B$fila");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'TOTALES');
        $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($styleTitulos);
        for ($i=2;$i<$columna;$i++){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,$fila,'=SUM(' . $this->equivalencias[$i].'4:' . $this->equivalencias[$i].($fila-1).')');
        }
        //*************************************Fin-Detalle-Planta**********************************************

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,20,'RESUMEN CANTIDAD DE PERSONAL DE EVENTUAL');
        $this->docexcel->getActiveSheet()->getStyle('A20:B20')->applyFromArray($styleTitulos);

        $this->docexcel->getActiveSheet()->mergeCells('A20:B20');
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(45);
        //*************************************Cabecera-Eventual*****************************************

        $this->docexcel->getActiveSheet()->setCellValue('A21','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B21','GERENCIA');
        $this->docexcel->getActiveSheet()->getStyle('A21:B21')->applyFromArray($styleTitulos2);
        $columna = 2;
        $fila = 22;
        foreach ($this->ciudadesOfiEVE as $key=>$value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, 20, $key);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos2);
            $fila++;
            $columnaInicial = $columna;

            foreach ($value as $nombreOfi=>$valorOfi) {
                $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columna])->setWidth(20);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna].'3')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, 21, $nombreOfi);
                $columna++;
            }

            $this->docexcel->getActiveSheet()->mergeCells($this->equivalencias[$columnaInicial] . "20:" . $this->equivalencias[$columna - 1] . "20");
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columnaInicial] . "20:" . $this->equivalencias[$columna - 1] . "20")->applyFromArray($styleTitulos);
        }
        //*************************************Fin-Cabecera-Eventual*****************************************
        //*************************************Detalle-Evetual***********************************************
        $nro = 1;
        $fila = 22;
        $columna=2;
        $par_impar = 1;
        $cantidad_ger = count($this->empleadosOficinaEVE);


        foreach ($this->empleadosOficinaEVE as $key => $gerencia) {

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $nro);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $key);


            $columna=2;
            foreach ($this->ciudadesOfiEVE as $ciudad=>$value2){

                foreach ($value2 as $oficina=>$value3){


                    if ($par_impar == 1) {
                        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . $fila . ":" . $this->equivalencias[$columna] . $fila)->applyFromArray($styleTitulos7);
                        if ($fila == 22) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-1) . ":" . $this->equivalencias[$columna] . ($fila-1))->applyFromArray($styleTitulos6);
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-2) . ":" . $this->equivalencias[$columna] . ($fila-2))->applyFromArray($styleTitulos6);
                        }
                        if ($fila == ($cantidad_ger + 20)) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila+2) . ":" . $this->equivalencias[$columna] . ($fila+2))->applyFromArray($styleTitulos6);
                        }
                    } else {
                        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . $fila . ":" . $this->equivalencias[$columna] . $fila)->applyFromArray($styleTitulos10);
                        if ($fila == 22) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-1) . ":" . $this->equivalencias[$columna] . ($fila-1))->applyFromArray($styleTitulos9);
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila-2) . ":" . $this->equivalencias[$columna] . ($fila-2))->applyFromArray($styleTitulos9);
                        }
                        if ($fila == ($cantidad_ger + 20)) {
                            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . ($fila+2) . ":" . $this->equivalencias[$columna] . ($fila+2))->applyFromArray($styleTitulos9);
                        }
                    }

                    if (array_key_exists($ciudad,$gerencia) && array_key_exists($oficina,$gerencia[$ciudad])) {
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$gerencia[$ciudad][$oficina]);

                        $columna++;
                    } else {
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,'0');
                        $columna++;
                    }
                }
                $par_impar = $par_impar * -1;

            }
            $nro++;
            $fila++;
            $par_impar = 1;


        }
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:B$fila");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'TOTALES');
        $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($styleTitulos);
        for ($i=2;$i<$columna;$i++){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,$fila,'=SUM(' . $this->equivalencias[$i].'22:' . $this->equivalencias[$i].($fila-1).')');
        }
        //*************************************Fin-Detalle-Eventual**********************************************

    }


    function generarReporte(){

        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);


    }
}
?>