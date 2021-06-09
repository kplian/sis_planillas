<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #ETR-4150			  04.06.2021			MZM-KPLIAN			Reporte CPS de planilla de reintegos
*/
class RPlanillaRetroactivoPDF extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	
	function Header() {
		//echo count($this->datos);exit;
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/cps.png', 300, 8, 50, 50);
		//#83
		$this->SetFont('','B',7);
		$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
		$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
		$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
		if($this->objParam->getParametro('fecha_backup')!=''){
			$this->Cell(0, 3, '', '', 0, 'R');
			$this->Cell(0, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'R');
		}else{
			$this->Cell(0, 3, '', '', 1, 'R');
		}
		$this->SetFont('','B',12);
		$this->SetY(20);
		$tipo_con='';//#77
		if($this->objParam->getParametro('id_tipo_contrato')>0){
			$tipo_con=' ('.$this->datos[0]['nombre'].')';	
		}
		if($tipo_con==' (Planta)') $tipo_con='';//#161 
		$this->SetTextColor(33, 152, 145);
		$this->Cell(0, 3, 'NOMBRE O RAZON SOCIAL:', '', 1, 'L');
		$this->Cell(0, 3, 'NUMERO DE EMPLEADOR CPS:', '', 1, 'L');
		$this->Cell(0, 3, 'NUMERO DE NIT:', '', 1, 'L');
		$this->Cell(0, 3, 'DIRECCION:', '', 1, 'L');
		$this->Cell(0, 3, 'TELEFONO:', '', 1, 'L');
		$this->Cell(0, 3, 'CORREO ELECTRONICO:', '', 1, 'L');
		$this->Ln(4);	
		
			$this->Cell(0,5,'PLANILLA RETROACTIVA - INCREMENTO SMN '.$this->datos[0]['gestion'],0,1,'C');//#77
			$this->Cell(0,5,'EXPRESADO EN BOLIVIANOS',0,1,'C');
		
		
		
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		
		$this->SetFont('','B',7);
		$this->SetX(3.5);
		
			  $this->Cell(5,5,'Nº','LBTR',0,'C');
			  $this->Cell(5,5,'CI','LBTR',0,'C');
			  $this->Cell(60,5,'APELLIDOS Y NOMBRES','LBTR',0,'C');
			  $this->Cell(15,5,'SEXO','LBTR',0,'C');
			  $this->Cell(50,5,'OCUPACION','LBTR',0,'C');
			  
			  	$this->Cell(15,5,'FECHA','LBTR',0,'C');
			  	$this->Cell(22,5,'HABER BASICO','LBTR',0,'C');
			  	$this->Cell(22,5,'HABER BASICO','LBTR',0,'C');
				$this->Cell(17,5,'ENERO','LBTR',0,'C');
				$this->Cell(17,5,'FEBRERO','LBTR',0,'C');
				$this->Cell(17,5,'MARZO','LBTR',0,'C');
				$this->Cell(17,5,'ABRIL','LBTR',0,'C');
				$this->Cell(17,5,'TOTAL','LBTR',0,'C');
				$this->Cell(17,5,'DESCUENTOS','LBTR',0,'C');
				$this->Cell(17,5,'TOTAL','LBTR',0,'C');
				$this->Cell(17,5,'LIQUIDO','LBTR',0,'C');
				$this->Cell(18,5,'','LBTR',1,'C');
				
			  
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
		
		
				/*for ($i=0; $i<count($this->datos);$i++){
										 
					 	  	  $array_datos[$cont][0]=$cont+1;
							  $array_datos[$cont][1]=mb_strcut($this->datos[$i]['desc_funcionario1'],0,40, "UTF-8");//#77
							  $array_datos[$cont][2]=mb_strcut($this->datos[$i]['cargo'],0,30, "UTF-8");//#77
							  $array_datos[$cont][3]=mb_strcut($this->datos[$i]['centro'],0,30, "UTF-8");//#77
							  
							  $a=substr($this->datos[$i]['fecha'],0,4);
							  $m=substr($this->datos[$i]['fecha'],5,2);
							  $d=substr($this->datos[$i]['fecha'],8,2);
							  
							  $array_datos[$cont][4]=$d.'/'.$m.'/'.$a;
							  //#ETR-2806
							 
							  //$array_datos[$cont][5]= $this->datos[$i]['observaciones_finalizacion'];
							  $array_datos[$cont][6]= $this->datos[$i]['valor'];
							 
							  $array_datos[$cont][7]=$this->datos[$i]['mes'];
							  $array_datos[$cont][8]=$this->datos[$i]['tipo'];//#ETR-2804
					
					$cont++;
				}
	
		$this->SetX(10);*/
		
		/***********************************************/
		
		   $code=''; 
			for ($i=0; $i<$cont;$i++){
			  	
				//if($code!=$array_datos[$i][7])	{
					  
					  $this->SetFont('','B',10);
					  $this->Ln(2);
					  $this->Cell(5,5,$i,'',0,'L');
					  //$this->Cell(70,5,$array_datos[$i][7],'',1,'L');
					  
					  //$this->SetFont('','',8);
					  $this->Cell(5,5,$array_datos[$i][0],'',0,'R');
					  $this->Cell(70,5,$array_datos[$i][1],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][2],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][3],'',0,'L');
					  $this->Cell(20,5,$array_datos[$i][4],'',0,'C');
					  $this->Cell(30,5,$array_datos[$i][5],'',0,'L');
					  $this->Cell(20,5,$array_datos[$i][6],'',1,'R');
					 
					 			
				/*}else{
					  $this->Cell(5,5,$array_datos[$i][0],'',0,'R');
					  $this->Cell(70,5,$array_datos[$i][1],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][2],'',0,'L');
					  $this->Cell(55,5,$array_datos[$i][3],'',0,'L');
					  if($this->objParam->getParametro('tipo_reporte')=='personal_ret'){
						  $this->Cell(20,5,$array_datos[$i][4],'',0,'C');
						  $this->Cell(30,5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(20,5,$array_datos[$i][6],'',1,'R');
					  }else{//#ETR-2804
					  	  $this->Cell(25,5,$array_datos[$i][4],'',0,'C');
						  $this->Cell(25,5,$array_datos[$i][6],'',0,'R');
						  $this->Cell(25,5,$array_datos[$i][8],'',1,'L');
						  //$this->Cell(20,5,'','',1,'R');
					  }				
					
					 
			  }*/
				
					
					
				}	
				
		
		
		}
		
		
			
	
	
    
}
?>