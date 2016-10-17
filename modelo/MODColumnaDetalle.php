<?php
/**
*@package pXP
*@file gen-MODColumnaDetalle.php
*@author  (jrivera)
*@date 06-12-2014 17:17:45
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODColumnaDetalle extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarColumnaDetalle(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_columna_detalle_sel';
		$this->transaccion='PLA_COLDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_columna_detalle','int4');
		$this->captura('id_horas_trabajadas','int4');
		$this->captura('id_columna_valor','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('valor_generado','numeric');
		$this->captura('valor','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('fecha_fin','date');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarColumnaDetalle(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_detalle_ime';
		$this->transaccion='PLA_COLDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_horas_trabajadas','id_horas_trabajadas','int4');
		$this->setParametro('id_columna_valor','id_columna_valor','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('valor_generado','valor_generado','numeric');
		$this->setParametro('valor','valor','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarColumnaDetalle(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_detalle_ime';
		$this->transaccion='PLA_COLDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_detalle','id_columna_detalle','int4');
		$this->setParametro('id_horas_trabajadas','id_horas_trabajadas','int4');
		$this->setParametro('id_columna_valor','id_columna_valor','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('valor_generado','valor_generado','numeric');
		$this->setParametro('valor','valor','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarColumnaDetalle(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_detalle_ime';
		$this->transaccion='PLA_COLDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_detalle','id_columna_detalle','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>