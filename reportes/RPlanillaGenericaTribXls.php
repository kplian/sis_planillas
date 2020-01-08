<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #77    ETR            14/11/2019           MZM                 Creacion 
 #77	ETR			   19/11/2019			MZM					Cambio en for
 #83	ETR				10.12.2019			MZM					Habilitacion de opcion historico de planilla
 * 
*/
class RPlanillaGenericaTribXls
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
        $this->docexcel->createSheet($index)->setTitle('XXXXX'.$name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function imprimeCabecera() {
        

    }

    function generarDatos($data, $data_det)
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
        $datos_det=$data_det;
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
               
				
                
	            $this->docexcel->getActiveSheet()->getStyle('A3:X3')->getAlignment()->setWrapText(true);
	            $this->docexcel->getActiveSheet()->getStyle('A3:X3')->applyFromArray($styleTitulos3);
				
				
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,4);
                $fila=4;
                $this->numero=1;
                //$columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
				
				
	                $this->docexcel->getActiveSheet()->setTitle('RelacionSaldos');
	                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);//categoria
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setWidth(15);//pres
	                
	                $this->docexcel->getActiveSheet()->setCellValue('A3','Año');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','Periodo');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C3','Codigo Dep RCIVA');//3
	                $this->docexcel->getActiveSheet()->setCellValue('D3','Nombres');//3
	                $this->docexcel->getActiveSheet()->setCellValue('E3','Primer Apellido');//3
	                $this->docexcel->getActiveSheet()->setCellValue('F3','Segundo Apellido');//3
	                $this->docexcel->getActiveSheet()->setCellValue('G3','Nº Doc Identidad');//3
	                $this->docexcel->getActiveSheet()->setCellValue('H3','Tipo Doc.Identidad');//3
	                $this->docexcel->getActiveSheet()->setCellValue('I3','Novedad(I=Ingreso,V=Vigente,D=Desvinculado)');//3
	                $this->docexcel->getActiveSheet()->setCellValue('J3','Monto de Ingreso Neto');//3
	                $this->docexcel->getActiveSheet()->setCellValue('K3','2 SMN no imponibles');//3
	                $this->docexcel->getActiveSheet()->setCellValue('L3','Importe sujeto a impuesto(base imponible)');//3
	                $this->docexcel->getActiveSheet()->setCellValue('M3','Impuesto RCIVA');//3
	                $this->docexcel->getActiveSheet()->setCellValue('N3','13% de 2SMN');//3
	                $this->docexcel->getActiveSheet()->setCellValue('O3','Impuesto Neto RCIVA');//3
	                $this->docexcel->getActiveSheet()->setCellValue('P3','F-110 13% de facturas presentadas');//3
	                $this->docexcel->getActiveSheet()->setCellValue('Q3','Saldo a favor del Fisco');//3
	                $this->docexcel->getActiveSheet()->setCellValue('R3','Saldo a favor del dependiente');//3
	                $this->docexcel->getActiveSheet()->setCellValue('S3','Saldo a favor del dependiente periodo anterior');//3
	                $this->docexcel->getActiveSheet()->setCellValue('T3','Mantenimiento de valor del saldo a favor del dependiente periodo anterior');//3
	                $this->docexcel->getActiveSheet()->setCellValue('U3','Saldo del periodo anterior actualizado');//3
	                $this->docexcel->getActiveSheet()->setCellValue('V3','Saldo utilizado');//3
	                $this->docexcel->getActiveSheet()->setCellValue('W3','Impuesto RcIVA retenido');//3
	                $this->docexcel->getActiveSheet()->setCellValue('X3','Saldo del credito fiscal a favor del dependiente para el mes siguiente');//3
	                
	                
	                $this->docexcel->getActiveSheet()->getStyle('C')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
					
				 
                

				$tit_rep='PLANILLA TRIBUTARIA';
	    //#83
		$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
		$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
		$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
		if($this->objParam->getParametro('fecha_backup')!=''){
			
			$tit_rep= $tit_rep. " [Backup: ".$dr.'/'.$mr.'/'.$ar.']';
		}
                $this->docexcel->getActiveSheet()->mergeCells("A1:X1"); 
				$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
				$this->docexcel->getActiveSheet()->mergeCells("A2:X2");
				$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A2', 'A: '.$datos['periodo_lite']);
				 
				
				$tipo_contrato='';
				
				$id_funcionario=0; 
				$columnas=0;
				foreach ($datos_det as $value){//#77

					if($id_funcionario!=$value['id_funcionario'] ){
						if($id_funcionario!=0){
							$fila++;	
						}
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['gestion']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['periodo']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['codigo_rciva']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nombre']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['apellido_paterno']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['apellido_materno']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['num_ci']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, 'CI');
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['novedad']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['valor']);
					    $columnas=10;
						
					} else{
			 	  	  
					   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columnas, $fila, $value['valor']);
					   $columnas++;
					}
					 $id_funcionario=$value['id_funcionario'];
					
					
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
    function generarReporte($datos,$datos_det){ //echo ($datos['periodo_lite']); exit;
        $this->generarDatos($datos,$datos_det);
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        //$this->imprimeCabecera(0);

    }

}
?>