<?php
/**
*@package pXP
*@file gen-MODReporte.php
*@author  (admin)
*@date 17-01-2014 22:07:28
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * #32    etr            MZM        02.09.2019    Adicion de relacion id_pie_firma y funcion para listar firmas por tipo de reporte
 * #60    etr            MZM        08.10.2019    Adicion de campo incluir_retirados
 * #65    ETR            MZM        10.10.2019    Adicion de 2 campos para q en reportes de listado solo se muestren los q tengan valor diferente a 0
 * #71    ETR            MZM        31.10.2019    Refactorizacion de campo periodo cuando son anuales, obteniendo el periodo en funcion a la fecha de planilla
 * #77    ETR            MZM        14.11.2019    Interlineado y bordes de reporte
 * #80    ETR            MZM        22.11.2019    Reportes bono/desc
 * #83    ETR            MZM        09.12.2019    Habilitacion de reporte para backup de planilla
 * #98    ETR            MZM        03.03.2020    Adicion de opciones estado_funcionario (activo, retirado, todos)
 * #103   ETR            RAC        02/04/2020    Listado de funcionario toda sin contador para envo de boletas de pago

**/

class MODReporte extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarReporte(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REPO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_reporte','int4');
        $this->captura('id_tipo_planilla','int4');
        $this->captura('numerar','varchar');
        $this->captura('hoja_posicion','varchar');
        $this->captura('mostrar_nombre','varchar');
        $this->captura('mostrar_codigo_empleado','varchar');
        $this->captura('mostrar_doc_id','varchar');
        $this->captura('mostrar_codigo_cargo','varchar');
        $this->captura('agrupar_por','varchar');
        $this->captura('ordenar_por','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('ancho_utilizado','int4');
        $this->captura('ancho_total','int4');
        $this->captura('titulo_reporte','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('control_reporte','varchar');
        $this->captura('tipo_reporte','varchar');
        $this->captura('multilinea','varchar');
        $this->captura('vista_datos_externos','varchar');
        $this->captura('num_columna_multilinea','integer');
        //#32 - 30.08.2019
        $this->captura('id_pie_reporte','integer');
        $this->captura('nombre','varchar');

        $this->captura('mostrar_ufv','varchar');//#58
        $this->captura('incluir_retirados','varchar');//#60
        //#65
        $this->captura('id_moneda_reporte','integer');//#65
        $this->captura('codigo','varchar');//#65

        $this->captura('bordes','integer');//#77
        $this->captura('interlineado','numeric');//#77
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_reporte_ime';
        $this->transaccion='PLA_REPO_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
        $this->setParametro('numerar','numerar','varchar');
        $this->setParametro('hoja_posicion','hoja_posicion','varchar');
        $this->setParametro('mostrar_nombre','mostrar_nombre','varchar');
        $this->setParametro('mostrar_codigo_empleado','mostrar_codigo_empleado','varchar');
        $this->setParametro('mostrar_doc_id','mostrar_doc_id','varchar');
        $this->setParametro('mostrar_codigo_cargo','mostrar_codigo_cargo','varchar');
        $this->setParametro('agrupar_por','agrupar_por','varchar');
        $this->setParametro('ordenar_por','ordenar_por','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('ancho_utilizado','ancho_utilizado','int4');
        $this->setParametro('ancho_total','ancho_total','int4');
        $this->setParametro('titulo_reporte','titulo_reporte','varchar');
        $this->setParametro('control_reporte','control_reporte','varchar');
        $this->setParametro('tipo_reporte','tipo_reporte','varchar');
        $this->setParametro('multilinea','multilinea','varchar');
        $this->setParametro('vista_datos_externos','vista_datos_externos','varchar');
        $this->setParametro('num_columna_multilinea','num_columna_multilinea','integer');
        //#32 - 31.08.2019
        $this->setParametro('id_pie_firma','id_pie_firma','integer');

        $this->setParametro('mostrar_ufv','mostrar_ufv','varchar');//#58
        $this->setParametro('incluir_retirados','incluir_retirados','varchar');//#60
        $this->setParametro('id_moneda_reporte','id_moneda_reporte','integer');//#65

        $this->setParametro('bordes','bordes','integer');//#77
        $this->setParametro('interlineado','interlineado','numeric');//#77
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_reporte_ime';
        $this->transaccion='PLA_REPO_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_reporte','id_reporte','int4');
        $this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
        $this->setParametro('numerar','numerar','varchar');
        $this->setParametro('hoja_posicion','hoja_posicion','varchar');
        $this->setParametro('mostrar_nombre','mostrar_nombre','varchar');
        $this->setParametro('mostrar_codigo_empleado','mostrar_codigo_empleado','varchar');
        $this->setParametro('mostrar_doc_id','mostrar_doc_id','varchar');
        $this->setParametro('mostrar_codigo_cargo','mostrar_codigo_cargo','varchar');
        $this->setParametro('agrupar_por','agrupar_por','varchar');
        $this->setParametro('ordenar_por','ordenar_por','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('ancho_utilizado','ancho_utilizado','int4');
        $this->setParametro('ancho_total','ancho_total','int4');
        $this->setParametro('titulo_reporte','titulo_reporte','varchar');
        $this->setParametro('control_reporte','control_reporte','varchar');
        $this->setParametro('tipo_reporte','tipo_reporte','varchar');
        $this->setParametro('multilinea','multilinea','varchar');
        $this->setParametro('vista_datos_externos','vista_datos_externos','varchar');
        $this->setParametro('num_columna_multilinea','num_columna_multilinea','integer');
        //#32 - 31.08.2019
        $this->setParametro('id_pie_firma','id_pie_firma','integer');
        $this->setParametro('mostrar_ufv','mostrar_ufv','varchar');//#58
        $this->setParametro('incluir_retirados','incluir_retirados','varchar');//#60
        $this->setParametro('id_moneda_reporte','id_moneda_reporte','integer');//#65

        $this->setParametro('bordes','bordes','integer');//#77
        $this->setParametro('interlineado','interlineado','numeric');//#77
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='plani.ft_reporte_ime';
        $this->transaccion='PLA_REPO_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_reporte','id_reporte','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarReporteMaestro(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REPOMAES_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('esquema','esquema','varchar');    //#83
        //#98
        $this->setParametro('estado_funcionario','personal_activo','varchar');//#98
        $this->setParametro('consolidar','consolidar','varchar');//#98
        $this->setParametro('id_periodo','id_periodo','integer');//#98

        //Datos del tipo de reporte
        $this->captura('numerar','varchar');
        $this->captura('hoja_posicion','varchar');
        $this->captura('mostrar_nombre','varchar');
        $this->captura('mostrar_codigo_empleado','varchar');
        $this->captura('mostrar_doc_id','varchar');
        $this->captura('mostrar_codigo_cargo','varchar');
        $this->captura('agrupar_por','varchar');
        $this->captura('ordenar_por','varchar');
        $this->captura('titulo_reporte','varchar');

        //Datos de la planilla
        $this->captura('nro_planilla','varchar');
        $this->captura('periodo','integer');
        $this->captura('gestion','integer');
        $this->captura('uo','varchar');
        $this->captura('depto','varchar');
        $this->captura('cantidad_columnas','integer');

        $this->captura('multilinea','varchar');
        $this->captura('vista_datos_externos','varchar');
        $this->captura('num_columna_multilinea','integer');
        //12.09.2019
        $this->captura('periodo_lite','varchar');
        //#58
        $this->captura('mostrar_ufv','varchar');
        $this->captura('ufv_ini','numeric');
        $this->captura('ufv_fin','numeric');

        $this->captura('tc','numeric');//#65
        $this->captura('cant_columnas_totalizan','integer');//#65
        $this->captura('tipo_reporte','varchar');//#65

        $this->captura('id_pie_firma','integer');//#71

        $this->captura('bordes','integer');//#77
        $this->captura('interlineado','numeric');//#77
        $this->captura('fecha_backup','text');//#83
        //Ejecuta la instruccion
        $this->armarConsulta(); 
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarReportePrevisiones(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REPOPREV_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('fecha','fecha','date');

        //Datos del tipo de reporte
        $this->captura('gerencia','varchar');
        $this->captura('cargo','varchar');
        $this->captura('nombre','text');
        $this->captura('basico','numeric');
        $this->captura('fecha_ingreso','varchar');
        $this->captura('dias_trabajados','integer');
        $this->captura('indem_dia','numeric');
        $this->captura('indem','numeric');
        $this->captura('presupuesto','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarReporteMaestroBoleta(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REPOMAESBOL_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_tipo_planilla','id_tipo_planilla','int4');
        $this->setParametro('id_funcionario_planilla','id_funcionario_planilla','int4');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('tipo_contrato','tipo_contrato','varchar');
        //**************************
        $this->setParametro('tipo_reporte','tipo_reporte','varchar');

        $this->setParametro('esquema','esquema','varchar');//#83
        //#98
        $this->setParametro('consolidar','consolidar','varchar');//#98
        $this->setParametro('id_periodo','id_periodo','integer');//#98

        //Datos del tipo de reporte

        $this->captura('titulo_reporte','varchar');

        //Datos de la planilla
        $this->captura('nro_planilla','varchar');
        $this->captura('periodo','varchar');
        $this->captura('gestion','integer');
        $this->captura('nit','varchar');
        $this->captura('nro_patronal','varchar');
        $this->captura('nombre','varchar');
        $this->captura('cargo','varchar');
        $this->captura('item','varchar');
        $this->captura('codigo_empleado','varchar');
        $this->captura('horas_trabajadas','integer');
        $this->captura('ci','varchar');
        $this->captura('id_funcionario','integer');
        $this->captura('cantidad_columnas','integer');

        $this->captura('multilinea','varchar');
        $this->captura('vista_datos_externos','varchar');
        $this->captura('num_columna_multilinea','integer');

		$this->captura('id_periodo','integer');//#71
		$this->captura('fecha_backup','text');//#83
		//Ejecuta la instruccion
		$this->armarConsulta();		
		//echo "****".$this->getConsulta(); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarReporteDetalle(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_reporte_sel';
		$this->transaccion='PLA_REPODET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('tipo_contrato','tipo_contrato','varchar');	
		$this->setParametro('id_uo','id_uo','integer');
		$this->setParametro('totales','totales','varchar');
		
		$this->setParametro('id_tipo_columna','id_tipo_columna','integer');//#80
		$this->setParametro('esquema','esquema','varchar');//#83
		$this->setParametro('id_afp','id_afp','integer');//#83
		//#98
		$this->setParametro('estado_funcionario','personal_activo','varchar');//#98
		$this->setParametro('consolidar','consolidar','varchar');//#98
		$this->setParametro('id_periodo','id_periodo','integer');//#98
		$this->setParametro('id_gestion','id_gestion','integer');//#98
		//Datos del empleado
		$this->captura('id_funcionario','integer');
		$this->captura('nombre_empleado','text');
		$this->captura('codigo_empleado','varchar');
		$this->captura('codigo_cargo','varchar');
		$this->captura('doc_id','varchar');
		//$this->captura('id_presupuesto','integer');
		$this->captura('id_gerencia','integer');
		$this->captura('gerencia','varchar');
				
		//Datos del tipo_reporte_columna
		$this->captura('sumar_total','varchar');
		$this->captura('ancho_columna','integer');
		$this->captura('titulo_reporte_superior','varchar');	
		$this->captura('titulo_reporte_inferior','varchar');		
		
		//Datos de la columna
		$this->captura('codigo_columna','varchar');	
		$this->captura('valor_columna','varchar');			
		$this->captura('nombre','varchar');
		$this->captura('espacio_previo','integer');
				
		$this->captura('orden','integer');//#80

		//Ejecuta la instruccion
		$this->armarConsulta(); 

		//echo "**REP**".$this->getConsulta(); exit;
		//var_dump($this->aParam->getParametrosConsulta()); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarReporteDetalleBoleta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='plani.ft_reporte_sel';
		$this->transaccion='PLA_REPODETBOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_funcionario','id_funcionario','int4');	
		
		$this->captura('titulo_reporte_superior','varchar');	
		$this->captura('titulo_reporte_inferior','varchar');	
		$this->captura('tipo_columna','varchar');	
		
		//Datos de la columna
		$this->captura('codigo_columna','varchar');	
		$this->captura('valor_columna','numeric');			
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo "****".$this->getConsulta(); exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	function ListarReportePlanillaActualizadaItem(){

        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REPOACIT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        //Datos de la planilla

        $this->setParametro('id_tipo_contrato','id_tipo_contrato','integer');
        $this->setParametro('id_uo','id_uo','integer');
        $this->setParametro('fecha','fecha','date');
        $this->setParametro('agrupar_por','agrupar_por','varchar');



        $this->captura('escala','varchar');
        $this->captura('cargo','varchar');
        $this->captura('nro_item','varchar');
        $this->captura('nombre_funcionario','text');
        $this->captura('genero','varchar');
        $this->captura('haber_basico','numeric');
        $this->captura('bono_antiguedad','numeric');
        $this->captura('bono_frontera','numeric');
        $this->captura('sumatoria','numeric');
        $this->captura('fecha_inicio','text');
        $this->captura('ci','varchar');
        $this->captura('expedicion','varchar');
        $this->captura('codigo','varchar');
        $this->captura('nombre','varchar');
        $this->captura('codigo_nombre_gerencia','varchar');
        $this->captura('nombre_unidad','varchar');
        $this->captura('id_tipo_contrato','integer');
        $this->captura('prioridad_gerencia','varchar');
        $this->captura('gerencia','varchar');
        $this->captura('prioridad_depto','varchar');
        $this->captura('departamento','varchar');
        $this->captura('categoria_programatica','varchar');
        $this->captura('fecha_finalizacion','varchar');
        //$this->captura('nivel','integer');
        //$this->captura('centro_costo','varchar');
        //$this->captura('categoria_codigo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();


        //Devuelve la respuesta
        return $this->respuesta;


    }

    function reporteGeneralPlanilla(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REP_CONTACT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('oficina','oficina','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('gerencia','varchar');
        $this->captura('contrato','varchar');
        $this->captura('desc_funcionario','varchar');
        $this->captura('cargo','varchar');
        $this->captura('lugar','varchar');
        $this->captura('codigo','varchar');
        $this->captura('email_empresa','varchar');
        $this->captura('correo','varchar');
        $this->captura('telefonos','varchar');
        $this->captura('celulares','varchar');
        $this->captura('documento','varchar');
        $this->captura('lugar_trabajo','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reportePresupuestoCatProg(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REP_PRE_CP_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('oficina','oficina','varchar');

        //Definicion de la lista del resultado del query
        /*$this->captura('desc_fun','varchar');
        $this->captura('nombre_cargo','varchar');
        $this->captura('tipo_contrato','varchar');
        $this->captura('categoria_prog','varchar');
        $this->captura('codigo_pres','varchar');
        $this->captura('presupuesto','varchar');*/

        $this->captura('tipo_contrato','varchar');
        $this->captura('categoria_prog','varchar');
        $this->captura('codigo_pres','varchar');
        $this->captura('presupuesto','varchar');
        $this->captura('desc_func','varchar');
        $this->captura('ci','varchar');
        $this->captura('nombre_cargo','varchar');
        $this->captura('fecha_ini','date');
        $this->captura('fecha_fin','date');

        $this->captura('periodo','varchar');
        $this->captura('codigo_columna','varchar');
        $this->captura('valor','numeric');




        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


/****/
function listarReporteDetalleMultiCell(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_REPODETMUL_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('tipo_contrato','tipo_contrato','varchar');
        $this->setParametro('id_uo','id_uo','integer');
        //Datos del empleado
        $this->captura('id_funcionario','integer');
        $this->captura('nombre_empleado','text');
        $this->captura('codigo_empleado','varchar');
        $this->captura('codigo_cargo','varchar');
        $this->captura('doc_id','varchar');
        //$this->captura('id_presupuesto','integer');
        $this->captura('id_gerencia','integer');
        $this->captura('gerencia','varchar');

        //Datos del tipo_reporte_columna
        $this->captura('sumar_total','varchar');
        $this->captura('ancho_columna','integer');
        $this->captura('titulo_reporte_superior','varchar');
        $this->captura('titulo_reporte_inferior','varchar');

        //Datos de la columna
        $this->captura('codigo_columna','varchar');
        $this->captura('valor_columna','varchar');
        $this->captura('nombre','varchar');
        $this->captura('espacio_previo','integer');



        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo "****".$this->getConsulta(); exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

//#32 - 31.08.2019

    function listarFirmasReporte(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='plani.ft_reporte_sel';
        $this->transaccion='PLA_FIRREP_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('esquema','esquema','varchar');//#83

        //Datos del empleado
        $this->captura('nombre_cargo_firma','varchar');
        $this->captura('nombre_empleado_firma','text');
        $this->captura('abreviatura_titulo','varchar');
        $this->captura('orden','integer');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

     function listarFunPlanillaAll() {
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento = 'plani.ft_funcionario_planilla_sel';
        $this->transaccion = 'PLA_FUNPLANALL_SEL';
        $this->tipo_procedimiento = 'SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('id_planilla','id_planilla','integer');
        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario_planilla','int4');
        $this->captura('id_funcionario','int4');
        $this->captura('id_planilla','int4');
        $this->captura('desc_funcionario1','text');
        $this->captura('email_empresa','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
	 
	 
}
?>
