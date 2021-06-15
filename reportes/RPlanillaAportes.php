<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
  #41	ETR				16.09.2019			MZM					OMISION DE SALTO DE PAGINA POR TIPO DE APORTANTE: MENOR 65, MAYOR 65, JUB55, JUB65
 *#44	ETR				18.09.2019			MZM					Adicion de totales para columnas numericas
 *#45	ETR				19.09.2019			MZM					Adicion de incap en dias_cotizable, cambio de var1, var2, var3
  #45	ETR				20.09.2019			MZM					Reposicion de calculo para valores 13000, 25000 y 35000
  #80	ETR				27.11.2019			MZM					ajuste formato numeric
  #86	ETR				20.12.2019			MZM					HAbilitacion para funcionar con reporte de reintegros
  #83 	ETR				03.01.2020			MZM					Adicion de fecha backup
  #123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019)
  
  #141	ETR				18.06.2020			MZM-KPLIAN			Ajuste a titulo de reporte
  *#ETR-4190				08.06.2021			MZM-KPLIAN			Ajuste a titulo para afps en planilla de reintegros 
  *#ETR-4240				10.06.2021			mzm					Adecuacion a reporte fondo solidario formato xls para planilla de reintegros
 * #ETR-4272			15.06.2021				MZM				Control de totales por habilitacion de reporte para planilla de reintegros mensual, y no afecte a sueldos en aporte_afp y fondo_solidario
 */
