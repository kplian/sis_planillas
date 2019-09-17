<?php
/***
 Nombre: ACTFuncionarioPlanillaReporte.php
 Proposito: Clase de Control para recibir los parametros enviados por los archivos
 de la Vista para envio y ejecucion de los metodos del Modelo referidas a la tabla tfuncionario 
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
 #41	etr				16.09.2091			MZM					ADICION DE TIPO CONTRATO A FILTRO EN RESERVAS  
 */
require_once(dirname(__FILE__).'/../reportes/RAntiguedadFuncionarioPDF.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaEmpleado.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaGenericaTrib.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaAportes.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaPersonal.php');
require_once(dirname(__FILE__).'/../reportes/REmpleadoDep.php');
require_once(dirname(__FILE__).'/../reportes/RPlanillaCurvaXls.php');
class ACTFuncionarioReporte extends ACTbase{    

	function listarFuncionarioReporte(){

	
       
        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res=$this->objFunc->listarFuncionarioReporte($this->objParam);
		
		
        //obtener titulo del reporte
        $titulo = $this->objParam->getParametro('tipo_reporte');
		$fecha=$this->objParam->getParametro('fecha');
		$rango_ini=$this->objParam->getParametro('rango_inicio');
		$rango_fin=$this->objParam->getParametro('rango_fin');
		$id_afp=$this->objParam->getParametro('id_afp');
		$id_gestion=$this->objParam->getParametro('id_gestion');
		//03.09.2019
		$id_tipo_contrato=$this->objParam->getParametro('id_tipo_contrato');
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);


        //obtener tamaño y orientacion
       
        $tamano = 'LETTER';
        $orientacion = 'P';
       if($this->objParam->getParametro('tipo_reporte')=='aporte_afp'){
       	$orientacion = 'L';
       } 

        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('rango_ini',$rango_ini);
		$this->objParam->addParametro('rango_fin',$rango_fin);
		//para aportes
		$this->objParam->addParametro('id_afp',$id_afp);
		$this->objParam->addParametro('id_gestion',$id_gestion);
		
