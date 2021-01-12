<?php
// Extend the TCPDF class to create custom MultiRow
/**
 #ISSUE                FECHA                AUTOR               DESCRIPCION
  #144	ETR				29.06.2020			MZM-KPLIAN			Planilla de Ingreso/egreso por empleado
  #ETR-2509				12.01.2021			MZM-KPLIAN			Adicion de cred fiscal, cambio formato tipo fecha, cambio nombre de columna  
 */
class RPlanillaIngresoEgreso extends  ReportePDF {
	var $datos;	
	var $datos_titulo;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $alto_header;

	var $borde;
	var $interlineado;
	function Header() {
		if(count($this->datos)>0){
			$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 10, 8, 30, 12);
			$this->SetFont('','B',7);
			if ($this->objParam->getParametro('fecha_backup')!=''){
				$dr=substr($this->objParam->getParametro('fecha_backup'),0,4);
				$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
				$ar=substr($this->objParam->getParametro('fecha_backup'),8,2);
				$id=substr($this->objParam->getParametro('fecha_backup'),9);
				$this->Cell(0, 3, '', '', 0, 'R');
				$this->Cell(0, 3, "Backup: ".$dr.'/'.$mr.'/'.$ar.$id, '', 1, 'R');
			}else{
				$this->Cell(0, 3, '', '', 1, 'R');
			}
		
		
			$this->SetFont('','B',12);
			$this->SetY(20);
			$cadena_nomina='';
		
					
			
			$this->Cell(0,5,'INGRESOS/EGRESOS ACUMULADOS'.$cadena_nomina,0,1,'C');
			
			$this->SetFont('','B',10);
			
			
			if($this->objParam->getParametro('codigo_planilla')=='PLASUE'){
				$this->Cell(0,5,'Sueldo del mes de : '.str_replace ('de ','',$this->datos[0]['periodo']),0,1,'C');	
			}else{
				$this->Cell(0,5,'Correspondiente a: '.$this->objParam->getParametro('codigo_planilla') .' - '.$this->datos[0]['periodo'],0,1,'C');
			}
			
			}else{
				$this->SetFont('','B',12);
				$this->Cell(0,5,'SIN DATOS PARA MOSTRAR','',1,'C');
			}
	}
	function setDatos($datos) {
		$this->datos = $datos;
		
	}
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		$array_datos;
		$this->SetY($this->alto_header); 
		$this->SetFont('','',8);
		$this->SetMargins(10,$this->alto_header, 5);
		//$this->gerencia=$this->datos[0]['desc_oficina'];
		$departamento='';
		$codigo_col='';
		$id_funcionario=0;
		$cont=0;
		$num=1;
		$val=0;
		$tot_bs=0;
		$tot_dep=0;
		
		//subtotales
		$s_dias1=0; $s_dias2=0;
		$s_prom1=0; $s_prom2=0;
		$s_cot1=0; $s_cot2=0; $s_cot3=0;
		$s_prima=0; $s_13=0; $s_iva=0; $s_des=0; $s_lq=0;
		
		//totales 
		$t_dias1=0; $t_dias2=0;
		$t_prom1=0; $t_prom2=0;
		$t_cot1=0; $t_cot2=0; $t_cot3=0;
		$t_prima=0; $t_13=0; $t_iva=0; $t_des=0; $t_lq=0;
			
			
		$this->SetX(10);
		$array_datos=array();
		
		
		$this->SetY(35);
		$this->SetFont('','B',8);
		$this->Cell(15,5,'Nombre: ','',0,'L');
		$this->SetFont('','',8);
		$this->Cell(100,5,$this->datos[0]['nombre_empleado'],'',0,'L');
		$this->SetFont('','B',8);
		$this->Cell(13,5,'Cargo: ','',0,'L');
		$this->SetFont('','',8);
		$this->Cell(95,5,$this->datos[0]['nombre_cargo'],'',1,'L');
		$this->SetFont('','B',8);
		$this->Cell(23,5,'Fecha Ingreso:','',0,'L');
		$this->SetFont('','',8);
		
		$this->Cell(50,5, date_format(date_create($this->datos[0]['primer_contrato']),'d/m/Y')  ,'',0,'L');
		
		$this->SetFont('','B',8);
		$this->Cell(12,5,'Codigo:','',0,'L');
		$this->SetFont('','',8);
		$this->Cell(30,5,$this->datos[0]['codigo_empleado'],'',0,'L');
		
		$this->SetFont('','B',8);
		$this->Cell(10,5,'Nivel:','',0,'L');
		$this->SetFont('','',8);
		$this->Cell(35,5,$this->datos[0]['nivel'],'',1,'L');
		
		
		$this->SetFont('','B',8);
		$this->Cell(10,5,'Afp:','',0,'L');
		$this->SetFont('','',8);
		$this->Cell(63,5,  $this->datos[0]['afp'] ,'',0,'L');
		
		
		$this->SetFont('','B',8);
		$this->Cell(15,5,'Jubilado:','',0,'L');
		$this->SetFont('','',8);
		$this->Cell(27,5,  $this->datos[0]['jubilado'] ,'',0,'L');
		
		$this->SetFont('','B',8);
		$this->Cell(25,5,'Saldo Cred Fiscal:','',0,'L');
		$this->SetFont('','',8);
		$this->Cell(30,5,  number_format($this->datos[0]['valor'],2,'.',',') ,'',0,'L');//#ETR-2509
		$this->Ln(5);
		$this->SetFont('','B',10);
		$this->Cell(110,5,'INGRESOS ACUMULADOS','',0,'L');
		$this->Cell(80,5,'DESCUENTOS ACUMULADOS','',1,'L');
		
		$this->SetFont('','',8);
		$t_ing=0;
		$t_egr=0;
		
		
		for ($i=1; $i<count($this->datos);$i++){//#ETR-2509: a partir del registro 1 dado q el primero es el credito fiscal
			if ($this->datos[$i]['tipo_movimiento']=='egreso'){
				
				if ($this->GetX()<110){
					
					$this->SetX(120);
				}
				$this->Cell(30,5,$this->datos[$i]['titulo_reporte_superior'].' '.$this->datos[$i]['titulo_reporte_inferior'],'',0,'L');
				$this->Cell(7,5,'','',0,'L');
				$this->Cell(30,5,number_format($this->datos[$i]['valor'],2,'.',','),'',1,'R');
				$t_egr=$t_egr+$this->datos[$i]['valor'];
			}else{
				
				$this->Cell(30,5,$this->datos[$i]['titulo_reporte_superior'].' '.$this->datos[$i]['titulo_reporte_inferior'],'',0,'L');
				$this->Cell(7,5,'','',0,'L');
				$this->Cell(30,5,number_format($this->datos[$i]['valor'],2,',',','),'',0,'R');
				$this->Cell(43,5,'','',0,'L');
				$t_ing=$t_ing+$this->datos[$i]['valor'];
			}
		}
		$this->SetFont('','B',8);
		$this->SetX(10);
		$this->Ln(3);
		$this->Cell(37,5,'TOTALES','',0,'L');
		$this->Cell(30,5,number_format($t_ing,2,',',','),'',0,'R');
		$this->Cell(43,5,'','',0,'L');
		$this->Cell(37,5,'','',0,'L');
		$this->Cell(30,5,number_format($t_egr,2,',',','),'',1,'R');
		
			
	}
	
		
		
		
			
	
	
    
}
?>