<?php
/**
*@package pXP
*@file gen-MODObligacion.php
*@author  (jrivera)
*@date 14-07-2014 20:30:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODObligacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarObligacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_obligacion_sel';
		$this->transaccion='PLA_OBLI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_obligacion','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('id_planilla','int4');
		$this->captura('id_tipo_obligacion','int4');
		$this->captura('monto_obligacion','numeric');
		$this->captura('acreedor','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo_pago','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('es_pagable','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_ime';
		$this->transaccion='PLA_OBLI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_tipo_obligacion','id_tipo_obligacion','int4');
		$this->setParametro('monto_obligacion','monto_obligacion','numeric');
		$this->setParametro('acreedor','acreedor','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_ime';
		$this->transaccion='PLA_OBLI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion','id_obligacion','int4');		
		$this->setParametro('acreedor','acreedor','varchar');		
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_ime';
		$this->transaccion='PLA_OBLI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion','id_obligacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>