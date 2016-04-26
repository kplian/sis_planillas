<?php
/**
*@package pXP
*@file gen-MODTipoPlanilla.php
*@author  (admin)
*@date 17-01-2014 15:36:53
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoPlanilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoPlanilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_tipo_planilla_sel';
		$this->transaccion='PLA_TIPPLA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_planilla','int4');
		$this->captura('id_proceso_macro','int4');
		$this->captura('tipo_presu_cc','varchar');
		$this->captura('funcion_obtener_empleados','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_proceso_macro','varchar');
		$this->captura('funcion_validacion_nuevo_empleado','varchar');
		$this->captura('calculo_horas','varchar');
		$this->captura('periodicidad','varchar');
		$this->captura('funcion_calculo_horas','varchar');
		$this->captura('recalcular_desde','int4');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_planilla_ime';
		$this->transaccion='PLA_TIPPLA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('tipo_presu_cc','tipo_presu_cc','varchar');
		$this->setParametro('funcion_obtener_empleados','funcion_obtener_empleados','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('funcion_validacion_nuevo_empleado','funcion_validacion_nuevo_empleado','varchar');
		$this->setParametro('calculo_horas','calculo_horas','varchar');
		$this->setParametro('periodicidad','periodicidad','varchar');
		$this->setParametro('funcion_calculo_horas','funcion_calculo_horas','varchar');
		$this->setParametro('recalcular_desde','recalcular_desde','int4');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_planilla_ime';
		$this->transaccion='PLA_TIPPLA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('tipo_presu_cc','tipo_presu_cc','varchar');
		$this->setParametro('funcion_obtener_empleados','funcion_obtener_empleados','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('funcion_validacion_nuevo_empleado','funcion_validacion_nuevo_empleado','varchar');
		$this->setParametro('calculo_horas','calculo_horas','varchar');
		$this->setParametro('periodicidad','periodicidad','varchar');
		$this->setParametro('funcion_calculo_horas','funcion_calculo_horas','varchar');
		$this->setParametro('recalcular_desde','recalcular_desde','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoPlanilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_planilla_ime';
		$this->transaccion='PLA_TIPPLA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>