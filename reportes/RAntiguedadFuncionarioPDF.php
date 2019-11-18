<?php
// Extend the TCPDF class to create custom MultiRow
/*
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
 #66	ETR				16.10.2019			MZM					Adicion de total a reporte
 #77	ETR				15.11.2019			MZM					Ajsute reprote
 */
class RAntiguedadFuncionarioPDF extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	var $etiqueta;
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 5, 8, 30, 12);
		$this->SetFont('','B',8);
		$this->SetY(10);
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($this->ancho_hoja+200, 3, $pagenumtxt, '', 1, 'R');
		
		$this->SetFont('','B',15);
		$this->SetY(20);
		//#66
		$tipo_cto=$this->objParam->getParametro('nombre_tipo_contrato');
		if($tipo_cto!=''){
			$tipo_cto='('.$tipo_cto.')';
		}
		
		if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
			$this->Cell(0,5,'ANTIGUEDAD DE LOS EMPLEADOS '.$tipo_cto,0,1,'C');
			$this->etiqueta='Antiguedad';
		}else{
			
			
				$this->Cell(0,5,'CLASIFICACION DEL PERSONAL POR EDADES '.$tipo_cto,0,1,'C');
				$this->etiqueta='Edad';
			
		}
		
		
		$this->SetFont('','B',10);
		//#77
		$ar=substr($this->datos[0]['fecha_rep'], 0,4);
		$mr=substr($this->datos[0]['fecha_rep'], 5,2);
		$dr=substr($this->datos[0]['fecha_rep'], 8,2);
		
		$this->Cell(0,5,'Al: '.$dr.'/'.$mr.'/'.$ar,0,1,'C');
		
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$this->SetFont('','B',7);
		$this->Cell(45,3.5,'Centro','LTR',0,'C');
		$this->Cell(20,3.5,'Codigo Emp.','LTR',0,'C');
		$this->Cell(60,3.5,'Nombre Completo','LTR',0,'C');
		if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
			
			$this->Cell(20,3.5,'Fecha','LTR',0,'C');
			$this->Cell(10,3.5,'Antig','LTR',0,'C');
			$this->Cell(30,3.5,'T.Antiguedad','LTR',1,'C');
		}else{ 
			$this->Cell(30,3.5,'Cargo','LTR',0,'C');
			$this->Cell(20,3.5,'Fecha','LTR',0,'C');
			$this->Cell(10,3.5,'Edad','LTR',1,'C');
		}
		
			$this->Cell(45,3.5,'','LBR',0,'C');
			$this->Cell(20,3.5,'','LBR',0,'C');
			$this->Cell(60,3.5,'','LBR',0,'C');
		
		if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
			$this->Cell(20,3.5,'Ingreso','LBR',0,'C');
			$this->Cell(10,3.5,'Anterior','LBR',0,'C');
			$this->Cell(15,3.5,'Años','LTBR',0,'C');		
			$this->Cell(15,3.5,'Dias','LTBR',1,'C');	
		}else{
			$this->Cell(30,3.5,'','LBR',0,'C');
			$this->Cell(20,3.5,'Nacim','LBR',0,'C');
			$this->Cell(10,3.5,'','LBR',1,'C');
		}	
		
		//$this->Cell(0,5,'Rango de Antiguedad:'.$this->objParam->getParametro('rango'),0,1,'L');
		$this->alto_header =$this->GetY(); 

	}
	function setDatos($datos) {
		$this->datos = $datos;
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		
		$this->SetY($this->alto_header+2); 
		$this->SetFont('','',8);
		$this->SetMargins(15,$this->alto_header+2, 5);
		$array_fem; $contf=1;
		$array_mas; $contm=0; 
		
		//#66
		$totalf=0;
		$totalm=0;
		$totala=0;
		$totald=0;
		
		
		$rango_ini=$this->objParam->getParametro('rango_ini');
		$rango_fin=$this->objParam->getParametro('rango_fin');
		$contador_rango=$rango_fin;
		$genero=$this->datos[0]['genero'];
		$rango='-1';
		
			
		  	for ($i=0; $i<count($this->datos);$i++){
		    
					 if($this->datos[$i]['rango']!=$rango){
					 	   if($genero!=$this->datos[0]['genero']){
					 	
					 			$this->SetFont('','B',8);
								$this->Cell(65,3.5,'Total '.$this->datos[$i-1]['genero'].':','TB',0,'C');
								$this->Cell(120,3.5,''.$contf,'TB',1,'C');
								$this->Ln(2);
								$contf=0;
								$this->SetFont('','',8);
					 	
					 	    }
								$this->Ln(2);
								$this->SetFont('','B',10);
								$this->Cell(65,3.5,'Rango '.$this->etiqueta.' : '.$this->datos[$i]['rango'],'',1,'L');
								$this->Ln(2);
								$contf=0; 
								
								$this->SetFont('','',7);
								$this->Cell(45,3.5,substr ( $this->datos[$i]['nombre_uo_pre'], 0, 23),'',0,'L');
								$this->Cell(20,3.5,$this->datos[$i]['codigo'],'',0,'R');
								$this->Cell(60,3.5,substr ( $this->datos[$i]['desc_funcionario2'], 0, 30),'',0,'L');
								
								
								if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
									$ff=$this->datos[$i]['fecha_ingreso'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['antiguedad_ant'],'',0,'R');
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad_anos'],'',0,'R');		
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad'],'',1,'R');
								}else{
									$ff=$this->datos[$i]['fecha_nacimiento'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
								
									$this->Cell(30,3.5,substr ($this->datos[$i]['cargo'],0,18),'',0,'L');
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['edad'],'',1,'R');		
								}	
								
								
								$contf++;
								
								
						}else{
								$this->SetFont('','',8);
								if ($this->datos[$i]['genero']!=$genero){
									
										$this->SetFont('','B',8);
										$this->Ln(2);
										$this->Cell(65,3.5,'Total '.$this->datos[$i-1]['genero'].':','BT',0,'C');
										$this->Cell(120,3.5,''.$contf,'TB',1,'C');
										$this->Ln(2);
										$contf=0;
										
										$this->SetFont('','',8);
										
								}	
								
								
								$this->SetFont('','',7);
								$this->Cell(45,3.5,substr ( $this->datos[$i]['nombre_uo_pre'], 0, 23),'',0,'L');
								$this->Cell(20,3.5,$this->datos[$i]['codigo'],'',0,'R');
								$this->Cell(60,3.5,substr ( $this->datos[$i]['desc_funcionario2'], 0, 30),'',0,'L');
								
								if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
									$ff=$this->datos[$i]['fecha_ingreso'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
									
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['antiguedad_ant'],'',0,'R');
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad_anos'],'',0,'R');		
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad'],'',1,'R');
								}else{
									$ff=$this->datos[$i]['fecha_nacimiento'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
									$this->Cell(30,3.5,substr ($this->datos[$i]['cargo'],0,16),'',0,'L');
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['edad'],'',1,'R');		
									
								
									
									
								}
								$contf++;
								
								
						
						}
						$genero=$this->datos[$i]['genero'];
						$rango=$this->datos[$i]['rango'];
						//#66
					if($this->datos[$i]['genero']=='femenino'){
						$totalf++;
					}else{
						$totalm++;
					}
						
					$totala=$totala+$this->datos[$i]['antiguedad_anos'];
					$totald=$totald+$this->datos[$i]['antiguedad'];
				
			}
						$this->SetFont('','B',8);
						$this->Cell(65,3.5,'Total '.$genero.':','TB',0,'C');
						$this->Cell(120,3.5,''.$contf,'TB',1,'C');
						$this->Ln(2);

		
		
		//#66
		if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
			$this->Ln(2);
			$this->SetFont('','B',8);
							$this->Cell(70,3.5,'Total Hombres: '.$totalm,'',0,'L');
							$this->Cell(70,3.5,'Total Mujeres: '.$totalf,'',0,'L');
							$this->Cell(38,3.5,'Antiguedad Media: '.round($totala/($totalm+$totalf),0),'',0,'L');
							$this->Cell(25,3.5,''.round($totald/($totalm+$totalf),0),'',1,'L');
							$this->Ln(2);
			
			}
		
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