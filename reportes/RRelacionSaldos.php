<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #56    ETR            30/09/2019           MZM                 Creacion
 #80    ETR            28/11/2019           MZM                 ajuste formato numeric
 #84    ETR            17/12/2019           MZM                 Inclusion de funcionalidad para manejo de resumen de planilla de aguinaldos
*/
class RRelacionSaldos extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	var $bandera;
	
	var $tipo_contrato;
	var $tipo_pago;
	var $ciudad;
	var $banco;
	var $tipo_contratoP;
	var $tipo_pagoP;
	var $firmas;//#84
	function Header() {

		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		
		
		
		
		
		$ormargins = $this->getOriginalMargins();
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->SetY(10);
		$fecha_rep = date("d/m/Y");
		
		$this->SetFont('','B',8);
		$pagenumtxt = $this->getAliasNumPage();
		$this->Cell(160, 3, '', '', 0, 'R');
		$this->Cell(10, 3, 'Página:', '', 0, 'L');
		$this->Cell(3, 3, '', '', 0, 'L');
		$this->SetFont('','',8);
		$this->Cell(10, 3, $pagenumtxt, '', 1, 'L');
			
		$this->SetFont('','B',8);
		$this->Cell(160, 3, '', '', 0, 'R');
		$this->Cell(10, 3, "Fecha : ", '', 0, 'L');
		$this->Cell(3, 3, '', '', 0, 'L');
		$this->SetFont('','',8);
		$this->Cell(10, 3, $fecha_rep, '', 1, 'L');	
		
		$this->SetFont('','B',15);
		
		    
		   	$this->Cell(0,7,strtoupper($this->detalle[0]['titulo_reporte']),'',1,'C');
			
		  
			$this->SetFont('','B',10);
			if($this->detalle[0]['periodo']>0){
				$this->Cell(0,5,'Correspondiente a'.$this->datos[0]['periodo'],0,1,'C');
			}else{
				$this->Cell(0,5,'GESTION '.$this->detalle[0]['gestion'],0,1,'C');
			}
			
			
			
			
		
		$this->SetLineWidth(0.5);
	 	$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$this->SetLineWidth(0.2);
		$this->SetFont('','B',8);
		
				  
	
		$this->alto_header =$this->GetY(); 
		
				
			$this->SetFont('','B',12);
			if($this->tipo_contratoP!=''){
				$this->Cell(0,5,'Personal '.$this->tipo_contratoP,'',1,'C');
				$this->Ln(1);	
			}
			
			
			$this->SetFont('','B',8);
			//$this->Cell(5,5,'','',0,'C');
			if($this->detalle[0]['periodo']>0){//#84
				if($this->tipo_pagoP!=''){
					$this->Cell(25,5,'Forma de Pago','LBTR',0,'L');
					$this->Cell(5,5,'','',0,'C');
					$this->SetFont('','',8);
					$this->Cell(25,5,''.$this->tipo_pagoP,'',1,'L');
				}
			}else{ $this->SetFont('','B',10);
				$this->SetX(30);
				$this->Cell(50,5,'','T',0,'C');
				$this->Cell(50,5,'','T',0,'C');
				$this->Cell(50,5,'Total','T',1,'C');
				$this->SetX(30);
				$this->Cell(50,5,'Distrito','B',0,'C');
				$this->Cell(50,5,'Forma de Pago','B',0,'C');
				$this->Cell(50,5,'Aguinaldo (Bs)','B',1,'C');
				
			}
			
						
		

}
	function setDatos($datos,$detalle,$firma) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT;
		$this->datos = $detalle;
		$this->detalle = $datos;
		$this->firmas = $firma;
		$this->tipo_contratoP= $this->datos[0]['tipo_contrato'];
		$this->tipo_pagoP= $this->datos[0]['tipo_pago'];
		
	}
	function generarReporte() {
		
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$array_datos;
		
		$this->SetFont('','',7);
	
		if($this->detalle[0]['periodo']>0){//#84
			$this->SetMargins(10,$this->alto_header+17, 5);
		}else{
			$this->SetMargins(25,$this->alto_header+17, 25);
		}
		$total=0;
		$ciudad='';
		$tipo_contrato='';
		$tipo_pago='';
		$subtotal=0;//#84
		$this->setY(55);
		
				for ($i=0; $i<count($this->datos);$i++){
					$this->bandera='resumen';
				
				
					$this->tipo_contratoP= $this->datos[$i]['tipo_contrato'];
					$this->tipo_pagoP= $this->datos[$i]['tipo_pago'];
					
					if($tipo_contrato!='' && $tipo_contrato!=$this->tipo_contratoP){
						$this->AddPage();
						$this->setX($this->getX()-5);
					}
					
					if($ciudad!=$this->datos[$i]['nombre']){ 
						//if($ciudad=='' && $ciudad!=$this->datos[$i]['nombre']){ //#56
							$this->Cell(5,5,'','',0,'L');
						//}
						if($this->detalle[0]['periodo']>0){//#84
							$this->SetFont('','B',8);
							$this->Cell(25,5,'Ciudad','LBTR',0,'L');	 
							$this->Cell(5,5,'','',0,'C');
							$this->SetFont('','',8);
							$this->Cell(30,5,$this->datos[$i]['nombre'],'',1,'L');
							$this->Ln(1);	 
							$this->SetFont('','B',8);
							$this->Cell(25,5,'','',0,'L');	
							$this->Cell(80,5,'Banco','LBTR',0,'C');	 
							$this->Cell(3.5,5,'','',0,'L');
							$this->Cell(30,5,'Monto Bs.','LBTR',1,'C');	  
							//$this->Cell(5,5,'','',0,'L'); //#56
							$this->Ln(1);
						}else{
							if($ciudad!=''){
								$this->Cell(150,0.1,'','LRB',1,'L');
								$this->SetFont('','B',8);
								$this->Cell(105,5,'Subtotal:','',0,'R');
								$this->SetFont('','',8);
								$this->Cell(50,5,number_format($subtotal,2,'.',','),'',0,'R');
								$subtotal=0;
							}
							$this->SetFont('','B',8);
							$this->Ln(5);
							$this->Cell(5,5,'','',0,'C');
							$this->SetFont('','B',8);
							$this->Cell(150,5,$this->datos[$i]['nombre'],'RLT',1,'L');
							
						}	
						
					}
					
					if($this->detalle[0]['periodo']>0){//#84
					
						$this->SetFont('','',8);
						$this->Cell(25,5,'','',0,'L');	
						$this->Cell(80,5,$this->datos[$i]['banco'],'',0,'L');	 
						$this->Cell(3.5,5,'','',0,'L');
						$this->Cell(30,5,number_format($this->datos[$i]['importe'],2,'.',','),'',1,'R');//#80 
					}else{
						
					
					
						$this->SetFont('','',8);
						$this->SetX(30);
						$this->Cell(50,5,'','L',0,'L');	
						$this->Cell(50,5,$this->datos[$i]['banco'],'',0,'L');	 
						$this->Cell(50,5,number_format($this->datos[$i]['importe'],2,'.',','),'R',1,'R');//#80
					}
						//$this->Cell(5,5,'','',0,'L');
						$total=$total+$this->datos[$i]['importe'];
						$subtotal=$subtotal+$this->datos[$i]['importe'];
						$ciudad=$this->datos[$i]['nombre'];
						$tipo_contrato= $this->datos[$i]['tipo_contrato'];
						$tipo_pago=$this->datos[$i]['tipo_pago'];
						
					
				}
			if($this->detalle[0]['periodo']>0){//#84
			}else{
				$this->SetX(30);
				$this->Cell(150,0.1,'','LRB',1,'L');
				$this->SetFont('','B',8);
				$this->Cell(105,5,'Subtotal:','',0,'R');
				$this->SetFont('','',8);
				$this->Cell(50,5,number_format($subtotal,2,'.',','),'',0,'R');
				$this->Ln(5);
			}
				
						
				$this->SetLineWidth(0.2);
			 	$this->SetDrawColor(0,0,0);
				$this->Cell(0,0,'','B',1);
				$this->SetFont('','B',8);
				
				
				if($this->detalle[0]['periodo']>0){//#84
					$this->Cell(108.5,5,'Total para Banco:','',0,'R');
					$this->SetFont('','',8);
					$this->Cell(30,5,number_format($total,2,'.',','),'',1,'R');//#80
				
					$this->tipo_contratoP='';
					$this->tipo_pagoP='';
					$this->AddPage();
					$this->SetFont('','B',8);
					$this->Cell(60,5,'','',0,'R');
					$this->Cell(30,0,'Forma de Pago: Banco','',0,'L');
					$this->SetFont('','',8);
					$this->Cell(30,0,number_format($total,2,'.',','),'',1,'R');//#80
					
					$this->SetFont('','B',8);
					$this->Cell(65,5,'','',0,'R');
					$this->Cell(30,0,'Forma de Pago: Cheque','',0,'L');
					$this->SetFont('','',8);
					$this->Cell(30,0,number_format(0,2,'.',','),'',1,'R');//#80
					
					$this->SetFont('','B',8);
					$this->Cell(65,5,'','',0,'R');
					$this->Cell(30,0,'Forma de Pago: Efectivo','',0,'L');
					$this->SetFont('','',8);
					$this->Cell(30,0,number_format(0,2,'.',','),'',1,'R');//#80
					
					$this->Cell(55,5,'','',0,'R');
					$this->Cell(80,0,'','B',1);
					$this->Ln(1);	
					$this->SetFont('','B',8);
					$this->Cell(65,5,'','',0,'R');
					$this->Cell(30,0,'Total de la Empresa:','',0,'L');
					$this->SetFont('','',8);
					$this->Cell(30,0,number_format($total,2,'.',','),'',1,'R');//#80
					
				}else{
					$this->Cell(105,5,'Total para Banco:','',0,'R');
					$this->SetFont('','',8);
					$this->Cell(50,5,number_format($total,2,'.',','),'',1,'R');//#84
				}
				
				
				if(count($this->firmas)>0){
					$this->ln(40);
					$ancho_firma= (($this->ancho_hoja-25) / count($this->firmas));
					
					$this->Cell($ancho_firma,2,'____________________________________________','',0,'C');
					
					
					$this->Cell($ancho_firma,2,'____________________________________________','',1,'C');
					
				
					
					
					
					$this->Cell($ancho_firma,3,$this->firmas[0]['abreviatura_titulo'].' '.$this->firmas[0]['nombre_empleado_firma'],'',0,'C');
					$this->Cell($ancho_firma,3,$this->firmas[1]['abreviatura_titulo'].' '.$this->firmas[1]['nombre_empleado_firma'],'',1,'C');
					$this->SetFont('','B',8);
					$this->Cell($ancho_firma,3,$this->firmas[0]['nombre_cargo_firma'],'',0,'C');
					$this->Cell($ancho_firma,3,$this->firmas[1]['nombre_cargo_firma'],'',1,'C');	
		
				}
				
				
				
		}
		
		function Footer(){ }
		
			
	
	
    
}
?>