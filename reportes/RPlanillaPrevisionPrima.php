<?php
// Extend the TCPDF class to create custom MultiRow
/**
 #ISSUE                FECHA                AUTOR               DESCRIPCION
  #135	ETR				04.06.2020			MZM-KPLIAN			Planilla de Prevision de Primas
  
 */
class RPlanillaPrevisionPrima extends  ReportePDF {
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
		
			if($this->objParam->getParametro('nombre_tipo_contrato')!='' ){
				
				
					$cadena_nomina=' ('.$this->objParam->getParametro('nombre_tipo_contrato').')';
				
			}
		
			if($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI' && $this->objParam->getParametro('estado')=='activo'){
				$this->Cell(0,5,'PLANILLA PREVISORA PRIMA ANUAL'.$cadena_nomina,0,1,'C');
			}elseif($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI' && $this->objParam->getParametro('estado')=='retirado') {
				$this->Cell(0,5,'PREVISION PRIMA POR PAGAR PERSONAL RETIRADO'.$cadena_nomina,0,1,'C');
			}
			$this->SetFont('','B',10);
			
			$this->Cell(0,5,'GESTION : '.$this->datos[0]['gestion'],0,1,'C');
		
			$this->Ln(-2);
				
			//Titulos de columnas superiores
			
			$this->SetX(10);
			$this->Cell(0,5,'Ciudad: '.substr($this->gerencia,0,strpos($this->gerencia, '*')),0,1,'L');
			if($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI' ){
				$this->SetX(10);
				$this->Cell(0,5,'Banco : '.substr($this->gerencia,strpos($this->gerencia, '*')+1),0,1,'L');
			}
			$this->Ln(1);
			
			$this->SetFont('','B',8);
			$this->SetX(10);
			
			if ($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI'){
				if($this->objParam->getParametro('estado')=='activo'){
					$this->Cell(85,5,'','',0,'C');
					$this->Cell(68,5,'CONTRATO 1','LTR',0,'C');
					$this->Cell(107,5,'CONTRATO 2','LTR',0,'C');
					$this->Cell(20,5,'','',1,'C');
				}else{
					$this->Cell(80,5,'','',0,'C');
					$this->Cell(60,5,'CONTRATO 1','LTR',0,'C');
					$this->Cell(60,5,'CONTRATO 2','LTR',0,'C');
					$this->Cell(80,5,'','',1,'C');
				}
			}
			  
			  
			$this->SetX(10);
			if ($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI' ){
				 if($this->objParam->getParametro('estado')=='activo'){
					 $this->Cell(15,5,'Codigo','T',0,'C');
					  $this->Cell(70,5,'Nombre','TR',0,'C');
					  $this->Cell(18,5,'Fecha','T',0,'C');
					  $this->Cell(18,5,'Fecha ','T',0,'C');
					  $this->Cell(13,5,'Dias','T',0,'C');
					  $this->Cell(19,5,'Cotizable','TR',0,'C');
					  $this->Cell(18,5,'Fecha','T',0,'C');
				  
				  
				  	  $this->Cell(13,5,'Dias','T',0,'C');
					  $this->Cell(19,5,'Cotizable','T',0,'C');
					  $this->Cell(19,5,'Cotizable','T',0,'C');
					  $this->Cell(19,5,'Cotizable','T',0,'C');
					  $this->Cell(19,5,'Cotizable','T',0,'C');
					  $this->Cell(20,5,'Total','LT',1,'C');
				  }else{//no vigentes
				  	  $this->Cell(15,5,'Codigo','T',0,'C');
					  $this->Cell(65,5,'Nombre','TR',0,'C');
					  $this->Cell(17,5,'Fecha','T',0,'C');
					  $this->Cell(17,5,'Fecha ','T',0,'C');
					  $this->Cell(10,5,'Dias','T',0,'C');
					  $this->Cell(16,5,'Cotizable','TR',0,'C');
					  $this->Cell(17,5,'Fecha','T',0,'C');
				  
				  	  $this->Cell(17,5,'Fecha ','T',0,'C');
				  	  $this->Cell(10,5,'Dias','T',0,'C');
				  	  $this->Cell(16,5,'Cotizable','TR',0,'C');
					  $this->Cell(16,5,'Total','T',0,'C');
					  $this->Cell(16,5,'13%','T',0,'C');
					  $this->Cell(16,5,'Certif.','T',0,'C'); //Saldo RC IVA
					  $this->Cell(16,5,'Descuento','T',0,'C');// RC IVA
					  $this->Cell(16,5,'Monto','T',1,'C');// a pagar
				  }
			 }else{//bono de produccion
			 	
				/*if($this->objParam->getParametro('codigo_planilla')=='BONOVIG'){
					  $this->Cell(15,5,'Codigo','T',0,'C');
					  $this->Cell(90,5,'Nombre','T',0,'C');
					  $this->Cell(25,5,'Fecha','T',0,'C');
					  $this->Cell(15,5,'Tiempo ','T',0,'C');
					  $this->Cell(25,5,'Cotizable','T',0,'C');
					  $this->Cell(25,5,'Bono','T',0,'C');
				  	  $this->Cell(25,5,'Importe','T',0,'C');
					  $this->Cell(25,5,'Aporte Pat','T',0,'C');
					  $this->Cell(25,5,'Costo Total','T',1,'C');
					 
				}else{
					  $this->Cell(15,5,'Codigo','T',0,'C');
					  $this->Cell(70,5,'Nombre','T',0,'C');
					  $this->Cell(17,5,'Fecha','T',0,'C');
					  $this->Cell(17,5,'Fecha ','T',0,'C');
					  $this->Cell(30,5,'Motivo','T',0,'C');
					  $this->Cell(10,5,'Dias','T',0,'C');
					  $this->Cell(17,5,'Cotizable','T',0,'C');
				  
				  	  $this->Cell(20,5,'% obtenido ','T',0,'C');
				  	  $this->Cell(17,5,'Incentivo','T',0,'C');
				  	  $this->Cell(17,5,'13%','T',0,'C');
					  $this->Cell(17,5,'Importe','T',0,'C');
					  $this->Cell(17,5,'Aporte Pat.','T',0,'C');
					  $this->Cell(17,5,'Costo Total','T',1,'C'); 
					  
				}*/
				
			 }
			  
