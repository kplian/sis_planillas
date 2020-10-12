<?php
// Extend the TCPDF class to create custom MultiRow
/*
 * issue 	empresa		autor	fecha	detalle
 * #62		etr			MZM		08.10.2019	omision de 0 en boleta d epago
 * #71		ETR			MZM		12.11.2019	Refactorizacion de reporte boleta para planillas anuales
 * #80		ETR			MZM		28.11.2019	Ajuste formato numeric
 * #83		ETR			MZM		10.12.2019	Habilitacion de opcion historico de planilla
 * #98		ETR			MZM		04.03.2020	Adecuacion para generacion de reporte consolidado (caso planilla reintegros)
 * #130		ETR			MZM		27.05.2020	Cambio en subtitulo de boleta mensual
 * #149		ETR			MZM		09.07.2020	Gestion en otra linea (titulo)
 * #169, ETR-1317		MZM		08.10.2020	Ajuste de campo para boletas anuales (prima/produccion)
 * */

class RBoletaGenerica extends  ReportePDF { 
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $num_boleta=1;
	
	function Header() {
		

	}
	function Footer() {
		

	}
	function datosHeader ($titulo, $detalle) {
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT;
	}
	function generarReporte() { 
		
		
		$this->setFontSubsetting(false);
		//$this->AddPage();
		
		if($this->datos_titulo['multilinea']=='si'){
			
		
				$x=($this->datos_titulo['cantidad_columnas']/$this->datos_titulo['num_columna_multilinea']*2*4)+15;
				
				$id_fun=$this->datos_detalle[0]['id_funcionario'];
				$logo=0;
				$espacio=0;
				$contador=0;
				$linea=0;
				$detalle_col_mod=array();
				$alineacion='R';
				$this->AddPage();
				$ancho_col= round((($this->ancho_hoja-1)/$this->datos_titulo['num_columna_multilinea']),2);
				$adicion_espacio=0;
				
				$espacio_total_adicion=(($this->datos_titulo['num_columna_multilinea']/2)-1)*5;//para separar_columnas
				$ancho_esperado=(($this->ancho_hoja-1-$espacio_total_adicion)/$this->datos_titulo['num_columna_multilinea'] );
				$a1=($ancho_esperado+5);
				$a2=($ancho_esperado-5);
				$control_fila=0; //echo $a1.'***'.$a2.'***'.$ancho_esperado; exit;
				$control_espacios_extra=($this->datos_titulo['num_columna_multilinea']/2)-1;
				$contador_espacios=0;
				 //echo sizeof($this->datos_detalle); exit;
				for ($i=0; $i< sizeof($this->datos_detalle); $i++ ){
					
					$dimensions=$this->getPageDimensions();
					
					$espacio=0;
					$cadena=$this->datos_detalle[$i]['valor'];
					
					if($this->datos_detalle[$i]['id_funcionario']!=$id_fun){
						
						if ($this->GetY()+$x+$dimensions['bm']> $dimensions['hk']){
						$this->AddPage();
						
					   }
						//cabecera del reporte
						$this->SetFont('','',8);
						//#83
							$dr=substr($this->datos_titulo['fecha_backup'],0,2);
							$mr=substr($this->datos_titulo['fecha_backup'],3,2);
							$ar=substr($this->datos_titulo['fecha_backup'],6);
						if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
							$this->SetX($dimensions['wk']-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10);
							$this->Cell(10, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'L');
						}else{
							$this->Cell(10, 3, '', '', 1, 'L');
						}
						
						
						$fecha_rep = date("d/m/Y");
						$this->SetX($dimensions['wk']-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10);
						$this->Cell(10, 3, "Fecha: ".$fecha_rep, '', 1, 'L');
						
						$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 15, $this->GetY()-15, 30, 15);
						$this->SetFont('','B',15);
					    $this->Cell(0,5,$this->datos_titulo['titulo_reporte'],0,1,'C');
						
						$this->SetFont('','B',10);
						$tipo_bol='Sueldo';
						if(strpos ( $this->datos_titulo['titulo_reporte'] , 'REINTEGRO')> 0 ){
							$tipo_bol='Reintegro';
						}
					
					    //$this->Cell(0,5, $tipo_bol.' del Mes de '.$this->datos_titulo['periodo'].' de '.$this->datos_titulo['gestion'],0,1,'C');
					    //#98 
						if ($this->objParam->getParametro('consolidar')=='si'){
							$tipo_bol=$tipo_bol. ' acumulado a '.$this->datos_titulo['periodo'].' de '.$this->datos_titulo['gestion'];
						}else{ 
							$tipo_bol=$tipo_bol. ' del mes de '.$this->datos_titulo['periodo'].' '.$this->datos_titulo['gestion'];//#130
						}
						
						
					    $this->Cell(0,5, $tipo_bol,0,1,'C');//#98
					    
					    
					    $this->Ln(5);
					    $this->SetFont('','',10);
					  
					   
					    $this->grillaDatosBoleta($detalle_col_mod,$alto=$x,$border=0,$this->datos_titulo['num_columna_multilinea'],3.5,'R',8);
						
						
					    
						
						
						
						
						$this->Ln(5);
					    	
					    $detalle_col_mod=array();
						$control_fila=0;	
					   
					   	$this->Ln(40);
					   
						
						$contador=1;
						
						    array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'           Nombre:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,22);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,mb_strcut($this->datos_detalle[$i]['desc_funcionario2'],0,40, "UTF-8"));
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,80);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Cargo:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,10);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,mb_strcut($this->datos_detalle[$i]['cargo'],0,40, "UTF-8"));
							
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,60);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
											
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Fecha Ingreso:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,22);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['fecha_ingreso']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,55);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
											
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Codigo:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,12);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['codigo']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,55);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Nivel:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,10);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['nivel']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,1); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,10);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							if($cadena>0){//#62
									$cadena=number_format($cadena,2,'.',',');//#80
								}else{
									$cadena='';
								}
							$alineacion='R';
							
								
								array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
								array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
								array_push($detalle_col_mod,$this->datos_detalle[$i]['titulo_reporte_superior'].' '.$this->datos_detalle[$i]['titulo_reporte_inferior']);
								array_push($detalle_col_mod,'B'); 
								array_push($detalle_col_mod,0); 
								array_push($detalle_col_mod,'R');//30.09.2019
								array_push($detalle_col_mod,$a1);
								$control_fila=$control_fila+$a1;
								array_push($detalle_col_mod,$ancho_esperado);
								array_push($detalle_col_mod,$contador_espacios);
								
								
								
								array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
								array_push($detalle_col_mod,0);
								array_push($detalle_col_mod,$cadena);
								array_push($detalle_col_mod,'');
								array_push($detalle_col_mod,$linea);
								array_push($detalle_col_mod,$alineacion); 
								
								array_push($detalle_col_mod,$a2);  
								array_push($detalle_col_mod,$ancho_esperado);
								array_push($detalle_col_mod,$contador_espacios);
								$control_fila=$control_fila+$a2;
						
						
						if ($this->datos_detalle[$i]['espacio_previo']/2!=0){
										$ii=0;
										for ($ii=0; $ii<$this->datos_detalle[$i]['espacio_previo']/2; $ii++){
											$contador_espacios++;
											if($contador_espacios>$control_espacios_extra){
												$contador_espacios=0;
											}
											
										}
										
									}
									
									
										if($control_espacios_extra>$contador_espacios){
										//if($control_fila+5 < $this->ancho_hoja){
											array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
											array_push($detalle_col_mod,0);
											array_push($detalle_col_mod,'');
											array_push($detalle_col_mod,''); 
											array_push($detalle_col_mod,0); 
											array_push($detalle_col_mod,'R');//30.09.2019
											array_push($detalle_col_mod,5); 
											array_push($detalle_col_mod,$ancho_esperado);
											array_push($detalle_col_mod,$contador_espacios);
											$contador_espacios++;
											
										}else{
											$contador_espacios=0;
											
										}
					}else{
						if($contador==0){
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'           Nombre:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,22);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['desc_funcionario2']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,80);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Cargo:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,10);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['cargo']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,60);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
											
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Fecha Ingreso:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,22);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['fecha_ingreso']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,55);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
											
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Codigo:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,12);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['codigo']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,55);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,'Nivel:');
							array_push($detalle_col_mod,'B'); 
							array_push($detalle_col_mod,0); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,10);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
							array_push($detalle_col_mod,$this->datos_detalle[$i]['nivel']);
							array_push($detalle_col_mod,''); 
							array_push($detalle_col_mod,1); 
							array_push($detalle_col_mod,'L');  
							array_push($detalle_col_mod,10);    
							array_push($detalle_col_mod,$ancho_esperado);
							array_push($detalle_col_mod,0);
							
							
							
					    }

 								if($cadena>0){//#62
									$cadena=number_format($cadena,2,'.',',');//#80
								}else{
									$cadena='';
								}



							$alineacion='R';
							
								
								array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
								array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
								array_push($detalle_col_mod,$this->datos_detalle[$i]['titulo_reporte_superior'].' '.$this->datos_detalle[$i]['titulo_reporte_inferior']);
								array_push($detalle_col_mod,'B'); 
								array_push($detalle_col_mod,0); 
								array_push($detalle_col_mod,'R');//30.09.2019
								array_push($detalle_col_mod,$a1);
								$control_fila=$control_fila+$a1;
								array_push($detalle_col_mod,$ancho_esperado);
								array_push($detalle_col_mod,$contador_espacios);
								
								
								
								array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
								array_push($detalle_col_mod,0);
								array_push($detalle_col_mod,$cadena);
								array_push($detalle_col_mod,'');
								array_push($detalle_col_mod,$linea);
								array_push($detalle_col_mod,$alineacion); 
								
								array_push($detalle_col_mod,$a2);  
								array_push($detalle_col_mod,$ancho_esperado);
								array_push($detalle_col_mod,$contador_espacios);
								$control_fila=$control_fila+$a2;
								
								
								if ($this->datos_detalle[$i]['espacio_previo']/2!=0){
										$ii=0;
										for ($ii=0; $ii<$this->datos_detalle[$i]['espacio_previo']/2; $ii++){
											$contador_espacios++;
											if($contador_espacios>$control_espacios_extra){
												$contador_espacios=0;
											}
											
										}
										
									}
									
									
										if($control_espacios_extra>$contador_espacios){
										//if($control_fila+5 < $this->ancho_hoja){
											array_push($detalle_col_mod,$this->datos_detalle[$i]['id_funcionario']);
											array_push($detalle_col_mod,0);
											array_push($detalle_col_mod,'');
											array_push($detalle_col_mod,''); 
											array_push($detalle_col_mod,0); 
											array_push($detalle_col_mod,'R');//30.09.2019
											array_push($detalle_col_mod,5); 
											array_push($detalle_col_mod,$ancho_esperado);
											array_push($detalle_col_mod,$contador_espacios);
											$contador_espacios++;
											
										}else{
											$contador_espacios=0;
											
										}
									
						$contador++;
						
					}
					$id_fun=$this->datos_detalle[$i]['id_funcionario'];
					
					
					
					
				}
						$dimensions=$this->getPageDimensions();
					   if ($this->GetY()+$x+$dimensions['bm']> $dimensions['hk']){
						$this->AddPage();
						
					   }
				 		
				   		$this->SetFont('','',8);
						//#83
						
							$dr=substr($this->datos_titulo['fecha_backup'],0,2);
							$mr=substr($this->datos_titulo['fecha_backup'],3,2);
							$ar=substr($this->datos_titulo['fecha_backup'],6);
						if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
							$this->SetX($dimensions['wk']-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10);
							$this->Cell(10, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'L');
						}else{
							$this->Cell(10, 3, '', '', 1, 'L');
						}
						$fecha_rep = date("d/m/Y");
						$this->SetX($dimensions['wk']-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10);
						$this->Cell(10, 3, "Fecha: ".$fecha_rep, '', 1, 'L');
						
						$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 15, $this->GetY()-15, 30, 15);
						$this->SetFont('','B',15);
					    $this->Cell(0,5,$this->datos_titulo['titulo_reporte'],0,1,'C');
					    $this->SetFont('','B',10);
					   
						
						$tipo_bol='Sueldo';
						if(strpos ( $this->datos_titulo['titulo_reporte'] , 'REINTEGRO')> 0 ){
							$tipo_bol='Reintegro';
						}
					
					    //$this->Cell(0,5, $tipo_bol.' del Mes de '.$this->datos_titulo['periodo'].' de '.$this->datos_titulo['gestion'],0,1,'C');
					    //#98 
						if ($this->objParam->getParametro('consolidar')=='si'){
							$tipo_bol=$tipo_bol. ' acumulado a '.$this->datos_titulo['periodo'].' de '.$this->datos_titulo['gestion'];
						}else{
							$tipo_bol=$tipo_bol. ' del mes de '.$this->datos_titulo['periodo'].' '.$this->datos_titulo['gestion'];//#130
						}
						
						
					    $this->Cell(0,5, $tipo_bol,0,1,'C');//#98
					    
						
						
						
						
					    $this->Ln(5);
					    $this->SetFont('','',10);
					   
					    $this->grillaDatosBoleta($detalle_col_mod,$alto=$x,$border=0,$this->datos_titulo['num_columna_multilinea'],3.5,'R',8); 
						$this->Ln(5);		 
				 	
				   
				   
		}else{
			//#71
			//SI LA PERIODICIDAD ES ANUAL == CON DIBUJO, PERIODO IS NULL
			
			$array_datos;
			$cont=0;
			$es_aguinaldo='no';
			if($this->datos_titulo['id_periodo']==''){ // es anual: prima, desempeño, aguinaldo
				
			$id_fun=0;
			$this->SetLeftMargin(20);
							$this->SetRightMargin(20);
								
						if(strlen(stristr($this->datos_titulo['titulo_reporte'],'aguinaldo'))> 0){
								$es_aguinaldo='si';
							}
						for ($i=0; $i< sizeof($this->datos_detalle); $i++ ){
							
						   if (($i%2) == 0) {
							$this->setFontSubsetting(false);
							
							$this->AddPage();
							$this->SetFont('','B',12);
							$this->Cell(0,5,'','TRL',1,'C');
							$this->Cell(0,5,$this->datos_titulo['titulo_reporte'],'LR',1,'C'); 
							$this->Cell(0,5,' GESTION '.$this->datos_titulo['gestion'],'LR',1,'C');//#149
							$this->Cell(0,8,'','RL',1,'C');
							
							$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 25, $this->GetY()-15, 35, 18);
								
							$this->Cell(0,1,'','RL',1,'C');
							$this->SetFont('','B',8);
							$this->Cell(30,5,'Nombre: ','LB',0,'R');
							$this->SetFont('','',8);
							
							$this->Cell(0,5,$this->datos_detalle[$i]['desc_funcionario2'],'BR',1,'L');//#169 -- #ETR-1317
							
							$this->Ln(10);
							if($es_aguinaldo=='no'){
								$this->Ln(10);
							}
						} else {
							//cabecera del reporte
							
							$this->SetFont('','B',12);
							$this->Cell(0,5,'','TRL',1,'C');
							$this->Cell(0,5,$this->datos_titulo['titulo_reporte'],'LR',1,'C'); 
							$this->Cell(0,5,' GESTION '.$this->datos_titulo['gestion'],'LR',1,'C');//#149
							$this->Cell(0,8,'','RL',1,'C');
							
							$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 25, $this->GetY()-15, 35, 18);
								
							$this->Cell(0,1,'','RL',1,'C');
							$this->SetFont('','B',8);
							$this->Cell(30,5,'Nombre: ','LB',0,'R');
							$this->SetFont('','',8);
							$this->Cell(0,5,$this->datos_detalle[$i]['desc_funcionario2'],'BR',1,'L');//#169-- #ETR-1317
							
							$this->Ln(10);
							
							if($es_aguinaldo=='no'){
								$this->Ln(10);
							}
						}
						
						$this->SetFont('','B',8);
						$this->Cell(30,5,'',0,0,'C');
						if($es_aguinaldo=='si'){
							$this->Cell(30,5,'',0,0,'C');
						}
						$this->Cell(30,5,$this->datos_detalle[$i]['titulo_reporte_superior'].' '. $this->datos_detalle[$i]['titulo_reporte_inferior'],0,0,'R');
							
						$this->SetFont('','',8);
						
						$this->Cell(0,5,' Bs. '.number_format($this->datos_detalle[$i]['valor'],2,'.',','),0,1,'L');//#169-- #ETR-1317
						if($es_aguinaldo=='no'){
							$this->Image(dirname(__FILE__).'/../../lib/imagenes/anual.png', 110, $this->GetY()-15, 40, 20);	
							$this->Ln(20);
							$this->Cell(0,5,'','TRL',1,'L');
							$this->Cell(0,5,'Este monto será incluido al sueldo de '.$this->datos_titulo['periodo'].' para fines de deducción del impuesto RC-IVA.','RL',1,'C');
							$this->Cell(0,5,'','BRL',1,'L');
							$this->Ln(50);
						}else{
							$this->Ln(10);
							$this->Cell(0,1,'','TRL',1,'L');
							$n_gestion=$this->datos_titulo['gestion']+1;
							$this->SetFont('','B',8);
							$this->Cell(0,5,'Feliz Navidad y prospero año '.$n_gestion,'RL',1,'C');
							$this->Cell(0,15,'','RL',1,'L');
							$this->Image(dirname(__FILE__).'/../../lib/imagenes/aguinaldo.png', 45, $this->GetY()-15, 120, 20);
							$this->Cell(0,8,'','BRL',1,'L');
							$this->Ln(50);
						}
							
							
				   
				}
				  
				  
		
				
				
			}else{ 
				//la boleta anterior
				if (($this->num_boleta%2) == 1) {
					$this->setFontSubsetting(false);
					$this->SetLeftMargin(5);
					$this->SetRightMargin(5);
					$this->AddPage();
					//cabecera del reporte
					$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
					$this->setY(15);
					
				} else {
					//cabecera del reporte
					$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 140, 30, 10);
					$this->setY(150);
				}
						
					$this->SetFont('','B',12);
					$this->Cell(0,5,$this->datos_titulo['titulo_reporte'] . ' : '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion'],0,1,'C');
		
					$this->SetFont('','B',10);
					
					$this->Cell(0,5,'No Patronal : '.$this->datos_titulo['nro_patronal'],0,1,'R');
					$this->Cell(0,5,'NIT : '.$this->datos_titulo['nit'],0,1,'R');
					
							
					$this->Ln(2);
						
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
					//var_dump($this->datos_detalle ); exit;
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
			
						if ($data['tipo_columna'] == 'iva') {
							$iva = $data['valor_columna'];
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
					 
					 
					$this->num_boleta++;
				
			}
			
			
				
			}
						
		}	
    
}
?>