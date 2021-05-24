<?php
// Extend the TCPDF class to create custom MultiRow
//#50			MZM			24.09.2019				Ajuste de forma en reporte: omitir en titulo centro, quitar autollenado de 0
//#56			MZM			08.10.2019				Ajuste a titutlo de reporte
//#65			MZM			16.10.2019				Inclusion de TC para reporte en $us
//#69			MZM			29.10.2019				Ajuste para reporte Hras trabajadas
//#70			MZM			31.10.2019				adicion de totales cuando no existen columnas fijas
//#77			MZM			14.11.2019				Ajuste reportes varios
//#80			MZM			22.11.2019				Reporte bono-desc y formato de numero
//#83	    MZM(ETR)		10.12.2019				Habilitacion de opcion historico de planilla
//#93			MZM			13.02.2020				Ajuste en obtencion de subtotales para columnas no numericas
//#98		ETR	MZM			04.03.2020				Adecuacion para generacion de reporte consolidado (caso planilla reintegros)
//#123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019)
//#141	ETR				18.06.2020			MZM-KPLIAN			Ajuste a titulo de reporte
//#161	ETR				07.09.2020			MZM-KPLIAN			Ajuste en encabezado, quitando tipo contrato planta
//#ETR-3997				24.05.2021			MZM-KPLIAN			Se modifica el orden de impresion de datos respecto al contador de registros

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
	var $cant_columnas_totalizan;//#80
	var $cantidad_columnas_repo;//#80
	var $cant_col_suman;
	
	function Header() {
		
		
		if(count($this->datos_detalle)>0){
			
		
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 5, 30, 15);
		$this->SetFont('','B',7);
		$this->Ln(1);
		$this->Cell($this->ancho_hoja-20,3,'',0,0,'R');
		$this->Cell(40,3,$this->datos_titulo['depto'],0,1,'C');
		$this->Cell($this->ancho_hoja-20,3,'',0,0,'R');
		$this->Cell(40,3,$this->datos_titulo['uo'],0,1,'R');
		
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($this->ancho_hoja-20,3,'',0,0,'R');
		$this->Cell(40, 3, $pagenumtxt, '', 1, 'R');
		
		//#83
		$dr=substr($this->datos_titulo['fecha_backup'],0,2);
		$mr=substr($this->datos_titulo['fecha_backup'],3,2);
		$ar=substr($this->datos_titulo['fecha_backup'],6);
		if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
			$this->Cell($this->ancho_hoja-20, 3, '', '', 0, 'R');
			$this->Cell(40, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'C');
		}else{
			$this->Cell($this->ancho_hoja+20, 3, '', '', 1, 'R');
		}
		
		
		$this->SetFont('','B',12);
		$tipo_con='';
		$tipo_con=$this->datos_detalle[0]['nombre'];
		if ($tipo_con=='Planta') $tipo_con='';
		if ($this->objParam->getParametro('id_tipo_contrato')!=''){//01.10.2019
		    if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$tipo_con=' ('.$tipo_con.' - '.$this->objParam->getParametro('personal_activo').')';
			}else{
				if ($tipo_con!='')				
				$tipo_con=' ('.$tipo_con.')';
			}
		
			
		}else{
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$tipo_con=' ('.$this->objParam->getParametro('personal_activo').')';
			}
		}
		
		
		
		$this->Cell(0,5,$this->datos_titulo['titulo_reporte'] .$tipo_con.'',0,1,'C');
		
		//Al Mes De  '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion']
		
		$this->SetFont('','B',10);
		
		
						
					   
		
		
		if($this->datos_titulo['periodo']!=''){
			if ($this->objParam->getParametro('consolidar')=='si'){//#98
							
							$this->Cell(0,5,'Acumulado a: ' . str_replace ('de ','',$this->datos_titulo['periodo_lite']),0,1,'C');//#141
						}else{
							$this->Cell(0,5,'Correspondiente a: ' . str_replace ('de ','',$this->datos_titulo['periodo_lite']),0,1,'C'); //#141
						}
				
		}else{
			$this->Cell(0,5,'GESTION ' . $this->datos_titulo['gestion'],0,1,'C'); // planilla prima 31.10.2019
		}
		
		
		
		if ($this->datos_titulo['mostrar_ufv']=='si'){
			$this->SetFont('','B',7);
			$this->Cell($this->ancho_hoja,3.5,'U.F.V. Anterior: ' ,0,0,'R');
			$this->SetFont('','U',7);
			$this->Cell(10,3.5,number_format($this->datos_titulo['ufv_ini'],6,'.',','),0,1,'L'); //#80
			$this->SetFont('','B',7);
			$this->Cell($this->ancho_hoja,3.5,'U.F.V. Actual: ' ,0,0,'R');
			$this->SetFont('','U',7);
			$this->Cell(10,3.5,number_format($this->datos_titulo['ufv_fin'],6,'.',','),0,1,'L');//#80
			
		}
		
		//#80
		if ($this->datos_titulo['tipo_reporte']=='bono_descuento'){
			$this->cant_columnas_totalizan=$this->datos_titulo['cant_columnas_totalizan']+1;
			$this->cantidad_columnas_repo=$this->datos_titulo['cantidad_columnas']+2;
			$this->Cell(50,5,'',0,1,'L');
			$this->Cell(50,3.5,'CONCEPTO: '.$this->objParam->getParametro('nombre_descuento'),0,1,'L');
			
		}else{
			$this->cantidad_columnas_repo=$this->datos_titulo['cantidad_columnas'];
			$this->cant_columnas_totalizan=$this->datos_titulo['cant_columnas_totalizan'];//#80
		}
		
		
		$this->SetFont('','B',10);
		
		if($this->objParam->getParametro('nombre_afp')!=''){
			$this->Cell($this->ancho_hoja/2,5,$this->gerencia ,0,0,'L');
			$this->Cell($this->ancho_hoja/2+20,5,$this->objParam->getParametro('nombre_afp') ,0,1,'R');
		}else{
			$this->Cell($this->ancho_hoja/2,5,$this->gerencia ,0,1,'L');
		}
		
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
		//var_dump($this->datos_detalle); exit;
		foreach($this->datos_detalle as $value) {
			$this->Cell($value['ancho_columna'],3.5,$value['titulo_reporte_superior'],'LTR',0,'C');
			$columnas++;
			if ($columnas == $this->cantidad_columnas_repo) {
				
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
		
		//var_dump($this->datos_detalle); exit;
		foreach($this->datos_detalle as $value) {
			$this->Cell($value['ancho_columna'],3.5,$value['titulo_reporte_inferior'],'LBR',0,'C');
			//iniciar ancho de columna, alineacion y formato de numero
			array_push($this->tablewidths, $value['ancho_columna']); 
			
			if($value['sumar_total']=='si' ){
	  			array_push($this->tablealigns, 'R');
				array_push($this->tablenumbers, 2); 
	  			
				$this->cant_col_suman++;//#80
	  		}else{
	  			
	  				array_push($this->tablealigns, 'L');
					array_push($this->tablenumbers, 0);
	  			
	  			
	  		}
			
			$columnas++;
			if ($columnas == $this->cantidad_columnas_repo) {
				
				break;
			}
		}
		$this->ln();	
		
		}//#123	 
		else{$this->SetFont('','B',12);
			$this->Cell(0,5,'SIN DATOS PARA MOSTRAR','',1,'C');//*****
		}
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
		if ($this->datos_titulo['mostrar_ufv'] == 'si' ) {
			$this->SetMargins(5, 50, 5); //**********++ 
		}else{
			if ($this->datos_titulo['tipo_reporte']=='bono_descuento'){
				$this->SetMargins(5, 52, 5); //**********++ 
			}else{
				$this->SetMargins(5, 43, 5); //**********++ 
			}
				
			
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
		$empleados_gerencia = 0;
		$array_show = $this->iniciarArrayShow($this->datos_detalle[0]);		
		
		for ($i = 0; $i < $this->cantidad_columnas_repo; $i++) {  //#80
	 		$sum_subtotal[$i]=0;
			$sum_total[$i]=0;
		}
		$columnas = 0;
		
		foreach ($this->datos_detalle as $value) {
			
		
			if ($id_funcionario != $value['id_funcionario']  ) {
			
				if($this->cant_columnas_totalizan==1){//#80
					
					if($array_show[((count($array_show))-1)]!=0){ 
						$this->SetFont('','',8);
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
							$this->SetFont('','B',10);
							if ($this->ancho_sin_totales>5){
								$this->Cell($this->ancho_sin_totales,3,'TOTAL ' . $this->gerencia . ' : ','RBT',0,'R');
							}else{
								if ($this->ancho_sin_totales!=0){
								$this->Cell($this->ancho_sin_totales,3,'','RBT',0,'R');}
							}
			 				
							for ($i = 0; $i < $this->cantidad_columnas_repo; $i++) {//#80
							  if($this->cant_col_suman > 0){//#80
								if ($this->datos_detalle[$i]['sumar_total'] == 'si'){
									
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i],2,'.',','),1,0,'R');//#50
								} 
								else
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
								//reiniciar subtotales
							  }
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
						
						$this->SetFont('','',8);
						$this->UniRow($array_show,false, $this->bordes, $this->interlineado);
						$columnas = 0;
						//#ETR-3997
						$this->numeracion++;
						$empleados_gerencia++;
						//echo $empleados_gerencia."--".$value['nombre_empleado']; exit;
						//var_dump($value); exit;
						$array_show = $this->iniciarArrayShow($value);
						$id_funcionario = $value['id_funcionario'];
						//Si cambia la gerencia
						
						if ($this->gerencia != $value['gerencia']) { 
							//generar subtotales
							$this->SetFont('','B',8); 
							
							if ($this->ancho_sin_totales>5){ $this->SetFont('','B',10);
								$this->Cell($this->ancho_sin_totales,3,'TOTAL ' . $this->gerencia . ' : ','RBT',0,'R');
							}else{
								if ($this->ancho_sin_totales!=0){
								$this->Cell($this->ancho_sin_totales,3,'','RBT',0,'R');}
							}
			 				
							for ($i = 0; $i < $this->cantidad_columnas_repo; $i++) {//#80
							
							  if($this->cant_col_suman > 0){//#80
								if ($this->datos_detalle[$i]['sumar_total'] == 'si') {
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i],2,'.',','),1,0,'R');//#50
									if ($this->datos_titulo['tipo_reporte']=='bono_descuento'){
										$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i]/$this->datos_titulo['tc'],2,'.',','),1,0,'R');//#80
									}
								}
								else
									$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
							  }
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

						
				}
				
			//si no es un nuevo funcionario hacer push al arreglo con el dato recibido
			} 
			
			
				//#65 
				if($value['sumar_total']=='si'){
		  			array_push($array_show, $value['valor_columna']); 
					
		  		}else{
		  			array_push($array_show, mb_strcut($value['valor_columna'],0,$value['ancho_columna']/1.79,"UTF-8"));
					
		  		}
			    //#93 
	  			if($value['sumar_total']=='si'){	
				$sum_subtotal[$columnas] += $value['valor_columna'];
				$sum_total[$columnas] += $value['valor_columna'];
				}$columnas++;	
	  		
		}
		$this->SetFont('','',8);
		//Añade al ultimo empleado de la lista
		//#77
		$abc=(count($array_show)-1);
		
		
		
		if($this->cant_columnas_totalizan==1) {
			
				if ($array_show[((count($array_show))-1)]!=0){
					$this->UniRow($array_show,false, $this->bordes, $this->interlineado);
					$this->numeracion++; //------------***********
					$empleados_gerencia++;
				}
				
			}else{
				$this->UniRow($array_show,false, $this->bordes, $this->interlineado);
				$this->numeracion++; //------------***********
				$empleados_gerencia++;
			}
			
			
			
		//}
		
		//Si cambia la gerencia
		
		//Añade el ultimo subtotal de la gerencia
		//generar subtotales
		$this->SetFont('','B',8);
		
		if ($this->gerencia!=''){
			
			if ($this->ancho_sin_totales>5){
				$this->Cell($this->ancho_sin_totales,3,'TOTAL ' . $this->gerencia . ' : ','RBT',0,'R');
			}else{
				if ($this->ancho_sin_totales!=0){
				$this->Cell($this->ancho_sin_totales,3,'','RBT',0,'R');
				}
			}
			for ($i = 0; $i < $this->cantidad_columnas_repo; $i++) {//#80
			  if($this->cant_col_suman > 0){//#80
				if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i],2,'.',','),1,0,'R');//#50
				else
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
			  }
				//reiniciar subtotales
				$sum_subtotal[$i] = 0;
			}
			$this->ln(10); $this->SetFont('','B',10);
			//$empleados_gerencia=$empleados_gerencia-1;
			$this->Cell($this->ancho_sin_totales*2,3,'SUBTOTAL EMPLEADOS '.$this->gerencia . ' : ' .$empleados_gerencia,'',0,'L');
			$this->ln(10);
		
		}
		
		
		//planilla
		//#70
		if($this->ancho_sin_totales > 5){ $this->SetFont('','B',10);
			$this->Cell($this->ancho_sin_totales,3,'TOTAL PLANILLA : ','RBT',0,'R');
		}else{
			if ($this->ancho_sin_totales!=0){
				$this->Cell($this->ancho_sin_totales,3,'','RBT',0,'R');}
			}
		if($this->cant_col_suman > 0){//#80
			for ($i = 0; $i < $this->cantidad_columnas_repo; $i++) {//#80
				if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_total[$i],2,'.',','),1,0,'R');//#50
				else
					$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
			}
			$this->ln(8);
		}
		
		
		$this->ln(2);
		$this->numeracion=$this->numeracion-1;
		if(count($this->datos_detalle)>0){ $this->SetFont('','B',10);
			$this->Cell($this->ancho_sin_totales*2,3,'TOTAL EMPLEADOS PLANILLA: '.(($this->numeracion)),'',0,'L');
		}
	}
	function iniciarArrayShow($detalle) { 
		$res_array = array();  
		if ($this->datos_titulo['numerar'] == 'si')
			array_push($res_array, $this->numeracion);
		if ($this->datos_titulo['mostrar_nombre'] == 'si')
			array_push($res_array, mb_strcut($detalle['nombre_empleado'], 0,27, "UTF-8"));//#77
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