<?php
// Extend the TCPDF class to create custom MultiRow
/*
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
 
 */
class RAntiguedadFuncionarioPDF extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	var $etiqueta;
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 5, 8, 30, 12);
		$this->SetFont('','B',15);
		$this->SetY(20);
		
		if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
			$this->Cell(0,5,'ANTIGUEDAD DE LOS EMPLEADOS',0,1,'C');
			$this->etiqueta='Antiguedad';
		}else{
			
			
				$this->Cell(0,5,'CLASIFICACION DEL PERSONAL POR EDADES',0,1,'C');
				$this->etiqueta='Edad';
			
		}
		
		
		$this->SetFont('','B',10);
		$this->Cell(0,5,'Al:'.$this->objParam->getParametro('fecha'),0,1,'C');
		$this->Ln(4);			
		//Titulos de columnas superiores
		$this->SetFont('','B',7);
		$this->Cell(45,3.5,'Centro','LTR',0,'C');
		$this->Cell(20,3.5,'Codigo Emp.','LTR',0,'C');
		$this->Cell(60,3.5,'Nombre Completo','LTR',0,'C');
		if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
			
			$this->Cell(20,3.5,'Fecha','LTR',0,'C');
			$this->Cell(10,3.5,'Antig','LTR',0,'C');
			$this->Cell(30,3.5,'T.Antiguedad','LTR',1,'C');
		}else{
			$this->Cell(30,3.5,'Cargo','LTR',0,'C');
			$this->Cell(20,3.5,'Fecha','LTR',0,'C');
			$this->Cell(10,3.5,'Edad','LTR',1,'C');
		}
		
			$this->Cell(45,3.5,'','LBR',0,'C');
			$this->Cell(20,3.5,'','LBR',0,'C');
			$this->Cell(60,3.5,'','LBR',0,'C');
		
		if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
			$this->Cell(20,3.5,'Ingreso','LBR',0,'C');
			$this->Cell(10,3.5,'Anterior','LBR',0,'C');
			$this->Cell(15,3.5,'Años','LTBR',0,'C');		
			$this->Cell(15,3.5,'Dias','LTBR',1,'C');	
		}else{
			$this->Cell(30,3.5,'','LBR',0,'C');
			$this->Cell(20,3.5,'Nacim','LBR',0,'C');
			$this->Cell(10,3.5,'','LBR',1,'C');
		}	
		
		//$this->Cell(0,5,'Rango de Antiguedad:'.$this->objParam->getParametro('rango'),0,1,'L');
		$this->alto_header =$this->GetY(); 

	}
	function setDatos($datos) {
		$this->datos = $datos;
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		
		$this->SetY($this->alto_header+2); 
		$this->SetFont('','',8);
		$this->SetMargins(15,$this->alto_header+2, 5);
		$array_fem; $contf=1;
		$array_mas; $contm=0; 
		
		
		$rango_ini=$this->objParam->getParametro('rango_ini');
		$rango_fin=$this->objParam->getParametro('rango_fin');
		$contador_rango=$rango_fin;
		$genero=$this->datos[0]['genero'];
		$rango='-1';
		
			
		  	for ($i=0; $i<count($this->datos);$i++){
		    
					 if($this->datos[$i]['rango']!=$rango){
					 	   if($genero!=$this->datos[0]['genero']){
					 	
					 			$this->SetFont('','B',8);
								$this->Cell(65,3.5,'Total '.$this->datos[$i-1]['genero'].':','TB',0,'C');
								$this->Cell(120,3.5,''.$contf,'TB',1,'C');
								$this->Ln(2);
								$contf=0;
								$this->SetFont('','',8);
					 	
					 	    }
								$this->Ln(2);
								$this->SetFont('','B',10);
								$this->Cell(65,3.5,'Rango '.$this->etiqueta.' : '.$this->datos[$i]['rango'],'',1,'L');
								$this->Ln(2);
								$contf=0; 
								
								$this->SetFont('','',7);
								$this->Cell(45,3.5,substr ( $this->datos[$i]['nombre_uo_pre'], 0, 23),'',0,'L');
								$this->Cell(20,3.5,$this->datos[$i]['codigo'],'',0,'R');
								$this->Cell(60,3.5,substr ( $this->datos[$i]['desc_funcionario2'], 0, 30),'',0,'L');
								
								
								if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
									$ff=$this->datos[$i]['fecha_ingreso'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['antiguedad_ant'],'',0,'R');
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad_anos'],'',0,'R');		
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad'],'',1,'R');
								}else{
									$ff=$this->datos[$i]['fecha_nacimiento'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
								
									$this->Cell(30,3.5,substr ($this->datos[$i]['cargo'],0,18),'',0,'L');
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['edad'],'',1,'R');		
								}	
								
								
								$contf++;
								
						}else{
								$this->SetFont('','',8);
								if ($this->datos[$i]['genero']!=$genero){
									
										$this->SetFont('','B',8);
										$this->Ln(2);
										$this->Cell(65,3.5,'Total '.$this->datos[$i-1]['genero'].':','BT',0,'C');
										$this->Cell(120,3.5,''.$contf,'TB',1,'C');
										$this->Ln(2);
										$contf=0;
										
										$this->SetFont('','',8);
										
								}	
								
								
								$this->SetFont('','',7);
								$this->Cell(45,3.5,substr ( $this->datos[$i]['nombre_uo_pre'], 0, 23),'',0,'L');
								$this->Cell(20,3.5,$this->datos[$i]['codigo'],'',0,'R');
								$this->Cell(60,3.5,substr ( $this->datos[$i]['desc_funcionario2'], 0, 30),'',0,'L');
								
								if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad'){
									$ff=$this->datos[$i]['fecha_ingreso'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
									
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['antiguedad_ant'],'',0,'R');
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad_anos'],'',0,'R');		
									$this->Cell(15,3.5,$this->datos[$i]['antiguedad'],'',1,'R');
								}else{
									$ff=$this->datos[$i]['fecha_nacimiento'];
									$aa=substr($ff, 0,4);
									$mm=substr($ff, 5,2);
									$dd=substr($ff, 8,2);
									$this->Cell(30,3.5,substr ($this->datos[$i]['cargo'],0,16),'',0,'L');
									$this->Cell(20,3.5,$dd.'/'.$mm.'/'.$aa,'',0,'C');
									$this->Cell(10,3.5,$this->datos[$i]['edad'],'',1,'R');		
									
								
									
									
								}
								$contf++;
							
						
						}
						$genero=$this->datos[$i]['genero'];
						$rango=$this->datos[$i]['rango'];
				
			}
						$this->SetFont('','B',8);
						$this->Cell(65,3.5,'Total '.$genero.':','TB',0,'C');
						$this->Cell(120,3.5,''.$contf,'TB',1,'C');
						$this->Ln(2);

		
		} 

		
	
		
		
		
			
	
	
    
}
?>