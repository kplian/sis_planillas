<?php
// Extend the TCPDF class to create custom MultiRow
//159	ETR				25.08.2020			MZM-KPLIAN			Reporte horas trabajadas

class RPlanillaHorasTrab extends  ReportePDF { 
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
		
		
		
		
		$this->SetFont('','B',12);
		$tipo_con='';
		
		if ($this->objParam->getParametro('id_tipo_contrato')!=''){//01.10.2019
		    if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$tipo_con=' ('.$this->datos_detalle[0]['nombre'].' - '.$this->objParam->getParametro('personal_activo').')';
			}else{
				
				$tipo_con=' ('.$this->datos_detalle[0]['nombre'].')';
			}
		
			
		}else{
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$tipo_con=' ('.$this->objParam->getParametro('personal_activo').')';
			}
		}
		
		
		
		$this->Cell(0,5,'TOTAL HORAS TRABAJADAS POR CECO/ORDEN/PEP',0,1,'C');
		
		//Al Mes De  '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion']
		
		$this->SetFont('','B',10);
		
		
		$this->Cell(0,5,'Correspondiente al periodo : ' . $this->datos_detalle[0]['periodo_lite'].' de '.substr($this->datos_detalle[0]['periodo'],2,4),0,1,'C'); //#141
						
		$this->Ln(10);
		$this->SetFont('','B',8);
		
		
		
		
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
		
		
		$this->bordes= $this->datos_titulo['bordes'];
		$this->interlineado=$this->datos_titulo['interlineado'];
		
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$this->SetMargins(10,40, 5);
		//iniciacion de datos 
		$id_funcionario = '0';
		$sum_subtotal = array();
		$sum_total = array();
		$this->numeracion = 1;
		$empleados_gerencia = 1;
				
		$ts1=0; $ts2=0; $ts3=0; $ts4=0;
		
		
		$columnas = 0;
		
		foreach ($this->datos_detalle as $value) {
			if ($id_funcionario != $value['codigo_tcc']  ) {
				
				if ($id_funcionario!='0'){
					//totales
					
					$this->SetFont('','B',8);
					$this->SetLineWidth(0.2);
			 	 	$this->SetDrawColor(0,0,0);
					$this->Cell(0,0,'','B',1);
				
					$this->Cell(140,5,'Totales','',0,'C');
					$this->Cell(30,5,$ts1,'',0,'C');
					$this->Cell(30,5,$ts2,'',0,'C');
					$this->Cell(30,5,$ts3,'',0,'C');
					$this->Cell(30,5,$ts4,'',1,'C');
					$ts1=0; $ts2=0; $ts3=0; $ts4=0;
					
				}
				$this->SetFont('','B',8);
				$this->SetLineWidth(0.2);
		 	 	$this->SetDrawColor(0,0,0);
				$this->Cell(0,0,'','B',1);
				$this->Cell(20,5,'Ceco/Orden/Pep','',0,'C');
				$this->Cell(100,5,''.$value['codigo_tcc'],'',1,'C');
				$this->Ln(2);
				
				$this->Cell(20,5,'Periodo','',0,'C');
				$this->Cell(20,5,'Codigo','',0,'C');
				$this->Cell(80,5,'Nombre Completo','',0,'C');
				$this->Cell(20,5,'Día','',0,'C');
				$this->Cell(30,5,'Hrs Compensación','',0,'C');
				$this->Cell(30,5,'Hrs Normales','',0,'C');
				$this->Cell(30,5,'Hrs Extras','',0,'C');
				$this->Cell(30,5,'Hrs Nocturnas','',1,'C');
				$this->SetLineWidth(0.2);
		 	 	$this->SetDrawColor(0,0,0);
				$this->Cell(0,0,'','B',1);
				$this->SetFont('','',8);
				$this->Cell(20,5,$value['periodo'],'',0,'C');
				$this->Cell(20,5,$value['codigo'],'',0,'C');
				$this->Cell(80,5,$value['desc_funcionario'],'',0,'L');
				$this->Cell(20,5,$value['dia'],'',0,'C');
				$this->Cell(30,5,$value['total_comp'],'',0,'C');
				$this->Cell(30,5,$value['total_normal'],'',0,'C');
				$this->Cell(30,5,$value['total_extra'],'',0,'C');
				$this->Cell(30,5,$value['total_nocturna'],'',1,'C');
				
				$ts1=$ts1+$value['total_comp']; $ts2=$ts2+$value['total_normal']; $ts3=$ts3+$value['total_extra']; $ts4=$ts4+$value['total_nocturna'];
				
			//si no es un nuevo funcionario hacer push al arreglo con el dato recibido
			} else{ $this->SetFont('','',8);
				$this->Cell(20,5,$value['periodo'],'',0,'C');
				$this->Cell(20,5,$value['codigo'],'',0,'C');
				$this->Cell(80,5,$value['desc_funcionario'],'',0,'L');
				$this->Cell(20,5,$value['dia'],'',0,'C');
				$this->Cell(30,5,$value['total_comp'],'',0,'C');
				$this->Cell(30,5,$value['total_normal'],'',0,'C');
				$this->Cell(30,5,$value['total_extra'],'',0,'C');
				$this->Cell(30,5,$value['total_nocturna'],'',1,'C');
				$ts1=$ts1+$value['total_comp']; $ts2=$ts2+$value['total_normal']; $ts3=$ts3+$value['total_extra']; $ts4=$ts4+$value['total_nocturna'];
			}
			
			$id_funcionario=$value['codigo_tcc'];
				
	  		
		}

					$this->SetFont('','B',8);
					$this->SetLineWidth(0.2);
			 	 	$this->SetDrawColor(0,0,0);
					$this->Cell(0,0,'','B',1);
				
					$this->Cell(140,5,'Totales','',0,'C');
					$this->Cell(30,5,$ts1,'',0,'C');
					$this->Cell(30,5,$ts2,'',0,'C');
					$this->Cell(30,5,$ts3,'',0,'C');
					$this->Cell(30,5,$ts4,'',1,'C');
					
					$this->SetFont('','B',8);
					$this->SetLineWidth(0.2);
			 	 	$this->SetDrawColor(0,0,0);
					$this->Cell(0,0,'','B',1);
		
		
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