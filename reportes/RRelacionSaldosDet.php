<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #56    ETR            30/09/2019           MZM                 Creacion 
 #80    ETR            28/11/2019           MZM                 ajuste formato numeric
 #84	ETR				26.12.2019			MZM					Habilitacion de opcion en REPOBANCDET de ci de funcionario
 #98	ETR				04.03.2020			MZM					Adecuacion para generacion de reporte consolidado (caso planilla reintegros)
 #123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019) 
*/
class RRelacionSaldosDet extends  ReportePDF {
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
	function Header() {
		if (count($this->detalle)>0){
			
		
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
		
		   
		    $this->Cell(0,7, strtoupper($this->datos[0]['titulo_reporte']),'',1,'C');//#56
		    
			
			$this->SetFont('','B',10);
			
			
			if ($this->objParam->getParametro('consolidar')=='si'){//#98
				$this->Cell(0,5,'Acumulado a: ' . $this->detalle[0]['det_periodo'],0,1,'C');
			}else{
				$this->Cell(0,5,'Correspondiente a: '.$this->detalle[0]['det_periodo'],0,1,'C');
			}
				
			
			
			
		
		$this->SetLineWidth(0.5);
	 	$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$this->SetLineWidth(0.2);
		$this->SetFont('','B',8);
		$this->SetX(10);
				  
		
		$this->alto_header =$this->GetY(); 
		
		 
		
			$this->SetFont('','B',12);
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$this->Cell(0,5,'Personal '.$this->tipo_contrato. ' ('.$this->objParam->getParametro('personal_activo').')','',1,'C');
			}else{
				$this->Cell(0,5,'Personal '.$this->tipo_contrato,'',1,'C');	
			}
			
			$this->Ln(1);	
			
			
			$this->SetFont('','B',8);
			//$this->Cell(5,5,'','',0,'L');
			$this->Cell(25,5,'Ciudad','LBTR',0,'C');
			$this->Cell(1,5,'','',0,'L');
			$this->Cell(30,5,$this->ciudad,'',1,'L');
			$this->Ln(1);	
			$this->Cell(25,5,'Banco','LBTR',0,'C');
			$this->Cell(1,5,'','',0,'L');
			$this->Cell(30,5,$this->banco,'',1,'L');
			$this->Ln(1);	
						
			$this->SetFont('','B',8);
			$this->Cell(25,5,'Codigo','LBTR',0,'C');
			$this->Cell(1,5,'','',0,'C');
			if($this->objParam->getParametro('tipo_reporte')=='relacion_saldos_det_ci'){//#84
			    $this->Cell(76,5,'Nombre','LBTR',0,'C');
				$this->Cell(1,5,'','',0,'C');
				$this->Cell(18,5,'CI','LBTR',0,'C');
			}else{
				$this->Cell(94,5,'Nombre','LBTR',0,'C');
			}
			$this->Cell(1,5,'','',0,'C');
			$this->Cell(34,5,'Nro. Cuenta','LBTR',0,'C');
			$this->Cell(1,5,'','',0,'C');
			$this->Cell(30,5,'Monto (Bs.)','LBTR',1,'C');
		
		}//#123
		else{
			$this->SetFont('','B',12);
				$this->Cell(0,5,'SIN DATOS PARA MOSTRAR','',1,'C');//*****
		}

}
	function setDatos($datos,$detalle) {
		
		$this->datos = $datos;
		$this->detalle = $detalle;
		
		$this->tipo_contrato=$this->detalle[0]['det_tipo_contrato'];
		$this->tipo_pago= $this->detalle[0]['det_tipo_pago'];
		$this->ciudad=$this->detalle[0]['det_nombre'];
		$this->banco=$this->detalle[0]['det_banco'];
	}
	function generarReporte() {
		
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$array_datos;
		$this->SetY($this->alto_header+5); 
		$this->SetFont('','',7);
		
		$this->SetMargins(10,$this->alto_header+25, 5);
		
		$total=0;
		$ciudad='';
		$tipo_contrato='';
		$tipo_pago='';
		
		
				$this->bandera='detalle';
				
		if (count($this->detalle)>0)	{	
				
				//---------------------DETALLE----------------------//
				
				$det_tipo_contrato='';
				$det_tipo_pago='';
				$det_ciudad='';
				$det_total=0;
				$det_total_ciudad=0;
				$det_banco='';
				$pagenumtxt=1;
					$this->setY(65);
				for ($i=0; $i<count($this->detalle);$i++){
					$this->tipo_contrato=$this->detalle[$i]['det_tipo_contrato'];
					$this->ciudad=$this->detalle[$i]['det_nombre'];
					$this->banco=$this->detalle[$i]['det_banco'];
					
					if($det_ciudad!=$this->detalle[$i]['det_nombre'] || $det_banco!= $this->detalle[$i]['det_banco']){
						
						if($det_ciudad!=''){
							$this->SetLineWidth(0.2);
						 	$this->SetDrawColor(0,0,0);
							
							//$this->Cell(189,0,'','B',1);
							$this->Cell(190,0,'','B',1);
							$this->SetFont('','B',8);
							$this->Cell(125,5,'','',0,'C');
							$this->Cell(35,5,'Sub Total:','',0,'L');
							$this->SetFont('','',8);
							$this->Cell(30,5,number_format($det_total_ciudad,2,'.',','),'',1,'R');//#80
						}
												
					    if($det_ciudad==''){ $this->Cell(5,0,'','',0);
						}
						
						if($det_ciudad!=$this->detalle[$i]['det_nombre'] && $det_ciudad!=''){
						   $this->AddPage();
						}
						
						if($det_ciudad==$this->detalle[$i]['det_nombre'] && $det_banco!= $this->detalle[$i]['det_banco'] && $det_banco!=''  ){  $this->AddPage();
							
							
						}
						
						$this->SetFont('','B',12);
						
						
						
						$det_total_ciudad=0;
						$det_total=0;
						
					
						
						
					}				
					
					$this->SetFont('','',8);
					//$this->Cell(5,5,'','',0,'C');
					$this->Cell(25,5,$this->detalle[$i]['codigo'],'',0,'L');
					
					if($this->objParam->getParametro('tipo_reporte')=='relacion_saldos_det_ci'){//#84
						$this->Cell(77,5,$this->detalle[$i]['det_desc_funcionario2'],'',0,'L');
						$this->Cell(18,5,$this->detalle[$i]['ci'],'',0,'L');
					}else{
						$this->Cell(95,5,$this->detalle[$i]['det_desc_funcionario2'],'',0,'L');	
					}
					
					$this->Cell(35,5,$this->detalle[$i]['det_nro_cuenta'],'',0,'L');
					$this->Cell(30,5,number_format($this->detalle[$i]['det_importe'],2,'.',','),'',1,'R');//#80
					$this->Cell(5,5,'','',0,'C');
					$det_total=$det_total+$this->detalle[$i]['det_importe'];
					$det_total_ciudad=$det_total_ciudad+$this->detalle[$i]['det_importe'];
					$det_ciudad=$this->detalle[$i]['det_nombre'];
					$det_tipo_contrato= $this->detalle[$i]['det_tipo_contrato'];
					$det_tipo_pago=$this->detalle[$i]['det_tipo_pago'];
					$det_banco=$this->detalle[$i]['det_banco'];
					
				}

					$this->SetLineWidth(0.2);
						 	$this->SetDrawColor(0,0,0);
							
							//$this->Cell(189,0,'','B',1);
							$this->Cell(190,0,'','B',1);
							$this->SetFont('','B',8);
							$this->Cell(125,5,'','',0,'C');
							$this->Cell(35,5,'Sub Total:','',0,'L');
							$this->SetFont('','',8);
							$this->Cell(30,5,number_format($det_total_ciudad,2,'.',','),'',1,'R');//#80

			}//#123
		}
		
		function Footer(){ }
		
			
	
	
    
}
?>