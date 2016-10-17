<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RSegAguinaldoXLS
{
	private $docexcel;
	private $objWriter;
	private $nombre_archivo;
	private $hoja;
	private $columnas=array();
	private $fila;
	private $equivalencias=array();
	
	private $indice, $m_fila, $titulo;
	private $swEncabezado=0; //variable que define si ya se imprimi� el encabezado
	private $objParam;
	public  $url_archivo;
	private $resumen = array();	
	private $resumen_regional = array();	
	
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
		
		//$sheetId = 1;
		//$this->docexcel->createSheet(NULL, $sheetId);	
		//$this->docexcel->setActiveSheetIndex($sheetId);	
		//$this->docexcel->getActiveSheet()->setTitle('Planilla Prima');
		
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
	
	function imprimeDatosSueldo(){
		$this->docexcel->getActiveSheet()->setTitle('Planilla Aguinaldo');
		$datos = $this->objParam->getParametro('datos');
			
		$columnas = 0;
		$this->docexcel->setActiveSheetIndex(0);
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(7);
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(18);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(18);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(18);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
		
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(7);
		$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(11);
		
		$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(11);
		
		$this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(11);
		
		$this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(11);
		$this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(11);
		
		
		
		
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
            		'rgb' => 'FFFFFF'
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
		        'size'  => 10,
		        'name'  => 'Arial'
		    ));
		
		$this->docexcel->getActiveSheet()->getStyle('A1:A4')->applyFromArray($styleTitulos2);
		
		
		$this->docexcel->getActiveSheet()->setCellValue('A1','NOMBRE O RAZÓN SOCIAL  :  BOLIVIANA DE AVIACIÓN – BoA');
		$this->docexcel->getActiveSheet()->setCellValue('A2','Nº EMPLEADOR MINISTERIO DE TRABAJO  :  154422029-03');
		$this->docexcel->getActiveSheet()->setCellValue('A3','Nº DE NIT  :  154422029');
		$this->docexcel->getActiveSheet()->setCellValue('A4','Nº DE EMPLEADOR (Caja de Salud)  :  020-621-271');
		
		$styleTitulos2 = array(
		    'font'  => array(
		        'bold'  => true,
		        'size'  => 12,
		        'name'  => 'Arial'
		    ),
			'alignment' => array(
		        'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
		        'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
		    ));
		
		$this->docexcel->getActiveSheet()->mergeCells('A6:U6');	
		$this->docexcel->getActiveSheet()->getStyle('A6')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->setCellValue('A6','PLANILLA DE SEGUNDO AGUINALDO "ESFUERZO POR BOLIVIA"');
		
		$styleTitulos2 = array(
		    'font'  => array(
		        'bold'  => false,
		        'size'  => 8,
		        'name'  => 'Arial'
		    ),
			'alignment' => array(
		        'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
		        'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
		    ));
		$this->docexcel->getActiveSheet()->mergeCells('A7:U7');
		$this->docexcel->getActiveSheet()->getStyle('A7')->applyFromArray($styleTitulos2);
		$this->docexcel->getActiveSheet()->setCellValue('A7','(En Bolivianos)');
		
		
		$this->docexcel->getActiveSheet()->getStyle('A10:U10')->getAlignment()->setWrapText(true); 	
		$this->docexcel->getActiveSheet()->getStyle('A10:U10')->applyFromArray($styleTitulos);
		
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->setCellValue('A10','Nº');
		$this->docexcel->getActiveSheet()->setCellValue('B10','CARNET DE INDENTIDAD');
		$this->docexcel->getActiveSheet()->setCellValue('C10','APELLIDO PATERNO');
		$this->docexcel->getActiveSheet()->setCellValue('D10','APELLIDO MATERNO');
		$this->docexcel->getActiveSheet()->setCellValue('E10','NOMBRES');
		$this->docexcel->getActiveSheet()->setCellValue('F10','NACIONALIDAD');
		$this->docexcel->getActiveSheet()->setCellValue('G10','FECHA DE NACIMIENTO');
		$this->docexcel->getActiveSheet()->setCellValue('H10','SEXO (F/M)');
		$this->docexcel->getActiveSheet()->setCellValue('I10','OCUPACIÓN QUE DESEMPEÑA');
		$this->docexcel->getActiveSheet()->setCellValue('J10','FECHA DE INGRESO');		
		$this->docexcel->getActiveSheet()->setCellValue('K10','Promedio del haber básico (A)');
		$this->docexcel->getActiveSheet()->setCellValue('L10','Promedio del bono de antiguedad (B)');
		$this->docexcel->getActiveSheet()->setCellValue('M10','Promedio del bono de produccion (C)');
		$this->docexcel->getActiveSheet()->setCellValue('N10','Promedio del subsidio de frontera (D)');
		$this->docexcel->getActiveSheet()->setCellValue('O10','Promedio trabajo extraordinario y nocturno (E)');
		$this->docexcel->getActiveSheet()->setCellValue('P10','Promedio pago dominical y domingo trabajado (F)');
		$this->docexcel->getActiveSheet()->setCellValue('Q10','Promedio otros bonos (G)');
		$this->docexcel->getActiveSheet()->setCellValue('R10','Promedio total ganado (H=A+B+C+D+E+F+G)');
		$this->docexcel->getActiveSheet()->setCellValue('S10','Meses trabajados (I)');
		$this->docexcel->getActiveSheet()->setCellValue('T10','Total ganado después de duodécimas (J=H*I/12)');
		$this->docexcel->getActiveSheet()->setCellValue('U10','FIRMA DEL EMPLEADO');
		
				
		
		
		//*************************************Detalle*****************************************
		$numero = 0;
		$columna = 0;
		$fila = 10;
		$this->docexcel->getActiveSheet()->getRowDimension($fila)->setRowHeight(60);
		$this->resumen['basico'] = 0;
		$this->resumen['antiguedad'] = 0;
		$this->resumen['frontera'] = 0;
		$this->resumen['otros_bonos'] = 0;
		$this->resumen['total_ganado'] = 0;
		$this->resumen['afp'] = 0;
		$this->resumen['iva'] = 0;
		$this->resumen['otros_descuentos'] = 0;
		$this->resumen['total_descuentos'] = 0;
		$this->resumen['liquido_pagable'] = 0;
		$this->resumen['trabajadores_varones'] = 0;
		$this->resumen['trabajadores_mujeres'] = 0;
		$this->resumen['jubilados_varones'] = 0;
		$this->resumen['jubilados_mujeres'] = 0;
		$this->resumen['extranjeros_varones'] = 0;
		$this->resumen['extranjeros_mujeres'] = 0;
		$this->resumen['discapacitados_varones'] = 0;
		$this->resumen['discapacitados_mujeres'] = 0;
		$this->resumen['contrato_varones'] = 0;
		$this->resumen['contrato_mujeres'] = 0;
		$this->resumen['retiro_varones'] = 0;
		$this->resumen['retiro_mujeres'] = 0;
		foreach($datos as $value) {
			
			if ($numero != $value['fila']) {
				
				$fila++;
				$columna = 0;
				//masculino
				if ($value['sexo']== 'M') {
					$this->resumen['trabajadores_varones']++;
					
					
				}//femenino			
				else {
					$this->resumen['trabajadores_mujeres']++;					
				}				
				foreach ($value as $key => $val) {
					if ($key != 'codigo_columna' && $key != 'valor'&& $key != 'oficina' && $key != 'discapacitado'&& $key != 'contrato_periodo'&& $key != 'retiro_periodo'
						&& $key != 'edad'&& $key != 'lugar' && $key != 'jubilado') {
						$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$val);
						$columna++;
					}
				}
				$numero = $value['fila'];
				
			}
			if ($columna == 10 && $value['codigo_columna'] == 'PROME') {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$value['valor']);
				$this->resumen['basico'] = $this->resumen['basico'] + $value['valor'];
				$columna++;
			}								
			
			if ($columna == 11) {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
				$columna++;
			}
			if ($columna == 12) {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
				$columna++;
			}
			if ($columna == 13) {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
				$columna++;
			}
			if ($columna == 14) {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
				$columna++;
			}
			if ($columna == 15) {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
				$columna++;
			}
			
			if ($columna == 16) {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,0);
				$columna++;
			}
			
			if ($columna == 17 && $value['codigo_columna'] == 'PROME') {
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$value['valor']);
				$columna++;
			}
			
			if ($columna == 18 && $value['codigo_columna'] == 'DIASAGUI') {
				$meses = floor($value['valor']/30);
				$dias = $value['valor'] - ($meses * 30);
				$texto = "$meses meses";
				if ($dias > 0) {
					$texto .= " y $dias días";
				}
				$this->docexcel->getActiveSheet()->getStyle("S$fila")->getAlignment()->setWrapText(true);
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$texto);
				$columna++;
			}
			
			if ($columna == 19 && $value['codigo_columna'] == 'AGUINA') {
				$this->resumen['liquido_pagable'] = $this->resumen['liquido_pagable'] + $value['valor'];
				$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columna,$fila,$value['valor']);
				$columna++;
			}			
			
		}
		$fila++;
		$this->docexcel->getActiveSheet()->mergeCells("A$fila:J$fila");
		$styleTotales = array(
				'font'  => array(
			        'bold'  => true,
			        'size'  => 11,
			        'name'  => 'Arial'
			    ),
			    'alignment' => array(
			        'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
			        'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
			    ),					    
				'fill' => array(
	        		'type' => PHPExcel_Style_Fill::FILL_SOLID,
					'color' => array(
	            		'rgb' => 'FFFFFF'
	            	)			        	
		    	),
				'borders' => array(
			        'allborders' => array(
			            'style' => PHPExcel_Style_Border::BORDER_THIN
			        )
			    ));
		$this->docexcel->getActiveSheet()->getStyle('A' . ($fila) . ":U" . ($fila))->applyFromArray($styleTotales);
		
		$this->docexcel->getActiveSheet()->getRowDimension($fila)->setRowHeight(25);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,'TOTALES');
		
		$this->docexcel->getActiveSheet()->setCellValue("K$fila", "=SUM(K11:K".($fila-1).")");
		$this->docexcel->getActiveSheet()->setCellValue("L$fila", "0");
		$this->docexcel->getActiveSheet()->setCellValue("M$fila", "0");
		$this->docexcel->getActiveSheet()->setCellValue("N$fila", "0");
		$this->docexcel->getActiveSheet()->setCellValue("O$fila", "0");
		$this->docexcel->getActiveSheet()->setCellValue("P$fila", "0");
		$this->docexcel->getActiveSheet()->setCellValue("Q$fila", "0");
		$this->docexcel->getActiveSheet()->setCellValue("R$fila", "=SUM(R11:R".($fila-1).")");
		$this->docexcel->getActiveSheet()->setCellValue("T$fila", "=SUM(T11:T".($fila-1).")");
		
		//************************************************Fin Detalle***********************************************
	}
	
	
	function imprimeResumen(){
		$sheetId = 1;
		$this->docexcel->createSheet(NULL, $sheetId);	
		$this->docexcel->setActiveSheetIndex($sheetId);	
		$this->docexcel->getActiveSheet()->setTitle('Resumen');
		
		$this->docexcel->setActiveSheetIndex($sheetId);
		
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
            		'rgb' => 'D9D9D9'
            	)
        	),
			'borders' => array(
	        'allborders' => array(
	            'style' => PHPExcel_Style_Border::BORDER_THIN
	        )
	    ));
		
		$this->docexcel->getActiveSheet()->getStyle('A2:F2')->applyFromArray($styleTitulos);
		
		$this->docexcel->getActiveSheet()->getStyle('A4:F4')->applyFromArray($styleTitulos);
		
		
		$this->docexcel->getActiveSheet()->setCellValue('A2','4. COMPOSICIÓN SALARIAL');
		$this->docexcel->getActiveSheet()->setCellValue('C2','5. TRABAJADORES');
		
		$this->docexcel->getActiveSheet()->setCellValue('A4','Concepto');
		$this->docexcel->getActiveSheet()->setCellValue('B4','Monto (Bs)');
		$this->docexcel->getActiveSheet()->setCellValue('D4','Varones');
		$this->docexcel->getActiveSheet()->setCellValue('E4','Mujeres');
		$this->docexcel->getActiveSheet()->setCellValue('F4','Total');
		
		$this->docexcel->getActiveSheet()->setCellValue('A5','4.1 Promedio haber básico');
		$this->docexcel->getActiveSheet()->setCellValue('B5',$this->resumen['basico']);
		$this->docexcel->getActiveSheet()->setCellValue('C5','5.1 Total trabajadores');
		$this->docexcel->getActiveSheet()->setCellValue('D5',$this->resumen['trabajadores_varones']);
		$this->docexcel->getActiveSheet()->setCellValue('E5',$this->resumen['trabajadores_mujeres']);
		$this->docexcel->getActiveSheet()->setCellValue('F5',$this->resumen['trabajadores_varones'] + $this->resumen['trabajadores_mujeres']);
		
		$this->docexcel->getActiveSheet()->setCellValue('A6','4.2 Promedio bono de antigüedad');
		$this->docexcel->getActiveSheet()->setCellValue('B6',0);
		
		$this->docexcel->getActiveSheet()->setCellValue('A7','4.3 Promedio bono de producción');
		$this->docexcel->getActiveSheet()->setCellValue('B7',0);
		
		$this->docexcel->getActiveSheet()->setCellValue('A8','4.4 Promedio subsidio de frontera');
		$this->docexcel->getActiveSheet()->setCellValue('B8',0);
		
		$this->docexcel->getActiveSheet()->setCellValue('A9','4.5 Promedio trabajo extraordinario y nocturno');
		$this->docexcel->getActiveSheet()->setCellValue('B9',0);
		
		
		$this->docexcel->getActiveSheet()->setCellValue('A10','4.6 Promedio pago dominical y domingo trabajado');
		$this->docexcel->getActiveSheet()->setCellValue('B10',0);
		
		
		$this->docexcel->getActiveSheet()->setCellValue('A11','4.7 Promedio otros bonos');
		$this->docexcel->getActiveSheet()->setCellValue('B11',0);
		
		
		$this->docexcel->getActiveSheet()->setCellValue('A12','4.8 Promedio total ganado');
		$this->docexcel->getActiveSheet()->setCellValue('B12',$this->resumen['basico']);
		
		
		$this->docexcel->getActiveSheet()->setCellValue('A13','4.9 Total ganado después de duodécimas');
		$this->docexcel->getActiveSheet()->setCellValue('B13',$this->resumen['liquido_pagable']);		
			
	}
	function armaResumenRegional($lugar, $value){
		if (!array_key_exists($lugar, $this->resumen_regional)) {
			$this->resumen_regional[$lugar]['varones'] = 0;
			$this->resumen_regional[$lugar]['mujeres'] = 0;
			$this->resumen_regional[$lugar]['mayores_60'] = 0;
			$this->resumen_regional[$lugar]['menores_18'] = 0;
			$this->resumen_regional[$lugar]['jubilados'] = 0;
			$this->resumen_regional[$lugar]['extranjeros'] = 0;
			$this->resumen_regional[$lugar]['discapacitados'] = 0;
			$this->resumen_regional[$lugar]['total_ganado'] = 0;
			$this->resumen_regional[$lugar]['afp'] = 0;
			$this->resumen_regional[$lugar]['caja'] = 0;
		}
		if ($value['sexo']== 1) {
			$this->resumen_regional[$lugar]['varones']++;
		} else {
			$this->resumen_regional[$lugar]['mujeres']++;
		}
		
		if ($value['edad'] > 60) {
			$this->resumen_regional[$lugar]['mayores_60']++;
		}
		
		if ($value['edad'] < 18) {
			$this->resumen_regional[$lugar]['menores_18']++;
		}
		
		if ($value['jubilado']== 1) {
			$this->resumen_regional[$lugar]['jubilados']++;
		}
		
		if ($value['nacionalidad']!= 'Bolivia') {
			$this->resumen_regional[$lugar]['extranjeros']++;
		}
		
		if ($value['discapacitado']== 'si') {
			$this->resumen_regional[$lugar]['discapacitados']++;
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