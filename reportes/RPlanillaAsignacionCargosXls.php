<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #77    ETR            14/11/2019           MZM                 Creacion
 #83	ETR				10.12.2019			MZM					Habilitacion de opcion historico de planilla
 #98	ETR				03.04.2020  		MZM					Adicion de opciones estado_funcionario (activo, retirado, todos) 
*/
class RPlanillaAsignacionCargosXls
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

    function generarDatos($data,$data_titulo)
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
               
				
               if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos' || $this->objParam->getParametro('tipo_reporte')=='movimiento_personal' || $this->objParam->getParametro('tipo_reporte')=='directorio_empleados' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_mes'  ){     
	                $this->docexcel->getActiveSheet()->getStyle('A3:F3')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A3:F3')->applyFromArray($styleTitulos3);
					
					if($this->objParam->getParametro('tipo_reporte')=='movimiento_personal' || $this->objParam->getParametro('tipo_reporte')=='directorio_empleados' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_ano'){
						$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
	                	$this->docexcel->getActiveSheet()->getStyle('A3:G3')->applyFromArray($styleTitulos3);
					
					}
                }else{
                	if($this->objParam->getParametro('tipo_reporte')=='lista_cargos'){
                		$this->docexcel->getActiveSheet()->getStyle('A3:B3')->getAlignment()->setWrapText(true);
	                	$this->docexcel->getActiveSheet()->getStyle('A3:B3')->applyFromArray($styleTitulos3);
                	}elseif($this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos'){
						$this->docexcel->getActiveSheet()->getStyle('A3:E3')->getAlignment()->setWrapText(true);
	                	$this->docexcel->getActiveSheet()->getStyle('A3:E3')->applyFromArray($styleTitulos3);
						
					}elseif($this->objParam->getParametro('tipo_reporte')=='profesiones' || $this->objParam->getParametro('tipo_reporte')=='listado_centros'){//#115
						$this->docexcel->getActiveSheet()->getStyle('A3:C3')->getAlignment()->setWrapText(true);
	                	$this->docexcel->getActiveSheet()->getStyle('A3:C3')->applyFromArray($styleTitulos3);
						
					}
                	
                }
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,4);
                $fila=4;
                $this->numero=1;
                //$columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
                $this->docexcel->getActiveSheet()->setTitle('Cargos');
				
			if($this->objParam->getParametro('tipo_reporte')=='lista_cargos' || $this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos' || $this->objParam->getParametro('tipo_reporte')=='frecuencia_profesiones'){
					
				if ($this->objParam->getParametro('tipo_reporte')=='frecuencia_profesiones' ){
					$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(40);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);//categori
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
		            $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//categori
		                
	                $this->docexcel->getActiveSheet()->setCellValue('A3','Profesion');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','Hombres');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C3','Mujeres');//2
	                $this->docexcel->getActiveSheet()->setCellValue('D3','Totales');//2
	              
				}else{
					$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);//categori
	                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','Descripcion');//2
	                
	                if ($this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos' ){
	                	$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
		                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//categori
		                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//categori
		                $this->docexcel->getActiveSheet()->setCellValue('C3','Hombres');//1
		                $this->docexcel->getActiveSheet()->setCellValue('D3','Mujeres');//2
		                $this->docexcel->getActiveSheet()->setCellValue('E3','Totales');//2
	                }
				}
				
			}elseif($this->objParam->getParametro('tipo_reporte')=='directorio_empleados'){
				$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);//categori
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);//cargo
                
                
                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo');//1
                $this->docexcel->getActiveSheet()->setCellValue('B3','Nombre');//2
                $this->docexcel->getActiveSheet()->setCellValue('C3','Cargo');//3
                $this->docexcel->getActiveSheet()->setCellValue('D3','Telef. Dom');//4
                $this->docexcel->getActiveSheet()->setCellValue('E3','Celular');//4
                $this->docexcel->getActiveSheet()->setCellValue('F3','Correo');//4
                $this->docexcel->getActiveSheet()->setCellValue('G3','Direccion');//4
			}elseif($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' ){
				$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);//categori
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);//cargo
                
                
                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo');//1
                $this->docexcel->getActiveSheet()->setCellValue('B3','Nombre');//2
                $this->docexcel->getActiveSheet()->setCellValue('C3','Año');//3
                $this->docexcel->getActiveSheet()->setCellValue('D3','Mes');//4
                $this->docexcel->getActiveSheet()->setCellValue('E3','Dia');//4
                $this->docexcel->getActiveSheet()->setCellValue('F3','Cargo');//4
                $this->docexcel->getActiveSheet()->setCellValue('G3','Centro de Responsabilidad');//4
			}elseif($this->objParam->getParametro('tipo_reporte')=='nacimiento_mes' ){
				$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);//categori
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);//cargo
                
                
                
                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo');//1
                $this->docexcel->getActiveSheet()->setCellValue('B3','Nombre');//2
                $this->docexcel->getActiveSheet()->setCellValue('C3','Mes');//3
                $this->docexcel->getActiveSheet()->setCellValue('D3','Dia');//4
                $this->docexcel->getActiveSheet()->setCellValue('E3','Cargo');//4
                $this->docexcel->getActiveSheet()->setCellValue('F3','Centro de Responsabilidad');//4
              
			}elseif($this->objParam->getParametro('tipo_reporte')=='profesiones' ){
				$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);//categori
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);//pres
                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo');//1
                $this->docexcel->getActiveSheet()->setCellValue('B3','Nombre');//2
                $this->docexcel->getActiveSheet()->setCellValue('C3','Profesion');//3
                 
			}
			elseif($this->objParam->getParametro('tipo_reporte')=='listado_centros' ){
				$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);//categori
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);//pres
                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo');//1
                $this->docexcel->getActiveSheet()->setCellValue('B3','Nombre');//2
                $this->docexcel->getActiveSheet()->setCellValue('C3','Cargo');//3
                 
			}
			
			else 
						
			{//asignacion_cargos, movimiento_personal
				$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(8);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);//categori
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(30);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);//cargo
                
                if($this->objParam->getParametro('tipo_reporte')=='movimiento_personal' ){
                	$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);//cargo
                }
				
                $this->docexcel->getActiveSheet()->setCellValue('A3','N');//1
                $this->docexcel->getActiveSheet()->setCellValue('B3','Codigo');//2
                $this->docexcel->getActiveSheet()->setCellValue('C3','Fecha Mov.');//3
                $this->docexcel->getActiveSheet()->setCellValue('D3','Nombre Completo');//4
                
                if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){
	                $this->docexcel->getActiveSheet()->setCellValue('E3','Cargo Anterior');//5
	                $this->docexcel->getActiveSheet()->setCellValue('F3','Cargo Actual');//6
				}else{
					$this->docexcel->getActiveSheet()->setCellValue('E3','De');//5
	                $this->docexcel->getActiveSheet()->setCellValue('F3','A');//6
				}
				
                if($this->objParam->getParametro('tipo_reporte')=='movimiento_personal'){
                	$this->docexcel->getActiveSheet()->setCellValue('G3','Cargo Actual');//6
                }
			}	
				
                
				
                
               
				
 $cadena_nomina=$this->objParam->getParametro('nombre_tipo_contrato');
		if($cadena_nomina!=''){
			//#98
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$cadena_nomina=' ('.$cadena_nomina.' - '.$this->objParam->getParametro('personal_activo').')';
			}else{
				$cadena_nomina='('.$cadena_nomina.')';
			}
		}else{
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
			$cadena_nomina=' ('.$this->objParam->getParametro('personal_activo').')';}
		}


     
   //#83
				$dr=substr($data_titulo[0]['fecha_backup'],0,2);
				$mr=substr($data_titulo[0]['fecha_backup'],3,2);
				$ar=substr($data_titulo[0]['fecha_backup'],6);
				$fecha_backup=''; 
				if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000' && $data_titulo[0]['fecha_backup']!=''){
					$fecha_backup=' [Backup:'.($dr.'/'.$mr.'/'.$ar).']';
				}          
                
