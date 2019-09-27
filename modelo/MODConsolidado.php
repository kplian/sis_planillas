<?php
/**
*@package pXP
*@file gen-MODConsolidado.php
*@author  (jrivera)
*@date 14-07-2014 19:04:07
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 * 
 * 
 *
 HISTORIAL DE MODIFICACIONES:

 ISSUE            FECHA:              AUTOR                 DESCRIPCION
 #0             14/07/2014        GUY       Creacion
 #53 ETR        26/09/2019        RAC       agregar centro de csoto techo y totalizadores
 * 
 * */

class MODConsolidado extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarConsolidado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_consolidado_sel';
		$this->transaccion='PLA_CONPRE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		$this->capturaCount('total_suma','numeric');   //#53
		$this->capturaCount('total_ejecutado','numeric');   //#53				  
		//Definicion de la lista del resultado del query
		$this->captura('id_consolidado','int4');
		$this->captura('id_cc','int4');
		$this->captura('id_planilla','int4');
		$this->captura('id_presupuesto','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo_consolidado','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_cc','text');
		$this->captura('suma','numeric');
		$this->captura('suma_ejecutado','numeric');		
		$this->captura('id_tipo_cc_techo','int4');  //#53
		$this->captura('codigo_techo','VARCHAR'); //#53
		$this->captura('descripcion_techo','VARCHAR'); //#53
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarConsolidado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_consolidado_ime';
		$this->transaccion='PLA_CONPRE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cc','id_cc','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_consolidado','tipo_consolidado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarConsolidado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_consolidado_ime';
		$this->transaccion='PLA_CONPRE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_consolidado','id_consolidado','int4');
		$this->setParametro('id_cc','id_cc','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_presupuesto','id_presupuesto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo_consolidado','tipo_consolidado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarConsolidado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_consolidado_ime';
		$this->transaccion='PLA_CONPRE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_consolidado','id_consolidado','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	function listarDetalleEjecucionPeriodo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_consolidado_sel';
		$this->transaccion='PLA_DETEJEREP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		
		$this->captura('codigo_cc','text');		
		$this->captura('columna','varchar');
		$this->captura('tipo_contrato','varchar');		
		$this->captura('ejecutado','numeric');
		$this->captura('codigo_columna','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	function listarDetalleEjecucionCategoria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_consolidado_sel';
		$this->transaccion='PLA_DETEJECATE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		
		$this->captura('codigo_cc','text');		
		$this->captura('columna','varchar');
		$this->captura('tipo_contrato','varchar');	
		$this->captura('codigo_columna','varchar');	
		$this->captura('ejecutado','numeric');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarObligaciones(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_consolidado_sel';
		$this->transaccion='PLA_DETOBLIREP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		
		$this->captura('tipo_obligacion','varchar');		
		$this->captura('acreedor','varchar');
		$this->captura('monto','numeric');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarColumnasEjecucion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_consolidado_sel';
		$this->transaccion='PLA_COLEJE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setCount(false);//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		
		$this->captura('codigo_columna','varchar');		
		$this->captura('nombre_columna','varchar');
				
		//Ejecuta la instruccion
		$this->armarConsulta();
		
		
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
			
}
?>