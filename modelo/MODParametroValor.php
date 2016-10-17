<?php
/**
*@package pXP
*@file gen-MODParametroValor.php
*@author  (admin)
*@date 17-01-2014 15:54:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODParametroValor extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarParametroValor(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_parametro_valor_sel';
		$this->transaccion='PLA_PARVAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_parametro_valor','int4');
		$this->captura('valor','numeric');
		$this->captura('fecha_fin','date');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarParametroValor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_parametro_valor_ime';
		$this->transaccion='PLA_PARVAR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarParametroValor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_parametro_valor_ime';
		$this->transaccion='PLA_PARVAR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_parametro_valor','id_parametro_valor','int4');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarParametroValor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_parametro_valor_ime';
		$this->transaccion='PLA_PARVAR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_parametro_valor','id_parametro_valor','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>