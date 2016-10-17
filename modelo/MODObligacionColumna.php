<?php
/**
*@package pXP
*@file gen-MODObligacionColumna.php
*@author  (jrivera)
*@date 14-07-2014 20:28:37
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODObligacionColumna extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarObligacionColumna(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_obligacion_columna_sel';
		$this->transaccion='PLA_OBLICOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_obligacion_columna','int4');
		$this->captura('id_cc','int4');
		$this->captura('id_obligacion','int4');
		$this->captura('id_presupuesto','int4');
		$this->captura('id_tipo_columna','int4');
		$this->captura('codigo_columna','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('monto_detalle_obligacion','numeric');
		$this->captura('tipo_contrato','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nombre','varchar');		
		$this->captura('codigo_cc','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarObligacionColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_columna_ime';
		$this->transaccion='PLA_OBLICOL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cc','id_cc','int4');
		$this->setParametro('id_obligacion','id_obligacion','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('monto_detalle_obligacion','monto_detalle_obligacion','numeric');
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarObligacionColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_columna_ime';
		$this->transaccion='PLA_OBLICOL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_columna','id_obligacion_columna','int4');
		$this->setParametro('id_cc','id_cc','int4');
		$this->setParametro('id_obligacion','id_obligacion','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('monto_detalle_obligacion','monto_detalle_obligacion','numeric');
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarObligacionColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_columna_ime';
		$this->transaccion='PLA_OBLICOL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion_columna','id_obligacion_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>