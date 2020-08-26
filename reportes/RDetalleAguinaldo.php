<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #87	ETR				10.01.2020			MZM					Habilitacion de opcion detalle de aguinaldo
 #92	ETR				13.02.2020			MZM					Ajuste a nombre de pagina cuando el valor es null
#155	ETR				22.07.2020			MZM-KPLIAN			Adaptacion de reporte para primas vigentes
 #158	ETR				19.08.2020			MZM-KPLIAN			Para Personal retirado adicionar periodo con el cual generar el reporte
*/
class RDetalleAguinaldo
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
       /* $this->docexcel->createSheet($index)->setTitle($name);
        $this->docexcel->setActiveSheetIndex($index);
		*/
		
		$sheetId = 0;
        $this->docexcel->createSheet(NULL, $sheetId);
        $this->docexcel->setActiveSheetIndex($sheetId);
        $this->docexcel->getActiveSheet()->setTitle('OVTPLA-T01');

        $this->docexcel->setActiveSheetIndex(0);
		
		
        return $this->docexcel;
    }

    function imprimeCabecera() {
        

    }

    function generarDatos($data)
    {
        $styleTitulos = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

 		$styleTitulosT = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'font' => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial',
                
                )
        );
		
		$styleTitulosST = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'font' => array(
                'bold'  => false,
                'size'  => 8,
                'name'  => 'Arial',
                
                ),
             'borders' => array(
               
              'right'     => array(
                'style' => PHPExcel_Style_Border::BORDER_MEDIUMDASHED     ,
                'color' => array(
                    'rgb' => '000000'
                )
             ),
            	'allborders'     => array(
                'style' => PHPExcel_Style_Border::BORDER_THIN     ,
                'color' => array(
                    'rgb' => '000000'
                )
             )
            )
        );
		
		
		$styleTitulosSTR = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'font' => array(
                'bold'  => true,
                'size'  => 8,
                'name'  => 'Arial',
                
                ),
             'borders' => array(
               
               'bottom'     => array(
                'style' => PHPExcel_Style_Border::BORDER_SLANTDASHDOT  ,
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            	'top'     => array(
                'style' => PHPExcel_Style_Border::BORDER_MEDIUMDASHED     ,
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            	'right'     => array(
                'style' => PHPExcel_Style_Border::BORDER_MEDIUMDASHED     ,
                'color' => array(
                    'rgb' => '000000'
                )
             ),
            	'vertical'     => array(
                'style' => PHPExcel_Style_Border::BORDER_THIN     ,
                'color' => array(
                    'rgb' => '000000'
                )
             )
            )
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

		$styleTitulosFirma = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'borders' => array(
               
               'bottom'     => array(
                'style' => PHPExcel_Style_Border::BORDER_SLANTDASHDOT  ,
                'color' => array(
                    'rgb' => '000000'
                )
            	)
			)
        );


		$styleTitulosSFirma = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            )
        );

        $this->numero = 1;
        $fila = 1;
		if ($this->objParam->getParametro('codigo_planilla')=='PLAGUIN'){
			$fila=3;
		}
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


        if ($this->objParam->getParametro('codigo_planilla')=='PLAGUIN' || $this->objParam->getParametro('codigo_planilla')=='PLASUE' ){
       // foreach ($datos as $value)
        //{
            
           // if($tipo_contrato != $value['estado']){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                $this->addHoja($this->objParam->getParametro('tipo_reporte'),$index);//#92
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
				$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
				$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
				$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
				
				if ($this->objParam->getParametro('codigo_planilla')=='PLAGUIN'){
					$this->docexcel->getActiveSheet()->mergeCells("A1:AH1");
					//#155
				//bono antiguedad
					if($this->objParam->getParametro('fecha_backup')!=''){
						$this->docexcel->getActiveSheet()->setCellValue('A1', 'DETALLE DE AGUINALDO ' .$datos[0]['gestion'].' [Backup: '.$dr.'/'.$mr.'/'.$ar.']');
					}else{
						$this->docexcel->getActiveSheet()->setCellValue('A1', 'DETALLE DE AGUINALDO ' .$datos[0]['gestion']);
					}
				
				}
				if ($this->objParam->getParametro('codigo_planilla')=='PLAGUIN'){
					$this->docexcel->getActiveSheet()->getStyle('A1:AH1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
					$this->docexcel->getActiveSheet()->getStyle('A1:AH1')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A1:AH1')->applyFromArray($styleTitulos3);
				}else{
					$this->docexcel->getActiveSheet()->getStyle('A1:AT1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
					$this->docexcel->getActiveSheet()->getStyle('A1:AT1')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A1:AT1')->applyFromArray($styleTitulos3);
   
				}
                
				
				
                //$this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,3);
                //$fila=$fila;
                $this->numero=1;
                $columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
                //$this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('nombre_tipo_contrato'));
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);//categoria
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);//fecha
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(25);//fecha
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(25);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(30);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(30);//mes

                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(40);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setWidth(20);//mes
				
				$this->docexcel->getActiveSheet()->getColumnDimension('AI')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AJ')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AK')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AL')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AM')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AN')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AO')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AP')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AR')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AS')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AT')->setWidth(20);//mes
				
				
				
				
                $this->docexcel->getActiveSheet()->setCellValue('A'.$fila,'Nº');//1
                $this->docexcel->getActiveSheet()->setCellValue('B'.$fila,'Tipo Doc Identificacion');//2
                $this->docexcel->getActiveSheet()->setCellValue('C'.$fila,'Nº Doc Identidad');//3
                $this->docexcel->getActiveSheet()->setCellValue('D'.$fila,'Lugar de expedición');//4
                $this->docexcel->getActiveSheet()->setCellValue('E'.$fila,'Fecha de nacimiento');//5
                $this->docexcel->getActiveSheet()->setCellValue('F'.$fila,'Apellido Paterno');//6
                $this->docexcel->getActiveSheet()->setCellValue('G'.$fila,'Apellido Materno');//7
                $this->docexcel->getActiveSheet()->setCellValue('H'.$fila,'Nombres');//8
                $this->docexcel->getActiveSheet()->setCellValue('I'.$fila,'País de nacionalidad');//9
                $this->docexcel->getActiveSheet()->setCellValue('J'.$fila,'Sexo');//10
                $this->docexcel->getActiveSheet()->setCellValue('K'.$fila,'Jubilado');//11
                $this->docexcel->getActiveSheet()->setCellValue('L'.$fila,'¿Aporta a la AFP?');//12
                $this->docexcel->getActiveSheet()->setCellValue('M'.$fila,'¿Persona con discapacidad?');//13
                $this->docexcel->getActiveSheet()->setCellValue('N'.$fila,'Tutor de persona con discapacidad');//14
                $this->docexcel->getActiveSheet()->setCellValue('O'.$fila,'Fecha de ingreso');//15
                $this->docexcel->getActiveSheet()->setCellValue('P'.$fila,'Fecha de retiro');//16
                $this->docexcel->getActiveSheet()->setCellValue('Q'.$fila,'Motivo retiro');//17
                $this->docexcel->getActiveSheet()->setCellValue('R'.$fila,'Caja de salud');//18
                $this->docexcel->getActiveSheet()->setCellValue('S'.$fila,'AFP a la que aporta');//19
                $this->docexcel->getActiveSheet()->setCellValue('T'.$fila,'NUA/CUA');//20
                $this->docexcel->getActiveSheet()->setCellValue('U'.$fila,'Sucursal o ubicación adicional');//21
                $this->docexcel->getActiveSheet()->setCellValue('V'.$fila,'Clasificación laboral');//22
                $this->docexcel->getActiveSheet()->setCellValue('W'.$fila,'Cargo');//23
                $this->docexcel->getActiveSheet()->setCellValue('X'.$fila,'Modalidad de contrato');//24
                
                if ($this->objParam->getParametro('codigo_planilla')=='PLAGUIN'){
                	$this->docexcel->getActiveSheet()->setCellValue('Y'.$fila,'Promedio haber básico');//25
                	$this->docexcel->getActiveSheet()->setCellValue('Z'.$fila,'Promedio bono de antigüedad');//26
	                $this->docexcel->getActiveSheet()->setCellValue('AA'.$fila,'Promedio bono producción');//27
	                $this->docexcel->getActiveSheet()->setCellValue('AB'.$fila,'Promedio subsidio frontera');//28
	                $this->docexcel->getActiveSheet()->setCellValue('AC'.$fila,'Promedio trabajo extraordinario y nocturno');//29
					$this->docexcel->getActiveSheet()->setCellValue('AD'.$fila,'Promedio pago dominical trabajado');//30
					$this->docexcel->getActiveSheet()->setCellValue('AE'.$fila,'Promedio otros bonos');//31
					$this->docexcel->getActiveSheet()->setCellValue('AF'.$fila,'Promedio total ganado');//32
					$this->docexcel->getActiveSheet()->setCellValue('AG'.$fila,'Meses trabajados');//33
					$this->docexcel->getActiveSheet()->setCellValue('AH'.$fila,'Total ganado después de duodécimas');//34
				}else{
					
					
					$this->docexcel->getActiveSheet()->setCellValue('Y'.$fila,'Tipo contrato');//25
                	$this->docexcel->getActiveSheet()->setCellValue('Z'.$fila,'Días pagados');//26
	                $this->docexcel->getActiveSheet()->setCellValue('AA'.$fila,'Horas pagadas');//27
	                $this->docexcel->getActiveSheet()->setCellValue('AB'.$fila,'Haber Básico');//28
	                $this->docexcel->getActiveSheet()->setCellValue('AC'.$fila,'Bono de antigüedad');//29
					$this->docexcel->getActiveSheet()->setCellValue('AD'.$fila,'Horas extra');//30
					$this->docexcel->getActiveSheet()->setCellValue('AE'.$fila,'Monto horas extra');//31
					$this->docexcel->getActiveSheet()->setCellValue('AF'.$fila,'Horas recargo nocturno');//32
					$this->docexcel->getActiveSheet()->setCellValue('AG'.$fila,'Monto horas extra nocturnas');//33
					$this->docexcel->getActiveSheet()->setCellValue('AH'.$fila,'Horas extra dominicales');//34
					
					            
					
					$this->docexcel->getActiveSheet()->setCellValue('AI'.$fila,'Monto horas extra dominicales');//34
					$this->docexcel->getActiveSheet()->setCellValue('AJ'.$fila,'Domingos trabajados');//34
					$this->docexcel->getActiveSheet()->setCellValue('AK'.$fila,'Monto domingo trabajado');//34
					$this->docexcel->getActiveSheet()->setCellValue('AL'.$fila,'Nro. dominicales');//34
					$this->docexcel->getActiveSheet()->setCellValue('AM'.$fila,'Salario dominical');//34
					$this->docexcel->getActiveSheet()->setCellValue('AN'.$fila,'Bono producción');//34
					$this->docexcel->getActiveSheet()->setCellValue('AO'.$fila,'Subsidio frontera');//34
					$this->docexcel->getActiveSheet()->setCellValue('AP'.$fila,'Otros bonos y pagos');//34
					$this->docexcel->getActiveSheet()->setCellValue('AQ'.$fila,'RC-IVA');//34
					$this->docexcel->getActiveSheet()->setCellValue('AR'.$fila,'Aporte Caja Salud');//34
					$this->docexcel->getActiveSheet()->setCellValue('AS'.$fila,'Aporte AFP');//34
					$this->docexcel->getActiveSheet()->setCellValue('AT'.$fila,'Otros descuentos');//34
						
							
				}
                
				$nombre_centro='';
				$cont=1;
				$fila++;
				foreach ($datos as $value){
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $cont);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['tipo_documento']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['num_documento']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['expedicion']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, date_format(date_create($value['fecha_nacimiento']),'d/m/Y'));
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['paterno']);
                 	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['materno'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['nombre'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['nacionalidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['genero']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila, $value['jubilado'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila, $value['aporta_afp'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila, $value['persona_discapacidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila, $value['tutor_discapacidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila, date_format(date_create($value['fecha_ingreso']),'d/m/Y') );
					
					if($value['fecha_retiro']!=''){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila, date_format(date_create($value['fecha_retiro']),'d/m/Y'));
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila, $value['motivo_retiro'] );
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila, '');
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila, '');
					}
			
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17,$fila, $value['caja_salud'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18,$fila, $value['nombre_afp'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19,$fila, $value['nro_afp'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20,$fila, $value['sucursal'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21,$fila, $value['clasificacion_laboral'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22,$fila, $value['cargo'] );
					
					
					
					if ($this->objParam->getParametro('codigo_planilla')=='PLAGUIN'){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23,$fila, $value['modalidad_ctto'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24,$fila, $value['haber_basico'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25,$fila, $value['bono_ant'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26,$fila, $value['bono_prod'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27,$fila, $value['bono_frontera'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28,$fila, $value['extra_noct'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(29,$fila, 0 );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(30,$fila, $value['otros'] );
						$tot=($value['otros'] + $value['haber_basico']+$value['bono_ant']+$value['extra_noct']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(31,$fila, $tot);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(32,$fila, $value['meses'] );
						$tot_duo=round(($tot*$value['meses']/360),2);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(33,$fila, $tot_duo);
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23,$fila, $value['modalidad_ctto'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24,$fila, $value['tipo_contrato'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25,$fila, $value['dias_pagados'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26,$fila, $value['horas_pagadas'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27,$fila, $value['haber_basico'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28,$fila, $value['bono_ant'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(29,$fila, $value['horas_extra'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(30,$fila, $value['monto_extra'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(31,$fila, $value['horas_noct'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(32,$fila, $value['monto_noct'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(33,$fila, 0.00 );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(34,$fila, 0.00);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(35,$fila, 0.00);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(36,$fila, 0.00);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(37,$fila, 0.00);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(38,$fila, 0.00);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(39,$fila, $value['bono_prod']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(40,$fila, $value['bono_frontera'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(41,$fila, $value['otros'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(42,$fila, $value['rc_iva'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(43,$fila, $value['cps'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(44,$fila, $value['afp'] );
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(45,$fila, $value['otros_desc'] );
					}				 
					$fila++;
					$cont++;
				}


				if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
					$sheetId = 1;
        			$this->docexcel->createSheet(NULL, $sheetId);
			        $this->docexcel->setActiveSheetIndex($sheetId);
			        $this->docexcel->getActiveSheet()->setTitle('Resumen');

        			$this->docexcel->setActiveSheetIndex(1);
					$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(55);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(55);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);

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
                    'rgb' => 'c5d9f1'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->docexcel->getActiveSheet()->getStyle('A1:F1')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A5:C5')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('A8:F8')->applyFromArray($styleTitulos);

        $this->docexcel->getActiveSheet()->getStyle('C16:D16')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle('D18:F18')->applyFromArray($styleTitulos);

        $this->docexcel->getActiveSheet()->setCellValue('A1','Seguro social a corto plazo');

        $this->docexcel->getActiveSheet()->setCellValue('A2','4.1.1 N°asegurados al ente gestor');
        $this->docexcel->getActiveSheet()->setCellValue('B2',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('C2','4.2.1 monto aportado');
        $this->docexcel->getActiveSheet()->setCellValue('D2',$this->resumen['caja']);
        $this->docexcel->getActiveSheet()->setCellValue('E2','4.3.1 ente gestor de salud corto plazo');
        $this->docexcel->getActiveSheet()->setCellValue('F2','CAJA PETROLERA DE SALUD');

        $this->docexcel->getActiveSheet()->setCellValue('A3','4.1.1 N°asegurados al ente gestor');
        $this->docexcel->getActiveSheet()->setCellValue('B3',0);
        $this->docexcel->getActiveSheet()->setCellValue('C3','4.2.1 monto aportado');
        $this->docexcel->getActiveSheet()->setCellValue('D3',0);

        $this->docexcel->getActiveSheet()->setCellValue('A5','Seguro social a largo plazo');

        $this->docexcel->getActiveSheet()->setCellValue('A6','4.4 Nº total de afiliados al seguro a largo plazo (AFP´s)');
        $this->docexcel->getActiveSheet()->setCellValue('B6',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('C6','4.5 Monto aportado (Total aporte de los trabajadores Bs)');
        $this->docexcel->getActiveSheet()->setCellValue('D6',$this->resumen['afp']);

        $this->docexcel->getActiveSheet()->setCellValue('A8','5. COMPOSICIÓN SALARIAL');
        $this->docexcel->getActiveSheet()->setCellValue('C8','6. TRABAJADORES');

        $this->docexcel->getActiveSheet()->setCellValue('A10','Concepto');
        $this->docexcel->getActiveSheet()->setCellValue('B10','Monto (Bs)');
        $this->docexcel->getActiveSheet()->setCellValue('D10','Varones');
        $this->docexcel->getActiveSheet()->setCellValue('E10','Mujeres');
        $this->docexcel->getActiveSheet()->setCellValue('F10','Total');

        $this->docexcel->getActiveSheet()->setCellValue('A11','5.1 Haber básico');
        $this->docexcel->getActiveSheet()->setCellValue('B11',$this->resumen['basico']);
        $this->docexcel->getActiveSheet()->setCellValue('C11','6.1 Total trabajadores');
        $this->docexcel->getActiveSheet()->setCellValue('D11',$this->resumen['trabajadores_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E11',$this->resumen['trabajadores_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F11',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A12','5.2 Bono de antigüedad');
        $this->docexcel->getActiveSheet()->setCellValue('B12',$this->resumen['antiguedad']);
        $this->docexcel->getActiveSheet()->setCellValue('C12','6.2 Personas jubiladas');
        $this->docexcel->getActiveSheet()->setCellValue('D12',$this->resumen['jubilados_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E12',$this->resumen['jubilados_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F12',$this->resumen['jubilados_mujeres'] + $this->resumen['jubilados_varones']);

        $this->docexcel->getActiveSheet()->setCellValue('A13','5.3 Bono de producción');
        $this->docexcel->getActiveSheet()->setCellValue('B13',0);
        $this->docexcel->getActiveSheet()->setCellValue('C13','6.3 Personas extranjeras');
        $this->docexcel->getActiveSheet()->setCellValue('D13',$this->resumen['extranjeros_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E13',$this->resumen['extranjeros_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F13',$this->resumen['extranjeros_varones'] + $this->resumen['extranjeros_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A14','5.4 Subsidio de frontera');
        $this->docexcel->getActiveSheet()->setCellValue('B14',$this->resumen['frontera']);
        $this->docexcel->getActiveSheet()->setCellValue('C14','6.4 Personas con discapacidad');
        $this->docexcel->getActiveSheet()->setCellValue('D14',$this->resumen['discapacitados_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E14',$this->resumen['discapacitados_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F14',$this->resumen['discapacitados_varones'] + $this->resumen['discapacitados_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A15','5.5 Trabajo extraordinario y nocturno');
        $this->docexcel->getActiveSheet()->setCellValue('B15',0);
        $this->docexcel->getActiveSheet()->setCellValue('C15','');
        $this->docexcel->getActiveSheet()->setCellValue('D15','');
        $this->docexcel->getActiveSheet()->setCellValue('E15','');
        $this->docexcel->getActiveSheet()->setCellValue('F15','');

        $this->docexcel->getActiveSheet()->setCellValue('A16','5.6 Pago dominical y domingo trabajado');
        $this->docexcel->getActiveSheet()->setCellValue('B16',0);
        $this->docexcel->getActiveSheet()->setCellValue('C16','7. INFORMACIÓN TRIMESTRAL, ACCIDENTES Y ENFERMEDADES DE TRABAJO');
        $this->docexcel->getActiveSheet()->setCellValue('D16','');
        $this->docexcel->getActiveSheet()->setCellValue('E16','');
        $this->docexcel->getActiveSheet()->setCellValue('F16','');

        $this->docexcel->getActiveSheet()->setCellValue('A17','5.7 Otros bonos');
        $this->docexcel->getActiveSheet()->setCellValue('B17',$this->resumen['otros_bonos']);
        $this->docexcel->getActiveSheet()->setCellValue('C17','');
        $this->docexcel->getActiveSheet()->setCellValue('D17','');
        $this->docexcel->getActiveSheet()->setCellValue('E17','');
        $this->docexcel->getActiveSheet()->setCellValue('F17','');

        $this->docexcel->getActiveSheet()->setCellValue('A18','5.8 Total ganado');
        $this->docexcel->getActiveSheet()->setCellValue('B18',$this->resumen['total_ganado']);
        $this->docexcel->getActiveSheet()->setCellValue('C18','');
        $this->docexcel->getActiveSheet()->setCellValue('D18','Varones');
        $this->docexcel->getActiveSheet()->setCellValue('E18','Mujeres');
        $this->docexcel->getActiveSheet()->setCellValue('F18','Total');

        $this->docexcel->getActiveSheet()->setCellValue('A19','5.9 Aporte a las AFPs');
        $this->docexcel->getActiveSheet()->setCellValue('B19',$this->resumen['afp']);
        $this->docexcel->getActiveSheet()->setCellValue('C19','7.1 Personas contratadas en el trimestre');
        $this->docexcel->getActiveSheet()->setCellValue('D19',$this->resumen['contrato_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E19',$this->resumen['contrato_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F19',$this->resumen['contrato_varones'] + $this->resumen['contrato_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A20','5.10 RC-IVA');
        $this->docexcel->getActiveSheet()->setCellValue('B20',$this->resumen['iva']);
        $this->docexcel->getActiveSheet()->setCellValue('C20','7.2 Personas retiradas en el trimestre');
        $this->docexcel->getActiveSheet()->setCellValue('D20',$this->resumen['retiro_varones']);
        $this->docexcel->getActiveSheet()->setCellValue('E20',$this->resumen['retiro_mujeres']);
        $this->docexcel->getActiveSheet()->setCellValue('F20',$this->resumen['retiro_varones'] + $this->resumen['retiro_mujeres']);

        $this->docexcel->getActiveSheet()->setCellValue('A21','5.11 Otros descuentos');
        $this->docexcel->getActiveSheet()->setCellValue('B21',$this->resumen['otros_descuentos']);
        $this->docexcel->getActiveSheet()->setCellValue('C21','');
        $this->docexcel->getActiveSheet()->setCellValue('D21','');
        $this->docexcel->getActiveSheet()->setCellValue('E21','');
        $this->docexcel->getActiveSheet()->setCellValue('F21','');

        $this->docexcel->getActiveSheet()->setCellValue('A22','5.12 Total descuentos');
        $this->docexcel->getActiveSheet()->setCellValue('B22',$this->resumen['total_descuentos']);
        $this->docexcel->getActiveSheet()->setCellValue('C22','');
        $this->docexcel->getActiveSheet()->setCellValue('D22','');
        $this->docexcel->getActiveSheet()->setCellValue('E22','');
        $this->docexcel->getActiveSheet()->setCellValue('F22','');

        $this->docexcel->getActiveSheet()->setCellValue('A23','5.13 Líquido pagable');
        $this->docexcel->getActiveSheet()->setCellValue('B23',$this->resumen['liquido_pagable']);
        $this->docexcel->getActiveSheet()->setCellValue('C23','');
        $this->docexcel->getActiveSheet()->setCellValue('D23','');
        $this->docexcel->getActiveSheet()->setCellValue('E23','');
        $this->docexcel->getActiveSheet()->setCellValue('F23','');
				}



		}else{//planilla de primas
			$this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('nombre_tipo_contrato'));
			$this->docexcel->getActiveSheet()->mergeCells("A1:E1");	
			$this->docexcel->getActiveSheet()->mergeCells("A2:E2");
			$this->docexcel->getActiveSheet()->mergeCells("A3:E3");
			$this->docexcel->getActiveSheet()->mergeCells("A4:E4");
			//$this->docexcel->getActiveSheet()->getStyle('A1:A1')->getAlignment()->setWrapText(true);
            $this->docexcel->getActiveSheet()->getStyle('A1:E1')->applyFromArray($styleTitulos);
			$this->docexcel->getActiveSheet()->getStyle('A2:E2')->applyFromArray($styleTitulos);
			$this->docexcel->getActiveSheet()->getStyle('A3:E3')->applyFromArray($styleTitulos);
			$this->docexcel->getActiveSheet()->getStyle('A4:E4')->applyFromArray($styleTitulos);
            //$this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,3);
                
		
		
			list($razon_social, $nitE, $minT, $numCPS,$nombreGG, $ciGG ) = explode("@@@", $datos[0]['tutor_discapacidad']);

			$this->docexcel->getActiveSheet()->setCellValue('A1','NOMBRE O RAZÓN SOCIAL: '.$razon_social );
			$this->docexcel->getActiveSheet()->setCellValue('A2','Nº EMPLEADOR MINISTERIO DE TRABAJO: '.$minT );
			$this->docexcel->getActiveSheet()->setCellValue('A3','Nº DE NIT: '.$nitE );	
			$this->docexcel->getActiveSheet()->setCellValue('A4','Nº DE EMPLEADOR (Caja de Salud): '.$numCPS );					
	
			
			
			$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
			$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
			$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
			$this->docexcel->getActiveSheet()->mergeCells("A6:T6");	
			
			$this->docexcel->getActiveSheet()->getStyle('A6:T6')->applyFromArray($styleTitulosT);
			$this->docexcel->getActiveSheet()->getStyle('A7:T7')->applyFromArray($styleTitulosT);
			
			if($this->objParam->getParametro('fecha_backup')!=''){
				$this->docexcel->getActiveSheet()->setCellValue('A6', 'PLANILLA DE PAGO DE PRIMA ' .' [Backup: '.$dr.'/'.$mr.'/'.$ar.']');
			}else{
				$this->docexcel->getActiveSheet()->setCellValue('A6', 'PLANILLA DE PAGO DE PRIMA');
			}
			$this->docexcel->getActiveSheet()->mergeCells("A7:T7");	
			$this->docexcel->getActiveSheet()->setCellValue('A7', '(En Bolivianos)');
			//$datos[0]['gestion']

			$this->docexcel->getActiveSheet()->setCellValue('T8', 'GESTION '.$datos[0]['gestion']);
			
			
				$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(4);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);//categoria
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(10);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(10);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(14);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(10);//fecha
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(6);//fecha
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(10);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(10);//mes
			
			//$this->docexcel->getActiveSheet()->getColumnDimension('A10')->setHeight(30);
				$this->docexcel->getActiveSheet()->getRowDimension(10)->setRowHeight(55);
				$this->docexcel->getActiveSheet()->getStyle('A10:A10')->applyFromArray($styleTitulosSTR);
				$this->docexcel->getActiveSheet()->getStyle('B10:H10')->applyFromArray($styleTitulosSTR);
				$this->docexcel->getActiveSheet()->getStyle('I10:J10')->applyFromArray($styleTitulosSTR);
				$this->docexcel->getActiveSheet()->getStyle('K10:K10')->applyFromArray($styleTitulosSTR);
				$this->docexcel->getActiveSheet()->getStyle('L10:Q10')->applyFromArray($styleTitulosSTR);
				$this->docexcel->getActiveSheet()->getStyle('R10:R10')->applyFromArray($styleTitulosSTR);
				$this->docexcel->getActiveSheet()->getStyle('S10:S10')->applyFromArray($styleTitulosSTR);
				$this->docexcel->getActiveSheet()->getStyle('T10:T10')->applyFromArray($styleTitulosSTR);
				
				
 				$this->docexcel->getActiveSheet()->setCellValue('A10','Nº');//1
                $this->docexcel->getActiveSheet()->setCellValue('B10','CARNET DE '. PHP_EOL .'IDENTIDAD');//2
                $this->docexcel->getActiveSheet()->setCellValue('C10','APELLIDO'. PHP_EOL .'PATERNO');//3
                $this->docexcel->getActiveSheet()->setCellValue('D10','APELLIDO'. PHP_EOL .'MATERNO');//4
                $this->docexcel->getActiveSheet()->setCellValue('E10','NOMBRES');//5
                $this->docexcel->getActiveSheet()->setCellValue('F10','NACIONALIDAD');//6
                $this->docexcel->getActiveSheet()->setCellValue('G10','FECHA DE'. PHP_EOL .'NACIMIENTO');//7
                $this->docexcel->getActiveSheet()->setCellValue('H10','SEXO'. PHP_EOL .'(F/M)');//8
                $this->docexcel->getActiveSheet()->setCellValue('I10','OCUPACIÓN QUE'. PHP_EOL .'DESEMPEÑA');//9
                $this->docexcel->getActiveSheet()->setCellValue('J10','FECHA DE'. PHP_EOL .'INGRESO');//10
                $this->docexcel->getActiveSheet()->setCellValue('K10','Haber básico'. PHP_EOL .'(A)');//11
                $this->docexcel->getActiveSheet()->setCellValue('L10','Bono de'. PHP_EOL .'antigüedad'. PHP_EOL .'(B)');//12
                $this->docexcel->getActiveSheet()->setCellValue('M10','Bono de'. PHP_EOL .'producción'. PHP_EOL .'(C)');//13
                $this->docexcel->getActiveSheet()->setCellValue('N10','Subsidio de'. PHP_EOL .'frontera'. PHP_EOL .'(D)');//14
                $this->docexcel->getActiveSheet()->setCellValue('O10','Trabajo'. PHP_EOL .'extraordinario'. PHP_EOL .'y nocturno'. PHP_EOL .'(E)');//15
                $this->docexcel->getActiveSheet()->setCellValue('P10','Pago'. PHP_EOL .'dominical y'. PHP_EOL .'domingo'. PHP_EOL .'trabajado'. PHP_EOL .'(F)');//16
                $this->docexcel->getActiveSheet()->setCellValue('Q10','Otros bonos'. PHP_EOL .'(G)');//17
                $this->docexcel->getActiveSheet()->setCellValue('R10','Total ganado'. PHP_EOL .'(H=A+B+C+D+'. PHP_EOL .'E+F+G)');//18
                $this->docexcel->getActiveSheet()->setCellValue('S10','Total ganado'. PHP_EOL .'(J=H*I/12)');//19
                $this->docexcel->getActiveSheet()->setCellValue('T10','FIRMA DEL'. PHP_EOL .'EMPLEADO');//20		
				$fila=11;
				$cont=1;
				
				
				$t1=0; $t2=0; $t3=0; $t4=0; $t5=0; $t6=0; $t7=0; $t8=0; $t9=0; 
				foreach ($datos as $value){
					
					
					$this->docexcel->getActiveSheet()->getRowDimension($fila)->setRowHeight(35);
					$this->docexcel->getActiveSheet()->getStyle('A'.$fila.':A'.$fila)->applyFromArray($styleTitulosST);
					$this->docexcel->getActiveSheet()->getStyle('B'.$fila.':H'.$fila)->applyFromArray($styleTitulosST);
					$this->docexcel->getActiveSheet()->getStyle('I'.$fila.':J'.$fila)->applyFromArray($styleTitulosST);
					$this->docexcel->getActiveSheet()->getStyle('K'.$fila.':K'.$fila)->applyFromArray($styleTitulosST);
					$this->docexcel->getActiveSheet()->getStyle('L'.$fila.':Q'.$fila)->applyFromArray($styleTitulosST);
					$this->docexcel->getActiveSheet()->getStyle('R'.$fila.':R'.$fila)->applyFromArray($styleTitulosST);
					$this->docexcel->getActiveSheet()->getStyle('S'.$fila.':S'.$fila)->applyFromArray($styleTitulosST);
					$this->docexcel->getActiveSheet()->getStyle('T'.$fila.':T'.$fila)->applyFromArray($styleTitulosST);
			
					
					
					
					
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $cont);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['num_documento']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['paterno']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['materno']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nombre'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nacionalidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, date_format(date_create($value['fecha_nacimiento']),'d/m/Y'));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['genero']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila, $value['cargo'] );
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila, date_format(date_create($value['fecha_ingreso']),'d/m/Y') );
					
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila, $value['haber_basico'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila, $value['bono_ant'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila, $value['bono_prod'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila, $value['bono_frontera'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila, $value['extra_noct'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila, 0 );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila, $value['otros'] );
					$tot=($value['otros'] + $value['haber_basico']+$value['bono_ant']+$value['extra_noct']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17,$fila, $tot);
					//$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18,$fila, $value['meses'] );
					$tot_duo=round(($tot*$value['meses']/360),2);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18,$fila, $tot_duo);
					$t1=$t1+$value['haber_basico'];
					$t2=$t2+$value['bono_ant'];
					$t3=$t3+$value['bono_prod'];
					$t4=$t4+$value['bono_frontera'];
					$t5=$t5+$value['extra_noct'];
					$t6=$t6+0;
					$t7=$t7+$value['otros'];
					$t8=$t8+$tot;
					$t9=$t9+$tot_duo;	
									 
					$fila++;
					$cont++;
				}



					$this->docexcel->getActiveSheet()->getStyle('A'.$fila.':J'.$fila)->applyFromArray($styleTitulosSTR);
					//$this->docexcel->getActiveSheet()->getStyle('B'.$fila.':H'.$fila)->applyFromArray($styleTitulosSTR);
					//$this->docexcel->getActiveSheet()->getStyle('I'.$fila.':J'.$fila)->applyFromArray($styleTitulosSTR);
					$this->docexcel->getActiveSheet()->getStyle('K'.$fila.':K'.$fila)->applyFromArray($styleTitulosSTR);
					$this->docexcel->getActiveSheet()->getStyle('L'.$fila.':Q'.$fila)->applyFromArray($styleTitulosSTR);
					$this->docexcel->getActiveSheet()->getStyle('R'.$fila.':R'.$fila)->applyFromArray($styleTitulosSTR);
					$this->docexcel->getActiveSheet()->getStyle('S'.$fila.':S'.$fila)->applyFromArray($styleTitulosSTR);
					$this->docexcel->getActiveSheet()->getStyle('T'.$fila.':T'.$fila)->applyFromArray($styleTitulosSTR);
			
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila, 'TOTALES');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila, $t1);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila, $t2);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila, $t3);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila, $t4);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila, $t5);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila, $t6);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila, $t7);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17,$fila, $t8);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18,$fila, $t9);
				
				$fila=$fila+5;
				$this->docexcel->getActiveSheet()->mergeCells("C".$fila.":G".$fila);
				$this->docexcel->getActiveSheet()->mergeCells("J".$fila.":L".$fila);
				$this->docexcel->getActiveSheet()->mergeCells("O".$fila.":Q".$fila);	
				
				$this->docexcel->getActiveSheet()->getStyle('C'.$fila.':G'.$fila)->applyFromArray($styleTitulosFirma);
				$this->docexcel->getActiveSheet()->getStyle('J'.$fila.':L'.$fila)->applyFromArray($styleTitulosFirma);
				$this->docexcel->getActiveSheet()->getStyle('O'.$fila.':Q'.$fila)->applyFromArray($styleTitulosFirma);
				
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila, $nombreGG);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila, $ciGG);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila, '');
				
				
				
				
				$fila++;
				$this->docexcel->getActiveSheet()->mergeCells("C".$fila.":G".$fila);
				$this->docexcel->getActiveSheet()->mergeCells("J".$fila.":L".$fila);
				$this->docexcel->getActiveSheet()->mergeCells("O".$fila.":Q".$fila);
				
				$this->docexcel->getActiveSheet()->getStyle('C'.$fila.':G'.$fila)->applyFromArray($styleTitulosSFirma);
				$this->docexcel->getActiveSheet()->getStyle('J'.$fila.':L'.$fila)->applyFromArray($styleTitulosSFirma);
				$this->docexcel->getActiveSheet()->getStyle('O'.$fila.':Q'.$fila)->applyFromArray($styleTitulosSFirma);
				
				
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila, 'NOMBRE DEL EMPLEADOR O REPRESENTANTE LEGAL');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila, 'Nº DE DOCUMENTO DE IDENTIDAD');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila, 'FIRMA');
				
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