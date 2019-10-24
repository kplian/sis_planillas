<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion
 #66	ETR				15.10.2019			MZM					Adicion de tipo contrato 
*/
class REmpleadoDep extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	
	function Header() {
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		
		$this->Ln(15);	
		$this->SetFont('','B',12);
		//#66
		$nombre_tc=$this->objParam->getParametro('nombre_tipo_contrato');
		if($nombre_tc!=''){
			$nombre_tc=' ('.$nombre_tc.')';
		}
		
		if($this->objParam->getParametro('tipo_reporte')=='dependientes'){	
			$this->Cell(0,5,'NOMINA DE PERSONAL Y DEPENDIENTES'.$nombre_tc,0,1,'C');//#66
		}else{
			$this->Cell(0,5,'GRUPO FAMILIAR DE LOS TRABAJADORES'.$nombre_tc,0,1,'C');//#66
			$this->SetFont('','B',10);
			$this->Cell(0,5,'Clasificación de los hijos según edades',0,1,'C');
		}
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		
		
		$this->SetX(10);
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
		$this->SetMargins(20,20, 5);
		$gerencia='';
		$departamento='';
		$codigo_col='';
		$id_persona=0;
		$cont=0;
		$n=1;
		$val=0;
		$this->SetX(20); 
		
		if($this->objParam->getParametro('tipo_reporte')=='dependientes'){
		
				 for ($i=0; $i<count($this->datos);$i++){
				   
				 	  if($id_persona!=$this->datos[$i]['id_persona']){
				 	      $this->Ln(5); 
						  $this->SetFont('','B',8);
				 	  	  $this->Cell(20,3.5,'Codigo Emp','LT',0,'L');
						  $this->SetFont('','',8);
				 	  	  $this->Cell(30,3.5,$this->datos[$i]['codigo'],'T',0,'L');
						  
						  $this->SetFont('','B',8);
						  $this->Cell(28,3.5,'Nombre Completo','T',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(65,3.5,$this->datos[$i]['nombre_funcionario'],'T',0,'L');
						  
						  $this->SetFont('','B',8);
						  $this->Cell(20,3.5,'Fecha Ingreso','T',0,'L');
						  $this->SetFont('','',8);
									 
						  $this->Cell(17,3.5,substr($this->datos[$i]['fecha_ingreso'],8,2).'/'.substr($this->datos[$i]['fecha_ingreso'],5,2).'/'.substr($this->datos[$i]['fecha_ingreso'],0,4),'TR',1,'L');
				 	  	 
						 
						  $this->SetFont('','B',8);
				 	  	  $this->Cell(20,3.5,'Hist. Clinica','LB',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(50,3.5,$this->datos[$i]['historia_clinica'],'B',0,'L');
						  
						  
						  $this->SetFont('','B',8);
						  $this->Cell(18,3.5,'# Matricula','B',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(55,3.5,$this->datos[$i]['matricula'],'B',0,'L');
						  
						  $this->SetFont('','B',8);
						  $this->Cell(20,3.5,'Fecha Nac.','B',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(17,3.5,substr($this->datos[$i]['fecha_nacimiento'],8,2).'/'.substr($this->datos[$i]['fecha_nacimiento'],5,2).'/'.substr($this->datos[$i]['fecha_nacimiento'],0,4),'BR',1,'L');
				 	  	 
						  
						  $this->Ln(2); 
				 	  	  $this->SetFont('','B',8);
						  $this->Cell(18,3.5,'Tipo Dep','',0,'C');
						  $this->Cell(75,3.5,'Nombre Dependiente','',0,'C');
						  $this->Cell(30,3.5,'Fecha Nacimiento','',0,'C');
				 	  	  $this->Cell(30,3.5,'Hist. Clinica','',0,'C');
						  $this->Cell(30,3.5,'# Matricula','',1,'C');
						  
						  $this->SetFont('','',8);
						  $this->Cell(18,3.5,$this->datos[$i]['relacion'],'',0,'C');
						  $this->Cell(75,3.5,$this->datos[$i]['nombre_dep'],'',0,'L');
						  $this->Cell(30,3.5,substr($this->datos[$i]['fecha_nacimiento_dep'],8,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],5,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],0,4),'',0,'C');
				 	  	  $this->Cell(30,3.5,$this->datos[$i]['historia_clinica_dep'],'',0,'C');
						  $this->Cell(30,3.5,$this->datos[$i]['matricula_dep'],'',1,'C');
						  
						  
				 	  }else{
				 	  	
				 	  	    
				 	  	  $this->SetFont('','',8);
						  $this->Cell(18,3.5,$this->datos[$i]['relacion'],'',0,'C');
						  $this->Cell(75,3.5,$this->datos[$i]['nombre_dep'],'',0,'L');
						  $this->Cell(30,3.5,substr($this->datos[$i]['fecha_nacimiento_dep'],8,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],5,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],0,4),'',0,'C');
				 	  	  $this->Cell(30,3.5,$this->datos[$i]['historia_clinica_dep'],'',0,'C');
						  $this->Cell(30,3.5,$this->datos[$i]['matricula_dep'],'',1,'C');
				 	  	 
				
		
				 	  }
						$id_persona=$this->datos[$i]['id_persona'];
				}
			}else{
				$this->Ln(5);
				$this->SetX(20); 
				$rango='-1';
				$rango_ini=$this->objParam->getParametro('rango_ini');
				$rango_fin=$this->objParam->getParametro('rango_fin');
				for ($i=0; $i<count($this->datos);$i++){
		    
					 if($this->datos[$i]['rango']!=$rango){
					 	$this->Ln(2);
						$this->SetFont('','B',10);
						$this->Cell(180,3.5,'Rango Edad '.$this->datos[$i]['rango'],'LBTR',1,'L');
						$this->Ln(2);
						$this->SetFont('','B',8);
						$this->Cell(15,3.5,'Fecha Nac',0,0,'L');
						$this->Cell(60,3.5,'Nombre Dependiente',0,0,'L');
						$this->Cell(10,3.5,'Edad',0,0,'L');
						$this->Cell(60,3.5,'Nombre del trabajador',0,0,'L');
						$this->Cell(10,3.5,'Sexo',0,0,'L');
						$this->Cell(35,3.5,'Distrito',0,1,'L');
									
						$this->SetFont('','',7);
						$this->Cell(15,3.5,$this->datos[$i]['fecha_nacimiento_dep'],0,0,'L');
						$this->Cell(60,3.5,$this->datos[$i]['nombre_dep'],0,0,'L');
						$this->Cell(10,3.5,$this->datos[$i]['edad_dep'],0,0,'R');
						$this->Cell(60,3.5,$this->datos[$i]['nombre_funcionario'],0,0,'L');
						$this->Cell(10,3.5,$this->datos[$i]['genero'],0,0,'L');
						$this->Cell(35,3.5,$this->datos[$i]['distrito'],0,1,'L');
					 }else{
					 	$this->SetFont('','',7);
						$this->Cell(15,3.5,$this->datos[$i]['fecha_nacimiento_dep'],0,0,'L');
						$this->Cell(60,3.5,$this->datos[$i]['nombre_dep'],0,0,'L');
						$this->Cell(10,3.5,$this->datos[$i]['edad_dep'],0,0,'R');
						$this->Cell(60,3.5,$this->datos[$i]['nombre_funcionario'],0,0,'L');
						$this->Cell(10,3.5,$this->datos[$i]['genero'],0,0,'L');
						$this->Cell(35,3.5,substr($this->datos[$i]['distrito'],0,15),0,1,'L');
					 }
					 $rango=$this->datos[$i]['rango'];
				}
				
			}
					
			
		
		} 

		
    
}
?>