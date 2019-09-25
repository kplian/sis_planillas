<?php
/**
*@package pXP
*@file gen-MODTipoObligacion.php
*@author  (admin)
*@date 17-01-2014 19:43:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * ISSUE 	FORK		FECHA			AUTHOR			DESCRIPCION
 * #3		EndeEtr		05/02/2019		EGS				Se agrego el campo id_tipo_obligacion_agrupador 
   #1		EndeEtr		19/02/2019		EGS				Se agrego el campo descripcion
 * #1		EndeEtr		20/02/2019		EGS				se agrego los campos codigo_tipo_relacion_debe,codigo_tipo_relacion_haber	 	
 * #46		ETR			19.09.2019		MZM				Adicion de campo tipo_abono para reporte abono en cuentas
 * */

class MODTipoObligacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoObligacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_tipo_obligacion_sel';
		$this->transaccion='PLA_TIPOBLI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_obligacion','int4');
		$this->captura('tipo_obligacion','varchar');
		$this->captura('dividir_por_lugar','varchar');
		$this->captura('id_tipo_planilla','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('es_pagable','varchar');
		$this->captura('id_tipo_obligacion_agrupador','int4');//#3 EGS
		$this->captura('codigo_agrupador','varchar'); //#3 EGS
		$this->captura('descripcion','varchar'); //#1 EGS
		$this->captura('codigo_tipo_relacion_debe','varchar'); //#1 EGS
		$this->captura('codigo_tipo_relacion_haber','varchar');	//#1 EGS	
		$this->captura('tipo_abono','varchar');//#46 MZM				
				
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_ime';
		$this->transaccion='PLA_TIPOBLI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('tipo_obligacion','tipo_obligacion','varchar');
		$this->setParametro('dividir_por_lugar','dividir_por_lugar','varchar');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('es_pagable','es_pagable','varchar');
		$this->setParametro('id_tipo_obligacion_agrupador','id_tipo_obligacion_agrupador','int4');//#3 EGS
		$this->setParametro('descripcion','descripcion','varchar');//#1 EGS
		$this->setParametro('codigo_tipo_relacion_debe','codigo_tipo_relacion_debe','varchar');//#1 EGS
		$this->setParametro('codigo_tipo_relacion_haber','codigo_tipo_relacion_haber','varchar');//#1 EGS
		$this->setParametro('tipo_abono','tipo_abono','varchar');//#46 MZM				
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_ime';
		$this->transaccion='PLA_TIPOBLI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_obligacion','id_tipo_obligacion','int4');
		$this->setParametro('tipo_obligacion','tipo_obligacion','varchar');
		$this->setParametro('dividir_por_lugar','dividir_por_lugar','varchar');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('es_pagable','es_pagable','varchar');
		$this->setParametro('id_tipo_obligacion_agrupador','id_tipo_obligacion_agrupador','int4');//#3 EGS
		$this->setParametro('descripcion','descripcion','varchar');//#1 EGS
		$this->setParametro('codigo_tipo_relacion_debe','codigo_tipo_relacion_debe','varchar');//#1 EGS
		$this->setParametro('codigo_tipo_relacion_haber','codigo_tipo_relacion_haber','varchar');//#1 EGS
		$this->setParametro('tipo_abono','tipo_abono','varchar');//#46 MZM		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_obligacion_ime';
		$this->transaccion='PLA_TIPOBLI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_obligacion','id_tipo_obligacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>