if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){
	$tit_rep='DESIGNACION DE CARGOS'.$cadena_nomina .$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='movimiento_personal'){
	$tit_rep='MOVIMIENTOS DE PERSONAL '.$cadena_nomina.$fecha_backup;

}elseif( $this->objParam->getParametro('tipo_reporte')=='lista_cargos'){
	$tit_rep='CARGOS '.$cadena_nomina.$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos'){
	$tit_rep='FRECUENCIA DE CARGOS '.$cadena_nomina.$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='directorio_empleados'){
	$tit_rep='DIRECTORIO DE EMPLEADOS POR CENTRO DE BENEFICIO Y CARGOS'.$cadena_nomina.$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='nacimiento_ano'){
	
	$tit_rep='FECHAS DE NACIMIENTO - NOMINA CLASIFICADA POR AÑO'.$cadena_nomina.$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='nacimiento_mes'){
	
	$tit_rep='FECHAS DE NACIMIENTO - NOMINA CLASIFICADA POR MES'.$cadena_nomina.$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='profesiones'){
	$tit_rep='CLASIFICACION DE PERSONAL POR PROFESIONES'.$cadena_nomina.$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='frecuencia_profesiones'){
	$tit_rep='FRECUENCIA DE PROFESIONES '.$cadena_nomina.$fecha_backup;
}elseif( $this->objParam->getParametro('tipo_reporte')=='listado_centros'){
	$tit_rep='LISTADO POR CENTROS '.$cadena_nomina.$fecha_backup;
}


