<?php
/**
*@package pXP
*@file gen-MODAntiguedad.php
*@author  (admin)
*@date 20-01-2014 03:47:41
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAntiguedad extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAntiguedad(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_antiguedad_sel';
		$this->transaccion='PLA_ANTI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_antiguedad','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('valor_max','int4');
		$this->captura('porcentaje','numeric');
		$this->captura('valor_min','int4');
		$this->captura('id_usuario_reg','int4');
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
			
	function insertarAntiguedad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_antiguedad_ime';
		$this->transaccion='PLA_ANTI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('valor_max','valor_max','int4');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('valor_min','valor_min','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAntiguedad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_antiguedad_ime';
		$this->transaccion='PLA_ANTI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_antiguedad','id_antiguedad','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('valor_max','valor_max','int4');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('valor_min','valor_min','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAntiguedad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_antiguedad_ime';
		$this->transaccion='PLA_ANTI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_antiguedad','id_antiguedad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>