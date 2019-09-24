<?php

#47    ETR             24-09-2019            Manuel Guerra        reporte de verificacion presupuestaria
class RVerificacionPresupuestaria extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $s1;
	var $s2;
	var $s3;
	var $s4;
	var $s5;
	var $s6;
	var $t1;
	var $t2;
	var $t3;
	var $t4;
	var $t5;
	var $t6;
	var $total;
	
	
	function datosHeader ($detalle) {
        $this->SetHeaderMargin(8);
        $this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->subtotal = 0;
		$this->SetMargins(25, 38, 5);
	}
	
	function Header() {
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));	
		$this->Ln(3);
		//formato de fecha
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);		
		
	    $this->SetFont('','B',12);		
		$this->Cell(0,5,"VERIFICACION PRESUPUESTARIA",0,1,'C');		
		//$this->Ln();
		$this->SetFont('','B',7);
		$this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');		
		$this->Ln(2);
		
		$this->SetFont('','',10);		
		$height = 5;
        $width1 = 5;
		$esp_width = 10;
        $width_c1= 55;
		$width_c2= 112;
        $width3 = 40;
        $width4 = 75;		
		$this->Ln(4);		
		$this->SetFont('','B',6);
		$this->generarCabecera();
				
	}
	
	function Footer() {		
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		//set style for cell border
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, '', '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$this->Ln($line_width);
	}
	
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();	   
		$this->generarCuerpo($this->datos_detalle);		
		if($this->s1 != 0){
			$this->SetFont('','B',6);
			$this->cerrarCuadro();	
		    $this->cerrarCuadroTotal();
		}		
		$this->Ln(4);			
	} 
    function generarCabecera(){    	
		//arma cabecera de la tabla  
		
		$conf_par_tablewidths=array(7,18,100,20,18,13);
        $conf_par_tablealigns=array('C','C','C','C','C','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0);
        $conf_tableborders=array();
        $conf_tabletextcolor=array();
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$RowArray = array(
			's0' => 'Nº',
			's1' => 'CODIGO TCC',
			's2' => 'DESCRIPCION TCC',       
			's3' => 'TIPO DE CONSOLIDACION',   
			's4' => 'SALDO COMPROMETIDO',
			's5' => 'ESTADO'
		);
		
		$this->MultiRow($RowArray, false, 1);
    }
	
	function generarCuerpo($detalle){
		
		$count = 1;
		$fill = 0;
		$this->total = count($detalle);
		$this->s1 = 0;

		foreach ($detalle as $val) {			
			$this->imprimirLinea($val,$count,$fill);
			$fill = !$fill;
			$count = $count + 1;
			$this->total = $this->total -1;
			$this->revisarfinPagina();
		}
	}	
	
	function imprimirLinea($val,$count,$fill){
		
		$this->SetFillColor(224, 235, 255);
        $this->SetTextColor(0);
        $this->SetFont('','',6);
			
		$conf_par_tablewidths=array(7,18,100,20,18,13);
        $conf_par_tablealigns=array('L','L','L','R','R','R');
        $conf_par_tablenumbers=array(0,0,0,2,2,0);
		$conf_tableborders=array('LR','LR','LR','LR','LR','LRB');
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$this->caclularMontos($val);
		$estado='-';
		if($val['veripre_vali']=='true'){
			$estado='Validado';
		}	
		$RowArray = array(
			's0'  => $count,
			's1' => trim($val['codigo_techo']),
			's2' => trim($val['descripcion_techo']),
			's3' => number_format((float)$val['suma'], 2, '.', ''),		
			's4' => number_format((float)$val['veripre_dispo'], 2, '.', ''),							
			's5' => $estado
		);	
		$this-> MultiRow($RowArray,$fill,0);
			
	}


    function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);		
        if ($startY > 190) {
            $this->cerrarCuadro();
            $this->cerrarCuadroTotal();
            if($this->total!= 0){
                $this->AddPage();
            }
        }
    }
		
	function caclularMontos($val){		
		$this->s1 = $this->s1 + $val['suma'];
		$this->s2 = $this->s2 + $val['veripre_dispo'];			
		$this->t1 = $this->t1 + $val['suma'];
		$this->t2 = $this->t2 + $val['veripre_dispo'];
	}
	function cerrarCuadro(){
	    //si noes inicio termina el cuardro anterior		
	    //(7,18,100,20,18,10);
	    $this->tablewidths=array(7 +18 +100,20,18,13);
	    $this->tablealigns=array('R','R','R','R');
	    $this->tablenumbers=array(0,2,2,0);	
	    $this->tableborders=array('T','LRTB','LRTB','');	 
	    $RowArray = array( 
	    				'espacio' => 'Subtotal:',
						's3' => $this->s1,						
						's4' => $this->s2								
				  		);     	                    
	    $this-> MultiRow($RowArray,false,1);			
		$this->s1 = 0;
		$this->s2 = 0;
  	}

	function cerrarCuadroTotal(){  			   
		//si noes inicio termina el cuardro anterior								
		$this->tablewidths=array(7 +18 +100,20,18,13);
	    $this->tablealigns=array('R','R','R','R');
	    $this->tablenumbers=array(0,2,2,0);	
	    $this->tableborders=array('T','LRTB','LRTB','');
		$RowArray = array( 			
						'espacio' => 'Total:',
						't3' => $this->t1,						
						't4' => $this->t2	
		);     	                     
		$this-> MultiRow($RowArray,false,1);	
	}
  
 
}
?>