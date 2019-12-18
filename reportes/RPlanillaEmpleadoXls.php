<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #77    ETR            14/11/2019           MZM                 Creacion 
 #80	ETR				25.11.2019			MZM					Ajuste formato numeric, inclusion de totales, campo de columna en nomina salarios ct
*/
class RPlanillaEmpleadoXls
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    var $datos_detalle;
    var $datos_titulo;
    public  $url_archivo;
    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        //ini_set('memory_limit','512M');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);




        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
            ->setLastModifiedBy("PXP")
            ->setTitle($tit_rep)
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");


        $this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
            9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
            18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
            26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
            34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
            42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
            50=>'AY',51=>'AZ',
            52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
            60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
            68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
            76=>'BY',77=>'BZ');

    }

    public function addHoja($name,$index){
        //$index = $this->docexcel->getSheetCount();
        //echo($index);
        $this->docexcel->createSheet($index)->setTitle('XXXXX'.$name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function imprimeCabecera() {
        

    }

    function generarDatos($data)
    {
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '626eba'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '3287c1'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->numero = 1;
        $fila = 3;
       // $columna = 8;
        $datos = $data;//$this->objParam->getParametro('datos');var_dump($datos);exit;
        //subtotales
        $tipo_contrato = '';
        $desc_func = '';
        $codigo_pres = '';
        //$this->imprimeCabecera(0);

        $numberFormat = '#,##0.00';
        $cant_datos = count($datos);
        $total_bono = 0;
        $total_sueldo = 0;
        $total_frontera = 0;
        $codigo_col = '';
        $index = 0;
        $color_pestana = array('ff0000','1100ff','55ff00','3ba3ff','ff4747','697dff','78edff','ba8cff',
            'ff80bb','ff792b','ffff5e','52ff97','bae3ff','ffaf9c','bfffc6','b370ff','ffa8b4','7583ff','9aff17','ff30c8');


       
       // foreach ($datos as $value)
        //{
            
           // if($tipo_contrato != $value['estado']){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                $this->addHoja($value['tipo_contrato'],$index);
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
				
                if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'|| $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios'){    
	                $this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
	                $this->docexcel->getActiveSheet()->getStyle('A3:G3')->applyFromArray($styleTitulos3);
				}else{
					
					if ($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
						$this->docexcel->getActiveSheet()->getStyle('A3:I3')->getAlignment()->setWrapText(true);
                		$this->docexcel->getActiveSheet()->getStyle('A3:I3')->applyFromArray($styleTitulos3);
					}elseif($this->objParam->getParametro('tipo_reporte')=='no_sindicato'){
						
						$this->docexcel->getActiveSheet()->getStyle('A3:E3')->getAlignment()->setWrapText(true);
                		$this->docexcel->getActiveSheet()->getStyle('A3:E3')->applyFromArray($styleTitulos3);
						
					}
					
					
					else{
						$this->docexcel->getActiveSheet()->getStyle('A3:F3')->getAlignment()->setWrapText(true);
                		$this->docexcel->getActiveSheet()->getStyle('A3:F3')->applyFromArray($styleTitulos3);
					
					}
				
				}
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,4);
                $fila=4;
                $this->numero=1;
                //$columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
				
				if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'|| $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3' || $this->objParam->getParametro('tipo_reporte')=='reserva_beneficios'){
	                $this->docexcel->getActiveSheet()->setTitle('BeneficiosSociales');
	                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);//categoria
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
	                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
	                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);//cargo
	                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);//fecha
	                
					
	                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo Empleado');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','nombre Completo');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C3','Fecha Ingreso');//3
	                $this->docexcel->getActiveSheet()->setCellValue('D3','Dias Trabajados');//4
	                $this->docexcel->getActiveSheet()->setCellValue('E3','Cotizable');//5
	                $this->docexcel->getActiveSheet()->setCellValue('F3','Reserva Bs');//6
	                $this->docexcel->getActiveSheet()->setCellValue('G3','Reserva USD');//7
	                
	                $this->docexcel->getActiveSheet()->getStyle('E')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
					$this->docexcel->getActiveSheet()->getStyle('F')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
					$this->docexcel->getActiveSheet()->getStyle('G')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
				}elseif($this->objParam->getParametro('tipo_reporte')=='no_sindicato'){
					$this->docexcel->getActiveSheet()->setTitle('PersonalNoSind');
	                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);//categoria
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(30);//ci
	                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
					
					$this->docexcel->getActiveSheet()->setCellValue('A3','Codigo Empleado');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','nombre Completo');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C3','CI');
					$this->docexcel->getActiveSheet()->setCellValue('D3','Distrito');
					$this->docexcel->getActiveSheet()->setCellValue('E3','Aporte(Bs)');
				}
				
				
				else{//nomina_Sal, nomina_sal1
					$this->docexcel->getActiveSheet()->setTitle('NominaSalarios');
	                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);//categoria
	                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);//pres
	                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
	                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
	                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);//cargo
	                
	                if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
		                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);//fecha
		                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);//fecha
		                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);//fecha
					}
					
	                $this->docexcel->getActiveSheet()->setCellValue('A3','Codigo Empleado');//1
	                $this->docexcel->getActiveSheet()->setCellValue('B3','nombre Completo');//2
	                $this->docexcel->getActiveSheet()->setCellValue('C3','Cargo');//3
	                
	                if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
	                	$this->docexcel->getActiveSheet()->setCellValue('D3','Fecha Ingreso');//4
		                $this->docexcel->getActiveSheet()->setCellValue('E3','Nivel');//5
		                $this->docexcel->getActiveSheet()->setCellValue('F3','S. Basico (Bs)');//6
		                $this->docexcel->getActiveSheet()->setCellValue('G3','T. Cotizable (Bs)');//7
		                $this->docexcel->getActiveSheet()->setCellValue('H3','Nivel Limite');//7
		                $this->docexcel->getActiveSheet()->setCellValue('I3','Basico Limite');//7
		                
		                $this->docexcel->getActiveSheet()->getStyle('F')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
						$this->docexcel->getActiveSheet()->getStyle('H')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
						$this->docexcel->getActiveSheet()->getStyle('G')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
				
	                }else{
	                	 
		                $this->docexcel->getActiveSheet()->setCellValue('D3','Nivel');//5
		                $this->docexcel->getActiveSheet()->setCellValue('E3','T. Cotizable (Bs)');//6
		                $this->docexcel->getActiveSheet()->setCellValue('F3','Costo Total (Bs)');//7
		                
		                
		                $this->docexcel->getActiveSheet()->getStyle('F')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
						$this->docexcel->getActiveSheet()->getStyle('E')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
						
				
	                }
	                
	               }
                
                
                
