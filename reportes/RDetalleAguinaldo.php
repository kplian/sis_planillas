<?php
/*
#ISSUE                FECHA                AUTOR               DESCRIPCION
 #87	ETR				10.01.2020			MZM					Habilitacion de opcion detalle de aguinaldo 
*/
class RDetalleAguinaldo
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
            
           // if($tipo_contrato != $value['estado']){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28, $fila, $total_sueldo);
                $this->addHoja($value['tipo_contrato'],$index);
                $this->docexcel->getActiveSheet()->getTabColor()->setRGB($color_pestana[$index]);
               
				$dr=substr($this->objParam->getParametro('fecha_backup'),8,2);
				$mr=substr($this->objParam->getParametro('fecha_backup'),5,2);
				$ar=substr($this->objParam->getParametro('fecha_backup'),0,4).''.substr($this->objParam->getParametro('fecha_backup'),10);
				
				$this->docexcel->getActiveSheet()->mergeCells("A1:AH1");
				$this->docexcel->getActiveSheet()->getStyle('A1:AH1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
				
				
				if($this->objParam->getParametro('fecha_backup')!=''){
					$this->docexcel->getActiveSheet()->setCellValue('A1', 'DETALLE DE AGUINALDO ' .$datos[0]['gestion'].' [Backup: '.$dr.'/'.$mr.'/'.$ar.']');
				}else{
					$this->docexcel->getActiveSheet()->setCellValue('A1', 'DETALLE DE AGUINALDO ' .$datos[0]['gestion']);
				}
				
                $this->docexcel->getActiveSheet()->getStyle('A2:AH2')->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle('A2:AH2')->applyFromArray($styleTitulos3);
                $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,3);
                $fila=3;
                $this->numero=1;
                $columna = 8;

                $total_bono = 0;
                $total_sueldo = 0;
                $total_frontera = 0;
                $this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('nombre_tipo_contrato'));
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
                $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);//categoria
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
                $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(30);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(30);//mes

                $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(20);//mes
                $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(40);//mes
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
				
				
                $this->docexcel->getActiveSheet()->setCellValue('A2','Nº');//1
                $this->docexcel->getActiveSheet()->setCellValue('B2','Tipo Doc Identificacion');//2
                $this->docexcel->getActiveSheet()->setCellValue('C2','Nº Doc Identidad');//3
                $this->docexcel->getActiveSheet()->setCellValue('D2','Lugar de expedición');//4
                $this->docexcel->getActiveSheet()->setCellValue('E2','Fecha de nacimiento');//5
                $this->docexcel->getActiveSheet()->setCellValue('F2','Apellido Paterno');//6
                $this->docexcel->getActiveSheet()->setCellValue('G2','Apellido Materno');//7
                $this->docexcel->getActiveSheet()->setCellValue('H2','Nombres');//8
                $this->docexcel->getActiveSheet()->setCellValue('I2','País de nacionalidad');//9
                $this->docexcel->getActiveSheet()->setCellValue('J2','Sexo');//10
                $this->docexcel->getActiveSheet()->setCellValue('K2','Jubilado');//11
                $this->docexcel->getActiveSheet()->setCellValue('L2','¿Aporta a la AFP?');//12
                $this->docexcel->getActiveSheet()->setCellValue('M2','¿Persona con discapacidad?');//13
                $this->docexcel->getActiveSheet()->setCellValue('N2','Tutor de persona con discapacidad');//14
                $this->docexcel->getActiveSheet()->setCellValue('O2','Fecha de ingreso');//15
                $this->docexcel->getActiveSheet()->setCellValue('P2','Fecha de retiro');//16
                $this->docexcel->getActiveSheet()->setCellValue('Q2','Motivo retiro');//17
                $this->docexcel->getActiveSheet()->setCellValue('R2','Caja de salud');//18
                $this->docexcel->getActiveSheet()->setCellValue('S2','AFP a la que aporta');//19
                $this->docexcel->getActiveSheet()->setCellValue('T2','NUA/CUA');//20
                $this->docexcel->getActiveSheet()->setCellValue('U2','Sucursal o ubicación adicional');//21
                $this->docexcel->getActiveSheet()->setCellValue('V2','Clasificación laboral');//22
                $this->docexcel->getActiveSheet()->setCellValue('W2','Cargo');//23
                $this->docexcel->getActiveSheet()->setCellValue('X2','Modalidad de contrato');//24
                $this->docexcel->getActiveSheet()->setCellValue('Y2','Promedio haber básico');//25
                $this->docexcel->getActiveSheet()->setCellValue('Z2','Promedio bono de antigüedad');//26
                $this->docexcel->getActiveSheet()->setCellValue('AA2','Promedio bono producción');//27
                $this->docexcel->getActiveSheet()->setCellValue('AB2','Promedio subsidio frontera');//28
                $this->docexcel->getActiveSheet()->setCellValue('AC2','Promedio trabajo extraordinario y nocturno');//29
				
				
				$this->docexcel->getActiveSheet()->setCellValue('AD2','Promedio pago dominical trabajado');//30
				
				$this->docexcel->getActiveSheet()->setCellValue('AE2','Promedio otros bonos');//31
				$this->docexcel->getActiveSheet()->setCellValue('AF2','Promedio total ganado');//32
				
				$this->docexcel->getActiveSheet()->setCellValue('AG2','Meses trabajados');//33
				$this->docexcel->getActiveSheet()->setCellValue('AH2','Total ganado después de duodécimas');//34

				$nombre_centro='';
				$cont=1;
				foreach ($datos as $value){
					//date_format(date_create($value['fecha_nacimiento']),'d/m/Y')
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $cont);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['tipo_documento']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['num_documento']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['expedicion']);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, date_format(date_create($value['fecha_nacimiento']),'d/m/Y'));
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['paterno']);
                 	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['materno'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['nombre'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['nacionalidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['genero']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila, $value['jubilado'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila, $value['aporta_afp'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila, $value['persona_discapacidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila, $value['tutor_discapacidad'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila, date_format(date_create($value['fecha_ingreso']),'d/m/Y') );
					
					if($value['fecha_retiro']!=''){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila, date_format(date_create($value['fecha_retiro']),'d/m/Y'));
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila, $value['motivo_retiro'] );
					}else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila, '');
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila, '');
					}
			
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17,$fila, $value['caja_salud'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18,$fila, $value['nombre_afp'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19,$fila, $value['nro_afp'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20,$fila, $value['sucursal'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21,$fila, $value['clasificacion_laboral'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22,$fila, $value['cargo'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(23,$fila, $value['modalidad_ctto'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(24,$fila, $value['haber_basico'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(25,$fila, $value['bono_ant'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(26,$fila, $value['bono_prod'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(27,$fila, $value['bono_frontera'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(28,$fila, $value['extra_noct'] );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(29,$fila, 0 );
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(30,$fila, $value['otros'] );
					$tot=($value['otros'] + $value['haber_basico']+$value['bono_ant']+$value['extra_noct']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(31,$fila, $tot);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(32,$fila, $value['meses'] );
					$tot_duo=round(($tot*$value['meses']/360),2);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(33,$fila, $tot_duo);
										 
					$fila++;
					$cont++;
				}

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