				//titulo inferior
			
			
			  $this->SetX(10);
			 if ($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI' ){
				  if($this->objParam->getParametro('estado')=='activo'){
				 	  $this->Cell(15,5,'','B',0,'C');
					  $this->Cell(70,5,'Cargo','BR',0,'C');
					  $this->Cell(18,5,'Ingreso','B',0,'C');
					  $this->Cell(18,5,'Retiro','B',0,'C');
					  $this->Cell(13,5,'Trab.','B',0,'C');
					  $this->Cell(19,5,'Prom','BR',0,'C');
					  $this->Cell(18,5,'Ingreso','B',0,'C');
				  	  $this->Cell(13,5,'Trab','B',0,'C');
					  $this->Cell(19,5,'Octubre','B',0,'C');
					  $this->Cell(19,5,'Noviembre','B',0,'C');
					  $this->Cell(19,5,'Diciembre','B',0,'C');
					  $this->Cell(19,5,'Prom','B',0,'C');
					  $this->Cell(20,5,'Prima','LB',1,'C');
				  }else{
				  	  $this->Cell(15,5,'','B',0,'C');
					  $this->Cell(65,5,'Cargo','BR',0,'C');
					  $this->Cell(17,5,'Ingreso','B',0,'C');
					  $this->Cell(17,5,'Retiro','B',0,'C');
					  $this->Cell(10,5,'Trab.','B',0,'C');
					  $this->Cell(16,5,'Prom','BR',0,'C');
					  $this->Cell(17,5,'Ingreso','B',0,'C');
					  
				  	  $this->Cell(17,5,'Retiro ','B',0,'C');
				  	  $this->Cell(10,5,'Trab','B',0,'C');
				  	  $this->Cell(16,5,'Prom','BR',0,'C');
					  $this->Cell(16,5,'Prima','B',0,'C');
					  $this->Cell(16,5,'','B',0,'C');
					  $this->Cell(16,5,'RC IVA','B',0,'C'); //
					  $this->Cell(16,5,'RC IVA','B',0,'C');// 
					  $this->Cell(16,5,'a pagar','B',1,'C');// 
				  }
				}else{//bono de produccion
					/*if($this->objParam->getParametro('codigo_planilla')=='BONOVIG'){
					  $this->Cell(15,5,'','B',0,'C');
					  $this->Cell(90,5,'Cargo','B',0,'C');
					  $this->Cell(25,5,'Ingreso','B',0,'C');
					  $this->Cell(15,5,'Trab.','B',0,'C');
					  $this->Cell(25,5,'Promedio','B',0,'C');
					  $this->Cell(25,5,'Produccion','B',0,'C');
				  	  $this->Cell(25,5,'a pagar(Bs.)','B',0,'C');
					  $this->Cell(25,5,'CPS','B',0,'C');
					  $this->Cell(25,5,'(Bs.)','B',1,'C');
					 
					}else{
					  $this->Cell(15,5,'','B',0,'C');
					  $this->Cell(70,5,'Cargo','B',0,'C');
					  $this->Cell(17,5,'Ingreso','B',0,'C');
					  $this->Cell(17,5,'Retiro','B',0,'C');
					  $this->Cell(30,5,'Retiro','B',0,'C');
					  $this->Cell(10,5,'Trab.','B',0,'C');
					  $this->Cell(17,5,'Promedio','B',0,'C');
				  
				  	  $this->Cell(20,5,'en Evaluacion','B',0,'C');
				  	  $this->Cell(17,5,'Desempeño','B',0,'C');
				  	  $this->Cell(17,5,'RC-IVA','B',0,'C');
					  $this->Cell(17,5,'a pagar','B',0,'C');
					  $this->Cell(17,5,'CPS','B',0,'C');
					  $this->Cell(17,5,'','B',1,'C'); 
					  //15,70,15,15,30,10,17,20,17,17,17,17,17		
					}*/
				}
				
				
				$this->alto_header =$this->GetY(); 
			}else{
				$this->SetFont('','B',12);
				$this->Cell(0,5,'SIN DATOS PARA MOSTRAR','',1,'C');
			}
	}
	function setDatos($datos) {
		$this->datos = $datos;
		$this->gerencia=$this->datos[0]['desc_oficina'];
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
		for ($i=0; $i<count($this->datos);$i++){
			if ($id_funcionario!=$this->datos[$i]['id_funcionario']){
				$cont++;
				$array_datos[$cont][0]= $this->datos[$i]['codigo'];
				$array_datos[$cont][1]= $this->datos[$i]['desc_funcionario'];
				$ff= $this->datos[$i]['ctto1'];
				
				$aa=substr($ff, 0,4);
				$mm=substr($ff, 5,2);
				$dd=substr($ff, 8,2);
				
				$array_datos[$cont][2]= $dd.'/'.$mm.'/'.$aa; //fecha_inicio_ctto1
				$aa=substr($ff, 15,4);
				$mm=substr($ff, 20,2);
				$dd=substr($ff, 23,2);
				$array_datos[$cont][3]= $dd.'/'.$mm.'/'.$aa; //fecha_fin_ctto1
				
				$ff= $this->datos[$i]['ctto2'];
				$aa=substr($ff, 0,4);
				$mm=substr($ff, 5,2);
				$dd=substr($ff, 8,2);
				
				$array_datos[$cont][4]= $dd.'/'.$mm.'/'.$aa; //fecha_inicio_ctto2
				$aa=substr($ff, 15,4);
				$mm=substr($ff, 20,2);
				$dd=substr($ff, 23,2);
				$array_datos[$cont][5]= $dd.'/'.$mm.'/'.$aa; //fecha_fin_ctto2
				$array_datos[$cont][6]= $this->datos[$i]['cargo'];
				
				if ($this->datos[$i]['codigo_columna']=='IMPDET' && ($this->objParam->getParametro('codigo_planilla')=='PLAPRIVIG' || $this->objParam->getParametro('codigo_planilla')=='SPLAPRIVIG' || $this->objParam->getParametro('codigo_planilla')=='PRINOVIG')){
				  	$array_datos[$cont][7]= $this->datos[$i]['valor'];  //impdet
				}
				if ($this->datos[$i]['codigo_columna']=='APCAJ' && ($this->objParam->getParametro('codigo_planilla')=='BONOVIG' || $this->objParam->getParametro('codigo_planilla')=='BONONOVIG')){
				  	$array_datos[$cont][19]= $this->datos[$i]['valor'];  //apcaj
				}
				
				if ($this->datos[$i]['codigo_columna']=='PREDIAS1' || $this->datos[$i]['codigo_columna']=='SPREDIAS1'){//#145
					$array_datos[$cont][8]= $this->datos[$i]['valor'];
				}
				
				//#145
				if ($this->datos[$i]['codigo_columna']=='PREPRIMA' && ($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI')){
				  	$array_datos[$cont][15]= $this->datos[$i]['valor'];  //preprima
				}
				
				$array_datos[$cont][18]= $this->datos[$i]['desc_oficina'];  
				$array_datos[$cont][21]= $this->datos[$i]['obs_fin'];  
			}else{
				if ($this->datos[$i]['codigo_columna']=='PREDIAS1' || $this->datos[$i]['codigo_columna']=='SPREDIAS1'){//#145
					$array_datos[$cont][8]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='PREDIAS2' || $this->datos[$i]['codigo_columna']=='SPREDIAS2'){//#145
					$array_datos[$cont][9]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='PREPRICOT21' || $this->datos[$i]['codigo_columna']=='SPREPRICOT1'){
					$array_datos[$cont][10]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='PREPRICOT22' || $this->datos[$i]['codigo_columna']=='SPREPRICOT2'){
					$array_datos[$cont][11]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='PREPRICOT23' || $this->datos[$i]['codigo_columna']=='SPREPRICOT3'){
					$array_datos[$cont][12]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='PREPROME1'){
					if ($this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI'){
						$array_datos[$cont][14]= $this->datos[$i]['valor'];
					}else{
						$array_datos[$cont][13]= $this->datos[$i]['valor'];
					}
					
					
				}elseif ($this->datos[$i]['codigo_columna']=='PREPROME2'){
					$array_datos[$cont][14]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='PREPRIMA'){
					$array_datos[$cont][15]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='IMPOFAC'){
					$array_datos[$cont][16]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='LIQPAG'){
					$array_datos[$cont][17]= $this->datos[$i]['valor'];
				}
				
				
				elseif ($this->datos[$i]['codigo_columna']=='BONO'){
					$array_datos[$cont][20]= $this->datos[$i]['valor'];
				
				}elseif ($this->datos[$i]['codigo_columna']=='PORCBONO'){
					$array_datos[$cont][22]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='CTOTAL'){
					$array_datos[$cont][23]= $this->datos[$i]['valor'];
				}elseif ($this->datos[$i]['codigo_columna']=='IMPDET' && ($this->objParam->getParametro('codigo_planilla')=='BONOVIG' || $this->objParam->getParametro('codigo_planilla')=='BONONOVIG')){
				  	$array_datos[$cont][7]= $this->datos[$i]['valor'];  //impdet
				}
			}

			$id_funcionario=$this->datos[$i]['id_funcionario']; 
			
		}

	if($this->objParam->getParametro('codigo_planilla')=='PLAPREPRI' || $this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI' ){ //#145		
		if($this->objParam->getParametro('estado')=='activo'){	
			for ($i=1; $i<=$cont;$i++){
			
				if($this->gerencia!=$array_datos[$i][18] ){
					$this->gerencia=$array_datos[$i][18];
					
					//añadimos los subtotales
					$this->Cell(85,5,'SUBTOTAL','TRB',0,'C');
					$this->Cell(36,5,'','TB',0,'C');
					$this->Cell(13,5,number_format($s_dias1,0),'TB',0,'R');
					$this->Cell(19,5,number_format($s_prom1,2,'.',','),'TRB',0,'R');
					$this->Cell(18,5,'','TB',0,'C');
					$this->Cell(13,5,number_format($s_dias2,0),'TB',0,'R');
					$this->Cell(19,5,number_format($s_cot1,2,'.',','),'TB',0,'R');
					$this->Cell(19,5,number_format($s_cot2,2,'.',','),'TB',0,'R');
					$this->Cell(19,5,number_format($s_cot3,2,'.',','),'TB',0,'R');
					$this->Cell(19,5,number_format($s_prom2,2,'.',','),'TBR',0,'R');
					$this->Cell(20,5,number_format($s_prima,2,'.',','),'TB',1,'R');
					
					$s_dias1=0; $s_dias2=0;
					$s_prom1=0; $s_prom2=0;
					$s_cot1=0; $s_cot2=0; $s_cot3=0;
					$s_prima=0; $s_13=0; $s_iva=0; $s_des=0; $s_lq=0;
					//----
					
					
					
					$this->AddPage();  //echo $this->gerencia.'---'. $array_datos[$i][18].'***'.$array_datos[$i][1]; exit;
					$this->SetX(10);
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(70,5,mb_strcut ( $array_datos[$i][1], 0, 38, "UTF-8"),'R',0,'L');
				
					if($array_datos[$i][8]>0){
						$this->Cell(18,5,$array_datos[$i][2],'',0,'C');
						$this->Cell(18,5,$array_datos[$i][3],'',0,'C');
						$this->Cell(13,5,number_format($array_datos[$i][8],0),'',0,'R');
						$this->Cell(19,5,number_format($array_datos[$i][13],2,'.',','),'R',0,'R');
						
						$s_dias1=$array_datos[$i][8];
						$s_prom1=$array_datos[$i][13];
						
						$t_dias1=$t_dias1+$array_datos[$i][8];
						$t_prom1=$t_prom1+$array_datos[$i][13];
						
						
					}else{
						$this->Cell(18,5,'','',0,'C');
						$this->Cell(18,5,'','',0,'C');
						$this->Cell(13,5,'','',0,'C');
						$this->Cell(19,5,'','R',0,'C');
					}
				
					$this->Cell(18,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(13,5,number_format($array_datos[$i][9],0),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][12],2,'.',','),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][11],2,'.',','),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][10],2,'.',','),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][14],2,'.',','),'R',0,'R');
					$this->Cell(20,5,number_format($array_datos[$i][15],2,'.',','),'',1,'R');
					
					$s_dias2=$array_datos[$i][9];
					$s_cot1=$array_datos[$i][12]; $s_cot2=$array_datos[$i][11]; $s_cot3=$array_datos[$i][10];
					$s_prom2=$array_datos[$i][14]; $s_prima=$array_datos[$i][15];
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_cot1=$t_cot1+$array_datos[$i][12]; $t_cot2=$t_cot2+$array_datos[$i][11]; $t_cot3=$t_cot3+$array_datos[$i][10];
					$t_prom2=$t_prom2+$array_datos[$i][14]; $t_prima=$t_prima+$array_datos[$i][15];
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(70,5,mb_strcut ( $array_datos[$i][6], 0, 38, "UTF-8"),'R',0,'L');
					$this->Cell(68,5,'','R',0,'C');
					$this->Cell(107,5,'','R',0,'C');
					$this->Cell(20,5,'','',1,'L');
					
				}else{
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(70,5,mb_strcut ( $array_datos[$i][1], 0, 38, "UTF-8"),'R',0,'L');
					
					if($array_datos[$i][8]>0){
						$this->Cell(18,5,$array_datos[$i][2],'',0,'C');
						$this->Cell(18,5,$array_datos[$i][3],'',0,'C');
						$this->Cell(13,5,number_format($array_datos[$i][8],0),'',0,'R');
						$this->Cell(19,5,number_format($array_datos[$i][13],2,'.',','),'R',0,'R');
						//number_format($this->datos_detalle[$i]['valor_columna'],2,'.',',')
						$s_dias1=$s_dias1+$array_datos[$i][8];
						$s_prom1=$s_prom1+$array_datos[$i][13];
						
						$t_dias1=$t_dias1+$array_datos[$i][8];
						$t_prom1=$t_prom1+$array_datos[$i][13];
						
					}else{
						$this->Cell(18,5,'','',0,'C');
						$this->Cell(18,5,'','',0,'C');
						$this->Cell(13,5,'','',0,'C');
						$this->Cell(19,5,'','R',0,'C');
					}
					
					$this->Cell(18,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(13,5,number_format($array_datos[$i][9],0),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][12],2,'.',','),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][11],2,'.',','),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][10],2,'.',','),'',0,'R');
					$this->Cell(19,5,number_format($array_datos[$i][14],2,'.',','),'R',0,'R');
					$this->Cell(20,5,number_format($array_datos[$i][15],2,'.',','),'',1,'R');
					
					$s_dias2=$s_dias2+$array_datos[$i][9];
					$s_cot1=$s_cot1+$array_datos[$i][12]; $s_cot2=$s_cot2+$array_datos[$i][11]; $s_cot3=$s_cot3+$array_datos[$i][10];
					$s_prom2=$s_prom2+$array_datos[$i][14]; $s_prima=$s_prima+$array_datos[$i][15];
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_cot1=$t_cot1+$array_datos[$i][12]; $t_cot2=$t_cot2+$array_datos[$i][11]; $t_cot3=$t_cot3+$array_datos[$i][10];
					$t_prom2=$t_prom2+$array_datos[$i][14]; $t_prima=$t_prima+$array_datos[$i][15];
					
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(70,5,mb_strcut ( $array_datos[$i][6], 0, 38, "UTF-8"),'R',0,'L');
					$this->Cell(68,5,'','R',0,'C');
					$this->Cell(107,5,'','R',0,'C');
					$this->Cell(20,5,'','',1,'L');
				
				}
				$this->gerencia=$array_datos[$i][18];
			}

				//subtotal del ultimo grupo
				$this->Cell(85,5,'SUBTOTAL','TRB',0,'C');
				$this->Cell(36,5,'','TB',0,'C');
				$this->Cell(13,5,number_format($s_dias1,0),'TB',0,'R');
				$this->Cell(19,5,number_format($s_prom1,2,'.',','),'TRB',0,'R');
				$this->Cell(18,5,'','TB',0,'C');
				$this->Cell(13,5,number_format($s_dias2,0),'TB',0,'R');
				$this->Cell(19,5,number_format($s_cot1,2,'.',','),'TB',0,'R');
				$this->Cell(19,5,number_format($s_cot2,2,'.',','),'TB',0,'R');
				$this->Cell(19,5,number_format($s_cot3,2,'.',','),'TB',0,'R');
				$this->Cell(19,5,number_format($s_prom2,2,'.',','),'TBR',0,'R');
				$this->Cell(20,5,number_format($s_prima,2,'.',','),'TB',1,'R');
				//totales
				$this->SetFont('','B',8); $this->Ln(2);
				$this->Cell(85,5,'TOTAL','TRB',0,'C');
				$this->Cell(36,5,'','TB',0,'C');
				$this->Cell(13,5,number_format($t_dias1,0),'TB',0,'R');
				$this->Cell(19,5,number_format($t_prom1,2,'.',','),'TRB',0,'R');
				$this->Cell(18,5,'','TB',0,'C');
				$this->Cell(13,5,number_format($t_dias2,0),'TB',0,'R');
				$this->Cell(19,5,number_format($t_cot1,2,'.',','),'TB',0,'R');
				$this->Cell(19,5,number_format($t_cot2,2,'.',','),'TB',0,'R');
				$this->Cell(19,5,number_format($t_cot3,2,'.',','),'TB',0,'R');
				$this->Cell(19,5,number_format($t_prom2,2,'.',','),'TBR',0,'R');
				$this->Cell(20,5,number_format($t_prima,2,'.',','),'TB',1,'R');
			//----------------------------------*******************
		}else{
		
			for ($i=1; $i<=$cont;$i++){
			
				if($this->gerencia!=$array_datos[$i][18] ){
					$this->gerencia=$array_datos[$i][18];
					//añadimos los subtotales
					$this->Cell(80,5,'SUBTOTAL','TRB',0,'C');
					$this->Cell(34,5,'','TB',0,'C');
					$this->Cell(10,5,number_format($s_dias1,0),'TB',0,'R');
					$this->Cell(16,5,number_format($s_prom1,2,'.',','),'TRB',0,'R');
					$this->Cell(34,5,'','TB',0,'C');
					$this->Cell(10,5,number_format($s_dias2,0),'TB',0,'R');
					$this->Cell(16,5,number_format($s_prom2,2,'.',','),'TBR',0,'R');
					$this->Cell(16,5,number_format($s_prima,2,'.',','),'TB',0,'R');
					
					$this->Cell(16,5,number_format($s_13,2,'.',','),'TB',0,'R');
					$this->Cell(16,5,number_format($s_iva,2,'.',','),'TB',0,'R');
					$this->Cell(16,5,number_format($s_des,2,'.',','),'TB',0,'R');
					$this->Cell(16,5,number_format($s_lq,2,'.',','),'TB',1,'R');
					
					$s_dias1=0; $s_dias2=0;
					$s_prom1=0; $s_prom2=0;
					$s_cot1=0; $s_cot2=0; $s_cot3=0;
					$s_prima=0; $s_13=0; $s_iva=0; $s_des=0; $s_lq=0;
					//----
					
					$this->AddPage();  //echo $this->gerencia.'---'. $array_datos[$i][18].'***'.$array_datos[$i][1]; exit;
					$this->SetX(10);
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(65,5,mb_strcut ( $array_datos[$i][1], 0, 35, "UTF-8"),'R',0,'L');
				
					if($array_datos[$i][8]>0){
						$this->Cell(17,5,$array_datos[$i][2],'',0,'C');
						$this->Cell(17,5,$array_datos[$i][3],'',0,'C');
						$this->Cell(10,5,number_format($array_datos[$i][8],0),'',0,'R');
						$this->Cell(16,5,number_format($array_datos[$i][13],2,'.',','),'R',0,'R');
						
						$s_dias1=$array_datos[$i][8];
						$s_prom1=$array_datos[$i][13];
						
						$t_dias1=$t_dias1+$array_datos[$i][8];
						$t_prom1=$t_prom1+$array_datos[$i][13];
						
					}else{
						$this->Cell(17,5,'','',0,'C');
						$this->Cell(17,5,'','',0,'C');
						$this->Cell(10,5,'','',0,'C');
						$this->Cell(16,5,'','R',0,'C');
					}
					
					$this->Cell(17,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(17,5,$array_datos[$i][5],'',0,'R');
					$this->Cell(10,5,number_format($array_datos[$i][9],0),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][14],2,'.',','),'R',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][15],2,'.',','),'',0,'R');
					
					$this->Cell(16,5,number_format(($array_datos[$i][15]*0.13),2,'.',','),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][16],2,'.',','),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][7],2,'.',','),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][17],2,'.',','),'',1,'R');
					
					
					$s_dias2=$array_datos[$i][9];
					$s_prom2=$array_datos[$i][14]; $s_prima=$array_datos[$i][15];
					$s_13=($array_datos[$i][15]*0.13); $s_iva=$array_datos[$i][16]; $s_des=$array_datos[$i][7]; $s_lq=$array_datos[$i][17];
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_prom2=$t_prom2+$array_datos[$i][14]; $t_prima=$t_prima+$array_datos[$i][15];
					$t_13=$t_13+($array_datos[$i][15]*0.13); $t_iva=$t_iva+$array_datos[$i][16]; 
					$t_des=$t_des+$array_datos[$i][7]; $t_lq=$t_lq+$array_datos[$i][17];
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(65,5,$array_datos[$i][6],'R',0,'L');
					$this->Cell(60,5,'','R',0,'C');
					$this->Cell(60,5,'','R',0,'C');
					$this->Cell(80,5,'','',1,'L');
					
				}else{
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(65,5,mb_strcut ( $array_datos[$i][1], 0, 35, "UTF-8"),'R',0,'L');
					
					if($array_datos[$i][8]>0){
						$this->Cell(17,5,$array_datos[$i][2],'',0,'C');
						$this->Cell(17,5,$array_datos[$i][3],'',0,'C');
						$this->Cell(10,5,number_format($array_datos[$i][8],0),'',0,'R');
						$this->Cell(16,5,number_format($array_datos[$i][13],2,'.',','),'R',0,'R');
						
						$s_dias1=$s_dias1+$array_datos[$i][8];
						$s_prom1=$s_prom1+$array_datos[$i][13];
						
						$t_dias1=$t_dias1+$array_datos[$i][8];
						$t_prom1=$t_prom1+$array_datos[$i][13];
					}else{
						$this->Cell(17,5,'','',0,'C');
						$this->Cell(17,5,'','',0,'C');
						$this->Cell(10,5,'','',0,'C');
						$this->Cell(16,5,'','R',0,'C');
					}
					
					$this->Cell(17,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(17,5,$array_datos[$i][5],'',0,'R');
					$this->Cell(10,5,number_format($array_datos[$i][9],0),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][14],2,'.',','),'R',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][15],2,'.',','),'',0,'R');
					
					$this->Cell(16,5,number_format(($array_datos[$i][15]*0.13),2,'.',','),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][16],2,'.',','),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][7],2,'.',','),'',0,'R');
					$this->Cell(16,5,number_format($array_datos[$i][17],2,'.',','),'',1,'R');
					
					$s_dias2=$s_dias2+$array_datos[$i][9];
					$s_prom2=$s_prom2+$array_datos[$i][14]; $s_prima=$s_prima+$array_datos[$i][15];
					$s_13=$s_13+($array_datos[$i][15]*0.13); $s_iva=$s_iva+$array_datos[$i][16]; $s_des=$s_des+$array_datos[$i][7]; $s_lq=$s_lq+$array_datos[$i][17];
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_prom2=$t_prom2+$array_datos[$i][14]; $t_prima=$t_prima+$array_datos[$i][15];
					$t_13=$t_13+($array_datos[$i][15]*0.13);
					
					 $t_iva=$t_iva+$array_datos[$i][16]; 
					$t_des=$t_des+$array_datos[$i][7]; $t_lq=$t_lq+$array_datos[$i][17];
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(65,5,mb_strcut ( $array_datos[$i][6], 0, 35, "UTF-8"),'R',0,'L');
					$this->Cell(60,5,'','R',0,'C');
					$this->Cell(60,5,'','R',0,'C');
					$this->Cell(80,5,'','',1,'L');
				
				}
				$this->gerencia=$array_datos[$i][18];
			}

				//
				$this->Cell(80,5,'SUBTOTAL','TRB',0,'C');
				$this->Cell(34,5,'','TB',0,'C');
				$this->Cell(10,5,number_format($s_dias1,0),'TB',0,'R');
				$this->Cell(16,5,number_format($s_prom1,2,'.',','),'TRB',0,'R');
				$this->Cell(34,5,'','TB',0,'C');
				$this->Cell(10,5,number_format($s_dias2,0),'TB',0,'R');
				$this->Cell(16,5,number_format($s_prom2,2,'.',','),'TBR',0,'R');
				$this->Cell(16,5,number_format($s_prima,2,'.',','),'TB',0,'R');
				
				$this->Cell(16,5,number_format($s_13,2,'.',','),'TB',0,'R');
				$this->Cell(16,5,number_format($s_iva,2,'.',','),'TB',0,'R');
				$this->Cell(16,5,number_format($s_des,2,'.',','),'TB',0,'R');
				$this->Cell(16,5,number_format($s_lq,2,'.',','),'TB',1,'R');
				//TOTALES
				$this->SetFont('','B',8); $this->Ln(4);
				$this->Cell(80,5,'TOTAL','TRB',0,'C');
				$this->Cell(34,5,'','TB',0,'C');
				$this->Cell(10,5,number_format($t_dias1,0),'TB',0,'R');
				$this->Cell(16,5,number_format($t_prom1,2,'.',','),'TRB',0,'R');
				$this->Cell(34,5,'','TB',0,'C');
				$this->Cell(10,5,number_format($t_dias2,0),'TB',0,'R');
				$this->Cell(16,5,number_format($t_prom2,2,'.',','),'TBR',0,'R');
				$this->Cell(16,5,number_format($t_prima,2,'.',','),'TB',0,'R');
				
				$this->Cell(16,5,number_format($t_13,2,'.',','),'TB',0,'R');
				$this->Cell(16,5,number_format($t_iva,2,'.',','),'TB',0,'R');
				$this->Cell(16,5,number_format($t_des,2,'.',','),'TB',0,'R');
				$this->Cell(16,5,number_format($t_lq,2,'.',','),'TB',1,'R');
		}

	}/*else{//bono de produccion
		 
		 if($this->objParam->getParametro('codigo_planilla')=='BONOVIG'){
		  	
			for ($i=1; $i<=$cont;$i++){
			
				if($this->gerencia!=$array_datos[$i][18] ){
					$this->gerencia=$array_datos[$i][18];
					
					//añadimos los subtotales
					$this->Cell(105,5,'SUBTOTAL','TB',0,'C');
					$this->Cell(25,5,'','TB',0,'C');
					
					$this->Cell(15,5,number_format($s_dias2,0),'TB',0,'R');
					$this->Cell(25,5,number_format($s_prom2,2),'TB',0,'R');
					$this->Cell(25,5,number_format($s_prima,2,'.',','),'TB',0,'R');
					$this->Cell(25,5,number_format($s_cot1,2,'.',','),'TB',0,'R');
					$this->Cell(25,5,number_format($s_cot2,2,'.',','),'TB',0,'R');
					$this->Cell(25,5,number_format($s_cot3,2,'.',','),'TB',1,'R');
					
					$s_dias2=0;
					$s_prom2=0;
					$s_cot1=0; $s_cot2=0; $s_cot3=0;
					$s_prima=0; 
					//----
					
					
					
					$this->AddPage();  //echo $this->gerencia.'---'. $array_datos[$i][18].'***'.$array_datos[$i][1]; exit;
					$this->SetX(10);
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(90,5,mb_strcut ( $array_datos[$i][1], 0, 38, "UTF-8"),'',0,'L');
				
					
				    $this->Cell(25,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(15,5,number_format($array_datos[$i][9],0),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][14],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][20],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][17],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][19],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][23],2,'.',','),'',1,'R');
					
					$s_dias2=$s_dias2+$array_datos[$i][9];
					$s_prom2=$s_prom2+$array_datos[$i][14]; 
					$s_prima=$s_prima+$array_datos[$i][20];
					$s_cot1=$s_cot1+ $array_datos[$i][17]; 
					$s_cot2=$s_cot2+$array_datos[$i][19]; 
					$s_cot3=$s_cot3+$array_datos[$i][23];
					
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_prom2=$t_prom2+$array_datos[$i][14]; 
					$t_prima=$t_prima+$array_datos[$i][20];
					$t_cot1=$t_cot1+ $array_datos[$i][17]; 
					$t_cot2=$t_cot2+$array_datos[$i][19]; 
					$t_cot3=$t_cot3+$array_datos[$i][23];
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(80,5,mb_strcut ( $array_datos[$i][6], 0, 38, "UTF-8"),'',0,'L');
					$this->Cell(115,5,'','',1,'C');
					
				}else{
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(90,5,mb_strcut ( $array_datos[$i][1], 0, 38, "UTF-8"),'',0,'L');
					
					
					
					$this->Cell(25,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(15,5,number_format($array_datos[$i][9],0),'',0,'R');
					
					$this->Cell(25,5,number_format($array_datos[$i][14],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][20],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][17],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][19],2,'.',','),'',0,'R');
					$this->Cell(25,5,number_format($array_datos[$i][23],2,'.',','),'',1,'R');
					
					
					$s_dias2=$s_dias2+$array_datos[$i][9];
					$s_prom2=$s_prom2+$array_datos[$i][14]; 
					$s_prima=$s_prima+$array_datos[$i][20];
					$s_cot1=$s_cot1+ $array_datos[$i][17]; 
					$s_cot2=$s_cot2+$array_datos[$i][19]; 
					$s_cot3=$s_cot3+$array_datos[$i][23];
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_prom2=$t_prom2+$array_datos[$i][14]; 
					$t_prima=$t_prima+$array_datos[$i][20];
					$t_cot1=$t_cot1+ $array_datos[$i][17]; 
					$t_cot2=$t_cot2+$array_datos[$i][19]; 
					$t_cot3=$t_cot3+$array_datos[$i][23];
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(90,5,mb_strcut ( $array_datos[$i][6], 0, 38, "UTF-8"),'',0,'L');
					
					
					$this->Cell(110,5,'','',1,'L');
				
				}
				$this->gerencia=$array_datos[$i][18];
			}


				//subtotal del ultimo grupo
				$this->Cell(105,5,'SUBTOTAL','TB',0,'C');
				$this->Cell(25,5,'','TB',0,'C');
				$this->Cell(15,5,number_format($s_dias2,0),'TB',0,'R');
				$this->Cell(25,5,number_format($s_prom2,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($s_prima,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($s_cot1,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($s_cot2,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($s_cot3,2,'.',','),'TB',1,'R');
				//totales
				$this->SetFont('','B',8); $this->Ln(2);
				$this->Cell(105,5,'TOTAL','TB',0,'C');
				$this->Cell(25,5,'','TB',0,'C');
				$this->Cell(15,5,number_format($t_dias2,0),'TB',0,'R');
				$this->Cell(25,5,number_format($t_prom2,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($t_prima,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($t_cot1,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($t_cot2,2,'.',','),'TB',0,'R');
				$this->Cell(25,5,number_format($t_cot3,2,'.',','),'TB',1,'R');
			
		}else{
					$s_dias2=0;
					$s_prom2=0;
					$s_dias1=0; //porc 22
					$s_prima=0; $s_13=0; 
					$s_iva=0; $s_des=0; $s_lq=0;
					$s_cot1=0;//apcaj 
					$s_cot2=0;
			for ($i=1; $i<=$cont;$i++){
			
				if($this->gerencia!=$array_datos[$i][18] ){
					$this->gerencia=$array_datos[$i][18];
					//añadimos los subtotales
					$this->Cell(85,5,'SUBTOTAL','TB',0,'C');
					$this->Cell(64,5,'','TB',0,'C');
					$this->Cell(10,5,number_format($s_dias2,0),'TB',0,'R');
					$this->Cell(17,5,number_format($s_prom2,2,'.',','),'TB',0,'R');
					$this->Cell(20,5,number_format($s_dias1,2,'.',','),'TB',0,'R');
					$this->Cell(17,5,number_format($s_prima,2,'.',','),'TB',0,'R');
					$this->Cell(17,5,number_format($s_13,2,'.',','),'TB',0,'R');
					$this->Cell(17,5,number_format($s_lq,2,'.',','),'TB',0,'R');
					
					$this->Cell(17,5,number_format($s_cot1,2,'.',','),'TB',0,'R');
					$this->Cell(17,5,number_format($s_cot2,2,'.',','),'TB',1,'R');
					
					
					$s_dias2=0;
					$s_prom2=0;
					$s_dias1=0; //porc 22
					$s_prima=0; $s_13=0; 
					$s_iva=0; $s_des=0; $s_lq=0;
					$s_cot1=0;//apcaj 
					$s_cot2=0;//costo_total
					
					//----
					
					$this->AddPage();  //echo $this->gerencia.'---'. $array_datos[$i][18].'***'.$array_datos[$i][1]; exit;
					$this->SetX(10);
					
					
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(70,5,mb_strcut ( $array_datos[$i][1], 0, 38, "UTF-8"),'',0,'L');
				
					$this->Cell(17,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(17,5,$array_datos[$i][5],'',0,'R');
					$this->Cell(10,5,'','',0,'L');
					$this->Cell(20,5,mb_strcut ($array_datos[$i][21], 0, 18, "UTF-8"),'',0,'L');
					$this->Cell(10,5,number_format($array_datos[$i][9],0),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][14],2,'.',','),'',0,'R');
					$this->Cell(20,5,number_format($array_datos[$i][22],2,'.',','),'',0,'R');
					
					$this->Cell(17,5,number_format(($array_datos[$i][20]),2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][7],2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][17],2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][19],2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][23],2,'.',','),'',1,'R');
					
					
					$s_dias2=$s_dias2+$array_datos[$i][9];
					$s_prom2=$s_prom2+$array_datos[$i][14]; 
					$s_dias1=$s_dias1+$array_datos[$i][22];//porc
					$s_prima=$s_prima+$array_datos[$i][20];
					$s_13=$s_13+($array_datos[$i][7]); 
					$s_lq=$s_lq+$array_datos[$i][17];
					$s_cot1=$s_cot1+$array_datos[$i][19];
					$s_cot2=$s_cot2+$array_datos[$i][23];
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_prom2=$t_prom2+$array_datos[$i][14]; 
					$t_dias1=$t_dias1+$array_datos[$i][22];//porc
					$t_prima=$t_prima+$array_datos[$i][20];
					$t_13=$t_13+($array_datos[$i][7]); 
					$t_lq=$t_lq+$array_datos[$i][17];
					$t_cot1=$t_cot1+$array_datos[$i][19];
					$t_cot2=$t_cot2+$array_datos[$i][23];
					
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(70,5,mb_strcut ($array_datos[$i][6], 0, 38, "UTF-8"),'',0,'L');
					$this->Cell(102,5,'','',1,'C');
					
					
				}else{
					
					$this->Cell(15,5,$array_datos[$i][0],'',0,'C');
					$this->Cell(70,5,mb_strcut ( $array_datos[$i][1], 0, 38, "UTF-8"),'',0,'L');
				
					$this->Cell(17,5,$array_datos[$i][4],'',0,'C');
					$this->Cell(17,5,$array_datos[$i][5],'',0,'R');
					$this->Cell(10,5,'','',0,'L');
					$this->Cell(20,5,mb_strcut ($array_datos[$i][21], 0, 18, "UTF-8"),'',0,'L');
					$this->Cell(10,5,number_format($array_datos[$i][9],0),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][14],2,'.',','),'',0,'R');
					$this->Cell(20,5,number_format($array_datos[$i][22],2,'.',','),'',0,'R');
					
					$this->Cell(17,5,number_format(($array_datos[$i][20]),2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][7],2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][17],2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][19],2,'.',','),'',0,'R');
					$this->Cell(17,5,number_format($array_datos[$i][23],2,'.',','),'',1,'R');
					
					
					$s_dias2=$s_dias2+$array_datos[$i][9];
					$s_prom2=$s_prom2+$array_datos[$i][14]; 
					$s_dias1=$s_dias1+$array_datos[$i][22];//porc
					$s_prima=$s_prima+$array_datos[$i][20];
					$s_13=$s_13+($array_datos[$i][7]); 
					$s_lq=$s_lq+$array_datos[$i][17];
					$s_cot1=$s_cot1+$array_datos[$i][19];
					$s_cot2=$s_cot2+$array_datos[$i][23];
					
					$t_dias2=$t_dias2+$array_datos[$i][9];
					$t_prom2=$t_prom2+$array_datos[$i][14]; 
					$t_dias1=$t_dias1+$array_datos[$i][22];//porc
					$t_prima=$t_prima+$array_datos[$i][20];
					$t_13=$t_13+($array_datos[$i][7]); 
					$t_lq=$t_lq+$array_datos[$i][17];
					$t_cot1=$t_cot1+$array_datos[$i][19];
					$t_cot2=$t_cot2+$array_datos[$i][23];
					
					$this->Ln(-1);
					$this->Cell(15,5,'','',0,'C');
					$this->Cell(70,5,mb_strcut ( $array_datos[$i][6], 0, 38, "UTF-8"),'',0,'L');
					$this->Cell(102,5,'','',1,'C');
				
				}
				$this->gerencia=$array_datos[$i][18];
			}
				//
				$this->Cell(85,5,'SUBTOTAL','TB',0,'C');
				$this->Cell(64,5,'','TB',0,'C');
				$this->Cell(10,5,number_format($s_dias2,0),'TB',0,'R');
				$this->Cell(17,5,number_format($s_prom2,2,'.',','),'TB',0,'R');
				$this->Cell(20,5,number_format($s_dias1,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($s_prima,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($s_13,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($s_lq,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($s_cot1,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($s_cot2,2,'.',','),'TB',1,'R');
				
				//TOTALES
				$this->SetFont('','B',8); $this->Ln(4);
				$this->Cell(85,5,'TOTAL','TB',0,'C');
				$this->Cell(64,5,'','TB',0,'C');
				$this->Cell(10,5,number_format($t_dias2,0),'TB',0,'R');
				$this->Cell(17,5,number_format($t_prom2,2,'.',','),'TB',0,'R');
				$this->Cell(20,5,number_format($t_dias1,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($t_prima,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($t_13,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($t_lq,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($t_cot1,2,'.',','),'TB',0,'R');
				$this->Cell(17,5,number_format($t_cot2,2,'.',','),'TB',1,'R');
		}
		
	}	*/
		
	
	}
	
		
		
		
			
	
	
    
}
?>