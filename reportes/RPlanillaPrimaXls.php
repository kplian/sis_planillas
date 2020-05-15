<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #125	ETR				14.05.2020			MZM-KPLIAN			Planilla de Primas 
*/
class RPlanillaPrimaXls
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
            ->setTitle($tit_rep)
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
        $this->docexcel->createSheet($index)->setTitle('XXXXX'.$name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function imprimeCabecera() {
        

    }

    function generarDatos($data)
    {
        $styleTitulos4 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            )
        );

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
                

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '95c2f0'
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
                'name'  => 'Arial'
                

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'c5dffa'
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
        $fila = 3;
       // $columna = 8;
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

			if(count($datos)>0){
				
			
                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                $this->addHoja($value['tipo_contrato'],$index);
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
			   
			  
				$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
				$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
				$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
				if($this->objParam->getParametro('fecha_backup')!=''){
					$tit_rep=$tit_rep.'[Backup:'.$dr.'/'.$mr.'/'.$ar.']';
				}

                 
				$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
			   
			   
				if($this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG'){	
	               		$this->docexcel->getActiveSheet()->getStyle('A3:N3')->getAlignment()->setWrapText(true);
		                $this->docexcel->getActiveSheet()->getStyle('D3:L3')->applyFromArray($styleTitulos2);
						$this->docexcel->getActiveSheet()->getStyle('A4:N4')->applyFromArray($styleTitulos1);
						$tit_rep='PLANILLA PRIMA ANUAL';
						$tit_rep= $tit_rep.' '.$this->objParam->getParametro('nombre_tipo_contrato');
						
						if($this->objParam->getParametro('fecha_backup')!=''){
							$tit_rep=$tit_rep.'[Backup:'.$dr.'/'.$mr.'/'.$ar.']';
						}
						$this->docexcel->getActiveSheet()->mergeCells("A1:N1"); 
						$this->docexcel->getActiveSheet()->mergeCells("A2:N2");
						$this->docexcel->getActiveSheet()->mergeCells("H3:L3");
						$this->docexcel->getActiveSheet()->setCellValue('H3', 'CONTRATO 2');	
						
	             }else{
	             		$this->docexcel->getActiveSheet()->getStyle('A3:P3')->getAlignment()->setWrapText(true);
		                $this->docexcel->getActiveSheet()->getStyle('D3:K3')->applyFromArray($styleTitulos2);
						$this->docexcel->getActiveSheet()->getStyle('A4:P4')->applyFromArray($styleTitulos1);
						//$this->docexcel->getActiveSheet()->getColumnDimension('T3')->setWidth(15);
						$tit_rep='PRIMA POR PAGAR PERSONAL RETIRADO';
						$tit_rep= $tit_rep.' '.$this->objParam->getParametro('nombre_tipo_contrato');
						if($this->objParam->getParametro('fecha_backup')!=''){
							$tit_rep=$tit_rep.'[Backup:'.$dr.'/'.$mr.'/'.$ar.']';
						}
						$this->docexcel->getActiveSheet()->mergeCells("A1:P1");
						$this->docexcel->getActiveSheet()->mergeCells("A2:P2");
						
						
						
						$this->docexcel->getActiveSheet()->mergeCells("H3:K3");
						$this->docexcel->getActiveSheet()->setCellValue('H3', 'CONTRATO 2');		
						
	             }
				 $this->docexcel->getActiveSheet()->mergeCells("D3:G3");
				 $this->docexcel->getActiveSheet()->setCellValue('D3', 'CONTRATO 1');
				 
				 $this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
				 $this->docexcel->getActiveSheet()->getStyle('A1')->applyFromArray($styleTitulos3);//-----
				 $this->docexcel->getActiveSheet()->getStyle('A2')->applyFromArray($styleTitulos3);
				 $this->docexcel->getActiveSheet()->setCellValue('A2', $datos[0]['gestion']);
			 
				 $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(2,5);
				
                 $fila=5;
                 $this->numero=1;
                 //$columna = 8;

                 $total_bono = 0;
                 $total_sueldo = 0;
                 $total_frontera = 0;
                 $this->docexcel->getActiveSheet()->setTitle('PlanillaPrima');
                 $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(8);
                 $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(35);//nombre
                 $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(35);//nombre
                 $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(12);//pres
                 $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(12);//ci
                 $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(8);//funcionario
                 $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(12);//cargo
                 $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(12);//fecha
                 
                 if($this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG'){
                 	$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(8);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(12);
				 }else{
				 	$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(12);//ci
	                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(8);//funcionario
	                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(12);
					$this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(12);
				 }
                 
                 
	                $this->docexcel->getActiveSheet()->setCellValue('A4','Codigo');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B4','Nombre');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C4','Cargo');//3
	                $this->docexcel->getActiveSheet()->setCellValue('D4','Fecha Ing.');//4
	                $this->docexcel->getActiveSheet()->setCellValue('E4','Fecha Ret.');//5
	                $this->docexcel->getActiveSheet()->setCellValue('F4','Dias Trab.');//6
	                $this->docexcel->getActiveSheet()->setCellValue('G4','Cot. Prom');//7
	                $this->docexcel->getActiveSheet()->setCellValue('H4','Fecha Ing.');//8
				
				if($this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG'){
					$this->docexcel->getActiveSheet()->setCellValue('I4','Dias Trab.');//9
					$this->docexcel->getActiveSheet()->setCellValue('J4','Cot. Oct.');//10
					$this->docexcel->getActiveSheet()->setCellValue('K4','Cot. Nov.');//11
					$this->docexcel->getActiveSheet()->setCellValue('L4','Cot. Dic.');//12
					$this->docexcel->getActiveSheet()->setCellValue('M4','Prom. Cot');//13
					$this->docexcel->getActiveSheet()->setCellValue('N4','Prima');//14
					
				}else{
					$this->docexcel->getActiveSheet()->setCellValue('I4','Fecha Ret.');//9
					$this->docexcel->getActiveSheet()->setCellValue('J4','Dias Trab.');//10
					$this->docexcel->getActiveSheet()->setCellValue('K4','Cot. Prom.');//11
					$this->docexcel->getActiveSheet()->setCellValue('L4','Prima');//12
					$this->docexcel->getActiveSheet()->setCellValue('M4','13%');//13
					$this->docexcel->getActiveSheet()->setCellValue('N4','Certif. RC-IVA');//14
					$this->docexcel->getActiveSheet()->setCellValue('O4','Desc. RC-IVA');//15
					$this->docexcel->getActiveSheet()->setCellValue('P4','Monto a Pagar');//16
				}
				
				//$this->docexcel->getActiveSheet()->getStyle('M:L')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
				
				
				
				
				
				
				
			//if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				$cont=0;
				$fecha_novedad='';
				$novedad='';
				$dias='';
				$id_fun=0;
				$id_distrito='';
				foreach ($datos as $value){
					$cont++;
					
				    if($id_fun!=$value['id_funcionario']){
				    	
						if($id_distrito!=$value['desc_oficina']){
							if($id_distrito!='') $fila++;
							$this->docexcel->getActiveSheet()->getStyle("A".$fila.":D".$fila)->applyFromArray($styleTitulos4);
						    $this->docexcel->getActiveSheet()->mergeCells("A".$fila.":D".$fila);
					    	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['desc_oficina']);
							if($id_distrito=='') $fila++;
						}
						
						
					    if($id_fun!=0) 	$fila++;
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo']); 
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['desc_funcionario']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['cargo']);
						$ff=$value['ctto1'];
						
						$aa=substr($ff, 0,4);
						$mm=substr($ff, 5,2);
						$dd=substr($ff, 8,2);
						if($value['ctto1']!='#@@@#'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$dd.'/'.$mm.'/'.$aa);
							
							$aa=substr($ff, 15,4);
							$mm=substr($ff, 20,2);
							$dd=substr($ff, 23,2);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$dd.'/'.$mm.'/'.$aa);
						} 
						
						if($value['ctto2']!='#@@@#'){
							$ff=$value['ctto2'];
							$aa=substr($ff, 0,4);
							$mm=substr($ff, 5,2);
							$dd=substr($ff, 8,2);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila ,$dd.'/'.$mm.'/'.$aa);
							if($this->objParam->getParametro('codigo_planilla')!='PLAPRIVIG'){
								$aa=substr($ff, 15,4);
								$mm=substr($ff, 20,2);
								$dd=substr($ff, 23,2);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila ,$dd.'/'.$mm.'/'.$aa);
							}
						} 
						
						if($value['codigo_columna']=='IMPDET' && $this->objParam->getParametro('codigo_planilla')!='PLAPRIVIG'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila ,$value['valor']);
						}
					}else{
						
						if ($value['codigo_columna']=='PREDIAS1'){
							if($value['ctto1']!='#@@@#')
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['valor']);
							else 
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,0);
							
						}
							
						elseif ($value['codigo_columna']=='PREPROME1'){
							if($value['ctto1']!='#@@@#')
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila ,$value['valor']);
							else 
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila ,0);
							
						}elseif ($value['codigo_columna']=='PREDIAS2'){
						    if($this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG')
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila ,$value['valor']);
							else 
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila ,$value['valor']);
						}
						elseif ($value['codigo_columna']=='PREPROME2'){
							if($this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG')
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila ,$value['valor']);
							else 
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila ,$value['valor']);
						}elseif ($value['codigo_columna']=='PRIMA'){
							if($this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG')
							    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila ,$value['valor']);
							else{
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila ,$value['valor']);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila ,$value['valor']*0.13);
							} 
								
						}elseif ($value['codigo_columna']=='IMPOFAC' && $this->objParam->getParametro('codigo_planilla')!='PLAPRIVIG'){
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila ,$value['valor']);
							
						}elseif ($value['codigo_columna']=='LIQPAG' && $this->objParam->getParametro('codigo_planilla')!='PLAPRIVIG'){
							    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila ,$value['valor']);
						}elseif ($value['codigo_columna']=='PREPRICOT23' && $this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG'){
							    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila ,$value['valor']);
						}elseif ($value['codigo_columna']=='PREPRICOT22' && $this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG'){
							    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila ,$value['valor']);
						}elseif ($value['codigo_columna']=='PREPRICOT21' && $this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG'){
							    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila ,$value['valor']);
						}
						
					}
				$id_distrito=$value['desc_oficina'];	 
				$id_fun=$value['id_funcionario'];
				}
					
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
    function generarReporte($datos){ 
        $this->generarDatos($datos);
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        //$this->imprimeCabecera(0);

    }

}
?>