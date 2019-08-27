<?php
// Extend the TCPDF class to create custom MultiRow
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
		if($this->datos_titulo['ordenar_por']=='centro'){//#17
			$this->tipo_ordenacion='CENTRO ';
		}//fin #17
		
		$max_fila=2; $this->max_columna=0;
		$espacio_previo=0;
		$cant_espacios=0;
		$this->cant_col=0;
		$this->cant_fil=0;
		$ancho_col=35;
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja-10, 5, 30, 10);
		$this->SetFont('','B',7);
		
		$this->Cell(30,3,$this->datos_titulo['depto'],0,1);
		$this->Cell(30,3,$this->datos_titulo['uo'],0,1);
		$this->SetFont('','BU',12);
		$this->Cell(0,5,$this->datos_titulo['titulo_reporte'] . ' ('.$this->datos_detalle[0]['nombre'].') Al Mes De  '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion'],0,1,'C');
		
		$this->SetFont('','B',10);
		$this->Cell(0,5,'No ' . $this->datos_titulo['nro_planilla'],0,1,'C');
		$this->SetFont('','B',10);
		//$this->gerencia=$this->datos_detalle[0]['nombre_unidad'];
		$this->Cell(0,5,$this->tipo_ordenacion.$this->gerencia,0,1,'L');
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
	function datosHeader ($titulo, $detalle) { 
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT;
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
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
			
		for ($i=0; $i< sizeof($this->datos_detalle); $i++ ){
			
			if($this->gerencia!=$this->datos_detalle[$i]['gerencia']){
				$this->SetFont('','',6);
				
				$this->SetY($this->posY);
				$this->grillaDatos($detalle_col_mod,$alto=$this->alto_grupo,$border=0,$this->datos_titulo['num_columna_multilinea']);
				
				
				
				$this->ln(2);
					$this->SetFont('','B',8);
					
					
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
				array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);
				array_push($detalle_col_mod,'');
				array_push($detalle_col_mod,'0');
				if($this->datos_detalle[$i]['sumar_total']=='si') {
					$sum_subtotal[$columnas] +=$this->datos_detalle[$i]['valor_columna'];
				}
				$columnas++;
			}else{
				
				if($id_funcionario!=$this->datos_detalle[$i+1]['id_funcionario'] ){
					
					
					array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
					array_push($detalle_col_mod,$this->datos_detalle[$i]['espacio_previo']);
					array_push($detalle_col_mod,$this->datos_detalle[$i]['valor_columna']);
					array_push($detalle_col_mod,'');
					array_push($detalle_col_mod,'1');
					
					$id_funcionario=$this->datos_detalle[$i+1]['id_funcionario'];
					
					
				}else{
					$id_funcionario=$this->datos_detalle[$i]['id_funcionario'];
					array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
					array_push($detalle_col_mod, $this->datos_detalle[$i]['espacio_previo']);
					array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);
					array_push($detalle_col_mod,'');
					array_push($detalle_col_mod,'0');
					
					
				}
				
			    			
				if(($columnas==($this->datos_titulo['cantidad_columnas'])) ){
					$columnas=0; 
				}
				
				
				if($this->datos_detalle[$i]['sumar_total']=='si') {
					$sum_subtotal[$columnas] +=$this->datos_detalle[$i]['valor_columna'];
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
		$this->UniRow($array_show,false, 0);
		//Si cambia la gerencia
		
		//Añade el ultimo subtotal de la gerencia
		
		$this->SetFont('','',6);
		
		$this->grillaDatos($detalle_col_mod,$alto=$this->alto_grupo,$border=0, $this->datos_titulo['num_columna_multilinea']);
		$this->Cell(80,3,'Sub Total:' . $this->tipo_ordenacion.$this->gerencia.'','',1,'L');
		$this->Cell(30,3,'# Empl.' . $empleados_gerencia ,'',1,'L');
		$this->subtotales($detalle_col_mod,$sum_subtotal);
		
		$this->SetFont('','B',8);
		
	 				
		
					

		$this->ln(4);
		
		$this->SetLineWidth(1);
 	 	$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);
		
		//planilla
		$this->ln(4);
		$this->SetFont('','B',9);
		$this->Cell(30,3,'TOTAL FUNCIONARIOS PLANILLA: '.$this->numeracion-1,'',1,'L');
		
		$this->subtotales($detalle_col_mod,$sum_total);			
		
			
	}
	
    function subtotales($data, $data_sub){
    	
    	$result=array();
		$id_emp=$data[0];
		$cc=0;
		
    	for ($i=0; $i< sizeof($data); $i++ ){
    		
			if($i%5==0){
				if($id_emp!=$data[$i]){
    			break;
    		}else{
    			
	    		array_push($result, $data[$i]);
				array_push($result, $data[$i+1]);
				array_push($result, $data_sub[$cc]);
				array_push($result,'B');
				array_push($result,'0');
				$cc++;
	    	}
			
			
			$id_emp=$data[$i];
			
			$i=$i+4;
			}
    		
		}
		
		$dimensions = $this->getPageDimensions();
		if ($this->GetY()+$this->alto_grupo+$dimensions['bm']> $dimensions['hk']){
						$this->AddPage();
		}

		$this->grillaDatos($result,$alto=$this->alto_grupo,0, $this->datos_titulo['num_columna_multilinea']);
    }
}
?>