<?php
// Extend the TCPDF class to create custom MultiRow
//ISSUE			AUTHOR			FECHA				DESCRIPCION
//#40 			MZM			16/09/2019	        	Inclusion de pie de firma
//#50			MZM			25.09.2019				Ajuste para el titulo del ultimo grupo de grilla y ajuste de espacio entre grilla y subtotal
//#80			MZM			25.11.2019				Ajuste a formato numeric
//#83	ETR		MZM			10.12.2019				Habilitacion de opcion historico de planilla
//#91	ETR		MZM			02.02.2020 				Para planillas que tienen un solo funcionario, el dibujado de la informacion no se hace en el for, por tanto la posicion en Y para el ultimo registro (que se hace fuera del loop, no considera el alto del grupo titulos)
//#97	ETR		MZM			27.02.2020				Ajuste a nombre de variable para subtitulo de planillas por mes (planilla de sueldos)
//#98	ETR		MZM			26.03.2020				Adecuacion para generacion de reporte consolidado (caso planilla reintegros)
class RPlanillaGenericaMultiCell2 extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
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
	    if(  $this->objParam->getParametro('tipo_contrato')!='' &&  $this->objParam->getParametro('tipo_contrato')!=null  ){
	    	
		 if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
		 	$tipo_con=' ('.$this->datos_detalle[0]['nombre'].' - '.$this->objParam->getParametro('personal_activo').')';
		 }else{
		 	$tipo_con=' ('.$this->datos_detalle[0]['nombre'].')';
		 }
			
			$nro_pla='No ' .$this->datos_titulo['nro_planilla'];
	    }
		else{
			
			if( $this->objParam->getParametro('personal_activo')!='todos'){//#98
		 		$tipo_con='('.$this->objParam->getParametro('personal_activo').')';
			 }
		}
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
		
		
		if(strpos($this->gerencia, '*') !== false){
			$this->Cell(0,5,$this->tipo_ordenacion.'Ciudad: '.substr($this->gerencia,0,strpos($this->gerencia, '*')),0,1,'L');
			$this->Cell(0,5,$this->tipo_ordenacion.'Banco : '.substr($this->gerencia,strpos($this->gerencia, '*')+1),0,1,'L');
		}else{
			$this->Cell(0,5,$this->tipo_ordenacion.$this->gerencia,0,1,'L');
		}
		
		
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
			$this->Ln(1);
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
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		$this->ancho_sin_totales = 0;
		$this->cantidad_columnas_estaticas = 0;
		
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->SetMargins(15,$this->posY+5, 15);
		
		//iniciacion de datos 
		$id_funcionario = $this->datos_detalle[0]['id_funcionario'];
		$this->gerencia=$this->datos_detalle[0]['gerencia'];
		
		$this->id_fun0=$id_funcionario;
		$sum_subtotal = array();
		$sum_total = array();
		
		$empleados_gerencia = 0;
		$this->numeracion=1;
		$this->ancho_col=35;
		$array_show = array(); 
		array_push($this->tablewidths, $this->ancho_col); 
		
		for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
		
	 		$sum_subtotal[$i]=0;
			$sum_total[$i]=0;
		}
		$columnas = 0;
		$fila=0;
		$detalle_col_mod=array();
		$this->SetFont('','',6);
		$linea=0;
		
		$subtotal=array();	
		setlocale(LC_MONETARY, 'it_IT');
		for ($i=0; $i< sizeof($this->datos_detalle); $i++ ){
			
			if($this->gerencia!=$this->datos_detalle[$i]['gerencia']){
				$this->SetFont('','',6);
				
				$this->SetY($this->posY);
				
				$this->grillaDatos($detalle_col_mod,$alto=$this->alto_grupo,$border=0,$this->datos_titulo['num_columna_multilinea']);
				
				
				
				
					$this->SetFont('','B',8);
					$dimensions_h = $this->getPageDimensions();
						if ($this->GetY()+$this->alto_grupo+$dimensions_h['bm']+3> $dimensions_h['hk']){
							$this->AddPage();
							$this->ln(-4);
						}else{
							$this->ln(2);
						}
					
					
					
					$this->Cell(0,0,'Sub Total:'.$this->tipo_ordenacion.$this->gerencia,'',1);
					$this->Cell(30,3,'# Empl.' . $empleados_gerencia,'',1,'L');
					
				$this->subtotales($detalle_col_mod,$sum_subtotal);
				
				$columnas=0;
				for ($m = 0; $m < $this->datos_titulo['cantidad_columnas']; $m++) {
		
				 		$sum_subtotal[$m]=0;
						
					}
				$this->gerencia=$this->datos_detalle[$i]['gerencia'];
				$empleados_gerencia=0;
				$detalle_col_mod=array();
				$this->AddPage();
				
				array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
				array_push($detalle_col_mod, $this->datos_detalle[$i]['espacio_previo']);
				
				//echo $this->datos_detalle[$i]['valor_columna'].'tipo:'.gettype($this->datos_detalle[$i]['valor_columna']); exit;
				//setlocale(LC_MONETARY, 'it_IT');
				//echo money_format('%.2n', $this->datos_detalle[$i]['valor_columna']) ; exit;
				//var_dump ($this->datos_detalle[$i]); exit;
				
				if ($this->datos_detalle[$i]['codigo_columna']!='fecha_ingreso' &&
					$this->datos_detalle[$i]['codigo_columna']!='codigo_funcionario' &&
					$this->datos_detalle[$i]['codigo_columna']!='cargo' &&
					$this->datos_detalle[$i]['codigo_columna']!='nivel' &&
					$this->datos_detalle[$i]['codigo_columna']!='fecha_nacimiento' &&
					$this->datos_detalle[$i]['codigo_columna']!='nombre_funcionario' 
					
				 ){
				 	if($this->datos_detalle[$i]['valor_columna']>0){
				 		array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor_columna'],2,'.',','));	//#80
				 	}else{
				 		array_push($detalle_col_mod, '');
				 	}
				 	
				 	
				 }
				else{
					
						array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);	
					
					
				}
				
				
				
				array_push($detalle_col_mod,'');
				array_push($detalle_col_mod,'0');
				if($this->datos_detalle[$i]['codigo_columna']=='nombre_funcionario' || $this->datos_detalle[$i]['codigo_columna']=='cargo' ) {
				
					array_push($detalle_col_mod,'L');
				}else{
						array_push($detalle_col_mod,'R');
				}
				if($this->datos_detalle[$i]['sumar_total']=='si') {
				    //$sum_subtotal[$columnas] +=$this->datos_detalle[$i]['valor_columna'];
					$sum_subtotal[$columnas]=($sum_subtotal[$columnas]+$this->datos_detalle[$i]['valor_columna']);
					$sum_total[$columnas]=($sum_total[$columnas]+$this->datos_detalle[$i]['valor_columna']);
					
				}
				
			
				
				
				$columnas++;
			}else{
				if($this->GetY()<$this->posY ){
					$this->SetY($this->posY);
				}
				
				
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
						 	
						 	if($this->datos_detalle[$i]['valor_columna']>0){
				 				array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor_columna'],2,'.',','));	//#80
						 	}else{
						 		array_push($detalle_col_mod, '');
						 	}
						 	
						 }
						else{
							
								array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);	
							

						}
					array_push($detalle_col_mod,'');
					array_push($detalle_col_mod,'1');
					
					if($this->datos_detalle[$i]['codigo_columna']=='nombre_funcionario' || $this->datos_detalle[$i]['codigo_columna']=='cargo' ) {
						array_push($detalle_col_mod,'L');
					}else{
						array_push($detalle_col_mod,'R');
					}
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
						 	
						 	if($this->datos_detalle[$i]['valor_columna']>0){
						 		array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor_columna'],2,'.',','));//#80	
						 	}else{
						 		array_push($detalle_col_mod, '');
						 	}
						 	
						 }
						else{
							
							array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);	
							
						}
					array_push($detalle_col_mod,'');
					array_push($detalle_col_mod,'0');
					if($this->datos_detalle[$i]['codigo_columna']=='nombre_funcionario' || $this->datos_detalle[$i]['codigo_columna']=='cargo' ) {
					array_push($detalle_col_mod,'L');}
					else{
						array_push($detalle_col_mod,'R');
					}
					
					
				}
				
			    			
				if(($columnas==($this->datos_titulo['cantidad_columnas'])) ){
					$columnas=0; 
				}
				
				
				if($this->datos_detalle[$i]['sumar_total']=='si') {
//					$sum_subtotal[$columnas] +=$this->datos_detalle[$i]['valor_columna'];
					$sum_subtotal[$columnas] =($sum_subtotal[$columnas]+$this->datos_detalle[$i]['valor_columna']);
					
					$sum_total[$columnas] +=$this->datos_detalle[$i]['valor_columna'];
						
				}

				
				$columnas++;
			
			}
			if($id_funcionario!=$this->datos_detalle[$i]['id_funcionario']){
				$empleados_gerencia++;
				$this->numeracion++;
			}
			
			$this->gerencia=$this->datos_detalle[$i]['gerencia'];
			
				
			}
			
		
		
		//Añade al ultimo empleado de la lista
		//$this->UniRow($array_show,false, 0);
		//Si cambia la gerencia
		
		//Añade el ultimo subtotal de la gerencia
		//#91
		if($this->datos_titulo['cantidad_columnas']==sizeof($this->datos_detalle)){
			$this->SetY($this->posY);
		}else{
			$this->ln(-4);
		}
		$this->SetFont('','',6);
		
		$this->grillaDatos($detalle_col_mod,$alto=$this->alto_grupo,$border=0, $this->datos_titulo['num_columna_multilinea']);
		$ultima_ger=$this->gerencia;
		$ultima_ord=$this->tipo_ordenacion;
		$this->gerencia='TOTAL EMPRESA';	
		$this->tipo_ordenacion='';
		
		$this->SetFont('','B',8);
					$dimensions_hu = $this->getPageDimensions();
						if ($this->GetY()+$this->alto_grupo+$dimensions_hu['bm']+3> $dimensions_hu['hk']){
							$this->AddPage();
							
						}
		$this->ln(2);
						
		
		
		$this->Cell(80,3,'Sub Total:' .  $ultima_ord.$ultima_ger.'','',1,'L');
		$this->Cell(30,3,'# Empl.' . $empleados_gerencia ,'',1,'L');
		$this->subtotales($detalle_col_mod,$sum_subtotal);
		
		$this->SetFont('','B',8);
		
	 				
		$this->AddPage();//#50
		
		//planilla
		
		
		
		
		//$this->ln(2);}
		$this->SetFont('','B',7);
		$xxx=$this->numeracion-1;
		$this->Cell(30,3,'TOTAL EMPLEADOS PLANILLA: '.$xxx,'',1,'L');
		
		$this->subtotales($detalle_col_mod,$sum_total);			
		//#50
		
		
		
		
		if(count($this->datos_firma)>0){
			//31.08.2019
			$this->ln(40);
			$ancho_firma= (($this->ancho_hoja) / count($this->datos_firma));
			$ancho_sep=(($this->ancho_hoja) / (count($this->datos_firma)+1));
			
			
			//$this->Cell($ancho_sep/,2,'',0,0,'C');
			$this->Cell($ancho_firma,2,'________________________________________________________________',0,0,'C');
			
			//$this->Cell($ancho_sep/2,2,'',0,0,'C');
			$this->Cell($ancho_firma,2,'________________________________________________________________',0,1,'C');
			
		
			
			
			
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
				
				if($data_sub[$cc]>0){
					array_push($result, number_format($data_sub[$cc],2,'.',','));//#80
				}else{
					array_push($result, '');
				}
				
				array_push($result,'B');
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