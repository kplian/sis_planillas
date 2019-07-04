<?php
/***
 Nombre: ACTFuncionarioPlanillaReporte.php
 Proposito: Clase de Control para recibir los parametros enviados por los archivos
 de la Vista para envio y ejecucion de los metodos del Modelo referidas a la tabla tfuncionario 
 ISSUE            FECHA:              AUTOR                 DESCRIPCION  
  #16           04/07/2019         	  EGS                 	creacion
 */
class ACTFuncionarioPlanillaReporte extends ACTbase{    

	function listarFuncionarioPlanillaReporte(){

		//el objeto objParam contiene todas la variables recibidad desde la interfaz
		
		// parametros de ordenacion por defecto
		$this->objParam->defecto('ordenacion','id_funcionario');
		$this->objParam->defecto('dir_ordenacion','asc');
			
		//crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
		if ($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte=new Reporte($this->objParam, $this);
			$this->res=$this->objReporte->generarReporteListado('MODFuncionarioPlanillaReporte','listarFuncionarioPlanillaReporte');
		}
		else {
			$this->objFunSeguridad=$this->create('MODFuncionarioPlanillaReporte');
			//ejecuta el metodo de lista funcionarios a travez de la intefaz objetoFunSeguridad 
			
			//var_dump('ACT',$this->objParam);exit;
			$this->res=$this->objFunSeguridad->listarFuncionarioPlanillaReporte($this->objParam);
			
		}
		//imprime respuesta en formato JSON para enviar lo a la interface (vista)
		$this->res->imprimirRespuesta($this->res->generarJson());
 
		
	}
	

}

?>