if( $this->objParam->getParametro('tipo_reporte')=='lista_cargos' || $this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos' || $this->objParam->getParametro('tipo_reporte')=='frecuencia_profesiones'){
	 	if($this->objParam->getParametro('tipo_reporte')=='lista_cargos'){
	 		$this->docexcel->getActiveSheet()->mergeCells("A1:B1"); 
			$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
			$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
			$this->docexcel->getActiveSheet()->mergeCells("A2:B2");
			$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
			$this->docexcel->getActiveSheet()->setCellValue('A2', '');
	 	}else{
	 		$this->docexcel->getActiveSheet()->mergeCells("A1:E1"); 
			$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
			$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
			$this->docexcel->getActiveSheet()->mergeCells("A2:E2");
			$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
			$this->docexcel->getActiveSheet()->setCellValue('A2', '');
	 	}
		 
	 
				
}else{
	
	 if($this->objParam->getParametro('tipo_reporte')=='profesiones' || $this->objParam->getParametro('tipo_reporte')=='listado_centros'){
	 	 $this->docexcel->getActiveSheet()->mergeCells("A1:C1");
		 $this->docexcel->getActiveSheet()->mergeCells("A2:C2"); 
	 }else{
	 	$this->docexcel->getActiveSheet()->mergeCells("A1:F1"); 
		$this->docexcel->getActiveSheet()->mergeCells("A2:F2");
	 }
	 
				$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
				
				$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				if($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_mes' || $this->objParam->getParametro('tipo_reporte')=='profesiones' || $this->objParam->getParametro('tipo_reporte')=='directorio_empleados' || $this->objParam->getParametro('tipo_reporte')=='listado_centros'){///////////////////
					$this->docexcel->getActiveSheet()->setCellValue('A2', 'A: '.$datos[0]['periodo_lite']);
				}else{
					$this->docexcel->getActiveSheet()->setCellValue('A2', 'A: '.$datos[0]['gestion']);	
				}
				
				
}

               
				
				
			 if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos' || $this->objParam->getParametro('tipo_reporte')=='movimiento_personal'){
				$cont=0;
				
				foreach ($datos as $value){
					
				   if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){		
					if($value['nuevo_cargo']!='' && $value['cargo']!=$value['nuevo_cargo']){
				   	  	$cont++; 	  
					  	$a=substr($value['fecha_finalizacion'],0,4);
					  	$m=substr($value['fecha_finalizacion'],5,2);
					  	$d=substr($value['fecha_finalizacion'],8,2);
				  
				  			    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$cont);
							    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['codigo']);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$d.'/'.$m.'/'.$a);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$value['desc_funcionario2']);
								if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['cargo']);
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['nuevo_cargo']);	
								}else{
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['unidad']);
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['nueva_unidad']);	
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila ,$value['nuevo_cargo']);
								}
								
					   
				  $fila++;
			   }
			   }else{
			   	if($value['nueva_unidad']!='' && $value['nueva_unidad']!=$value['unidad']){
				   	  	$cont++; 	  
					  	$a=substr($value['fecha_finalizacion'],0,4);
					  	$m=substr($value['fecha_finalizacion'],5,2);
					  	$d=substr($value['fecha_finalizacion'],8,2);
				  
				  			    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$cont);
							    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['codigo']);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$d.'/'.$m.'/'.$a);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$value['desc_funcionario2']);
								if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['cargo']);
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['nuevo_cargo']);	
								}else{
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['unidad']);
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['nueva_unidad']);	
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila ,$value['nuevo_cargo']);
								}
								
					   
				  $fila++;
			   }
			   }
					
			}
		}elseif($this->objParam->getParametro('tipo_reporte')=='directorio_empleados'){
			$centro_uo='';
			foreach ($datos as $value){
				
				if($centro_uo!=$value['nombre_uo_centro']){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['nombre_uo_centro']);
					$fila++;
				}
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo_funcionario']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['desc_funcionario2']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['nombre_cargo']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$value['telefono1']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['celular_personal']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['correo_personal']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila ,$value['direccion']);
				$fila++;
				$centro_uo=$value['nombre_uo_centro'];			
			}
		}elseif($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano'){
			$ges='';
			foreach ($datos as $value){
				
				if($ges!=$value['ano']){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['ano']);
					$fila++;
										
				}
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo_funcionario']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['desc_funcionario2']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['ano']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$value['mes']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['dia']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['nombre_cargo']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila ,$value['nombre_uo_centro']);
				$fila++;
				$ges=$value['ano'];			
			}
			
		}elseif($this->objParam->getParametro('tipo_reporte')=='nacimiento_mes'){
			$ges='';
			foreach ($datos as $value){
				
				if($ges!=$value['mes']){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['mes_lite']);
					$fila++;
										
				}
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo_funcionario']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['desc_funcionario2']);
//				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['ano']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['mes']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$value['dia']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,$value['nombre_cargo']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila ,$value['nombre_uo_centro']);
				$fila++;
				$ges=$value['mes'];			
			}
			
		}elseif($this->objParam->getParametro('tipo_reporte')=='profesiones'){
			$ges='';
			foreach ($datos as $value){
				
				if($ges!=$value['profesion']){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['profesion']);
					$fila++;
										
				}
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['desc_funcionario2']);

				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['profesion']);
				$fila++;
				$ges=$value['profesion'];			
			}
		}
		elseif($this->objParam->getParametro('tipo_reporte')=='listado_centros'){//#115
			$centro_uo='';
			foreach ($datos as $value){
				
				if($centro_uo!=$value['nombre_uo_centro']){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['nombre_uo_centro']);
					$fila++;
				}
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo_funcionario']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['desc_funcionario2']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['nombre_cargo']);
				$fila++;
				$centro_uo=$value['nombre_uo_centro'];			
			}
		}
		
		
		else{//lista_cargos
		  if( $this->objParam->getParametro('tipo_reporte')=='lista_cargos' ){
		
			foreach ($datos as $value){
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['nombre']);
				$fila++;			
			}
		  }elseif($this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos'){
			  	foreach ($datos as $value){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['codigo']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['nombre']);
					
					if($value['total_masculino']>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['total_masculino']);
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,'');
					}
										
					if($value['total_femenino']>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,$value['total_femenino']);
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,'');
					}
										
					
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila ,($value['total_femenino']+$value['total_masculino']));
					$fila++;			
				}
		  }elseif($this->objParam->getParametro('tipo_reporte')=='frecuencia_profesiones'){
		  	
			  	foreach ($datos as $value){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila ,$value['nombre']);
					
					if($value['total_masculino']>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,$value['total_masculino']);
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila ,'');
					}
										
					if($value['total_femenino']>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,$value['total_femenino']);
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila ,'');
					}
										
					
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila ,($value['total_femenino']+$value['total_masculino']));
					$fila++;			
				}
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
    function generarReporte($datos,$datos_titulo){ 
        $this->generarDatos($datos,$datos_titulo);
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        //$this->imprimeCabecera(0);

    }

}
?>