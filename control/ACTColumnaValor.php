<?php
/**
*@package pXP
*@file gen-ACTColumnaValor.php
*@author  (admin)
*@date 27-01-2014 04:53:54
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTColumnaValor extends ACTbase{    
			
	function listarColumnaValor(){
		$this->objParam->defecto('ordenacion','id_columna_valor');

		$this->objParam->defecto('dir_ordenacion','asc');
		if ($this->objParam->getParametro('id_funcionario_planilla') != '') {
			$this->objParam->addFiltro("colval.id_funcionario_planilla = ". $this->objParam->getParametro('id_funcionario_planilla'));
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODColumnaValor','listarColumnaValor');
		} else{
			$this->objFunc=$this->create('MODColumnaValor');
			
			$this->res=$this->objFunc->listarColumnaValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarColumnaValor(){
		$this->objFunc=$this->create('MODColumnaValor');	
		if($this->objParam->insertar('id_columna_valor')){
			$this->res=$this->objFunc->insertarColumnaValor($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarColumnaValor($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarColumnaValor(){
			$this->objFunc=$this->create('MODColumnaValor');	
		$this->res=$this->objFunc->eliminarColumnaValor($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function modificarColumnaCsv(){
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
					$this->objParam->addParametro('ci',$arr_temp[0]);
					$this->objParam->addParametro('valor',$arr_temp[1]);
					$this->objFunc=$this->create('MODColumnaValor');
					$this->res=$this->objFunc->modificarColumnaCsv($this->objParam);
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
			$this->mensajeRes->setMensaje('ERROR','ACTColumnaValor.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
										$mensaje_completo,'control');
		} else if ($error == 'no') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('EXITO','ACTColumnaValor.php','El archivo fue ejecutado con éxito',
										'El archivo fue ejecutado con éxito','control');
		}		
		
		//devolver respuesta
		$this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
	}
			
}

?>