class RPlanillaAportes extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	
	function Header() {
		if (count($this->datos)>0){
			
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		
		//#83
		$this->SetFont('','B',7);
		$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
		$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
		$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
		if($this->objParam->getParametro('fecha_backup')!=''){
			$this->Cell(227, 3, '', '', 0, 'R');
			$this->Cell(10, 3, "[Backup: ", '', 0, 'L');
			$this->Cell(3, 3, '', '', 0, 'L');
			//$this->SetFont('','',7);
			$this->Cell(10, 3, $dr.'/'.$mr.'/'.$ar.']', '', 1, 'L');
		}else{
			$this->Cell(0, 3, '', '', 1, 'R');
		}
		
		
		
		$this->SetFont('','B',12);
		$this->SetY(20);
		
		if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
			if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				$this->Cell(0,5,'APORTES AL SISTEMA INTEGRAL DE PENSIONES',0,1,'C');
			}else{
				$this->Cell(0,5,'PAGO DE CONTRIBUCIONES FONDO SOLIDARIO',0,1,'C'); //#141
				//$this->Cell(0,5,'FONDO SOLIDARIO',0,1,'C');
			}
		}else{//reintegros
			if($this->objParam->getParametro('tipo_reporte')!='aporte_afp'){
			  if ($this->objParam->getParametro('personal_activo')=='activo'){
			  	$this->Cell(0,5,'APORTES AL FONDO SOLIDARIO POR PAGO RETROACTIVO DE SALARIOS - PERSONAL ACTIVO',0,1,'C');
			  }elseif($this->objParam->getParametro('personal_activo')=='retirado'){
			  	$this->Cell(0,5,'APORTES AL FONDO SOLIDARIO POR PAGO RETROACTIVO DE SALARIOS - PERSONAL RETIRADO ',0,1,'C');
			  }else{
			  	$this->Cell(0,5,'APORTES AL FONDO SOLIDARIO POR PAGO RETROACTIVO DE SALARIOS ',0,1,'C');
			  } 
			}else{
				if ($this->objParam->getParametro('personal_activo')=='activo'){
					$this->Cell(0,5,'APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS - PERSONAL ACTIVO',0,1,'C');
				}elseif($this->objParam->getParametro('personal_activo')=='retirado'){
					$this->Cell(0,5,'APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS - PERSONAL RETIRADO',0,1,'C');
				}else{
					$this->Cell(0,5,'APORTES AL SISTEMA INTEGRAL DE PENSIONES POR PAGO RETROACTIVO DE SALARIOS',0,1,'C');
				}
			}
		}
		
		
		$this->SetFont('','B',10);
		
		if ($this->objParam->getParametro('consolidar')=='si'){//#98
							
				$this->Cell(0,5,'Acumulado de Enero a ' . str_replace ('de ','',$this->datos[0]['periodo']),0,1,'C'); //#141
		}else{
				$this->Cell(0,5,'Correspondiente al Periodo : '. str_replace ('de ','',$this->datos[0]['periodo']),0,1,'C');//#141
		}
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$nombre_afp=$this->datos[0]['nombre_afp'];
		$this->Cell(0,5,''.$nombre_afp,0,1,'R');
	
		$this->SetFont('','B',6);
		$this->SetX(5);
		
			  $this->Cell(50,5,'Identificacion','LTR',0,'C');
			  
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
			  	$this->Cell(79,5,'Nombre del Empleado','LTR',0,'C');
			  }else{
			  	$this->Cell(100,5,'Nombre del Empleado','LTR',0,'C');
			  }
			
			if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
			  $this->Cell(21,5,'Departamento','LTR',0,'C');//#ETR-4240
				$subtit='Tot. Ganado';
		    }else{
		    	
			  	if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
					 $this->Cell(21,5,'Departamento','LTR',0,'C');//#ETR-4240
				}
			  
				
				
		    	$subtit='Tot. Solidario';
		    }
		    
			  $this->Cell(21,5,'Novedad','LTR',0,'C');
			  $this->Cell(8,5,'Dias','LTR',0,'C');
			  $this->Cell(15,5,$subtit,'LTR',0,'C');
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(15,5,'Tot.Ganado','LTR',0,'C');
				  $this->Cell(15,5,'Tot','LTR',0,'C');
				  $this->Cell(15,5,'Tot','LTR',0,'C');
				  $this->Cell(16,5,'Tot','LTR',0,'C');
				  $this->Cell(16,5,'Tot.Ganado','LTR',1,'C');
			}else{
				  $this->Cell(17,5,$subtit,'LTR',0,'C');
				  $this->Cell(17,5,$subtit,'LTR',0,'C');
				  
				  
				  if($this->objParam->getParametro('codigo_planilla')=='PLANRE'){
				  	  $this->Cell(17,5,$subtit,'LTR',0,'C');
				  	  $this->Cell(15,5,$subtit,'LTR',0,'C');
					  $this->Cell(15,5,$subtit,'LTR',0,'C');
					  $this->Cell(15,5,$subtit,'LTR',0,'C');
					  $this->Cell(15,5,$subtit,'LTR',0,'C');
					  $this->Cell(10,5,'Aporte','LTR',0,'C');
					  $this->Cell(10,5,'Aporte','LTR',0,'C');
					  $this->Cell(10,5,'Aporte','LTR',0,'C');
				  	  $this->Cell(10,5,'Total','LTR',1,'C');
				  
				  }else{
				  	 $this->Cell(17,5,$subtit,'LTR',1,'C');
				  }  
			}
		//titulo inferior
		
		
		$this->SetX(5);
		
			  $this->Cell(5,5,'N','LTR',0,'C');
			  $this->Cell(7,5,'Tipo','LTR',0,'C');
			  $this->Cell(16,5,'Numero','LTR',0,'C');
			  $this->Cell(7,5,'Ext','LTR',0,'C');
			  $this->Cell(15,5,'NUA','LTR',0,'C');
			  //---------
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(22,5,'Apellido Paterno','LTR',0,'C');
				  $this->Cell(21,5,'Apellido Materno','LTR',0,'C');
				  $this->Cell(17,5,'Primer Nombre','LTR',0,'C');
				  $this->Cell(19,5,'Segundo Nombre','LTR',0,'C');
			  }else{
			  	  $this->Cell(27,5,'Apellido Paterno','LTR',0,'C');
				  $this->Cell(27,5,'Apellido Materno','LTR',0,'C');
				  $this->Cell(22,5,'Primer Nombre','LTR',0,'C');
				  $this->Cell(24,5,'Segundo Nombre','LTR',0,'C');
			  }
			  //---------
			  if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){//#ETR-4240
			  $this->Cell(21,5,'','LTR',0,'C');}
			  else{
			  	if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
							$this->Cell(21,5,'','LTR',0,'C');
				}
			  }
			  //----
			  $this->Cell(11,5,'Novedad','LTR',0,'C');
			  $this->Cell(10,5,'Fecha','LTR',0,'C');
			  //-------
			  $this->Cell(8,5,'Cot','LTR',0,'C');
			  //-----
			  
			   if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(15,5,'Cot Dep<65','LTR',0,'C');
				  //----
				  $this->Cell(15,5,'Cot Dep>65','LTR',0,'C');
				  //---
				  $this->Cell(15,5,'Jubilado<65','LTR',0,'C');
				  $this->Cell(15,5,'Jubilado>65','LTR',0,'C');
				  
				  $this->Cell(16,5,'FV','LTR',0,'C');
				  $this->Cell(16,5,'FS','LTR',1,'C');
			  }else{
			  	if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
			  	  $this->Cell(15,5,'Solidario','LTR',0,'C');
			  	  $this->Cell(17,5,'Sol(13000 Bs)','LTR',0,'C');
				  $this->Cell(17,5,'Sol(25000 Bs)','LTR',0,'C');
				  $this->Cell(17,5,'Sol(35000 Bs)','LTR',1,'C');
				}else{
				  $this->Cell(15,5,'SIN','LTR',0,'C');
			  	  $this->Cell(17,5,'Sin Incremen','LTR',0,'C');
				  $this->Cell(17,5,'Sin Incremen','LTR',0,'C');
				  $this->Cell(17,5,'Sin Incremen','LTR',0,'C');
				  $this->Cell(15,5,'CON','LTR',0,'C');
				  $this->Cell(15,5,'Con Incremen','LTR',0,'C');
				  $this->Cell(15,5,'Con Incremen','LTR',0,'C');
				  $this->Cell(15,5,'Con Incremen','LTR',0,'C');
				  $this->Cell(10,5,'Solidario','LTR',0,'C');
				  $this->Cell(10,5,'Solidario','LTR',0,'C');
				  $this->Cell(10,5,'Solidario','LTR',0,'C');
			  	  $this->Cell(10,5,'Aporte','LTR',1,'C');
				  
				}
			  }
			  
		$this->SetX(5);
		
			  $this->Cell(5,5,'','LBR',0,'C');
			  $this->Cell(7,5,'','LBR',0,'C');
			  $this->Cell(16,5,'','LBR',0,'C');
			  $this->Cell(7,5,'','LBR',0,'C');
			  $this->Cell(15,5,'','LBR',0,'C');
			  //---------
			   if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(22,5,' ','LBR',0,'C');
				  $this->Cell(21,5,' ','LBR',0,'C');
				  $this->Cell(17,5,' ','LBR',0,'C');
				  $this->Cell(19,5,' ','LBR',0,'C');
			  }else{
			  	  $this->Cell(27,5,'','LBR',0,'C');
				  $this->Cell(27,5,'','LBR',0,'C');
				  $this->Cell(22,5,'','LBR',0,'C');
				  $this->Cell(24,5,'','LBR',0,'C');
			  }
			  //---------
			  if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){//#ETR-4240
			  $this->Cell(21,5,'','LBR',0,'C');}
			  else{
			  	if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
							$this->Cell(21,5,'','LBR',0,'C');
				}
			  }
			  //----
			  $this->Cell(11,5,'I/R/L/S','LBR',0,'C');
			  $this->Cell(10,5,'Novedad','LBR',0,'C');
			  //-------
			  $this->Cell(8,5,'','LBR',0,'C');
			  //-----
			  if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
			  	$this->Cell(15,5,'','LBR',0,'C');
			  }else{
			  	$this->Cell(15,5,'Incremento','LBR',0,'C');
			  }
			  //----
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(15,5,'','LBR',0,'C');
				  //---
				  $this->Cell(15,5,'','LBR',0,'C');
				  $this->Cell(15,5,'','LBR',0,'C');
				  
				  $this->Cell(16,5,'','LBR',0,'C');
				  $this->Cell(16,5,'','LBR',1,'C');
			}else{
				if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
				  $this->Cell(17,5,'','LBR',0,'C');
				  $this->Cell(17,5,'','LBR',0,'C');
				  $this->Cell(17,5,'','LBR',1,'C');
				}else{
				  $this->Cell(17,5,'(13000 Bs.)','LBR',0,'C');
				  $this->Cell(17,5,'(25000 Bs.)','LBR',0,'C');
				  $this->Cell(17,5,'(35000 Bs.)','LBR',0,'C');
				  $this->Cell(15,5,'Incremento','LBR',0,'C');
				  $this->Cell(15,5,'(13000 Bs.)','LBR',0,'C');
				  $this->Cell(15,5,'(25000 Bs.)','LBR',0,'C');
				  $this->Cell(15,5,'(35000 Bs.)','LBR',0,'C');
				  $this->Cell(10,5,'1%','LBR',0,'C');
				  $this->Cell(10,5,'5%','LBR',0,'C');
				  $this->Cell(10,5,'10%','LBR',0,'C');
				  $this->Cell(10,5,'Solid','LBR',1,'C');
				}
			}
		
	
		$this->alto_header =$this->GetY(); 
		}else{//#123
			$this->SetFont('','B',12);
			$this->Cell(0,5,'SIN DATOS PARA MOSTRAR','',1,'C');//*****
		}
}
	function setDatos($datos) {
		$this->datos = $datos;
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$array_datos;
		$this->SetY($this->alto_header+2); 
		$this->SetFont('','',7);
		$this->SetMargins(5,$this->alto_header+2, 5);
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
		$tipo_jubilado=$this->datos[0]['tipo_jubilado'];
		
		
				for ($i=0; $i<count($this->datos);$i++){
					
					 
						$novedad='';
						$fecha_novedad='';
						$val=0;
							  $n=1;
					 	  	  $array_datos[$cont][0]=$cont+1;
							  $array_datos[$cont][1]=$this->datos[$i]['ci'];
							  $array_datos[$cont][2]=$this->datos[$i]['num_ci'];
							  $array_datos[$cont][3]=$this->datos[$i]['expedicion'];
							  $array_datos[$cont][4]=$this->datos[$i]['nro_afp'];
							  $array_datos[$cont][5]= $this->datos[$i]['apellido_paterno'];
							  $array_datos[$cont][6]= $this->datos[$i]['apellido_materno'];
							  $array_datos[$cont][7]=$this->datos[$i]['primer_nombre'];
							  $array_datos[$cont][8]=$this->datos[$i]['segundo_nombre'];
							  $array_datos[$cont][9]=$this->datos[$i]['departamento'];
							  if($this->datos[$i]['fecha_ingreso']!=''){
							  	  $novedad='I';
								  if($this->datos[$i]['dias_incap']>0){//#45
								  	$novedad='I/S';
								  }
								  
								  $aa=substr($this->datos[$i]['fecha_ingreso'], 0,4);
							  	  $mm=substr($this->datos[$i]['fecha_ingreso'], 5,2);
							      $dd=substr($this->datos[$i]['fecha_ingreso'], 8,2);
								  $fecha_novedad=$dd.'/'.$mm.'/'.$aa;//#45
								  
							  }
							  if($this->datos[$i]['fecha_finalizacion']!=''){
							  	  $novedad='R';
								  if($this->datos[$i]['dias_incap']>0){//#45
								  	$novedad='R/S';
								  }
								  
								  $aa=substr($this->datos[$i]['fecha_finalizacion'], 0,4);
							  	  $mm=substr($this->datos[$i]['fecha_finalizacion'], 5,2);
							      $dd=substr($this->datos[$i]['fecha_finalizacion'], 8,2);
								  $fecha_novedad=$dd.'/'.$mm.'/'.$aa;//#45
								  
							  }
							  
							   if($this->datos[$i]['fecha_ingreso']==''){//#45
								   	if($this->datos[$i]['dias_incap']>0){
									  	$novedad='S';
									}
							   }
							  $dias=$this->datos[$i]['dias'];
							  $array_datos[$cont][10]=$novedad;
							  $array_datos[$cont][11]=$fecha_novedad;
							  $array_datos[$cont][12]=$dias;
							  
							   if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
								  if($this->datos[$i]['tipo_jubilado']=='no'){
								  	
								  		$array_datos[$cont][13]=round($this->datos[$i]['valor'],2);	
								  	
								  	
								  }else{
								  	 if($this->datos[$i]['tipo_jubilado']=='mayor_65'){
									  	 	
												$array_datos[$cont][15]=round($this->datos[$i]['valor'],2);
											
								  		}else{
								  			if ($this->datos[$i]['tipo_jubilado']=='jubilado_55' ){
								  					$array_datos[$cont][16]=round($this->datos[$i]['valor'],2);
											
								  			}else{//jubilado_65
								  					$array_datos[$cont][17]=round($this->datos[$i]['valor'],2);
											
								  			}
								  		}
								  }
							  }else{//#45
							  	$array_datos[$cont][13]=round($this->datos[$i]['valor'],2);
							  	
							  	if($this->datos[$i]['valor']>13000){//#45
							  		     $array_datos[$cont][15]=round($this->datos[$i]['valor']-13000,2);
							  	
							  	}else{
							  		
										$array_datos[$cont][15]=0.00;
									
									
							  		
							  		
							  	}
							  	
							  
							  	if($this->datos[$i]['valor']>25000){//#45
							  		$array_datos[$cont][16]=round($this->datos[$i]['valor']-25000,2);
							  	
							  	}else{
							  		$array_datos[$cont][16]=0.00;
							  	
							  	}
							  	
							  	if($this->datos[$i]['valor']>35000){//#45
							  		$array_datos[$cont][17]=round($this->datos[$i]['valor']-35000,2);
							  		
							  	
							  	}else{
							  		$array_datos[$cont][17]=0.00;
							  	
							  	}
							  	
							  	
							  	
							  }  
							 $array_datos[$cont][14]=$this->datos[$i]['tipo_jubilado'];
						if($this->objParam->getParametro('tipo_reporte')=='aporte_afp' && $this->objParam->getParametro('codigo_planilla')=='PLANRE'){
							  //#86
							  if($this->datos[$i]['tipo_jubilado']=='no'){
							  	$array_datos[$cont][18]=$this->datos[$i]['ncotiz'];
							  }
							  
							  if($this->datos[$i]['tipo_jubilado']=='mayor_65'){
							  	$array_datos[$cont][19]=$this->datos[$i]['ncotiz'];
							  }
							  
							  if($this->datos[$i]['tipo_jubilado']=='jubilado_55'){
							  	$array_datos[$cont][20]=$this->datos[$i]['ncotiz'];
							  }
							  if($this->datos[$i]['tipo_jubilado']=='jubilado_65'){
							  	$array_datos[$cont][21]=$this->datos[$i]['ncotiz'];
							  }
							  
						}else{ //echo '---'.$this->datos[$i]['ncotiz'].'----'.$this->datos[$i]['nvar1']; exit;
							 $array_datos[$cont][18]=$this->datos[$i]['ncotiz'];
							 $array_datos[$cont][19]=$this->datos[$i]['nvar1'];
							 $array_datos[$cont][20]=$this->datos[$i]['nvar2'];
							 $array_datos[$cont][21]=$this->datos[$i]['nvar3'];
						}
							
					if(($this->objParam->getParametro('codigo_planilla')=='PLASUE' )){
						$cont++;
					}else{
						if($this->objParam->getParametro('tipo_reporte')!='aporte_afp'){
						if(($this->datos[$i]['nvar1']+$this->datos[$i]['nvar2']+$this->datos[$i]['nvar3']) >0){
							$cont++;
						}
						}else{
							$cont++;
						}
					}
					
					//$cont++;
				}


			
		$this->SetX(5);
		
		/***********************************************/
		$tot13=0;
		$tot15=0;
		$tot16=0;
		$tot17=0;
		$tot18=0;
		$tot19=0;
		
		$totncotiz=0;
		$totnvar1=0;
		$totnvar2=0;
		$totnvar3=0;
		$nvar1=0;
		$nvar2=0;
		$nvar3=0;
		$tot1n=0;
		$tot5n=0;
		$tot10n=0;
		
		   $var_planre=0; 
		   $code=$array_datos[0][14]; 
		   
			for ($i=0; $i<$cont;$i++){
				
				if($this->objParam->getParametro('tipo_reporte')!='aporte_afp' && $this->objParam->getParametro('codigo_planilla')=='PLANRE'){
					$var_planre=$array_datos[$i][19]+$array_datos[$i][20]+$array_datos[$i][21];
					//$var_planre=1;
				}else{
					$var_planre=1;
				}
				    if(($this->objParam->getParametro('codigo_planilla')=='PLANRE' && $var_planre>0 ) || $this->objParam->getParametro('codigo_planilla')=='PLASUE'){
				      $this->Cell(5,5,$array_datos[$i][0],'',0,'R');
					  $this->Cell(7,5,$array_datos[$i][1],'',0,'L');
					  $this->Cell(16,5,$array_datos[$i][2],'',0,'R');
					  $this->Cell(7,5,$array_datos[$i][3],'',0,'L');
					  $this->Cell(15,5,$array_datos[$i][4],'',0,'R');
					}
					  //---------
					 if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
					  
						  $this->Cell(22,5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(21,5,$array_datos[$i][6],'',0,'L');
						  $this->Cell(17,5,$array_datos[$i][7],'',0,'L');
						  $this->Cell(19,5,$array_datos[$i][8],'',0,'L');
					  }else{
					  	
						  if(($this->objParam->getParametro('codigo_planilla')=='PLANRE' && $var_planre>0 ) || $this->objParam->getParametro('codigo_planilla')=='PLASUE'){
						  	  $this->Cell(27,5,$array_datos[$i][5],'',0,'L');
							  $this->Cell(27,5,$array_datos[$i][6],'',0,'L');
							  $this->Cell(22,5,$array_datos[$i][7],'',0,'L');
							  $this->Cell(24,5,$array_datos[$i][8],'',0,'L');
						  }
					  }
					  //---------
					  if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){//#ETR-4240
					  	$this->Cell(21,5,$array_datos[$i][9],'',0,'L');
					  }else{
					  	if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
							$this->Cell(21,5,$array_datos[$i][9],'',0,'L');
						}

					  }
					  //----
					if(($this->objParam->getParametro('codigo_planilla')=='PLANRE' && $var_planre>0 ) || $this->objParam->getParametro('codigo_planilla')=='PLASUE'){
						
					  $this->Cell(11,5,$array_datos[$i][10],'',0,'L');
					  $this->Cell(10,5,$array_datos[$i][11],'',0,'C');
					  //-------
					  $this->Cell(8,5,$array_datos[$i][12],'',0,'R');
					  //-----
					  if ($this->objParam->getParametro('tipo_reporte')!='aporte_afp' || $this->objParam->getParametro('codigo_planilla')=='PLASUE'){//#ETR-4272: Para no afectar a los totales de aporte_afp en planilla de reintegros
					  	  $tot13=$tot13+$array_datos[$i][13];
						  $tot15=$tot15+$array_datos[$i][15];
						  $tot16=$tot16+$array_datos[$i][16];
						  $tot17=$tot17+$array_datos[$i][17];
					  }
					  
					}
					  //----
					  
					  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
					      if ($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
					      	  $this->Cell(15,5,number_format($array_datos[$i][13],2,'.',','),'',0,'R');//#80
					      	  $this->Cell(15,5,number_format($array_datos[$i][15],2,'.',','),'',0,'R');//#80
							  $this->Cell(15,5,number_format($array_datos[$i][16],2,'.',','),'',0,'R');//#80
							  $this->Cell(15,5,number_format($array_datos[$i][17],2,'.',','),'',0,'R');//#80
							  $tot18=$tot18+$array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17];
							  $tot19=$tot19+$array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17];
							  $this->Cell(16,5,number_format($array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17],2,'.',','),'',0,'R');//#80
							  $this->Cell(16,5,number_format($array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17],2,'.',','),'',1,'R');//#80
					      }else{ 
					      	  $this->Cell(15,5,number_format($array_datos[$i][18],2,'.',','),'',0,'R');//#80
					      	  $this->Cell(15,5,number_format($array_datos[$i][19],2,'.',','),'',0,'R');//#80
							  $this->Cell(15,5,number_format($array_datos[$i][20],2,'.',','),'',0,'R');//#80
							  $this->Cell(15,5,number_format($array_datos[$i][21],2,'.',','),'',0,'R');//#80
							  $tot18=$tot18+$array_datos[$i][18]+$array_datos[$i][19]+$array_datos[$i][20]+$array_datos[$i][21];
							  $tot19=$tot19+$array_datos[$i][18]+$array_datos[$i][19]+$array_datos[$i][20]+$array_datos[$i][21];
							  $this->Cell(16,5,number_format($array_datos[$i][18]+$array_datos[$i][19]+$array_datos[$i][20]+$array_datos[$i][21],2,'.',','),'',0,'R');//#80
							  $this->Cell(16,5,number_format($array_datos[$i][18]+$array_datos[$i][19]+$array_datos[$i][20]+$array_datos[$i][21],2,'.',','),'',1,'R');//#80
							  
							  $tot13=$tot13+$array_datos[$i][18];
					  		  $tot15=$tot15+$array_datos[$i][19];
							  $tot16=$tot16+$array_datos[$i][20];
							  $tot17=$tot17+$array_datos[$i][21];
							  	
					      }
						  
					  }else{
					  	$this->Cell(15,5,number_format($array_datos[$i][13],2,'.',','),'',0,'R');//#80
						if(($this->objParam->getParametro('codigo_planilla')=='PLANRE' && $var_planre>0 ) || $this->objParam->getParametro('codigo_planilla')=='PLASUE'){
					  	  $this->Cell(17,5,number_format($array_datos[$i][15],2,'.',','),'',0,'R');//#80
						  //---
						  $this->Cell(17,5,number_format($array_datos[$i][16],2,'.',','),'',0,'R');//#80
						}
						  if($this->objParam->getParametro('codigo_planilla')=='PLANRE' && $var_planre>0 ){//#86
						  $this->Cell(17,5,number_format($array_datos[$i][17],2,'.',','),'',0,'R');//#80
						  
						  	  
							  $totncotiz=$totncotiz+ ($array_datos[$i][13]+$array_datos[$i][18]);
							  if($array_datos[$i][13]+$array_datos[$i][18]>13000){
							  	$nvar1=$array_datos[$i][13]+$array_datos[$i][18]-13000;
							  }else{
							  	$nvar1=0;
							  }
							  
							  if($array_datos[$i][13]+$array_datos[$i][18]>25000){
							  	$nvar2=$array_datos[$i][13]+$array_datos[$i][18]-25000;
							  }else{
							  	$nvar2=0;
							  }
							  
							  if($array_datos[$i][13]+$array_datos[$i][18]>35000){
							  	$nvar3=$array_datos[$i][13]+$array_datos[$i][18]-35000;
							  }else{
							  	$nvar3=0;
							  }
								$totnvar1=$totnvar1+$nvar1;
								$totnvar2=$totnvar2+$nvar2;
								$totnvar3=$totnvar3+$nvar3;
								$tot1n=$tot1n+$array_datos[$i][19];
								$tot5n=$tot5n+$array_datos[$i][20];
								$tot10n=$tot10n+$array_datos[$i][21];
						  	  $this->Cell(15,5,number_format($array_datos[$i][13]+$array_datos[$i][18],2,'.',','),'',0,'R');
						  	  $this->Cell(15,5,number_format($nvar1,2,'.',','),'',0,'R');
							  $this->Cell(15,5,number_format($nvar2,2,'.',','),'',0,'R');
							  $this->Cell(15,5,number_format($nvar3,2,'.',','),'',0,'R');
						  	  $this->Cell(10,5,number_format($array_datos[$i][19],2,'.',','),'',0,'R');
							  $this->Cell(10,5,number_format($array_datos[$i][20],2,'.',','),'',0,'R');
						  	  $this->Cell(10,5,number_format($array_datos[$i][21],2,'.',','),'',0,'R');
							  $this->Cell(10,5,number_format($array_datos[$i][19]+$array_datos[$i][20]+$array_datos[$i][21],2,'.',','),'',1,'R');
						  }else{
						  	if(($this->objParam->getParametro('codigo_planilla')=='PLANRE' && $var_planre>0 ) || $this->objParam->getParametro('codigo_planilla')=='PLASUE'){
						  	$this->Cell(17,5,number_format($array_datos[$i][17],2,'.',','),'',1,'R');}
						  }
						  
						  
					  }
			 
			}

			if (count($this->datos)>0){
 			//totales #44
 			$this->SetFont('','B',7);
 			$this->SetLineWidth(0.2);
	 	 	$this->SetDrawColor(0,0,0);
			$this->Cell(0,0,'','B',1);
 			if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
 				if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){ 
	 				$this->Cell(176,5,'TOTALES','',0,'R');
					$this->Cell(3,5,'','',0,'R');
					$this->Cell(15,5,number_format($tot13,2,'.',','),'',0,'R');//#80
					$this->Cell(15,5,number_format($tot15,2,'.',','),'',0,'R');//#80
					$this->Cell(15,5,number_format($tot16,2,'.',','),'',0,'R');//#80
					$this->Cell(15,5,number_format($tot17,2,'.',','),'',0,'R');//#80
					$this->Cell(16,5,number_format($tot18,2,'.',','),'',0,'R');//#80
					$this->Cell(16,5,number_format($tot19,2,'.',','),'',1,'R');//#80
				}else{
					$this->Cell(176,5,'TOTALES','',0,'R');
					$this->Cell(3,5,'','',0,'R');
					$this->Cell(15,5,number_format($tot13,2,'.',','),'',0,'R');//#80
					$this->Cell(15,5,number_format($tot15,2,'.',','),'',0,'R');//#80
					$this->Cell(15,5,number_format($tot16,2,'.',','),'',0,'R');//#80
					$this->Cell(15,5,number_format($tot17,2,'.',','),'',0,'R');//#80
					$this->Cell(16,5,number_format($tot18,2,'.',','),'',0,'R');//#80
					$this->Cell(16,5,number_format($tot19,2,'.',','),'',1,'R');//#80
				}
				
			}else{
				if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
					$this->Cell(197,5,'TOTALES','',0,'R');
					$this->Cell(3,5,'','',0,'R');
					$this->Cell(15,5,number_format($tot13,2,'.',','),'',0,'R');//#80
					$this->Cell(17,5,number_format($tot15,2,'.',','),'',0,'R');//#80
					$this->Cell(17,5,number_format($tot16,2,'.',','),'',0,'R');//#80
					$this->Cell(17,5,number_format($tot17,2,'.',','),'',1,'R');//#80
				}else{//#86
					
					$this->Cell(176,5,'TOTALES','',0,'R');
					$this->Cell(3,5,'','',0,'R');
					$this->Cell(15,5,number_format($tot13,2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($tot15,2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($tot16,2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($tot17,2,'.',','),'',0,'R');
					$this->Cell(15,5,number_format($totncotiz,2,'.',','),'',0,'R');
					$this->Cell(15,5,number_format($totnvar1,2,'.',','),'',0,'R');
					$this->Cell(15,5,number_format($totnvar2,2,'.',','),'',0,'R');
					$this->Cell(15,5,number_format($totnvar3,2,'.',','),'',0,'R');
					$this->Cell(10,5,number_format($tot1n,2,'.',','),'',0,'R');
					$this->Cell(10,5,number_format($tot5n,2,'.',','),'',0,'R');
					$this->Cell(10,5,number_format($tot10n,2,'.',','),'',0,'R');
					$this->Cell(10,5,number_format(($tot1n+$tot5n+$tot10n),2,'.',','),'',1,'R');
					
				}
			}
				
				}//#123
		
		}
		
		
			
	
	
    
}
?>