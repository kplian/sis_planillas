<?php
/**
*@package pXP
*@file gen-MODFuncionarioAfp.php
*@author  (admin)
*@date 20-01-2014 16:05:08
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFuncionarioAfp extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFuncionarioAfp(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_funcionario_afp_sel';
		$this->transaccion='PLA_FUNAFP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_funcionario_afp','int4');
		$this->captura('id_afp','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('tipo_jubilado','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('fecha_ini','date');
		$this->captura('estado_reg','varchar');
		$this->captura('nro_afp','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nombre','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFuncionarioAfp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_funcionario_afp_ime';
		$this->transaccion='PLA_FUNAFP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_afp','id_afp','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('tipo_jubilado','tipo_jubilado','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_afp','nro_afp','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFuncionarioAfp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_funcionario_afp_ime';
		$this->transaccion='PLA_FUNAFP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario_afp','id_funcionario_afp','int4');
		$this->setParametro('id_afp','id_afp','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('tipo_jubilado','tipo_jubilado','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_afp','nro_afp','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFuncionarioAfp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_funcionario_afp_ime';
		$this->transaccion='PLA_AFP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario_afp','id_funcionario_afp','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>