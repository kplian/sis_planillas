<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #56    ETR            30/09/2019           MZM                 Creacion 
*/
class RRelacionSaldos extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	
	function Header() {
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		
		
		$this->SetFont('','B',15);
		$this->SetY(20);
		
		
		$ormargins = $this->getOriginalMargins();
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		
		$fecha_rep = date("d/m/Y");
		
		
			$this->Cell(135,7,'RESUMEN - RELACION DE SALDOS','',0,'R');
			
			$this->SetFont('','B',8);
			$pagenumtxt = $this->getAliasNumPage();
			
			$this->Cell(25, 7, 'Página:', '', 0, 'R');
			$this->SetFont('','',8);
			$this->Cell(5, 7, '', '', 0, 'L');
			$this->Cell(10, 7, $pagenumtxt, '', 1, 'L');
			
						$this->SetFont('','B',10);
			
			$this->Cell(90,5,'Correspondiente a: ',0,0,'R');
			$this->SetFont('','',10);
			$this->Cell(50,5,$this->datos[0]['periodo'],0,0,'L');
			
			$this->SetFont('','B',8);
			$this->Cell(10, 0, '', '', 0, 'L');
			$this->Cell(15, 0, "Fecha : ", '', 0, 'L');
			$this->SetFont('','',8);
			$this->Cell(10, 0, $fecha_rep, '', 1, 'L');
		
		
		$this->SetLineWidth(0.5);
	 	$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$this->SetLineWidth(0.2);
		$this->SetFont('','B',8);
		$this->SetX(10);
		$value_tp='Banco';
		$this->Cell(5,5,'','',0,'C');
		$this->Cell(25,5,'Forma de Pago','LBTR',0,'L');
		$this->Cell(5,5,'','',0,'C');
		$this->SetFont('','',8);
		$this->Cell(25,5,''.$value_tp,'',1,'L');
			  
			  
			  
	
		$this->alto_header =$this->GetY(); 

}
	function setDatos($datos) {
		$this->datos = $datos;
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$array_datos;
		$this->SetY($this->alto_header+5); 
		$this->SetFont('','',7);
		$this->SetMargins(10,$this->alto_header+5, 5);
		$total=0;
		
		
				for ($i=0; $i<count($this->datos);$i++){
					$this->SetFont('','B',8);
					$this->Cell(25,5,'Ciudad','LBTR',0,'L');	 
					$this->Cell(5,5,'','',0,'C');
					$this->SetFont('','',8);
					$this->Cell(30,5,$this->datos[$i]['nombre'],'',1,'L');
					$this->Ln(3);	 
					$this->SetFont('','B',8);
					$this->Cell(25,5,'','',0,'L');	
					$this->Cell(80,5,'Banco','LBTR',0,'C');	 
					$this->Cell(3.5,5,'','',0,'L');
					$this->Cell(30,5,'Monto Bs.','LBTR',1,'C');	  
					$this->SetFont('','',8);
					$this->Cell(25,5,'','',0,'L');	
					$this->Cell(80,5,$this->datos[$i]['banco'],'',0,'L');	 
					$this->Cell(3.5,5,'','',0,'L');
					$this->Cell(30,5,number_format($this->datos[$i]['importe'],2,',','.'),'',1,'R');
					$total=$total+$this->datos[$i]['importe'];
					$this->Ln(3);	 
					$this->Cell(5,5,'','',0,'L');	
				}
		
		$this->SetLineWidth(0.2);
	 	$this->SetDrawColor(0,0,0);
		
		//$this->Cell(189,0,'','B',1);
		$this->Cell(180,0,'','B',1);
		$this->SetFont('','B',8);
		$this->Cell(108.5,5,'Total para Banco:','',0,'R');
		$this->SetFont('','',8);
		$this->Cell(30,5,number_format($total,2,',','.'),'',1,'R');
		
				
		
		
		}
		
		function Footer(){ }
		
			
	
	
    
}
?>