<?php

#47    ETR             24-09-2019            Manuel Guerra        reporte de verificacion presupuestaria
#54    ETR             24-09-2019            Manuel Guerra        mejora en consulta y reporte de verificación presupuestaria
class RVerificacionPresupuestaria extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $s1;
	var $s2;
	var $s3;
	var $t1;
	var $t2;
	var $t3;
	var $total;
	
	
	function datosHeader ($detalle) {
        $this->SetHeaderMargin(8);
        $this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;		
		$this->SetMargins(20, 36, 5);
	}
	
	function Header() {
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);				
	    $this->SetFont('','B',12);		
		$this->Cell(0,5,"VERIFICACION PRESUPUESTARIA",0,1,'C');				
		$this->SetFont('','B',7);
		$this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');		
		$this->Ln(6);			
		$this->generarCabecera();				
	}	
	
	function generarReporte() {
		$this->setFontSubsetting(true);
		$this->AddPage();	   
		$this->generarCuerpo($this->datos_detalle);		
		if($this->s1 != 0){			
			$this->cerrarCuadro();	
		    $this->cerrarCuadroTotal();
		}		
		$this->Ln(4);			
	} 
    function generarCabecera(){    	
		//arma cabecera de la tabla  
		
		$conf_par_tablewidths=array(7,18,100,20,18,18);
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
			's3' => 'REQUERIDO',   
			's4' => 'DISPONIBLE',
			's5' => 'ESTADO'
		);		
		$this->MultiRow($RowArray, false, 1);
    }
	
	function generarCuerpo($detalle){		
		$count = 1;
		$fill = 0;
		$this->total = count($detalle);
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
		$conf_par_tabletextcolor_rojo=array(array(0,0,0),array(0,0,0),array(0,0,0),array(0,0,0),array(255,0,0),array(255,0,0));      
		$conf_par_tablewidths=array(7,18,100,20,18,18);
        $conf_par_tablealigns=array('L','L','L','R','R','R');
        $conf_par_tablenumbers=array(0,0,0,2,2,0);
		$conf_tableborders=array('LR','LR','LR','LR','LR','LR');
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		//#54
		$this->caclularMontos($val);
		$estado='Disponible';		
		if($val['veripre_vali']=='false'){
			if($val['estado']=='Bloqueado'){
				$estado='Bloqueado';	
			}else{
				$estado='No Disponible';
			}			
			$this->tabletextcolor=$conf_par_tabletextcolor_rojo;
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
        if ($startY > 245) {
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
	    $this->tablewidths=array(7 +18 +100,20,18,18);
	    $this->tablealigns=array('R','R','R','R');
	    $this->tablenumbers=array(0,2,2,0);	
	    $this->tableborders=array('T','LRT','LRTB','T');	 
	    $RowArray = array( 
	    				'espacio' => 'Subtotal:',
						's3' => $this->s1,						
						's4' => $this->s2,
						''								
				  		);     	                    
	    $this-> MultiRow($RowArray,false,0);			
		$this->s1 = 0;
		$this->s2 = 0;
  	}

	function cerrarCuadroTotal(){  			   
		//si noes inicio termina el cuardro anterior								
		$this->tablewidths=array(7+18 +100,20,18,18);
	    $this->tablealigns=array('R','R','R','R');
	    $this->tablenumbers=array(0,2,2,0);	
	    $this->tableborders=array('','LRTB','LRTB','');
		$RowArray = array( 			
						'espacio' => 'Total:',
						't3' => $this->t1,						
						't4' => $this->t2,					
		);     	                     
		$this-> MultiRow($RowArray,false,0);	
	}
  
 
}
?>