<?php
/**
*@package pXP
*@file gen-ACTObligacion.php
*@author  (jrivera)
*@date 14-07-2014 20:30:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 * 
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#38 ETR             12/09/2019          RAC                 metodo para verificar si existen cbtes de pago 
#46 ETR				23.09.2019			MZM					Listado de informacion para abono en cuentas
 * 															omision de extension txt
#56 ETR				30.09.2019			MZM					Listado de resumen de saldos
#56 ETR				10.10.2019			MZM					Inclusion de filtro en cabecera de reporte
#117ETR				22.04.2020			MZM					Ajuste por actualizacion de php7  
*/
require_once(dirname(__FILE__).'/../reportes/RRelacionSaldos.php'); //#56
require_once(dirname(__FILE__).'/../reportes/RAbonoCuentaXls.php'); //#142
class ACTObligacion extends ACTbase{    
			
	function listarObligacion(){
		$this->objParam->defecto('ordenacion','id_obligacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_planilla') != '') {
			$this->objParam->addFiltro("obli.id_planilla = ". $this->objParam->getParametro('id_planilla'));
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODObligacion','listarObligacion');
		} else{
			$this->objFunc=$this->create('MODObligacion');
			
			$this->res=$this->objFunc->listarObligacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarObligacion(){
		$this->objFunc=$this->create('MODObligacion');	
		if($this->objParam->insertar('id_obligacion')){
			$this->res=$this->objFunc->insertarObligacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarObligacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarObligacion(){
			$this->objFunc=$this->create('MODObligacion');	
		$this->res=$this->objFunc->eliminarObligacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//#38 verifica si existe algun cbte de pago para la planilla
	function existenCbteDePago(){
		$this->objFunc=$this->create('MODObligacion');	
		$this->res=$this->objFunc->existenCbteDePago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	//#46 listado para abono en cuentas
	function listarAbonoCuenta(){
		$this->objParam->defecto('ordenacion','id_obligacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if ($this->objParam->getParametro('id_obligacion') != '') {
			$this->objParam->addFiltro("detran.id_obligacion = ". $this->objParam->getParametro('id_obligacion'));
		}
		
		$this->objFunc=$this->create('MODObligacion');
			
		$this->res=$this->objFunc->listarAbonoCuenta($this->objParam);
		$datos = $this->res->getDatos(); 
		//$this->res->imprimirRespuesta($this->res->generarJson());
		
		
		$periodo=$datos[0]['periodo'];
		
		$id_obligacion=$this->objParam->getParametro('id_obligacion');
		
		$nombre_archivo = 'B03'.$periodo.".CTD";
		
		if($this->objParam->getParametro('tipo_contrato')!= null && $this->objParam->getParametro('tipo_contrato')!= 'undefined' ){//#117
			if($this->objParam->getParametro('tipo_contrato')=='Planta' ){
				$nombre_archivo = 'B03'.$periodo."1.CTD.PRN";
			}else{
				$nombre_archivo = 'B03'.$periodo."2.CTD.PRN";
			}
		}
		
		
		$MiDocumento = fopen("../../../reportes_generados/".$nombre_archivo, "w+");//#46
		
		
		$Escribo=$datos[0]['total'];
		fwrite($MiDocumento, $Escribo);
		fwrite($MiDocumento, chr(13).chr(10));
		foreach ($datos as $dato) {
			
			$Escribo = "".$dato['detalle'] ;
				
			
			fwrite($MiDocumento, $Escribo);
			fwrite($MiDocumento, chr(13).chr(10)); //genera el salto de linea
			

		}
		fclose($MiDocumento);
		
		$this->res->setDatos($nombre_archivo);
		$this->res->imprimirRespuesta($this->res->generarJson());
		
		
	}


function reporteBancos()	{ //#56

        if ($this->objParam->getParametro('id_obligacion') != '') {//#56
            $this->objParam->addFiltro("o.id_obligacion = ". $this->objParam->getParametro('id_obligacion'));
        }

      
        $this->objFunc=$this->create('MODObligacion');

        $this->res=$this->objFunc->listarReporteBancos($this->objParam);

        //obtener titulo del reporte
        $titulo = 'RESUMEN - RELACION DE SALDOS';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $this->objParam->addParametro('titulo_archivo',$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        //Instancia la clase de pdf
        $this->objReporteFormato=new RRelacionSaldos($this->objParam);
        
        
		$this->objReporteFormato->setDatos($this->res->datos,$this->res->datos);
			$this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
 
			$this->mensajeExito=new Mensaje();
        	$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
	        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
	        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	

    }



//#142
function reporteAbonoXls()    {//#77 #83

            $titulo ='Abono en cuenta';
            //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

            $this->objParam->addParametro('titulo_archivo',$titulo);
            $this->objParam->addParametro('datos',$this->res->datos);
            $this->objParam->addParametro('fecha',$fecha);
            $this->objParam->addParametro('tipo_reporte',$tipo_reporte);
            $this->objParam->addParametro('tipo_contrato',$this->objParam->getParametro('tipo_contrato'));
            $this->objParam->addParametro('id_obligacion',$this->objParam->getParametro('id_obligacion')); 
            $this->objParam->addParametro('esquema',$esquema); //#83
            //Instancia la clase de excel
            $this->objFunc=$this->create('MODObligacion');

            $this->res=$this->objFunc->listarAbonoCuentaXls($this->objParam);
            $this->objReporteFormato=new RAbonoCuentaXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
           //var_dump($this->res->datos); exit;
            $this->objReporteFormato->generarReporte($this->res->datos);


            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                'Se generó con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }


			
}

?>