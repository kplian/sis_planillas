<?php
/**
*@package pXP
*@file gen-MODPlanilla.php
*@author  (admin)
*@date 22-01-2014 16:11:04
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPlanilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPlanilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_planilla_sel';
		$this->transaccion='PLA_PLANI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_planilla','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_uo','int4');
		$this->captura('id_tipo_planilla','int4');
		$this->captura('id_proceso_macro','int4');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('observaciones','text');
		$this->captura('nro_planilla','varchar');
		$this->captura('estado','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('gestion','int4');
		$this->captura('periodo','int4');
		$this->captura('codigo_planilla','varchar');
		$this->captura('desc_uo','varchar');
		$this->captura('id_depto','int4');
		$this->captura('nombre_depto','varchar');			
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		$this->transaccion='PLA_PLANI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('nro_planilla','nro_planilla','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_depto','id_depto','integer');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		$this->transaccion='PLA_PLANI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','text');
		$this->setParametro('nro_planilla','nro_planilla','varchar');
		$this->setParametro('estado','estado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_planilla_ime';
		$this->transaccion='PLA_PLANI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>