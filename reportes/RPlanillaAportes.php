<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
  #41	ETR				16.09.2019			MZM					OMISION DE SALTO DE PAGINA POR TIPO DE APORTANTE: MENOR 65, MAYOR 65, JUB55, JUB65
 *#44	ETR				18.09.2019			MZM					Adicion de totales para columnas numericas
 * 
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
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		
		
		$this->SetFont('','B',15);
		$this->SetY(20);
		if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
			$this->Cell(0,5,'APORTES AL SISTEMA INTEGRAL DE PENSIONES',0,1,'C');
		}else{
			$this->Cell(0,5,'FORMULARIO DE PAGO DE CONTRIBUCIONES',0,1,'C');
			$this->Cell(0,5,'FONDO SOLIDARIO',0,1,'C');
		}
		
		$this->SetFont('','B',10);
		
		$this->Cell(0,5,'Correspondiente al Periodo : '.$this->datos[0]['periodo'],0,1,'C');
	
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		$nombre_afp=$this->datos[0]['nombre_afp'];
		$this->Cell(0,5,''.$nombre_afp,0,1,'R');
	
		$this->SetFont('','B',6);
		$this->SetX(5);
		
			  $this->Cell(50,3.5,'Identificacion','LTR',0,'C');
			  
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
			  	$this->Cell(79,3.5,'Nombre del Empleado','LTR',0,'C');
			  }else{
			  	$this->Cell(100,3.5,'Nombre del Empleado','LTR',0,'C');
			  }
			  $this->Cell(21,3.5,'Departamento','LTR',0,'C');
			  $this->Cell(21,3.5,'Novedad','LTR',0,'C');
			  $this->Cell(8,3.5,'Dias','LTR',0,'C');
			  $this->Cell(15,3.5,'Tot.Ganado','LTR',0,'C');
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(15,3.5,'Tot.Ganado','LTR',0,'C');
				  $this->Cell(15,3.5,'Tot','LTR',0,'C');
				  $this->Cell(15,3.5,'Tot','LTR',0,'C');
				  $this->Cell(16,3.5,'Tot','LTR',0,'C');
				  $this->Cell(16,3.5,'Tot.Ganado','LTR',1,'C');
			}else{
				  $this->Cell(17,3.5,'Total Ganado','LTR',0,'C');
				  $this->Cell(17,3.5,'Total Ganado','LTR',0,'C');
				  $this->Cell(17,3.5,'Total Ganado','LTR',1,'C');
			}
		//titulo inferior
		
		
		$this->SetX(5);
		
			  $this->Cell(5,3.5,'N','LTR',0,'C');
			  $this->Cell(7,3.5,'Tipo','LTR',0,'C');
			  $this->Cell(16,3.5,'Numero','LTR',0,'C');
			  $this->Cell(7,3.5,'Ext','LTR',0,'C');
			  $this->Cell(15,3.5,'NUA','LTR',0,'C');
			  //---------
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(22,3.5,'Apellido Paterno','LTR',0,'C');
				  $this->Cell(21,3.5,'Apellido Materno','LTR',0,'C');
				  $this->Cell(17,3.5,'Primer Nombre','LTR',0,'C');
				  $this->Cell(19,3.5,'Segundo Nombre','LTR',0,'C');
			  }else{
			  	  $this->Cell(27,3.5,'Apellido Paterno','LTR',0,'C');
				  $this->Cell(27,3.5,'Apellido Materno','LTR',0,'C');
				  $this->Cell(22,3.5,'Primer Nombre','LTR',0,'C');
				  $this->Cell(24,3.5,'Segundo Nombre','LTR',0,'C');
			  }
			  //---------
			  $this->Cell(21,3.5,'','LTR',0,'C');
			  //----
			  $this->Cell(11,3.5,'Novedad','LTR',0,'C');
			  $this->Cell(10,3.5,'Fecha','LTR',0,'C');
			  //-------
			  $this->Cell(8,3.5,'Cot','LTR',0,'C');
			  //-----
			  
			   if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(15,3.5,'Cot Dep<65','LTR',0,'C');
				  //----
				  $this->Cell(15,3.5,'Cot Dep>65','LTR',0,'C');
				  //---
				  $this->Cell(15,3.5,'Jubilado<65','LTR',0,'C');
				  $this->Cell(15,3.5,'Jubilado>65','LTR',0,'C');
				  
				  $this->Cell(16,3.5,'FV','LTR',0,'C');
				  $this->Cell(16,3.5,'FS','LTR',1,'C');
			  }else{
			  	 $this->Cell(15,3.5,'Solidario','LTR',0,'C');
			  	 $this->Cell(17,3.5,'Sol(13000 Bs)','LTR',0,'C');
				  $this->Cell(17,3.5,'Sol(25000 Bs)','LTR',0,'C');
				  $this->Cell(17,3.5,'Sol(35000 Bs)','LTR',1,'C');
			  }
			  
		$this->SetX(5);
		
			  $this->Cell(5,3.5,'','LBR',0,'C');
			  $this->Cell(7,3.5,'','LBR',0,'C');
			  $this->Cell(16,3.5,'','LBR',0,'C');
			  $this->Cell(7,3.5,'','LBR',0,'C');
			  $this->Cell(15,3.5,'','LBR',0,'C');
			  //---------
			   if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(22,3.5,' ','LBR',0,'C');
				  $this->Cell(21,3.5,' ','LBR',0,'C');
				  $this->Cell(17,3.5,' ','LBR',0,'C');
				  $this->Cell(19,3.5,' ','LBR',0,'C');
			  }else{
			  	  $this->Cell(27,3.5,'','LBR',0,'C');
				  $this->Cell(27,3.5,'','LBR',0,'C');
				  $this->Cell(22,3.5,'','LBR',0,'C');
				  $this->Cell(24,3.5,'','LBR',0,'C');
			  }
			  //---------
			  $this->Cell(21,3.5,'','LBR',0,'C');
			  //----
			  $this->Cell(11,3.5,'I/R/L/S','LBR',0,'C');
			  $this->Cell(10,3.5,'Novedad','LBR',0,'C');
			  //-------
			  $this->Cell(8,3.5,'','LBR',0,'C');
			  //-----
			  $this->Cell(15,3.5,'','LBR',0,'C');
			  //----
			  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
				  $this->Cell(15,3.5,'','LBR',0,'C');
				  //---
				  $this->Cell(15,3.5,'','LBR',0,'C');
				  $this->Cell(15,3.5,'','LBR',0,'C');
				  
				  $this->Cell(16,3.5,'','LBR',0,'C');
				  $this->Cell(16,3.5,'','LBR',1,'C');
			}else{
				  $this->Cell(17,3.5,'','LBR',0,'C');
				  $this->Cell(17,3.5,'','LBR',0,'C');
				  $this->Cell(17,3.5,'','LBR',1,'C');
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
						$dias=30;     
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
								  $fecha_novedad=$this->datos[$i]['fecha_ingreso'];
								  $dias=$this->datos[$i]['dias_ingreso'];
							  }
							  if($this->datos[$i]['fecha_finalizacion']!=''){
							  	  $novedad='R';
								  $fecha_novedad=$this->datos[$i]['fecha_finalizacion'];
								  $dias=$this->datos[$i]['dias_retiro'];
							  }
							  
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
							  }else{
							  	$array_datos[$cont][13]=round($this->datos[$i]['valor'],2);
							  	if($this->datos[$i]['valor']>13000){
							  		$array_datos[$cont][15]=round($this->datos[$i]['valor']-13000,2);
							  	
							  	}else{
							  		$array_datos[$cont][15]=0.00;
							  	
							  	}
							  	
							  	if($this->datos[$i]['valor']>25000){
							  		$array_datos[$cont][16]=round($this->datos[$i]['valor']-25000,2);
							  	
							  	}else{
							  		$array_datos[$cont][16]=0.00;
							  	
							  	}
							  	
							  	if($this->datos[$i]['valor']>35000){
							  		$array_datos[$cont][17]=round($this->datos[$i]['valor']-35000,2);
							  	
							  	}else{
							  		$array_datos[$cont][17]=0.00;
							  	
							  	}
							  	
							  }  
							  $array_datos[$cont][14]=$this->datos[$i]['tipo_jubilado'];
					
					$cont++;
				}


			
		$this->SetX(5);
		
		/***********************************************/
		$tot13=0;
		$tot15=0;
		$tot16=0;
		$tot17=0;
		$tot18=0;
		$tot19=0;
		
		   $code=$array_datos[0][14]; 
			for ($i=0; $i<$cont;$i++){
			  	
				/*if($code!=$array_datos[$i][14])	{
					  $this->AddPage();
					  $this->SetX(5);
					  $this->Cell(5,3.5,$array_datos[$i][0],'',0,'R');
					  $this->Cell(7,3.5,$array_datos[$i][1],'',0,'L');
					  $this->Cell(16,3.5,$array_datos[$i][2],'',0,'R');
					  $this->Cell(7,3.5,$array_datos[$i][3],'',0,'L');
					  $this->Cell(16,3.5,$array_datos[$i][4],'',0,'R');
					  //---------
					  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
					  
						  $this->Cell(22,3.5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(22,3.5,$array_datos[$i][6],'',0,'L');
						  $this->Cell(17,3.5,$array_datos[$i][7],'',0,'L');
						  $this->Cell(19,3.5,$array_datos[$i][8],'',0,'L');
					  }else{
					  	  $this->Cell(27,3.5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(27,3.5,$array_datos[$i][6],'',0,'L');
						  $this->Cell(22,3.5,$array_datos[$i][7],'',0,'L');
						  $this->Cell(24,3.5,$array_datos[$i][8],'',0,'L');
					  }
					  //---------
					  $this->Cell(21,3.5,$array_datos[$i][9],'',0,'L');
					  //----
					  $this->Cell(11,3.5,$array_datos[$i][10],'',0,'L');
					  $this->Cell(10,3.5,$array_datos[$i][11],'',0,'C');
					  //-------
					  $this->Cell(8,3.5,$array_datos[$i][12],'',0,'R');
					  //-----
					  $this->Cell(15,3.5,number_format($array_datos[$i][13],2,',','.'),'',0,'R');
					 if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
					
						  $this->Cell(15,3.5,number_format($array_datos[$i][15],2,',','.'),'',0,'R');
						  //---
						  $this->Cell(15,3.5,number_format($array_datos[$i][16],2,',','.'),'',0,'R');
						  $this->Cell(15,3.5,number_format($array_datos[$i][17],2,',','.'),'',0,'R');
						  $this->Cell(15,3.5,number_format($array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17],2,',','.'),'',0,'R');
						  $this->Cell(15,3.5,number_format($array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17],2,',','.'),'',1,'R');
					  }else{
					  	  $this->Cell(17,3.5,number_format($array_datos[$i][15],2,',','.'),'',0,'R');
						  //---
						  $this->Cell(17,3.5,number_format($array_datos[$i][16],2,',','.'),'',0,'R');
						  $this->Cell(17,3.5,number_format($array_datos[$i][17],2,',','.'),'',1,'R');
					  }				
				}else{*/
										
					
					  $this->Cell(5,3.5,$array_datos[$i][0],'',0,'R');
					  $this->Cell(7,3.5,$array_datos[$i][1],'',0,'L');
					  $this->Cell(16,3.5,$array_datos[$i][2],'',0,'R');
					  $this->Cell(7,3.5,$array_datos[$i][3],'',0,'L');
					  $this->Cell(15,3.5,$array_datos[$i][4],'',0,'R');
					  //---------
					 if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
					  
						  $this->Cell(22,3.5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(21,3.5,$array_datos[$i][6],'',0,'L');
						  $this->Cell(17,3.5,$array_datos[$i][7],'',0,'L');
						  $this->Cell(19,3.5,$array_datos[$i][8],'',0,'L');
					  }else{
					  	  $this->Cell(27,3.5,$array_datos[$i][5],'',0,'L');
						  $this->Cell(27,3.5,$array_datos[$i][6],'',0,'L');
						  $this->Cell(22,3.5,$array_datos[$i][7],'',0,'L');
						  $this->Cell(24,3.5,$array_datos[$i][8],'',0,'L');
					  }
					  //---------
					  $this->Cell(21,3.5,$array_datos[$i][9],'',0,'L');
					  //----
					  $this->Cell(11,3.5,$array_datos[$i][10],'',0,'L');
					  $this->Cell(10,3.5,$array_datos[$i][11],'',0,'C');
					  //-------
					  $this->Cell(8,3.5,$array_datos[$i][12],'',0,'R');
					  //-----
					  $this->Cell(15,3.5,number_format($array_datos[$i][13],2,',','.'),'',0,'R');
					  $tot13=$tot13+$array_datos[$i][13];
					  $tot15=$tot15+$array_datos[$i][15];
					  $tot16=$tot16+$array_datos[$i][16];
					  $tot17=$tot17+$array_datos[$i][17];
					  //----
					  if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
					
						  $this->Cell(15,3.5,number_format($array_datos[$i][15],2,',','.'),'',0,'R');
						  //---
						  $this->Cell(15,3.5,number_format($array_datos[$i][16],2,',','.'),'',0,'R');
						  $this->Cell(15,3.5,number_format($array_datos[$i][17],2,',','.'),'',0,'R');
						  $tot18=$tot18+$array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17];
						  $tot19=$tot19+$array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17];
						  $this->Cell(16,3.5,number_format($array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17],2,',','.'),'',0,'R');
						  $this->Cell(16,3.5,number_format($array_datos[$i][13]+$array_datos[$i][15]+$array_datos[$i][16]+$array_datos[$i][17],2,',','.'),'',1,'R');
					  }else{
					  	  $this->Cell(17,3.5,number_format($array_datos[$i][15],2,',','.'),'',0,'R');
						  //---
						  $this->Cell(17,3.5,number_format($array_datos[$i][16],2,',','.'),'',0,'R');
						  $this->Cell(17,3.5,number_format($array_datos[$i][17],2,',','.'),'',1,'R');
					  }
			 // }
				//$code=$array_datos[$i][14];	
				
			}
 			//totales #44
 			$this->SetFont('','B',7);
 			$this->SetLineWidth(0.2);
	 	 	$this->SetDrawColor(0,0,0);
			$this->Cell(0,0,'','B',1);
 			if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
 				$this->Cell(176,3.5,'TOTALES','',0,'R');
				$this->Cell(3,3.5,'','',0,'R');
				$this->Cell(15,3.5,number_format($tot13,2,',','.'),'',0,'R');
				$this->Cell(15,3.5,number_format($tot15,2,',','.'),'',0,'R');
				$this->Cell(15,3.5,number_format($tot16,2,',','.'),'',0,'R');
				$this->Cell(15,3.5,number_format($tot17,2,',','.'),'',0,'R');
				$this->Cell(16,3.5,number_format($tot18,2,',','.'),'',0,'R');
				$this->Cell(16,3.5,number_format($tot19,2,',','.'),'',1,'R');
				
			}else{
				
				$this->Cell(197,3.5,'TOTALES','',0,'R');
				$this->Cell(3,3.5,'','',0,'R');
				$this->Cell(15,3.5,number_format($tot13,2,',','.'),'',0,'R');
				$this->Cell(17,3.5,number_format($tot15,2,',','.'),'',0,'R');
				$this->Cell(17,3.5,number_format($tot16,2,',','.'),'',0,'R');
				$this->Cell(17,3.5,number_format($tot17,2,',','.'),'',1,'R');
			}
				
		
		
		}
		
		
			
	
	
    
}
?>