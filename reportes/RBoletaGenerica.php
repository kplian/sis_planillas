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
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
		$this->SetFont('','B',10);
		
		$this->Cell(0,5,'No Patronal : '.$this->datos_titulo['nro_patronal'],0,1,'R');
		$this->Cell(0,5,'NIT : '.$this->datos_titulo['nit'],0,1,'R');
		
		$this->SetFont('','B',12);
		$this->Cell(0,5,$this->datos_titulo['titulo_reporte'] . ' : '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion'],0,0,'C');
				
		$this->Ln(2);
		$this->SetFont('','B',8);		

	}
	function datosHeader ($titulo, $detalle) {
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->SetLeftMargin(5);
		$this->SetRightMargin(5);
		$this->AddPage();
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
			
	}	
    
}
?>