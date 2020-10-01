<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
//#77 	ETR		MZM		15.11.2019	Ajsute reprote
//#83	ETR				07.01.2020			MZM-KPLIAN			Habilitacion de opcion historico de planilla
//#89	ETR				14.01.2020			MZM-KPLIAN			Inclusion de condicion bono/descuento para imprimir el concepto que se consulta
//#123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019)
//#161	ETR				07.09.2020			MZM-KPLIAN			Ajuste en encabezado, quitando tipo contrato planta
class RPlanillaGenericaXls
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
		$titulo_archivo_xls='Planilla';
		if($this->objParam->getParametro('titulo_archivo')!=''){
			$titulo_archivo_xls	=$this->objParam->getParametro('titulo_archivo');
		}
		
		
		$this->docexcel->getProperties()->setCreator("PXP")
							 ->setLastModifiedBy("PXP")
							 ->setTitle($titulo_archivo_xls)
							 ->setSubject($titulo_archivo_xls)
							 ->setDescription('Reporte "'.$titulo_archivo_xls.'", generado por el framework PXP')
							 ->setKeywords("office 2007 openxml php")
							 ->setCategory("Report File");
		$this->docexcel->setActiveSheetIndex(0);
		$this->docexcel->getActiveSheet()->setTitle(substr($titulo_archivo_xls,1,30)); //#77
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
		$datos = $this->objParam->getParametro('datos');
		
		$config = $this->objParam->getParametro('config'); 
		$columnas = 0;
		
		
		//*************************************Cabecera*****************************************
	if(count($datos)>0){//#123
		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,4,'Gerencia');
		$columnas++;
		if ($config['numerar'] == 'si') {
			$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(8);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,4,'No');
			$columnas++;
		}
		if ($config['mostrar_nombre'] == 'si'){
			$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(33);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,4,'Nombre Completo');
			$columnas++;			
		}
		if ($config['mostrar_codigo_empleado'] == 'si') {
			$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(10);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,4,'Cod.');
			$columnas++;			
		}
		if ($config['mostrar_doc_id'] == 'si') {
			$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(10);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,4,'CI.');
			$columnas++;
		}
		if ($config['mostrar_codigo_cargo'] == 'si') {
			$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(10);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,4,'Item');
			$columnas++;
		}
		
		$columnas_basicas = $columnas;
		foreach($datos as $value) {
			$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(10);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,4,$value['titulo_reporte_superior']);
			$columnas++;
			if ($columnas - $columnas_basicas == $config['cantidad_columnas']) {
				break;
			}
		}		
		$columnas = 0;
		$columnas++;
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		if ($config['numerar'] == 'si') {			
			$columnas++;
		}
		if ($config['mostrar_nombre'] == 'si'){			
			$columnas++;			
		}
		if ($config['mostrar_codigo_empleado'] == 'si') {			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,5,'Emp.');
			$columnas++;			
		}
		if ($config['mostrar_doc_id'] == 'si') {			
			$columnas++;
		}
		if ($config['mostrar_codigo_cargo'] == 'si') {			
			$columnas++;
		}
		
		
		foreach($datos as $value) {			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,5,$value['titulo_reporte_inferior']);
			$columnas++;
			if ($columnas - $columnas_basicas == $config['cantidad_columnas']) {
				break;
			}
		}
		//*************************************Fin Cabecera*****************************************
		$id_funcionario = -1;
		$fila = 5;
		//#89
		if ($this->objParam->getParametro('tipo_reporte')=='bono_descuento'){
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,3,$this->objParam->getParametro('nombre_descuento'));
		}
		
		/////////////////////***********************************Detalle***********************************************
		foreach($datos as $value) {			
			if ($id_funcionario != $value['id_funcionario']) {				
				$fila++;
				$columnas = $columnas_basicas;
				$this->imprimeDatosBasicos($config,$value,$fila);
				$id_funcionario = $value['id_funcionario'];
				
			}
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,$fila,$value['valor_columna']);
			$columnas++;
		}
		//************************************************Fin Detalle***********************************************
		
		$start = PHPExcel_Cell::stringFromColumnIndex(0);
		$end=PHPExcel_Cell::stringFromColumnIndex($columnas-1);
		$merge=$start.'1:'.$end.'1';
		
	
		
		
		$tit_rep=$config['titulo_reporte'];
		$tcon=$this->objParam->getParametro('nombre_tipo_contrato');
		if ($tcon=='Planta') $tcon=''; //#161
		if ($tcon!=''){
			//#98
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				
				$tit_rep=$tit_rep.' ('.$tcon.' - '.$this->objParam->getParametro('personal_activo').')';	
			}else{
				$tit_rep=$tit_rep.' ('.$tcon.')';	
			}
			
			
		}else{
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$tit_rep=$tit_rep.' ('.$this->objParam->getParametro('personal_activo').')';
			}
		}
		
		//#83
		$dr=substr($config['fecha_backup'],0,2);
		$mr=substr($config['fecha_backup'],3,2);
		$ar=substr($config['fecha_backup'],5);
		if($config['fecha_backup']!='' && $config['fecha_backup']!='01-01-1000'){
			
			$tit_rep= $tit_rep. " [Backup: ".$dr.'/'.$mr.'/'.$ar.']';
		}
		
		
		$this->docexcel->getActiveSheet()->mergeCells("$merge"); 
		$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,1,$tit_rep);
		
		$subtit='Correspondiente a: ';
		
		if($config['periodo']!=''){
			$subtit=$subtit.$config['periodo_lite'];
		}else{
			$subtit=$subtit.$config['gestion'];
		}
		$merge=$start.'2:'.$end.'2';
		$this->docexcel->getActiveSheet()->mergeCells("$merge"); 
		$this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columnas])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,2,$subtit);
		
		
		}
	
		
	}

	function imprimeDatosBasicos($config,$detalle, $fila) {
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$detalle['gerencia']);	
		$columnas = 1;
			
		if ($config['numerar'] == 'si') {
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,$fila,$fila);
			$columnas++;
		}
		if ($config['mostrar_nombre'] == 'si') {
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,$fila,$detalle['nombre_empleado']);
			$columnas++;
		}
		if ($config['mostrar_codigo_empleado'] == 'si') {
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,$fila,$detalle['codigo_empleado']);
			$columnas++;
		}
		if ($config['mostrar_doc_id'] == 'si') {
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,$fila,$detalle['doc_id']);
			$columnas++;
		}
		if ($config['mostrar_codigo_cargo'] == 'si') {
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow($columnas,$fila,$detalle['codigo_cargo']);
			$columnas++;
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