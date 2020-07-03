<?php
/**
*@package pXP
*@file gen-MODTipoColumna.php
*@author  (admin)
*@date 17-01-2014 19:43:15
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * 
 *     HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               17-01-2014         JRR KPLIAN       creacion
 #10              04/06/2019        RAC KPLIAN        añade posibilidad  para configurar  si el tipo de columna es editable
 #143			  26.06.2020		MZM KPLIAN		  adicion de campo tipo_movimiento 
*/

class MODTipoColumna extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoColumna(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_tipo_columna_sel';
		$this->transaccion='PLA_TIPCOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_columna','int4');
		$this->captura('id_tipo_planilla','int4');
		$this->captura('compromete','varchar');
		$this->captura('tipo_descuento_bono','varchar');
		$this->captura('tipo_dato','varchar');
		$this->captura('codigo','varchar');
		$this->captura('decimales_redondeo','int4');
		$this->captura('nombre','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('orden','int4');
		$this->captura('descripcion','text');
		$this->captura('formula','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('finiquito','varchar');
		$this->captura('tiene_detalle','varchar');
		$this->captura('recalcular','varchar');
		$this->captura('editable','varchar');  // #10 ++
		$this->captura('tipo_movimiento','varchar');  // #143
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_columna_ime';
		$this->transaccion='PLA_TIPCOL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('compromete','compromete','varchar');
		$this->setParametro('tipo_descuento_bono','tipo_descuento_bono','varchar');
		$this->setParametro('tipo_dato','tipo_dato','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('decimales_redondeo','decimales_redondeo','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('orden','orden','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('formula','formula','varchar');
		$this->setParametro('finiquito','finiquito','varchar');
		$this->setParametro('tiene_detalle','tiene_detalle','varchar');
		$this->setParametro('recalcular','recalcular','varchar');
		$this->setParametro('editable','editable','varchar'); //#10 ++
		$this->setParametro('tipo_movimiento','tipo_movimiento','varchar'); //#143
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_columna_ime';
		$this->transaccion='PLA_TIPCOL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
		$this->setParametro('compromete','compromete','varchar');
		$this->setParametro('tipo_descuento_bono','tipo_descuento_bono','varchar');
		$this->setParametro('tipo_dato','tipo_dato','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('decimales_redondeo','decimales_redondeo','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('orden','orden','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('formula','formula','varchar');
		$this->setParametro('finiquito','finiquito','varchar');
		$this->setParametro('tiene_detalle','tiene_detalle','varchar');
		$this->setParametro('recalcular','recalcular','varchar');
		$this->setParametro('editable','editable','varchar'); //#10 ++
		$this->setParametro('tipo_movimiento','tipo_movimiento','varchar'); //#143

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_tipo_columna_ime';
		$this->transaccion='PLA_TIPCOL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>