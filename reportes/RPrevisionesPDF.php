<?php
// Extend the TCPDF class to create custom MultiRow
class RPrevisionesPDF extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 245, 8, 30, 12);
		$this->SetFont('','B',12);
		
		$this->Cell(0,5,'REPORTE DE PREVISIONES AL :  '.$this->objParam->getParametro('fecha'),0,1,'C');
						
		$this->SetFont('','B',10);
		$this->Cell(0,5,'Gerencia : ' . $this->objParam->getParametro('uo'),0,1,'L');
		$this->Ln(1);
		$this->Cell(0,5,'Tipo de Contrato : ' . $this->objParam->getParametro('tipo_contrato'),0,1,'L');
		$this->Ln(2);
		$this->SetFont('','B',8);
		
		//Titulos de columnas superiores
		
		$this->Cell(40,3.5,'Gerencia','LTR',0,'C');
		$this->Cell(50,3.5,'Cargo','LTR',0,'C');
		$this->Cell(55,3.5,'Nombre Completo','LTR',0,'C');
		$this->Cell(15,3.5,'Salario','LTR',0,'C');
		$this->Cell(35,3.5,'Fecha Incorp','LTR',0,'C');
		$this->Cell(15,3.5,'Dias','LTR',0,'C');
		$this->Cell(25,3.5,'Indem Dia','LTR',0,'C');
		$this->Cell(20,3.5,'Indem','LTR',0,'C');
				
		$this->ln();	

	}
	function setDatos($datos) {
		$this->datos = $datos;
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->SetFont('','',8);
		$this->tablewidths=array(40,50,55,15,35,15,25,20);
		$this->tablealigns=array('L','L','L','R','L','L','R','R');	
		$this->tablenumbers=array(0,0,0,2,0,0,8,2);		
		foreach ($this->datos as $value) {
			$this->MultiRow($value);
			
		}		
		
			
	}
	
    
}
?>