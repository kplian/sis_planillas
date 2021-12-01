<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #77    ETR            14/11/2019           MZM                 Creacion 
 #77	ETR			   19/11/2019			MZM					Cambio en for
 #83	ETR				10.12.2019			MZM					Habilitacion de opcion historico de planilla
 #123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019)
*/
class RPlanillaSueldosMinXls
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    var $datos_detalle;
    var $datos_titulo;
	var $etiqueta;
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
        $this->docexcel->createSheet($index)->setTitle($name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function imprimeCabecera() {
        

    }

    function generarDatos($data, $data_det, $data_firma)
    {
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'font'  => array(
                'bold'  => true,
                'size'  => 7,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '000000'
                )

            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THICK  
                )
            )
        );

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
             ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ));

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial',
                

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            )
           
         );

        $styleTitulos4 = array(
            'font'  => array(
                'size'  => 7,
                'name'  => 'Arial',
           ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
            $styleTitulos5 = array(
                'font'  => array(
                    'size'  => 7,
                    'name'  => 'Arial',
               ),
                'alignment' => array(
                    'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
                    'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
                ),
                'borders' => array(
                    'allborders' => array(
                        'style' => PHPExcel_Style_Border::BORDER_THIN
                    )
                ));

                $styleFirma = array(
                    'font'  => array(
                        'size'  => 10,
                        'name'  => 'Arial',
                        'bold' => true
                   ),
                    'alignment' => array(
                        'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                        'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
                    ),
                    'borders' => array(
                        'top' => array(
                            'style' => PHPExcel_Style_Border::BORDER_THIN
                        )
                    ));

        $this->numero = 1;
        $fila = 8;
       // $columna = 8;
        $datos = $data;//$this->objParam->getParametro('datos');
        //var_dump($datos);exit;
        $datos_det=$data_det;
        $datos_firma=$data_firma;
        //subtotales
        $tipo_contrato = '';
        $desc_func = '';
        $codigo_pres = '';
        //$this->imprimeCabecera(0);

        $numberFormat = '#,##0.00';
        //$cant_datos = count($datos);
        $totales=array();
        $codigo_col = '';
        $index = 0;
        $nombre_empresa='';
        $color_pestana = array('ff0000','1100ff','55ff00','3ba3ff','ff4747','697dff','78edff','ba8cff',
            'ff80bb','ff792b','ffff5e','52ff97','bae3ff','ffaf9c','bfffc6','b370ff','ffa8b4','7583ff','9aff17','ff30c8');

       $id_gerencia=0;
       if (count($datos_det)>0){

        $tipo_contrato='';
				
				$id_funcionario=0; 
				$columnas=0;
        foreach ($datos_det as $value){//#77
           
              if ($id_gerencia!=$value['id_gerencia']){
               
                if ($id_gerencia!=0){
                    $fila++;
                    $this->docexcel->getActiveSheet()->mergeCells('A'.$fila.':J'.$fila); 
                    $this->docexcel->getActiveSheet()->getStyle('A'.$fila)->applyFromArray($styleTitulos2);
                    $this->docexcel->getActiveSheet()->setCellValue('A'.$fila, 'TOTALES');

                    $this->docexcel->getActiveSheet()->getStyle('A9:J'.$fila)->applyFromArray($styleTitulos4); 	
                    $this->docexcel->getActiveSheet()->getStyle('F9:F'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                    $this->docexcel->getActiveSheet()->getStyle('H9:J'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                    $this->docexcel->getActiveSheet()->getStyle('K9:X'.$fila)->applyFromArray($styleTitulos5); 	
                    for ($ii=10; $ii <23 ;$ii++){
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($ii, $fila, $totales[$ii]);
                     }
                    $this->docexcel->getActiveSheet()->getStyle('A'.$fila.':X'.$fila)->applyFromArray(
                        array(
                            
                            'font'  => array(
                                'size'  => 7,
                                'name'  => 'Arial',
                                'bold'  => true,
                           ),
                           'borders' => array(
                            'top'     => array(
                                'style' => PHPExcel_Style_Border::BORDER_THICK,
                             ),
                             'bottom'     => array(
                                 'style' => PHPExcel_Style_Border::BORDER_THICK,
                             ),
                        )
                        )
                            );



                    $this->docexcel->getActiveSheet()->getStyle('J9:J'.$fila)->getBorders()->applyFromArray(
                        array(
                            'right'     => array(
                               'style' => PHPExcel_Style_Border::BORDER_THICK,
                            )
                        )
                            );


                      $this->docexcel->getActiveSheet()->getStyle('R9:R'.$fila)->getBorders()->applyFromArray(
                                array(
                                    'right'     => array(
                                       'style' => PHPExcel_Style_Border::BORDER_THICK,
                                    ),
                                    'left'     => array(
                                        'style' => PHPExcel_Style_Border::BORDER_THICK,
                                     )
                                )
                                    );    
                                    $this->docexcel->getActiveSheet()->getStyle('V9:V'.$fila)->getBorders()->applyFromArray(
                                        array(
                                            'right'     => array(
                                               'style' => PHPExcel_Style_Border::BORDER_THICK,
                                            ),
                                            'left'     => array(
                                                'style' => PHPExcel_Style_Border::BORDER_THICK,
                                             )
                                        )
                                            );    
                
                                            $this->docexcel->getActiveSheet()->getStyle('W9:W'.$fila)->getBorders()->applyFromArray(
                                                array(
                                                    'right'     => array(
                                                       'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                    ),
                                                    'left'     => array(
                                                        'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                     )
                                                )
                                                    );

                                                    $this->docexcel->getActiveSheet()->getStyle('X9:X'.$fila)->getBorders()->applyFromArray(
                                                        array(
                                                            'right'     => array(
                                                               'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                            ),
                                                            'left'     => array(
                                                                'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                             )
                                                        )
                                                            );
              
                                                            $fila=$fila+10;   
                                                            $this->docexcel->getActiveSheet()->mergeCells('E'.$fila.':K'.$fila); 
                                                            $this->docexcel->getActiveSheet()->mergeCells('M'.$fila.':P'.$fila); 
                                                            $this->docexcel->getActiveSheet()->mergeCells('S'.$fila.':U'.$fila); 
                                                            $this->docexcel->getActiveSheet()->setCellValue('E'.$fila, $datos_firma[0]['nombre_empleado_firma']);
                                                            $this->docexcel->getActiveSheet()->getStyle('E'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                                                                  
                                                            $this->docexcel->getActiveSheet()->setCellValue('M'.$fila, $datos_firma[0]['ci_firma']); 
                                                            $this->docexcel->getActiveSheet()->getStyle('M'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                                                       
                                                           
                                                            $fila++;
                                                            $this->docexcel->getActiveSheet()->mergeCells('E'.$fila.':K'.$fila); 
                                                            $this->docexcel->getActiveSheet()->mergeCells('M'.$fila.':P'.$fila); 
                                                            $this->docexcel->getActiveSheet()->mergeCells('S'.$fila.':U'.$fila); 
                                               
                                               
                                                            
                                               
                                                            $this->docexcel->getActiveSheet()->setCellValue('E'.$fila, 'NOMBRE DEL EMPLEADOR O REPRESENTANTE LEGAL'); 
                                                            $this->docexcel->getActiveSheet()->getStyle('E'.$fila.':K'.$fila)->applyFromArray($styleFirma);
                                                            $this->docexcel->getActiveSheet()->setCellValue('M'.$fila, 'Nº DE DOCUMENTO DE IDENTIDAD'); 
                                                            $this->docexcel->getActiveSheet()->getStyle('M'.$fila.':P'.$fila)->applyFromArray($styleFirma);
                                                            $this->docexcel->getActiveSheet()->setCellValue('S'.$fila, 'FIRMA'); 
                                                            $this->docexcel->getActiveSheet()->getStyle('S'.$fila.':U'.$fila)->applyFromArray($styleFirma);
                                                            $this->docexcel->getActiveSheet()->setCellValue('W'.$fila, 'FECHA'); 
                                                            $this->docexcel->getActiveSheet()->getStyle('W'.$fila)->applyFromArray($styleTitulos2);
                                                            $this->docexcel->getActiveSheet()->setCellValue('X'.$fila, $datos['fecha_planilla']); 
                                                            $this->docexcel->getActiveSheet()
                                                               ->getStyle('X'.$fila)
                                                               ->getBorders()
                                                               ->applyFromArray(
                                                                   array(
                                                                       'allborders'     => array(
                                                                          'style' => PHPExcel_Style_Border::BORDER_THIN,
                                                                       )
                                                                   )
                                                                 );                                

                                                            $totales=array();
                }

                $this->addHoja($value['gerencia'],$index);
                $id_funcionario=0;
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
	            $this->docexcel->getActiveSheet()->getStyle('A8:X8')->getAlignment()->setWrapText(true);
	            $this->docexcel->getActiveSheet()->getStyle('A8:X8')->applyFromArray($styleTitulos3);
				
				
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,9);
                $fila=9;
                $this->numero=1;
                //$columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
				
				
	                $this->docexcel->getActiveSheet()->setTitle($value['gerencia']);
	                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(2);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(9);//categoria
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(9);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(4);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(6);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(6);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(9);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(8);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setWidth(9);//pres
	                
	                $this->docexcel->getActiveSheet()->setCellValue('A8','Nº');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B8','Documento de Identidad');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C8','Apellidos y nombres');//3
	                $this->docexcel->getActiveSheet()->setCellValue('D8','Pais de nacionalidad');//3
	                $this->docexcel->getActiveSheet()->setCellValue('E8','Fecha de nacimiento');//3
	                $this->docexcel->getActiveSheet()->setCellValue('F8','Sexo (V/F)');//3
	                $this->docexcel->getActiveSheet()->setCellValue('G8','Ocupacion que desempeña');//3
	                $this->docexcel->getActiveSheet()->setCellValue('H8','Fecha de ingreso');//3
	                $this->docexcel->getActiveSheet()->setCellValue('I8','Horas pagadas (dia)');//3
	                $this->docexcel->getActiveSheet()->setCellValue('J8','Dias pagados (mes)');//3
	                $this->docexcel->getActiveSheet()->setCellValue('K8','(1) Haber básico');//3
	                $this->docexcel->getActiveSheet()->setCellValue('L8','(2) Bono de Antigüedad');//3
	                $this->docexcel->getActiveSheet()->setCellValue('M8','(3) Bono de producción');//3
	                $this->docexcel->getActiveSheet()->setCellValue('N8','(4) Subsidio de frontera');//3
	                $this->docexcel->getActiveSheet()->setCellValue('O8','(5) Trabajo extraordi-nario y nocturno');//3
	                $this->docexcel->getActiveSheet()->setCellValue('P8','(6) Pago dominical y domingo trabajado');//3
	                $this->docexcel->getActiveSheet()->setCellValue('Q8','(7) Otros bonos');//3
	                $this->docexcel->getActiveSheet()->setCellValue('R8','(8) TOTAL GANADO');//3
	                $this->docexcel->getActiveSheet()->setCellValue('S8','(9) Aporte a las AFPs');//3
	                $this->docexcel->getActiveSheet()->setCellValue('T8','(10) RC-IVA');//3
	                $this->docexcel->getActiveSheet()->setCellValue('U8','(11) Otros descuentos');//3
	                $this->docexcel->getActiveSheet()->setCellValue('V8','(12) TOTAL DESCUENTOS     Suma
                    (9 a 11)');//3
	                $this->docexcel->getActiveSheet()->setCellValue('W8','(13) LÍQUIDO PAGABLE    (12-8)');//3
	                $this->docexcel->getActiveSheet()->setCellValue('X8','(14) Firma');//3
	                
	                
	                $this->docexcel->getActiveSheet()->getStyle('C')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
					
				 
                

				$tit_rep='PLANILLA DE SUELDOS Y SALARIOS';
			    
                $this->docexcel->getActiveSheet()->getStyle('A1:T3')->applyFromArray($styleTitulos2);
                $this->docexcel->getActiveSheet()->setCellValue('A1', 'NOMBRE O RAZON SOCIAL');
                $this->docexcel->getActiveSheet()->mergeCells("D1:J1"); 
              
                $this->docexcel->getActiveSheet()->mergeCells("H2:J2"); 
                $this->docexcel->getActiveSheet()->setCellValue('A2', 'Nº IDENTIFICADOR DEL EMPLEADOR ANTE EL MINISTERIO DE TRABAJO');
                $this->docexcel->getActiveSheet()->setCellValue('L1', 'Nº DE NIT');
                $this->docexcel->getActiveSheet()->setCellValue('L2', 'Nº DE EMPLEADOR (Caja de Salud)');
                $this->docexcel->getActiveSheet()->mergeCells("Q1:R1"); 
                $this->docexcel->getActiveSheet()->mergeCells("Q2:R2"); 
                $this->docexcel->getActiveSheet()->setCellValue('U1', 'Pagina');
                $this->docexcel->getActiveSheet()->setCellValue('V1', '1');
                $this->docexcel->getActiveSheet()->setCellValue('W1', 'de');
                $this->docexcel->getActiveSheet()->setCellValue('X1', '1');
                $this->docexcel->getActiveSheet()->getStyle('X6')->applyFromArray($styleTitulos2);
                $this->docexcel->getActiveSheet()->setCellValue('X6', 'CORRESPONDIENTE AL MES DE '.strtoupper($datos['periodo_lite']));
                $this->docexcel->getActiveSheet()->getStyle('X6')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);


                $this->docexcel->getActiveSheet()->mergeCells("A4:X4"); 
				$this->docexcel->getActiveSheet()->getStyle('A4')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                $this->docexcel->getActiveSheet()->getStyle('A4:X4')->applyFromArray($styleTitulos1);
				$this->docexcel->getActiveSheet()->setCellValue('A4', $tit_rep);
				$this->docexcel->getActiveSheet()->mergeCells("A5:X5");
				$this->docexcel->getActiveSheet()->getStyle('A5')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A5', '(En Bolivianos)');
            }
                    $this->docexcel->getActiveSheet()->getStyle('A'.$fila.':X'.$fila)->getAlignment()->setWrapText(true);     
					if($id_funcionario!=$value['id_funcionario'] ){
						if($id_funcionario!=0){
							$fila++;	
						}
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $fila-8);
                        if($value['codigo_columna']=='num_documento'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['valor_columna']);
                        }
                        
                       
						//$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['valor_columna']);
					    $columnas=2;
						
					} else{
                        if($value['codigo_columna']=='empresa'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, 1, $value['valor_columna']);
                        }
                        elseif($value['codigo_columna']=='direccion_empresa'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, 3, 'DIRECCION '.$value['valor_columna']);
                        }

                        elseif($value['codigo_columna']=='identificador_min_trabajo'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, 2, $value['valor_columna']);
                        }

                        elseif($value['codigo_columna']=='identificador_caja_salud'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, 2, $value['valor_columna']);
                        }else{
                            if($columnas>22){
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columnas, $fila, '');
                               }else{
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columnas, $fila, $value['valor_columna']);   
                               }

                            
                           if ($columnas>=10 && $columnas<23){
                             $totales[$columnas] += $value['valor_columna'];
                           }
                            
                           
                        }
					   
					   $columnas++;
					}
					 $id_funcionario=$value['id_funcionario'];
                     $id_gerencia=$value['id_gerencia'];
                    
                        
                                                                
                    
				}
               
                $fila++;
                $this->docexcel->getActiveSheet()->mergeCells('A'.$fila.':J'.$fila); 
                $this->docexcel->getActiveSheet()->getStyle('A'.$fila)->applyFromArray($styleTitulos2);
                $this->docexcel->getActiveSheet()->setCellValue('A'.$fila, 'TOTALES');    
                $this->docexcel->getActiveSheet()->getStyle('A9:J'.$fila)->applyFromArray($styleTitulos4); 	
                $this->docexcel->getActiveSheet()->getStyle('F9:F'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                $this->docexcel->getActiveSheet()->getStyle('H9:J'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                $this->docexcel->getActiveSheet()->getStyle('K9:X'.$fila)->applyFromArray($styleTitulos5); 	
           
                $this->docexcel->getActiveSheet()->getStyle('J9:J'.$fila)->getBorders()->applyFromArray(
                    array(
                        'right'     => array(
                           'style' => PHPExcel_Style_Border::BORDER_THICK,
                        )
                    )
                        );


                  $this->docexcel->getActiveSheet()->getStyle('R9:R'.$fila)->getBorders()->applyFromArray(
                            array(
                                'right'     => array(
                                   'style' => PHPExcel_Style_Border::BORDER_THICK,
                                ),
                                'left'     => array(
                                    'style' => PHPExcel_Style_Border::BORDER_THICK,
                                 )
                            )
                                );    
                                $this->docexcel->getActiveSheet()->getStyle('V9:V'.$fila)->getBorders()->applyFromArray(
                                    array(
                                        'right'     => array(
                                           'style' => PHPExcel_Style_Border::BORDER_THICK,
                                        ),
                                        'left'     => array(
                                            'style' => PHPExcel_Style_Border::BORDER_THICK,
                                         )
                                    )
                                        );    
            
                                        $this->docexcel->getActiveSheet()->getStyle('W9:W'.$fila)->getBorders()->applyFromArray(
                                            array(
                                                'right'     => array(
                                                   'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                ),
                                                'left'     => array(
                                                    'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                 )
                                            )
                                                );

                                                $this->docexcel->getActiveSheet()->getStyle('X9:X'.$fila)->getBorders()->applyFromArray(
                                                    array(
                                                        'right'     => array(
                                                           'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                        ),
                                                        'left'     => array(
                                                            'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                         )
                                                    )
                                                        );


                                                        for ($ii=10; $ii <23 ;$ii++){
                                                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($ii, $fila, $totales[$ii]);
                                                           
                                                        }
                                                        $this->docexcel->getActiveSheet()->getStyle('A'.$fila.':X'.$fila)->applyFromArray(
                                                            array(
                                                                
                                                                'font'  => array(
                                                                    'size'  => 7,
                                                                    'name'  => 'Arial',
                                                                    'bold'  => true,
                                                               ),
                                                               'borders' => array(
                                                                'top'     => array(
                                                                    'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                                 ),
                                                                 'bottom'     => array(
                                                                     'style' => PHPExcel_Style_Border::BORDER_THICK,
                                                                 ),
                                                            )
                                                            )
                );
                 
             $fila=$fila+10;   
             $this->docexcel->getActiveSheet()->mergeCells('E'.$fila.':K'.$fila); 
             $this->docexcel->getActiveSheet()->mergeCells('M'.$fila.':P'.$fila); 
             $this->docexcel->getActiveSheet()->mergeCells('S'.$fila.':U'.$fila); 
             $this->docexcel->getActiveSheet()->setCellValue('E'.$fila, $datos_firma[0]['nombre_empleado_firma']);
             $this->docexcel->getActiveSheet()->getStyle('E'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
                   
             $this->docexcel->getActiveSheet()->setCellValue('M'.$fila, $datos_firma[0]['ci_firma']); 
             $this->docexcel->getActiveSheet()->getStyle('M'.$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
        
            
             $fila++;
             $this->docexcel->getActiveSheet()->mergeCells('E'.$fila.':K'.$fila); 
             $this->docexcel->getActiveSheet()->mergeCells('M'.$fila.':P'.$fila); 
             $this->docexcel->getActiveSheet()->mergeCells('S'.$fila.':U'.$fila); 


             

             $this->docexcel->getActiveSheet()->setCellValue('E'.$fila, 'NOMBRE DEL EMPLEADOR O REPRESENTANTE LEGAL'); 
             $this->docexcel->getActiveSheet()->getStyle('E'.$fila.':K'.$fila)->applyFromArray($styleFirma);
             $this->docexcel->getActiveSheet()->setCellValue('M'.$fila, 'Nº DE DOCUMENTO DE IDENTIDAD'); 
             $this->docexcel->getActiveSheet()->getStyle('M'.$fila.':P'.$fila)->applyFromArray($styleFirma);
             $this->docexcel->getActiveSheet()->setCellValue('S'.$fila, 'FIRMA'); 
             $this->docexcel->getActiveSheet()->getStyle('S'.$fila.':U'.$fila)->applyFromArray($styleFirma);
             $this->docexcel->getActiveSheet()->setCellValue('W'.$fila, 'FECHA'); 
             $this->docexcel->getActiveSheet()->getStyle('W'.$fila)->applyFromArray($styleTitulos2);
             $this->docexcel->getActiveSheet()->setCellValue('X'.$fila, $datos['fecha_planilla']); 
             $this->docexcel->getActiveSheet()
                ->getStyle('X'.$fila)
                ->getBorders()
                ->applyFromArray(
                    array(
                        'allborders'     => array(
                           'style' => PHPExcel_Style_Border::BORDER_THIN,
                        )
                    )
                  );
               
               


           /*  $this->docexcel->getActiveSheet()->getStyle('E'.$fila.':K'.$fila)->applyFromArray(
                array(
                    
                    'font'  => array(
                        'size'  => 10,
                        'name'  => 'Arial',
                        'bold'  => true,
                   ),
                   'borders' => array(
                    'top'     => array(
                        'style' => PHPExcel_Style_Border::BORDER_THICK,
                     )
                    ),
                    'alignment' => array(
                        'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                        'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
                    ),
                )
);*/
            
             

		}//#123      
                    
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
    function generarReporte($datos,$datos_det,$datos_firma){ //echo ($datos['periodo_lite']); exit;
        $this->generarDatos($datos,$datos_det,$datos_firma);
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        //$this->imprimeCabecera(0);

    }

}
?>