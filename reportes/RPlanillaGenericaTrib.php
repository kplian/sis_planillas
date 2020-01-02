<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion
 #83	ETR				10.12.2019			MZM					Habilitacion de opcion historico de planilla 
*/
class RPlanillaGenericaTrib extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	function Header() { 
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 5, 5, 30, 10);
		$this->SetFont('','B',7);
		$this->ln(10);
		//#83
		$this->SetFont('','B',7);
		$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
		$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
		$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
		if($this->objParam->getParametro('fecha_backup')!=''){
			$this->Cell(0, 3, '', '', 0, 'R');
			$this->Cell(0, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar, '', 1, 'R');
		}else{
			$this->Cell(0, 3, '', '', 1, 'R');
		}
		$this->SetFont('','B',14);
		$this->Cell(0,5,$this->datos_titulo['titulo_reporte'],0,1,'C');
		$this->ln(5);
		$this->SetFont('','B',7);
		$columnas = 0;
		$this->SetLineWidth(0.1);
		$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);
		$this->ln(1);
		//MultiCell($w, $h, $txt, $border=0, $align='J', $fill=0, $ln=1, $x='', $y='', $reseth=true, $stretch=0)
		$this->MultiCell(10,3.5,'Año',0,'L',0,0);
		$this->MultiCell(10,3.5,'Periodo',0,'L',0,0);
		$this->MultiCell(15,3.5,'Codigo   dependiente RcIVA',0,'L',0,0);
		$this->MultiCell(25,3.5,'Nombres',0,'L',0,0);
		$this->MultiCell(25,3.5,'Primer Apellido',0,'L',0,0);
		$this->MultiCell(25,3.5,'Segundo Apellido',0,'L',0,0);
		$this->MultiCell(15,3.5,'Numero de Documento de identidad',0,'L',0,0);
		$this->MultiCell(10,3.5,'Tipo de documento de identidad',0,'L',0,0);
		$this->MultiCell(15,3.5,'Novedades (I=Ingreso, V=Vigente, D=Desvinculado)',0,'L',0,0);
		$this->MultiCell(13,3.5,'Monto de Ingreso Neto',0,'L',0,0);
		$this->MultiCell(12,3.5,'2 SMN no imponibles',0,'L',0,0);
		$this->MultiCell(13,3.5,'Importe sujeto a impuesto (base imponible)',0,'L',0,0);
		$this->MultiCell(12,3.5,'Impuesto RCIVA',0,'L',0,0);
		$this->MultiCell(10,3.5,'13% de 2SMN',0,'L',0,0);
		$this->MultiCell(12,3.5,'Impuesto Neto RCIVA',0,'L',0,0);
		$this->MultiCell(12,3.5,'F-110 13% de facturas presentadas',0,'L',0,0);
		$this->MultiCell(12,3.5,'Saldo a favor del Fisco',0,'L',0,0);
		$this->MultiCell(15,3.5,'Saldo a favor del dependiente',0,'L',0,0);
		$this->MultiCell(15,3.5,'Saldo a favor del dependiente periodo anterior',0,'L',0,0);
		$this->MultiCell(15,3.5,'Mantenimiento de valor del saldo a favor del dependiente periodo anterior',0,'L',0,0);
		$this->MultiCell(15,3.5,'Saldo del periodo anterior actualizado',0,'L',0,0);
		$this->MultiCell(11,3.5,'Saldo utilizado',0,'L',0,0);
		$this->MultiCell(13,3.5,'Impuesto RcIVA retenido',0,'L',0,0);
		$this->MultiCell(15,3.5,'Saldo del credito fiscal a favor del dependiente para el mes siguiente',0,'L',0,1);
		
		
		$this->SetLineWidth(0.1);
		$this->SetDrawColor(0,0,0);
		$this->Cell(0,0,'','B',1);	

	}
	function datosHeader ($titulo, $detalle) {  
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		$this->ancho_sin_totales = 0;
		$this->cantidad_columnas_estaticas = 0;
		
		$this->SetMargins(5, 58, 5);
	}
	function generarReporte() {
		
		
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//iniciacion de datos 
		$id_funcionario = 0;
		
		$sum_total = array();
		$detalle_col_mod=array();
		$columnas = 0;
		$cont=0;
		$this->tablewidths=array(10,10,15,25,25,25,15,10,15,13,12,13,12,10,12,12,12,15,15,15,15,11,13,15);
		$this->tablealigns=array('L','L','L','L','L','L','R','R','C','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R');	
		$this->tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		$this->tableborders	=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		$this->SetFont('','',7);
		
							
		for ($i=0; $i<count($this->datos_detalle);$i++){
			
			if($id_funcionario!=$this->datos_detalle[$i]['id_funcionario'] ){
				
				if($id_funcionario!=0){
					//var_dump($detalle_col_mod); exit;
			        $this->UniRow($detalle_col_mod,false,0);
				}
			  $detalle_col_mod=array();
			  //array_push($detalle_col_mod, $this->datos_detalle[$i]['id_funcionario']);
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['gestion']);
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['periodo']);
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['codigo_rciva']);
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['nombre']);
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['apellido_paterno']);
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['apellido_materno']);
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['num_ci']);
			  //array_push($detalle_col_mod, $this->datos_detalle[$i]['tipo_documento']);
			  array_push($detalle_col_mod, 'CI');
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['novedad']);
			  array_push($detalle_col_mod, round($this->datos_detalle[$i]['valor'],2));
				
			} else{
	 	  	  
			  array_push($detalle_col_mod, round($this->datos_detalle[$i]['valor'],2));
			}
			 $id_funcionario=$this->datos_detalle[$i]['id_funcionario'];
		}
		
	
		
		
						
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