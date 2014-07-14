<?php
/**
*@package pXP
*@file gen-MODFuncionarioPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:08
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFuncionarioPlanilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFuncionarioPlanilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_funcionario_planilla_sel';
		$this->transaccion='PLA_FUNPLAN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_funcionario_planilla','int4');
		$this->captura('finiquito','varchar');
		$this->captura('forzar_cheque','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('id_planilla','int4');
		$this->captura('id_lugar','int4');
		$this->captura('id_uo_funcionario','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_funcionario1','text');
		$this->captura('lugar','varchar');
		$this->captura('afp','varchar');
		$this->captura('nro_afp','varchar');
		$this->captura('banco','varchar');
		$this->captura('nro_cuenta','varchar');	
		$this->captura('ci','varchar');		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFuncionarioPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_funcionario_planilla_ime';
		$this->transaccion='PLA_FUNPLAN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('finiquito','finiquito','varchar');
		$this->setParametro('forzar_cheque','forzar_cheque','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_lugar','id_lugar','int4');
		$this->setParametro('id_uo_funcionario','id_uo_funcionario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFuncionarioPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_funcionario_planilla_ime';
		$this->transaccion='PLA_FUNPLAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario_planilla','id_funcionario_planilla','int4');
		$this->setParametro('finiquito','finiquito','varchar');
		$this->setParametro('forzar_cheque','forzar_cheque','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_lugar','id_lugar','int4');
		$this->setParametro('id_uo_funcionario','id_uo_funcionario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFuncionarioPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_funcionario_planilla_ime';
		$this->transaccion='PLA_FUNPLAN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario_planilla','id_funcionario_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>