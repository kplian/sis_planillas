<?php
// Extend the TCPDF class to create custom MultiRow
class RPlanillaGenerica extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
		$this->SetFont('','B',7);
		$this->Cell(30,3,$this->datos_titulo['depto'],0,1);
		$this->Cell(30,3,$this->datos_titulo['uo'],0,1);
		$this->SetFont('','BU',12);
		$this->Cell(0,5,$this->datos_titulo['titulo_reporte'] . ' AL MES DE  '.$this->datos_titulo['periodo'].'-'.$this->datos_titulo['gestion'],0,1,'C');
		
		$this->SetFont('','B',10);
		$this->Cell(0,5,'No ' . $this->datos_titulo['nro_planilla'],0,1,'C');
		$this->SetFont('','B',10);
		$this->Cell(0,5,$this->gerencia,0,1,'L');
		$this->Ln(2);
		$this->SetFont('','B',8);
		
		//Titulos de columnas superiores
		if ($this->datos_titulo['numerar'] == 'si')
			$this->Cell(5,3.5,'No','LTR',0,'C');
		if ($this->datos_titulo['mostrar_nombre'] == 'si')
			$this->Cell(52,3.5,'Nombre Completo','LTR',0,'C');
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si')
			$this->Cell(10,3.5,'Cod.','LTR',0,'C');
		if ($this->datos_titulo['mostrar_doc_id'] == 'si')
			$this->Cell(15,3.5,'CI','LTR',0,'C');
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si')
			$this->Cell(15,3.5,'Item','LTR',0,'C');
		$columnas = 0;
		
		foreach($this->datos_detalle as $value) {
			$this->Cell($value['ancho_columna'],3.5,$value['titulo_reporte_superior'],'LTR',0,'C');
			$columnas++;
			if ($columnas == $this->datos_titulo['cantidad_columnas']) {
				break;
			}
		}
		$this->ln();

		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		if ($this->datos_titulo['numerar'] == 'si') {
			$this->Cell(5,3.5,'','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_nombre'] == 'si') {
			$this->Cell(52,3.5,'','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si') {
			$this->Cell(10,3.5,'Emp.','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_doc_id'] == 'si') {
			$this->Cell(15,3.5,'','LBR',0,'C');			
		}
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si') {
			$this->Cell(15,3.5,'','LBR',0,'C');
		}
		$columnas = 0;
		
		foreach($this->datos_detalle as $value) {
			$this->Cell($value['ancho_columna'],3.5,$value['titulo_reporte_inferior'],'LBR',0,'C');
			//iniciar ancho de columna, alineacion y formato de numero
			array_push($this->tablewidths, $value['ancho_columna']); 
			array_push($this->tablealigns, 'R');
			array_push($this->tablenumbers, 2);
			$columnas++;
			if ($columnas == $this->datos_titulo['cantidad_columnas']) {
				break;
			}
		}
		$this->ln();	

	}
	function datosHeader ($titulo, $detalle) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		$this->ancho_sin_totales = 0;
		$this->cantidad_columnas_estaticas = 0;
		if ($this->datos_titulo['numerar'] == 'si') {
			array_push($this->tablewidths, 5); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 5;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_nombre'] == 'si') {
			array_push($this->tablewidths, 52); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 52;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si') {
			array_push($this->tablewidths, 15); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 10;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_doc_id'] == 'si') {
			array_push($this->tablewidths, 15); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 10;
			$this->cantidad_columnas_estaticas++;
		}
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si') {
			array_push($this->tablewidths, 10); 
			array_push($this->tablealigns, 'L');
			array_push($this->tablenumbers, 0);
			$this->ancho_sin_totales += 10;
			$this->cantidad_columnas_estaticas++;
		}
		$this->SetMargins(5, 36, 5);
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//iniciacion de datos 
		$id_funcionario = $this->datos_detalle[0]['id_funcionario'];
		$sum_subtotal = array();
		$sum_total = array();
		$this->numeracion = 1;
		$empleados_gerencia = 1;
		$array_show = $this->iniciarArrayShow($this->datos_detalle[0]);		
		
		for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
	 		$sum_subtotal[$i]=0;
			$sum_total[$i]=0;
		}
		$columnas = 0;
		
		foreach ($this->datos_detalle as $value) {		
			if ($id_funcionario != $value['id_funcionario']) {
				$this->SetFont('','',6);
				$this->MultiRow($array_show);
				$columnas = 0;
				//Si cambia la gerencia
				if ($this->gerencia != $value['gerencia']) {
					//generar subtotales
					$this->SetFont('','B',7);
	 				$this->Cell($this->ancho_sin_totales,3,'TOTAL GERENCIA ' . $this->gerencia . ' : ','RBT',0,'R');
					for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
						if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
							$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i],2),1,0,'R');
						else
							$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
						//reiniciar subtotales
						$sum_subtotal[$i] = 0;
					}
	 	 			
					$this->ln(10);
					$this->Cell($this->ancho_sin_totales,3,'SUBTOTAL FUNCIONARIOS '.$this->gerencia . ' : ' .$empleados_gerencia,'',0,'R');
					//crear nueva pagina y cambiar de gerencia
					$this->gerencia = $value['gerencia'];
					$empleados_gerencia = 0;
					$this->AddPage();
				}
				$this->numeracion++;
				$empleados_gerencia++;
				$array_show = $this->iniciarArrayShow($value);
				$id_funcionario = $value['id_funcionario'];
			//si no es un nuevo funcionario hacer push al arreglo con el dato recibido
			} 
			array_push($array_show, $value['valor_columna']);
			$sum_subtotal[$columnas] += $value['valor_columna'];
			$sum_total[$columnas] += $value['valor_columna'];
			$columnas++;				
			
		}
		
		$this->SetFont('','',5);
		//Añade al ultimo empleado de la lista
		$this->MultiRow($array_show);
		//Si cambia la gerencia
		
		//Añade el ultimo subtotal de la gerencia
		//generar subtotales
		$this->SetFont('','B',6);
		$this->Cell($this->ancho_sin_totales,3,'TOTAL GERENCIA ' . $this->gerencia . ' : ','RBT',0,'R');
		for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
			if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
				$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_subtotal[$i],2),1,0,'R');
			else
				$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
			//reiniciar subtotales
			$sum_subtotal[$i] = 0;
		}		
		$this->ln(10);
		$this->Cell($this->ancho_sin_totales,3,'SUBTOTAL FUNCIONARIOS '.$this->gerencia . ' : ' .$empleados_gerencia,'',0,'R');
		$this->ln(10);
		
		//planilla
		$this->Cell($this->ancho_sin_totales,3,'TOTAL PLANILLA : ','RBT',0,'R');
		for ($i = 0; $i < $this->datos_titulo['cantidad_columnas']; $i++) {
			if ($this->datos_detalle[$i]['sumar_total'] == 'si') 
				$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,number_format($sum_total[$i],2),1,0,'R');
			else
				$this->Cell($this->tablewidths[$i + $this->cantidad_columnas_estaticas],3,'',1,0,'R');
		}
		$this->ln(10);
		$this->Cell($this->ancho_sin_totales,3,'TOTAL FUNCIONARIOS PLANILLA: '.$this->numeracion,'',0,'R');
			
	}
	function iniciarArrayShow($detalle) {
		$res_array = array();
		if ($this->datos_titulo['numerar'] == 'si')
			array_push($res_array, $this->numeracion);
		if ($this->datos_titulo['mostrar_nombre'] == 'si')
			array_push($res_array, $detalle['nombre_empleado']);
		if ($this->datos_titulo['mostrar_codigo_empleado'] == 'si')
			array_push($res_array, $detalle['codigo_empleado']);
		if ($this->datos_titulo['mostrar_doc_id'] == 'si')
			array_push($res_array, $detalle['doc_id']);
		if ($this->datos_titulo['mostrar_codigo_cargo'] == 'si')
			array_push($res_array, $detalle['codigo_cargo']);
		return $res_array;
	}
    
}
?>