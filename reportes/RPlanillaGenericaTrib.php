<?php
// Extend the TCPDF class to create custom MultiRow
/**
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM-KPLIAN			Creacion
 #83	ETR				10.12.2019			MZM-KPLIAN			Habilitacion de opcion historico de planilla
 #123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019) 
 #ETR-1527				27.11.2020			MZM-KPLIAN			Cambios en formato para planilla tributaria V.3
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
		
		if(count($this->datos_detalle)>0){
			
		
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], 5, 5, 30, 10);
		$this->SetFont('','B',7);
		$this->ln(1);
		$this->Cell($this->ancho_hoja-20,3,'',0,0,'R');
		$this->Cell(40,3,$this->datos_titulo['depto'],0,1,'C');
		$this->Cell($this->ancho_hoja-20,3,'',0,0,'R');
		$this->Cell(40,3,$this->datos_titulo['uo'],0,1,'R');
		
		
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
		$this->SetFont('','B',12);
		$this->Cell(0,5,$this->datos_titulo['titulo_reporte'],0,1,'C');
		$this->SetFont('','B',10);
		$this->Cell(0,5,'Correspondiente a: '. str_replace ('de ','',$this->datos_titulo['periodo_lite']) ,0,1,'C');
		
		$this->SetFont('','B',7);
		$this->Cell($this->ancho_hoja,3.5,'U.F.V. Anterior: ' ,0,0,'R');
		$this->SetFont('','U',7);
		$this->Cell(10,3.5,number_format($this->datos_titulo['ufv_ini'],6,'.',','),0,1,'L'); //#80
		$this->SetFont('','B',7);
		$this->Cell($this->ancho_hoja,3.5,'U.F.V. Actual: ' ,0,0,'R');
		$this->SetFont('','U',7);
		$this->Cell(10,3.5,number_format($this->datos_titulo['ufv_fin'],6,'.',','),0,1,'L');//#80
			
		$this->ln(1.7);
		$this->SetFont('','B',6.5);
		$columnas = 0;
		//$this->SetLineWidth(0.1);
		//$this->SetDrawColor(0,0,0);
		//$this->Cell(0,0,'','B',1);
		$this->ln(1);
		//MultiCell($w, $h, $txt, $border=0, $align='J', $fill=0, $ln=1, $x='', $y='', $reseth=true, $stretch=0)
		//#ETR-1527
		$this->MultiCell(7,3.5,'                                       Año                                         ','TLRB','C',0,0);//1
		$this->MultiCell(6,3.5,'                           Perio   do                                   ','TRB','C',0,0);//2
		$this->MultiCell(15,3.5,'                                                                             Codigo       dependiente        RcIVA                                                                 ','TRB','C',0,0);//3
		$this->MultiCell(17,3.5,'                                                                                                                Nombres                                                                                             ','TRB','C',0,0);//4
		$this->MultiCell(17,3.5,'                                                                                         Primer              Apellido                                                                                              ','TRB','C',0,0);//5
		$this->MultiCell(17,3.5,'                                                                                      Segundo             Apellido                                                                                              ','TRB','C',0,0);//6
		$this->MultiCell(13,3.5,'                                             Numero de Documento de identidad                                          ','TRB','C',0,0);//7
		$this->MultiCell(7,3.5,'                         Tipo    de    documento                          ','TRB','C',0,0);//8 
		$this->MultiCell(10,3.5,'             Novedades (I=Incorporacion, V=Vigente, D=Desvinculado)              ','TRB','C',0,0);//9
		$this->MultiCell(12,3.5,'                                         Monto            de          Ingreso         Neto                                                ','TRB','C',0,0);//10
		$this->MultiCell(10,3.5,'                 Dos(2) Salarios Minimos Nacionales          no     imponibles                 ','TRB','C',0,0);//11
		$this->MultiCell(12,3.5,'                             Importe sujeto a impuesto (base imponible)                        ','TRB','C',0,0);//12
		$this->MultiCell(12,3.5,'                                                          Impuesto     RCIVA                                                                     ','TRB','C',0,0);//13
		$this->MultiCell(12,3.5,'                                        13% de       Dos(2)       Salarios     Minimos  Nacionales                             ','TRB','C',0,0);//14
		$this->MultiCell(12,3.5,'                                                   Impuesto        Neto          RCIVA                                              ','TRB','C',0,0);//15
		$this->MultiCell(12,3.5,'                                                                    F-110 Casilla 693                                           ','TRB','C',0,0);//16
		$this->MultiCell(12,3.5,'                                                       Saldo a favor del        Fisco                                                  ','TRB','C',0,0);//17
		$this->MultiCell(12,3.5,'                                                            Saldo a    favor del dependiente                                    ','TRB','C',0,0);//18
		$this->MultiCell(12,3.5,'                                        Saldo a      favor del dependiente periodo    anterior                                       ','TRB','C',0,0);//19
		$this->MultiCell(10,3.5,'Mantenimiento de valor de saldo a favor dependiente periodo anterior','TRB','C',0,0);//20
		$this->MultiCell(12,3.5,'                                     Saldo del     periodo      anterior  actualizado                                         ','TRB','C',0,0);//21 
		$this->MultiCell(12,3.5,'                                                            Saldo       utilizado                                                               ','TRB','C',0,0);//22
		$this->MultiCell(12,3.5,'                                                      Saldo RcIVA sujeto a retencion                                     ','TRB','C',0,0);//23
		$this->MultiCell(10,3.5,'                                 Pago Cta SIETE-RG periodo anterior                                 ','TRB','C',0,0);//24
		$this->MultiCell(10,3.5,'                                                   F-110     Casilla       465                                                ','TRB','C',0,0);//25
		$this->MultiCell(10,3.5,'                                  Total       Saldo  SIETE-RG del periodo                             ','TRB','C',0,0);//26
		$this->MultiCell(10,3.5,'                                   Pago        Cta    SIETE-RG utilizado                              ','TRB','C',0,0);//27
		$this->MultiCell(10,3.5,'                                             Impuesto RcIVA retenido                                        ','TRB','C',0,0);//28
		$this->MultiCell(12,3.5,'         Saldo del credito fiscal a favor del dependiente para el mes siguiente','TRB','C',0,0);//29
		$this->MultiCell(12,3.5,'         Saldo de pago SIETE-RG a favor del dependiente para el mes siguiente','TRB','C',0,1);//30
		
		///------
		
		/*$this->MultiCell(7,3.5,'     a     ','TLRB','C',0,0);//1
		$this->MultiCell(6,3.5,'    b     ','TRB','C',0,0);//2
		$this->MultiCell(15,3.5,'           c             ','TRB','C',0,0);//3
		$this->MultiCell(17,3.5,'            d              ','TRB','C',0,0);//4
		$this->MultiCell(17,3.5,'            e              ','TRB','C',0,0);//5
		$this->MultiCell(17,3.5,'             f              ','TRB','C',0,0);//6
		$this->MultiCell(13,3.5,'         g            ','TRB','C',0,0);//7
		$this->MultiCell(7,3.5,'     h     ','TRB','C',0,0);//8 
		$this->MultiCell(12,3.5,'         i           ','TRB','C',0,0);//9
		$this->MultiCell(10,3.5,'        j           ','TRB','C',0,0);//10
		$this->MultiCell(10,3.5,'        k           ','TRB','C',0,0);//11
		$this->MultiCell(12,3.5,'l=j-k (si j>k)','TRB','C',0,0);//12
		$this->MultiCell(12,3.5,'  m=l*13%    ','TRB','C',0,0);//13
		$this->MultiCell(12,3.5,'        n          ','TRB','C',0,0);//14
		$this->MultiCell(12,3.5,'o=m-n (si m>n)','TRB','C',0,0);//15
		$this->MultiCell(12,3.5,'        p          ','TRB','C',0,0);//16
		$this->MultiCell(12,3.5,'q=o-p (si o>p)','TRB','C',0,0);//17
		$this->MultiCell(12,3.5,'r=p-o (si p>o)','TRB','C',0,0);//18
		$this->MultiCell(12,3.5,'        s          ','TRB','C',0,0);//19
		$this->MultiCell(10,3.5,'        t          ','TRB','C',0,0);//20
		$this->MultiCell(12,3.5,'      u=s+t      ','TRB','C',0,0);//21 
		$this->MultiCell(12,3.5,'v=u(si u<=q)','TRB','C',0,0);//22
		$this->MultiCell(12,3.5,'w=q-v(si q>v)','TRB','C',0,0);//23
		$this->MultiCell(10,3.5,'        x          ','TRB','C',0,0);//24
		$this->MultiCell(10,3.5,'        y          ','TRB','C',0,0);//25
		$this->MultiCell(10,3.5,'   z=x+y    ','TRB','C',0,0);//26
		$this->MultiCell(10,3.5,'aa=z(si w>=z)','TRB','C',0,0);//27
		$this->MultiCell(10,3.5,' ab=w-aa  ','TRB','C',0,0);//28
		$this->MultiCell(12,3.5,'   ac=r+u-v  ','TRB','C',0,0);//29
		$this->MultiCell(12,3.5,'    ad=z-aa   ','TRB','C',0,1);//30
		*/
		
		
		}
	}
	function datosHeader ($titulo, $detalle) {  
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_titulo = $titulo;
		$this->datos_detalle = $detalle;
		//Titulos de columnas inferiores e iniciacion de los arreglos para la tabla
		$this->ancho_sin_totales = 0;
		$this->cantidad_columnas_estaticas = 0;
		
		$this->SetMargins(5, 61.2, 5);
	}
	function generarReporte() {
		
		
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//iniciacion de datos 
		$id_funcionario = 0;
		
		$sum_total = array();
		$detalle_col_mod=array();   $totales=array();
		$columnas = 0;
		$cont=0;
		$this->tablewidths=array(7,6,15,17,17,17,13,7,10,12,10,12,12,12,12,12,12,12,12,10,12,12,12,10,10,10,10,10,12,12);
		$this->tablealigns=array('L','C','L','L','L','L','R','C','C','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R','R');	
		$this->tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
		$this->tableborders	=array(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
		$this->SetFont('','',6.5);
		
			
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
			  array_push($detalle_col_mod, mb_strcut($this->datos_detalle[$i]['nombre'], 0, 10, "UTF-8"));
			  array_push($detalle_col_mod, mb_strcut($this->datos_detalle[$i]['apellido_paterno'], 0, 11, "UTF-8"));
			  array_push($detalle_col_mod, mb_strcut($this->datos_detalle[$i]['apellido_materno'], 0, 11, "UTF-8"));
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['num_ci']);
			  //array_push($detalle_col_mod, $this->datos_detalle[$i]['tipo_documento']);
			  array_push($detalle_col_mod, 'CI');
			  array_push($detalle_col_mod, $this->datos_detalle[$i]['novedad']);
			  array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor'],2,'.',','));
			  $cont=0;
			  
			} else{
	 	  	  array_push($detalle_col_mod, number_format($this->datos_detalle[$i]['valor'],2,'.',','));
			  $cont++;
			}
			 $totales[$cont] += $this->datos_detalle[$i]['valor'];
			 
			 
			 
			 $id_funcionario=$this->datos_detalle[$i]['id_funcionario'];
		}
		
		
		$this->UniRow($detalle_col_mod,false,0);
		$this->Cell(109 ,3,'TOTAL GENERAL','LTB',0,'C');//#50
		$this->SetFont('','',5.5);
		for ($i = 0; $i < 21; $i++) {//#80
			 if ($i==1 ||$i==10 || $i==14 || $i==15 ||$i==16 || $i==17 || $i==18 ){
			 	$this->Cell(10,3,number_format($totales[$i],2,'.',','),1,0,'R');//#50
			 }else{
			 	if ($i==0){
			 		$this->Cell(12,3,number_format($totales[$i],2,'.',','),'TBR',0,'R');//#50
			 	}else{
			 		$this->Cell(12,3,number_format($totales[$i],2,'.',','),1,0,'R');//#50
			 	}
				
			 		
			 }
		}
		
		
		//$this->UniRow($totales,false,0);				
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