<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
 #77	ETR				21.11.2019			MZM					Ajuste a reporte (inclusion de tipo contrato)
*/
class RPlanillaPersonal extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	
	function Header() {
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		
		$this->SetFont('','B',12);
		$this->SetY(20);
		$tipo_con='';//#77
		if($this->objParam->getParametro('id_tipo_contrato')>0){
			$tipo_con=' ('.$this->datos[0]['nombre'].')';	
		}
		
		if($this->objParam->getParametro('tipo_reporte')=='personal_ret'){
			$this->Cell(0,5,'PERSONAL RETIRADO'.$tipo_con,0,1,'C');//#77
			$this->Cell(0,5,'GESTION '.$this->datos[0]['gestion'],0,1,'C');
		}else{
			$this->Cell(0,5,'INCORPORACIONES DEL PERSONAL'.$tipo_con,0,1,'C');//#77
			$this->Cell(0,5,'GESTION '.$this->datos[0]['gestion'],0,1,'C');
		}
		
		
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		
		$this->SetFont('','B',8);
		$this->SetX(10);
		
			  $this->Cell(5,5,'N','LBTR',0,'C');
			  $this->Cell(70,5,'Nombre','LBTR',0,'C');
			  $this->Cell(55,5,'Cargo','LBTR',0,'C');
			  $this->Cell(55,5,'Centro','LBTR',0,'C');
			  if($this->objParam->getParametro('tipo_reporte')=='personal_ret'){
			  	$this->Cell(20,5,'Fecha Retiro','LBTR',0,'C');
			  	$this->Cell(30,5,'Motivo','LBTR',0,'C');
			  	$this->Cell(20,5,'Salario','LBTR',1,'C');
			  }else{
			  	$this->Cell(20,5,'Fecha Ing.','LBTR',0,'C');
			  	$this->Cell(20,5,'Salario','LBTR',0,'C');
			  	$this->Cell(18,5,'Tiem. Ctto','LBTR',0,'C');
			  	$this->Cell(20,5,'Fech Conclus','LBTR',0,'C');
			  }
			  
			  
			  
	
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
		$this->SetFont('','',8);
		$this->SetMargins(10,$this->alto_header+5, 5);
		$gerencia='';
		$departamento='';
		$codigo_col='';
		$id_funcionario=0;
		$cont=0;
		$n=1;
		$val=0;
		$novedad='';
		$fecha_novedad='';
		$dias=30;
		
		
				for ($i=0; $i<count($this->datos);$i++){
										 
					 	  	  $array_datos[$cont][0]=$cont+1;
							  $array_datos[$cont][1]=mb_strcut($this->datos[$i]['desc_funcionario1'],0,40, "UTF-8");//#77
							  $array_datos[$cont][2]=mb_strcut($this->datos[$i]['cargo'],0,30, "UTF-8");//#77
							  $array_datos[$cont][3]=mb_strcut($this->datos[$i]['centro'],0,30, "UTF-8");//#77
							  $array_datos[$cont][4]=$this->datos[$i]['fecha'];
							  $array_datos[$cont][5]= $this->datos[$i]['observaciones_finalizacion'];
							  $array_datos[$cont][6]= $this->datos[$i]['valor'];
							 
							  $array_datos[$cont][7]=$this->datos[$i]['mes'];
					
					$cont++;
				}
	
		$this->SetX(10);
		
		/***********************************************/
		
		   $code=''; 
			for ($i=0; $i<$cont;$i++){
			  	
				if($code!=$array_datos[$i][7])	{
					  
					  $this->SetFont('','B',10);
					  $this->Ln(2);
					  $this->Cell(5,5,'','',0,'L');
					  $this->Cell(70,5,$array_datos[$i][7],'',1,'L');
					  
					  $this->SetFont('','',8);
					  $this->Cell(5,5,$array_datos[$i][0],'',0,'R');
					  $this->Cell(70,5,$array_datos[$i][1],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][2],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][3],'',0,'L');
					  if($this->objParam->getParametro('tipo_reporte')=='personal_ret'){
						  $this->Cell(20,5,$array_datos[$i][4],'',0,'C');
						  $this->Cell(30,5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(20,5,$array_datos[$i][6],'',1,'R');
					  }else{
					  	  $this->Cell(20,5,$array_datos[$i][4],'',0,'C');
						  $this->Cell(20,5,$array_datos[$i][6],'',0,'R');
						  $this->Cell(18,5,'','',0,'R');
						  $this->Cell(20,5,'','',1,'R');
					  }
					  //---------
					 			
				}else{
					  $this->Cell(5,5,$array_datos[$i][0],'',0,'R');
					  $this->Cell(70,5,$array_datos[$i][1],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][2],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][3],'',0,'L');
					  if($this->objParam->getParametro('tipo_reporte')=='personal_ret'){
						  $this->Cell(20,5,$array_datos[$i][4],'',0,'C');
						  $this->Cell(30,5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(20,5,$array_datos[$i][6],'',1,'R');
					  }else{
					  	  $this->Cell(20,5,$array_datos[$i][4],'',0,'C');
						  $this->Cell(20,5,$array_datos[$i][6],'',0,'R');
						  $this->Cell(18,5,'','',0,'R');
						  $this->Cell(20,5,'','',1,'R');
					  }				
					
					 
			  }
				$code=$array_datos[$i][7];	
					
					
				}	
				
		
		
		}
		
		
			
	
	
    
}
?>