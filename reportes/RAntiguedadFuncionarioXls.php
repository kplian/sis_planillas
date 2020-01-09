<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #77    ETR            14/11/2019           MZM                 Creacion 
 #83	ETR			   10.12.2019			MZM					Habilitacion de opcion historico de planilla
*/
class RAntiguedadFuncionarioXls
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
        $this->docexcel->createSheet($index)->setTitle('Hoja'.$name);
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


       
           
                $this->addHoja($value['tipo_contrato'],$index);
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
				
                if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){    
	                $this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A3:G3')->applyFromArray($styleTitulos3);
				}else{
					
					
				
				}
				
				
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,4);
                $fila=4;
                $this->numero=1;
                //$columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
				
				if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
	                $this->docexcel->getActiveSheet()->setTitle('InfEmpleados');
	                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);//categoria
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
	                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
	                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);//cargo
	                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);//fecha
	                
					
	                $this->docexcel->getActiveSheet()->setCellValue('A3','Centro');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','Codigo Emp');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C3','Nombre Completo');//3
	                $this->docexcel->getActiveSheet()->setCellValue('D3','Fecha Ingreso');//4
	                $this->docexcel->getActiveSheet()->setCellValue('E3','Antig Ant.');//5
	                $this->docexcel->getActiveSheet()->setCellValue('F3','Total Ant. Años');//6
	                $this->docexcel->getActiveSheet()->setCellValue('G3','Total Ant. Dias');//7
	                
	                $this->docexcel->getActiveSheet()->getStyle('F')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
					$this->docexcel->getActiveSheet()->getStyle('G')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
				}
				
				
                
                
                
if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
	$tit_rep='ANTIGUEDAD DE LOS EMPLEADOS';
	$this->etiqueta='Antiguedad';
}elseif($this->objParam->getParametro('tipo_reporte')=='empleado_edad'){
	$tit_rep='CLASIFICACION DEL PERSONAL POR EDADES';
	$this->etiqueta='Edad';
}
//#83
if ($this->objParam->getParametro('nombre_tipo_contrato')!=''){
			$tit_rep=$tit_rep.' ('.$this->objParam->getParametro('nombre_tipo_contrato').')';	
		}

//#83
				$dr=substr($data_titulo[0]['fecha_backup'],0,2);
				$mr=substr($data_titulo[0]['fecha_backup'],3,2);
				$ar=substr($data_titulo[0]['fecha_backup'],6);
				//$this->docexcel->getActiveSheet()->mergeCells("A3:G3");
				$this->docexcel->getActiveSheet()->getStyle('A3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				 
				$subtit='A: '.date_format(date_create($datos[0]['fecha_rep']),'d/m/Y');			
				if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
					$subtit=$subtit. '[Backup: '.$dr.'/'.$mr.'/'.$ar.']';
				}
	
                $this->docexcel->getActiveSheet()->mergeCells("A1:G1"); 
				$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
				$this->docexcel->getActiveSheet()->mergeCells("A2:G2");
				$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A2', $subtit);
				 
				
				//#83
				$dr=substr($data_titulo[0]['fecha_backup'],0,2);
				$mr=substr($data_titulo[0]['fecha_backup'],3,2);
				$ar=substr($data_titulo[0]['fecha_backup'],6);
				$this->docexcel->getActiveSheet()->mergeCells("A3:G3");
				$this->docexcel->getActiveSheet()->getStyle('A3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				
				if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
					$this->docexcel->getActiveSheet()->setCellValue('A3', 'Backup: '.$dr.'/'.$mr.'/'.$ar);
				}
				
				
				
				
				$nombre_centro='';
				$tot_cot=0;
				$tot_reserva=0;
				$tot_reserva1=0;
				
			
			
			
				$rango_ini=$this->objParam->getParametro('rango_ini');
				$rango_fin=$this->objParam->getParametro('rango_fin');
				$contador_rango=$rango_fin;
				$genero=$this->datos[0]['genero'];
				$rango='-1';
				
				$totalf=0;
				$totalm=0;
				$totala=0;
				$totald=0;
				
				foreach ($datos as $value){

					if($value['rango'].''.$value['genero']!=$rango.''.$genero){
					 	    $fila++;
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, 'Rango '.$this->etiqueta.' : '.$value['rango'].' ('.$value['genero'].')');
							$fila++;	
							
								
						}
								
								
								
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['nombre_uo_pre']);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['codigo']);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['desc_funcionario2']);
								
								if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, date_format(date_create($value['fecha_ingreso']),'d/m/Y'));
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['antiguedad_ant']);
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['antiguedad_anos']);
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['antiguedad']);
								}else{
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['cargo']);
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, date_format(date_create($value['fecha_nacimiento']),'d/m/Y'));
									$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['edad']);
									
								}
								$contf++;
								
							
						$genero=$value['genero'];
						$rango=$value['rango'];
						//#66
					if($value['genero']=='femenino'){
						$totalf++;
					}else{
						$totalm++;
					}
						
					$totala=$totala+$value['antiguedad_anos'];
					$totald=$totald+$value['antiguedad'];
					
					
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
    function generarReporte($datos,$datos_titulo){//#83 
        $this->generarDatos($datos,$datos_titulo);//#83 
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        //$this->imprimeCabecera(0);

    }

}
?>