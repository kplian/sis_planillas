<?php
/***
 Nombre: 	MODFuncionarioPlanillaReporte.php
 Proposito: Clase de Modelo, que contiene la definicion y llamada a funciones especificas relacionadas 
 a la tabla tfuncionario del esquema RHUM
 Autor:		Kplian
 Fecha:		04/06/2011
 * 
 *  HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION  
  #16           04/07/2019         	  EGS                 	creacion
 */
class MODFuncionarioPlanillaReporte extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
		
	}
	
	function listarFuncionarioPlanillaReporte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.f_reporte_funcionario_planilla_sel';// nombre procedimiento almacenado
		$this->transaccion='PLA_REFUPL_SEL';//nombre de la transaccion
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('id_gestion','id_gestion','integer');	 
		$this->setParametro('id_periodo','id_periodo','integer');
		$this->setParametro('groupBy','groupBy','varchar');	 
		$this->setParametro('groupDir','groupDir','varchar'); 
			
		
		//Definicion de la lista del resultado del query
	
		//defino varialbes que se captran como retornod e la funcion
		
         $this->captura('id_funcionario','integer');
         $this->captura('ci','varchar');
         $this->captura('codigo','varchar');
         $this->captura('desc_funcionario1','text');
         $this->captura('desc_funcionario2','text');
         $this->captura('num_doc','integer');
         $this->captura('fecha_asignacion','date');
         $this->captura('fecha_finalizacion','date');                                                                                       
         $this->captura('id_cargo','integer');
         $this->captura('codigo_cargo','varchar');
         $this->captura('nombre_cargo','varchar');
         $this->captura('observaciones_finalizacion','varchar');
         $this->captura('nro_documento_asignacion','varchar');
         $this->captura('fecha_documento_asignacion','date');
         $this->captura('tipo','varchar');
         $this->captura('text','text');                             
         $this->captura('id_uo_funcionario','integer');
         $this->captura('id_uo','integer');
         $this->captura('nombre_lugar','varchar');
         $this->captura('codigo_gerencia','varchar');
         $this->captura('nombre_unidad_gerencia','varchar');
         $this->captura('codigo_uo_pre','varchar');
         $this->captura('nombre_uo_pre','varchar');
         $this->captura('codigo_uo_centro','varchar');
         $this->captura('nombre_uo_centro','varchar');
         $this->captura('firma','text');
         $this->captura('interno','varchar');
         $this->captura('id_biometrico','integer');
         $this->captura('email_empresa','varchar');
         $this->captura('telefono_ofi','varchar');
         $this->captura('codigo_rciva','varchar');
         $this->captura('profesion','varchar');
         $this->captura('id_afp','integer');
         $this->captura('nombre_afp','varchar');
         $this->captura('nro_afp','varchar');
         $this->captura('tipo_jubilado','varchar');
         $this->captura('edad','integer');
         $this->captura('carnet_discapacitado','varchar');
         $this->captura('celular_personal','varchar');
         $this->captura('correo_personal','varchar');
         $this->captura('estado_civil','varchar');
         $this->captura('expedicion','varchar');
         $this->captura('genero','varchar');
         $this->captura('direccion','varchar');
         $this->captura('fecha_nacimiento','date');
         $this->captura('ano_nacimiento','integer');
         $this->captura('mes_nacimiento','varchar');
         $this->captura('estado_reg','varchar'); 
         $this->captura('fecha_reg','timestamp');
         $this->captura('fecha_mod','timestamp');
         $this->captura('id_usuario_reg','integer');
         $this->captura('id_usuario_mod','integer');
		 $this->captura('uo_centro_orden','numeric');		 
		 $this->captura('codigo_tipo_contrato','varchar');	
		 $this->captura('nombre_tipo_contrato','varchar');	
		 $this->captura('tipo_asignacion','varchar');
		 
		 		
		//Ejecuta la funcion
		$this->armarConsulta();		
		//echo $this->getConsulta(); exit;
		$this->ejecutarConsulta();
		
		//var_dump('hola',$this->respuesta);exit;
		
		return $this->respuesta;

	}
}
?>
