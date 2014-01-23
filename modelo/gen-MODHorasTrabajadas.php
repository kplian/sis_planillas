<?php
/**
*@package pXP
*@file gen-MODHorasTrabajadas.php
*@author  (admin)
*@date 22-01-2014 16:11:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODHorasTrabajadas extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarHorasTrabajadas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_horas_trabajadas_sel';
		$this->transaccion='PLA_HORTRA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_horas_trabajadas','int4');
		$this->captura('id_funcionario_planilla','int4');
		$this->captura('id_uo_funcionario','int4');
		$this->captura('tipo_contrato','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('horas_nocturnas','numeric');
		$this->captura('horas_disponibilidad','numeric');
		$this->captura('horas_extras','numeric');
		$this->captura('horas_normales','numeric');
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
			
	function insertarHorasTrabajadas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_horas_trabajadas_ime';
		$this->transaccion='PLA_HORTRA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario_planilla','id_funcionario_planilla','int4');
		$this->setParametro('id_uo_funcionario','id_uo_funcionario','int4');
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('horas_nocturnas','horas_nocturnas','numeric');
		$this->setParametro('horas_disponibilidad','horas_disponibilidad','numeric');
		$this->setParametro('horas_extras','horas_extras','numeric');
		$this->setParametro('horas_normales','horas_normales','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarHorasTrabajadas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_horas_trabajadas_ime';
		$this->transaccion='PLA_HORTRA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_horas_trabajadas','id_horas_trabajadas','int4');
		$this->setParametro('id_funcionario_planilla','id_funcionario_planilla','int4');
		$this->setParametro('id_uo_funcionario','id_uo_funcionario','int4');
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('horas_nocturnas','horas_nocturnas','numeric');
		$this->setParametro('horas_disponibilidad','horas_disponibilidad','numeric');
		$this->setParametro('horas_extras','horas_extras','numeric');
		$this->setParametro('horas_normales','horas_normales','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarHorasTrabajadas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_horas_trabajadas_ime';
		$this->transaccion='PLA_HORTRA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_horas_trabajadas','id_horas_trabajadas','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>