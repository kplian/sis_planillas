<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #160	ETR				27.08.2020			MZM-KPLIAN			Grupo Familiar xls
 #161	ETR				07.09.2020			MZM-KPLIAN			Ajuste en encabezado, quitando tipo contrato planta
 #ETR-1379				16.10.2020			MZM-KPLIAN 			Modificacion reporte grupo familiar, genero del depediente  
*/
class REmpleadoDepXls
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
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'A0C4DE'//'99BCD5'
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


       if(count($datos)>0){//#123
       
                
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,4);
                $fila=4;
                $this->numero=1;
                //$columna = 8;

				
				
	                $this->docexcel->getActiveSheet()->setTitle('GrupoFamiliar');
	                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);//categoria
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(10);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);//ci
	                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);//funcionario
	                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);//cargo
	                
	                
					
	                $this->docexcel->getActiveSheet()->setCellValue('A3','Fecha Nac');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','Nombre Dependiente');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C3','Edad');//3
	                $this->docexcel->getActiveSheet()->setCellValue('D3','Sexo');//5//ETR-1379
	                $this->docexcel->getActiveSheet()->setCellValue('E3','Nombre del Trabajador');//4
	                
	                $this->docexcel->getActiveSheet()->setCellValue('F3','Distrito');//6
	                
	                
	                $this->docexcel->getActiveSheet()->getStyle('E')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
					$this->docexcel->getActiveSheet()->getStyle('F')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
					$this->docexcel->getActiveSheet()->getStyle('G')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
				
				
                
                
 				//#83
 				if($data_titulo[0]['fecha_backup']!=''){
				$dr=substr($data_titulo[0]['fecha_backup'],0,2);
				$mr=substr($data_titulo[0]['fecha_backup'],3,2);
				$ar=substr($data_titulo[0]['fecha_backup'],6);
				$fecha_backup='';
				if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
					$fecha_backup=' [Backup:'.($dr.'/'.$mr.'/'.$ar).']';
				}}
				//#89				      
				$tipcon='';//#161
				$tipcon=$this->objParam->getParametro('nombre_tipo_contrato');
				if ($tipcon=='Planta') $tipcon='';
				if($tipcon!=''){
					//#98
					if ($tipcon!='Planta'){
						if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
							$tipcon=' ('.$tipcon.' - '.$this->objParam->getParametro('personal_activo').')';
						}else{
							$tipcon=' ('.$tipcon.')';
						}
					
					}else{
						if( $this->objParam->getParametro('personal_activo')!='todos'){
							$tipcon=' ('.$this->objParam->getParametro('personal_activo').')';
						}
					}
					
					
					
				}	  
					         
				if($this->objParam->getParametro('tipo_reporte')=='dependientes_edad'){
					$tit_rep='GRUPO FAMILIAR DE LOS TRABAJADORES '.$tipcon.$fecha_backup;
				}
				$this->docexcel->getActiveSheet()->getStyle('A1:F1')->applyFromArray($styleTitulos3);
                $this->docexcel->getActiveSheet()->mergeCells("A1:F1"); 
				$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
				$this->docexcel->getActiveSheet()->mergeCells("A2:F2");
				$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->getStyle('A3:F3')->applyFromArray($styleTitulos3);
				
				$this->docexcel->getActiveSheet()->setCellValue('A2', 'Clasificación de los hijos según edades');
				
				$rango=''; 
			
				
				foreach ($datos as $value){
					
					if ($rango!=$value['rango']){
						$this->docexcel->getActiveSheet()->mergeCells("A".$fila.":F".$fila);
						$this->docexcel->getActiveSheet()->getStyle("A".$fila.":F".$fila)->applyFromArray($styleTitulos2);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila,'Rango Edad: '.$value['rango']);
						$fila++;
					
					}
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, date_format(date_create($value['fecha_nacimiento_dep']),'d/m/Y'));
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_dep']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['edad_dep'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['genero'] );//#ETR-1379
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nombre_funcionario']);
					
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['distrito'] );
					
				    $rango=$value['rango'];
					$fila++;
				}
					/*$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,'TOTALES' );
              		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,number_format($tot_cot,2,'.',',') );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($tot_reserva,2,'.',','));
					
					//$value['tc']
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($tot_reserva1,2,'.',','));
                  */
            
		}
        //}
       // $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
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