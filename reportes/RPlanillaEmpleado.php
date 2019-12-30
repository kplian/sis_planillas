<?php
// Extend the TCPDF class to create custom MultiRow
/**
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion
 #41	ETR				16.09.2019			MZM		 			Modificacion a reporte reserva detalle para q liste 3 registros historicos, adicion de tipo contrato en titulo y formateo de number
 #64	ETR				10.10.2019			MZM					Ajuste a reporte Aporte CACSEL
 #77	ETR				15.11.2019			MZM					Ajuste reportes
 #77 	ETR				20.11.2019			MZM					Cambio de ubicacion de columas nomina CT
 #80 	ETR				27.11.2019			MZM					Cambio de formato numeric, ajuste a beneficios reserva detalel
 #83	ETR				10.12.2019			MZM					Habilitacion de opcion historico de planilla
*/
class RPlanillaEmpleado extends  ReportePDF {
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
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
			
			$this->Cell(0,5,'T.C. '.$this->datos[0]['tc'],0,1,'R');
		}
		//#83
		$dr=substr($this->datos_titulo[0]['fecha_backup'],0,2);
		$mr=substr($this->datos_titulo[0]['fecha_backup'],3,2);
		$ar=substr($this->datos_titulo[0]['fecha_backup'],6);
		if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
			$this->Cell(0, 3, '', '', 0, 'R');
			$this->Cell(0, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'R');
		}else{
			$this->Cell(0, 3, '', '', 1, 'R');
		}
		$this->SetFont('','B',12);//#77
		$this->SetY(20);
		$cadena_nomina='';
		
		if($this->objParam->getParametro('id_tipo_contrato')!='' && $this->objParam->getParametro('id_tipo_contrato')>0){
			$cadena_nomina='('.$this->datos[0]['tipo_contrato'].')';
			
		}
		
		
		
		if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
			$this->Cell(0,5,'NOMINA DE SALARIOS BC '.$cadena_nomina,0,1,'C');
			
		}else{
			
			if($this->objParam->getParametro('tipo_reporte')=='no_sindicato' || $this->objParam->getParametro('tipo_reporte')=='aporte_sindicato' || $this->objParam->getParametro('tipo_reporte')=='aporte_cacsel'){
				if ($this->objParam->getParametro('tipo_reporte')=='no_sindicato'){
					$this->Cell(0,5,'NOMINA DE PERSONAL NO SINDICALIZADO',0,1,'C');
					
				}else{ if ( $this->objParam->getParametro('tipo_reporte')=='aporte_cacsel'){
					$this->Cell(0,5,'APORTE PORCENTUAL CACSEL',0,1,'C');
				}else{
					$this->Cell(0,5,'APORTE PORCENTUAL SINDICATO',0,1,'C');
				}
					
				}
				
				if($cadena_nomina!=''){
						$this->Cell(0,5,$cadena_nomina,0,1,'C');	
				}
				
			}else{
				if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
					$this->Cell(0,5,'PLANILLA DE RESERVA PARA BENEFICIOS SOCIALES',0,1,'C');
					if($cadena_nomina!=''){ //#41
						$this->Cell(0,5,$cadena_nomina,0,1,'C');	
					}
					
				}else{
					$this->Cell(0,5,'NOMINA DE SALARIOS '.$cadena_nomina,0,1,'C');
				}
				
			}
			
		}
		
		
		$this->SetFont('','B',10);
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
			$this->Cell(0,5,'Hasta : '.$this->objParam->getParametro('fecha'),0,1,'C');
			
		}else{
			$this->Cell(0,5,'Correspondiente al mes de : '.$this->datos[0]['periodo'],0,1,'C');
		}
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$this->SetFont('','B',8);
		$this->SetX(10);
		$this->Cell(18,5,'Codigo ','LTR',0,'C');
		
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
			  $this->Cell(65,5,'Nombre Completo','LTR',0,'C');
			  $this->Cell(20,5,'Fecha','LTR',0,'C');
			  $this->Cell(20,5,'Dias','LTR',0,'C');
			  $this->Cell(25,5,'Cotizable','LTR',0,'C');
			  $this->Cell(25,5,'Reserva','LTR',0,'C');
			  $this->Cell(25,5,'Reserva','LTR',1,'C');
		}else{
		
			if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
				$this->Cell(55,5,'Nombre Completo','LTR',0,'C');
				$this->Cell(40,5,'Cargo','LTR',0,'C');
			  	$this->Cell(15,5,'Fecha','LTR',0,'C');
			}else{
			
				if($this->objParam->getParametro('tipo_reporte')=='aporte_cacsel'){
					$this->Cell(160,5,'Nombre Completo','LTR',0,'C');
				}else{
					$this->Cell(60,5,'Nombre Completo','LTR',0,'C');
					if($this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
						$this->Cell(65,5,'Cargo','LTR',0,'C');
					}else{
						
						$this->Cell(35,5,'CI','LTR',0,'C');//*********
						
					}
				}
				
			}
		
			if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
				$this->Cell(10,5,'Nivel','LTR',0,'C');
			}
		
		
			if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
			
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
					$this->Cell(17,5,'S.Basico','LTR',0,'C');
					$this->Cell(17,5,'T.Cotizab','LTR',0,'C');
					$this->Cell(11,5,'Nivel','LTR',0,'C');
					$this->Cell(15,5,'Basico','LTR',1,'C');
				}else{
					$this->Cell(20,5,'T.Cotizable','LTR',0,'C');
					$this->Cell(20,5,'Costo Total','LTR',1,'C');
				}
			}else{
				if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
					$this->Cell(65,5,'Distrito','LTR',0,'C');//*****
				}
				
				
				$this->Cell(20,5,'Aporte','LTR',1,'C');//*****
			}
			
		}
		//titulo inferior
		
		
		$this->SetX(10);
		$this->Cell(18,5,'Emp.','LBR',0,'C');
		
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
			  $this->Cell(65,5,'','LBR',0,'L');
			  $this->Cell(20,5,'Ingreso','LBR',0,'C');
			  $this->Cell(20,5,'Trabajados','LBR',0,'C');
			  $this->Cell(25,5,'','LBR',0,'C');
			  $this->Cell(25,5,'Bs.','LBR',0,'C');
			  $this->Cell(25,5,'USD','LBR',1,'C');
		}else{
		
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
					$this->Cell(55,5,'','LBR',0,'C');
					$this->Cell(40,5,'','LBR',0,'C');
				 	$this->Cell(15,5,'Ingreso','LBR',0,'C');
				}else{
					
					if($this->objParam->getParametro('tipo_reporte')=='aporte_cacsel'){
						$this->Cell(160,5,'','LBR',0,'C');
					}else{
						$this->Cell(60,5,'','LBR',0,'C');
						if($this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
						
							$this->Cell(65,5,'','LBR',0,'C');
						}else{
							$this->Cell(35,5,'','LBR',0,'C');//*****
							
						}
					}
				}
			
		
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
				$this->Cell(10,5,'','LBR',0,'C');
				}
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
				
					if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
						$this->Cell(17,5,'Bs.','LBR',0,'C');
						$this->Cell(17,5,'Bs.','LBR',0,'C');
						$this->Cell(11,5,'Limite','LBR',0,'C');
						$this->Cell(15,5,'Limite','LBR',1,'C');
					}else{
						$this->Cell(20,5,'Bs.','LBR',0,'C');
						$this->Cell(20,5,'Bs.','LBR',1,'C');
					}
				}else{
					if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
						$this->Cell(65,5,'','LBR',0,'C');//*****
					}
					$this->Cell(20,5,'(Bs)','LBR',1,'C');//*****
				}
			}
		
	
		$this->alto_header =$this->GetY(); 

	}
	function setDatos($datos,$datos_titulo) {
		$this->datos = $datos;
		$this->datos_titulo=$datos_titulo;
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
		$tot_sus=0;
		$tot_cot=0;
		
		$contador_reserva3=0;
		
		if( $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){//#80
			$num=0;
			//var_dump($this->datos); exit;
				for ($i=0; $i<count($this->datos);$i++){
					
					
					$cont++;
					if($id_funcionario!=$this->datos[$i]['id_funcionario']){ 
						     
						     /*if($num==3){//#41
						     	
						     }else{
						      	while($id_funcionario!=0 && $num<4 ){ 
						      	  $num++;
							  	  $cont++;
							      $array_datos[$cont][0]='';
								  $array_datos[$cont][1]='';
								  $array_datos[$cont][2]=$this->datos[$i-1]['cargo'];
								  $array_datos[$cont][3]='';
								  $array_datos[$cont][4]=$this->datos[$i-1]['nivel'];
								  $array_datos[$cont][5]= $this->datos[$i-1]['valor'];
								  $array_datos[$cont][7]='';
								  $array_datos[$cont][8]='';
								  $array_datos[$cont][9]=$this->datos[$i-1]['nombre_gerencia'];
								  $array_datos[$cont][10]=$this->datos[$i-1]['nombre_unidad'];
								  $array_datos[$cont][11]=$this->datos[$i-1]['ci'].'  '.$this->datos[$i-1]['expedicion'];
								  $array_datos[$cont][12]=$this->datos[$i-1]['distrito'];							 
								  $array_datos[$cont][13]='';
								  $array_datos[$cont][14]=$this->datos[$i-1]['anos_quinquenio'];
								  $array_datos[$cont][15]=$this->datos[$i-1]['mes_quinquenio'];
								  $array_datos[$cont][16]=$this->datos[$i-1]['dias_quinquenio'];
								  
								  $val=$val+$this->datos[$i-1]['valor'];
								  
								  $array_datos[$cont][17]=$val; 
								  $array_datos[$cont][18]=number_format($num,2);
						      	}
						      }*/


						      $val=0;
							  $num=1; 
					 	  	  $array_datos[$cont][0]=$this->datos[$i]['codigo_empleado'];
							  $array_datos[$cont][1]=$this->datos[$i]['nombre_empleado'];
							  $array_datos[$cont][2]=$this->datos[$i]['cargo'];
							  $ff=$this->datos[$i]['fecha_ingreso'];
							  $aa=substr($ff, 0,4);
							  $mm=substr($ff, 5,2);
							  $dd=substr($ff, 8,2);
							  $array_datos[$cont][3]=$dd.'/'.$mm.'/'.$aa;
							  $array_datos[$cont][4]=$this->datos[$i]['nivel'];
							  $array_datos[$cont][5]= $this->datos[$i]['valor'];
							  $array_datos[$cont][7]='';
							  $array_datos[$cont][8]='';
							  $array_datos[$cont][9]=$this->datos[$i]['nombre_gerencia'];
							  $array_datos[$cont][10]=$this->datos[$i]['nombre_unidad'];
							  $array_datos[$cont][11]=$this->datos[$i]['ci'].'  '.$this->datos[$i]['expedicion'];
							  $array_datos[$cont][12]=$this->datos[$i]['distrito'];
							  
							  $a=substr($this->datos[$i]['fecha_quinquenio'],0,4);
							  $m=substr($this->datos[$i]['fecha_quinquenio'],5,2);
							  $d=substr($this->datos[$i]['fecha_quinquenio'],8,2);
							  
							  
							  $array_datos[$cont][13]=$d.'/'.$m.'/'.$a;
							  $array_datos[$cont][14]=$this->datos[$i]['anos_quinquenio'];
							  $array_datos[$cont][15]=$this->datos[$i]['mes_quinquenio'];
							  $array_datos[$cont][16]=$this->datos[$i]['dias_quinquenio'];
							  $array_datos[$cont][17]=$this->datos[$i]['valor'];
							  $array_datos[$cont][18]=number_format($num,2);
							 
							  $val=$this->datos[$i]['valor'];
							  
							 
					}else{
						
						 $num++;
					
							  $array_datos[$cont][0]='';
							  $array_datos[$cont][1]='';
							  $array_datos[$cont][2]=$this->datos[$i]['cargo'];
							  $array_datos[$cont][3]='';
							  $array_datos[$cont][4]=$this->datos[$i]['nivel'];
							  $array_datos[$cont][5]= $this->datos[$i]['valor'];
							  $array_datos[$cont][7]='';
							  $array_datos[$cont][8]='';
							  $array_datos[$cont][9]=$this->datos[$i]['nombre_gerencia'];
							  $array_datos[$cont][10]=$this->datos[$i]['nombre_unidad'];
							  $array_datos[$cont][11]=$this->datos[$i]['ci'].'  '.$this->datos[$i]['expedicion'];
							  $array_datos[$cont][12]=$this->datos[$i]['distrito'];							 
							  $array_datos[$cont][13]='';
							  $array_datos[$cont][14]=$this->datos[$i]['anos_quinquenio'];
							  $array_datos[$cont][15]=$this->datos[$i]['mes_quinquenio'];
							  $array_datos[$cont][16]=$this->datos[$i]['dias_quinquenio'];
							  
							  $val=$val+$this->datos[$i]['valor'];
							  
							  $array_datos[$cont][17]=$val; 
							  $array_datos[$cont][18]=number_format($num,2);
					}
					$id_funcionario=$this->datos[$i]['id_funcionario'];
				}


				//para el ultimo registro #41
				/*while($num!=0 && $num<3 ){ 
						      	  $num++;
							  	  $cont++;
							      $array_datos[$cont][0]='';
								  $array_datos[$cont][1]='';
								  $array_datos[$cont][2]=$this->datos[$i-1]['cargo'];
								  $array_datos[$cont][3]='';
								  $array_datos[$cont][4]=$this->datos[$i-1]['nivel'];
								  $array_datos[$cont][5]= $this->datos[$i-1]['valor'];
								  $array_datos[$cont][7]='';
								  $array_datos[$cont][8]='';
								  $array_datos[$cont][9]=$this->datos[$i-1]['nombre_gerencia'];
								  $array_datos[$cont][10]=$this->datos[$i-1]['nombre_unidad'];
								  $array_datos[$cont][11]=$this->datos[$i-1]['ci'].'  '.$this->datos[$i-1]['expedicion'];
								  $array_datos[$cont][12]=$this->datos[$i-1]['distrito'];							 
								  $array_datos[$cont][13]='';
								  $array_datos[$cont][14]=$this->datos[$i-1]['anos_quinquenio'];
								  $array_datos[$cont][15]=$this->datos[$i-1]['mes_quinquenio'];
								  $array_datos[$cont][16]=$this->datos[$i-1]['dias_quinquenio'];
								  
								  $val=$val+$this->datos[$i-1]['valor'];
								  
								  $array_datos[$cont][17]=$val; 
								  $array_datos[$cont][18]=number_format($num,2);
						      }*/


 
		}else{
			
			if( $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){ 
				$id_funcionario=$this->datos[0]['id_funcionario'];
				$cont=0;
				$numE=0;
				for ($i=0; $i<count($this->datos)+2;$i++){
									
				    if($id_funcionario!=$this->datos[$i]['id_funcionario'] ){
				    	
							  $cont++;
					 	  	  $array_datos[$cont][0]=$this->datos[$i-1]['codigo_empleado'];
							  $array_datos[$cont][1]=$this->datos[$i-1]['nombre_empleado'];
							  $array_datos[$cont][2]='';
							  $ff=$this->datos[$i-1]['fecha_ingreso'];
							  $aa=substr($ff, 0,4);
							  $mm=substr($ff, 5,2);
						      $dd=substr($ff, 8,2);
							  $array_datos[$cont][3]=$dd.'/'.$mm.'/'.$aa;
							  $array_datos[$cont][4]='';
							
							  $array_datos[$cont][5]= ($val/$numE);
							  $array_datos[$cont][7]='';
							  $array_datos[$cont][8]='';
							  $array_datos[$cont][9]='';
							  $array_datos[$cont][10]='';
							  $array_datos[$cont][11]='';
							  $array_datos[$cont][12]='';
							  
							  $a=substr($this->datos[$i-1]['fecha_quinquenio'],0,4);
							  $m=substr($this->datos[$i-1]['fecha_quinquenio'],5,2);
							  $d=substr($this->datos[$i-1]['fecha_quinquenio'],8,2);
							  
							  
							  $array_datos[$cont][13]=$d.'/'.$m.'/'.$a;
							  $array_datos[$cont][14]=$this->datos[$i-1]['anos_quinquenio'];
							  $array_datos[$cont][15]=$this->datos[$i-1]['mes_quinquenio'];
							  $array_datos[$cont][16]=$this->datos[$i-1]['dias_quinquenio'];
							  $val=$this->datos[$i]['valor'];
							  $numE=0;
						}else{
							  
							  //$array_datos[$cont][5]= $this->datos[$i]['valor'];
							  $val=$val+$this->datos[$i]['valor'];
							
						}
						
					$numE++;
					$id_funcionario=$this->datos[$i]['id_funcionario'];
				}
			
				
			}else{ 
		  			for ($i=0; $i<count($this->datos);$i++){
		   
					 	  if($id_funcionario!=$this->datos[$i]['id_funcionario'] ){
					 	  	  
					 	  	  $cont++;
					 	  	  $array_datos[$cont][0]=$this->datos[$i]['codigo_empleado'];
							  $array_datos[$cont][1]=$this->datos[$i]['nombre_empleado'];
							  $array_datos[$cont][2]=$this->datos[$i]['cargo'];
							  $ff=$this->datos[$i]['fecha_ingreso'];
								$aa=substr($ff, 0,4);
								$mm=substr($ff, 5,2);
								$dd=substr($ff, 8,2);
							  $array_datos[$cont][3]=$dd.'/'.$mm.'/'.$aa;
							  $array_datos[$cont][4]=$this->datos[$i]['nivel'];
							  $array_datos[$cont][5]= $this->datos[$i]['valor'];
							  $array_datos[$cont][7]='';
							  $array_datos[$cont][8]='';
							  $array_datos[$cont][9]=$this->datos[$i]['nombre_gerencia'];
							  $array_datos[$cont][10]=$this->datos[$i]['nombre_unidad'];
							  $array_datos[$cont][11]=$this->datos[$i]['ci'].'  '.$this->datos[$i]['expedicion'];
							  $array_datos[$cont][12]=$this->datos[$i]['distrito'];
							  
							  $a=substr($this->datos[$i]['fecha_quinquenio'],0,4);
							  $m=substr($this->datos[$i]['fecha_quinquenio'],5,2);
							  $d=substr($this->datos[$i]['fecha_quinquenio'],8,2);
							  
							  
							  $array_datos[$cont][13]=$d.'/'.$m.'/'.$a;
							  $array_datos[$cont][14]=$this->datos[$i]['anos_quinquenio'];
							  $array_datos[$cont][15]=$this->datos[$i]['mes_quinquenio'];
							  $array_datos[$cont][16]=$this->datos[$i]['dias_quinquenio'];
							  //para nomina de salarios BC y CT
							  $array_datos[$cont][17]=$this->datos[$i]['nivel_limite'];
							  $array_datos[$cont][18]=$this->datos[$i]['basico_limite'];
					 	  }else{   
					 	  	
					 	  	  $array_datos[$cont][6]= $this->datos[$i]['valor'];
					 	  }
							$id_funcionario=$this->datos[$i]['id_funcionario'];
					}
					
				}
		}	
		$this->SetX(10);
		
		/***********************************************/
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
		   $code=$array_datos[0][0];
			
			for ($i=0; $i<$cont+1;$i++){
				$code=$array_datos[$i][0];	
				
					if($code!='' && $i!=0 && $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
					//echo $i.'---'.$array_datos[1][17].'---'.$array_datos[1][18]; exit;
					$numE++; //#41
					   if($array_datos[$i-1][18]>0 ){
						   	$this->Cell(148,5,number_format($array_datos[$i-1][17]/$array_datos[$i-1][18],2,'.',','),'',0,'R');	//#80
							$this->Cell(25,5,number_format($array_datos[$i-1][17]/$array_datos[$i-1][18]/360*$diast,2,'.',','),'',0,'R');//#80
							$this->Cell(25,5,number_format($array_datos[$i-1][17]/$array_datos[$i-1][18]/360*$diast/$this->datos[0]['tc'],2,'.',','),'',1,'R');//#80
							$this->Ln(3);
						
                            $tot_cot=$tot_cot+($array_datos[$i-1][17]/$array_datos[$i-1][18]);						
						 	$tot_bs=$tot_bs+($array_datos[$i-1][17]/$array_datos[$i-1][18]/360*$diast);
							$tot_sus=$tot_sus+($array_datos[$i-1][17]/$array_datos[$i-1][18]/360*$diast/$this->datos[0]['tc']);
						
					   }
					    
						
					}
					
									
					$dias=(($array_datos[$i][14]*360)+($array_datos[$i][15]*30)+($array_datos[$i][16]));
					//$dias=number_format($dias,2,',','.');
					if($dias>0){
						$this->Cell(18,5,$array_datos[$i][0],'',0,'C');
						$this->Cell(65,5,mb_strcut ( $array_datos[$i][1], 0, 38, "UTF-8"),'',0,'L');
						$this->Cell(20,5,$array_datos[$i][13],'',0,'L');	
						if($code==''){
							$this->Cell(20,5,'','',0,'R');
						}else{
							$this->Cell(20,5,number_format($dias,0,'.',','),'',0,'R');
						}
						
							
						$diast=(($array_datos[$i][14]*360)+($array_datos[$i][15]*30)+($array_datos[$i][16]));
					 	if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
							$this->Cell(25,5,number_format($array_datos[$i][5],2,'.',','),'',1,'R');	
						}
						if($this->objParam->getParametro('tipo_reporte')!='reserva_beneficios3' ){
							$this->Cell(25,5,number_format($array_datos[$i][5],2,'.',','),'',0,'R');//#80
							$this->Cell(25,5,number_format(($array_datos[$i][5]/360*$dias),2,'.',','),'',0,'R');	//#80
							$this->Cell(25,5,number_format($array_datos[$i][5]/360*$dias/$this->datos[0]['tc'],2,'.',','),'',1,'R');//#80
							$tot_cot=$tot_cot+($array_datos[$i][5]);
							$tot_bs=$tot_bs+($array_datos[$i][5]/360*$dias);
							$tot_sus=$tot_sus+($array_datos[$i][5]/360*$dias/$this->datos[0]['tc']);
						}
					 
					}	
					
					
				}	

              
               if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
				$this->Cell(148,5,number_format($array_datos[$cont][17]/$array_datos[$cont][18],2,'.',','),'',0,'R');//#80
				$this->Cell(25,5,number_format($array_datos[$cont][17]/$array_datos[$cont][18]/360*$diast,2,'.',','),'',0,'R');//#80
				$this->Cell(25,5,number_format($array_datos[$cont][17]/$array_datos[$cont][18]/360*$diast/$this->datos[0]['tc'],2,'.',','),'',1,'R');//#80
				$tot_cot=$tot_cot+($array_datos[$cont][17]/$array_datos[$cont][18]);
				$tot_bs=$tot_bs+($array_datos[$cont][17]/$array_datos[$cont][18]/360*$diast);
				$tot_sus=$tot_sus+($array_datos[$cont][17]/$array_datos[$cont][18]/360*$diast/$this->datos[0]['tc']);
			   }			

				//#41
				$this->SetLineWidth(0.2);
		 	 	$this->SetDrawColor(0,0,0);
				$this->Cell(0,0,'','B',1);
				$this->SetFont('','B',8);
			if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
				$this->Cell(18,5,$numE,'',0,'C');
			}else{
				$this->Cell(18,5,number_format($cont,0,'.',','),'',0,'C');
			}
				$this->Cell(130,5,number_format($tot_cot,2,'.',','),'',0,'R');//#80
				$this->Cell(25,5,number_format($tot_bs,2,'.',','),'',0,'R');//#80
				$this->Cell(25,5,number_format($tot_sus,2,'.',','),'',1,'R');//#80	
				
		}else{
			
				
			if($this->objParam->getParametro('tipo_reporte')=='no_sindicato' || $this->objParam->getParametro('tipo_reporte')=='aporte_sindicato' || $this->objParam->getParametro('tipo_reporte')=='aporte_cacsel' ){
				//var_dump($array_datos); exit;
				$total_valor=0;
				for ($i=0; $i<$cont;$i++){
					$total_valor=$total_valor+$array_datos[$i][5];
					if($array_datos[$i][1]!=''){ //#64
						$this->Cell(18,5,$array_datos[$i][0],'',0,'L');
						
						if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
							$this->Cell(60,5,mb_strcut ( $array_datos[$i][1], 0, 32,"UTF-8"),'',0,'L');
						}
						
						if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
							
							$this->Cell(35,5,$array_datos[$i][11],'',0,'L');	
							$this->Cell(65,5,$array_datos[$i][12],'',0,'L');	
						}else{
							$this->Cell(160,5,mb_strcut ( $array_datos[$i][1], 0, 32,"UTF-8"),'',0,'L');
						}
						if($array_datos[$i][5]>0){
							$this->Cell(20,5,number_format($array_datos[$i][5],2,'.',','),'',1,'R');//#80
						}else{
							$this->Cell(20,5,'','',1,'R');//#64
						}
					}
											
				}	
				//#64
				    $this->Cell(18,5,$array_datos[$cont][0],'',0,'L');
					if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
				    	$this->Cell(60,5,mb_strcut ( $array_datos[$cont][1], 0, 32,"UTF-8"),'',0,'L');
					}
					if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
						$this->Cell(35,5,$array_datos[$cont][11],'',0,'L');	
						$this->Cell(65,5,$array_datos[$cont][12],'',0,'L');	
					}else{
						$this->Cell(160,5,mb_strcut ( $array_datos[$cont][1], 0, 32,"UTF-8"),'',0,'L');	
					}
					if($array_datos[$i][5]>0){
						$this->Cell(20,5,$array_datos[$cont][5],'',1,'R');
					}else{
						$this->Cell(20,5,'','',1,'R');//#64
					}	
				
				if($this->objParam->getParametro('tipo_reporte')!='no_sindicato'){//#64
					//para el total
					$this->SetLineWidth(0.5);
				 	$this->SetDrawColor(0,0,0);
					$this->Cell(0,0,'','B',1);
					$this->Ln(1);
					$this->SetFont('','B',8);
					$this->Cell(178,5,'Monto Total:','',0,'R');	
					$this->SetFont('','',8);
					$this->Cell(20,5,number_format($total_valor,2,'.',','),'',1,'R');	//#80
				}
				
				
				
				
			}else{//salario BC y CT
				
			    //#77
			    $tot1=0;
				$tot2=0;
				$tot3=0;
				$tot11=0;
				$tot22=0;
				for ($i=0; $i<$cont+1;$i++){	
					     if($array_datos[$i][9]!=$gerencia){
							 	$this->Ln(2);
								$this->SetFont('','B',10);
								$this->Cell(100,5,''.$array_datos[$i][9],'',1,'L');
								$this->Ln(2);
								$contf=0; 
						 }
								    if(($departamento!=$array_datos[$i][10]) && ($array_datos[$i][10]!=$array_datos[$i][9])){
							 			$this->Ln(2);
							 			$this->SetFont('','B',8);
										$this->Cell(100,5,''.$array_datos[$i][10],'',1,'L');
										$this->Ln(2);
										$this->SetFont('','',8);
							 	
							 	    }
							 	 
		
										$this->SetFont('','',8);
										$this->Cell(18,5,substr ( $array_datos[$i][0], 0, 23),'',0,'L');
										
										if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
											$this->Cell(55,5,mb_strcut ( $array_datos[$i][1], 0, 29,"UTF-8"),'',0,'L');
											$this->Cell(40,5,mb_strcut ( $array_datos[$i][2], 0, 22,"UTF-8"),'',0,'L');
											
											$this->Cell(15,5,$array_datos[$i][3],'',0,'L');
										}else{
										
											$this->Cell(60,5,mb_strcut ( $array_datos[$i][1], 0, 33,"UTF-8"),'',0,'L');
											$this->Cell(65,5,mb_strcut ( $array_datos[$i][2], 0, 38,"UTF-8"),'',0,'L');
										}
										$this->Cell(10,5,$array_datos[$i][4],'',0,'R');
									
										if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
											if($array_datos[$i][5]!=''){
												$tot1=$tot1+$array_datos[$i][5];
												$tot2=$tot2+$array_datos[$i][6];
												$tot3=$tot3+$array_datos[$i][18];
												$this->Cell(17,5,number_format($array_datos[$i][5],2,'.',','),'',0,'R');//#80
												$this->Cell(17,5,number_format($array_datos[$i][6],2,'.',','),'',0,'R');//#80
												$this->Cell(11,5,$array_datos[$i][17],'',0,'R');//nomina BC y CT
												$this->Cell(15,5,number_format($array_datos[$i][18],2,'.',','),'',1,'R');//nomina BC y CT //#80
											}
										}else{
											if($array_datos[$i][5]!=''){
												$tot11=$tot11+$array_datos[$i][5];
												$tot22=$tot22+$array_datos[$i][6];
												$this->Cell(20,5,number_format($array_datos[$i][6],2,'.',','),'',0,'R');//#77 (20.11.19) //#80
												$this->Cell(20,5,number_format($array_datos[$i][5],2,'.',','),'',1,'R');//#77 (20.11.19) //#80
											}
											
										
										}
										
								
								$gerencia=$array_datos[$i][9];
								$departamento=$array_datos[$i][10];
						
					}

					//totales basico y cotizable #77
					$this->SetFont('','B',7.7);
					$this->Ln(2);
					if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
						$this->Cell(128,5,'TOTALES','',0,'R');
						$this->Cell(10,5,'','',0,'R');
						$this->Cell(17,5,number_format($tot1,2,'.',','),'',0,'R');//#80
						$this->Cell(17,5,number_format($tot2,2,'.',','),'',0,'R');//nomina BC y CT //#80
						$this->Cell(26,5,number_format($tot3,2,'.',','),'',1,'R');//nomina BC y CT //#80
					}else{
						$this->Cell(153,5,'TOTALES','',0,'R');
										
						$this->Cell(20,5,number_format($tot22,2,'.',','),'',0,'R'); //#77 (20.11.19) //#80
						$this->Cell(20,5,number_format($tot11,2,'.',','),'',0,'R');//nomina BC y CT #77 (20.11.19) //#80
					}
					


				}
						
			}
		
		} 

		
	
		
		
		
			
	
	
    
}
?>