<?php
/**
*@package pXP
*@file gen-MODFiltroCbte.php
*@author  (miguel.mamani)
*@date 15-05-2019 22:18:29
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#6	ETR			15-05-2019 22:18:29		MMV Kplian			Identifica los presupeusto que entran al abte de diario presupeustario para planillas, los que noesten presente iran al  cbte de diraio
#*/

class MODFiltroCbte extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFiltroCbte(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_filtro_cbte_sel';
		$this->transaccion='PLA_FOE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_filtro_cbte','int4');
		$this->captura('id_tipo_presupuesto','int4');
        $this->captura('tipo_presupuesto','varchar');
        $this->captura('obs','text');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFiltroCbte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_filtro_cbte_ime';
		$this->transaccion='PLA_FOE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_presupuesto','id_tipo_presupuesto','int4');
		$this->setParametro('obs','obs','text');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFiltroCbte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_filtro_cbte_ime';
		$this->transaccion='PLA_FOE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_filtro_cbte','id_filtro_cbte','int4');
		$this->setParametro('id_tipo_presupuesto','id_tipo_presupuesto','int4');
		$this->setParametro('obs','obs','text');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFiltroCbte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_filtro_cbte_ime';
		$this->transaccion='PLA_FOE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_filtro_cbte','id_filtro_cbte','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>