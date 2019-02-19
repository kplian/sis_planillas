<?php
/**
*@package pXP
*@file MODTipoObligacionAgrupador.php
*@author  (eddy.gutierrez)
*@date 05-02-2019 20:20:47
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	 ISSUE 	FORK		FECHA			AUTHOR			DESCRIPCION
 	#3		EndeEtr		05/02/2019		EGS				creacion
 * 	#1		EndeEtr		19/02/2019		EGS				Se agrego el campo descripcion
*/

class MODTipoObligacionAgrupador extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoObligacionAgrupador(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_tipo_obligacion_agrupador_sel';
		$this->transaccion='PLA_TIOBAG_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_obligacion_agrupador','int4');
		$this->captura('codigo','varchar');
		$this->captura('codigo_plantilla_comprobante','varchar');
		$this->captura('nombre','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('descripcion','varchar');// #1	EGS
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoObligacionAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_agrupador_ime';
		$this->transaccion='PLA_TIOBAG_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');// #1	EGS
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoObligacionAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_agrupador_ime';
		$this->transaccion='PLA_TIOBAG_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_obligacion_agrupador','id_tipo_obligacion_agrupador','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('codigo_plantilla_comprobante','codigo_plantilla_comprobante','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');// #1	EGS

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoObligacionAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_agrupador_ime';
		$this->transaccion='PLA_TIOBAG_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_obligacion_agrupador','id_tipo_obligacion_agrupador','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>