<?php
// Extend the TCPDF class to create custom MultiRow
/**
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
*/
class RPlanillaEmpleado extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	
	function Header() {
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
			$this->SetFont('','B',8);
			$this->Cell(0,5,'T.C. '.$this->datos[0]['tc'],0,1,'R');
		}
		
		$this->SetFont('','B',15);
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
				
			}else{
				if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
					$this->Cell(0,5,'PLANILLA DE RESERVA PARA BENEFICIOS SOCIALES',0,1,'C');
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
		$this->Cell(18,3.5,'Codigo ','LTR',0,'C');
		
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
			  $this->Cell(65,3.5,'Nombre Completo','LTR',0,'C');
			  $this->Cell(20,3.5,'Fecha','LTR',0,'C');
			  $this->Cell(20,3.5,'Dias','LTR',0,'C');
			  $this->Cell(25,3.5,'Cotizable','LTR',0,'C');
			  $this->Cell(25,3.5,'Reserva','LTR',0,'C');
			  $this->Cell(25,3.5,'Reserva','LTR',1,'C');
		}else{
		
			if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
				$this->Cell(55,3.5,'Nombre Completo','LTR',0,'C');
				$this->Cell(40,3.5,'Cargo','LTR',0,'C');
			  	$this->Cell(15,3.5,'Fecha','LTR',0,'C');
			}else{
			
				if($this->objParam->getParametro('tipo_reporte')=='aporte_cacsel'){
					$this->Cell(160,3.5,'Nombre Completo','LTR',0,'C');
				}else{
					$this->Cell(60,3.5,'Nombre Completo','LTR',0,'C');
					if($this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
						$this->Cell(65,3.5,'Cargo','LTR',0,'C');
					}else{
						
						$this->Cell(35,3.5,'CI','LTR',0,'C');//*********
						
					}
				}
				
			}
		
			if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
				$this->Cell(10,3.5,'Nivel','LTR',0,'C');
			}
		
		
			if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
			
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
					$this->Cell(15,3.5,'S.Basico','LTR',0,'C');
					$this->Cell(15,3.5,'T.Cotizab','LTR',0,'C');
					$this->Cell(15,3.5,'Nivel','LTR',0,'C');
					$this->Cell(15,3.5,'Basico','LTR',1,'C');
				}else{
					$this->Cell(20,3.5,'T.Cotizable','LTR',0,'C');
					$this->Cell(20,3.5,'Costo Total','LTR',1,'C');
				}
			}else{
				if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
					$this->Cell(65,3.5,'Distrito','LTR',0,'C');//*****
				}
				
				
				$this->Cell(20,3.5,'Aporte','LTR',1,'C');//*****
			}
			
		}
		//titulo inferior
		
		
		$this->SetX(10);
		$this->Cell(18,3.5,'Emp.','LBR',0,'C');
		
		if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
			  $this->Cell(65,3.5,'','LBR',0,'L');
			  $this->Cell(20,3.5,'Ingreso','LBR',0,'C');
			  $this->Cell(20,3.5,'Trabajados','LBR',0,'C');
			  $this->Cell(25,3.5,'','LBR',0,'C');
			  $this->Cell(25,3.5,'Bs.','LBR',0,'C');
			  $this->Cell(25,3.5,'USD','LBR',1,'C');
		}else{
		
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
					$this->Cell(55,3.5,'','LBR',0,'C');
					$this->Cell(40,3.5,'','LBR',0,'C');
				 	$this->Cell(15,3.5,'Ingreso','LBR',0,'C');
				}else{
					
					if($this->objParam->getParametro('tipo_reporte')=='aporte_cacsel'){
						$this->Cell(160,3.5,'','LBR',0,'C');
					}else{
						$this->Cell(60,3.5,'','LBR',0,'C');
						if($this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
						
							$this->Cell(65,3.5,'','LBR',0,'C');
						}else{
							$this->Cell(35,3.5,'','LBR',0,'C');//*****
							
						}
					}
				}
			
		
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
				$this->Cell(10,3.5,'','LBR',0,'C');
				}
				if($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
				
					if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
						$this->Cell(15,3.5,'Bs.','LBR',0,'C');
						$this->Cell(15,3.5,'Bs.','LBR',0,'C');
						$this->Cell(15,3.5,'Limite','LBR',0,'C');
						$this->Cell(15,3.5,'Limite','LBR',1,'C');
					}else{
						$this->Cell(20,3.5,'Bs.','LBR',0,'C');
						$this->Cell(20,3.5,'Bs.','LBR',1,'C');
					}
				}else{
					if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
						$this->Cell(65,3.5,'','LBR',0,'C');//*****
					}
					$this->Cell(20,3.5,'(Bs)','LBR',1,'C');//*****
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
		
		if( $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
			//var_dump($this->datos); exit;
				for ($i=0; $i<count($this->datos);$i++){
					$cont++;
					if($id_funcionario!=$this->datos[$i]['id_funcionario']){ 
						      
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
		   
					 	  if($id_funcionario!=$this->datos[$i]['id_funcionario']){
					 	  	  
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
							  $array_datos[$cont][18]=number_format($this->datos[$i]['basico_limite'],2,',','.');
					 	  }else{   
					 	  	
					 	  	  $array_datos[$cont][6]= number_format($this->datos[$i]['valor'],2,',','.');
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
					   if($array_datos[$i-1][18]>0 ){
						   	$this->Cell(148,3.5,number_format($array_datos[$i-1][17]/$array_datos[$i-1][18],2,',','.'),'',0,'R');	
							$this->Cell(25,3.5,number_format($array_datos[$i-1][17]/$array_datos[$i-1][18]/360*$diast,2,',','.'),'',0,'R');
							$this->Cell(25,3.5,number_format($array_datos[$i-1][17]/$array_datos[$i-1][18]/360*$diast/$this->datos[0]['tc'],2,',','.'),'',1,'R');
							$this->Ln(3);
						
					   }
					    
						
					}
					
									
					$dias=(($array_datos[$i][14]*360)+($array_datos[$i][15]*30)+($array_datos[$i][16]));
					//$dias=number_format($dias,2,',','.');
					if($dias>0){
						$this->Cell(18,3.5,$array_datos[$i][0],'',0,'L');
						$this->Cell(65,3.5,substr ( $array_datos[$i][1], 0, 32),'',0,'L');
						$this->Cell(20,3.5,$array_datos[$i][13],'',0,'L');	
						if($code==''){
							$this->Cell(20,3.5,'','',0,'R');
						}else{
							$this->Cell(20,3.5,number_format($dias,2,',','.'),'',0,'R');
						}
						
							
						$diast=(($array_datos[$i][14]*360)+($array_datos[$i][15]*30)+($array_datos[$i][16]));
					 	if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
							$this->Cell(25,3.5,number_format($array_datos[$i][5],2,',','.'),'',1,'R');	
						}
						if($this->objParam->getParametro('tipo_reporte')!='reserva_beneficios3' ){
							$this->Cell(25,3.5,number_format($array_datos[$i][5],2,',','.'),'',0,'R');
							$this->Cell(25,3.5,number_format(($array_datos[$i][5]/360*$dias),2,',','.'),'',0,'R');	
							$this->Cell(25,3.5,number_format($array_datos[$i][5]/360*$dias/$this->datos[0]['tc'],2,',','.'),'',1,'R');
						}
					 
					}	
					
					
					
					
				}	
				
		}else{
			
				
			if($this->objParam->getParametro('tipo_reporte')=='no_sindicato' || $this->objParam->getParametro('tipo_reporte')=='aporte_sindicato' || $this->objParam->getParametro('tipo_reporte')=='aporte_cacsel' ){
				//var_dump($array_datos); exit;
				for ($i=0; $i<$cont;$i++){
					
					$this->Cell(18,3.5,$array_datos[$i][0],'',0,'L');
					
					$this->Cell(60,3.5,substr ( $array_datos[$i][1], 0, 32),'',0,'L');
					if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
						$this->Cell(35,3.5,$array_datos[$i][11],'',0,'L');	
						$this->Cell(65,3.5,$array_datos[$i][12],'',0,'L');	
					}
					$this->Cell(20,3.5,number_format($array_datos[$i][5],2,',','.'),'',1,'R');						
				}	
				
				    $this->Cell(18,3.5,$array_datos[$cont][0],'',0,'L');
				    $this->Cell(60,3.5,substr ( $array_datos[$cont][1], 0, 32),'',0,'L');
					if($this->objParam->getParametro('tipo_reporte')!='aporte_cacsel'){
						$this->Cell(35,3.5,$array_datos[$cont][11],'',0,'L');	
						$this->Cell(65,3.5,$array_datos[$cont][12],'',0,'L');	
					}else{
						$this->Cell(100,3.5,'','',0,'L');	
					}
					$this->Cell(20,3.5,$array_datos[$cont][5],'',1,'R');	
				
				
			}else{//salario BC y CT
				
			
				for ($i=0; $i<$cont+1;$i++){	
					     if($array_datos[$i][9]!=$gerencia){
							 	$this->Ln(2);
								$this->SetFont('','B',10);
								$this->Cell(100,3.5,''.$array_datos[$i][9],'',1,'L');
								$this->Ln(2);
								$contf=0; 
						 }
								    if(($departamento!=$array_datos[$i][10]) && ($array_datos[$i][10]!=$array_datos[$i][9])){
							 			$this->Ln(2);
							 			$this->SetFont('','B',8);
										$this->Cell(100,3.5,''.$array_datos[$i][10],'',1,'L');
										$this->Ln(2);
										$this->SetFont('','',8);
							 	
							 	    }
							 	 
		
										$this->SetFont('','',7);
										$this->Cell(18,3.5,substr ( $array_datos[$i][0], 0, 23),'',0,'L');
										
										if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
											$this->Cell(55,3.5,$array_datos[$i][1],'',0,'L');
											$this->Cell(40,3.5,substr ( $array_datos[$i][2], 0, 24),'',0,'L');
											
											$this->Cell(15,3.5,$array_datos[$i][3],'',0,'L');
										}else{
										
											$this->Cell(60,3.5,substr ( $array_datos[$i][1], 0, 38),'',0,'L');
											$this->Cell(65,3.5,substr ( $array_datos[$i][2], 0, 40),'',0,'L');
										}
										$this->Cell(10,3.5,$array_datos[$i][4],'',0,'R');
										
										if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
											if($array_datos[$i][5]!=''){	
												$this->Cell(15,3.5,number_format($array_datos[$i][5],2,',','.'),'',0,'R');
												$this->Cell(15,3.5,$array_datos[$i][6],'',0,'R');
												$this->Cell(15,3.5,$array_datos[$i][17],'',0,'R');//nomina BC y CT
												$this->Cell(15,3.5,$array_datos[$i][18],'',1,'R');//nomina BC y CT
											}
										}else{
											if($array_datos[$i][5]!=''){
												$this->Cell(20,3.5,number_format($array_datos[$i][5],2,',','.'),'',0,'R');
												$this->Cell(20,3.5,$array_datos[$i][6],'',1,'R');
											}
											
										
										}
										
								
								$gerencia=$array_datos[$i][9];
								$departamento=$array_datos[$i][10];
						
					}
				}
						
			}
		
		} 

		
	
		
		
		
			
	
	
    
}
?>