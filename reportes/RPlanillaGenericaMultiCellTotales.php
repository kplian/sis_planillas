<?php
// Extend the TCPDF class to create custom MultiRow
//ISSUE			AUTHOR			FECHA				DESCRIPCION	  		
//#33			etr-MZM		02.09.2019				reporte multilinea pro totales
//#40 			MZM			16/09/2019	        	Modificacion a formato de cabecera en reporte totales multicel
//#50			MZM			24.09.2019				Ajuste de forma en reporte: omitir en titulo centro, quitar autollenado de 0	
//#83	ETR		MZM			10.12.2019				Habilitacion de opcion historico de planilla
//#97	ETR		MZM			27.02.2020				Ajuste a nombre de variable para subtitulo de planillas por mes (planilla de sueldos)
//#98	ETR		MZM			26.03.2020				Adecuacion para generacion de reporte consolidado (caso planilla reintegros)
//#148	ETR		MZM-KPLIAN	06.07.2020				Omision de tipo_contrato "Planta" en titulo de reporte
//#ETR-1361		MZM-KPLIAN	14.10.2020				Adicion de regional en reporte multilinea por distrito 
class RPlanillaGenericaMultiCellTotales extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $datos_firma;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $max_fila;
	var $max_columna;
	var $fila;
	var $detalle_col_mod=array();
	
	var $detalle_col;
	var $espacio_previo;
	var $cant_espacios;
	var $cant_col;
	var $cant_fil;
	var $id_fun0;
	var $posY;
	var $ancho_col;
	var $alto_grupo;
	var $tipo_ordenacion='';
	function Header() {
		//#50  
		if($this->datos_titulo['ordenar_por']=='centro'){//#17
			//$this->tipo_ordenacion='CENTRO ';
		}//fin #17
		
		$max_fila=2; $this->max_columna=0;
		$espacio_previo=0;
		$cant_espacios=0;
		$this->cant_col=0;
		$this->cant_fil=0;
		$ancho_col=35;
		$tipo_con='';
		$nro_pla='';
		//cabecera del reporte
		//$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja-10, 5, 30, 10);
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 5, 30, 15);
		$this->SetFont('','B',7);
	    if(  $this->objParam->getParametro('tipo_contrato')!='' &&  $this->objParam->getParametro('tipo_contrato')!=null &&  $this->objParam->getParametro('tipo_contrato')!='PLA'  ){//#148
	    	if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
		 		$tipo_con=' ('.$this->datos_detalle[0]['nombre'].' - '.$this->objParam->getParametro('personal_activo').')';
		 	}else{
		 		$tipo_con=' ('.$this->datos_detalle[0]['nombre'].')';
		 	}
	    	
			$nro_pla='No ' .$this->datos_titulo['nro_planilla'];
	    }else{
	    	if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
		 		$tipo_con='('.$this->objParam->getParametro('personal_activo').')';
			 }
	    }
		$this->Ln(1);
		$this->Ln(1);
		$this->Cell($this->ancho_hoja-30, 3, '', '', 0, 'R');
		$this->Cell(30,3,$this->datos_titulo['depto'],'',1,'C');
		$this->Cell($this->ancho_hoja-30, 3, '', '', 0, 'R');
		$this->Cell(30,3,$this->datos_titulo['uo'],'',1,'C');
		
		$this->Cell($this->ancho_hoja-20, 3, '', '', 0, 'R');
		$di=$this->getAliasNumPage(); $df=$this->getAliasNbPages();
		$xx='Pagina '.$di.' de '.$df;
		$this->Cell(20,3, ''.$xx, '', 1, 'C');
		
		//#83
		$dr=substr($this->datos_titulo['fecha_backup'],0,2);
		$mr=substr($this->datos_titulo['fecha_backup'],3,2);
		$ar=substr($this->datos_titulo['fecha_backup'],6);
		if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
			$this->Cell($this->ancho_hoja-30, 3, '', '', 0, 'R');
			$this->Cell(30, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'C');
		}else{
			$this->Cell($this->ancho_hoja-30, 3, '', '', 1, 'R');
		}
		
		$this->SetFont('','B',12);
		$this->Cell(0,5,str_replace ( 'Multilinea' ,'', $this->datos_titulo['titulo_reporte']).$tipo_con,0,1,'C');
		$this->SetFont('','B',10);
		if($this->datos_titulo['periodo']>0){//#97
			$this->Cell(0,5,'Correspondiente al mes de '.$this->datos_titulo['periodo_lite'],0,1,'C');
		}else{
			$this->Cell(0,5,'GESTION '.$this->datos_titulo['gestion'],0,1,'C');
		}
		//$this->Cell(0,5, $nro_pla,0,1,'C');
		$this->SetFont('','B',10);
		//$this->gerencia=$this->datos_detalle[0]['nombre_unidad'];
		if ($this->datos_detalle[0]['regional']!=''){//#ETR-1361
				if($this->regional==''){
					$this->regional=$this->datos_detalle[0]['regional'];
				}
				 
				$this->Cell(0,5,$this->regional,0,1,'L');
				$this->SetFont('','B',8);
				$this->Cell(0,5,$this->tipo_ordenacion.$this->gerencia,0,1,'L');
				$this->Ln(-5);
			}else{$this->Cell(0,5,$this->tipo_ordenacion.$this->gerencia,0,1,'L');}
			
		$this->Ln(2);
		$this->SetFont('','B',8);
		
		
			$columnas=0;
			$fila=0;
			$this->SetFont('helvetica', 'N', 7);
			//$detalle_col=$this->datos_detalle[1];
			$id_funcionario = $this->datos_detalle[0]['id_funcionario'];
			
			$this->id_fun0=$id_funcionario;
			$this->alto_grupo=$this->GetY();
			$detalle_col_mod=array();
			foreach($this->datos_detalle as $value) {
				if($id_funcionario!=$value['id_funcionario']) break;
				else{
					array_push($detalle_col_mod,$value['id_funcionario']);
					array_push($detalle_col_mod,$value['espacio_previo']);
					array_push($detalle_col_mod,$value['titulo_reporte_superior'].' '.$value['titulo_reporte_inferior']);
					array_push($detalle_col_mod,'B');
					array_push($detalle_col_mod,'0');
					array_push($detalle_col_mod,'R');
				}
			}
			
			$this->SetFont('','B',7);
			$this->grillaDatos($detalle_col_mod,$alto=$this->alto_grupo,0, $this->datos_titulo['num_columna_multilinea']);
			$this->ln(1);
			$this->SetLineWidth(0.1);
 	 		$this->SetDrawColor(0,0,0);
			$this->Cell(0,0,'','B',1);
			$this->posY=$this->GetY();
			$this->alto_grupo=$this->posY-$this->alto_grupo;
	}
	function datosHeader ($titulo, $detalle,$firmas) { 
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT;
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		$this->datos_firma=$firmas;
		//Titulo>s de columnas inferiores e iniciacion de los arreglos para la tabla
		$this->ancho_sin_totales = 0;
		$this->cantidad_columnas_estaticas = 0;
		$this->SetMargins(5,$this->GetY()+($this->datos_titulo['cantidad_columnas']/$this->datos_titulo['num_columna_multilinea']*9), 5);
	}
	function generarReporte() { 
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$this->SetY($this->GetY()+ $this->getHeightV2($this->datos_detalle[0]['id_funcionario'],1)+($this->datos_titulo['cantidad_columnas']/$this->datos_titulo['num_columna_multilinea']*2));
		
		
	
		$this->SetMargins(5,$this->alto_grupo*2, 5);
		//iniciacion de datos 
		$id_funcionario = $this->datos_detalle[0]['id_funcionario'];
		$this->regional=$this->datos_detalle[0]['regional'];//#ETR-1361
		$this->gerencia=$this->datos_detalle[0]['gerencia'];
		
		$this->id_fun0=$id_funcionario;
		$sum_subtotal = array();
		$sum_total = array();
		
		$empleados_gerencia = 0;
		$empleados_regional = 0;//#ETR-1361
		$this->numeracion=1;
		$this->ancho_col=35;
		$array_show = array(); 
		array_push($this->tablewidths, $this->ancho_col); 
		
		for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
			$sum_subtotal_regional[$i]=0;//#ETR-1361
	 		$sum_subtotal[$i]=0;
			$sum_total[$i]=0;
		}
		$columnas = 0;
		$fila=0;
		$detalle_col_mod=array();
		$this->SetFont('','',6);
		$linea=0;
		
		$subtotal=array();	
		$cant_centro=0;
		$this->alto_grupo=$this->posY;
		setlocale(LC_MONETARY, 'it_IT');
		for ($i=0; $i< sizeof($this->datos_detalle); $i++ ){
			
			if($this->gerencia!=$this->datos_detalle[$i]['gerencia']){
				$this->SetFont('','',6);
				$cant_centro++;
				$this->SetY($this->posY);
					
				$this->SetFont('','B',8);
			//	$this->Cell(0,0,'Sub Total:'.$this->tipo_ordenacion.$this->gerencia,'',1);
				$this->Cell(30,3,'# Empl.' . $empleados_gerencia,'',1,'L');
				$this->SetFont('','',8);
						
				
				$this->subtotales($detalle_col_mod,$sum_subtotal);
				
				
				
				$columnas=0;
				for ($m = 0; $m < $this->datos_titulo['cantidad_columnas']; $m++) {
		
				 		$sum_subtotal[$m]=0;
						
					}
				if($this->regional!=$this->datos_detalle[$i]['regional']){//#ETR-1361
					$this->SetY($this->GetY()+5);
				
				    $dimensions_h = $this->getPageDimensions();
						if ($this->GetY()+$this->alto_grupo+$dimensions_h['bm']+3> $dimensions_h['hk']){
							$this->AddPage();
							$this->ln(-4);
						}else{
							$this->ln(2);
							$this->SetDrawColor(0,0,0);
							$this->SetLineWidth(0.2);
							$this->Cell(0,0,'','B',1);
							$this->Cell(0,0,'','B',1);
						}
					$this->SetFont('','B',8);
					$this->Cell(0,0,'Total:'.$this->regional,'',1);
					$this->Cell(30,3,'# Empl.' . $empleados_regional,'',1,'L');
					
					$this->subtotales($detalle_col_mod,$sum_subtotal_regional);
					$this->SetFont('','',8);
					for ($m = 0; $m < $this->datos_titulo['cantidad_columnas']; $m++) {
		
				 		$sum_subtotal_regional[$m]=0;
						
					}
					$empleados_regional=0;
				}
				$this->regional=$this->datos_detalle[$i]['regional'];//#ETR-1361
				
				$this->gerencia=$this->datos_detalle[$i]['gerencia'];
				$empleados_gerencia=0;
				$detalle_col_mod=array();
				$this->AddPage();
				
				array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
				array_push($detalle_col_mod, $this->datos_detalle[$i]['espacio_previo']);
				
				
				if ($this->datos_detalle[$i]['codigo_columna']!='fecha_ingreso' &&
					$this->datos_detalle[$i]['codigo_columna']!='codigo_funcionario' &&
					$this->datos_detalle[$i]['codigo_columna']!='cargo' &&
					$this->datos_detalle[$i]['codigo_columna']!='nivel' &&
					$this->datos_detalle[$i]['codigo_columna']!='fecha_nacimiento' &&
					$this->datos_detalle[$i]['codigo_columna']!='nombre_funcionario' 
				
				 ){
				 	
				 	if($this->datos_detalle[$i]['valor_columna']>0){//#50
						 		array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor_columna'],2,'.',','));	
				 	}else{
				 		array_push($detalle_col_mod, '');
				 	}
				 	
				 }
				else{
					array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);
				}
				array_push($detalle_col_mod,'');
				array_push($detalle_col_mod,'0');
				array_push($detalle_col_mod,'R');
				if($this->datos_detalle[$i]['sumar_total']=='si') {
				    
					$sum_subtotal[$columnas]=($sum_subtotal[$columnas]+$this->datos_detalle[$i]['valor_columna']);
					$sum_total[$columnas]=($sum_total[$columnas]+$this->datos_detalle[$i]['valor_columna']);
					$sum_subtotal_regional[$columnas]=($sum_subtotal_regional[$columnas]+$this->datos_detalle[$i]['valor_columna']);//#ETR-1361
				}
				
			
				$columnas++;
			}else{
				
				if($id_funcionario!=$this->datos_detalle[$i+1]['id_funcionario'] ){
					
					
					array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
					array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
					
						if ($this->datos_detalle[$i]['codigo_columna']!='fecha_ingreso' &&
							$this->datos_detalle[$i]['codigo_columna']!='codigo_funcionario' &&
							$this->datos_detalle[$i]['codigo_columna']!='cargo' &&
							$this->datos_detalle[$i]['codigo_columna']!='nivel' &&
							$this->datos_detalle[$i]['codigo_columna']!='fecha_nacimiento' &&
							$this->datos_detalle[$i]['codigo_columna']!='nombre_funcionario' 
						
						 ){
						 	
						 	if($this->datos_detalle[$i]['valor_columna']>0){//#50
						 		array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor_columna'],2,'.',','));	
						 	}else{
						 		array_push($detalle_col_mod, '');
						 	}
						 	
						 }
						else{
							array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);
						}
					array_push($detalle_col_mod,'');
					array_push($detalle_col_mod,'1');
					array_push($detalle_col_mod,'R');
					
					$id_funcionario=$this->datos_detalle[$i+1]['id_funcionario'];
					
					
				}else{
					$id_funcionario=$this->datos_detalle[$i]['id_funcionario'];
					array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
					array_push($detalle_col_mod, $this->datos_detalle[$i]['espacio_previo']);
						if ($this->datos_detalle[$i]['codigo_columna']!='fecha_ingreso' &&
						$this->datos_detalle[$i]['codigo_columna']!='codigo_funcionario' &&
						$this->datos_detalle[$i]['codigo_columna']!='cargo' &&
						$this->datos_detalle[$i]['codigo_columna']!='nivel' &&
						$this->datos_detalle[$i]['codigo_columna']!='fecha_nacimiento' &&
						$this->datos_detalle[$i]['codigo_columna']!='nombre_funcionario' 
					
						 ){
						 	
						 	if($this->datos_detalle[$i]['valor_columna']>0){//#50
						 		array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor_columna'],2,'.',','));	
						 	}else{
						 		array_push($detalle_col_mod, '');
						 	}
						 	
						 }
						else{
							array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);
						}
					array_push($detalle_col_mod,'');
					array_push($detalle_col_mod,'0');
					array_push($detalle_col_mod,'R');
					
					
				}
				
			    			
				if(($columnas==($this->datos_titulo['cantidad_columnas'])) ){
					$columnas=0; 
				}
				
				
				if($this->datos_detalle[$i]['sumar_total']=='si') {

					$sum_subtotal[$columnas] =($sum_subtotal[$columnas]+$this->datos_detalle[$i]['valor_columna']);
					
					$sum_total[$columnas] +=$this->datos_detalle[$i]['valor_columna'];
					$sum_subtotal_regional[$columnas]=($sum_subtotal_regional[$columnas]+$this->datos_detalle[$i]['valor_columna']);//#ETR-1361
				}

				
				$columnas++;
			
			}
			if($id_funcionario!=$this->datos_detalle[$i]['id_funcionario']){
				$empleados_gerencia++;
				$empleados_regional++;//#ETR-1361
				$this->numeracion++;
			}
			
			$this->gerencia=$this->datos_detalle[$i]['gerencia'];
			$this->regional=$this->datos_detalle[$i]['regional'];//#ETR-1361
				
			}
			
		
		
		//Añade el ultimo subtotal de la gerencia
		
		$this->SetFont('','B',8);
		$this->ln(10);
		//$this->grillaDatos($detalle_col_mod,$alto=$this->alto_grupo,$border=0, $this->datos_titulo['num_columna_multilinea']);
		//$this->Cell(80,3,'Sub Total:' . $this->tipo_ordenacion.$this->gerencia.'','',1,'L');
		$this->Cell(30,3,'# Empl.' . $empleados_gerencia ,'',1,'L');
		$this->subtotales($detalle_col_mod,$sum_subtotal);
		
		$this->SetFont('','B',8);
		
	 	if ($this->datos_detalle[0]['regional']!=''){//#ETR-1361
				$dimensions_h = $this->getPageDimensions();
						if ($this->GetY()+$this->alto_grupo+$dimensions_h['bm']+3> $dimensions_h['hk']){
							$this->AddPage();
							$this->ln(-4);
						}else{
							$this->ln(2);
							$this->SetDrawColor(0,0,0);
							$this->SetLineWidth(0.2);
							$this->Cell(0,0,'','B',1);
							$this->Cell(0,0,'','B',1);
						}
						
		
				$this->Cell(80,3,'Total:' .  $this->regional.'','',1,'L');
				$this->Cell(30,3,'# Empl.' . $empleados_regional ,'',1,'L');
				$this->subtotales($detalle_col_mod,$sum_subtotal_regional);
				$this->regional='EMPRESA';
		}
		
		//planilla
		$this->gerencia='TOTAL EMPRESA';
		$this->AddPage();
		$this->ln(10);
		$this->SetFont('','B',8);
		$xxx=$this->numeracion-1;
		$this->Cell(30,3,'TOTAL EMPLEADOS PLANILLA: '.$xxx,'',1,'L');
		$this->SetFont('','',8);
		$this->subtotales($detalle_col_mod,$sum_total);			
		
			
	if(count($this->datos_firma)>0){//#89
		//#40
		$this->ln(40);
		$ancho_firma= (($this->ancho_hoja) / count($this->datos_firma));
		$ancho_sep=(($this->ancho_hoja) / (count($this->datos_firma)+1));
		
		
		//$this->Cell($ancho_sep/,2,'',0,0,'C');
		$this->Cell($ancho_firma,2,'________________________________________________________________',0,0,'C');
		
		//$this->Cell($ancho_sep/2,2,'',0,0,'C');
		$this->Cell($ancho_firma,2,'________________________________________________________________',0,1,'C');
		$this->SetFont('','B',7);//#50
	
		
		
		
		$this->Cell($ancho_firma,3,$this->datos_firma[0]['abreviatura_titulo'].' '.$this->datos_firma[0]['nombre_empleado_firma'],'',0,'C');
		$this->Cell($ancho_firma,3,$this->datos_firma[1]['abreviatura_titulo'].' '.$this->datos_firma[1]['nombre_empleado_firma'],'',1,'C');
		$this->SetFont('','B',8);
		$this->Cell($ancho_firma,3,$this->datos_firma[0]['nombre_cargo_firma'],'',0,'C');
		$this->Cell($ancho_firma,3,$this->datos_firma[1]['nombre_cargo_firma'],'',1,'C');			
		
	}	

			
	}
	
    function subtotales($data, $data_sub){
    	
    	$result=array();
		$id_emp=$data[0];
		$cc=0;
		
    	for ($i=0; $i< sizeof($data); $i++ ){
    		
			if($i%6==0){
				if($id_emp!=$data[$i]){
    			break;
    		}else{
    			
	    		array_push($result, $data[$i]);
				array_push($result, $data[$i+1]);
				if($data_sub[$cc]>0){//#50
					array_push($result, number_format($data_sub[$cc],2,'.',','));
				}else{
					array_push($result, '');
				}
				array_push($result,'');
				array_push($result,'0');
				array_push($result,'R');
				$cc++;
	    	}
			
					$id_emp=$data[$i];
			
			$i=$i+5;
			}
    		
		}
		
		$dimensions = $this->getPageDimensions();
		if ($this->GetY()+$this->alto_grupo+$dimensions['bm']> $dimensions['hk']){
					$this->AddPage();
		}

		$this->grillaDatos($result,$alto=$this->alto_grupo,0, $this->datos_titulo['num_columna_multilinea']);
    }
	
	//#40
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