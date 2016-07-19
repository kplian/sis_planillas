<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
class RPrevisionesXLS
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
	
	function __construct(CTParametro $objParam){
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
		$this->docexcel->getActiveSheet()->setTitle('Previsiones');
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
			
	function imprimeDatos() {
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
			'borders' => array(
	        	'allborders' => array(
	            	'style' => PHPExcel_Style_Border::BORDER_THIN
	        	)
			)			
	    );
		
		$datos = $this->objParam->getParametro('datos');		
		
		$columnas = 0;
		
		$this->docexcel->getActiveSheet()->getStyle('A4:H4')->getAlignment()->setWrapText(true); 	
		
		$this->docexcel->getActiveSheet()->getStyle('A4:H4')->applyFromArray($styleTitulos);
		$this->docexcel->getActiveSheet()->mergeCells("C1:E1");
		$styleTitulos['font']['size'] = 12;
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,1,'REPORTE DE PREVISIONES AL : ' . $this->objParam->getParametro('fecha'));
		
		$styleTitulos['font']['size'] = 10;
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,2,'Gerencia : ' . $this->objParam->getParametro('uo'));
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,3,'Tipo de Contrato : ' . $this->objParam->getParametro('tipo_contrato'));
		$styleTitulos['font']['size'] = 8;
		/*
		Gerencia :
		Tipo de Contrato :
		*/
		//*************************************Cabecera*****************************************
		
		$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(23);
		$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
		$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);
		$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(12);
		$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(8);
		$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(10);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(12);
		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,4,'Gerencia');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,4,'Cargo');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,4,'Nombre Completo');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,4,'Salario');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,4,'Fecha Incorp');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,4,'Dias');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,4,'Indem Dia');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,4,'Indem');	
		
		$fila = 5;
		$styleTitulos['font']['bold'] = false;
		foreach($datos as $value) {
			$this->docexcel->getActiveSheet()->getStyle("A$fila:H$fila")->getAlignment()->setWrapText(true); 	
		
			$this->docexcel->getActiveSheet()->getStyle("A$fila:H$fila")->applyFromArray($styleTitulos);
				
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$value['gerencia']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,$value['cargo']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$fila,$value['nombre']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$value['basico']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$value['fecha_ingreso']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$value['dias_trabajados']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$fila,number_format ( $value['indem_dia'] , 8 , ',' , ' ' ));
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$fila,number_format ( $value['indem'] , 2 , ',' , ' ' ));
			$fila++;
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