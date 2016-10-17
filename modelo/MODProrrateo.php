<?php
/**
*@package pXP
*@file gen-MODProrrateo.php
*@author  (jrivera)
*@date 17-02-2016 16:12:04
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProrrateo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProrrateo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_prorrateo_sel';
		$this->transaccion='PLA_PRO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_prorrateo','int4');		
		$this->captura('id_cc','int4');
		$this->captura('codigo_cc','text');
		
		$this->captura('id_funcionario_planilla','int4');
		$this->captura('id_horas_trabajadas','int4');		
		$this->captura('porcentaje','numeric');		
		$this->captura('tipo_contrato','varchar');		
		
		$this->captura('estado_reg','varchar');		
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usr_reg','varchar');
		
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_mod','varchar');
				
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');	
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}		
	
			
	function modificarProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_prorrateo_ime';
		$this->transaccion='PLA_PRO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_prorrateo','id_prorrateo','int4');		
		$this->setParametro('id_cc','id_cc','int4');		
		$this->setParametro('porcentaje','porcentaje','numeric');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_prorrateo_ime';
		$this->transaccion='PLA_PRO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_prorrateo','id_prorrateo','int4');		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>