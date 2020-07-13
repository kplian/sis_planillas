<?php
/***
 Nombre: 	MODFuncionarioPlanillaReporte.php
 Proposito: Clase de Modelo, que contiene la definicion y llamada a funciones especificas relacionadas 
 a la tabla tfuncionario del esquema RHUM
 Autor:		Kplian
 Fecha:		04/06/2011
 * 
 *  HISTORIAL DE MODIFICACIONES:
       
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM-KPLIAN          Creacion 
  #41	ETR				16.09.2019			MZM-KPLIAN			ADICION DE FILTRO TIPO_CONTRATO
  #45	ETR				19.09.2019			MZM-KPLIAN			adicion de campo para reporte afp
  #66	ETR				15.10.2019			MZM-KPLIAN			Adicion de filtro id_tipo_contrato en reportes especificos
  #67	ETR				16.10.2019			MZM-KPLIAN			Reporte asignacion de cargos
 *#77	ETR				15.11.2019			MZM-KPLIAN			Ajsutes reportes
 *#81	ETR				25.11.2019			MZM-KPLIAN			Curva salarial jeerarquia por nivel arbol y prioridad
 *#81	ETR				05.12.2019			MZM-KPLIAN			Adicion de campo estado_afp para curva salarial
 *#83	ETR				10.12.2019			MZM-KPLIAN			Habilitacion de opcion historico de planilla
 *#83 	ETR				03.01.2020			MZM-KPLIAN			para DATAPORTE adicion de parametro esquema 
 *#87	ETR				09.01.2020			MZM-KPLIAN			Reporte detalle de aguinaldos	
 *#98	ETR				03.03.2020  		MZM-KPLIAN			Adicion de opciones estado_funcionario (activo, retirado, todos)
 *#119	ETR				23.04.2020			MZM-KPLIAN			Reporte saldo acumulado Rc-Iva
  #123	ETR				06.05.2020			MZM-KPLIAN			Leyenda para planillas que no tienen informacion a exponer (caso planillas regularizadas enero-sep/2019) 
  #125	ETR				14.05.2020			MZM-KPLIAN			Planilla de Primas
  #133  ETR       		03.06.2020          MZM KPLIAN     		Reporte para prevision de primas
  #135	ETR				04.06.2020			MZM-KPLIAN			Reporte de prevision de primas (detalle)
 *#144	ETR				29.06.2020			MZM-KPLIAN
 */
