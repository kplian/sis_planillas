<?php
// Extend the TCPDF class to create custom MultiRow
//#50			MZM			24.09.2019				Ajuste de forma en reporte: omitir en titulo centro, quitar autollenado de 0
//#56			MZM			08.10.2019				Ajuste a titutlo de reporte
//#65			MZM			16.10.2019				Inclusion de TC para reporte en $us
//#69			MZM			29.10.2019				Ajuste para reporte Hras trabajadas
//#70			MZM			31.10.2019				adicion de totales cuando no existen columnas fijas
//#77			MZM			14.11.2019				Ajuste reportes varios
class RPlanillaGenerica extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $bordes;
	var $interlineado;
	
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 5, 30, 15);
		$this->SetFont('','B',7);
		$this->Ln(1);
		$this->Cell($this->ancho_hoja+20,3,$this->datos_titulo['depto'],0,1,'R');
		$this->Cell($this->ancho_hoja+20,3,$this->datos_titulo['uo'],0,1,'R');
		
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($this->ancho_hoja+20, 3, $pagenumtxt, '', 1, 'R');
		
		$this->SetFont('','B',12);
		$tipo_con='';
		
		if ($this->objParam->getParametro('id_tipo_contrato')!=''){//01.10.2019
			$tipo_con=' ('.$this->datos_detalle[0]['nombre'].')';
		}
		
		$this->Cell(0,5,$this->datos_titulo['titulo_reporte'] .$tipo_con.'',0,1,'C');
		
		//Al Mes De  '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion']
		
		$this->SetFont('','B',10);
		
		
		if($this->datos_titulo['periodo']!=''){
			$this->Cell(0,5,'Correspondiente a: ' . $this->datos_titulo['periodo_lite'],0,1,'C');	
		}else{
			$this->Cell(0,5,'GESTION ' . $this->datos_titulo['gestion'],0,1,'C'); // planilla prima 31.10.2019
		}
		
		
		
		if ($this->datos_titulo['mostrar_ufv']=='si'){
			$this->SetFont('','B',7);
			$this->Cell($this->ancho_hoja,3.5,'U.F.V. Anterior: ' ,0,0,'R');
			$this->SetFont('','U',7);
			$this->Cell(10,3.5,number_format($this->datos_titulo['ufv_ini'],6,',','.'),0,1,'L');
			$this->SetFont('','B',7);
			$this->Cell($this->ancho_hoja,3.5,'U.F.V. Actual: ' ,0,0,'R');
			$this->SetFont('','U',7);
			$this->Cell(10,3.5,number_format($this->datos_titulo['ufv_fin'],6,',','.'),0,1,'L');
			
		}
		$this->SetFont('','B',10);
		$this->Cell(0,5,$this->gerencia,0,1,'L');
		$this->Ln(2);
		$this->SetFont('','B',8);
		
		//Titulos de columnas superiores
		if ($this->datos_titulo['numerar'] == 'si')
			$this->Cell(5,3.5,'No','LTR',0,'C');
		if ($this->datos_titulo['mostrar_nombre'] == 'si')
			$this->Cell(52,3.5,'Nombre Completo','LTR',0,'C');
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si')
			$this->Cell(15,3.5,'Cod.','LTR',0,'C');
		if ($this->datos_titulo['mostrar_doc_id'] == 'si')
			$this->Cell(15,3.5,'CI','LTR',0,'C');
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si')
			$this->Cell(10,3.5,'Item','LTR',0,'C');
		$columnas = 0;
		
		foreach($this->datos_detalle as $value) {
			$this->Cell($value['ancho_columna'],3.5,$value['titulo_reporte_superior'],'LTR',0,'C');
			$columnas++;
			if ($columnas == $this->datos_titulo['cantidad_columnas']) {
				break;
			}
		}
		$this->ln();

		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		if ($this->datos_titulo['numerar'] == 'si') {
			$this->Cell(5,3.5,'','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_nombre'] == 'si') {
			$this->Cell(52,3.5,'','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si') {
			$this->Cell(15,3.5,'Emp.','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_doc_id'] == 'si') {
			$this->Cell(15,3.5,'','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si') {
			$this->Cell(10,3.5,'','LBR',0,'C');
		}
		$columnas = 0;
		
		
		foreach($this->datos_detalle as $value) {
			$this->Cell($value['ancho_columna'],3.5,$value['titulo_reporte_inferior'],'LBR',0,'C');
			//iniciar ancho de columna, alineacion y formato de numero
			array_push($this->tablewidths, $value['ancho_columna']); 
			
			if($value['sumar_total']=='si' ){
	  			array_push($this->tablealigns, 'R');
				array_push($this->tablenumbers, 2); 
	  			
				
	  		}else{
	  			
	  				array_push($this->tablealigns, 'L');
					array_push($this->tablenumbers, 0);
	  			
	  			
	  		}
			
			$columnas++;
			if ($columnas == $this->datos_titulo['cantidad_columnas']) {
				break;
			}
		}
		$this->ln();	

	}
	function datosHeader ($titulo, $detalle) { 
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		$this->ancho_sin_totales = 0;
		$this->cantidad_columnas_estaticas = 0;
		if ($this->datos_titulo['numerar'] == 'si') {
			array_push($this->tablewidths, 5); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 5;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_nombre'] == 'si') {
			array_push($this->tablewidths, 52); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 52;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si') {
			array_push($this->tablewidths, 15); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 15;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_doc_id'] == 'si') {
			array_push($this->tablewidths, 15); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 15;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si') {
			array_push($this->tablewidths, 10); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 10;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_ufv'] == 'si') {
			$this->SetMargins(5, 47, 5); //**********++ 
		}else{
			$this->SetMargins(5, 40, 5); //**********++ 
		}
		
		
		$this->bordes= $this->datos_titulo['bordes'];
		$this->interlineado=$this->datos_titulo['interlineado'];
		
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//iniciacion de datos 
		$id_funcionario = $this->datos_detalle[0]['id_funcionario'];
		$sum_subtotal = array();
		$sum_total = array();
		$this->numeracion = 1;
		$empleados_gerencia = 1;
		$array_show = $this->iniciarArrayShow($this->datos_detalle[0]);		
		
		for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
	 		$sum_subtotal[$i]=0;
			$sum_total[$i]=0;
		}
		$columnas = 0;
		
		foreach ($this->datos_detalle as $value) {
			
		
			if ($id_funcionario != $value['id_funcionario']  ) {
				
				if($this->datos_titulo['cant_columnas_totalizan']==1){
					
					if($array_show[((count($array_show))-1)]!=0){ 
						$this->SetFont('','',6);
						$this->UniRow($array_show,false, $this->bordes, $this->interlineado);
						$this->numeracion++;
						$empleados_gerencia++;
					}
					else{
						
					}
						$columnas = 0;
						//Si cambia la gerencia
						if ($this->gerencia != $value['gerencia']) {
							//generar subtotales
							$this->SetFont('','B',7);
							if ($this->ancho_sin_totales>0){
								$this->Cell($this->ancho_sin_totales,3,'TOTAL ' . $this->gerencia . ' : ','RBT',0,'R');
							}
			 				
							for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
								if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i]/$this->datos_titulo['tc'],2,',','.'),1,0,'R');//#50
									
								else
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
								//reiniciar subtotales
								$sum_subtotal[$i] = 0;
							}
			 	 			
							$this->ln(10);
							$this->Cell($this->ancho_sin_totales*2,3,'SUBTOTAL EMPLEADOS '.$this->gerencia . ' : ' .$empleados_gerencia,'',0,'L');
							//crear nueva pagina y cambiar de gerencia
							$this->gerencia = $value['gerencia'];
							$empleados_gerencia = 0;
							
							if($this->datos_titulo['titulo_reporte']!='TOTAL HORAS TRABAJADAS'){//#69
								$this->AddPage();	
							}else{
								$this->Ln(8);
								$this->SetFont('','B',10);
								$this->Cell(30,3,''.$this->gerencia . '' ,'',1,'L');
							
								
							}
							
						} 
						
						$array_show = $this->iniciarArrayShow($value);
						
						$id_funcionario = $value['id_funcionario'];
					
				}else{
						$this->SetFont('','',6);
						$this->UniRow($array_show,false, $this->bordes, $this->interlineado);
						$columnas = 0;
						//Si cambia la gerencia
						if ($this->gerencia != $value['gerencia']) {
							//generar subtotales
							$this->SetFont('','B',7);
							if ($this->ancho_sin_totales>0){
								$this->Cell($this->ancho_sin_totales,3,'TOTAL ' . $this->gerencia . ' : ','RBT',0,'R');
							}
			 				
							for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
								if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i]/$this->datos_titulo['tc'],2,',','.'),1,0,'R');//#50
								else
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
								//reiniciar subtotales
								$sum_subtotal[$i] = 0;
							}
			 	 			
							$this->ln(10);
							$this->Cell($this->ancho_sin_totales*2,3,'SUBTOTAL EMPLEADOS '.$this->gerencia . ' : ' .$empleados_gerencia,'',0,'L');
							//crear nueva pagina y cambiar de gerencia
							$this->gerencia = $value['gerencia'];
							$empleados_gerencia = 0;
							if($this->datos_titulo['titulo_reporte']!='TOTAL HORAS TRABAJADAS'){//#69
								$this->AddPage();	
							}else{
								$this->Ln(8);
								$this->SetFont('','B',10);
								$this->Cell(30,3,''.$this->gerencia . '' ,'',1,'L');
							}
						} 
						$this->numeracion++;
						$empleados_gerencia++;
						$array_show = $this->iniciarArrayShow($value);
						$id_funcionario = $value['id_funcionario'];
				}
				
			//si no es un nuevo funcionario hacer push al arreglo con el dato recibido
			} 
			
