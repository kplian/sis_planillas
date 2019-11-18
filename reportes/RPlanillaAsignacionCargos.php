<?php
// Extend the TCPDF class to create custom MultiRow
/**
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #67	ETR				16.10.2019			MZM		 			Creacion
 #77	ETR				13.11.2019			MZM					Ajustes varios
*/
class RPlanillaAsignacionCargos extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	
	function Header() {
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		$this->SetY(10);
		$this->SetFont('','B',7);
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		
		if($this->objParam->getParametro('tipo_reporte')!='frecuencia_cargos'  && $this->objParam->getParametro('tipo_reporte')!='lista_cargos' && $this->objParam->getParametro('tipo_reporte')!='profesiones'  && $this->objParam->getParametro('tipo_reporte')!='nacimiento_ano' && $this->objParam->getParametro('tipo_reporte')!='nacimiento_mes'){
			$this->Cell($this->ancho_hoja+260, 3, $pagenumtxt, '', 1, 'R');
		}else{
			$this->Cell($this->ancho_hoja+200, 3, $pagenumtxt, '', 1, 'R');
		}
		
		$this->SetFont('','B',15);
		$this->SetY(20);
		$cadena_nomina=$this->objParam->getParametro('nombre_tipo_contrato');
		if($cadena_nomina!=''){
			$cadena_nomina='('.$cadena_nomina.')';
		}
		
		if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){
			$this->Cell(0,5,'DESIGNACIÓN DE CARGOS '.$cadena_nomina,0,1,'C');
		}else{//movimiento_personal
			if($this->objParam->getParametro('tipo_reporte')=='movimiento_personal'){
				$this->Cell(0,5,'MOVIMIENTOS DE PERSONAL '.$cadena_nomina,0,1,'C');
			}else{//lista_cargos
				if($this->objParam->getParametro('tipo_reporte')=='lista_cargos'){
					$this->Cell(0,5,'CARGOS '.$cadena_nomina,0,1,'C');
				}else{//frecuencia_cargos
				    if($this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos'){
						$this->Cell(0,5,'FRECUENCIA DE CARGOS '.$cadena_nomina,0,1,'C');
					}else{//profesiones
						if($this->objParam->getParametro('tipo_reporte')=='directorio_empleados'){
							$this->Cell(0,5,'DIRECTORIO DE EMPLEADOS POR CENTRO DE BENEFICIO Y CARGOS '.$cadena_nomina,0,1,'C');
						}else{
							if($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_mes'){
								$this->Cell(0,5,'FECHAS DE NACIMIENTO',0,1,'C');
								if($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano'){
									$this->Cell(0,5,'NOMINA CLASIFICADA POR AÑO '. $cadena_nomina,0,1,'C');	
								}else{
									$this->Cell(0,5,'NOMINA CLASIFICADA POR MES '. $cadena_nomina,0,1,'C');
								}
								
							}
							else{
								$this->Cell(0,5,'CLASIFICACION DE PERSONAL POR PROFESIONES '.$cadena_nomina,0,1,'C');	
							}
								
						}
						
					}
				}
				
			}
		}
		
		
		if($this->objParam->getParametro('tipo_reporte')!='frecuencia_cargos' &&  $this->objParam->getParametro('tipo_reporte')!='lista_cargos' && $this->objParam->getParametro('tipo_reporte')!='directorio_empleados' ){
			$this->SetFont('','B',10);
			if($this->objParam->getParametro('tipo_reporte')=='profesiones'|| $this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_mes'){
				$this->Cell(0,5,'Correspondiente a : '.$this->datos[0]['periodo_lite'],0,1,'C');
			}else{
				$this->Cell(0,5,'Gestión : '.$this->datos[0]['gestion'],0,1,'C');	
			}
			
		}	
			
			$this->Ln(4);			
			//Titulos de columnas superiores
		$this->SetFont('','B',10);
		$this->SetX(10);
		
		if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){
				$this->Cell(10,5,'Nro','TB',0,'C');
				$this->Cell(18,5,'Codigo ','TB',0,'L');
				$this->Cell(20,5,'Fecha Mov.','TB',0,'L');
				$this->Cell(69,5,'Nombre Completo','TB',0,'C');
				$this->Cell(69,5,'Cargo Anterior','TB',0,'C');
				$this->Cell(69,5,'Cargo Act.','TB',1,'C');
		}else{
		   if($this->objParam->getParametro('tipo_reporte')=='movimiento_personal'){
		   		//movimiento_personal
				$this->Cell(10,5,'Nro','TB',0,'C');
				$this->Cell(15,5,'Cod.','TB',0,'C');
				$this->Cell(18,5,'Fecha','TB',0,'C');
				$this->Cell(60,5,'Nombre Completo','TB',0,'C');
				$this->Cell(55,5,'De','TB',0,'C');
				$this->Cell(55,5,'A','TB',0,'C');
				$this->Cell(50,5,'Cargo Act.','TB',1,'C');
			
		   }else{//frecuencia cargos
		   		if($this->objParam->getParametro('tipo_reporte')=='frecuencia_cargos'){
					$this->Cell(20,5,'Codigo','LRTB',0,'C');
					$this->Cell(100,5,'Descripcion','LRTB',0,'C');
					$this->Cell(25,5,'Hombres','LRTB',0,'C');
					$this->Cell(25,5,'Mujeres','LRTB',0,'C');
					$this->Cell(25,5,'Total','LRTB',1,'C');
				}else{//lista_cargos
					if($this->objParam->getParametro('tipo_reporte')=='lista_cargos'){
				
						$this->Cell(50,5,'Codigo','LRTB',0,'C');
						$this->Cell(145,5,'Descripcion','LRTB',1,'C');
					}else{//profesiones
						if($this->objParam->getParametro('tipo_reporte')=='directorio_empleados' ){
							$this->SetFont('','B',8);
							$this->Cell(18,5,'Cod. Empl','LRTB',0,'C');
							$this->Cell(60,5,'Nombre','LRTB',0,'C');
							$this->Cell(60,5,'Cargo','LRTB',0,'C');
							$this->Cell(18,5,'Telf.Dom','LRTB',0,'C');
							$this->Cell(18,5,'Celular','LRTB',0,'C');
							$this->Cell(30,5,'Correo','LRTB',0,'C');
							$this->Cell(60,5,'Direccion','LRTB',1,'C');
							
						}else{
							if($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_mes'){
								$this->SetFont('','B',8);
								$this->Cell(15,5,'Codigo','T',0,'C');
								$this->Cell(60,5,'Nombre','T',0,'C');
								$this->Cell(26,5,'Fecha Nacimiento ','T',0,'C');
								$this->Cell(50,5,'Cargo','T',0,'C');
								$this->Cell(50,5,'Centro de Responsabilidad','T',1,'C');
								$this->SetX($this->GetX()-5);
								$this->Cell(15,5,'','B',0,'C');
								$this->Cell(60,5,'','B',0,'C');
								
								if($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano'){
									$this->Cell(10,5,'Año ','B',0,'C');
									$this->Cell(8,5,'Mes ','B',0,'C');
									$this->Cell(8,5,'Dia ','B',0,'C');
								}else{
									
									$this->Cell(13,5,'Mes ','B',0,'C');
									$this->Cell(13,5,'Dia ','B',0,'C');
								}
								
								$this->Cell(50,5,'','B',0,'C');
								$this->Cell(50,5,'','B',1,'C');
							
							}
						}
					}
				}
		   }
		
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
		$this->SetY($this->alto_header); 
		$this->SetFont('','',8);
		$this->SetMargins(10,$this->alto_header, 5);
		
		$cont=0;
		
		if($this->objParam->getParametro('tipo_reporte')!='frecuencia_cargos' &&  $this->objParam->getParametro('tipo_reporte')!='lista_cargos' &&  $this->objParam->getParametro('tipo_reporte')!='profesiones' &&  $this->objParam->getParametro('tipo_reporte')!='directorio_empleados' &&  $this->objParam->getParametro('tipo_reporte')!='nacimiento_ano' &&  $this->objParam->getParametro('tipo_reporte')!='nacimiento_mes'){
			for ($i=0; $i<count($this->datos);$i++){
			   if($this->datos[$i]['nuevo_cargo']!='' && $this->datos[$i]['cargo']!=$this->datos[$i]['nuevo_cargo']){
			   	  $cont++; 	  
				  $a=substr($this->datos[$i]['fecha_finalizacion'],0,4);
				  $m=substr($this->datos[$i]['fecha_finalizacion'],5,2);
				  $d=substr($this->datos[$i]['fecha_finalizacion'],8,2);
				  if($cont ==1){
				  	//$this->Cell(5,4,'','',0,'R');
				  	$this->SetX($this->GetX()-5);
				  }
				  
				  if($this->objParam->getParametro('tipo_reporte')=='asignacion_cargos'){
				  
					    $this->Cell(10,5,$cont,'',0,'R');
					    $this->Cell(18,5,$this->datos[$i]['codigo'],'',0,'C');
					    $this->Cell(20,5,$d.'/'.$m.'/'.$a,0,'C');
					    $this->Cell(69,5,mb_strcut($this->datos[$i]['desc_funcionario2'],0,38, "UTF-8"),'',0,'L');
					    $this->Cell(69,5,mb_strcut($this->datos[$i]['cargo'],0,38, "UTF-8"),'',0,'L');
					    $this->Cell(69,5,mb_strcut($this->datos[$i]['nuevo_cargo'],0,39, "UTF-8"),'',1,'L');
				  }else{ 
					  	$this->Cell(10,5,$cont,'',0,'R');
						$this->Cell(15,5,$this->datos[$i]['codigo'],'',0,'C');
						$this->Cell(18,5,$d.'/'.$m.'/'.$a,'',0,'C');
						$this->Cell(60,5,mb_strcut($this->datos[$i]['desc_funcionario2'],0,32, "UTF-8"),'',0,'L');
						$this->Cell(55,5,mb_strcut($this->datos[$i]['unidad'],0,30, "UTF-8"),'',0,'L');
						$this->Cell(55,5,mb_strcut($this->datos[$i]['nueva_unidad'],0,30, "UTF-8"),'',0,'L');
						$this->Cell(55,5,mb_strcut($this->datos[$i]['nuevo_cargo'], 0, 27, "UTF-8"),'',1,'L');
					
					
				  }
			   }
				  
				  
			}
		}else{
			
			if( $this->objParam->getParametro('tipo_reporte')=='lista_cargos'){
				for ($i=0; $i<count($this->datos);$i++){
					$cont++; 
					if($cont ==1){
					  	//$this->Cell(5,4,'','',0,'R');
					  	$this->SetX($this->GetX()-5);
					  }	  
					
							$this->Cell(50,5,$this->datos[$i]['codigo'],'LRTB',0,'C');
							$this->Cell(145,5,mb_strcut($this->datos[$i]['nombre'], 0, 80, "UTF-8"),'LRTB',1,'L');
							
						
				}
			}else{
				
				if( $this->objParam->getParametro('tipo_reporte')=='profesiones'){
					$m_cargo='';$cont_cargo=0;
					for ($i=0; $i<count($this->datos);$i++){
					   
						
						if($m_cargo!=$this->datos[$i]['profesion']){
							
							if($i !=0){
								$this->Cell(180,5,'Total','T',0,'R');
								$this->Cell(15,5,$cont_cargo,'T',1,'R');
							}
							$this->SetFont('','B',8);
							$this->Ln(4);
							$this->Cell(50,5,$this->datos[$i]['profesion'],'LRTB',1,'C');
							$this->Ln(2);
							$this->Cell(50,5,'Cod. Empl.','B',0,'C');
							$this->Cell(90,5,'Nombre','B',0,'L');
							$this->Cell(55,5,'Profesion','B',1,'C');
							$this->Ln(2);
							$cont_cargo=0;
						}
						$m_cargo=$this->datos[$i]['profesion'];
						$cont_cargo++;
						if($i ==0){
					   		$this->SetX($this->GetX()-5);
					  	}
						$this->SetFont('','',8);	
						$this->Cell(50,5,$this->datos[$i]['codigo'],'',0,'C');
						$this->Cell(90,5,mb_strcut($this->datos[$i]['desc_funcionario2'], 0, 80, "UTF-8"),'',0,'L');
						$this->Cell(55,5,$this->datos[$i]['profesion'],'',1,'L');
						
					}
					
					$this->Cell(180,5,'Total','T',0,'R');
					$this->Cell(15,5,$cont_cargo,'T',1,'R');
					
					
					
					
					
					
				}else{
					
					if( $this->objParam->getParametro('tipo_reporte')=='directorio_empleados'){
						$centro_uo='';
						
						for ($i=0; $i<count($this->datos);$i++){
							if($i ==0){
					   		$this->SetX($this->GetX()-5);
					  	}
							if($centro_uo!=$this->datos[$i]['nombre_uo_centro']){
							
								$this->SetFont('','B',8);
								$this->Cell(50,5,$this->datos[$i]['nombre_uo_centro'],'',1,'L');
								$this->Ln(2);
								
							}
							$this->SetFont('','',8);
							$centro_uo=$this->datos[$i]['nombre_uo_centro'];
							$this->Cell(18,5,$this->datos[$i]['codigo_funcionario'],'',0,'C');
							$this->Cell(60,5,mb_strcut($this->datos[$i]['desc_funcionario2'], 0, 35, "UTF-8"),'',0,'L');
							$this->Cell(60,5,mb_strcut($this->datos[$i]['nombre_cargo'], 0, 35, "UTF-8"),'',0,'L');
							$this->Cell(18,5,$this->datos[$i]['telefono1'],'',0,'R');
							$this->Cell(18,5,$this->datos[$i]['celular_personal'],'',0,'R');
							$this->Cell(30,5,mb_strcut($this->datos[$i]['correo_personal'], 0, 18, "UTF-8"),'',0,'L');
							$this->Cell(60,5,mb_strcut($this->datos[$i]['direccion'], 0, 35, "UTF-8"),'',1,'L');
						}
						
					}else{
						
						if( $this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' || $this->objParam->getParametro('tipo_reporte')=='nacimiento_mes'){
							$gestion_nac='';
							for ($i=0; $i<count($this->datos);$i++){
								if($i ==0){
						   			$this->SetX($this->GetX()-5);
						  		}
								if ($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' ){
									if($gestion_nac!=$this->datos[$i]['ano']){
									
										$this->SetFont('','B',8);
										$this->Cell(75,5,$this->datos[$i]['ano'],'',1,'C');
										$this->Ln(2);
										
									}
								}else{
									if($gestion_nac!=$this->datos[$i]['mes']){
									
										$this->SetFont('','B',8);
										$this->Cell(75,5,$this->datos[$i]['mes_lite'],'',1,'C');
										$this->Ln(2);
										
									}
								}
								$this->SetFont('','',8);
								if ($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' ){
									$gestion_nac=$this->datos[$i]['ano'];
								}else{
									$gestion_nac=$this->datos[$i]['mes'];
								}
								$this->Cell(15,5,$this->datos[$i]['codigo_funcionario'],'',0,'C');
								$this->Cell(60,5,mb_strcut($this->datos[$i]['desc_funcionario2'], 0, 35, "UTF-8"),'',0,'L');
								if ($this->objParam->getParametro('tipo_reporte')=='nacimiento_ano' ){
									$this->Cell(10,5,$this->datos[$i]['ano'],'',0,'R');
									$this->Cell(8,5,$this->datos[$i]['mes'],'',0,'R');
									$this->Cell(8,5,$this->datos[$i]['dia'],'',0,'R');
								}else{
									
									$this->Cell(13,5,$this->datos[$i]['mes'],'',0,'R');
									$this->Cell(13,5,$this->datos[$i]['dia'],'',0,'R');
								}
								$this->Cell(50,5,mb_strcut($this->datos[$i]['nombre_cargo'], 0, 28, "UTF-8"),'',0,'L');
								$this->Cell(50,5,mb_strcut($this->datos[$i]['nombre_uo_centro'], 0, 26, "UTF-8"),'',1,'L');
								
							}
							
						}
					else{
							$tot_fem=0;
							$tot_mas=0;
							for ($i=0; $i<count($this->datos);$i++){
								$cont++; 
								if($cont ==1){
								  	//$this->Cell(5,4,'','',0,'R');
								  	$this->SetX($this->GetX()-5);
								  }	  
								
										$this->Cell(20,5,$this->datos[$i]['codigo'],'LRTB',0,'C');
										$this->Cell(100,5,mb_strcut($this->datos[$i]['nombre'], 0, 50, "UTF-8"),'LRTB',0,'L');
										//#77
										if($this->datos[$i]['total_masculino']>0){
											$this->Cell(25,5,$this->datos[$i]['total_masculino'],'LRTB',0,'C');
										}else{
											$this->Cell(25,5,'','LRTB',0,'C');
										}
										
										if($this->datos[$i]['total_femenino']>0){
											$this->Cell(25,5,$this->datos[$i]['total_femenino'],'LRTB',0,'C');
										}else{
											$this->Cell(25,5,'','LRTB',0,'C');
										}
										$this->Cell(25,5,$this->datos[$i]['total_femenino']+$this->datos[$i]['total_masculino'],'LRTB',1,'C');
										
									$tot_fem=$tot_fem+$this->datos[$i]['total_femenino'];
									$tot_mas=$tot_mas+$this->datos[$i]['total_masculino'];
							}
							$this->Cell(20,5,$cont,'',0,'C');
							$this->Cell(100,5,'Totales','',0,'R');
							$this->Cell(25,5,$tot_mas,'',0,'C');
							$this->Cell(25,5,$tot_fem,'',0,'C');
							$this->Cell(25,5,$tot_fem+$tot_mas,'',1,'C');
						}
						
						
					}
					
					
					
				}
				
				
				
			}
			
			
			
			
		}			
		
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