<?php
/**
*@package pXP
*@file gen-MODColumnaValor.php
*@author  (admin)
*@date 27-01-2014 04:53:54
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * 
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0              27-01-2014         RAC              creacion
#78	ETR			19-11-2019         RAC				considerar esquema para origen de datos
#132ETR		  	01/06/2020		   MZM KPLIAN		Habilitacion de opcion para reseteo de valores de columnas variables
*/

class MODColumnaValor extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarColumnaValor(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_columna_valor_sel';
		$this->transaccion='PLA_COLVAL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('esquema','esquema','varchar'); //#78
				
		//Definicion de la lista del resultado del query
		$this->captura('id_columna_valor','int4');
		$this->captura('id_tipo_columna','int4');
		$this->captura('id_funcionario_planilla','int4');
		$this->captura('codigo_columna','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('valor','numeric');
		$this->captura('valor_generado','numeric');
		$this->captura('formula','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nombre_columna','varchar');
		$this->captura('estado_planilla','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarColumnaValor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_valor_ime';
		$this->transaccion='PLA_COLVAL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('id_funcionario_planilla','id_funcionario_planilla','int4');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('valor_generado','valor_generado','numeric');
		$this->setParametro('formula','formula','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarColumnaValor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_valor_ime';
		$this->transaccion='PLA_COLVAL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_valor','id_columna_valor','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('id_funcionario_planilla','id_funcionario_planilla','int4');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('valor_generado','valor_generado','numeric');
		$this->setParametro('formula','formula','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function modificarColumnaCsv(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_valor_ime';
		$this->transaccion='PLA_COLVALCSV_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('ci','ci','varchar');
		$this->setParametro('valor','valor','numeric');		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarColumnaValor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_valor_ime';
		$this->transaccion='PLA_COLVAL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_columna_valor','id_columna_valor','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	//#132
	function resetColumnaValor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_columna_valor_ime';
		$this->transaccion='PLA_COLVALRES_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_tipo_col','id_tipo_col','int4');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>