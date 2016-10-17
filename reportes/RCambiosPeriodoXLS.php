<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RCambiosPeriodoXLS
{
	private $docexcel;
	private $objWriter;
	private $nombre_archivo;
	private $hoja;
	private $columnas=array();
	private $fila;
	private $equivalencias=array();
	
	private $indice, $m_fila, $titulo;
	private $swEncabezado=0; //variable que define si ya se imprimió el encabezado
	private $objParam;
	public  $url_archivo;
	
	
	function __construct(CTParametro $objParam){
		
		//reducido menos 23,24,26,27,29,30
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
		
		
		
		$this->docexcel->setActiveSheetIndex(0);
		
		$this->equivalencias=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
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
	
	function imprimeDatos(){
		$this->docexcel->getActiveSheet()->setTitle('ALTAS');
		$datos = $this->objParam->getParametro('altas');	
		$columnas = 0;
		$this->docexcel->setActiveSheetIndex(0);
		
		
				
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
		//ALTAS
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(40);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
		
		$this->docexcel->getActiveSheet()->getStyle('A1:I1')->getAlignment()->setWrapText(true); 	
		
		$this->docexcel->getActiveSheet()->getStyle('A1:I1')->applyFromArray($styleTitulos);
		
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('A1','Gerencia');
		$this->docexcel->getActiveSheet()->setCellValue('B1','Cargo');
		$this->docexcel->getActiveSheet()->setCellValue('C1','Haber Básico');
		$this->docexcel->getActiveSheet()->setCellValue('D1','Tipo Contrato');
		$this->docexcel->getActiveSheet()->setCellValue('E1','Presupuesto');
		$this->docexcel->getActiveSheet()->setCellValue('F1','Nombre');
		$this->docexcel->getActiveSheet()->setCellValue('G1','Fecha Inicio');
		$this->docexcel->getActiveSheet()->setCellValue('H1','Item');
		$this->docexcel->getActiveSheet()->setCellValue('I1','Certificacion');
				
		//*************************************Detalle*****************************************
		$fila = 1;
		
		$this->docexcel->getActiveSheet()->getStyle('I2:I500')->getNumberFormat()->setFormatCode( PHPExcel_Style_NumberFormat::FORMAT_GENERAL );
		foreach($datos as $value) {			
			$fila++;
			$columna = 0;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['nombre_unidad']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['cargo']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['haber_basico']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['tipo_contrato']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['codigo_cc']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['funcionario']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['fecha_inicio']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['item']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['certificacion']." ");						
		}

		
		//************************************************Fin Detalle***********************************************
		//BAJAS
		$sheetId = 1;
		$this->docexcel->createSheet(NULL, $sheetId);	
		$this->docexcel->setActiveSheetIndex($sheetId);	
		$this->docexcel->getActiveSheet()->setTitle('BAJAS');
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(40);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
		
		$this->docexcel->getActiveSheet()->getStyle('A1:H1')->getAlignment()->setWrapText(true); 	
		
		$this->docexcel->getActiveSheet()->getStyle('A1:H1')->applyFromArray($styleTitulos);
		
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('A1','Gerencia');
		$this->docexcel->getActiveSheet()->setCellValue('B1','Cargo');
		$this->docexcel->getActiveSheet()->setCellValue('C1','Haber Básico');
		$this->docexcel->getActiveSheet()->setCellValue('D1','Tipo Contrato');
		$this->docexcel->getActiveSheet()->setCellValue('E1','Presupuesto');
		$this->docexcel->getActiveSheet()->setCellValue('F1','Nombre');
		$this->docexcel->getActiveSheet()->setCellValue('G1','Fecha Fin');
		$this->docexcel->getActiveSheet()->setCellValue('H1','Item');
		
		$fila = 1;
		$datos = $this->objParam->getParametro('bajas');
		
		foreach($datos as $value) {			
			$fila++;
			$columna = 0;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['nombre_unidad']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['cargo']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['haber_basico']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['tipo_contrato']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['codigo_cc']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['funcionario']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['fecha_fin']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['item']);						
		}
		
		//MOVIMIENTOS
		$sheetId = 2;
		$this->docexcel->createSheet(NULL, $sheetId);	
		$this->docexcel->setActiveSheetIndex($sheetId);	
		$this->docexcel->getActiveSheet()->setTitle('MOVIMIENTOS');
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(40);
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(40);
		$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(20);
		
		$this->docexcel->getActiveSheet()->getStyle('A1:L1')->getAlignment()->setWrapText(true); 	
		$styleTitulos['fill']['color']['rgb'] = 'fffafa';
		$this->docexcel->getActiveSheet()->getStyle('C1:G1')->applyFromArray($styleTitulos);
		
		$styleTitulos['fill']['color']['rgb'] = 'c5d9f1';
		$this->docexcel->getActiveSheet()->getStyle('A1:B1')->applyFromArray($styleTitulos);
		$this->docexcel->getActiveSheet()->getStyle('H1:N1')->applyFromArray($styleTitulos);
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('A1','Funcionario');
		$this->docexcel->getActiveSheet()->setCellValue('B1','Fecha Mov');
		$this->docexcel->getActiveSheet()->setCellValue('C1','Gerencia Ant.');
		$this->docexcel->getActiveSheet()->setCellValue('D1','Cargo Ant');
		$this->docexcel->getActiveSheet()->setCellValue('E1','Tipo Ant');
		$this->docexcel->getActiveSheet()->setCellValue('F1','Presupuesto Ant.');
		$this->docexcel->getActiveSheet()->setCellValue('G1','Haber Ant.');
		$this->docexcel->getActiveSheet()->setCellValue('H1','Gerencia Act.');
		$this->docexcel->getActiveSheet()->setCellValue('I1','Cargo Act');
		$this->docexcel->getActiveSheet()->setCellValue('J1','Tipo Act');
		$this->docexcel->getActiveSheet()->setCellValue('K1','Presupuesto Act.');
		$this->docexcel->getActiveSheet()->setCellValue('L1','Haber Act.');
		$this->docexcel->getActiveSheet()->setCellValue('M1','Item');
		$this->docexcel->getActiveSheet()->setCellValue('N1','Certificacion');
		
		
		$fila = 1;
		$datos = $this->objParam->getParametro('movimientos');
		
		foreach($datos as $value) {			
			$fila++;
			$columna = 0;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['funcionario']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['fecha_movimiento']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['gerencia_anterior']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['cargo_anterior']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['tipo_contrato_anterior']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['presupuesto_anterior']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['haber_basico_anterior']);
			$columna++;			
			
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['gerencia_actual']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['cargo_actual']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['tipo_contrato_actual']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['presupuesto_actual']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['haber_basico_actual']);
			$columna++;	
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['item']);
			$columna++;	
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['certificacion']." ");
			$columna++;						
		}
		
		//ANTIGUEDAD
		$sheetId = 3;
		$this->docexcel->createSheet(NULL, $sheetId);	
		$this->docexcel->setActiveSheetIndex($sheetId);	
		$this->docexcel->getActiveSheet()->setTitle('ANTIGUEDAD');
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(18);
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(40);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(30);
		
		$this->docexcel->getActiveSheet()->getStyle('A1:H1')->getAlignment()->setWrapText(true); 	
		
		$this->docexcel->getActiveSheet()->getStyle('A1:H1')->applyFromArray($styleTitulos);
		
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('A1','Antiguedad');
		$this->docexcel->getActiveSheet()->setCellValue('B1','Gerencia');
		$this->docexcel->getActiveSheet()->setCellValue('C1','Cargo');
		$this->docexcel->getActiveSheet()->setCellValue('D1','Tipo Contrato');
		$this->docexcel->getActiveSheet()->setCellValue('E1','Presupuesto');
		$this->docexcel->getActiveSheet()->setCellValue('F1','Nombre');
		$this->docexcel->getActiveSheet()->setCellValue('G1','Fecha Inicio');
		$this->docexcel->getActiveSheet()->setCellValue('H1','Fecha Antiguedad');
				
		//*************************************Detalle*****************************************
		$fila = 1;
		
		$datos = $this->objParam->getParametro('antiguedad');
		foreach($datos as $value) {			
			$fila++;
			$columna = 0;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['antiguedad']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['nombre_unidad']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['cargo']);
			$columna++;			
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['tipo_contrato']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['codigo_cc']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['funcionario']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['fecha_inicio']);
			$columna++;
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$value['fecha_antiguedad']);											
		}
	
		
	}
	
	function generarReporte(){
		//echo $this->nombre_archivo; exit;
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->docexcel->setActiveSheetIndex(0);
		
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);	
		
	}	
	

}

?>