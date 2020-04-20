<?php
/**
*@package pXP
*@file gen-MODLicencia.php
*@author  (admin)
*@date 07-03-2019 13:53:18
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
ISSUE      AUTOR       FECHA        DESCRIPCION
#114        EGS        16/04/2020  agregando  desc funcionario por Combo de Funcionario 
 */

class MODLicencia extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarLicencia(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_licencia_sel';
		$this->transaccion='PLA_LICE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('nombreVista','nombreVista','varchar');
						
		//Definicion de la lista del resultado del query
		$this->captura('id_licencia','int4');
		$this->captura('id_tipo_licencia','int4');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('desde','date');
		$this->captura('motivo','text');
		$this->captura('hasta','date');
		$this->captura('id_funcionario','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_tipo_lic','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('nro_tramite','varchar');
        $this->captura('desc_funcionario1','varchar');//#114

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarLicencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_licencia_ime';
		$this->transaccion='PLA_LICE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_licencia','id_tipo_licencia','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desde','desde','date');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarLicencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_licencia_ime';
		$this->transaccion='PLA_LICE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_licencia','id_licencia','int4');
		$this->setParametro('id_tipo_licencia','id_tipo_licencia','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desde','desde','date');
		$this->setParametro('motivo','motivo','text');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarLicencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.ft_licencia_ime';
		$this->transaccion='PLA_LICE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_licencia','id_licencia','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'plani.ft_licencia_ime';
        $this->transaccion = 'PLA_SIGELICE_INS';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_licencia','id_licencia','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');		
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        $this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_licencia_ime';
        $this->transaccion='PLA_ANTELICE_IME';
        $this->tipo_procedimiento='IME';                
        //Define los parametros para la funcion
         $this->setParametro('id_licencia','id_licencia','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');		
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>