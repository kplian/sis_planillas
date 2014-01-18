<?php
/**
*@package pXP
*@file gen-MODReporte.php
*@author  (admin)
*@date 17-01-2014 22:07:28
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODReporte extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarReporte(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_reporte_sel';
		$this->transaccion='PLA_REPO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_reporte','int4');
		$this->captura('id_tipo_planilla','int4');
		$this->captura('numerar','varchar');
		$this->captura('hoja_posicion','varchar');
		$this->captura('mostrar_nombre','varchar');
		$this->captura('mostrar_codigo_empleado','varchar');
		$this->captura('mostrar_doc_id','varchar');
		$this->captura('mostrar_codigo_cargo','varchar');
		$this->captura('agrupar_por','varchar');
		$this->captura('ordenar_por','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('ancho_utilizado','int4');
		$this->captura('ancho_total','int4');
		$this->captura('titulo_reporte','varchar');
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
			
	function insertarReporte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_reporte_ime';
		$this->transaccion='PLA_REPO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('numerar','numerar','varchar');
		$this->setParametro('hoja_posicion','hoja_posicion','varchar');
		$this->setParametro('mostrar_nombre','mostrar_nombre','varchar');
		$this->setParametro('mostrar_codigo_empleado','mostrar_codigo_empleado','varchar');
		$this->setParametro('mostrar_doc_id','mostrar_doc_id','varchar');
		$this->setParametro('mostrar_codigo_cargo','mostrar_codigo_cargo','varchar');
		$this->setParametro('agrupar_por','agrupar_por','varchar');
		$this->setParametro('ordenar_por','ordenar_por','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ancho_utilizado','ancho_utilizado','int4');
		$this->setParametro('ancho_total','ancho_total','int4');
		$this->setParametro('titulo_reporte','titulo_reporte','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarReporte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_reporte_ime';
		$this->transaccion='PLA_REPO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte','id_reporte','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('numerar','numerar','varchar');
		$this->setParametro('hoja_posicion','hoja_posicion','varchar');
		$this->setParametro('mostrar_nombre','mostrar_nombre','varchar');
		$this->setParametro('mostrar_codigo_empleado','mostrar_codigo_empleado','varchar');
		$this->setParametro('mostrar_doc_id','mostrar_doc_id','varchar');
		$this->setParametro('mostrar_codigo_cargo','mostrar_codigo_cargo','varchar');
		$this->setParametro('agrupar_por','agrupar_por','varchar');
		$this->setParametro('ordenar_por','ordenar_por','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ancho_utilizado','ancho_utilizado','int4');
		$this->setParametro('ancho_total','ancho_total','int4');
		$this->setParametro('titulo_reporte','titulo_reporte','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarReporte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_reporte_ime';
		$this->transaccion='PLA_REPO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte','id_reporte','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>