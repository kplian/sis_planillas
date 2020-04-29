<?php
// Extend the TCPDF class to create custom MultiRow
/**
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #119    ETR            23/04/2020           MZM                 Creacion
 */
class RPlanillaSaldoIva extends  ReportePDF {
	var $datos;	
	var $datos_titulo;//#83
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	//#77
	var $borde;
	var $interlineado;
	function Header() {
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		$this->SetFont('','B',7);
		if ($this->objParam->getParametro('fecha_backup')!=''){
			$dr=substr($this->objParam->getParametro('fecha_backup'),0,4);
			$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
			$ar=substr($this->objParam->getParametro('fecha_backup'),8,2);
			$id=substr($this->objParam->getParametro('fecha_backup'),9);
			$this->Cell(0, 3, '', '', 0, 'R');
			$this->Cell(0, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar.$id, '', 1, 'R');
		}else{
			$this->Cell(0, 3, '', '', 1, 'R');
		}
		
		
		$this->SetFont('','B',12);//#77
		$this->SetY(20);
		$cadena_nomina='';
		
		if($this->objParam->getParametro('id_tipo_contrato')!='' && $this->objParam->getParametro('id_tipo_contrato')>0){
			
			
				$cadena_nomina=' ('.$this->objParam->getParametro('nombre_tipo_contrato').')';
			
		}
		
		
		$this->Cell(0,5,'DETALLE DE SALDOS ACUMULADOS RC-IVA '.$cadena_nomina,0,1,'C');
		$this->SetFont('','B',10);
		
			$this->Cell(0,5,'Correspondiente al mes de : '.$this->datos[0]['periodo'],0,1,'C');
		
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$this->SetFont('','B',8);
		$this->SetX(10);
		//$this->Cell(18,5,'Codigo ','LTR',0,'C');
		
		
			  $this->Cell(75,5,'Nombre Completo','LTR',0,'C');
			  $this->Cell(25,5,'Fecha','LTR',0,'C');
			  $this->Cell(25,5,'Fecha ','LTR',0,'C');
			  $this->Cell(25,5,'Obs.','LTR',0,'C');
			  $this->Cell(25,5,'Sueldo','LTR',0,'C');
			  $this->Cell(25,5,'Saldo','LTR',1,'C');
			  
		
		//titulo inferior
		
		
		$this->SetX(10);
		
		
		
			  $this->Cell(75,5,'','LBR',0,'L');
			  $this->Cell(25,5,'Ingreso','LBR',0,'C');
			  $this->Cell(25,5,'Retiro','LBR',0,'C');
			  $this->Cell(25,5,'Finaliz.','LBR',0,'C');
			  $this->Cell(25,5,'Neto','LBR',0,'C');
			  $this->Cell(25,5,'Acumulado','LBR',1,'C');
		
		
	
		$this->alto_header =$this->GetY(); 

	}
	function setDatos($datos) {
		$this->datos = $datos;
		
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$array_datos;
		$this->SetY($this->alto_header+2); 
		$this->SetFont('','',8);
		$this->SetMargins(10,$this->alto_header+2, 5);
		$gerencia='';
		$departamento='';
		$codigo_col='';
		$id_funcionario=0;
		$cont=0;
		$num=1;
		$val=0;
		$tot_bs=0;
		
		
		
			
		$this->SetX(10);
		
		for ($i=0; $i<count($this->datos);$i++){
			if($this->datos[$i]['acumulado']>0 ){
			$this->Cell(75,5,$this->datos[$i]['desc_funcionario'],'',0,'L');	
			$this->Cell(25,5,$this->datos[$i]['fecha_primer_contrato'],'',0,'C');
			$this->Cell(25,5,$this->datos[$i]['fecha_finalizacion'],'',0,'C');
			$this->Cell(25,5,$this->datos[$i]['observaciones_fin'],'',0,'L');
			$this->Cell(25,5,number_format($this->datos[$i]['sueldo_neto'],2),'',0,'R');
			$this->Cell(25,5,number_format($this->datos[$i]['acumulado'],2),'',1,'R');
			$tot_bs=$tot_bs+$this->datos[$i]['acumulado'];
			}
		}
		
		
		/***********************************************/
		
				//#41
				$this->SetLineWidth(0.2);
		 	 	$this->SetDrawColor(0,0,0);
				$this->Cell(0,0,'','B',1);
				$this->SetFont('','B',8);
				
			$this->Cell(75,5,'','',0,'L');	
			$this->Cell(25,5,'','',0,'C');
			$this->Cell(25,5,'','',0,'C');
			$this->Cell(25,5,'','',0,'L');
			$this->Cell(25,5,'TOTAL:','',0,'R');
			$this->Cell(25,5,number_format($tot_bs,2),'',1,'R');
			
		}

		
	
		
		
		
			
	
	
    
}
?>