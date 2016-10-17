<?php
/**
*@package pXP
*@file gen-ACTPlanillaSigma.php
*@author  (jrivera)
*@date 22-09-2015 14:58:50
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RDiferenciasPlanillaSigmaXLS.php');
class ACTPlanillaSigma extends ACTbase{    
			
	function listarDiferenciasPlanillaSigma(){
		$this->objFunc=$this->create('MODPlanillaSigma');			
		$this->res=$this->objFunc->listarPlanillaSigma($this->objParam);		
		$this->objParam->addParametro('datos',$this->res->datos);			
		
			
		//obtener titulo del reporte
		$titulo = 'RepDiferenciasSigma';
		
		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);		
		
		$this->objReporteFormato=new RDiferenciasPlanillaSigmaXLS($this->objParam);
		$this->objReporteFormato->imprimeDatos();		
		
		
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
										'Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}
				
	function insertarPlanillaSigma(){
		$this->objFunc=$this->create('MODPlanillaSigma');	
		if($this->objParam->insertar('id_planilla_sigma')){
			$this->res=$this->objFunc->insertarPlanillaSigma($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlanillaSigma($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlanillaSigma(){
			$this->objFunc=$this->create('MODPlanillaSigma');	
		$this->res=$this->objFunc->eliminarPlanillaSigma($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function subirCsvPlanillaSigma(){
		//validar extnsion del archivo	
		$arregloFiles = $this->objParam->getArregloFiles();
		$ext = pathinfo($arregloFiles['archivo']['name']);
		$extension = $ext['extension'];
		$error = 'no';
		$mensaje_completo = '';
		//validar errores unicos del archivo: existencia, copia y extension
		if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){
			if ($extension != 'csv' && $extension != 'CSV') {
				$mensaje_completo = "La extensión del archivo debe ser CSV";
				$error = 'error_fatal';
			}  
	  	    //upload directory  
		    $upload_dir = "/tmp/";  
		    //create file name  
		    $file_path = $upload_dir . $arregloFiles['archivo']['name'];  
		  	
		    //move uploaded file to upload dir  
		    if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {	  
		        //error moving upload file  
		        $mensaje_completo = "Error al guardar el archivo csv en disco";
				$error = 'error_fatal';	  
		    } 
			if ($this->objParam->getParametro('accion') == 'reemplazar'){
					
				$this->objFunc=$this->create('MODPlanillaSigma');
				$this->res=$this->objFunc->eliminarPlanillaSigma($this->objParam);
				if ($this->res->getTipo() == 'ERROR') {
					$error = 'error_fatal';
					$mensaje_completo = $this->res->getMensaje();
				}
			} 
			
		} else {
			$mensaje_completo = "No se subio el archivo";
			$error = 'error_fatal';
		}
		//armar respuesta en error fatal
		if ($error == 'error_fatal') {
			
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTColumnaCalor.php',$mensaje_completo,
										$mensaje_completo,'control');
		//si no es error fatal proceso el archivo
		} else {
			$lines = file($file_path);
			
			foreach ($lines as $line_num => $line) {
				$arr_temp = explode('|', $line);
				
				
				
				if (count($arr_temp) != 2) {
					$error = 'error';
					$mensaje_completo .= "No se proceso la linea: $line_num, por un error en el formato \n";
					
				} else {
					$arr_temp[1] = str_replace(',', '.', $arr_temp[1]);					
					$this->objParam->addParametro('ci',$arr_temp[0]);
					$this->objParam->addParametro('sueldo_liquido',$arr_temp[1]);
					$this->objFunc=$this->create('MODPlanillaSigma');
					$this->res=$this->objFunc->insertarPlanillaSigma($this->objParam);
					if ($this->res->getTipo() == 'ERROR') {
						$error = 'error';
						$mensaje_completo .= $this->res->getMensaje() . " \n";
					}
				}
			}
		}
		
		//armar respuesta en caso de exito o error en algunas tuplas
		if ($error == 'error') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTPlanillaSigma.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
										$mensaje_completo,'control');
		} else if ($error == 'no') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('EXITO','ACTPlanillaSigma.php','El archivo fue ejecutado con éxito',
										'El archivo fue ejecutado con éxito','control');
		}		
		
		//devolver respuesta
		$this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
	}
			
}

?>