<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 
 #142	ETR				23.06.2020			MZM					Condicion para reporte por centros
 */
class RAbonoCuentaXls
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
	}
    function generarDatos($data)
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
                'size'  => 25,
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
                    'rgb' => '2D572C'
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
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->numero = 1;
        $fila = 3;
        $columna = 8;
        $datos = $data;//$this->objParam->getParametro('datos');var_dump($datos);exit;
        //subtotales
        $tipo_contrato = '';
        $desc_func = '';
        $codigo_pres = '';
        //$this->imprimeCabecera(0);

        $numberFormat = '#,##0.00';
        $cant_datos = count($datos);
        $total_bono = 0;
        $total_sueldo = 0;
        $total_frontera = 0;
        $codigo_col = '';
        $index = 0;
        $color_pestana = array('ff0000','1100ff','55ff00','3ba3ff','ff4747','697dff','78edff','ba8cff',
            'ff80bb','ff792b','ffff5e','52ff97','bae3ff','ffaf9c','bfffc6','b370ff','ffa8b4','7583ff','9aff17','ff30c8');


    
       // foreach ($datos as $value)
        //{
            //var_dump($value['tipo_contrato']);exit;
           // if($tipo_contrato != $value['estado']){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, '******');
                //$this->addHoja($value['tipo_contrato'],$index);
				$this->addHoja('',$index);
				//#98
				$tcon='';
				
				
				
				
				
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
				//#83
				
				$this->docexcel->getActiveSheet()->mergeCells("A1:A11");
				$this->docexcel->getActiveSheet()->getStyle('A1:BR1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->getStyle('A1')->applyFromArray($styleTitulos1);
					$this->docexcel->getActiveSheet()->setCellValue('A1','BNB');//1			
				//$this->docexcel->getActiveSheet()->setCellValue('A1', 'CURVA SALARIAL '.$tcon.' A ' .date_format(date_create($datos[0]['fecha_planilla']),'d/m/Y'));
			
				$this->docexcel->getActiveSheet()->mergeCells("B2:F2");
				$this->docexcel->getActiveSheet()->getStyle('B2')->applyFromArray($styleTitulos3);
				$this->docexcel->getActiveSheet()->setCellValue('B2','PLANILLA PARA ABONO');//1
                $this->docexcel->getActiveSheet()->getStyle('A12:D12')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A12:D12')->applyFromArray($styleTitulos3);
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,14);
                $fila=14;
                $this->numero=1;
                $columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
                $this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('nombre_tipo_contrato'));
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(40);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);//categoria
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);//ci
                $this->docexcel->getActiveSheet()->mergeCells("A12:A13");
				$this->docexcel->getActiveSheet()->mergeCells("B12:B13");
				$this->docexcel->getActiveSheet()->mergeCells("C12:C13");
				$this->docexcel->getActiveSheet()->mergeCells("D12:D13");
				
                $this->docexcel->getActiveSheet()->setCellValue('A12','NOMBRE EMPLEADO');//1
                $this->docexcel->getActiveSheet()->setCellValue('B12','C.I.');//2
                $this->docexcel->getActiveSheet()->setCellValue('C12','Numero de Cuenta');//3
                $this->docexcel->getActiveSheet()->setCellValue('D12','Monto (Numerico) ABONO');//4
               

               $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, 4, 'Empresa');
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, 4, $datos[0]['nombre']);
               
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, 5, 'Codigo Empresa');
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, 5, $datos[0]['codigo_bnb']);
               
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, 6, 'Fecha');
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, 6, $datos[0]['fecha']);
               
			   $this->docexcel->getActiveSheet()->getStyle('C7')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, 7, 'NUM de Abonos');
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, 7, $datos[0]['num_abonos']);
               $this->docexcel->getActiveSheet()->getStyle('C8')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
			   $this->docexcel->getActiveSheet()->getStyle('C8')->applyFromArray( array( 'fill' => array( 'type' => PHPExcel_Style_Fill::FILL_SOLID, 'color' => array('rgb' => 'FFFF00') ) ) );
			   
			   
                
			   
			   
			   
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, 8, 'Abono Total Bs.');
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, 8, number_format($datos[0]['total'],2,'.',','));
               
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, 9, 'Mes de Abono');
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, 9, $datos[0]['periodo']);
               
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, 10, 'Tipo Moneda');
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, 10, 'Bs.');
			   
			   $this->docexcel->getActiveSheet()->getStyle('D')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
			   $this->docexcel->getActiveSheet()->getStyle('D11')->applyFromArray( array( 'fill' => array( 'type' => PHPExcel_Style_Fill::FILL_SOLID, 'color' => array('rgb' => 'FFFF00') ) ) );
			   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 11, number_format($datos[0]['total'],2,'.',','));
               $this->docexcel->getActiveSheet()->getStyle('C14:C1000')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
				$nombre_centro='';
				foreach ($datos as $value){
					
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['desc_funcionario2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['ci']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['numero_cuenta']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, number_format($value['monto_transferencia'],2,'.',','));		 
					$fila++;
				}

                
           
        //}
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
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
    function generarReporte($datos){ 
        $this->generarDatos($datos);
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        $this->imprimeCabecera(0);

    }

}
?>