if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
	$tit_rep='BENEFICIOS SOCIALES - RESUMEN';
}elseif($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
	$tit_rep='PLANILLA DE RESERVA PARA BENEFICIOS SOCIALES';

}elseif($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios'){
	$tit_rep='BENEFICIOS SOCIALES - 1 MES';
}elseif ($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
	$tit_rep='NOMINA DE SALARIOS BC';
}elseif ($this->objParam->getParametro('tipo_reporte')=='nomina_salario1'){
	$tit_rep='NOMINA DE SALARIOS CT';
}elseif ($this->objParam->getParametro('tipo_reporte')=='no_sindicato'){
	$tit_rep='NOMINA DE PERSONAL NO SINDICALIZADO';
}

                $this->docexcel->getActiveSheet()->mergeCells("A1:G1"); 
				$this->docexcel->getActiveSheet()->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				$this->docexcel->getActiveSheet()->setCellValue('A1', $tit_rep);
				 $this->docexcel->getActiveSheet()->mergeCells("A2:G2");
				 $this->docexcel->getActiveSheet()->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				 
				 if ($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1' || $this->objParam->getParametro('tipo_reporte')=='no_sindicato'){
					$this->docexcel->getActiveSheet()->setCellValue('A2', 'A: '.$datos[0]['periodo']);
				 }else{
				 	$this->docexcel->getActiveSheet()->setCellValue('A2', 'A: '.$this->objParam->getParametro('fecha').'         T/C:'.$datos[0]['tc']);
				 }
				 
				
				
				$nombre_centro='';
				$tot_cot=0;
				$tot_reserva=0;
				$tot_reserva1=0;
				
			if($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios'){
				
				foreach ($datos as $value){

					$dias=(($value['anos_quinquenio']*360)+($value['mes_quinquenio']*30)+($value['dias_quinquenio']));
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_empleado']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_empleado']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,date_format(date_create($value['fecha_quinquenio']),'d/m/Y') );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $dias);
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,number_format($value['valor'],2,'.',',') );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format(($value['valor']/360*$dias),2,'.',','));
					$val_tc=($value['valor']/360*$dias/$value['tc']);
					//$value['tc']
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($val_tc,2,'.',','));
                  
				    $tot_cot=$tot_cot+$value['valor'];
				  	$tot_reserva=$tot_reserva+($value['valor']/360*$dias);
					$tot_reserva1=$tot_reserva1+$val_tc;
					$fila++;
				}
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,'TOTALES' );
              		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,number_format($tot_cot,2,'.',',') );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($tot_reserva,2,'.',','));
					$val_tc=($value['valor']/360*$dias/$value['tc']);
					//$value['tc']
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($tot_reserva1,2,'.',','));
                  
            }elseif($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios2'){
            	$id_fun=0;
				$prom_cot=0;
				$prom_res=0;
				$prom_res1=0;
				$cont=0;
				$v4=0;
				
            	foreach ($datos as $value){
					
					if($id_fun!=$value['id_funcionario']){
						
							if($id_fun!=0){
						  	    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $v0);
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $v1);
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $v2);
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $v3);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($v4/($cont),2,'.',',') );
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format(($v4/$cont/360*$v3),2,'.',','));
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format(($v4/$cont/360*$v3/$v6),2,'.',','));
			                  	$tot_cot=$tot_cot+($v4/$cont);
								$tot_reserva=$tot_reserva+($v4/$cont/360*$v3);
								$tot_reserva1=$tot_reserva1+($v4/$cont/360*$v3/$v6);
			                  	
			                  	$cont=0; $v1='';$v4=0;
								$fila++;
								$vt4=0;
								$vt5=0;
								$vt6=0;
							}
								
						  
							
							$dias=(($value['anos_quinquenio']*360)+($value['mes_quinquenio']*30)+($value['dias_quinquenio']));
					
							
							
							
							$v0=$value['codigo_empleado'];
							$v1=$value['nombre_empleado'];
							$v2=date_format(date_create($value['fecha_quinquenio']),'d/m/Y');
							$v3=$dias;
							$v4=$v4+$value['valor'];
							$v5=($value['valor']/360*$dias);
							$v6=$value['tc'];
							
							$vt4=$vt4+$v4;
							
							
					}else{
							
							
							$v0=$value['codigo_empleado'];
							$v1=$value['nombre_empleado'];
							$v2=date_format(date_create($value['fecha_quinquenio']),'d/m/Y');
							$dias=(($value['anos_quinquenio']*360)+($value['mes_quinquenio']*30)+($value['dias_quinquenio']));
							$v3=$dias;
							$v4=$v4+$value['valor'];
							$v5=($value['valor']/360*$dias);
							$v6=$value['tc'];
							
							$vt4=$vt4+$v4;
							
					}
					
					
					$cont++;
					$id_fun=$value['id_funcionario'];
					
					
				}

						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $v0);
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $v1);
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $v2);
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $v3);
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($v4/($cont),2,'.',',') );
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format((($v4/$cont)/360*$v3),2,'.',','));
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format(((($v4/$cont)/360*$v3)/$v6),2,'.',','));
			         $fila++;  
					        	
					$tot_cot=$tot_cot+($v4/$cont);
					$tot_reserva=$tot_reserva+($v4/$cont/360*$v3);
					$tot_reserva1=$tot_reserva1+($v4/$cont/360*$v3/$v6);
			                  	
								
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,'TOTALES' );
              		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,number_format($tot_cot,2,'.',',') );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($tot_reserva,2,'.',','));
					$val_tc=($value['valor']/360*$dias/$value['tc']);
					
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($tot_reserva1,2,'.',','));

					
            }elseif($this->objParam->getParametro('tipo_reporte')=='reserva_beneficios3'){
            	$id_fun=0;//$datos[0]['id_funcionario'];
				$cont=0;
				$bandera=0;
				$v0=''; $v1=''; $v2=''; $v3=''; $v4=0; $v5=0; $v6=0; 
				
				$vt4=0;
				$vt5=0;
				$vt6=0;
				foreach ($datos as $value){
					$dias=(($value['anos_quinquenio']*360)+($value['mes_quinquenio']*30)+($value['dias_quinquenio']));
					
					if($id_fun!=$value['id_funcionario']){
						  
						 if($id_fun!=0){
						 	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, '');
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, '');
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, '' );
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, '');
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($vt4/$cont,2,'.',',') );
			                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($vt5/$cont,2,'.',','));
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($vt6/$cont,2,'.',','));
			                  	
								$tot_cot=$tot_cot+($vt4/$cont);
								$tot_reserva=$tot_reserva+($vt5/$cont);
								$tot_reserva1=$tot_reserva1+($vt6/$cont);
								
								$cont=0; $v1='';
								$fila++;
								
								$vt4=0;
								$vt5=0;
								$vt6=0;
						 } 
						  	    
						  
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_empleado']);
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_empleado']);
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,date_format(date_create($value['fecha_quinquenio']),'d/m/Y') );
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $dias);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,number_format($value['valor'],2,'.',',') );
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, '');
							$val_tc=($value['valor']/360*$dias/$value['tc']);
							//$value['tc']
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, '');
		                  	
							$v0=$value['codigo_empleado'];
							$v1=$value['nombre_empleado'];
							$v2=date_format(date_create($value['fecha_quinquenio']),'d/m/Y');
							$v3=$dias;
							$v4=$value['valor'];
							$v5=($value['valor']/360*$dias);
							$v6=$val_tc;
							
							$vt4=$vt4+$v4;
							$vt5=$vt5+$v5;
							$vt6=$vt6+$v6;
							
							
							
							
					}else{
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, '');
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, '');
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, '' );
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, '');
							
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,number_format($value['valor'],2,'.',',') );
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, '');
							$val_tc=($value['valor']/360*$dias/$value['tc']);
							//$value['tc']
		                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, '');
							
							
							$v0=$value['codigo_empleado'];
							$v1=$value['nombre_empleado'];
							$v2=date_format(date_create($value['fecha_quinquenio']),'d/m/Y');
							$v3=$dias;
							$v4=$value['valor'];
							$v5=($value['valor']/360*$dias);
							$v6=$val_tc;
							
							$vt4=$vt4+$v4;
							$vt5=$vt5+$v5;
							$vt6=$vt6+$v6;
							
							
					}
					
					
					$fila++;
					$cont++;
					$id_fun=$value['id_funcionario'];
				}
				
				   $fila++;  
					        	
					$tot_cot=$tot_cot+($vt4/$cont);
					$tot_reserva=$tot_reserva+($vt5/$cont);
					$tot_reserva1=$tot_reserva1+($vt6/$cont);         	
								
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,'TOTALES' );
              		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,number_format($tot_cot,2,'.',',') );
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($tot_reserva,2,'.',','));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($tot_reserva1,2,'.',','));
				
				
					
			}elseif ($this->objParam->getParametro('tipo_reporte')=='nomina_salario' || $this->objParam->getParametro('tipo_reporte')=='nomina_salario1' ){
				
				$id_fun=0;
				$ger='';
				$uni='';
				foreach ($datos as $value){
					if($ger!=$value['nombre_gerencia']){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['nombre_gerencia']);
						$fila++;
					}
					if($ger==$value['nombre_gerencia'] && $uni!=$value['nombre_unidad'] ){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['nombre_unidad']);
						$fila++;
					}
					
					if($id_fun!=$value['id_funcionario']){
						
					
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_empleado']);
			            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_empleado']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['cargo']);
						if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, date_format(date_create($value['fecha_ingreso']),'d/m/Y') );
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nivel']);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($value['valor'],2,'.',','));
							
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['nivel_limite']);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['basico_limite']);
						}else{
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nivel']);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, number_format($value['valor'],2,'.',','));
						}
						
						
					}else{
						if($this->objParam->getParametro('tipo_reporte')=='nomina_salario'){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, number_format($value['valor'],2,'.',','));
						}else{
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, number_format($value['valor'],2,'.',','));
						}
						$fila++;
						
					}
					
					
					$id_fun=$value['id_funcionario'];
					$uni=$value['nombre_unidad'];
					$ger=$value['nombre_gerencia'];
				}
				
			}elseif($this->objParam->getParametro('tipo_reporte')=='no_sindicato'){
				foreach ($datos as $value){
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_empleado']);
			        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_empleado']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['ci'].' '.$value['expedicion']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['distrito']);
					$fila++;	
				}
			}
        //}
       // $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
    }
    function obtenerFechaEnLetra($fecha){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $dia= date("d", strtotime($fecha));
        $anno = date("Y", strtotime($fecha));
        // var_dump()
        $mes = array('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre');
        $mes = $mes[(date('m', strtotime($fecha))*1)-1];
        return $dia.' de '.$mes.' del '.$anno;
    }
    function generarReporte($datos){ 
        $this->generarDatos($datos);
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        //$this->imprimeCabecera(0);

    }

}
?>