		$this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);
		
       
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            //Instancia la clase de pdf
           
        if($this->objParam->getParametro('tipo_reporte')=='empleado_antiguedad' ||  $this->objParam->getParametro('tipo_reporte')=='empleado_edad' ){   
            $this->objReporteFormato=new RAntiguedadFuncionarioPDF($this->objParam);

			$this->objReporteFormato->setDatos($this->res->datos);
			$this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
 
			$this->mensajeExito=new Mensaje();
        	$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
	        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
	        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	


		}
		else{
			if($this->objParam->getParametro('tipo_reporte')=='planilla_tributaria' ){
				$this->reportePlanillaTrib($titulo,$fecha); //nomina salarios BC, CT
				   
			}else{
				if($this->objParam->getParametro('tipo_reporte')=='aporte_afp' || $this->objParam->getParametro('tipo_reporte')=='fondo_solidario' ){ 
					$this->reportePlanillaAFP($titulo,$fecha,$id_afp,$id_tipo_contrato ); //nomina salarios BC, CT
				}else{
					if($this->objParam->getParametro('tipo_reporte')=='personal_ret' || $this->objParam->getParametro('tipo_reporte')=='personal_inc' ){
						$this->reportePlanillaPersonal($titulo,$id_gestion); //nomina salarios BC, CT
					}else{
						if($this->objParam->getParametro('tipo_reporte')=='planilla_tributaria'){
							$this->reportePlanillaTrib($titulo,$fecha);
						}else{
							if($this->objParam->getParametro('tipo_reporte')=='dependientes' || $this->objParam->getParametro('tipo_reporte')=='dependientes_edad' ){
								$this->reportePlanillaDep($titulo,$fecha);
							}else{
								if($this->objParam->getParametro('tipo_reporte')=='curva_salarial'  ){
									$this->reporteCurvaSalarial($titulo,$fecha);
								}else{
									$this->reportePlanilla($titulo,$fecha,$id_tipo_contrato); //nomina salarios BC, CT
								}
								
								
							}
							
							
						}
					} 
					
				}
				 
			}
		}
			
	}
	
	
	function reportePlanilla($tipo_reporte,$fecha,$id_tipo_contrato)	{

        $this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosReporteDetalle($this->objParam);
        

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$this->objParam->addParametro('id_tipo_contrato',$id_tipo_contrato);

        
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            
           	$this->objReporteFormato=new RPlanillaEmpleado($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
	
	
	function reportePlanillaAFP($tipo_reporte,$fecha,$id_afp,$id_tipo_contrato)	{

        $this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosAportes($this->objParam);
        

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$this->objParam->addParametro('id_afp',$id_afp);
        $this->objParam->addParametro('orientacion','L');
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            
           	$this->objReporteFormato=new RPlanillaAportes($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
	
	
	
	function reportePlanillaPersonal($tipo_reporte,$id_gestion)	{

        $this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosPersonal($this->objParam);
        

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$this->objParam->addParametro('id_gestion',$id_gestion);
        $this->objParam->addParametro('orientacion','L');
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            
           	$this->objReporteFormato=new RPlanillaPersonal($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
	
	function reportePlanillaTrib($tipo_reporte,$fecha)	{
		
	    $this->objParam->addFiltro("(repo.titulo_reporte ilike ''%tributaria%''
		)
		
		and plani.id_periodo =(select po_id_periodo from param.f_get_periodo_gestion(''".$fecha."''))
		
		");
 		$this->objFunc=$this->create('MODReporte');
		$this->res=$this->objFunc->listarReporteMaestro($this->objParam);

        $this->objFunc=$this->create('MODFuncionarioReporte');
        $this->res2=$this->objFunc->listarDatosPlaniTrib($this->objParam);
		
		$titulo = $this->res->datos[0]['titulo_reporte'];
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);

        $tamano = 'LEGAL';
        $orientacion = 'L';
       

        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
		$nombreArchivo.='.pdf';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            

		$this->objReporteFormato=new RPlanillaGenericaTrib($this->objParam);

        $this->objReporteFormato->datosHeader($this->res->datos[0], $this->res2->datos);
            //$this->objReporteFormato->renderDatos($this->res2->datos);
        $this->objReporteFormato->gerencia = $this->res2->datos[0]['gerencia'];
        $this->objReporteFormato->generarReporte();
        $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }



function reportePlanillaDep($tipo_reporte,$fecha)	{

        $this->objFunc=$this->create('MODFuncionarioReporte');

        
        $this->res=$this->objFunc->listarDatosReporteDep($this->objParam);
        

        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()));

 		$this->objParam->addParametro('fecha',$fecha);
		$this->objParam->addParametro('tipo_reporte',$tipo_reporte);

        
            $nombreArchivo.='.pdf';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            
           	$this->objReporteFormato=new REmpleadoDep($this->objParam);
            $this->objReporteFormato->setDatos($this->res->datos);
            $this->objReporteFormato->generarReporte();
            $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        





        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }




		function reporteCurvaSalarial($tipo_reporte,$fecha)	{

	        $this->objFunc=$this->create('MODFuncionarioReporte');
	
	        
	        $this->res=$this->objFunc->listarDatosCurva($this->objParam);
        

        	//Genera el nombre del archivo (aleatorio + titulo)
        	/*$nombreArchivo=uniqid(md5(session_id()));

 			$this->objParam->addParametro('fecha',$fecha);
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
			$this->objParam->addParametro('datos',$this->res->datos);
        	$this->objParam->addParametro('titulo_archivo','titulo');
			$nombreArchivo.='.xls';
            			
            $this->objReporteFormato=new RPlanillaCurvaXls($this->objParam);
			$this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte();*/
			
			
			
			 $titulo ='Curva Salarial';
        //Genera el nombre del archivo (aleatorio + titulo)
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
			$nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			
            $this->objParam->addParametro('titulo_archivo',$titulo);
            $this->objParam->addParametro('datos',$this->res->datos);
			$this->objParam->addParametro('fecha',$fecha);
			$this->objParam->addParametro('tipo_reporte',$tipo_reporte);
            //Instancia la clase de excel
            $this->objReporteFormato=new RPlanillaCurvaXls($this->objParam);
           // $this->objReporteFormato->imprimeDatos();
            $this->objReporteFormato->generarReporte(); 
			

	        $this->mensajeExito=new Mensaje();
	        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
	            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
	        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
	        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

}

?>