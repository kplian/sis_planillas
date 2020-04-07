<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #77    ETR            14/11/2019           MZM                 Creacion
 #80    ETR            27/11/2019           MZM                 ajuste formato numeric
 #86	ETR				20.12.2019			MZM					HAbilitacion para funcionar con reporte de reintegros
 #83	ETR				02.02.2020			MZM					Habilitacion de opcion historico de planilla
 #86	ETR				20.12.2019			MZM					HAbilitacion para funcionar con reporte de reintegros 
*/
class RPlanillaAportesXls
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


        
           // if($tipo_contrato != $value['estado']){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                $this->addHoja($value['tipo_contrato'],$index);
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
			if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){	
               if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){     
	                $this->docexcel->getActiveSheet()->getStyle('A3:S3')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A3:S3')->applyFromArray($styleTitulos3);
                }else{
                	$this->docexcel->getActiveSheet()->getStyle('A3:Q3')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A3:Q3')->applyFromArray($styleTitulos3);
                }
             }else{
             	$this->docexcel->getActiveSheet()->getStyle('A3:Y3')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A3:Y3')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getColumnDimension('T3')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('U3')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('V3')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('W3')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('X3')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('Y3')->setWidth(15);
					
             }
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,4);
                $fila=4;
                $this->numero=1;
                //$columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
                $this->docexcel->getActiveSheet()->setTitle('BeneficiosSociales');
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(8);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(8);//categori
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(8);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);//fecha
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(15);
				$this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(15);
				if($this->objParam->getParametro('tipo_reporte')!='aporte_afp'){   
					$this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(15);
				}
                
				
                $this->docexcel->getActiveSheet()->setCellValue('A3','N');//1
                $this->docexcel->getActiveSheet()->setCellValue('B3','Tipo');//2
                $this->docexcel->getActiveSheet()->setCellValue('C3','Numero');//3
                $this->docexcel->getActiveSheet()->setCellValue('D3','Ext');//4
                $this->docexcel->getActiveSheet()->setCellValue('E3','NUA');//5
                $this->docexcel->getActiveSheet()->setCellValue('F3','Apellido Paterno');//6
                $this->docexcel->getActiveSheet()->setCellValue('G3','Apellido Materno');//7
                $this->docexcel->getActiveSheet()->setCellValue('H3','Primer Nombre');
				$this->docexcel->getActiveSheet()->setCellValue('I3','Segundo Nombre');
				$this->docexcel->getActiveSheet()->setCellValue('J3','Departamento');
				$this->docexcel->getActiveSheet()->setCellValue('K3','Novedad');
				$this->docexcel->getActiveSheet()->setCellValue('L3','Fecha Novedad');
				$this->docexcel->getActiveSheet()->setCellValue('M3','Dias Cot');
				if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){  
					$this->docexcel->getActiveSheet()->setCellValue('N3','Tot Gan - Dep<65');
					$this->docexcel->getActiveSheet()->setCellValue('O3','Tot Gan - Dep>65');
					$this->docexcel->getActiveSheet()->setCellValue('P3','Tot Jub<65');
					$this->docexcel->getActiveSheet()->setCellValue('Q3','Tot Jub>65');
				}else{
					if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
						$this->docexcel->getActiveSheet()->setCellValue('N3','Tot Ganado Solidario');
						$this->docexcel->getActiveSheet()->setCellValue('O3','Tot Gan Sol - 13000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('P3','Tot Gan Sol - 25000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('Q3','Tot Gan Sol - 35000 Bs');
					}else{
						$this->docexcel->getActiveSheet()->setCellValue('N3','Tot Solidario SIN Incr.');
						$this->docexcel->getActiveSheet()->setCellValue('O3','Tot Sol sin incr. - 13000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('P3','Tot Sol sin incr. - 25000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('Q3','Tot Sol sin incr. - 35000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('R3','Tot Sol CON Incremento');
						$this->docexcel->getActiveSheet()->setCellValue('S3','Tot Sol con incr. - 13000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('T3','Tot Sol con incr. - 25000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('U3','Tot Sol con incr. - 35000 Bs');
						$this->docexcel->getActiveSheet()->setCellValue('V3','Aporte Solidario 1%');
						$this->docexcel->getActiveSheet()->setCellValue('W3','Aporte Solidario 5%');
						$this->docexcel->getActiveSheet()->setCellValue('X3','Aporte Solidario 10%');
						$this->docexcel->getActiveSheet()->setCellValue('Y3','Total Aporte Solidario');
					}
				}
				if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){  
					$this->docexcel->getActiveSheet()->setCellValue('R3','Tot FV');
					$this->docexcel->getActiveSheet()->setCellValue('S3','Tot FS');
				}
				
                
                $this->docexcel->getActiveSheet()->getStyle('M:S')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
				
                
             
                
if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
	$tit_rep='APORTES AL SISTEMA INTEGRAL DE PENSIONES -'.$datos[0]['nombre_afp'];
}else{
	if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
	$tit_rep='FORMULARIO DE PAGO DE CONTRIBUCIONES - '.$datos[0]['nombre_afp'];}
	else{
		$tit_rep='APORTES AL FONDO SOLIDARIO POR PAGO RETROACTIVO DE SUELDOS - '.$datos[0]['nombre_afp'];
	}
}


		//#83
		$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
		$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
		$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
		if($this->objParam->getParametro('fecha_backup')!=''){
			$tit_rep=$tit_rep.'[Backup:'.$dr.'/'.$mr.'/'.$ar.']';
		}

                $this->docexcel->getActiveSheet()->mergeCells("A1:S1"); 
				$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
				 $this->docexcel->getActiveSheet()->mergeCells("A2:S2");
				 $this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				if ($this->objParam->getParametro('consolidar')=='si'){//#98
					$this->docexcel->getActiveSheet()->setCellValue('A2', 'Acumulado a : '.$datos[0]['periodo']);
				}else{
					$this->docexcel->getActiveSheet()->setCellValue('A2', 'A: '.$datos[0]['periodo']);
				}
				
				
				
				
				
			//if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				$cont=0;
				$fecha_novedad='';
				$novedad='';
				$dias='';
				foreach ($datos as $value){
					$cont++;
					$fecha_novedad='';
				$novedad='';
				$dias='';
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$cont); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['ci']); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['num_ci']); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$value['expedicion']); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['nro_afp']); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['apellido_paterno']); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila ,$value['apellido_materno']); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila ,$value['primer_nombre']); 
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila ,$value['segundo_nombre']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila ,$value['departamento']);  
					
					if($value['fecha_ingreso']!=''){
							  	  $novedad='I';
								  if($value['dias_incap']>0){//#45
								  	$novedad='I/S';
								  }
								  
								  $aa=substr($value['fecha_ingreso'], 0,4);
							  	  $mm=substr($value['fecha_ingreso'], 5,2);
							      $dd=substr($value['fecha_ingreso'], 8,2);
								  $fecha_novedad=$dd.'/'.$mm.'/'.$aa;//#45
								  
							  }
							  if($value['fecha_finalizacion']!=''){
							  	  $novedad='R';
								  if($value['dias_incap']>0){//#45
								  	$novedad='R/S';
								  }
								  
								  $aa=substr($value['fecha_finalizacion'], 0,4);
							  	  $mm=substr($value['fecha_finalizacion'], 5,2);
							      $dd=substr($value['fecha_finalizacion'], 8,2);
								  $fecha_novedad=$dd.'/'.$mm.'/'.$aa;//#45
								  
							  }
							  
							   if($value['fecha_ingreso']==''){//#45
								   	if($value['dias_incap']>0){
									  	$novedad='S';
									}
							   }
					
								$dias=$value['dias'];
					 					    
    				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila ,$novedad);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila ,$fecha_novedad);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila ,$dias);




					if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
						if($value['tipo_jubilado']=='no'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila ,$value['valor']);
						} 
						else {
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila ,'');
						}
									  
									  
						if($value['tipo_jubilado']=='mayor_65'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila ,number_format($value['valor'],2,'.',','));//#80
						} 
						else {
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila ,'');
						}
						
						if($value['tipo_jubilado']=='jubilado_55'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila ,number_format($value['valor'],2,'.',','));//#80
						} 
						else {
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila ,'');
						}
								
						if($value['tipo_jubilado']=='jubilado_65'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila ,number_format($value['valor'],2,'.',','));//#80
						} 
						else {
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila ,'');
						}	  				
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila ,number_format($value['valor'],2,'.',','));//#80
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila ,number_format($value['valor'],2,'.',','));//#80
					}else{
						
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila ,number_format($value['valor'],2,'.',','));//#80
						if($value['valor']>13000){//#45
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila ,number_format(($value['valor']-13000),2,'.',','));//#80
							  	
						}else{
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila ,'');
							  	
						}
						
						if($value['valor']>25000){//#45
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila ,number_format(($value['valor']-25000),2,'.',','));//#80
							  	
						}else{
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila ,'');
							  	
						}
						
						
						if($value['valor']>35000){//#45
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila ,number_format(($value['valor']-35000),2,'.',','));//#80
							  	
						}else{
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila ,'');
							  	
						}
							  	
								
						if($this->objParam->getParametro('codigo_planilla')=='PLANRE'){//#86
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila ,number_format(($value['valor']+$value['ncotiz']),2,'.',','));
						}
						$ncotiz=($value['valor']+$value['ncotiz']);
						if($ncotiz>13000){
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila ,number_format(($ncotiz-13000),2,'.',','));
							  	
						}else{
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila ,'');
							  	
						}
						
						if($ncotiz>25000){
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila ,number_format(($ncotiz-25000),2,'.',','));
							  	
						}else{
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila ,'');
							  	
						}
						
						
						if($ncotiz>35000){
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila ,number_format(($ncotiz-35000),2,'.',','));
							  	
						}else{
							  	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila ,'');
							  	
						}

						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila ,number_format($value['nvar1'],2,'.',','));
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila ,number_format($value['nvar2'],2,'.',','));
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23, $fila ,number_format($value['nvar3'],2,'.',','));
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila ,number_format(($value['nvar1']+$value['nvar2']+$value['nvar3']),2,'.',','));
						
					}
					
					$fila++;
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