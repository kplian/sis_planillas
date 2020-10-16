<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion
 #66	ETR				15.10.2019			MZM					Adicion de tipo contrato
 #77	ETR				20.11.2019			MZM					Uniformizacion de tamaño de letra
 #80	ETR				25.11.2019			MZM					Reporte Bono Desc
 #83	MZM(ETR)		10.12.2019				Habilitacion de opcion historico de planilla 
 #90	ETR				15.01.2019			MZM					cambio de dato matricula_dep por edad_dep
 #98	ETR				30.03.2020  		MZM					Adicion de opciones estado_funcionario (activo, retirado, todos)
 #123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019)
 #161	ETR				07.09.2020			MZM-KPLIAN			Ajuste en encabezado, quitando tipo contrato planta
 #ETR-1379				16.10.2020			MZM-KPLIAN 			Modificacion reporte grupo familiar, genero del depediente
*/
class REmpleadoDep extends  ReportePDF {
	var $datos;	
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;
	var $datos_titulo;	
	var $borde;
	var $interlineado;
	
	function Header() { 
		if (count($this->datos)>0){
			
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
		//#83
		$this->SetFont('','B',7);
		$dr=substr($this->datos_titulo[0]['fecha_backup'],0,2);
		$mr=substr($this->datos_titulo[0]['fecha_backup'],3,2);
		$ar=substr($this->datos_titulo[0]['fecha_backup'],6);
		if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
			$this->Cell(0, 3, '', '', 0, 'R');
			$this->Cell(0, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'R');
		}else{
			$this->Cell(0, 3, '', '', 1, 'R');
		}
		
		$this->Ln(15);	
		$this->SetFont('','B',12);
		//#66
		$nombre_tc=$this->objParam->getParametro('nombre_tipo_contrato');
		if($nombre_tc=='Planta') $nombre_tc=''; //#161
		if($nombre_tc!=''){
			//#98
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$nombre_tc=' ('.$nombre_tc.' - '.$this->objParam->getParametro('personal_activo').')';
			}else{
				$nombre_tc='('.$nombre_tc.')';
			}
			
			
		}else{
			//#98
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
				$nombre_tc=' ('.$this->objParam->getParametro('personal_activo').')';
			}
		}
		
		if($this->objParam->getParametro('tipo_reporte')=='dependientes'){	
			$this->Cell(0,5,'NOMINA DE PERSONAL Y DEPENDIENTES'.$nombre_tc,0,1,'C');//#66
		}elseif($this->objParam->getParametro('tipo_reporte')=='dependientes_edad'){
			$this->Cell(0,5,'GRUPO FAMILIAR DE LOS TRABAJADORES'.$nombre_tc,0,1,'C');//#66
			$this->SetFont('','B',10);
			$this->Cell(0,5,'Clasificación de los hijos según edades',0,1,'C');
			
		}
		else
		
		{
			$this->Cell(0,5,$this->datos_titulo[0]['titulo_reporte'].$nombre_tc,0,1,'C');//#80
			$this->SetFont('','B',10);
			$this->Cell(0,5,'Correspondiente a: '.$this->datos_titulo[0]['periodo_lite'],0,1,'C');//#80
		}
		
		$this->Ln(4);			
		//Titulos de columnas superiores
		//#80
		$this->borde='';
		if($this->datos_titulo[0]['bordes']==1){
			$this->borde='TBLR';
		}
		
		$this->interlineado=$this->datos_titulo[0]['interlineado'];
		
		$this->SetX(10);
		$this->alto_header =$this->GetY(); 
		}//#123
		else{
			$this->SetFont('','B',12);
			$this->Cell(0,5,'SIN DATOS PARA MOSTRAR','',1,'C');//*****	
		}
	}
	function setDatos($datos,$datos_titulo) {
		$this->datos = $datos;
		$this->datos_titulo = $datos_titulo;
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$array_datos;
		$this->SetY($this->alto_header+2); 
		$this->SetFont('','',8);
		$this->SetMargins(20,35, 5);
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
				 	  	  $this->Cell(20,5,'Codigo Emp','LT',0,'L');
						  $this->SetFont('','',8);
				 	  	  $this->Cell(30,5,$this->datos[$i]['codigo'],'T',0,'L');
						  
						  $this->SetFont('','B',8);
						  $this->Cell(28,5,'Nombre Completo','T',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(65,5,$this->datos[$i]['nombre_funcionario'],'T',0,'L');
						  
						  $this->SetFont('','B',8);
						  $this->Cell(20,5,'Fecha Ingreso','T',0,'L');
						  $this->SetFont('','',8);
									 
						  $this->Cell(17,5,substr($this->datos[$i]['fecha_ingreso'],8,2).'/'.substr($this->datos[$i]['fecha_ingreso'],5,2).'/'.substr($this->datos[$i]['fecha_ingreso'],0,4),'TR',1,'L');
				 	  	 
						 
						  $this->SetFont('','B',8);
				 	  	  $this->Cell(20,5,'Edad','LB',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(50,5,$this->datos[$i]['historia_clinica'],'B',0,'L');
						  
						  
						  $this->SetFont('','B',8);
						  $this->Cell(18,5,'# Matricula','B',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(55,5,$this->datos[$i]['matricula'],'B',0,'L');
						  
						  $this->SetFont('','B',8);
						  $this->Cell(20,5,'Fecha Nac.','B',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(17,5,substr($this->datos[$i]['fecha_nacimiento'],8,2).'/'.substr($this->datos[$i]['fecha_nacimiento'],5,2).'/'.substr($this->datos[$i]['fecha_nacimiento'],0,4),'BR',1,'L');
				 	  	 
						  
						  $this->Ln(2); 
				 	  	  $this->SetFont('','B',8);
						  $this->Cell(15,5,'','',0,'C');
						  $this->Cell(20,5,'Tipo Dep','',0,'C');
						  $this->Cell(75,5,'Nombre Dependiente','',0,'C');
						  $this->Cell(30,5,'Fecha Nacimiento','',0,'C');
				 	  	  //$this->Cell(30,5,'Hist. Clinica','',0,'C');
						  $this->Cell(30,5,'Edad','',1,'C');//#90
						  
						  $this->SetFont('','',8);
						  $this->Cell(15,5,'','',0,'C');//#909
						  $this->Cell(20,5,$this->datos[$i]['relacion'],'',0,'C');
						  $this->Cell(10,5,'','',0,'C');
						  $this->Cell(65,5,$this->datos[$i]['nombre_dep'],'',0,'L');
						  $this->Cell(30,5,substr($this->datos[$i]['fecha_nacimiento_dep'],8,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],5,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],0,4),'',0,'C');
				 	  	  //$this->Cell(30,5,$this->datos[$i]['historia_clinica_dep'],'',0,'C');
						  $this->Cell(30,5,$this->datos[$i]['edad_dep'],'',1,'C');//#90
						  
						  
				 	  }else{
				 	  	
				 	  	    
				 	  	  $this->SetFont('','',8);
						  $this->Cell(15,5,'','',0,'C');
						  $this->Cell(20,5,$this->datos[$i]['relacion'],'',0,'C');
						  $this->Cell(10,5,'','',0,'C');
						  $this->Cell(65,5,$this->datos[$i]['nombre_dep'],'',0,'L');
						  $this->Cell(30,5,substr($this->datos[$i]['fecha_nacimiento_dep'],8,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],5,2).'/'.substr($this->datos[$i]['fecha_nacimiento_dep'],0,4),'',0,'C');
				 	  	  //$this->Cell(30,5,$this->datos[$i]['historia_clinica_dep'],'',0,'C');
						  $this->Cell(30,5,$this->datos[$i]['edad_dep'],'',1,'C');//#90
				 	  	 
				
		
				 	  }
						$id_persona=$this->datos[$i]['id_persona'];
				}
			}elseif ($this->objParam->getParametro('tipo_reporte')=='detalle_bono_desc'){//#80
				
				for ($i=0; $i<count($this->datos);$i++){
				   
				 	  if($id_persona!=$this->datos[$i]['id_funcionario']){
				 	      $this->Ln(5); 
						  $this->SetFont('','B',8);
				 	  	  $this->Cell(20,$this->interlineado,'Codigo Emp','LTB',0,'L');
						  $this->SetFont('','',8);
				 	  	  $this->Cell(30,$this->interlineado,$this->datos[$i]['codigo'],'TB',0,'L');
						  
						  $this->SetFont('','B',8);
						  $this->Cell(28,$this->interlineado,'Nombre Completo','TB',0,'L');
						  $this->SetFont('','',8);
						  $this->Cell(107,$this->interlineado,$this->datos[$i]['nombre'],'TBR',0,'L');
						  
						  
						  $this->Ln(5); 
						  
				 	  	  $this->SetFont('','B',8);
						  $this->Cell(20,$this->interlineado,'Codigo','',0,'C');
						  $this->Cell(75,$this->interlineado,'Bono/Descuento','',0,'C');
						  $this->Cell(30,$this->interlineado,'Valor','',0,'C');
				 	  	  $this->Cell(30,$this->interlineado,'Fecha Inicio','',0,'C');
						  $this->Cell(30,$this->interlineado,'Fecha Fin','',1,'C');
						  
						  $this->SetFont('','',8);
						  $this->Cell(20,$this->interlineado,$this->datos[$i]['codigo_columna'],$this->borde,0,'C');
						  //$this->Cell(10,$this->interlineado,'','',0,'C');
						  $this->Cell(75,$this->interlineado,$this->datos[$i]['nombre_columna'],$this->borde,0,'L');
						  $this->Cell(30,$this->interlineado,number_format($this->datos[$i]['valor'],2,'.',','),$this->borde,0,'R');
						   
				 	  	  $this->Cell(30,$this->interlineado,date_format(date_create($this->datos[$i]['fecha_ini']),'d/m/Y'),$this->borde,0,'C');
						  if($this->datos[$i]['fecha_fin']!=''){
						    $this->Cell(30,$this->interlineado,date_format(date_create($this->datos[$i]['fecha_fin']),'d/m/Y'),$this->borde,1,'C');	
						  }else{
						  	$this->Cell(30,$this->interlineado,$this->datos[$i]['fecha_fin'],$this->borde,1,'C');
						  }
						  
						  
						  
				 	  }else{
				 	  	
				 	  	    
				 	  	  $this->SetFont('','',8);
						  $this->Cell(20,$this->interlineado,$this->datos[$i]['codigo_columna'],$this->borde,0,'C');
						 // $this->Cell(10,$this->interlineado,'','',0,'C');
						  $this->Cell(75,$this->interlineado,$this->datos[$i]['nombre_columna'],$this->borde,0,'L');
						  $this->Cell(30,$this->interlineado,number_format($this->datos[$i]['valor'],2,'.',','),$this->borde,0,'R');
				 	  	  $this->Cell(30,$this->interlineado,date_format(date_create($this->datos[$i]['fecha_ini']),'d/m/Y'),$this->borde,0,'C');
						  if($this->datos[$i]['fecha_fin']!=''){
						    $this->Cell(30,$this->interlineado,date_format(date_create($this->datos[$i]['fecha_fin']),'d/m/Y'),$this->borde,1,'C');	
						  }else{
						  	$this->Cell(30,$this->interlineado,$this->datos[$i]['fecha_fin'],$this->borde,1,'C');
						  }
				
		
				 	  }
						$id_persona=$this->datos[$i]['id_funcionario'];
				}
				
				
			}
			
			else{
				$this->Ln(5);
				$this->SetX(20); 
				$rango='-1';
				$rango_ini=$this->objParam->getParametro('rango_ini');
				$rango_fin=$this->objParam->getParametro('rango_fin');
				for ($i=0; $i<count($this->datos);$i++){
		    
					 if($this->datos[$i]['rango']!=$rango){
					 	$this->Ln(2);
						$this->SetFont('','B',10);
						$this->Cell(180,5,'Rango Edad '.$this->datos[$i]['rango'],'LBTR',1,'L');
						$this->Ln(2);
						$this->SetFont('','B',8);
						$this->Cell(15,5,'Fecha Nac',0,0,'L');
						$this->Cell(60,5,'Nombre Dependiente',0,0,'L');
						$this->Cell(10,5,'Edad',0,0,'L');
						$this->Cell(10,5,'Sexo',0,0,'L');//#ETR-1379
						$this->Cell(60,5,'Nombre del trabajador',0,0,'L');
						
						$this->Cell(35,5,'Distrito',0,1,'L');
									
						$this->SetFont('','',8);//#77(20.11.19)
						$this->Cell(15,5,$this->datos[$i]['fecha_nacimiento_dep'],0,0,'L');
						$this->Cell(60,5,mb_strcut($this->datos[$i]['nombre_dep'],0,30, "UTF-8"),0,0,'L');
						$this->Cell(10,5,$this->datos[$i]['edad_dep'],0,0,'R');
						$this->Cell(10,5,$this->datos[$i]['genero'],0,0,'L');//#ETR-1379
						$this->Cell(60,5,mb_strcut($this->datos[$i]['nombre_funcionario'],0,30, "UTF-8"),0,0,'L');
						
						$this->Cell(35,5,mb_strcut($this->datos[$i]['distrito'],0,18, "UTF-8"),0,1,'L');
					 }else{
					 	$this->SetFont('','',8);//#77(20.11.19)
						$this->Cell(15,5,$this->datos[$i]['fecha_nacimiento_dep'],0,0,'L');
						$this->Cell(60,5,mb_strcut($this->datos[$i]['nombre_dep'],0,30, "UTF-8"),0,0,'L');
						$this->Cell(10,5,$this->datos[$i]['edad_dep'],0,0,'R');
						$this->Cell(10,5,$this->datos[$i]['genero'],0,0,'L');
						$this->Cell(60,5,mb_strcut($this->datos[$i]['nombre_funcionario'],0,30, "UTF-8"),0,0,'L');
						
						$this->Cell(35,5,mb_strcut($this->datos[$i]['distrito'],0,18, "UTF-8"),0,1,'L');
					 }
					 $rango=$this->datos[$i]['rango'];
				}
				
			}
					
			
		
		} 

		
    
}
?>