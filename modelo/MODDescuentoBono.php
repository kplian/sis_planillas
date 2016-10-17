<?php
/**
*@package pXP
*@file gen-MODDescuentoBono.php
*@author  (admin)
*@date 20-01-2014 18:26:40
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDescuentoBono extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDescuentoBono(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_descuento_bono_sel';
		$this->transaccion='PLA_DESBON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_descuento_bono','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_tipo_columna','int4');
		$this->captura('valor_por_cuota','numeric');
		$this->captura('monto_total','numeric');
		$this->captura('num_cuotas','int4');
		$this->captura('fecha_ini','date');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_moneda','varchar');
		$this->captura('codigo_columna','varchar');
		$this->captura('tipo_descuento_bono','varchar');
		$this->captura('tipo_dato','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDescuentoBono(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_descuento_bono_ime';
		$this->transaccion='PLA_DESBON_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('valor_por_cuota','valor_por_cuota','numeric');
		$this->setParametro('monto_total','monto_total','numeric');
		$this->setParametro('num_cuotas','num_cuotas','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDescuentoBono(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_descuento_bono_ime';
		$this->transaccion='PLA_DESBON_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_descuento_bono','id_descuento_bono','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('valor_por_cuota','valor_por_cuota','numeric');
		$this->setParametro('monto_total','monto_total','numeric');
		$this->setParametro('num_cuotas','num_cuotas','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDescuentoBono(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_descuento_bono_ime';
		$this->transaccion='PLA_DESBON_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_descuento_bono','id_descuento_bono','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>