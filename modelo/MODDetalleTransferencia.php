<?php
/**
*@package pXP
*@file gen-MODDetalleTransferencia.php
*@author  (jrivera)
*@date 14-07-2014 20:28:39
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDetalleTransferencia extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDetalleTransferencia(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_detalle_transferencia_sel';
		$this->transaccion='PLA_DETRAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_detalle_transferencia','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('id_institucion','int4');
		$this->captura('id_obligacion','int4');
		$this->captura('nro_cuenta','varchar');
		$this->captura('monto_transferencia','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('ci','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('nombre','varchar');//banco
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//echo $this->getConsulta(); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDetalleTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_detalle_transferencia_ime';
		$this->transaccion='PLA_DETRAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_institucion','id_institucion','int4');
		$this->setParametro('id_obligacion','id_obligacion','int4');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('monto_transferencia','monto_transferencia','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDetalleTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_detalle_transferencia_ime';
		$this->transaccion='PLA_DETRAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_detalle_transferencia','id_detalle_transferencia','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_institucion','id_institucion','int4');
		$this->setParametro('id_obligacion','id_obligacion','int4');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('monto_transferencia','monto_transferencia','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDetalleTransferencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_detalle_transferencia_ime';
		$this->transaccion='PLA_DETRAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_detalle_transferencia','id_detalle_transferencia','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>