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
	function Header() {
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
		$this->Cell(0,5,$this->gerencia,0,1,'L');
		$this->Ln(2);
		$this->SetFont('','B',8);
		
		
			$columnas=0;
			$fila=0;
			$this->SetFont('helvetica', 'N', 7);
			//$detalle_col=$this->datos_detalle[1];
			$id_funcionario = $this->datos_detalle[0]['id_funcionario'];
			
			$this->id_fun0=$id_funcionario;
			
			$detalle_col_mod=array();
			foreach($this->datos_detalle as $value) {
				if($id_funcionario!=$value['id_funcionario']) break;
				else{
					array_push($detalle_col_mod,$value['id_funcionario']);
					array_push($detalle_col_mod,$value['espacio_previo']);
					array_push($detalle_col_mod,$value['titulo_reporte_superior'].' '.$value['titulo_reporte_inferior']);
				
				}
			}
			$this->SetFont('','B',7);
			$this->grillaDatos($detalle_col_mod,0, $this->datos_titulo['num_columna_multilinea']);
			$this->ln(2);
			$this->SetLineWidth(0.1);
 	 		$this->SetDrawColor(0,0,0);
			$this->Cell(0,0,'','B',1);
			$this->posY=$this->GetY();
		
	}
	function datosHeader ($titulo, $detalle) { 
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT;
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		$this->ancho_sin_totales = 0;
		$this->cantidad_columnas_estaticas = 0;
		$this->SetMargins(5,$this->GetY()+($this->datos_titulo['cantidad_columnas']/$this->datos_titulo['num_columna_multilinea']*5), 5);
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$this->SetY($this->GetY()+ $this->getHeightV2($this->datos_detalle[0]['id_funcionario'],1)+($this->datos_titulo['cantidad_columnas']/$this->datos_titulo['num_columna_multilinea']*2));
		
		//$this->SetMargins(5,$this->GetY()+($this->datos_titulo['cantidad_columnas']/$this->datos_titulo['num_columna_multilinea']*5), 5);
		
	
		$this->SetMargins(5,$this->GetY(), 5);
		//iniciacion de datos 
		$id_funcionario = $this->datos_detalle[0]['id_funcionario'];
		$this->gerencia=$this->datos_detalle[0]['gerencia'];
		
		$this->id_fun0=$id_funcionario;
		$sum_subtotal = array();
		$sum_total = array();
		
		$empleados_gerencia = 1;
		$this->numeracion=1;
		$this->ancho_col=35;
		$array_show = array(); //$this->iniciarArrayShow($this->datos_detalle[0]);		
		array_push($this->tablewidths, $this->ancho_col); 
		
		for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
		
	 		$sum_subtotal[$i]=0;
			$sum_total[$i]=0;
		}
		$columnas = 0;
		$fila=0;
		$detalle_col_mod=array();
		$this->SetFont('','',6);
		
		//echo '**'.sizeof($this->datos_detalle); exit;
		//foreach ($this->datos_detalle as $value) {
			$subtotal=array();	
			
		for ($i=0; $i< sizeof($this->datos_detalle); $i++ ){
			
			if($this->gerencia!=$this->datos_detalle[$i]['gerencia']){
				$this->SetFont('','',6);
				
				$this->SetY($this->posY);
				$this->grillaDatos($detalle_col_mod,$border=0,$this->datos_titulo['num_columna_multilinea']);
				$columnas=0;
				$this->ln(10);
					$this->SetLineWidth(0.1);
 	 				$this->SetDrawColor(0,0,0);
					$this->Cell(0,0,'','B',1);
					$this->ln(6);
					$this->SetFont('','B',8);
					$this->Cell(0,0,'Sub Total:'.$this->gerencia,'',1);
					$this->Cell(30,3,'# Empl.' . $empleados_gerencia,'',1,'L');
					$this->ln(6);
				$this->subtotales($detalle_col_mod,$sum_subtotal);
				$this->gerencia=$this->datos_detalle[$i]['gerencia'];
				$empleados_gerencia=0;
				$detalle_col_mod=array();
				$this->AddPage();
				
			}else{ 
				array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
				array_push($detalle_col_mod, $this->datos_detalle[$i]['espacio_previo']);
				array_push($detalle_col_mod, $this->datos_detalle[$i]['valor_columna']);
				
				if(($i%($this->datos_titulo['cantidad_columnas']))==0 && $i!=0){
					$columnas=0;
				}
				$sum_subtotal[$columnas] +=$this->datos_detalle[$i]['valor_columna'];
				$columnas++;
			
			}
			if($id_funcionario!=$this->datos_detalle[$i]['id_funcionario']){
				$empleados_gerencia++;
				$this->numeracion++;
			}
			$id_funcionario=$this->datos_detalle[$i]['id_funcionario'];
			$this->gerencia=$this->datos_detalle[$i]['gerencia'];
			
				
				$sum_subtotal[$columnas] +=$value['valor_columna'];
				$sum_total[$columna] += $value['valor_columna'];
				$columna++;
				
			}
			
		//$this->SetFont('','',5);
		//Añade al ultimo empleado de la lista
		$this->UniRow($array_show,false, 0);
		//Si cambia la gerencia
		
		//Añade el ultimo subtotal de la gerencia
		//generar subtotales
		$this->SetY($this->posY);
		$this->SetFont('','B',6);
		$this->SetLineWidth(0.1);
 	 	$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);
		//$this->Ln(20);
		
		//$this->Cell($this->ancho_sin_totales,3,'TOTAL GERENCIA ' . $this->gerencia . ' : ','RBT',0,'R');
		$this->SetFont('','',6);
		
		$this->grillaDatos($detalle_col_mod,$border=0, $this->datos_titulo['num_columna_multilinea']);
		$this->ln(10);
					$this->SetLineWidth(0.1);
 	 				$this->SetDrawColor(0,0,0);
					$this->Cell(0,0,'','B',1);
					$this->ln(6);
					$this->SetFont('','B',8);
		$this->Cell(80,3,'Sub Total:' . $this->gerencia.'','',1,'L');
		$this->Cell(30,3,'# Empl.' . $empleados_gerencia ,'',1,'L');
	 				
		
					

		$this->ln(10);
		//$this->Cell($this->ancho_sin_totales,3,'SUBTOTAL FUNCIONARIOS '.$this->gerencia . ' : ' .$empleados_gerencia,'',0,'R');
		//$this->ln(15);
		$this->SetLineWidth(1);
 	 	$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);
		//$this->ln(15);
		//planilla
		$this->SetFont('','B',8);
		$this->Cell(30,3,'TOTAL FUNCIONARIOS PLANILLA: '.$this->numeracion,'',1,'L');
		
					
		//$this->ln(15);
			
	}
	
    function subtotales($data, $data_sub){
    	
    	$result=array();
		$id_emp=$data[0];
		$cc=0;
		
    	for ($i=0; $i< sizeof($data); $i++ ){
    		
			if($i%3==0){
				if($id_emp!=$data[$i]){
    			break;
    		}else{
    			
	    		array_push($result, $data[$i]);
				array_push($result, $data[$i+1]);
				array_push($result, $data_sub[$cc]);
				$cc++;
	    	}
			
			
			$id_emp=$data[$i];
			$sum_subtotal[$i]=0;
			$i=$i+2;
			}
    		
		}
		
		
		$this->grillaDatos($result,0, $this->datos_titulo['num_columna_multilinea']);
    }
}
?>