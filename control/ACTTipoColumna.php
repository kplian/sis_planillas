<?php
/**
*@package pXP
*@file gen-ACTTipoColumna.php
*@author  (admin)
*@date 17-01-2014 19:43:15
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoColumna extends ACTbase{    
			
	function listarTipoColumna(){
		$this->objParam->defecto('ordenacion','id_tipo_columna');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_tipo_planilla') != '') {
			$this->objParam->addFiltro("tipcol.id_tipo_planilla = ". $this->objParam->getParametro('id_tipo_planilla'));
		}
		
		if ($this->objParam->getParametro('compromete') == 'si') {
			$this->objParam->addFiltro("tipcol.compromete in (''si'',''si_contable'')");
		}
		
		if ($this->objParam->getParametro('tipo_dato') != '') {
			if ($this->objParam->getParametro('tipo_dato') == 'variable' && $this->objParam->getParametro('columnas') != '') {
				$this->objParam->addFiltro("((tipcol.tipo_dato = ''". $this->objParam->getParametro('tipo_dato') . "'') or 
				tipcol.codigo in (" . $this->objParam->getParametro('columnas') . "))");
			} else {
				$this->objParam->addFiltro("tipcol.tipo_dato = ''". $this->objParam->getParametro('tipo_dato') . "''");
			}
			
		}
		
		if ($this->objParam->getParametro('tipo_descuento_bono') == 'si') {
			$this->objParam->addFiltro("tipcol.tipo_descuento_bono is not null and tipo_descuento_bono != ''''");
		}
		
		if ($this->objParam->getParametro('presupuesto_pago') == 'si') {
			$this->objParam->addFiltro("(tipcol.compromete=''si'' or tipcol.compromete=''si_pago'' or tipcol.compromete=''si_contable'')");
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoColumna','listarTipoColumna');
		} else{
			$this->objFunc=$this->create('MODTipoColumna');
			
			$this->res=$this->objFunc->listarTipoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoColumna(){
		$this->objFunc=$this->create('MODTipoColumna');	
		if($this->objParam->insertar('id_tipo_columna')){
			$this->res=$this->objFunc->insertarTipoColumna($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoColumna($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
						
	function eliminarTipoColumna(){
			$this->objFunc=$this->create('MODTipoColumna');	
		$this->res=$this->objFunc->eliminarTipoColumna($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function reporte(){
		//============================================================+
		// File name   : example_052.php
		// Begin       : 2009-05-07
		// Last Update : 2013-05-14
		//
		// Description : Example 052 for TCPDF class
		//               Certification Signature (experimental)
		//
		// Author: Nicola Asuni
		//
		// (c) Copyright:
		//               Nicola Asuni
		//               Tecnick.com LTD
		//               www.tecnick.com
		//               info@tecnick.com
		//============================================================+
		
		/**
		 * Creates an example PDF TEST document using TCPDF
		 * @package com.tecnick.tcpdf
		 * @abstract TCPDF - Example: Certification Signature (experimental)
		 * @author Nicola Asuni
		 * @since 2009-05-07
		 */
		
		// Include the main TCPDF library (search for installation path).
		
		require_once(dirname(__FILE__).'/../../lib/tcpdf/tcpdf.php');
		
		// create new PDF document
		$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
		
		// set document information
		$pdf->SetCreator(PDF_CREATOR);
		$pdf->SetAuthor('Nicola Asuni');
		$pdf->SetTitle('TCPDF Example 052');
		$pdf->SetSubject('TCPDF Tutorial');
		$pdf->SetKeywords('TCPDF, PDF, example, test, guide');
		
		// set default header data
		$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE.' 052', PDF_HEADER_STRING);
		
		// set header and footer fonts
		$pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
		$pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));
		
		// set default monospaced font
		$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		
		// set margins
		$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
		$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
		$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);
		
		// set auto page breaks
		$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
		
		// set image scale factor
		$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
		
		// set some language-dependent strings (optional)
		if (@file_exists(dirname(__FILE__).'/lang/eng.php')) {
		    require_once(dirname(__FILE__).'/lang/eng.php');
		    $pdf->setLanguageArray($l);
		}
		
		// ---------------------------------------------------------
		
		/*
		NOTES:
		 - To create self-signed signature: openssl req -x509 -nodes -days 365000 -newkey rsa:1024 -keyout tcpdf.crt -out tcpdf.crt
		 - To export crt to p12: openssl pkcs12 -export -in tcpdf.crt -out tcpdf.p12
		 - To convert pfx certificate to pem: openssl pkcs12 -in tcpdf.pfx -out tcpdf.crt -nodes
		*/
		
		// set certificate file
		//$certificate = 'file://var/www/html/kerp_capacitacion/sis_planillas/control/cert.pem';
		//$certificate ='file://'. dirname(FILE).'/cert.pem';
		$certificate = 'file://tcpdf.crt';
		$key = 'file://tcpdf.crt';
		// set additional information
		$info = array(
		    'Name' => 'TCPDF',
		    'Location' => 'Office',
		    'Reason' => 'Testing TCPDF',
		    'ContactInfo' => 'http://www.tcpdf.org',
		    );
		
		// set document signature
		$pdf->setSignature($certificate, $key, 'jaime', '', 2, $info);
		
		// set font
		$pdf->SetFont('helvetica', '', 12);
		
		// add a page
		$pdf->AddPage();
		
		// print a line of text
		$text = 'This is a <b color="#FF0000">digitally signed document</b> using the default (example) <b>tcpdf.crt</b> certificate.<br />To validate this signature you have to load the <b color="#006600">tcpdf.fdf</b> on the Arobat Reader to add the certificate to <i>List of Trusted Identities</i>.<br /><br />For more information check the source code of this example and the source code documentation for the <i>setSignature()</i> method.<br /><br /><a href="http://www.tcpdf.org">www.tcpdf.org</a>';
		$pdf->writeHTML($text, true, 0, true, 0);
		
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		// *** set signature appearance ***
		
		// create content for signature (image and/or text)
		$pdf->Image('../../lib/tcpdf/images/tcpdf_signature.png', 180, 60, 15, 15, 'PNG');
		
		// define active area for signature appearance
		$pdf->setSignatureAppearance(180, 60, 15, 15);
		
		// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		// *** set an empty signature appearance ***
		$pdf->addEmptySignatureAppearance(180, 80, 15, 15);
		
		// ---------------------------------------------------------
		
		//Close and output PDF document
		$pdf->Output('../../reportes_generados/example_052.pdf', 'D');
		
		//============================================================+
		// END OF FILE
		//============================================================+
	}
			
}

?>