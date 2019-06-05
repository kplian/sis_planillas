<?php
/**
*@package pXP
*@file ACTExportarPlantilla.php
*@author  (EGS)
*@date
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*  ISSUE		FECHA    		AUTOR			DESCRIPCION
*	#9			22/05/2019		EGS				creacion 
 * #11   endeetr    05/06/2019       EGS              actualizaciones de registros activos
 */

class ACTExportarPlantilla extends ACTbase{    
			
	function exportarDatosTipoPlanilla(){
		
		
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFunProcesoMacro=$this->create('MODExportarPlantilla');		
		
		$this->res = $this->objFunProcesoMacro->exportarDatosTipoPlanilla();
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		
		$objFunProcesoMacro2=$this->create('MODExportarPlantilla');		
		$this->res2 = $objFunProcesoMacro2->exportarDatosTipoObligacion();
		//var_dump($this->res2);
		
		$nombreArchivo = $this->crearArchivoExportacionTipoPlanilla($this->res,$this->res2);
					
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
										'Se genero con exito el sql'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	
	function crearArchivoExportacionTipoPlanilla($res,$res2) {
		$data = $res -> getDatos();
		$dataObligacion = $res2 -> getDatos();
		$fileName = uniqid(md5(session_id()).'PlantillaTipoPlanilla').'.sql';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		
		$sw_gui = 0;
		$sw_funciones=0;
		$sw_procedimiento=0;
		$sw_rol=0; 
		$sw_rol_pro=0;
		fwrite ($file,"----------------------------------\r\n".
						  "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
						  
						  "--Configuracion Tipo Planilla \n---------------------------------\r\n".
						  "\r\n" );
		foreach ($data as $row) {			
			 if ($row['tipo_reg'] == 'maestro' ) {
			 	
				if ($row['estado_reg'] == 'activo') {
					fwrite ($file, 					
					"select plani.f_import_ttipo_planilla ('insert','".
								$row['codigo']."'," .
						     (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
							 (is_null($row['codigo_proceso_macro'])?'NULL':"'".$row['codigo_proceso_macro']."'") ."," .
							 (is_null($row['funcion_obtener_empleados'])?'NULL':"'".$row['funcion_obtener_empleados']."'") ."," .
							 (is_null($row['tipo_presu_cc'])?'NULL':"'".$row['tipo_presu_cc']."'") ."," .							 
							 (is_null($row['funcion_validacion_nuevo_empleado'])?'NULL':"'".$row['funcion_validacion_nuevo_empleado']."'") ."," .							 
							 (is_null($row['calculo_horas'])?'NULL':"'".$row['calculo_horas']."'") ."," .							 
							 (is_null($row['periodicidad'])?'NULL':"'".$row['periodicidad']."'") ."," .							 
							 (is_null($row['funcion_calculo_horas'])?'NULL':"'".$row['funcion_calculo_horas']."'") ."," .							 
							 (is_null($row['recalcular_desde'])?'NULL':"'".$row['recalcular_desde']."'") ."," .							 							 
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'").");\r\n");	
					
							
				} /*else {
					fwrite ($file, 

				"select plani.f_import_ttipo_planilla ('delete','".							 
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL);\r\n");
							 
							 	
				}*/
			 } else if ($row['tipo_reg'] == 'detalle') {
				if ($row['estado_reg'] == 'activo') {
					
					fwrite ($file, 
					 "select plani.f_import_ttipo_columna_planilla ('insert',".
							 (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
							 (is_null($row['codigo_tipo_pla'])?'NULL':"'".$row['codigo_tipo_pla']."'") ."," .
							 (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
							 (is_null($row['tipo_dato'])?'NULL':"'".$row['tipo_dato']."'") ."," .
							 (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .
							 (is_null($row['formula'])?'NULL':"'".$row['formula']."'") ."," .
							 (is_null($row['compromete'])?'NULL':"'".$row['compromete']."'") ."," .
							 (is_null($row['tipo_descuento_bono'])?'NULL':"'".$row['tipo_descuento_bono']."'") ."," .
							 (is_null($row['decimales_redondeo'])?'NULL':"'".$row['decimales_redondeo']."'") ."," .
							 (is_null($row['orden'])?'NULL':"'".$row['orden']."'") ."," .
							 (is_null($row['finiquito'])?'NULL':"'".$row['finiquito']."'") ."," .	
							 (is_null($row['tiene_detalle'])?'NULL':"'".$row['tiene_detalle']."'") ."," .	
							 (is_null($row['recalcular'])?'NULL':"'".$row['recalcular']."'") ."," .
							 (is_null($row['editable'])?'NULL':"'".$row['editable']."'") ."," .		// --#11						 							 							 								 								 							 							 	
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") .");\r\n");
						
				
	
				} /*else {
					
						fwrite ($file, 
					"select plani.f_import_ttipo_columna_planilla ('delete','".							 
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL);\r\n");	
			
							 						
				}*/
			} 
         } //end for
         
         fwrite ($file,"----------------------------------\r\n".
						  "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
						  "--Configuracion Tipo Obligacion\n---------------------------------\r\n".
						  "\r\n" );
         
         
         foreach ($dataObligacion as $row) {			
			 if ($row['tipo_reg'] == 'maestro_tipo_obli' ) {
			 	
				if ($row['estado_reg'] == 'activo') {
					fwrite ($file, 					
					"select plani.f_import_ttipo_obligacion('insert','".
								$row['codigo']."'," .
							 (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .							
						     (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
							 (is_null($row['tipo_obligacion'])?'NULL':"'".$row['tipo_obligacion']."'") ."," .
							 (is_null($row['dividir_por_lugar'])?'NULL':"'".$row['dividir_por_lugar']."'") ."," .							 
							 (is_null($row['es_pagable'])?'NULL':"'".$row['es_pagable']."'") ."," .							 
							 (is_null($row['codigo_tipo_obligacion_agrupador'])?'NULL':"'".$row['codigo_tipo_obligacion_agrupador']."'") ."," .							 
							 (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .							 
							 (is_null($row['codigo_tipo_relacion_debe'])?'NULL':"'".$row['codigo_tipo_relacion_debe']."'") ."," .							 
							 (is_null($row['codigo_tipo_relacion_haber'])?'NULL':"'".$row['codigo_tipo_relacion_haber']."'") ."," .							 							 
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'").");\r\n");	
							
							
				} /*else {
					fwrite ($file, 

				"select plani.f_import_ttipo_planilla ('delete','".							 
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL);\r\n");
							 
							 	
				}*/
			 } else if ($row['tipo_reg'] == 'detalle_tipo_obli_colum') {
				if ($row['estado_reg'] == 'activo') {
					
					fwrite ($file, 
					 "select plani.f_import_ttipo_obligacion_columna('insert',".
							 (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
							 (is_null($row['codigo_tipo_obligacion'])?'NULL':"'".$row['codigo_tipo_obligacion']."'") ."," .
							 (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
							 (is_null($row['pago'])?'NULL':"'".$row['pago']."'") ."," .
							 (is_null($row['presupuesto'])?'NULL':"'".$row['presupuesto']."'") ."," .
							 (is_null($row['es_ultimo'])?'NULL':"'".$row['es_ultimo']."'") ."," .							 							 							 	
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") .");\r\n");
			
	
				} /*else {
					
						fwrite ($file, 
					"select plani.f_import_ttipo_columna_planilla ('delete','".							 
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL);\r\n");	
			
							 						
				}*/
			} 
         } //end for
		
		
		return $fileName;
	}
	///Se creo la logica para crear exportador de plantilla de tipo de obligacion separado del exportador tipo de planilla solo falta agregar el boton y 
	//mandara la id_tipo_obligacion como parametro desde la vista
	function exportarDatosTipoObligacion(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFunProcesoMacro=$this->create('MODExportarPlantilla');		
		
		$this->res = $this->objFunProcesoMacro->exportarDatosTipoObligacion();
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacionTipoObligacion($this->res);
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
										'Se genero con exito el sql'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	function crearArchivoExportacionTipoObligacion($res) {
		$data = $res -> getDatos();
		//var_dump($data);
		$fileName = uniqid(md5(session_id()).'PlantillaTipoObligacion').'.sql';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		
		$sw_gui = 0;
		$sw_funciones=0;
		$sw_procedimiento=0;
		$sw_rol=0; 
		$sw_rol_pro=0;
		fwrite ($file,"----------------------------------\r\n".
						  "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
						  "---------------------------------\r\n".
						  "\r\n" );
		foreach ($data as $row) {			
			  if ($row['tipo_reg'] == 'maestro_tipo_obli' ) {
			 	
				if ($row['estado_reg'] == 'activo') {
					fwrite ($file, 					
					"select plani.f_import_ttipo_obligacion('insert','".
								$row['codigo']."'," .
							 (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
						     (is_null($row['nombre'])?'NULL':"'".$row['nombre']."'") ."," .
							 (is_null($row['tipo_obligacion'])?'NULL':"'".$row['tipo_obligacion']."'") ."," .
							 (is_null($row['dividir_por_lugar'])?'NULL':"'".$row['dividir_por_lugar']."'") ."," .							 
							 (is_null($row['es_pagable'])?'NULL':"'".$row['es_pagable']."'") ."," .							 
							 (is_null($row['codigo_tipo_obligacion_agrupador'])?'NULL':"'".$row['codigo_tipo_obligacion_agrupador']."'") ."," .							 
							 (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .							 
							 (is_null($row['codigo_tipo_relacion_debe'])?'NULL':"'".$row['codigo_tipo_relacion_debe']."'") ."," .							 
							 (is_null($row['codigo_tipo_relacion_haber'])?'NULL':"'".$row['codigo_tipo_relacion_haber']."'") ."," .							 							 
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'").");\r\n");	
							
							
				} /*else {
					fwrite ($file, 

				"select plani.f_import_ttipo_planilla ('delete','".							 
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL);\r\n");
							 
							 	
				}*/
			 } else if ($row['tipo_reg'] == 'detalle_tipo_obli_colum') {
				if ($row['estado_reg'] == 'activo') {
					
					fwrite ($file, 
					 "select plani.f_import_ttipo_obligacion_columna('insert',".
							 (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
							 (is_null($row['codigo_tipo_obligacion'])?'NULL':"'".$row['codigo_tipo_obligacion']."'") ."," .
							 (is_null($row['codigo_tipo_planilla'])?'NULL':"'".$row['codigo_tipo_planilla']."'") ."," .
							 (is_null($row['pago'])?'NULL':"'".$row['pago']."'") ."," .
							 (is_null($row['presupuesto'])?'NULL':"'".$row['presupuesto']."'") ."," .
							 (is_null($row['es_ultimo'])?'NULL':"'".$row['es_ultimo']."'") ."," .							 							 							 	
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") .");\r\n");
			
	
				} /*else {
					
						fwrite ($file, 
					"select plani.f_import_ttipo_columna_planilla ('delete','".							 
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL);\r\n");	
			
							 						
				}*/
			} 
         } //end for
		
		
		return $fileName;
	}
			
			
}

?>