<?php
/**
*@package pXP
*@file gen-MODReporteColumna.php
*@author  (admin)
*@date 18-01-2014 02:56:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODReporteColumna extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarReporteColumna(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_reporte_columna_sel';
		$this->transaccion='PLA_REPCOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_reporte_columna','int4');
		$this->captura('id_reporte','int4');
		$this->captura('sumar_total','varchar');
		$this->captura('ancho_columna','int4');
		$this->captura('orden','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_columna','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('titulo_reporte_superior','varchar');
		$this->captura('titulo_reporte_inferior','varchar');
		$this->captura('tipo_columna','varchar');
		
		$this->captura('espacio_previo','integer');
		$this->captura('columna_vista','varchar');
		$this->captura('origen','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarReporteColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_reporte_columna_ime';
		$this->transaccion='PLA_REPCOL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte','id_reporte','int4');
		$this->setParametro('sumar_total','sumar_total','varchar');
		$this->setParametro('ancho_columna','ancho_columna','int4');
		$this->setParametro('orden','orden','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('titulo_reporte_superior','titulo_reporte_superior','varchar');
		$this->setParametro('titulo_reporte_inferior','titulo_reporte_inferior','varchar');
		$this->setParametro('tipo_columna','tipo_columna','varchar');
		$this->setParametro('espacio_previo','espacio_previo','integer');
		$this->setParametro('columna_vista','columna_vista','varchar');
		$this->setParametro('origen','origen','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarReporteColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_reporte_columna_ime';
		$this->transaccion='PLA_REPCOL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte_columna','id_reporte_columna','int4');
		$this->setParametro('id_reporte','id_reporte','int4');
		$this->setParametro('sumar_total','sumar_total','varchar');
		$this->setParametro('ancho_columna','ancho_columna','int4');
		$this->setParametro('orden','orden','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo_columna','codigo_columna','varchar');
		$this->setParametro('titulo_reporte_superior','titulo_reporte_superior','varchar');
		$this->setParametro('titulo_reporte_inferior','titulo_reporte_inferior','varchar');
		$this->setParametro('tipo_columna','tipo_columna','varchar');
		$this->setParametro('espacio_previo','espacio_previo','integer');
		$this->setParametro('columna_vista','columna_vista','varchar');
		$this->setParametro('origen','origen','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarReporteColumna(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_reporte_columna_ime';
		$this->transaccion='PLA_REPCOL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte_columna','id_reporte_columna','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>