class MODFuncionarioReporte extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
		
	}
	
	function listarFuncionarioReporte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='plani.f_reporte_funcionario_sel';// nombre procedimiento almacenado
		$this->transaccion='PLA_TOTRANGO_SEL';//nombre de la transaccion
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		$this->setParametro('rango_inicio','rango_inicio','integer');
		$this->setParametro('rango_fin','rango_fin','integer');
		$this->setParametro('id_cargo','id_cargo','integer');
		$this->setParametro('id_centro_costo','id_centro_costo','integer');
		$this->setParametro('id_lugar','id_lugar','integer');
		$this->setParametro('genero','genero','varchar');
		$this->setParametro('tipo_agrupacion','tipo_agrupacion','varchar');
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer'); //#66
		
		//#77
		$this->setParametro('id_periodo','id_periodo','integer');
		$this->setParametro('esquema','esquema','varchar'); //#83 
		
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		
		$this->captura('nombre_uo_pre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('fecha_ingreso','date');
		$this->captura('antiguedad_ant','integer');
		 
		$this->captura('antiguedad_anos','integer');
		$this->captura('antiguedad','integer');
		$this->captura('rango','varchar');
		$this->captura('genero','varchar');
		
		 $this->captura('cargo','varchar');
		 $this->captura('fecha_nacimiento','date');
		 $this->captura('edad','integer');
		 
		 $this->captura('fecha_rep','date');//#77
		//Ejecuta la funcion
		$this->armarConsulta();		
		//echo 'listarFuncionarioReporte - '.
		//echo '1:***'.$this->getConsulta(); exit;
		$this->ejecutarConsulta();
		
		//var_dump('hola',$this->respuesta);exit;
		
		return $this->respuesta;

	}

	function listarDatosReporteDetalle(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DATPLAEMP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	//#41
		$this->setParametro('id_periodo','id_periodo','integer');	//#77
		
		$this->setParametro('esquema','esquema','varchar');	//#83
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('nombre_empleado','text');
		$this->captura('codigo_empleado','varchar');
		$this->captura('ci','varchar');
		$this->captura('fecha_ingreso','date');
		$this->captura('codigo_columna','varchar');
		$this->captura('valor','numeric');
		$this->captura('tipo_contrato','varchar');	
		$this->captura('cargo','text');			
		$this->captura('nombre_gerencia','varchar');
		$this->captura('nombre_unidad','varchar');
		$this->captura('orden_centro','numeric');
		$this->captura('periodo','varchar');
		$this->captura('gestion','integer');
		$this->captura('nivel','varchar');
		$this->captura('distrito','varchar');
		$this->captura('expedicion','varchar');
		$this->captura('tc','numeric');
		$this->captura('fecha_quinquenio','date'); 
		$this->captura('anos_quinquenio','integer');
		$this->captura('mes_quinquenio','integer');
		$this->captura('dias_quinquenio','integer');
		
		$this->captura('basico_limite','numeric');
		$this->captura('nivel_limite','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "**2:**".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	
	function listarDatosAportes(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DATAPORTE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_afp','id_afp','integer');	
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');
		$this->setParametro('id_periodo','id_periodo','integer');	//#77	
		$this->setParametro('id_tipo_planilla','id_tipo_planilla','integer');	//#84
		//$this->setParametro('id_reporte','id_reporte','integer');	//#84

		$this->setParametro('esquema','esquema','varchar');	//#83
		//#98
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		$this->setParametro('consolidar','consolidar','varchar');//#98
		
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('apellido_paterno','varchar');
		$this->captura('apellido_materno','varchar');
		$this->captura('primer_nombre','varchar');
		$this->captura('segundo_nombre','varchar');
		$this->captura('num_ci','varchar');
		$this->captura('ci','varchar');
		$this->captura('expedicion','varchar');
		$this->captura('valor','numeric');	
		$this->captura('columna','varchar');			
		$this->captura('edad','integer');
		$this->captura('nro_afp','varchar');
		$this->captura('tipo_jubilado','varchar');
		$this->captura('departamento','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('fecha_ingreso','date');
		$this->captura('fecha_finalizacion','date');
		$this->captura('nombre_afp','varchar');
		$this->captura('id_afp','integer');
		$this->captura('periodo','varchar');
		$this->captura('dias','integer');
		$this->captura('dias_incap','integer');
		$this->captura('var1','numeric');//#45
		$this->captura('var2','numeric');//#45
		$this->captura('var3','numeric');//#45
		
		$this->captura('ncotiz','numeric');//#83
		$this->captura('nvar1','numeric');//#83
		$this->captura('nvar2','numeric');//#83
		$this->captura('nvar3','numeric');//#83
		
		
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "3****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function listarDatosPersonal(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DATPERSON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_gestion','id_gestion','integer');	
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');//#77(20.11.19)
		//Datos del empleado
		$this->captura('desc_funcionario1','text');
		$this->captura('fecha','date');
		$this->captura('observaciones_finalizacion','varchar');
		$this->captura('id_funcionario','integer');
		$this->captura('cargo','varchar');
		$this->captura('centro','varchar');
		$this->captura('valor','numeric');	
		$this->captura('mes','varchar');
		$this->captura('gestion','integer');
		$this->captura('nombre','varchar');	//#77			
		
		
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "**4:**".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


//planilla tributaria

	function listarDatosPlaniTrib(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_PLATRIB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_periodo','id_periodo','integer');	//#77
		$this->setParametro('esquema','esquema','varchar');	//#83
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('apellido_paterno','varchar');
		$this->captura('apellido_materno','varchar');
		$this->captura('nombre','varchar');	
		$this->captura('num_ci','varchar');
		
		$this->captura('periodo','integer');
		$this->captura('gestion','integer');
		$this->captura('codigo_rciva','varchar');
		$this->captura('tipo_documento','varchar');	
		$this->captura('novedad','varchar');	
		$this->captura('valor','numeric');				
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "5****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}



	function listarDatosReporteDep(){
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_INFDEP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	//#66
		$this->setParametro('id_periodo','id_periodo','integer'); //#77
		$this->setParametro('esquema','esquema','varchar'); //#83
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		//Datos del empleado
		if($this->objParam->getParametro('tipo_reporte')=='dependientes'){
			
			$this->captura('id_persona','integer');
			$this->captura('matricula','varchar');
			$this->captura('historia_clinica','varchar');
			$this->captura('codigo','varchar');	
			$this->captura('fecha_nacimiento','date');
			$this->captura('fecha_ingreso','date');
			$this->captura('nombre_funcionario','text');
			$this->captura('relacion','varchar');
			$this->captura('nombre_dep','text');	
			$this->captura('fecha_nacimiento_dep','date');	
			$this->captura('matricula_dep','varchar');
			$this->captura('historia_clinica_dep','varchar');
			$this->captura('edad_dep','integer');
		}else{
			$this->setParametro('rango_inicio','rango_inicio','integer');
			$this->setParametro('rango_fin','rango_fin','integer');
			$this->captura('nombre_funcionario','text');
			$this->captura('fecha_nacimiento_dep','date');
			$this->captura('edad_dep','integer');
			$this->captura('nombre_dep','text');
			$this->captura('genero','varchar');
			$this->captura('distrito','varchar');
			$this->captura('rango','varchar');
			
		}
		 
        
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "6****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}



	function listarDatosCurva(){
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_CURVSAL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');
		$this->setParametro('id_periodo','id_periodo','integer');
		$this->setParametro('esquema','esquema','varchar');//#83
		
		//#98
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		
		//Datos del empleado
		 $this->captura('codigo','varchar');
		 $this->captura('num_documento','varchar');
		 $this->captura('tipo_documento','varchar');
		 $this->captura('expedicion','varchar'); 
		 $this->captura('nro_afp','varchar'); 
		 $this->captura('apellido_paterno','varchar'); 
		 $this->captura('apellido_materno','varchar'); 
		 $this->captura('primer_nombre','varchar');
         $this->captura('segundo_nombre','varchar'); 
         $this->captura('fecha_nacimiento','date'); 
         $this->captura('direccion','varchar'); 
         $this->captura('telefono1','varchar');
         $this->captura('grupo_sanguineo','varchar');
         $this->captura('genero','varchar');
         $this->captura('estado_civil','varchar'); 
         $this->captura('profesion','varchar');
         $this->captura('cargo','varchar');
         $this->captura('fecha_ingreso','date');
         $this->captura('tiempo_contrato','varchar'); 
         $this->captura('nombre_lugar','varchar');
         $this->captura('codigo_centro','varchar');  
         $this->captura('numero_nivel','varchar'); //#81
         $this->captura('nivel_salarial_cargo','varchar'); 
         $this->captura('lugar_pago','varchar');
         $this->captura('nivel_salarial_categoria','varchar');
         $this->captura('basico_limite','numeric');
         $this->captura('fecha_quinquenio','date');
         $this->captura('antiguedad_anterior','integer'); 
         $this->captura('fecha_planilla','date');
         $this->captura('fecha_retiro','date');
         $this->captura('motivo_retiro','varchar');
		 $this->captura('fecha_ingreso_ctto1','date');
		 $this->captura('fecha_retiro_ctto1','date');
		 $this->captura('fecha_ingreso_ctto2','date');
		 $this->captura('fecha_retiro_ctto2','date');
		 $this->captura('estado','varchar');
		 $this->captura('sueldo_mes','numeric');
		 $this->captura('cotizable','numeric');
		 $this->captura('liquido','numeric');
		 $this->captura('disponibilidad','numeric');
		 $this->captura('prenatal','numeric'); 
		 $this->captura('lactancia','numeric'); 
		 $this->captura('natalidad','numeric'); 
		 $this->captura('total_ganado','numeric');
		 $this->captura('total_descuentos','numeric'); 
		 $this->captura('total_gral','numeric');
         $this->captura('celular1','varchar'); 
         $this->captura('nro_cuenta','varchar'); 
         $this->captura('banco','varchar'); 
		 
		 $this->captura('bonofrontera','numeric'); 
		 $this->captura('horext','numeric'); 
		 $this->captura('extra','numeric'); 
		 $this->captura('hornoc','numeric'); 
		 $this->captura('nocturno','numeric'); 
		 $this->captura('suelmes','numeric'); 
		 $this->captura('asigtra','numeric'); 
		 $this->captura('asigtra_it','numeric'); 
		 $this->captura('asigesp','numeric'); 
		 $this->captura('asigesp_it','numeric'); 
		 $this->captura('asigcaja','numeric'); 
		 $this->captura('asigcaja_it','numeric');          
		 $this->captura('asignaciones','numeric');
		 $this->captura('nombre_afp','varchar'); 		
		 
		 ////////
		 $this->captura('afp_sso','numeric');
		 $this->captura('afp_rcom','numeric');
		 $this->captura('afp_cadm','numeric');
		
		 $this->captura('afp_apnal','numeric');
		 $this->captura('afp_apsol','numeric');//#81
		 $this->captura('nombre_centro','varchar'); 	
		 $this->captura('orden_centro','numeric'); 	 		  
		 $this->captura('bonant','numeric');
		 $this->captura('estado_afp','varchar');  	//#81
		 $this->captura('fecha_backup','text');//#83
		 $this->armarConsulta(); 		   
        //Ejecuta la instruccion
        //echo '77----'.$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
		
	}
	
	//#67
	
	function listarRepAsignacionCargos(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_ASIGCAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_gestion','id_gestion','integer');
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	
		
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('codigo','varchar');
		$this->captura('fecha_finalizacion','date');
		$this->captura('desc_funcionario2','text');	
		$this->captura('cargo','varchar');
		$this->captura('nuevo_cargo','varchar');
		$this->captura('gestion','integer');
		$this->captura('unidad','varchar');
		$this->captura('nueva_unidad','varchar');
						
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "7****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function listarFrecuenciaCargos(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_FRECCAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_periodo','id_periodo','integer'); //#77
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	
		$this->setParametro('esquema','esquema','varchar');//#83
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		//Datos del empleado
		
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('total_femenino','integer');	
		$this->captura('total_masculino','integer');
						
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "8****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function listarCargosRep(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_LISTCAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_periodo','id_periodo','integer'); //#77
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	
		$this->setParametro('esquema','esquema','varchar');//#83
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		//Datos del empleado
		
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
								
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "9****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	function listarProfesiones(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_CLASIFPROF_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		//$this->setParametro('id_gestion','id_gestion','integer');
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	
		$this->setParametro('esquema','esquema','varchar');//#83
		
		$this->setParametro('id_periodo','id_periodo','integer'); //#77
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		//Datos del empleado
		
		$this->captura('profesion','varchar');
		$this->captura('codigo','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('periodo_lite','varchar');
								
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "10****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function listarDirectorioEmpleados(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DIREMP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_periodo','id_periodo','integer');//#77
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	
		$this->setParametro('esquema','esquema','varchar');//#83
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		//Datos del empleado
		
		$this->captura('nombre_oficina','varchar');
		$this->captura('codigo_funcionario','varchar');
		$this->captura('desc_funcionario2','text');
		$this->captura('nombre_cargo','varchar');
		$this->captura('telefono1','varchar');
		$this->captura('celular_personal','varchar');
		$this->captura('correo_personal','varchar');
		$this->captura('direccion','varchar');
		$this->captura('nombre_uo_centro','varchar');
		$this->captura('ano','integer');
		$this->captura('mes','integer');
		$this->captura('dia','integer');
		
		$this->captura('periodo_lite','varchar');
		$this->captura('mes_lite','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "11****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarFrecuenciaProfesiones(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_FRECPROF_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_periodo','id_periodo','integer'); //#77
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	
		
		//Datos del empleado
		
		
		$this->captura('nombre','varchar');
		$this->captura('total_femenino','integer');	
		$this->captura('total_masculino','integer');
						
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "12****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	function listarDetalleBonoDesc(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DETBONDESC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');	
		
		//Datos del empleado
		
		$this->captura('id_funcionario','integer');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('codigo_columna','varchar');
		$this->captura('nombre_columna','varchar');
		$this->captura('valor','numeric');	
		$this->captura('fecha_ini','date');
		$this->captura('fecha_fin','date');
						
		//Ejecuta la instruccion
		$this->armarConsulta(); //echo "13****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	//#87
	function listarDetalleAguinaldo(){
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_DETAGUIN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('fecha','fecha','date');	
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');
		$this->setParametro('id_gestion','id_gestion','integer');
		$this->setParametro('esquema','esquema','varchar');//#83
		//Datos del empleado
		
		$this->captura('id_funcionario','integer');
            	$this->captura('tipo_documento','varchar');
                $this->captura('num_documento','varchar'); 
                $this->captura('expedicion','varchar'); 
                $this->captura('fecha_nacimiento','date');
                $this->captura('paterno','varchar');
                $this->captura('materno','varchar');
                $this->captura('nombre','varchar');
                $this->captura('nacionalidad','varchar');
                $this->captura('genero','varchar');
                $this->captura('jubilado','varchar');
                $this->captura('aporta_afp','varchar');
                $this->captura('persona_discapacidad','varchar');
                $this->captura('tutor_discapacidad','varchar');
                $this->captura('fecha_ingreso','date');
                $this->captura('fecha_retiro','date');
                $this->captura('motivo_retiro','varchar');
                $this->captura('caja_salud','varchar');
                $this->captura('nombre_afp','varchar');
                $this->captura('nro_afp','varchar');
                $this->captura('sucursal','varchar');
                $this->captura('clasificacion_laboral','varchar');
                $this->captura('cargo','varchar');
                $this->captura('modalidad_ctto','varchar');
                $this->captura('haber_basico','numeric');
                $this->captura('bono_ant','numeric');
                $this->captura('bono_prod','numeric');
                $this->captura('bono_frontera','numeric');
                $this->captura('extra_noct','numeric');
                $this->captura('otros','numeric');
                $this->captura('meses','numeric');
				$this->captura('gestion','integer');
		
		 $this->armarConsulta(); 		   
        //Ejecuta la instruccion
        
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
		
	}

	//#119
	function listarSaldoAcumuladoRcIva(){
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_SALDO_FISCO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');	
		$this->setParametro('id_periodo','id_periodo','integer');	
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');
		$this->setParametro('esquema','esquema','varchar');//#83
		//Datos del empleado
		
		$this->captura('desc_funcionario','text');
                $this->captura('cargo','varchar'); 
                $this->captura('fecha_primer_contrato','date'); 
                $this->captura('fecha_quinquenio','date');
				$this->captura('fecha_finalizacion','date');
                $this->captura('observaciones_fin','varchar');
                $this->captura('sueldo_neto','numeric');
                $this->captura('acumulado','numeric');
				$this->captura('periodo','varchar');
				$this->captura('saldo_dep','numeric');
		 $this->armarConsulta(); 		   
		 //echo '***15'.$this->getConsulta(); exit;
        //Ejecuta la instruccion
     
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
		
	}

///
		function listarPlanillaPrima(){ 
			$this->procedimiento='plani.f_reporte_funcionario_sel';
			$this->transaccion='PLA_PRIMA_SEL';
			$this->tipo_procedimiento='SEL';//tipo de transaccion
			$this->setCount(false);
			
			$this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');
			$this->setParametro('esquema','esquema','varchar');
			$this->setParametro('id_tipo_planilla','id_tipo_planilla','integer');
			
			
			if($this->objParam->getParametro('codigo_planilla')=='PLAPREPRI' || $this->objParam->getParametro('codigo_planilla')=='SPLAPREPRI'){//#145
				$this->setParametro('estado','estado','varchar');
			}
			
			
			//Datos del empleado
			$this->captura('id_funcionario','integer');
			$this->captura('desc_funcionario','text');
			$this->captura('codigo','text');
            $this->captura('id_oficina','integer'); 
            $this->captura('desc_oficina','text'); 
            $this->captura('nombre','varchar');
			$this->captura('codigo_columna','varchar');
            $this->captura('valor','numeric');
            $this->captura('ctto1','text');
            $this->captura('ctto2','text');
			$this->captura('cargo','varchar');
			$this->captura('gestion','integer');
			$this->captura('obs_fin','varchar');
			$this->captura('es_vigente','boolean');	//#135	
		 	$this->armarConsulta(); 		   
		
        //Ejecuta la instruccion
//echo "****".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		 
		//Devuelve la respuesta
		return $this->respuesta;
		
	}


//#133
	 function listarResumenPrevision(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_REPPREVIS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		
		$this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');	//#83
		$this->setParametro('id_gestion','id_gestion','integer');//#98	
		//Datos de la planilla
		$this->captura('nombre','varchar');
		$this->captura('importe','numeric');
		$this->captura('periodo','text');
		$this->captura('banco','varchar');
		$this->captura('tipo_pago','text');
		$this->captura('tipo_contrato','varchar');
		$this->captura('total','bigint');
		//Ejecuta la instruccion
		$this->armarConsulta();		
	//echo "****".$this->getConsulta(); exit;

		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	 
	 function listarIngresoEgreso(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.f_reporte_funcionario_sel';
		$this->transaccion='PLA_INGEGR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('nombre_empleado','text');
		$this->captura('codigo_empleado','text');
		$this->captura('doc_id','varchar');
		$this->captura('titulo_reporte_superior','varchar');	
		$this->captura('titulo_reporte_inferior','varchar');		
		$this->captura('primer_contrato','date');	
		$this->captura('nivel','varchar');			
		$this->captura('afp','varchar');
		$this->captura('cod_columna','varchar');
		$this->captura('valor','numeric');
		$this->captura('tipo_movimiento','varchar');
		$this->captura('nombre_cargo','varchar');
		$this->captura('jubilado','varchar');
		$this->captura('periodo','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta(); 
		
		 //echo "**REP**".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	 

}
?>
