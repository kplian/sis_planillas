<?php
/**
*@package pXP
*@file gen-MODConsolidadoColumna.php
*@author  (jrivera)
*@date 14-07-2014 19:04:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODConsolidadoColumna extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConsolidadoColumna(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_consolidado_columna_sel';
		$this->transaccion='PLA_CONCOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_consolidado_columna','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_consolidado','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_tipo_columna','int4');
		$this->captura('valor','numeric');
		$this->captura('codigo_columna','varchar');
		$this->captura('tipo_contrato','varchar');
		$this->captura('valor_ejecutado','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre_partida','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConsolidadoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_consolidado_columna_ime';
		$this->transaccion='PLA_CONCOL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_consolidado','id_consolidado','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');
		$this->setParametro('valor_ejecutado','valor_ejecutado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConsolidadoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_consolidado_columna_ime';
		$this->transaccion='PLA_CONCOL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_consolidado_columna','id_consolidado_columna','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_consolidado','id_consolidado','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');
		$this->setParametro('valor_ejecutado','valor_ejecutado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConsolidadoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_consolidado_columna_ime';
		$this->transaccion='PLA_CONCOL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_consolidado_columna','id_consolidado_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>