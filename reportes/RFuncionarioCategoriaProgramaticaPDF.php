<?php
//(Franklin Espinoza A.-02/08/2017)Certificacion Presupuestario
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDF.php';
require_once(dirname(__FILE__) . '/../../lib/tcpdf/tcpdf_barcodes_2d.php');
class RFuncionarioCategoriaProgramaticaPDF extends  ReportePDF{
    var $datos ;
    var $ancho_hoja;

    function Header() {
        $this->Ln(3);


        //cabecera del reporte
        $this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 16,5,40,20);
        $this->ln(5);
        $this->SetFont('','B',12);
        $this->Cell(0,5,"CERTIFICACIÓN PRESUPUESTARIA",0,1,'C');

        $this->Ln(2);

    }

    function setDatos($datos) {

        $this->datos = $datos;
        //var_dump( $this->datos);exit;
    }

    function  generarReporte()
    {

        $this->AddPage();
        $this->SetMargins(15, 40, 15);
        $this->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        $firmas = explode(';',$this->datos[0]['firmas']);
        $firma_fecha = '';
        $firma_elaborado = '';
        $firma_aprobado = '';

        if(count($firmas)>1) {
            foreach ($firmas as $fir){
                if(strpos($fir, 'comprobante_generado')!==false){
                    $firma_fecha = explode(',',$fir);
                }
            }
        }

        foreach ($firmas as $fir){
            if(strpos($fir, 'vbpresupuestos')!==false){
                $firma_elaborado = explode(',',$fir);
            }
        }

        foreach ($firmas as $fir){
            if(strpos($fir, 'suppresu')!==false){
                $firma_aprobado = explode(',',$fir);
            }
        }

        //$fecha = date_format(date_create($firma_fecha[1]), 'd/m/Y');
        $fecha = date_format(date_create($this->datos[0]['fecha_soli']), 'd/m/Y');


        $tbl = '<table border="0" style="font-size: 7pt;"> 
                <tr><td width="28%"><b>ENTIDAD: </b></td><td width="23%"> '.$this->datos[0]['nombre_entidad'].'</td><td width="23%"><b>NRO. PLANILLA: </b></td><td width="28%">'.$this->datos[0]['num_tramite'].'</td></tr>
                <tr><td><b>DIRECCIÓN ADMINISTRATIVA: </b></td><td> '.$this->datos[0]['direccion_admin'].'</td><td><b>FECHA: </b></td><td>'.$fecha.'</td></tr>
                <tr><td><b>UNIDAD EJECUTORA: </b></td><td> '.$this->datos[0]['unidad_ejecutora'].'</td><td><b>UNIDAD SOLICITANTE: </b></td><td>'.$this->datos[0]['unidad_solicitante'].' </td></tr>
                <tr><td><b>CON IMPUTACIÓN PRESUPUESTARIA: </b><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Compromiso: <img width="13" height="13" src="'.dirname(__FILE__).'/../../sis_presupuestos/reportes/media/tiqueado.png"></td><td></td><td><b>FUNCIONARIO SOLICITANTE: </b></td><td>'.$this->datos[0]['funcionario_solicitante'].'</td></tr>
                <tr><td colspan="4"><b>CATEGORIA: </b> '.$this->datos[0]['codigo_proceso'].'</td></tr>
                ';

        $this->Ln(5);
        $this->writeHTML ($tbl);


        $this->Ln(5);


        //variables para la tabla
        $codigo_cg = '';
        $id_cp = 0;
        $cod_partida = '';
        $tbl = '<table border="1" style="font-size: 6pt;">';
        $cont_parcial = 0;
        $cont_total = 0;
        $contador = 0;
        $total_general = 0;
        $cod_moneda = $this->datos[0]['codigo_moneda'];
        $codigo = '';

        foreach( $this->datos as $record){

            if($record["codigo_cg"] != $codigo_cg){

                if($record["id_cp"] != $id_cp || $record["codigo_partida"] != $cod_partida){

                    if($id_cp != '' || $cod_partida!=''){
                        $tbl.='<tr>
                               <td colspan="9" align="center" colspan="9" ><b> TOTAL PARCIAL</b>['.$codigo.']</td>
                               <td align="right" ><b>'.number_format($cont_parcial,2, ',', '.').'</b></td>
                           </tr>';
                        $cont_total+=$cont_parcial;
                        $cont_parcial = 0;
                        $id_cp = $record["id_cp"];
                        $cod_partida = $record["codigo_partida"];
                    }


                }
                if($codigo_cg!='') {

                    $tbl .= '<tr>
                               <td colspan="9" align="center" ><b> SUB - TOTAL CLASE DE GASTOS (' . $record["codigo_cg"] . ') ' . $record["nombre_cg"] . '</b></td>
                               <td align="right" ><b>' . number_format($cont_total, 2, ',', '.') . '</b></td>
                           </tr>';
                    $total_general+=$cont_total;

                }
                $tbl.='<tr><td colspan="10" align="center"><b>CLASE DE GASTO: ('.$record["codigo_cg"].') '.$record["nombre_cg"].'</b></td></tr>
                         <tr>
                            <td width="7%" align="center"><b>CENTRO DE COSTO</b></td>
                            <td width="5%" align="center"><br><b>PROG.</b></td>
                            <td width="5%" align="center"><br><b>PROY.</b></td>
                            <td width="5%" align="center"><br><b>ACT.</b></td>
                            <td width="5%" align="center"><br><b>FTE.</b></td>
                            <td width="5%" align="center" ><b>ORG. FINAN</b></td>
                            <td width="10%" align="center" valign="center"><br><b>PARTIDA</b></td>
                            <td width="36%" align="center"><br><b>DESCRIPCIÓN</b></td>
                            <td width="7%" align="center"><b>ENT.</b> <br><b>TRANSF</b></td>
                            <td width="15%" align="right"><br><b>IMPORTE '.($cod_moneda=='Bs'?'Bs.':'$us.').'</b></td>
                        </tr>';


                $codigo_cg = $record["codigo_cg"];
                //$cont_parcial = 0;
                $cont_total = 0;
            }

            if($record["id_cp"] != $id_cp || $record["codigo_partida"] != $cod_partida){

                if($id_cp != '' || $cod_partida!=''){
                    $tbl.='<tr>
                               <td colspan="9" align="center" colspan="9" ><b> TOTAL PARCIAL</b>['.$codigo.']</td>
                               <td align="right" ><b>'.number_format($cont_parcial,2, ',', '.').'</b></td>
                           </tr>';
                    $cont_total+=$cont_parcial;
                    $cont_parcial = 0;
                }

                //$cont_parcial += $record["precio_total"];
                $id_cp = $record["id_cp"];
                $cod_partida = $record["codigo_partida"];
            }

            $tbl.='<tr >
                            <td width="7%" align="center">'.$record["centro_costo"].'</td>
                            <td width="5%" align="center">'.$record["codigo_programa"].'</td>
                            <td width="5%" align="center">'.$record["codigo_proyecto"].'</td>
                            <td width="5%" align="center">'.$record["codigo_actividad"].'</td>
                            <td width="5%" align="center">'.$record["codigo_fuente_fin"].'</td>
                            <td width="5%" align="center" >'.$record["codigo_origen_fin"].'</td>
                            <td width="10%" align="center" valign="center">'.$record["codigo_partida"].'</td>
                            <td width="36%" align="left">'.$record["nombre_partida"].'</td>
                            <td width="7%" align="center">'.$record["codigo_transf"].'</td>
                            <td width="15%" align="right">'.number_format($record["precio_total"],2, ',', '.').'</td>
                        </tr>';

            $cont_parcial += $record["precio_total"];

            $codigo = $codigo = $record["codigo_programa"].'-'.$record["codigo_proyecto"].'-'.$record["codigo_actividad"].'-'.$record["codigo_fuente_fin"].'-'.$record["codigo_origen_fin"].', '.$record["codigo_partida"];

        }


        $cont_total += $cont_parcial;
        $codigo = $record["codigo_programa"].'-'.$record["codigo_proyecto"].'-'.$record["codigo_actividad"].'-'.$record["codigo_fuente_fin"].'-'.$record["codigo_origen_fin"].', '.$record["codigo_partida"];

        if($id_cp != '' || $cod_partida != ''){
            $tbl.='<tr>
                               <td colspan="9" align="center" colspan="9" ><b> TOTAL PARCIAL</b>['.$codigo.']</td>
                               <td align="right" ><b>'.number_format($cont_parcial,2, ',', '.').'</b></td>
                           </tr>';
            $total_general+=$cont_total;
        }

        $tbl .= '<tr>
                               <td colspan="9" align="center" ><b> SUB - TOTAL CLASE DE GASTOS (' . $record["codigo_cg"] . ') ' . $record["nombre_cg"] . '</b></td>
                               <td align="right" ><b>' . number_format($cont_total, 2, ',', '.') . '</b></td>
                           </tr>';
        $centimos = explode('.', $total_general);

        $tbl.='<tr>
                           <td colspan="9" align="center" ><b> TOTAL GENERAL AUTORIZADO</b></td>
                           <td align="right" ><b>'.number_format($total_general,2, ',', '.').'</b></td>
                       </tr>';
        $tbl.='<tr>
                   <td colspan="10" align="left">&nbsp;&nbsp;&nbsp;&nbsp;Son: <b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'.$this->convertir((integer)$total_general).' '.($centimos[1]==''?'00':$centimos[1]).'/100 ........................................................'.($cod_moneda=='Bs'?'Bolivianos.':'Dolares.').'</b></td>
                        
               </tr>';

        $tbl.='</table>';
        $this->writeHTML ($tbl);

        $tbl = '';
        $this->Ln(1);
        $tbl.='<table border="1"><tr>
                   <td colspan="10" align="left" style="font-size: 8pt;">&nbsp;<b>JUSTIFICACIÓN:</b><br>&nbsp;'.$this->datos[0]['justificacion'].'</td>
                        
               </tr></table>';
        $this->writeHTML ($tbl);
        //controlamos el alto para las firmas
        if($this->GetY() == 220)
            $this->SetY(250);

        //var_dump($this->getPageDimensions());exit;
        if($firma_fecha[0]=='comprobante_generado') {
            $tbl = '<table>
                    <tr>
                    <td style="width: 15%"></td>
                    <td style="width: 70%">
                    <table cellspacing="0" cellpadding="1" border="1">
                        <tr>
                            <td style="font-family: Calibri; font-size: 9px;"><b> Elaborado por:</b> <br> ' . $firma_elaborado[2] . '</td>
                            <td style="font-family: Calibri; font-size: 9px;"><b> Aprobado por:</b><br> ' . $firma_aprobado[2] . '</td>
                        </tr>
                        <tr>
                            <td align="center" > 
                                <br><br>
                                <img  style="width: 110px; height: 110px;" src="' . $this->generarImagen($firma_elaborado[2], $firma_elaborado[3],$firma_elaborado[4]) . '" alt="Logo">
                               
                            </td>
                            <td align="center" >
                                <br><br>
                                <img  style="width: 110px; height: 110px;" src="' . $this->generarImagen($firma_aprobado[2], $firma_aprobado[3],$firma_aprobado[4]) . '" alt="Logo">
                                  
                            </td>
                         </tr>
                    </table>
                    </td>
                    <td style="width:15%;"></td>
                    </tr>
                    </table>
                    
                ';
            $this->Ln(5);
            $this->writeHTML($tbl, true, false, false, false, '');
        }else{
            $tbl = '<table>
                    <tr>
                    <td style="width: 15%"></td>
                    <td style="width: 70%">
                    <table cellspacing="0" cellpadding="1" border="1" style="font-family: Calibri; font-size: 9px;">
                        <tr>
                            <td style="font-family: Calibri; font-size: 9px;"><b> Elaborado por:</b> <br> </td>
                            <td style="font-family: Calibri; font-size: 9px;"><b> Aprobado por:</b><br> </td>
                        </tr>
                        <tr>
                            <td align="center" > 
                                <br><br>
                                <img  style="width: 95px; height: 95px;" src="" alt="Logo"><br>
                                
                            </td>
                            <td align="center" >
                                <br><br>
                                <img  style="width: 95px; height: 95px;" src="" alt="Logo"><br>
                                
                            </td>
                         </tr>
                    </table>
                    </td>
                    <td style="width:15%;"></td>
                    </tr>
                    </table>
                    
                ';
            $this->Ln(5);
            $this->writeHTML($tbl, true, false, false, false, '');
        }

        if($this->datos[0]['codigo_poa']!=''){
            $tex ='Mediante la presente, en referencia a solicitud <b>'.$this->datos[0]['num_tramite'].'</b> de fecha <b>'.$this->datos[0]['fecha_soli'].'</b> 
            acerca de: <b>'.$this->datos[0]['justificacion'].'</b>, certificar que el mismo se encuentra contemplado en el Plan Operativo gestion <b>'.$this->datos[0]['gestion'].'</b>, 
            en la operacion <b>'.$this->datos[0]['codigo_descripcion'].'.</b>';

            $this->SetFont('','B',12);
            $this->Cell(0,5,"CERTIFICACIÓN POA",0,1,'C');
            $this->ln(1);
            $this->SetFont('','',12);

            $tbl = '<table border="1">
                    <tr>
                        <td>
                            <table border="0">
                                <tr>
                                    <td style="width: 0.5%"></td>
                                    <td style="width: 97.5%; text-align: justify; font-family: Calibri; font-size: 10px;"><br><br>'.$tex.'<br></td>
                                    <td style="width: 2%"> </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                    
                ';
            $this->writeHTML($tbl, true, false, false, false, '');
            if($firma_elaborado[0]!='' || $firma_aprobado[0]!='') {
                $firmas = explode(';',$this->datos[0]['firmas']);

                $firma_poa = '';
                foreach ($firmas as $fir){
                    if(strpos($fir, 'vbpoa')!==false){
                        $firma_poa = explode(',',$fir);
                    }
                }

                $tbl = '<table>
                        <tr>
                        <td style="width: 35%"></td>
                        <td style="width: 30%">
                        <table cellspacing="0" cellpadding="1" border="1">
                            <tr>
                                <td style="font-family: Calibri; font-size: 9px;"><b> VoBo POA:</b> <br> ' . $firma_poa[2] . '</td>
                            </tr>
                            <tr>
                                <td align="center" cellspacing="0" cellpadding="1"> 
                                    <br>
                                    <img  style="width: 110px; height: 110px;" src="' . $this->generarImagen($firma_poa[2], $firma_poa[3], $firma_poa[4]) . '" alt="Logo">
                                   
                                </td>
                             </tr>
                        </table>
                        </td>
                        <td style="width:35%;"></td>
                        </tr>
                   </table>
                        
                    ';
                $this->writeHTML($tbl, true, false, false, false, '');
            }
        }

    }

    function basico($numero) {
        $valor = array ('Uno','Dos','Tres','Cuatro','Cinco','Seis','Siete','Ocho',
            'Nueve','Diez','Once','Doce','Trece','Catorce','Quince','Dieciséis','Diecisiete',
            'Dieciocho','Diecinueve','Veinte','Veintiuno','Veintidós','Veintitrés','Veinticuatro','Veinticinco',
            'Veintiséis','Veintisiete','Veintiocho','Veintinueve');
        return $valor[$numero - 1];
    }

    function decenas($n) {
        $decenas = array (30=>'Treinta',40=>'Cuarenta',50=>'Cincuenta',60=>'Sesenta',
            70=>'Setenta',80=>'Ochenta',90=>'Noventa');
        if( $n <= 29) return $this->basico($n);
        $x = $n % 10;
        if ( $x == 0 ) {
            return $decenas[$n];
        } else
            return $decenas[$n - $x].' y '. $this->basico($x);
    }

    function centenas($n) {
        $cientos = array (100 =>'Cien',200 =>'Doscientos',300=>'Trecientos',
            400=>'Cuatrocientos', 500=>'Quinientos',600=>'Seiscientos',
            700=>'Setecientos',800=>'Ochocientos', 900 =>'Novecientos');
        if( $n >= 100) {
            if ( $n % 100 == 0 ) {
                return $cientos[$n];
            } else {
                $u = (int) substr($n,0,1);
                $d = (int) substr($n,1,2);
                return
                    (($u == 1)?'Ciento':$cientos[$u*100]).' '.$this->decenas($d);
            }
        } else
            return $this->decenas($n);
    }

    function miles($n) {
        if($n > 999) {
            if( $n == 1000) {return 'Mil';}
            else {
                $l = strlen($n);
                $c = (int)substr($n,0,$l-3);
                $x = (int)substr($n,-3);
                if($c == 1) {$cadena = 'Mil '.$this->centenas($x);}
                else if($x != 0) {$cadena = $this->centenas($c).' Mil '.$this->centenas($x);}
                else $cadena = $this->centenas($c). ' Mil';
                return $cadena;
            }
        } else return $this->centenas($n);
    }

    function millones($n) {
        if($n == 1000000) {return 'Un Millón';}
        else {
            $l = strlen($n);
            $c = (int)substr($n,0,$l-6);
            $x = (int)substr($n,-6);
            if($c == 1) {
                $cadena = ' Millón ';
            } else {
                $cadena = ' Millones ';
            }
            return $this->miles($c).$cadena.(($x > 0)?$this->miles($x):'');
        }
    }
    function convertir($n) {
        switch (true) {
            case ( $n >= 1 && $n <= 29) : return $this->basico($n); break;
            case ( $n >= 30 && $n < 100) : return $this->decenas($n); break;
            case ( $n >= 100 && $n < 1000) : return $this->centenas($n); break;
            case ($n >= 1000 && $n <= 999999): return $this->miles($n); break;
            case ($n >= 1000000): return $this->millones($n);
        }
    }

    function generarImagen($nom, $car, $ofi){
        $cadena_qr = 'Nombre: '.$nom. "\n" . 'Cargo: '.$car."\n".'Oficina: '.$ofi ;
        $barcodeobj = new TCPDF2DBarcode($cadena_qr, 'QRCODE,M');
        $png = $barcodeobj->getBarcodePngData($w = 8, $h = 8, $color = array(0, 0, 0));
        $im = imagecreatefromstring($png);
        if ($im !== false) {
            header('Content-Type: image/png');
            imagepng($im, dirname(__FILE__) . "/../../reportes_generados/" . $nom . ".png");
            imagedestroy($im);

        } else {
            echo 'A ocurrido un Error.';
        }
        $url_archivo = dirname(__FILE__) . "/../../reportes_generados/" . $nom . ".png";

        return $url_archivo;
    }

}
?>