//#65 
	  		if($value['sumar_total']=='si'){
	  			
	  				array_push($array_show, $value['valor_columna']/$this->datos_titulo['tc']); 
	  		}else{
	  			
	  				array_push($array_show, $value['valor_columna']);
	  		}
	  				
				$sum_subtotal[$columnas] += $value['valor_columna'];
				$sum_total[$columnas] += $value['valor_columna'];
				$columnas++;	
	  		
		}
		
		$this->SetFont('','',6);
		//Añade al ultimo empleado de la lista
		//#77
		$abc=(count($array_show)-1);
		
		
		if($array_show[$abc-1]!=''){
			$this->UniRow($array_show,false, $this->bordes, $this->interlineado);
			$this->numeracion++; //------------***********
			$empleados_gerencia++;
		}
		
		//Si cambia la gerencia
		
		//Añade el ultimo subtotal de la gerencia
		//generar subtotales
		$this->SetFont('','B',7);
		
		if ($this->gerencia!=''){
			
			if ($this->ancho_sin_totales>0){
				$this->Cell($this->ancho_sin_totales,3,'TOTAL ' . $this->gerencia . ' : ','RBT',0,'R');
			}
			for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
				if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i]/$this->datos_titulo['tc'],2,',','.'),1,0,'R');//#50
				else
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
				//reiniciar subtotales
				$sum_subtotal[$i] = 0;
			}
			$this->ln(10);
			$empleados_gerencia=$empleados_gerencia-1;
			$this->Cell($this->ancho_sin_totales*2,3,'SUBTOTAL EMPLEADOS '.$this->gerencia . ' : ' .$empleados_gerencia,'',0,'L');
			$this->ln(10);
		
		}
		
		
		//planilla
		//#70
		if($this->ancho_sin_totales > 0){
			$this->Cell($this->ancho_sin_totales,3,'TOTAL PLANILLA : ','RBT',0,'R');
		}
			for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
				if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_total[$i]/$this->datos_titulo['tc'],2,',','.'),1,0,'R');//#50
				else
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
			}
			$this->ln(8);
		
		
		$this->ln(2);
		$this->numeracion=$this->numeracion-1;
		$this->Cell($this->ancho_sin_totales*2,3,'TOTAL EMPLEADOS PLANILLA: '.(($this->numeracion)),'',0,'L');
			
	}
	function iniciarArrayShow($detalle) {
		$res_array = array();
		if ($this->datos_titulo['numerar'] == 'si')
			array_push($res_array, $this->numeracion);
		if ($this->datos_titulo['mostrar_nombre'] == 'si')
			array_push($res_array, $detalle['nombre_empleado']);
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si')
			array_push($res_array, $detalle['codigo_empleado']);
		if ($this->datos_titulo['mostrar_doc_id'] == 'si')
			array_push($res_array, $detalle['doc_id']);
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si')
			array_push($res_array, $detalle['codigo_cargo']);
		return $res_array;
	}
    function Footer(){ 
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		//set style for cell border
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		//$this->Cell($ancho, 0, 'Generado por XPHS', 'T', 0, 'L');
		$this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 0, 'L');
		//$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		//$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, "Fecha Impresion : ".$fecha_rep, '', 0, 'L');
		$this->Ln($line_width);
		$this->Ln();
		$barcode = $this->getBarcode();
		$style = array(
					'position' => $this->rtl?'R':'L',
					'align' => $this->rtl?'R':'L',
					'stretch' => false,
					'fitwidth' => true,
					'cellfitalign' => '',
					'border' => false,
					'padding' => 0,
					'fgcolor' => array(0,0,0),
					'bgcolor' => false,
					'text' => false,
					'position' => 'R'
				);
				$this->write1DBarcode($barcode, 'C128B', $ancho*2, $cur_y + $line_width+5, '', (($this->getFooterMargin() / 3) - $line_width), 0.3, $style, '');
			
	}
}
?>