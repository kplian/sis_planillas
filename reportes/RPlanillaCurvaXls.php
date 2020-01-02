<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion
 #66	ETR				25.10.2019			MZM					Condicion para reporte por centros
 #81	ETR				06.11.2019			MZM					Adicion de columna estado AFP (Jubilado55, 65, mayor65, activo)
 #83	ETR				10.12.2019			MZM					Habilitacion de opcion historico de planilla 
*/
class RPlanillaCurvaXls
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
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
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
        $this->docexcel->createSheet($index)->setTitle($name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function imprimeCabecera() {
        /*$this->docexcel->createSheet(0);
        $this->docexcel->setActiveSheetIndex(0);
        $this->docexcel->getActiveSheet()->setTitle('Detalle');*/

        /*$this->docexcel->createSheet(1);
        $this->docexcel->setActiveSheetIndex(1);
        $this->docexcel->getActiveSheet()->setTitle('Totales');

        $this->docexcel->setActiveSheetIndex(0);*/




        /*$styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
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
        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),

        );*/

        //titulos

        /*$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'BOLIVIANA DE AVIACIÓN - BOA' );
        $this->docexcel->getActiveSheet()->getStyle('A2:H2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:H2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Bienes de Consumo' );
        $this->docexcel->getActiveSheet()->getStyle('A3:H3')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A3:H3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'AL: '. $this->obtenerFechaEnLetra($this->objParam->getParametro('fecha_hasta')));
        $this->docexcel->getActiveSheet()->getStyle('A4:H4')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A4:H4');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'(Expresado en Bolivianos)' );
        $this->docexcel->getActiveSheet()->getStyle('A5:H5')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A5:H5');*/

        /*$this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);*/



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
        $columna = 8;
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
            //var_dump($value['tipo_contrato']);exit;
           // if($tipo_contrato != $value['estado']){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                $this->addHoja($value['tipo_contrato'],$index);
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
				//#83
				$dr=substr($datos[0]['fecha_backup'],0,2);
				$mr=substr($datos[0]['fecha_backup'],3,2);
				$ar=substr($datos[0]['fecha_backup'],6);
				$this->docexcel->getActiveSheet()->mergeCells("A1:BR1");
				$this->docexcel->getActiveSheet()->getStyle('A1:BR1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				
				if(($dr.'/'.$mr.'/'.$ar)!='01/01/1000'){
					$this->docexcel->getActiveSheet()->setCellValue('A1', 'CURVA SALARIAL A ' .date_format(date_create($datos[0]['fecha_planilla']),'d/m/Y').' [Backup: '.$dr.'/'.$mr.'/'.$ar.']');
				}else{
					$this->docexcel->getActiveSheet()->setCellValue('A1', 'CURVA SALARIAL A ' .date_format(date_create($datos[0]['fecha_planilla']),'d/m/Y'));
				}
				
                $this->docexcel->getActiveSheet()->getStyle('A2:BR2')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A2:BR2')->applyFromArray($styleTitulos3);
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,3);
                $fila=3;
                $this->numero=1;
                $columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
                $this->docexcel->getActiveSheet()->setTitle($value['tipo_contrato']);
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);//categoria
                $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);//pres
                $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);//ci
                $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);//funcionario
                $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);//cargo
                $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);//fecha
                $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(25);//fecha
                $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(25);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(20);//mes

                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('X')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('Y')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('Z')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AA')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AB')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AC')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AD')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AE')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AF')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AG')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AH')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AI')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AJ')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AK')->setWidth(20);//mes
                
                $this->docexcel->getActiveSheet()->getColumnDimension('AL')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AM')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AN')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AO')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AP')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AQ')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AR')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AS')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AT')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('AU')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AV')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AW')->setWidth(20);//mes
				
				$this->docexcel->getActiveSheet()->getColumnDimension('AX')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AY')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('AZ')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BA')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BB')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BC')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BD')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BE')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BF')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BG')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BH')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BI')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BJ')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BK')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BL')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BM')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BN')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BO')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BP')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BQ')->setWidth(20);//mes
				$this->docexcel->getActiveSheet()->getColumnDimension('BR')->setWidth(20);//mes#81
				
				
                $this->docexcel->getActiveSheet()->setCellValue('A2','Cd_Empleado');//1
                $this->docexcel->getActiveSheet()->setCellValue('B2','CI_RUN');//2
                $this->docexcel->getActiveSheet()->setCellValue('C2','Tipo_Identificacion');//3
                $this->docexcel->getActiveSheet()->setCellValue('D2','Lugar_Emision_DI');//4
                $this->docexcel->getActiveSheet()->setCellValue('E2','Nro_AFP');//5
                $this->docexcel->getActiveSheet()->setCellValue('F2','Apellido_P');//6
                $this->docexcel->getActiveSheet()->setCellValue('G2','Apellido_M');//7
                $this->docexcel->getActiveSheet()->setCellValue('H2','Primer_Nombre');//8
                $this->docexcel->getActiveSheet()->setCellValue('I2','Segundo_Nombre');//9
                $this->docexcel->getActiveSheet()->setCellValue('J2','Fecha_Nacimiento');//10
                $this->docexcel->getActiveSheet()->setCellValue('K2','Dir_Domicilio');//11
                $this->docexcel->getActiveSheet()->setCellValue('L2','Telef_Domicilio');//12
                $this->docexcel->getActiveSheet()->setCellValue('M2','Grupo_Sanguineo');//13
                $this->docexcel->getActiveSheet()->setCellValue('N2','Sexo');//14
                $this->docexcel->getActiveSheet()->setCellValue('O2','Estado_Civil');//15
                $this->docexcel->getActiveSheet()->setCellValue('P2','Profesion');//16
                $this->docexcel->getActiveSheet()->setCellValue('Q2','Cargo');//17
                $this->docexcel->getActiveSheet()->setCellValue('R2','Fecha_Ingreso');//18
                $this->docexcel->getActiveSheet()->setCellValue('S2','Fecha_Retiro');//19
                $this->docexcel->getActiveSheet()->setCellValue('T2','Motivo_Retiro');//20
                $this->docexcel->getActiveSheet()->setCellValue('U2','Fecha_Ingreso_contrato1');//21
                $this->docexcel->getActiveSheet()->setCellValue('V2','Fecha_Retiro_contrato1');//22
                $this->docexcel->getActiveSheet()->setCellValue('W2','Fecha_Ingreso_contrato2');//23
                $this->docexcel->getActiveSheet()->setCellValue('X2','Fecha_Retiro_contrato2');//24
                $this->docexcel->getActiveSheet()->setCellValue('Y2','Estado');//25
                $this->docexcel->getActiveSheet()->setCellValue('Z2','Tiempo de contratación');//26
                $this->docexcel->getActiveSheet()->setCellValue('AA2','Distrito');//27
                $this->docexcel->getActiveSheet()->setCellValue('AB2','CeBe');//28
                $this->docexcel->getActiveSheet()->setCellValue('AC2','Jerarquia');//29
				
				
				$this->docexcel->getActiveSheet()->setCellValue('AD2','Nivel_Salarial_Categ');//30
				
				$this->docexcel->getActiveSheet()->setCellValue('AE2','Lugar Pago');//31
				$this->docexcel->getActiveSheet()->setCellValue('AF2','Subsidio_Frontera');//32
				
				$this->docexcel->getActiveSheet()->setCellValue('AG2','AsignacionxSitioTrabajo');//33
				$this->docexcel->getActiveSheet()->setCellValue('AH2','IT AsignacionxSitioTrabajo');//34
				$this->docexcel->getActiveSheet()->setCellValue('AI2','Asignacion Especial');//35
				$this->docexcel->getActiveSheet()->setCellValue('AJ2','IT Asignacion Especial');//36
				$this->docexcel->getActiveSheet()->setCellValue('AK2','Asignacion de Caja');	//37
				$this->docexcel->getActiveSheet()->setCellValue('AL2','IT Asignacion de Caja');//38
				$this->docexcel->getActiveSheet()->setCellValue('AM2','Total Asignaciones');//39
				$this->docexcel->getActiveSheet()->setCellValue('AN2','BonoAntiguedad');//40
				$this->docexcel->getActiveSheet()->setCellValue('AO2','Hras Extra');//41
				$this->docexcel->getActiveSheet()->setCellValue('AP2','Sobretiempos');//42
				$this->docexcel->getActiveSheet()->setCellValue('AQ2','Hras Nocturnas');//43	
				$this->docexcel->getActiveSheet()->setCellValue('AR2','Recargo Nocturno');//44
				$this->docexcel->getActiveSheet()->setCellValue('AS2','Basico');//45
				$this->docexcel->getActiveSheet()->setCellValue('AT2','AFP');//46
				
				$this->docexcel->getActiveSheet()->setCellValue('AU2','Estado AFP');//46
				
				$this->docexcel->getActiveSheet()->setCellValue('AV2','Nivel_Salarial_Cargo');//47							
				
				$this->docexcel->getActiveSheet()->setCellValue('AW2','Basico_Límite');//48
				$this->docexcel->getActiveSheet()->setCellValue('AX2','FechaIngresoNeto');//49
				$this->docexcel->getActiveSheet()->setCellValue('AY2','AntiguedadExterna');//50
				$this->docexcel->getActiveSheet()->setCellValue('AZ2','Periodo');//51
				$this->docexcel->getActiveSheet()->setCellValue('BA2','Sueldo_Mes'); //52
				$this->docexcel->getActiveSheet()->setCellValue('BB2','Cotizable');//53

				$this->docexcel->getActiveSheet()->setCellValue('BC2','LQ_Pagable');//54
				$this->docexcel->getActiveSheet()->setCellValue('BD2','Asig_Disp');//55
				$this->docexcel->getActiveSheet()->setCellValue('BE2','Prenatal');//56
				$this->docexcel->getActiveSheet()->setCellValue('BF2','Lactancia');//57
				$this->docexcel->getActiveSheet()->setCellValue('BG2','Natalidad');//58
				
				///////
				$this->docexcel->getActiveSheet()->setCellValue('BH2','C_Indiv');//59
				$this->docexcel->getActiveSheet()->setCellValue('BI2','Riesgo_Comun');//60
				$this->docexcel->getActiveSheet()->setCellValue('BJ2','C_Administ');//61
				$this->docexcel->getActiveSheet()->setCellValue('BK2','AporteSolidarioNacional');//62
				$this->docexcel->getActiveSheet()->setCellValue('BL2','AporteSolidarioEmpl');//63
				//////
				
				$this->docexcel->getActiveSheet()->setCellValue('BM2','TotalGanado');//59
				$this->docexcel->getActiveSheet()->setCellValue('BN2','TotalDescuentos');//60
				$this->docexcel->getActiveSheet()->setCellValue('BO2','TotalGeneral');//61
				$this->docexcel->getActiveSheet()->setCellValue('BP2','Telef_Celular');//62
				$this->docexcel->getActiveSheet()->setCellValue('BQ2','Banco');//63
				$this->docexcel->getActiveSheet()->setCellValue('BR2','Cuenta_Banco');//64

				$nombre_centro='';
				foreach ($datos as $value){
					//#66
					if($this->objParam->getParametro('tipo_reporte')!='curva_salarial'){
						if($nombre_centro!=$value['nombre_centro']){
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['nombre_centro']);
							$fila++;
						}
						$nombre_centro=$value['nombre_centro'];
						
					}
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['num_documento']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['tipo_documento']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['expedicion']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nro_afp']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['apellido_paterno']);
                    //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, date_format(date_create($value['fecha_ini']),'d/m/Y'));
                    //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, date_format(date_create($value['fecha_fin']),'d/m/Y'));
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila,$value['apellido_materno'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila,$value['primer_nombre'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila,$value['segundo_nombre'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila,date_format(date_create($value['fecha_nacimiento']),'d/m/Y'));
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila,$value['direccion'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila,$value['telefono1'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila,$value['grupo_sanguineo'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila,$value['genero'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila,$value['estado_civil'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila,$value['profesion'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila,$value['cargo'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila,date_format(date_create($value['fecha_ingreso']),'d/m/Y') );
					
					if(strlen($value['fecha_retiro'])>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila,date_format(date_create($value['fecha_retiro']),'d/m/Y') );
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila,$value['fecha_retiro'] );	
					}
					
					
										//
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila,$value['motivo_retiro'] );
					if(strlen($value['fecha_ingreso_ctto1'])>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,date_format(date_create($value['fecha_ingreso_ctto1']),'d/m/Y') );
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,$value['fecha_ingreso_ctto1']);
					}
					if(strlen($value['fecha_retiro_ctto1'])>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,date_format(date_create($value['fecha_retiro_ctto1']),'d/m/Y') );
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,$value['fecha_retiro_ctto1']);
					}
					
					if(strlen($value['fecha_ingreso_ctto2'])>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,date_format(date_create($value['fecha_ingreso_ctto2']),'d/m/Y') );
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,$value['fecha_ingreso_ctto2']);
					}

					if(strlen($value['fecha_retiro_ctto2'])>0){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,date_format(date_create($value['fecha_retiro_ctto2']),'d/m/Y') );
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila,$value['fecha_retiro_ctto2']);
					}
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila,$value['estado'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25, $fila,$value['tiempo_contrato'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26, $fila,$value['nombre_lugar'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27, $fila,$value['codigo_centro'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila,$value['numero_nivel'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(29, $fila,$value['nivel_salarial_cargo'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(30, $fila,$value['lugar_pago'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(31, $fila,$value['bonofrontera'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(32, $fila,$value['asigtra'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(33, $fila,$value['asigtra_it'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(34, $fila,$value['asigesp'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(35, $fila,$value['asigesp_it'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(36, $fila,$value['asigcaja'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(37, $fila,$value['asigcaja_it'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(38, $fila,$value['asignaciones'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(39, $fila,$value['bonant'] );//bono antiguedad
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(40, $fila,$value['horext'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(41, $fila,$value['extra'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(42, $fila,$value['hornoc'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(43, $fila,$value['nocturno'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(44, $fila,$value['sueldo_mes'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(45, $fila,$value['nombre_afp'] );
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(46, $fila,$value['estado_afp'] );//#81
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(47, $fila,$value['nivel_salarial_categoria'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(48, $fila,$value['basico_limite'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(49, $fila,date_format(date_create($value['fecha_quinquenio']),'d/m/Y') );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(50, $fila,$value['antiguedad_anterior'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(51, $fila,date_format(date_create($value['fecha_planilla']),'d/m/Y') );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(52, $fila,$value['suelmes'] ); //suelmes
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(53, $fila,$value['cotizable'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(54, $fila,$value['liquido'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(55, $fila,$value['disponibilidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(56, $fila,$value['prenatal'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(57, $fila,$value['lactancia'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(58, $fila,$value['natalidad'] );
					//#66
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(59, $fila,$value['afp_sso'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(60, $fila,$value['afp_rcom'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(61, $fila,$value['afp_cadm'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(62, $fila,$value['afp_apnal'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(63, $fila,$value['afp_apsol'] );
					
					//
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(64, $fila,$value['total_ganado'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(65, $fila,$value['total_descuentos'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(66, $fila,$value['total_gral'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(67, $fila,$value['celular1'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(68, $fila,$value['banco'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(69, $fila,$value['nro_cuenta'] );
										 
					$fila++;
				}

                //if($desc_func != $value['desc_func'] || $codigo_pres!=$value['codigo_pres']) {
                    
             /*   switch ($value['periodo']){

                    case 1:
						

                        if($value['codigo_columna'] == 'BONFRONTERA'){
                            $total_frontera += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REINBANT'){
                            $total_bono += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REISUELDOBA'){
                            $total_sueldo += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila, $value['valor']); break;
                        }
                    case 2:

                        if($value['codigo_columna'] == 'BONFRONTERA'){
                            $total_frontera += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REINBANT'){
                            $total_bono += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REISUELDOBA'){
                            $total_sueldo += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila, $value['valor']); break;
                        }

                    case 3:
                        if($value['codigo_columna'] == 'BONFRONTERA'){
                            $total_frontera += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REINBANT') {
                            $total_bono += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila, $value['valor']);break;
                        }else if($value['codigo_columna'] == 'REISUELDOBA'){
                            $total_sueldo += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23, $fila, $value['valor']); break;
                        }
                    case 4:
                        if($value['codigo_columna'] == 'BONFRONTERA'){
                            $total_frontera += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REINBANT') {
                            $total_bono += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila, $value['valor']);break;
                        }else if($value['codigo_columna'] == 'REISUELDOBA'){
                            $total_sueldo += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila, $value['valor']); break;
                        }
                    case 5:
                        if($value['codigo_columna'] == 'BONFRONTERA'){
                            $total_frontera += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REINBANT') {
                            $total_bono += $value['valor'];
                            //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['valor']);break;
                        }else if($value['codigo_columna'] == 'REISUELDOBA'){
                            $total_sueldo += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25, $fila, $value['valor']); break;
                        }
                    case 6:
                        if($value['codigo_columna'] == 'BONFRONTERA'){
                            $total_frontera += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REINBANT') {
                            $total_bono += $value['valor'];
                            //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REISUELDOBA'){
                            $total_sueldo += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26, $fila, $value['valor']); break;
                        }
                    case 7:
                        if($value['codigo_columna'] == 'BONFRONTERA'){
                            $total_frontera += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REINBANT') {
                            $total_bono += $value['valor'];
                            //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['valor']); break;
                        }else if($value['codigo_columna'] == 'REISUELDOBA'){
                            $total_sueldo += $value['valor'];
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nombre_cargo']);
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27, $fila, $value['valor']); break;
                        }
                    
                }/*


                //}
                $columna++;
                //$fila++;
                $this->numero++;
                $index++;
                $codigo_col = $value['codigo_columna'];

            //}
            /*else {
                if($desc_func != $value['desc_func'] || $codigo_pres!=$value['codigo_pres']){
                    if($desc_func != $value['desc_func']){
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                    }

                    $total_bono = 0;
                    $total_sueldo = 0;
                    $total_frontera = 0;
                    $fila++;
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['categoria_prog']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['presupuesto'].'['.$value['codigo_pres'].']');
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['ci']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['desc_func']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nombre_cargo']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, date_format(date_create($value['fecha_ini']),'d/m/Y'));
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, date_format(date_create($value['fecha_fin']),'d/m/Y'));


                    switch ($value['periodo']){

                        case 1:

                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT'){
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila, $value['valor']); break;
                            }
                        case 2:

                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT'){
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila, $value['valor']); break;
                            }

                        case 3:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila, $value['valor']);break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23, $fila, $value['valor']); break;
                            }
                        case 4:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila, $value['valor']);break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila, $value['valor']); break;
                            }
                        case 5:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['valor']);break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25, $fila, $value['valor']); break;
                            }
                        case 6:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26, $fila, $value['valor']); break;
                            }
                        case 7:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nombre_cargo']);
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27, $fila, $value['valor']); break;
                            }
                    }



                    $this->numero++;
                    $columna = 8;
                    $codigo_col = $value['codigo_columna'];
                }else{
                    switch ($value['periodo']){

                        case 1:

                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT'){
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila, $value['valor']); break;
                            }
                        case 2:

                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT'){
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila, $value['valor']); break;
                            }

                        case 3:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila, $value['valor']);break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23, $fila, $value['valor']); break;
                            }
                        case 4:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila, $value['valor']);break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24, $fila, $value['valor']); break;
                            }
                        case 5:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['valor']);break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25, $fila, $value['valor']); break;
                            }
                        case 6:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26, $fila, $value['valor']); break;
                            }
                        case 7:
                            if($value['codigo_columna'] == 'BONFRONTERA'){
                                $total_frontera += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REINBANT') {
                                $total_bono += $value['valor'];
                                //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['valor']); break;
                            }else if($value['codigo_columna'] == 'REISUELDOBA'){
                                $total_sueldo += $value['valor'];
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nombre_cargo']);
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27, $fila, $value['valor']); break;
                            }
                        
                    }
                    if($codigo_col!=$value['codigo_columna']){
                        if($codigo_col == 'BONFRONTERA'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, $total_frontera);
                        }else if($codigo_col == 'REINBANT'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila, $total_bono);
                        }else if($codigo_col == 'REISUELDOBA'){
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                        }
                    }
                    $codigo_col = $value['codigo_columna'];
                    $columna++;
                }

                //$fila++;
                //$this->numero++;
            }
*/
            $tipo_contrato = $value['tipo_contrato'];
            $desc_func = $value['desc_func'];
            $codigo_pres = $value['codigo_pres'];
        //}
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
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