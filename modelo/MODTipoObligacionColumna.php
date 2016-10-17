<?php
/**
*@package pXP
*@file gen-MODTipoObligacionColumna.php
*@author  (admin)
*@date 18-01-2014 02:57:04
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoObligacionColumna extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoObligacionColumna(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_tipo_obligacion_columna_sel';
		$this->transaccion='PLA_OBCOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_obligacion_columna','int4');
		$this->captura('id_tipo_obligacion','int4');
		$this->captura('presupuesto','varchar');
		$this->captura('pago','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_columna','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('es_ultimo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoObligacionColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_columna_ime';
		$this->transaccion='PLA_OBCOL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_obligacion','id_tipo_obligacion','int4');
		$this->setParametro('presupuesto','presupuesto','varchar');
		$this->setParametro('pago','pago','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('es_ultimo','es_ultimo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoObligacionColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_columna_ime';
		$this->transaccion='PLA_OBCOL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_obligacion_columna','id_tipo_obligacion_columna','int4');
		$this->setParametro('id_tipo_obligacion','id_tipo_obligacion','int4');
		$this->setParametro('presupuesto','presupuesto','varchar');
		$this->setParametro('pago','pago','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('es_ultimo','es_ultimo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoObligacionColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_columna_ime';
		$this->transaccion='PLA_OBCOL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_obligacion_columna','id_tipo_obligacion_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>