<?php
/**
*@package pXP
*@file gen-Obligacion.php
*@author  (jrivera)
*@date 14-07-2014 20:30:19
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * 
 *   HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #74         04/11/2019           Rarteaga             creacion
 #78 ETR     18-11-2019           RAC                  considerar esquema para origen de datos
 #79 ETR     27/11/2019          RAC KPLIAN            nueva columnas para habilitar o des-habilitar el botón de cbte de pago
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ObligacionConta=Ext.extend(Phx.gridInterfaz,{
    
	constructor:function(config){
		
		this.maestro=config.maestro;
		
		this.south = ((config.esquema === 'plani')?{
												  url:'../../../sis_planillas/vista/obligacion_columna/ObligacionColumna.php',
													  title:'Detalle de Ejecución por Obligación', 
													  height:'50%',
													  cls:'ObligacionColumna'
												}:undefined);
	
		
    	//llama al constructor de la clase padre
		Phx.vista.ObligacionConta.superclass.constructor.call(this,config);
		this.init();
		this.esquema = this.esquema?this.esquema:'plani'; //#78 si no existe el dato por defecto recupera de PLANI
		this.store.baseParams.id_planilla = this.maestro.id_planilla;
		this.store.baseParams.esquema = this.esquema?this.esquema:'plani'; //#78 si no existe el dato por defecto recupera de PLANI
		this.load({params:{start:0, limit:this.tam_pag, id_planilla: this.maestro.id_planilla}});
		
        
       
       this.addButton('SolPag',{text:'Solicitar Cbtes de Pago', iconCls: 'bpagar',disabled: true, handler: this.onBtnPag ,tooltip: '<b>Generar Cbte de  Pago</b><br/>Genera el comprobante correspondiente del pago seleccionado'});
       this.addButton('SolTodosPag',{text:'Solicitar Todos los Cbtes de Pago', iconCls: 'bpagar',disabled: true, handler: this.onBtnTodosPag ,tooltip: '<b>Solicitar Todos los Pagos</b><br/>Genera en cotabilidad todos los  comprobante Correspondiente de pago'});
        
	},
	
	
    savePltGrid: true, //#24 configura el manejo de plantilla para la grilla
    applyPltGrid: true, //#24
    bottom_filter: true,//#24
    tipoStore: 'GroupingStore',//GroupingStore o JsonStore #24
    remoteGroup: true,//#24
    groupField: 'desc_agrupador',//#24
    viewGrid: new Ext.grid.GroupingView({
            forceFit:false,
            //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        }), //#24  
        
        
	
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_obligacion'
			},
			type:'Field',
			form:true 
		},
		
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_planilla'
			},
			type:'Field',
			form:true 
		},		
		
		{
			config:{
				name: 'acreedor',
				fieldLabel: 'Acreedor',
				allowBlank: false,
				anchor: '80%',
				gwidth: 170
			},
				type:'TextField',
				filters:{pfiltro:'obli.acreedor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter : true,
				egrid:true
		},
	
		
		{
			config:{
				name: 'desc_tipo_obligacion',
				fieldLabel: 'Descripción',
				allowBlank: true,
				anchor: '100%',				
				gwidth: 300,
				maxLength:500,
				renderer:function (value, p, record){				
					if(record.data['desc_tipo_obligacion'] && record.data['desc_tipo_obligacio'] != '' ){
						return String.format('{0}', record.data['desc_tipo_obligacion']);
					}
					else{
						return String.format('{0}', record.data['descripcion']);
					}
					
				}
			},
				type:'TextArea',
				filters:{pfiltro:'tipobli.nombre#obli.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter : true,
				egrid:false
		},
		
		{
			config:{
				name: 'es_pagable',
				fieldLabel: 'Es pagable',				
				gwidth: 80
			},
				type:'TextField',
				filters:{pfiltro:'tipobli.es_pagable',type:'string'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'tipo_pago',
				fieldLabel: 'Tipo Pago',
				allowBlank:true,
				emptyText:'tipo...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 85,
				store:['cheque','transferencia','transferencia_empleados']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['cheque','transferencia','transferencia_empleados'],	
	       		 	},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:false
		},	
		
		{
			config:{
				name: 'monto_obligacion',
				fieldLabel: 'Monto',				
				gwidth: 100
			},
				type:'NumberField',
				filters:{pfiltro:'obli.monto_obligacion',type:'numeric'},				
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'obli.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
			//#38 desc_agrupador
		{
			config:{
				name: 'desc_agrupador',
				fieldLabel: 'Agrupado de pago',
				allowBlank: true,
				anchor: '100%',
				gwidth: 250,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'oa.acreedor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true
		},
		//#38 ++  inicio
		{	config:{
				name: 'id_int_comprobante',
				fieldLabel: 'ID Cbte',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'obli.id_int_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'id_int_comprobante_agrupador',
				fieldLabel: 'ID Cbte Agru',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'oa.id_int_comprobante',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		//#38 ++  fin
		
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'obli.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'obli.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'obli.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'obli.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Obligaciones',
	ActSave:'../../sis_planillas/control/Obligacion/insertarObligacion',
	ActDel:'../../sis_planillas/control/Obligacion/eliminarObligacion',
	ActList:'../../sis_planillas/control/Obligacion/listarObligacion',
	id_store:'id_obligacion',
	fields: [
		{name:'id_obligacion', type: 'numeric'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'id_planilla', type: 'numeric'},
		{name:'id_tipo_obligacion', type: 'numeric'},
		{name:'monto_obligacion', type: 'numeric'},
		{name:'acreedor', type: 'string'},
		{name:'es_pagable', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo_pago', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'id_obligacion_agrupador','desc_agrupador','desc_tipo_obligacion','id_int_comprobante','id_int_comprobante_agrupador' //#38++
		
	],
	sortInfo:{
		field: 'id_obligacion',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bedit:false,
	bnew:false,
	
	
    onBtnPag: function(){
    	var rec=this.sm.getSelected();
    	var confirmado = true;
    	if(rec){
	     	if(confirm('¿Está seguro de generar el comprobante de pago para: '+ rec.data.descripcion + '?. Si tiene agrupador de segenerá el cbte para todos los miembros del grupo')) {            
	           
		            
		            //si ya existe un cbte de devegado pedimos confirmacion
        	   	   var ids_cbts = ''
        	   	   if(rec.data.id_int_comprobante || rec.data.id_int_comprobante_agrupador){
        	   	  	
	        	   	  	 if(rec.data.id_int_comprobante){
	        	   	  	 	ids_cbts = rec.data.id_int_comprobante;
	        	   	  	 } 
	        	   	  	 if(rec.data.id_int_comprobante_agrupador){
	        	   	  	 	ids_cbts =  rec.data.id_int_comprobante_agrupador
	        	   	  	 }
	        	   	  	
	        	   	  	if(confirm('¿Previamente fueron  generados los cbte de pago id: '+ ids_cbts+' ,continuamos?')){
	        	   	  		confirmado = true;
	        	   	  	}
	        	   	  	else{
	        	   	  		confirmado = false;
	        	   	  	}        	   	  	
	        	   	} 
		            if(confirmado) {
		                Phx.CP.loadingShow();
			            Ext.Ajax.request({
			                url:'../../sis_planillas/control/Planilla/generarCbteContable',
			                params: { id_planilla: undefined, tipo:'pago', id_obligacion: rec.data.id_obligacion },
			                success: this.successGenCbte,
			                failure: this.conexionFailure,
			                timeout: this.timeout,
			                scope:this
			            });
			       }
	            
	         }
		 }
         else {
           alert('no selecciono ningun registro');
         }
     },
     
     onBtnTodosPag: function() {
         	
         	if(confirm('¿Está seguro de generar todos los comprobantes de pago de uan sola vez?')) {
	            var rec=this.sm.getSelected();
	            if(rec){
		            Phx.CP.loadingShow();
		            //preguntamos si existe algun comprobante de pago
		            Ext.Ajax.request({
		                url:'../../sis_planillas/control/Obligacion/existenCbteDePago',
		                params: { id_planilla: rec.data.id_planilla },
		                success: this.regresoVerficacionCbte,
		                failure: this.conexionFailure,
		                timeout: this.timeout,
		                scope:this
		            }); 
	            }
	            else{
	            	alert('no selecciono ningun registro');
	            }
           }
     },
     
     regresoVerficacionCbte: function(resp){
            Phx.CP.loadingHide();
            // si existen  algun cbte generado pedimos confirmación al usuario
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			if (reg.ROOT.error) {
				Ext.Msg.alert('Error', 'Validación no realizada: ' + reg.ROOT.error)
			} else {
				if(reg.ROOT.datos.existe_cbte_pago == 'si'){
					//pedimos  confirmacion del usuario
					if(confirm('¿Previamente ya fueron  generados algunos cbte de pago ,continuamos?')){
	        	   	  	this.generarTodosPag()
	        	   	 }
				}
				else{
					// si no existen cbte inicia la generacion
					this.generarTodosPag()
				}
			}
           
    },
     
    generarTodosPag: function(){
    	
    	Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_planillas/control/Planilla/generarCbteContable',
            params: { id_planilla: this.maestro.id_planilla, tipo:'pagogrupo', id_obligacion: undefined},
            success: this.successGenCbte,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope:this
        });
     	
    },
     
    successGenCbte: function(resp){
            Phx.CP.loadingHide();
            this.reload();
    },
	
	onBtnDetalle: function(){
			var rec = {maestro: this.sm.getSelected().data};
						      
            Phx.CP.loadWindows('../../../sis_planillas/vista/detalle_transferencia/DetalleTransferencia.php',
                    'Detalle de Transferencias',
                    {
                        width:800,
                        height:'90%'
                    },
                    rec,
                    this.idContenedor,
                    'DetalleTransferencia');
	},
	onBtnRepAbono: function(){//#46
			var rec=this.sm.getSelected();
			
					
				   
          Ext.Ajax.request({
				url:'../../sis_planillas/control/Obligacion/listarAbonoCuenta',
				params:{'id_obligacion':rec.data.id_obligacion,
				'tipo_contrato':this.maestro.tipo_contrato,
				'start':0,'limit':100000},
				success: this.successGeneracion_txt,
			
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
				
	},
	successGeneracion_txt:function(resp) {
			Phx.CP.loadingHide();
	        var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
	        
	        var texto = objRes.datos;
	        window.open('../../../reportes_generados/'+texto)//#46
		},//#46
		
		
	onBtnRepBancos: function() {//#56
			var data=this.sm.getSelected().data;
			
			Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_planillas/control/Reporte/reporteBancos', //#56
                params:{'id_obligacion' : data.id_obligacion, 'control_reporte':'relacion_saldos'
                		},
                success:this.successExport,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });  
				
	},
	
	
	preparaMenu: function()  {	
    	var rec = this.sm.getSelected().data;   
    	
    	console.log('datos maestro ---->', this.maestro.sw_pago, this.maestro.estado, this.maestro) 
    	console.log('datos esquema ---->', this.esquema, rec.es_pagable, this.vistaPadre) 	
    	//if(this.esquema === 'plani' && this.maestro.estado == 'vobo_conta' && rec.es_pagable == 'si' && this.vistaPadre == 'PlanillaVbConta' && this.maestro.sw_pago == 'si'){//#79
    	if(this.esquema === 'plani' && this.maestro.estado == 'vobo_conta' && rec.es_pagable == 'si' && this.vistaPadre == 'PlanillaVbConta'){//#79
        
           	this.getBoton('SolPag').enable();
           	this.getBoton('SolTodosPag').disable();	           	
        }
        else{
           this.getBoton('SolPag').disable();
           this.getBoton('SolTodosPag').disable();
        }  
        Phx.vista.ObligacionConta.superclass.preparaMenu.call(this);
    },
    liberaMenu: function() {	                   
        Phx.vista.ObligacionConta.superclass.liberaMenu.call(this);
        this.getBoton('SolPag').disable();
        this.getBoton('SolTodosPag').disable();
    },
});
</script>
		
		