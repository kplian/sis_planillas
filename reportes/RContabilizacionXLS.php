<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RContabilizacionXLS
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
		
		$this->docexcel->getActiveSheet()->setTitle('DEBE');
		
		$datos = $this->objParam->getParametro('datos_ejecucion');	
		$nombres_columnas = $this->objParam->getParametro('columnas');			
		$this->docexcel->setActiveSheetIndex(0);
		$posiciones = array();
		
		
				
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
		
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(35);
		
		$i=1;
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,1,'DESCRIPCION');
		foreach ($nombres_columnas as $dato) {
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,1,$dato['nombre_columna']);
			$posiciones[$dato['codigo_columna']] = $i;
			$i++;
			
		}
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,1,'TOTALES');
		
		
		$this->docexcel->getActiveSheet()->getStyle('A1:' . $this->equivalencias[$i] . '1')->getAlignment()->setWrapText(true); 	
		
		$this->docexcel->getActiveSheet()->getStyle('A1:' . $this->equivalencias[$i] . '1')->applyFromArray($styleTitulos);
		
		
		$fila=1;
		$presupuesto = '';
		foreach ($datos as $dato) {
			if ($dato['codigo_cc'] != $presupuesto) {
				$fila++;
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$dato['codigo_cc']);
				$presupuesto = $dato['codigo_cc'];
			}
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($posiciones[$dato['codigo_columna']],$fila,$dato['ejecutado']);
					
		}
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila+1,'TOTALES');
		$this->docexcel->getActiveSheet()->getStyle('A1:' . 'A' . ($fila + 1))->getAlignment()->setWrapText(true); 	
		$this->docexcel->getActiveSheet()->getStyle('A1:' . 'A' . ($fila + 1))->applyFromArray($styleTitulos);
		for($j=2; $j<=$fila; $j++){
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,$j,'=SUM(B'  . $j .':' . $this->equivalencias[$i-1] . $j.')');
		}
		
		for($j=1; $j<=$i; $j++){
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($j,$fila+1,'=SUM(' . $this->equivalencias[$j] . '2:' . $this->equivalencias[$j] . $fila.')');
		}
		
		$this->docexcel->getActiveSheet()->getStyle('A' . ($fila + 1).':' . $this->equivalencias[$i] . ($fila + 1))->getAlignment()->setWrapText(true); 	
		$this->docexcel->getActiveSheet()->getStyle('A' . ($fila + 1).':' . $this->equivalencias[$i] . ($fila + 1))->applyFromArray($styleTitulos);
		
		$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$i] . '2:' . $this->equivalencias[$i] . $fila )->getAlignment()->setWrapText(true); 	
		$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$i] . '2:' . $this->equivalencias[$i] . $fila )->applyFromArray($styleTitulos);
			
	}

	function imprimeEjecucionCategoria(){
		
		$this->docexcel->createSheet(2);
		$this->docexcel->setActiveSheetIndex(2);
		$this->docexcel->getActiveSheet()->setTitle('EJECUCION');
		
		$datos = $this->objParam->getParametro('ejecucion_categoria');	
		$nombres_columnas = $this->objParam->getParametro('columnas');			
		$this->docexcel->setActiveSheetIndex(2);
		$posiciones = array();
		
		
				
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
		
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(35);
		
		$i=1;
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,1,'DESCRIPCION');
		foreach ($nombres_columnas as $dato) {
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,1,$dato['nombre_columna']);
			$posiciones[$dato['codigo_columna']] = $i;
			$i++;
			
		}
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,1,'TOTALES');
		
		
		$this->docexcel->getActiveSheet()->getStyle('A1:' . $this->equivalencias[$i] . '1')->getAlignment()->setWrapText(true); 	
		
		$this->docexcel->getActiveSheet()->getStyle('A1:' . $this->equivalencias[$i] . '1')->applyFromArray($styleTitulos);
		
		
		$fila=1;
		$presupuesto = '';
		foreach ($datos as $dato) {
			if ($dato['codigo_cc'] != $presupuesto) {
				$fila++;
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$dato['codigo_cc']);
				$presupuesto = $dato['codigo_cc'];
			}
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($posiciones[$dato['codigo_columna']],$fila,$dato['ejecutado']);
					
		}
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila+1,'TOTALES');
		$this->docexcel->getActiveSheet()->getStyle('A1:' . 'A' . ($fila + 1))->getAlignment()->setWrapText(true); 	
		$this->docexcel->getActiveSheet()->getStyle('A1:' . 'A' . ($fila + 1))->applyFromArray($styleTitulos);
		for($j=2; $j<=$fila; $j++){
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,$j,'=SUM(B'  . $j .':' . $this->equivalencias[$i-1] . $j.')');
		}
		
		for($j=1; $j<=$i; $j++){
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($j,$fila+1,'=SUM(' . $this->equivalencias[$j] . '2:' . $this->equivalencias[$j] . $fila.')');
		}
		
		$this->docexcel->getActiveSheet()->getStyle('A' . ($fila + 1).':' . $this->equivalencias[$i] . ($fila + 1))->getAlignment()->setWrapText(true); 	
		$this->docexcel->getActiveSheet()->getStyle('A' . ($fila + 1).':' . $this->equivalencias[$i] . ($fila + 1))->applyFromArray($styleTitulos);
		
		$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$i] . '2:' . $this->equivalencias[$i] . $fila )->getAlignment()->setWrapText(true); 	
		$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$i] . '2:' . $this->equivalencias[$i] . $fila )->applyFromArray($styleTitulos);
		
	}

	function imprimeObligaciones(){
		
		$this->docexcel->createSheet(1);
		$this->docexcel->setActiveSheetIndex(1);
		$this->docexcel->getActiveSheet()->setTitle('HABER');
		
		$datos = $this->objParam->getParametro('obligaciones');	
		
		
		
				
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
		
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(35);
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(45);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
		
		$this->docexcel->getActiveSheet()->getStyle('A1:C1')->getAlignment()->setWrapText(true);		
		$this->docexcel->getActiveSheet()->getStyle('A1:C1')->applyFromArray($styleTitulos);
		
		
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,1,'TIPO OBLIGACION');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,1,'ACREEDOR');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,1,'MONTO');
		$fila = 2;
		$tipo_obligacion = '';
		foreach ($datos as $dato) {
			if ($dato['tipo_obligacion'] != $tipo_obligacion) {				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$dato['tipo_obligacion']);
				$tipo_obligacion = $dato['tipo_obligacion'];
				$fila++;
			}
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$dato['acreedor']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$dato['monto']);
			$fila++;		
		}
		$this->docexcel->getActiveSheet()->getStyle("A$fila:C$fila")->getAlignment()->setWrapText(true);		
		$this->docexcel->getActiveSheet()->getStyle("A$fila:C$fila")->applyFromArray($styleTitulos);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,'TOTAL');
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,'=SUM(C2:C' . ($fila-1).')');
		
		 
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