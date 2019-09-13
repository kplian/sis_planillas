<?php
// Extend the TCPDF class to create custom MultiRow
class RBoletaGenerica extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $num_boleta=1;
	function Header() {
		

	}
	function Footer() {
		

	}
	function datosHeader ($titulo, $detalle) {
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT;
	}
	function generarReporte() { 
		//var_dump($this->datos_titulo); exit;
		
		$this->setFontSubsetting(false);
		//$this->AddPage();
		
		if($this->datos_titulo['multilinea']=='si'){
			
			/*$this->setFontSubsetting(false);
			$this->SetLeftMargin(5);
			$this->SetRightMargin(5);
			$this->AddPage();
			//cabecera del reporte
			$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 5, 5, 30, 15);
			$this->setY(20);
		
			       $this->SetFont('','B',15);
				   $this->Cell(0,5,$this->datos_titulo['titulo_reporte'],0,1,'C');
				   $this->SetFont('','B',10);
				   $this->Cell(0,5, 'Sueldo del Mes de '.$this->datos_titulo['periodo'].' de '.$this->datos_titulo['gestion'],0,1,'C');
				   $this->Ln(2);
				   $this->SetFont('','',7);
				   $espacio=0;
				 
				   $detalle_col_mod=array();
				   
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,0);
				   array_push($detalle_col_mod,'Nombre');
				   array_push($detalle_col_mod,'B');
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,$espacio);
				   array_push($detalle_col_mod,$this->datos_titulo['nombre']);
				   array_push($detalle_col_mod,'');
				   
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,2);
				   array_push($detalle_col_mod,'Cargo');
				   array_push($detalle_col_mod,'B');
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,$espacio);
				   array_push($detalle_col_mod,$this->datos_titulo['cargo']);
				   array_push($detalle_col_mod,'');
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,$this->datos_detalle[0]['espacio_previo']);
				   array_push($detalle_col_mod,'Fecha Ingreso');
				   array_push($detalle_col_mod,'B');
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,$espacio);
				   array_push($detalle_col_mod,$this->datos_detalle[0]['valor_columna']);
				   array_push($detalle_col_mod,'');
				   
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,0);
				   array_push($detalle_col_mod,'Codigo');
				   array_push($detalle_col_mod,'B');
				   
				   array_push($detalle_col_mod,$this->datos_titulo['id_funcionario']);
				   array_push($detalle_col_mod,$espacio);
				   array_push($detalle_col_mod,$this->datos_titulo['item']);
				   array_push($detalle_col_mod,'');
				   
				   $this->grillaDatos($detalle_col_mod,$alto=5,$border=0,$this->datos_titulo['num_columna_multilinea'],5,'L');
				  
				   $detalle_col_mod=array();
				   $this->Ln(5);
				   $this->SetLineWidth(0.1);
 	 				$this->SetDrawColor(0,0,0);
					$this->Cell(0,0,'','B',1);
				   //var_dump($this->datos_detalle); exit;
				   for ($i=1; $i< sizeof($this->datos_detalle); $i++ ){
				   	    
						array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
						array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
						array_push($detalle_col_mod,$this->datos_detalle[$i]['titulo_reporte_superior'].' '.$this->datos_detalle[$i]['titulo_reporte_inferior']);
						array_push($detalle_col_mod,'B'); 
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$espacio);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['valor_columna']);
							array_push($detalle_col_mod,'');
						
				    }
					
				   $this->grillaDatos($detalle_col_mod,$alto=5,$border=0,$this->datos_titulo['num_columna_multilinea'],5,'L');
				 */ 
				$x=($this->datos_titulo['cantidad_columnas']/$this->datos_titulo['num_columna_multilinea']*2*4)+15;
				
				$id_fun=$this->datos_detalle[0]['id_funcionario'];
				$logo=0;
				$espacio=0;
				$contador=0;
				$linea=0;
				$detalle_col_mod=array();
				$alineacion='R';
				$this->AddPage();
				$ancho_col= round((($this->ancho_hoja-1)/$this->datos_titulo['num_columna_multilinea']),2);
				 //echo sizeof($this->datos_detalle); exit;
				for ($i=0; $i< sizeof($this->datos_detalle); $i++ ){
					
					$dimensions=$this->getPageDimensions();
					
					$espacio=0;
					$cadena=$this->datos_detalle[$i]['valor_columna'];
					
					if($this->datos_detalle[$i]['id_funcionario']!=$id_fun){
						
						if ($this->GetY()+$x+$dimensions['bm']> $dimensions['hk']){
						$this->AddPage();
						
					   }
						//cabecera del reporte
						$this->SetFont('','',8);
						$fecha_rep = date("d/m/Y");
						$this->SetX($dimensions['wk']-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10);
						$this->Cell(10, 3, "Fecha: ".$fecha_rep, '', 1, 'L');
						
						$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 15, $this->GetY()-15, 30, 15);
						$this->SetFont('','B',15);
					    $this->Cell(0,5,$this->datos_titulo['titulo_reporte'],0,1,'C');
					    $this->SetFont('','B',10);
					    $this->Cell(0,5, 'Sueldo del Mes de '.$this->datos_titulo['periodo'].' de '.$this->datos_titulo['gestion'],0,1,'C');
					    $this->Ln(5);
					    $this->SetFont('','',10);
					  
					    $this->grillaDatos($detalle_col_mod,$alto=$x,$border=0,$this->datos_titulo['num_columna_multilinea'],3.5,'R',8);
						
						$this->Ln(5);
					    	
					    $detalle_col_mod=array();
							
					   
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['titulo_reporte_superior'].' '.$this->datos_detalle[$i]['titulo_reporte_inferior']);
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,$linea); 
							array_push($detalle_col_mod,'R'); 
							
								
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,0);
							array_push($detalle_col_mod,$cadena);
							array_push($detalle_col_mod,'');
							array_push($detalle_col_mod,$linea);
							array_push($detalle_col_mod,'L');  
					   	
						
						
						$this->Ln(30);
						$contador=1;
					}else{
						
						if($contador==4){// echo $this->datos_detalle[$i]['titulo_reporte_superior']; exit;
							
							$linea=1;
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['titulo_reporte_superior'].' '.$this->datos_detalle[$i]['titulo_reporte_inferior']);
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'R'); 
								
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,0);
							array_push($detalle_col_mod,$cadena);
							array_push($detalle_col_mod,'');
							array_push($detalle_col_mod,$linea);
							array_push($detalle_col_mod,'L');  
							
							/*array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,0);
							array_push($detalle_col_mod,'');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L'); 
								
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,0);
							array_push($detalle_col_mod,'');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
						    array_push($detalle_col_mod,'L');*/
						   
						   
						}else{
							$linea=0;
							if($contador> 4){
								$cadena=number_format($cadena,2,',','.');
								$alineacion='R';
							}else{
								$alineacion='L';
							}
						
								array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
								array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
								array_push($detalle_col_mod,$this->datos_detalle[$i]['titulo_reporte_superior'].' '.$this->datos_detalle[$i]['titulo_reporte_inferior']);
								array_push($detalle_col_mod,'B'); 
								array_push($detalle_col_mod,0); 
								array_push($detalle_col_mod,'R');
								
								array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
								array_push($detalle_col_mod,0);
								array_push($detalle_col_mod,$cadena);
								array_push($detalle_col_mod,'');
								array_push($detalle_col_mod,$linea);
								array_push($detalle_col_mod,$alineacion); 
							
							
							
						}
						
						$contador++;
						
					}
					$id_fun=$this->datos_detalle[$i]['id_funcionario'];
					
					
					
					
				}
						$dimensions=$this->getPageDimensions();
					   if ($this->GetY()+$x+$dimensions['bm']> $dimensions['hk']){
						$this->AddPage();
						
					   }
				 		
				   		$this->SetFont('','',8);
						$fecha_rep = date("d/m/Y");
						$this->SetX($dimensions['wk']-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10);
						$this->Cell(10, 3, "Fecha: ".$fecha_rep, '', 1, 'L');
						
						$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 15, $this->GetY()-15, 30, 15);
						$this->SetFont('','B',15);
					    $this->Cell(0,5,$this->datos_titulo['titulo_reporte'],0,1,'C');
					    $this->SetFont('','B',10);
					    $this->Cell(0,5, 'Sueldo del Mes de '.$this->datos_titulo['periodo'].' de '.$this->datos_titulo['gestion'],0,1,'C');
					    $this->Ln(5);
					    $this->SetFont('','',10);
					   
					    $this->grillaDatos($detalle_col_mod,$alto=$x,$border=0,$this->datos_titulo['num_columna_multilinea'],3,'R',8);
						$this->Ln(5);		
				 	
				   
				   
		}else{
				if (($this->num_boleta%2) == 1) {
					$this->setFontSubsetting(false);
					$this->SetLeftMargin(5);
					$this->SetRightMargin(5);
					$this->AddPage();
					//cabecera del reporte
					$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
					$this->setY(15);
					
				} else {
					//cabecera del reporte
					$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 140, 30, 10);
					$this->setY(150);
				}
						
					$this->SetFont('','B',12);
					$this->Cell(0,5,$this->datos_titulo['titulo_reporte'] . ' : '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion'],0,1,'C');
		
					$this->SetFont('','B',10);
					
					$this->Cell(0,5,'No Patronal : '.$this->datos_titulo['nro_patronal'],0,1,'R');
					$this->Cell(0,5,'NIT : '.$this->datos_titulo['nit'],0,1,'R');
					
							
					$this->Ln(2);
						
					$this->SetFont('','B',10);
					
					$cargo = str_replace(',', "\n", $this->datos_titulo['cargo']);
					$item = str_replace(',', "\n", $this->datos_titulo['item']);
					
					$this->Cell(30,5,'Nombre','',0,'L');
					$this->Cell(100,5,$this->datos_titulo['nombre'],'',0,'L');
					
					$this->Cell(30,5,'CI','',0,'L');
					$this->Cell(40,5,$this->datos_titulo['ci'],'',1,'L');
					
					$this->Cell(30,5,'Cargo','',0,'L');
					$this->MultiCell(100,5,$cargo,'','L',false,0);
					
					$this->Cell(30,5,'Item','',0,'L');
					$this->MultiCell(100,5,$item,'','L',false,1);
					
					$this->Cell(200,5,'','T',1,'L');
					
					
					$ingresos = '<table style="with:100%;table-layout:fixed;">';
					$descuentos = '<table style="with:100%;table-layout:fixed;">';
					$otros_descuentos = '';
					$total_ingresos = 0;
					$total_descuentos = 0;
					$this->SetFont('','',9);
					//var_dump($this->datos_detalle ); exit;
					foreach($this->datos_detalle as $data) {
						if ($data['tipo_columna'] == 'ingreso') {
							$ingresos .= '<tr><td style="height:30px;width:220px;text-align: left;">' . $data['titulo_reporte_superior'] . '</td>
										<td style="width:60px;text-align: left;">' . $data['titulo_reporte_inferior'] . '</td>
										<td style="width:70px;text-align: right;">' . number_format ( $data['valor_columna'] ,  2 , "." , "," ) . '</td></tr>';
							$total_ingresos += $data['valor_columna'];
						} 
						
						if ($data['tipo_columna'] == 'descuento_ley') {
							$descuentos .= '<tr><td style="width:220px;text-align: left;">' . $data['titulo_reporte_superior'] . '</td>
										<td style="width:60px;text-align: left;">' . $data['titulo_reporte_inferior'] . '</td>
										<td style="width:70px;text-align: right;">' . number_format ( $data['valor_columna'] ,  2 , "." , "," ) . '</td></tr>';
							$total_descuentos += $data['valor_columna'];
						} 
						
						if ($data['tipo_columna'] == 'otros_descuentos') {
							if ($otros_descuentos == '') {
								$otros_descuentos .= '<tr><td style="text-align: left;" colspan = "3"></td></tr>';
								$otros_descuentos .= '<tr><td style="text-align: left;" colspan = "2"><b>TOTAL DESCUENTOS DE LEY</b></td>
										
										<td style="width:70px;text-align: right;"><b>' . number_format ( $total_descuentos ,  2 , "." , "," ) . '</b></td></tr>';
								$otros_descuentos .= '<tr><td style="text-align: left;" colspan = "3"></td></tr>';
							}
							$otros_descuentos .= '<tr><td style="width:220px;text-align: left;">' . $data['titulo_reporte_superior'] . '</td>
										<td style="width:60px;text-align: left;">' . $data['titulo_reporte_inferior'] . '</td>
										<td style="width:70px;text-align: right;">' . number_format ( $data['valor_columna'] ,  2 , "." , "," ) . '</td></tr>';
							$total_descuentos += $data['valor_columna'];
						} 
			
						if ($data['tipo_columna'] == 'iva') {
							$iva = $data['valor_columna'];
						}
					}
					$ingresos .= '</table>';
					$otros_descuentos .= '</table>';
					
					
					$this->writeHTMLCell(100, 60, 5, $this->getY(), $ingresos, 'RB', 0, 0, true, 'C', true);
					$this->writeHTMLCell(100, 60, 105, $this->getY(), $descuentos . $otros_descuentos , 'B', 1, 0, true, 'C', true);
					
					$this->SetFont('','',9);
					$this->Cell(70,5,'TOTAL INGRESOS(Bs)','',0,'L');
					$this->Cell(28,5,number_format ( $total_ingresos ,  2 , "." , "," ),'',0,'R');
					$this->Cell(2,5,'','',0,'L');
					
					$this->Cell(70,5,'TOTAL DESCUENTOS(Bs)','',0,'L');
					$this->Cell(28,5,number_format ( $total_descuentos ,  2 , "." , "," ),'',1,'R');
					
					$this->SetFont('','BI',9);
					$this->Cell(100,5,'','',0,'L');
					$this->Cell(70,5,'LIQUIDO PAGABLE(Bs)','TLB',0,'L');
					$this->Cell(28,5,number_format ( $total_ingresos-$total_descuentos ,  2 , "." , "," ),'TRB',1,'R');
					
					$this->SetFont('','B',9);
					$this->Cell(70,5,'SALDO RC-IVA','',0,'L');
					$this->Cell(28,5,number_format ( $iva ,  2 , "." , "," ),'',1,'R');
					
					$this->Cell(70,5,'HORAS TRABAJADAS','',0,'L');
					$this->Cell(28,5,number_format ( $this->datos_titulo['horas_trabajadas'] ,  2 , "." , "," ),'',1,'R');
					 
					 
					$this->num_boleta++;
			}
						
		}	
    
}
?>