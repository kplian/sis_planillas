<?php
/**
*@package pXP
*@file gen-MODObligacion.php
*@author  (jrivera)
*@date 14-07-2014 20:30:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 * 
 *   
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#38 ETR             12/09/2019          RAC                 metodo para verificar si existen cbtes de pago
#46	ETR				23.09.2019			MZM					Listado para reporte abono en cuenta  
#56	ETR				30.09.2019			MZM					Listado resumen de saldos
#78	ETR			    19-11-2019          RAC				    considerar esquema para origen de datos PLA_OBLI_SEL
#83	ETR				10.12.2019			MZM					Habilitacion de opcion historico de planilla 
#84	ETR				26.12.2019			MZM					Habilitacion de opcion en REPOBANCDET de ci de funcionario
#98	ETR				04.03.2020			MZM					Adecuacion para generacion de reporte consolidado (caso planilla reintegros)
#128ETR				25.05.2020			MZM					Adicion de columna para reporte por bancos (bono de produccion) 
 * 
 * */
class MODObligacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarObligacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_obligacion_sel';
		$this->transaccion='PLA_OBLI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		
		$this->setParametro('groupBy','groupBy','varchar');	 //#38
		$this->setParametro('groupDir','groupDir','varchar'); //#38		
		$this->setParametro('esquema','esquema','varchar'); //#78
				
		//Definicion de la lista del resultado del query
		$this->captura('id_obligacion','int4');		
		$this->captura('id_obligacion_agrupador','int4');//#38
		$this->captura('desc_agrupador','text');//#38
		$this->captura('id_auxiliar','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('id_planilla','int4');
		$this->captura('id_tipo_obligacion','int4');
		$this->captura('monto_obligacion','numeric');
		$this->captura('acreedor','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo_pago','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('es_pagable','varchar');	
		$this->captura('desc_tipo_obligacion','varchar');//#38
		$this->captura('id_int_comprobante','int4');	//#38
		$this->captura('id_int_comprobante_agrupador','int4');	//#38
		
			
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_ime';
		$this->transaccion='PLA_OBLI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_tipo_obligacion','id_tipo_obligacion','int4');
		$this->setParametro('monto_obligacion','monto_obligacion','numeric');
		$this->setParametro('acreedor','acreedor','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_ime';
		$this->transaccion='PLA_OBLI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion','id_obligacion','int4');		
		$this->setParametro('acreedor','acreedor','varchar');		
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarObligacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_ime';
		$this->transaccion='PLA_OBLI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_obligacion','id_obligacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	//#38 añade metodo para validar si existe algun cbte de pago generado para la planilla
	function existenCbteDePago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_obligacion_ime';
		$this->transaccion='PLA_EXCBTE_PAG';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	//#46
	function listarAbonoCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_obligacion_sel';
		$this->transaccion='PLA_ABOCUE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
						
		//Definicion de la lista del resultado del query
		$this->captura('total','text');		
		$this->captura('detalle','text');//#46
		
		
		$this->captura('periodo','text');//#46
		
				
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
		
		
		//#56
		function listarReporteBancos(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_obligacion_sel';
		$this->transaccion='PLA_REPOBANC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_obligacion','id_obligacion','int4');
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');	//#83
		$this->setParametro('esquema','esquema','varchar');//#83
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		$this->setParametro('id_periodo','id_periodo','integer');//#98
		$this->setParametro('id_gestion','id_gestion','integer');//#98	
		//Datos de la planilla
		$this->captura('nombre','varchar');
		$this->captura('importe','numeric');
		$this->captura('periodo','text');
		$this->captura('banco','varchar');
		$this->captura('tipo_pago','text');
		$this->captura('tipo_contrato','varchar');//#56
		//$this->captura('desc_funcionario2','text');//#60
		//$this->captura('nro_cuenta','varchar');//#60
		
		
		$this->captura('orden','numeric');//#60
		$this->captura('caja_oficina','numeric');//#128
		//Ejecuta la instruccion
		$this->armarConsulta();		
	//echo "****".$this->getConsulta(); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
		
		
		function listarReporteBancosDet(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_obligacion_sel';
		$this->transaccion='PLA_REPOBANCDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_obligacion','id_obligacion','int4');
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');	//#83
		$this->setParametro('esquema','esquema','varchar');	//#83	
		
		//#98			
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		$this->setParametro('consolidar','consolidar','varchar');//#98
		$this->setParametro('id_periodo','id_periodo','integer');//#98			
		
		//Datos de la planilla
		$this->captura('det_nombre','varchar');
		$this->captura('det_importe','numeric');
		$this->captura('det_periodo','text');
		$this->captura('det_banco','varchar');
		$this->captura('det_tipo_pago','text');
		$this->captura('det_tipo_contrato','varchar');//#56
		$this->captura('det_desc_funcionario2','text');//#60
		$this->captura('det_nro_cuenta','varchar');//#60
		$this->captura('det_orden','numeric');//#60
		$this->captura('codigo','text');//#60
		$this->captura('ci','varchar');//#84
		
		//Ejecuta la instruccion
		$this->armarConsulta();		
		//echo "---****".$this->getConsulta(); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function listarAbonoCuentaXls(){//#142
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_obligacion_sel';
		$this->transaccion='PLA_ABONOXLS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_obligacion','id_obligacion','int4');
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');			
		//Definicion de la lista del resultadoel query
		$this->captura('nombre','varchar');		
		$this->captura('codigo_bnb','varchar');
		$this->captura('fecha','text');
		
		$this->captura('num_abonos','bigint');
		$this->captura('total','numeric');
		$this->captura('ci','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('gestion','int4');
		$this->captura('monto_transferencia','numeric');
		$this->captura('numero_cuenta','varchar');
		$this->captura('periodo','text');		
				
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//echo $this->getConsulta(); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>