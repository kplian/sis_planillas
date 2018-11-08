<?php
/**
*@package pXP
*@file gen-MODPlanillaSigma.php
*@author  (jrivera)
*@date 22-09-2015 14:58:50
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPlanillaSigma extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPlanillaSigma(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sigma_sel';
		$this->transaccion='PLA_PLASI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('gerencia','varchar');		
		$this->captura('ci','varchar');
		$this->captura('tipo_contrato','varchar');		
		$this->captura('desc_funcionario','text');
		$this->captura('liquido_erp','numeric');
		$this->captura('liquido_sigma','numeric');
				
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPlanillaSigma(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_sigma_ime';
		$this->transaccion='PLA_PLASI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('ci','ci','varchar');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('sueldo_liquido','sueldo_liquido','numeric');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function eliminarPlanillaSigma(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_sigma_ime';
		$this->transaccion='PLA_PLASI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
			
}
?>