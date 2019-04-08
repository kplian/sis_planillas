<?php
/**
*@package pXP
*@file gen-MODTipoLicencia.php
*@author  (admin)
*@date 07-03-2019 13:52:26
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoLicencia extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoLicencia(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_tipo_licencia_sel';
		$this->transaccion='PLA_TIPLIC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_licencia','int4');
		$this->captura('nombre','varchar');
		$this->captura('genera_descuento','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
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
			
	function insertarTipoLicencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_licencia_ime';
		$this->transaccion='PLA_TIPLIC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('genera_descuento','genera_descuento','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoLicencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_licencia_ime';
		$this->transaccion='PLA_TIPLIC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_licencia','id_tipo_licencia','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('genera_descuento','genera_descuento','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoLicencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_licencia_ime';
		$this->transaccion='PLA_TIPLIC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_licencia','id_tipo_licencia','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>