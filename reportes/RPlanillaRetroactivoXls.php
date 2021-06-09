<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 
 #ETR-4051				04.06.2021			MZM-KPLIAN			Reporte CPS para planilla de reintegros
 * *  
*/
class RPlanillaRetroactivoXls
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
            'font'  => array(
                'bold'  => true,
                'underline'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '219891'
                )

            ),
        );

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'underline'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '219891'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            /*'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )*/);

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

       $styleTitulos2T = array(
            'font'  => array(
                'bold'  => true,
                'underline'  => true,
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
                    'rgb' => '219891'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));


  $styleTitulos3C = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'font'  => array(
                'bold'  => true,
                'underline'  => true,
                'size'  => 12,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '219891'
                )

            ),
        );

        $this->numero = 1;
        $fila = 8;
        $columna = 3;
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
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                //$this->addHoja($value['tipo_contrato'],$index);
				$this->addHoja($this->objParam->getParametro('nombre_tipo_contrato'),$index);
				//#98
				$tcon='';
				$tcon=$this->objParam->getParametro('nombre_tipo_contrato');
				if ($tcon=='Planta') $tcon=''; //#161
				if($tcon!=''){
					if($this->objParam->getParametro('personal_activo')!='todos'){
					  $tcon='('.$tcon.' - '. $this->objParam->getParametro('personal_activo').')';
					}
					else {
						$tcon='('.$tcon.')';	
					}
				}
				
				
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
				//#83
				$dr=substr($datos[0]['fecha_backup'],0,2);
				$mr=substr($datos[0]['fecha_backup'],3,2);
				$ar=substr($datos[0]['fecha_backup'],6);
				
				$this->docexcel->getActiveSheet()->mergeCells("A8:S8");
				$this->docexcel->getActiveSheet()->mergeCells("A9:S9");
				
				
				
				
				$this->docexcel->getActiveSheet()->mergeCells("A1:C1");
				$this->docexcel->getActiveSheet()->mergeCells("D1:H1");
				//$this->docexcel->getActiveSheet()->getStyle('A1:C1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				$this->docexcel->getActiveSheet()->mergeCells("A2:C2");
				$this->docexcel->getActiveSheet()->mergeCells("D2:H2");
				//$this->docexcel->getActiveSheet()->getStyle('A2:C2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				$this->docexcel->getActiveSheet()->mergeCells("A3:C3");
				$this->docexcel->getActiveSheet()->mergeCells("D3:H3");
				//$this->docexcel->getActiveSheet()->getStyle('A3:C3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				$this->docexcel->getActiveSheet()->mergeCells("A4:C4");
				$this->docexcel->getActiveSheet()->mergeCells("D4:H4");
				//$this->docexcel->getActiveSheet()->getStyle('A4:C4')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				$this->docexcel->getActiveSheet()->mergeCells("A5:C5");
				$this->docexcel->getActiveSheet()->mergeCells("D5:H5");
				//$this->docexcel->getActiveSheet()->getStyle('A5:C5')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				$this->docexcel->getActiveSheet()->mergeCells("A6:C6");
				$this->docexcel->getActiveSheet()->mergeCells("D6:H6");
				//$this->docexcel->getActiveSheet()->getStyle('A6:C6')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				
				
                $this->docexcel->getActiveSheet()->getStyle('A1:C6')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A1:C6')->applyFromArray($styleTitulos2);
				
				
				$this->docexcel->getActiveSheet()->getStyle('A8:S8')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A8:A8')->applyFromArray($styleTitulos3C);
				
                $this->docexcel->getActiveSheet()->getStyle('A9:S9')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A9:A9')->applyFromArray($styleTitulos3);
				
				
				$this->docexcel->getActiveSheet()->getStyle('A10:S12')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A10:S12')->applyFromArray($styleTitulos2T);
				
                
                //$this->docexcel->getActiveSheet()->freezePaneByolumnAndRow(0,3);
                $fila=14;
                $this->numero=1;
                $columna = 1;

                $tot1=0; $tot2=0;
				$tot3=0; $tot4=0;
				$tot5=0; $tot6=0;
				$tot7=0; $tot8=0;
				$tot9=0; $tot10=0;
                $this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('nombre_tipo_contrato'));
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(7);//nº
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(8);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);//apellido_nombre
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);//sexo
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(12);//fecha_ingreso
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(12);//haber_basico
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);//haber_basico1
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(12);//bonoant_ene
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(12);//bonoant_feb
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(12);//bonoant_mar
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(12);//bonoant_abr
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);//total_bonoant
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(10);//afp
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(10);//iva
                $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(10);//otro_desc
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(15);//total_desc
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(12);//liqpag
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(15);//firma
                
				
				
                $this->docexcel->getActiveSheet()->setCellValue('A10','Nº');//1
                $this->docexcel->getActiveSheet()->setCellValue('B10','C.I.');//2
                $this->docexcel->getActiveSheet()->setCellValue('C10','APELLIDOS Y NOMBRES');//3
                $this->docexcel->getActiveSheet()->setCellValue('D10','SEXO');//4
                $this->docexcel->getActiveSheet()->setCellValue('E10','OCUPACION');//5
                $this->docexcel->getActiveSheet()->setCellValue('F10','FECHA');//6
                $this->docexcel->getActiveSheet()->setCellValue('G10','HABER BASICO');//7
                $this->docexcel->getActiveSheet()->setCellValue('H10','HABER BASICO');//8
                $this->docexcel->getActiveSheet()->setCellValue('I10','ENERO');//9
                $this->docexcel->getActiveSheet()->setCellValue('J10','FEBRERO');//10
                $this->docexcel->getActiveSheet()->setCellValue('K10','MARZO');//11
                $this->docexcel->getActiveSheet()->setCellValue('L10','ABRIL');//12
                $this->docexcel->getActiveSheet()->setCellValue('M10','TOTAL');//13
                $this->docexcel->getActiveSheet()->setCellValue('N10','DESCUENTOS');//14
                $this->docexcel->getActiveSheet()->setCellValue('O10','');//15
                $this->docexcel->getActiveSheet()->setCellValue('P10','');//16
                $this->docexcel->getActiveSheet()->setCellValue('Q10','TOTAL');//17
                $this->docexcel->getActiveSheet()->setCellValue('R10','LIQUIDO');//18
                $this->docexcel->getActiveSheet()->setCellValue('S10','FIRMA');//18
                
                //2
                $this->docexcel->getActiveSheet()->setCellValue('A11','Nº');//1
                $this->docexcel->getActiveSheet()->setCellValue('B11','C.I.');//2
                $this->docexcel->getActiveSheet()->setCellValue('C11','APELLIDOS Y NOMBRES');//3
                $this->docexcel->getActiveSheet()->setCellValue('D11','');//4
                $this->docexcel->getActiveSheet()->setCellValue('E11','QUE');//5
                $this->docexcel->getActiveSheet()->setCellValue('F11','DE');//6
                $this->docexcel->getActiveSheet()->setCellValue('G11','');//7
                $this->docexcel->getActiveSheet()->setCellValue('H11','');//8
                $this->docexcel->getActiveSheet()->setCellValue('I11','INCREMENTO BONO ANT');//9
                $this->docexcel->getActiveSheet()->setCellValue('J11','INCREMENTO BONO ANT');//10
                $this->docexcel->getActiveSheet()->setCellValue('K11','INCREMENTO BONO ANT');//11
                $this->docexcel->getActiveSheet()->setCellValue('L11','INCREMENTO BONO ANT');//12
                $this->docexcel->getActiveSheet()->setCellValue('M11','RETROACTIVO');//13
                $this->docexcel->getActiveSheet()->setCellValue('N11','AFP');//14
                $this->docexcel->getActiveSheet()->setCellValue('O11','RC IVA');//15
                $this->docexcel->getActiveSheet()->setCellValue('P11','OTROS');//16
                $this->docexcel->getActiveSheet()->setCellValue('Q11','DESCUENTOS');//17
                $this->docexcel->getActiveSheet()->setCellValue('R11','PAGABLE');//18
                $this->docexcel->getActiveSheet()->setCellValue('S11','FIRMA');//18
                
                //3
                $this->docexcel->getActiveSheet()->setCellValue('A12','');//1
                $this->docexcel->getActiveSheet()->setCellValue('B12','');//2
                $this->docexcel->getActiveSheet()->setCellValue('C12','');//3
                $this->docexcel->getActiveSheet()->setCellValue('D12','(F/M)');//4
                $this->docexcel->getActiveSheet()->setCellValue('E12','DESEMPEÑA');//5
                $this->docexcel->getActiveSheet()->setCellValue('F12','INGRESO');//6
                $ges=($datos[0]['gestion']);
				
                $this->docexcel->getActiveSheet()->setCellValue('G12','DIC-'.substr(number_format($ges-1),3));//7
                $this->docexcel->getActiveSheet()->setCellValue('H12','INCREMENTO '.$datos[0]['gestion']);//8
                $this->docexcel->getActiveSheet()->setCellValue('I12','');//9
                $this->docexcel->getActiveSheet()->setCellValue('J12','');//10
                $this->docexcel->getActiveSheet()->setCellValue('K12','');//11
                $this->docexcel->getActiveSheet()->setCellValue('L12','');//12
                $this->docexcel->getActiveSheet()->setCellValue('M12','');//13
                $this->docexcel->getActiveSheet()->setCellValue('N12','');//14
                $this->docexcel->getActiveSheet()->setCellValue('O12','');//15
                $this->docexcel->getActiveSheet()->setCellValue('P12','');//16
                $this->docexcel->getActiveSheet()->setCellValue('Q12','');//17
                $this->docexcel->getActiveSheet()->setCellValue('R12','');//18
                 $this->docexcel->getActiveSheet()->setCellValue('S12','');//18
                
               $this->docexcel->getActiveSheet()->mergeCells("A10:A13");
			   $this->docexcel->getActiveSheet()->mergeCells("B10:B13");
			   $this->docexcel->getActiveSheet()->mergeCells("C10:C13");
			   $this->docexcel->getActiveSheet()->mergeCells("D10:D11");
			   $this->docexcel->getActiveSheet()->mergeCells("D12:D13");
			   
                $this->docexcel->getActiveSheet()->mergeCells("E12:E13");
				$this->docexcel->getActiveSheet()->mergeCells("F12:F13");
				$this->docexcel->getActiveSheet()->mergeCells("G10:G11");
			   $this->docexcel->getActiveSheet()->mergeCells("G12:G13");
			   $this->docexcel->getActiveSheet()->mergeCells("H10:H11");
			   $this->docexcel->getActiveSheet()->mergeCells("H12:H13");
			   
			   
			   /*$this->docexcel->getActiveSheet()->mergeCells("D11:D13");
			   $this->docexcel->getActiveSheet()->mergeCells("E11:E13");
			   $this->docexcel->getActiveSheet()->mergeCells("F11:F13");
			   $this->docexcel->getActiveSheet()->mergeCells("G11:G13");
			   $this->docexcel->getActiveSheet()->mergeCells("H11:H13");*/
			   $this->docexcel->getActiveSheet()->mergeCells("I11:I13");
			   $this->docexcel->getActiveSheet()->mergeCells("J11:J13");
			   $this->docexcel->getActiveSheet()->mergeCells("K11:K13");
			   $this->docexcel->getActiveSheet()->mergeCells("L11:L13");
			   
			   $this->docexcel->getActiveSheet()->mergeCells("M11:M13");
			   $this->docexcel->getActiveSheet()->mergeCells("N11:N13");
			   $this->docexcel->getActiveSheet()->mergeCells("O11:O13");
			   $this->docexcel->getActiveSheet()->mergeCells("P11:P13");
			   $this->docexcel->getActiveSheet()->mergeCells("Q11:Q13");
			   $this->docexcel->getActiveSheet()->mergeCells("R11:R13");
			   $this->docexcel->getActiveSheet()->mergeCells("S10:S13");
			   
			   
			   $this->docexcel->getActiveSheet()->mergeCells("N10:P10");
				
				
                
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 1, 'NOMBRE O RAZON SOCIAL:');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 2, 'NUMERO DE EMPLEADOR CPS:');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 3, 'NUMERO DE NIT:');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 4, 'DIRECCION:');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 5, 'TELEFONO:');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 6, 'CORREO ELECTRONICO:');
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 1, '___________________________________________________________________________________________________________');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 2, '___________________________________________________________________________________________________________');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 3, '___________________________________________________________________________________________________________');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 4, '___________________________________________________________________________________________________________');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 5, '___________________________________________________________________________________________________________');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 6, '___________________________________________________________________________________________________________');
                
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8, 'PLANILLA RETROACTIVA - INCREMENTO SMN  '.$datos[0]['gestion']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,9, 'EXPRESADO EN BOLIVIANOS');
				
				$nombre_centro='';
				foreach ($datos as $value){
					//#66
					/*if($this->objParam->getParametro('tipo_reporte')!='curva_salarial'){
						if($nombre_centro!=$value['nombre_centro']){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['nombre_centro']);
							$fila++;
						}
						$nombre_centro=$value['nombre_centro'];
						
					}*/
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $fila-13);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['ci']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['desc_funcionario2']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['cargo']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, date_format(date_create($value['fecha_ingreso']),'d/m/Y'));
					if ($value['genero']=='masculino'){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, 'M');
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, 'F');	
					}
                    
                   	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila,$value['haber_basico'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila,$value['haber_basico_inc'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila,$value['bant_ene'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila,$value['bant_feb']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila,$value['bant_mar'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila,$value['bant_abr'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila,$value['total_retroactivo'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila,$value['afp'] );
					if ($this->objParam->getParametro('personal_activo')=='activo'){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila,0 );
						$tot7=$tot7+0;
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila,$value['rc_iva'] );
						$tot7=$tot7+	$value['rc_iva'];
					}
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila,$value['otros'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila,$value['total_desc'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila,$value['liqpag'] );
					
					
					$tot1=$tot1+ $value['bant_ene'];
					$tot2=$tot2+$value['bant_feb'];
					$tot3=$tot3+$value['bant_mar'];
					$tot4=$tot4+$value['bant_abr'];
					$tot5=$tot5+$value['total_retroactivo'];
					$tot6=$tot6+$value['afp'];
					
					$tot8=$tot8+$value['otros'];
					$tot9=$tot9+$value['total_desc'];
					$tot10=$tot10+ $value['liqpag'];
				
								 
					$fila++;
				}

        $this->docexcel->getActiveSheet()->getStyle('H'.$fila.':S'.$fila)->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('H'.$fila.':S'.$fila)->applyFromArray($styleTitulos2T);
				 
        //}
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, 'TOTALES');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $tot1);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $tot2);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $tot3);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $tot4);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $tot5);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $tot6);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $tot7);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, $tot8);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $tot9);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $tot10);
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
        //$this->imprimeCabecera(0);

    }

}
?>