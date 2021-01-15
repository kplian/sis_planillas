<?php
/**
 *@package pXP
 *@file    ItemEntRec.php
 *@author  RCM
 *@date    07/08/2013
 *@description Reporte Material Entregado/Recibido
 * #33	etr			MZM-KPLIAN		02.09.2019	Adicion de control para reporte multilinea (opcion totales)
 * #66	etr			MZM-KPLIAN		24.10.2019	inclusion de opcion de reporte con control_reporte
 * #77	ETR			MZM-KPLIAN		15.11.2019	Ajuste Reportes
   #81	ETR			MZM-KPLIAN		20.11.2019	Ampliacion de visualizacion de nombre de reportes
 * #83	ETR			MZM-KPLIAN		10.12.2019	Habilitacion de opcion historico de planilla
 * #87	ETR			MZM-KPLIAN		10.01.2020	Habilitacion de opcion detalle de aguinaldo
 * #98	ETR			MZM-KPLIAN		03.03.2020	HAbilitacion de opcion estado_funcionario (activo, retirado, todos) para todos los reportes
 * #107	ETR			MZM-KPLIAN		16.03.2020	Carga automatica de ultima gestion y periodo procesado
 * #119 ETR			MZM-KPLIAN		23.04.2020	Reporte acumulado saldo rc-iva
 * #144	ETR			MZM-KPLIAN		29.06.2020	Reporte ingreso/egreso por funcionario
  #156	ETR			EGS				03/08/2020	Se agrega codigo_afp
   #158	ETR			MZM-KPLIAN		19.08.2020	Para Personal retirado adicionar periodo con el cual generar el reporte
 *#ETR-1378			MZM-KPLIAN		18.10.2020	Adicion de filtro por empleado_planilla
 *#ETR-2476			MZM-KPLIAN		14.01.2021	Adicion de tipo incremento_salarial para ocultar periodo 
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.GenerarReporte = Ext.extend(Phx.frmInterfaz, {
		Atributos : [ 
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_contrato'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre_tipo_contrato'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'tipo_reporte'
			},
			type:'Field',
			form:true 
		},
		{
   			config:{
   				name:'id_depto',
   				 hiddenName: 'id_depto',
   				 //url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
	   				origen:'DEPTO',
	   				allowBlank:false,
	   				fieldLabel: 'Depto',	   				
	   				width:250,   			        
	   				baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'ORGA'}//parametros adicionales que se le pasan al store
	      			
   			},
   			//type:'TrigguerCombo',
   			type:'ComboRec',
   			id_grupo:0,   			
   			form:true
       	},	
		{
			config: {
				name: 'id_tipo_planilla',
				fieldLabel: 'Tipo Planilla',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_tipo_planilla',
				allowBlank: false,
				emptyText: 'Lista de Planillas...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/TipoPlanilla/listarTipoPlanilla',
					id: 'id_tipo_planilla',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_planilla', 'nombre', 'codigo','periodicidad'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tippla.nombre#tippla.codigo'}
				}),
				valueField: 'id_tipo_planilla',
				displayField: 'nombre',				
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,				
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},	
		
		
		{
			config: {
				name: 'id_reporte',
				fieldLabel: 'Tipo Reporte',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_reporte',
				allowBlank: false,
				emptyText: 'Reportes Disponibles...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/Reporte/listarReporte',
					id: 'id_reporte',
					root: 'datos',
					sortInfo: {
						field: 'titulo_reporte',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_reporte', 'titulo_reporte','tipo_reporte','multilinea','control_reporte'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'repo.titulo_reporte'}
				}),
				valueField: 'id_reporte',
				displayField: 'titulo_reporte',				
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:480,//#81 20.11.2019
				minChars: 2,
				disabled : true
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},	//#80
		{
			config: {
				name: 'id_tipo_columna',
				fieldLabel: 'Código Columna',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_tipo_columna',
				allowBlank: false,
				emptyText: 'Lista de Columnas...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/TipoColumna/listarTipoColumna',
					id: 'id_tipo_columna',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_columna', 'nombre', 'codigo', 'tipo_descuento_bono','tipo_dato'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'tipcol.nombre#tipcol.codigo',tipo_descuento_bono:'si'}
				}),
				valueField: 'id_tipo_columna',
				displayField: 'nombre',
				gdisplayField: 'codigo_columna',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'tipcol.codigo',
				type: 'string'
			},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'id_tipo_contrato',
				fieldLabel: 'Tipo Contrato',
				allowBlank: false,
				emptyText: 'Tipo Contrato...',
				store: new Ext.data.JsonStore({
					url: '../../sis_organigrama/control/TipoContrato/listarTipoContrato',
					id: 'id_tipo_contrato',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_contrato', 'nombre', 'codigo'],
					remoteSort: true,
					baseParams: {par_filtro: 'tipcon.nombre#tipcon.codigo'}
				}),
				valueField: 'id_tipo_contrato',
				displayField: 'nombre',
				gdisplayField: 'nombre_tipo_contrato',
				hiddenName: 'id_tipo_contrato',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				minChars: 2,
				
			},
			type: 'ComboBox',
			id_grupo: 0,			
			form: true
		},
		{
   			config:{
       		    name:'id_uo',
       		    hiddenName: 'id_uo',
          		origen:'UO',
   				fieldLabel:'UO',
   				gdisplayField:'desc_uo',//mapea al store del grid
   				gwidth:200,
   				emptyText:'Dejar blanco para toda la empresa...',
   				anchor: '80%',
   				baseParams: {nivel: '0,1,2'},
   				allowBlank:true   			     
       	     },
   			type:'ComboRec',
   			id_grupo:0,   			
   			form:true
   	      },	
		{
	   			config:{
	   				name : 'id_gestion',
	   				origen : 'GESTION',
	   				fieldLabel : 'Gestion',
	   				allowBlank : false	   				
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,
	   			form : true
	   	},
		{
	   			config:{
	   				name : 'id_periodo',
	   				origen : 'PERIODO',
	   				fieldLabel : 'Periodo',
	   				allowBlank : true
	   				  				
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,	   			
	   			form : true
	   },
	   {
			config:{
				name: 'formato_reporte',
				fieldLabel: 'Formato de Reporte',
				allowBlank:false,
				emptyText:'Formato...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['pdf','xls']
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		},
		{
			config:{//#33
				name: 'totales',
				fieldLabel: 'Totales?',
				allowBlank:false,
				emptyText:'Totales...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no']
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		},
		
		{
	       		config:{
	       			name: 'fecha',
	       			fieldLabel: "A fecha",
	       			gwidth: 120,	       			
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			format:'d/m/Y',
	       			//anchor:'30%',
	       			renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
				},
	       		type:'DateField',
				filters:{pfiltro:'rfu.fecha_asignacion',type:'date'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       },
		
		
		 {
	       		config:{
	       			name: 'rango_inicio',
	       			fieldLabel: "Rango Inicial(años)",
	       			gwidth: 200,	       			
	       			allowBlank:true,	
	       			maxLength:150,
	       			minLength:1
	       			//anchor:'30%'
	       		},
	       		type:'NumberField',
				id_grupo:0,
	       		grid:true,
	       		form:true
	       },
	      {
	       		config:{
	       			name: 'rango_fin',
	       			fieldLabel: "Rango incremento(años)",
	       			gwidth: 200,	       			
	       			allowBlank:true,	
	       			maxLength:150,
	       			minLength:1
	       			//,anchor:'30%'
	       		},
	       		type:'NumberField',
				id_grupo:0,
	       		grid:true,
	       		form:true
	      },
	      {
			config: {
				name: 'id_afp',
				fieldLabel: 'AFP',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_afp',
				allowBlank: false,
				emptyText: 'Afp...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/Afp/listarAfp',
					id: 'id_afp',
					root: 'datos',
					sortInfo: {
						field: 'id_afp',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_afp', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'afp.nombre#afp.codigo'}
				}),
				valueField: 'id_afp',
				displayField: 'nombre',
				gdisplayField: 'nombre',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><strong>{nombre}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'afppar.nombre',
				type: 'string'
			},
			grid: true,
			form: true
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'control_reporte'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'periodicidad'
			},
			type:'Field',
			form:true 
		},{
			config:{//#01/10/2019
				name: 'personal_activo',
				fieldLabel: 'Estado',
				allowBlank:false,
				emptyText:'Estado...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['activo','retirado','todos']
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		}
		//#80
		,{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre_descuento'
			},
			type:'Field',
			form:true 
		},{
			config:{//#01/10/2019
				name: 'consultar_backup',
				fieldLabel: 'Consultar Backup',
				allowBlank:false,
				emptyText:'Consultar Backup...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no']
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		},{
			config: {
				name: 'id_planillabk',
				fieldLabel: 'Backup de Planilla',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_planillabk',
				allowBlank: true,
				emptyText: 'Backup de Planilla...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/Planilla/listarPlanillaBk',
					id: 'id_planilla',
					root: 'datos',
					sortInfo: {
						field: 'id_planilla',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_planilla', 'nro_planilla', 'fecha_backup','tipo_contrato'],
					remoteSort: true,
					baseParams: {par_filtro: 'afp.nombre#afp.codigo',
					}
				}),
				valueField: 'id_planilla',
				displayField: 'nro_planilla',
				gdisplayField: 'nombre',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nro_planilla}-({id_planilla})</p>Tipo:<strong>{tipo_contrato}</strong></p>Fecha Backup:<strong>{fecha_backup}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'afppar.nombre',
				type: 'string'
			},
			grid: true,
			form: true
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'esquema'
			},
			type:'Field',
			form:true 
		},
		{//#83
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre_afp'
			},
			type:'Field',
			form:true 
		},
        {//#156
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'codigo_afp'
            },
            type:'Field',
            form:true
        },{//#83
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'codigo_planilla'
			},
			type:'Field',
			form:true 
		},{//#83
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'fecha_backup'
			},
			type:'Field',
			form:true 
		},{//#98
			config:{
				name: 'consolidar',
				fieldLabel: 'Consolidar',
				allowBlank:false,
				emptyText:'Consolidar...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
				store:['si','no']
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		},
		{
			config: {
				name: 'id_funcionario_planilla',
				fieldLabel: 'Funcionario',
				typeAhead: false,
				forceSelection: false,
				hiddenName: 'id_funcionario_planilla',
				allowBlank: true,
				emptyText: 'Funcionario...',
				store: new Ext.data.JsonStore({
					url: '../../sis_planillas/control/FuncionarioPlanilla/listarFuncionarioPlanilla',
					id: 'id_funcionario_planilla',
					root: 'datos',
					sortInfo: {
						field: 'id_funcionario_planilla',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_funcionario_planilla', 'id_planilla', 'id_funcionario','desc_funcionario2','tipo_contrato'],
					remoteSort: true,
					baseParams: {par_filtro: 'funcio.desc_funcionario2',
					}
				}),
				valueField: 'id_funcionario_planilla',
				displayField: 'desc_funcionario2',
				gdisplayField: 'desc_funcionario2',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_funcionario2}</p>Tipo:<strong>{tipo_contrato}</strong></p>Fecha Backup:<strong>{fecha_backup}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters:{pfiltro:'funcio.desc_funcionario2',type:'string'},
			grid: true,
			form: true
		}
		
		],
		title : 'Generar Reporte',
		ActSave : '../../sis_planillas/control/Reporte/generarReporteDesdeForm',
		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte</b>',
		constructor : function(config) {
			Phx.vista.GenerarReporte.superclass.constructor.call(this, config);
			this.init();
			
			this.ocultarComponente(this.Cmp.totales);
			this.ocultarComponente(this.Cmp.id_planillabk);//#83
			
			this.Cmp.id_gestion.disable();//#107
			this.Cmp.totales.setValue('no');//#107
			//********
						this.ocultarComponente(this.Cmp.rango_fin);
						this.ocultarComponente(this.Cmp.rango_inicio);
						this.ocultarComponente(this.Cmp.id_afp);
						this.ocultarComponente(this.Cmp.fecha);
						//this.ocultarComponente(this.Cmp.personal_activo);
						this.ocultarComponente(this.Cmp.id_tipo_columna);//#80
						this.ocultarComponente(this.Cmp.consolidar);//#98
						this.Cmp.consolidar.setValue('no');//#98
												
			//********
			//#83
			this.Cmp.consultar_backup.on('select',function(c,r,i) {
			  if (c.value=='si'){
			  	this.mostrarComponente(this.Cmp.id_planillabk);
			  	this.Cmp.id_planillabk.store.baseParams={id_tipo_planilla: this.Cmp.id_tipo_planilla.getValue(),
			  		id_periodo: this.Cmp.id_periodo.getValue(),
			  		id_tipo_contrato:this.Cmp.id_tipo_contrato.getValue()
			  		}
			  		this.Cmp.id_planillabk.modificado=true;
			  }else{
			  	this.ocultarComponente(this.Cmp.id_planillabk);
			  	this.Cmp.id_planillabk.reset();		
			  	this.Cmp.esquema.setValue('plani');	  
			  	this.Cmp.fecha_backup.setValue('');
			  	}
				
			},this);
			
			this.Cmp.id_planillabk.on('select',function(c,r,i) {
				if(c.value!=''){
					this.Cmp.esquema.setValue('planibk');
					this.Cmp.fecha_backup.setValue(r.data.fecha_backup+'('+r.data.id_planilla+')');
				}else{
					this.Cmp.esquema.setValue('plani');
					this.Cmp.fecha_backup.setValue('');
				}
			},this);
			
			this.Cmp.id_tipo_planilla.on('select',function(c,r,i) {
				this.Cmp.id_gestion.enable();//#107
				this.Cmp.id_gestion.reset();//#107
				this.Cmp.id_gestion.modificado=true;//#107
				this.Cmp.id_periodo.reset();//#107
				
				this.ocultarComponente(this.Cmp.fecha);
				this.ocultarComponente(this.Cmp.rango_fin);
				this.ocultarComponente(this.Cmp.rango_inicio);
				this.ocultarComponente(this.Cmp.id_afp);
				this.ocultarComponente(this.Cmp.totales);
				this.mostrarComponente(this.Cmp.formato_reporte);
				this.mostrarComponente(this.Cmp.id_uo);
				this.mostrarComponente(this.Cmp.id_tipo_contrato);
				this.mostrarComponente(this.Cmp.id_gestion);
				//this.ocultarComponente(this.Cmp.personal_activo);
				this.ocultarComponente(this.Cmp.consolidar);//#98
				this.Cmp.periodicidad.setValue(r.data.periodicidad);
				this.Cmp.codigo_planilla.setValue(r.data.codigo);//#83
				
				/************/
				this.ocultarComponente(this.Cmp.id_funcionario_planilla); //#144
				this.mostrarComponente(this.Cmp.personal_activo);//#144
				this.mostrarComponente(this.Cmp.consultar_backup);//#144
				
				
				// obtener la ultima planilla del tipo seleccionado
				 Ext.Ajax.request({
	                // form:this.form.getForm().getEl(),
	                url:'../../sis_planillas/control/Planilla/listarPlanillaUltima',
	                params: { id_tipo_planilla: r.data.id_tipo_planilla },
	                success: this.successTipoPlani,
	                failure: this.conexionFailure,
	                timeout:this.timeout,
	                scope:this
            	});
            	
            	  
				if (r.data.periodicidad == 'anual') {
					this.ocultarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = true;
					this.Cmp.id_periodo.reset();	
					
					this.ocultarComponente(this.Cmp.personal_activo);
					this.Cmp.personal_activo.setValue('todos');
									
				} else {
					this.mostrarComponente(this.Cmp.id_periodo);
					this.Cmp.id_periodo.allowBlank = false;		
					this.mostrarComponente(this.Cmp.personal_activo);
					this.Cmp.personal_activo.setValue('todos');
	
				}
				this.Cmp.id_reporte.setDisabled(false);
				this.Cmp.id_reporte.reset();
				this.Cmp.id_reporte.store.baseParams.id_tipo_planilla = r.data.id_tipo_planilla;
				this.Cmp.id_reporte.modificado = true;
				
				this.Cmp.personal_activo.setValue('todos');//#98
				if(r.data.codigo=='PLANRE' ){
					//this.mostrarComponente(this.Cmp.personal_activo);
					this.mostrarComponente(this.Cmp.consolidar);//#98
				}else{
					//this.ocultarComponente(this.Cmp.personal_activo);	
					this.ocultarComponente(this.Cmp.consolidar);//#98	
					this.Cmp.consolidar.setValue('no');//#98
					
				}
				this.Cmp.id_planillabk.reset();//#83
				this.Cmp.consultar_backup.setValue('no');//#83
				this.ocultarComponente(this.Cmp.id_planillabk);//#83
				this.Cmp.esquema.setValue('plani');
				
				
				
			},this);
			
			
			this.Cmp.id_gestion.on('select',function(c,r,i){
				this.Cmp.id_periodo.reset();
				this.Cmp.id_periodo.store.baseParams.id_gestion = r.data.id_gestion;
				
				this.Cmp.id_periodo.modificado = true;
				this.Cmp.id_funcionario_planilla.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue(); //#144
				
				this.Cmp.id_funcionario_planilla.modificado=true;
			},this);
			
			
			// ETR-1378
			this.Cmp.id_funcionario_planilla.on('change',function(c,r,i){
				this.Cmp.id_funcionario_planilla.store.baseParams.par_filtro = 'funcio.desc_funcionario2'; 
				
				this.Cmp.id_funcionario_planilla.modificado=true;
			},this);

				
			this.Cmp.id_tipo_contrato.on('select',function(c,r,i){
				this.Cmp.tipo_contrato.setValue(r.data.codigo);
				this.Cmp.nombre_tipo_contrato.setValue(r.data.nombre);
				//#83
				this.Cmp.consultar_backup.setValue('no');
				this.Cmp.id_planillabk.reset();
				this.ocultarComponente(this.Cmp.id_planillabk);//#83
				this.Cmp.esquema.setValue('plani');
				
				//#144
				this.Cmp.id_funcionario_planilla.reset();
				this.Cmp.id_funcionario_planilla.store.baseParams.id_tipo_contrato = this.Cmp.id_tipo_contrato.getValue(); //#144
				if (this.Cmp.id_periodo.getValue()!=''){
					this.Cmp.id_funcionario_planilla.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue(); //#144
					this.Cmp.id_funcionario_planilla.store.baseParams.id_periodo = this.Cmp.id_periodo.getValue(); //#144
				}
				this.Cmp.id_funcionario_planilla.modificado=true;
				
				
				
			},this);
			//#83
			this.Cmp.id_periodo.on('select',function(c,r,i){
				this.Cmp.consultar_backup.setValue('no');
				this.Cmp.id_planillabk.reset();
				this.ocultarComponente(this.Cmp.id_planillabk);
				this.Cmp.esquema.setValue('plani');
				//#144
				this.Cmp.id_funcionario_planilla.reset();
				this.Cmp.id_funcionario_planilla.store.baseParams.id_periodo = this.Cmp.id_periodo.getValue(); //#144
				this.Cmp.id_funcionario_planilla.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue(); //#144
				if (this.Cmp.id_tipo_contrato.getValue()!=''){
					this.Cmp.id_funcionario_planilla.store.baseParams.id_tipo_contrato = this.Cmp.id_tipo_contrato.getValue(); //#144
				}
				//#144
				this.Cmp.id_funcionario_planilla.modificado=true;
				
			},this);
			
			
			this.Cmp.id_tipo_columna.on('select',function(c,r,i){ //#80
				this.Cmp.nombre_descuento.setValue(r.data.nombre);
			},this);	  
			
			
			this.Cmp.id_reporte.on('select',function(c,r,i){ //#33
				this.Cmp.tipo_reporte.setValue(r.data.tipo_reporte);
				this.Cmp.control_reporte.setValue(r.data.control_reporte);
				this.Cmp.id_tipo_columna.setValue('');
				this.Cmp.nombre_descuento.setValue('');
				this.mostrarComponente(this.Cmp.personal_activo);
				this.ocultarComponente(this.Cmp.id_funcionario_planilla); //#144
				this.Cmp.id_funcionario_planilla.reset();
				this.Cmp.id_afp.allowBlank=true;
				this.Cmp.id_afp.setValue('');
				//***************
				if(r.data.tipo_reporte=='formato_especifico'){ //alert(r.data.control_reporte);
					  //***************************     
					    this.ocultarComponente(this.Cmp.totales);
						//this.ocultarComponente(this.Cmp.formato_reporte);
						this.ocultarComponente(this.Cmp.id_uo);
						this.ocultarComponente(this.Cmp.id_tipo_columna);//#80
						
											
						
						this.Cmp.id_uo.allowBlank=true;
						this.Cmp.id_uo.setValue('');
						
						this.ocultarComponente(this.Cmp.id_afp);
						this.Cmp.id_afp.allowBlank=true;
						this.Cmp.id_afp.setValue('');
						//this.Cmp.id_tipo_contrato.allowBlank=true;
						this.Cmp.nombre_afp.setValue('');
                        this.Cmp.codigo_afp.setValue('');//#156
							
						this.ocultarComponente(this.Cmp.fecha);
						this.Cmp.fecha.allowBlank=true;
						this.Cmp.fecha.setValue('');
						
						this.mostrarComponente(this.Cmp.id_gestion);
						this.Cmp.id_gestion.allowBlank=false;
						
						
						//#83
						if (this.Cmp.periodicidad.getValue() == 'anual') {
							this.ocultarComponente(this.Cmp.id_periodo);
							this.Cmp.id_periodo.allowBlank = true;
							this.Cmp.id_periodo.reset();		
							
							this.ocultarComponente(this.Cmp.personal_activo);
							this.Cmp.personal_activo.setValue('todos');		
							
							if(this.Cmp.control_reporte.getValue()=='planilla_prevision' ){
								this.Cmp.personal_activo.setValue('activo');//#135
								this.mostrarComponente(this.Cmp.personal_activo);//#135
							
							}else{//#135
								this.ocultarComponente(this.Cmp.personal_activo);
								this.Cmp.personal_activo.setValue('todos');	
							}
								
						} else {
							this.mostrarComponente(this.Cmp.id_periodo);
							this.Cmp.id_periodo.allowBlank = false;		
							this.mostrarComponente(this.Cmp.personal_activo);
							this.Cmp.personal_activo.setValue('todos');
						}
						

						
						this.ocultarComponente(this.Cmp.rango_fin);
						this.ocultarComponente(this.Cmp.rango_inicio);
						this.Cmp.rango_inicio.allowBlank=true;
						this.Cmp.rango_fin.allowBlank=true;
						
						this.mostrarComponente(this.Cmp.formato_reporte);	
						this.Cmp.formato_reporte.allowBlank=false;
						
						if (r.data.control_reporte=='empleado_edad' || r.data.control_reporte=='empleado_antiguedad' || r.data.control_reporte=='dependientes_edad'){//#77
								
								this.mostrarComponente(this.Cmp.rango_fin);
								this.mostrarComponente(this.Cmp.rango_inicio);
								this.Cmp.rango_inicio.allowBlank=false;
								this.Cmp.rango_fin.allowBlank=false;
								this.mostrarComponente(this.Cmp.personal_activo);
								this.Cmp.personal_activo.setValue('todos');
								//this.ocultarComponente(this.Cmp.id_tipo_contrato);
								//this.ocultarComponente(this.Cmp.formato_reporte);
								
						}else{  this.mostrarComponente(this.Cmp.personal_activo);
								/*this.ocultarComponente(this.Cmp.rango_fin);
								this.ocultarComponente(this.Cmp.rango_inicio);
								this.Cmp.rango_inicio.allowBlank=true;
								this.Cmp.rango_fin.allowBlank=true;*/
								this.mostrarComponente(this.Cmp.formato_reporte);
								//this.mostrarComponente(this.Cmp.id_tipo_contrato);
								
								if (r.data.control_reporte=='aporte_afp' || r.data.control_reporte=='fondo_solidario'){
									this.mostrarComponente(this.Cmp.id_afp);
									this.Cmp.id_afp.allowBlank=false;
									this.ocultarComponente(this.Cmp.personal_activo);
									this.Cmp.personal_activo.setValue('todos');
								}else{
									if(r.data.control_reporte=='reserva_beneficios' || r.data.control_reporte=='reserva_beneficios2' || r.data.control_reporte=='reserva_beneficios3'){
										this.mostrarComponente(this.Cmp.fecha);
										this.Cmp.fecha.allowBlank=false;
										
										this.ocultarComponente(this.Cmp.id_gestion);
										this.ocultarComponente(this.Cmp.id_periodo);
										this.Cmp.id_gestion.allowBlank=true;
										this.Cmp.id_gestion.setValue('');
										
										this.Cmp.id_periodo.allowBlank=true;
										this.Cmp.id_periodo.setValue('');
										
										this.ocultarComponente(this.Cmp.personal_activo);
										this.Cmp.personal_activo.setValue('todos');
										
									}else{
										if(r.data.control_reporte=='asignacion_cargos' || r.data.control_reporte=='movimiento_personal' || r.data.control_reporte=='personal_ret' || r.data.control_reporte=='personal_inc' ||  r.data.control_reporte=='incremento_salarial' ){ //#ETR-2476
											this.ocultarComponente(this.Cmp.id_periodo);
											this.Cmp.id_periodo.allowBlank=true;
											this.Cmp.id_periodo.setValue('');
											this.ocultarComponente(this.Cmp.personal_activo);
											this.Cmp.personal_activo.setValue('todos');
											if (r.data.control_reporte=='personal_ret'){//#158
												this.mostrarComponente(this.Cmp.fecha);
												this.Cmp.fecha.allowBlank=false;
											}else{
												this.ocultarComponente(this.Cmp.fecha);
												this.Cmp.fecha.allowBlank=true;
											}
											
											
										}else{
											if(r.data.control_reporte=='planilla_tributaria' || r.data.control_reporte=='saldo_fisco'){//#119
												this.ocultarComponente(this.Cmp.personal_activo);
											}else{
												if(r.data.control_reporte=='ingreso_egreso' ){//#144
													
													this.mostrarComponente(this.Cmp.id_funcionario_planilla);
													this.ocultarComponente(this.Cmp.personal_activo);
													this.ocultarComponente(this.Cmp.consultar_backup);
												}	
											}
										}
										
									}
									
								}
								
							}
							
						if( r.data.control_reporte=='curva_salarial' || r.data.control_reporte=='curva_salarial_centro' || r.data.control_reporte=='dependientes'  || r.data.control_reporte=='detalle_aguinaldo'
){//#87 #160: se quita || r.data.control_reporte=='dependientes_edad' porq quieren en pdf y excel
							this.ocultarComponente(this.Cmp.formato_reporte);
						}

							
						//},this);
					
					  //***************************
				}else{
					this.ocultarComponente(this.Cmp.id_afp);
					this.Cmp.nombre_afp.setValue('');
                    this.Cmp.codigo_afp.setValue('');//#156
					if(r.data.tipo_reporte=='bono_descuento'){
					  this.mostrarComponente(this.Cmp.id_tipo_columna);
					  this.Cmp.id_tipo_columna.setValue('');
					  		
					  
						}
					else{ 
						//#83
						if (r.data.control_reporte=='aporte_afp' || r.data.control_reporte=='fondo_solidario'){
							
									this.mostrarComponente(this.Cmp.id_afp);
									this.Cmp.id_afp.allowBlank=false;
						}else{
							this.ocultarComponente(this.Cmp.id_afp);
							this.Cmp.id_afp.allowBlank=true;
							this.Cmp.id_afp.setValue('');
							//this.Cmp.id_tipo_contrato.allowBlank=true;
						}
						
						
						
						this.ocultarComponente(this.Cmp.id_tipo_columna);//#80
						//this.mostrarComponente(this.Cmp.id_tipo_contrato);
						if (this.Cmp.periodicidad.getValue() == 'anual') {
							this.ocultarComponente(this.Cmp.id_periodo);
							this.Cmp.id_periodo.allowBlank = true;
							this.Cmp.id_periodo.reset();					
						} else {
							this.mostrarComponente(this.Cmp.id_periodo);
							this.Cmp.id_periodo.allowBlank = false;		
			
						}
						
						this.ocultarComponente(this.Cmp.fecha);
						this.ocultarComponente(this.Cmp.rango_fin);
						this.ocultarComponente(this.Cmp.rango_inicio);
						
						
						this.ocultarComponente(this.Cmp.totales);
						this.mostrarComponente(this.Cmp.formato_reporte);
						this.mostrarComponente(this.Cmp.id_uo);
						
						this.mostrarComponente(this.Cmp.id_gestion);
						if(r.data.tipo_reporte=='planilla' && r.data.multilinea=='si' ){
							this.mostrarComponente(this.Cmp.totales);
							this.Cmp.totales.allowBlank = false;	
						}else{
							this.ocultarComponente(this.Cmp.totales);
							this.Cmp.totales.setValue('no');
						}
					}
				}
				
				
				
			},this);			
			//#83
			this.Cmp.id_afp.on('select',function(c,r,i) {
				
				if(r.data.nombre!=''){
					this.Cmp.nombre_afp.setValue(r.data.nombre);
                    this.Cmp.codigo_afp.setValue(r.data.codigo);//#156
				}else{
					this.Cmp.nombre_afp.setValue('');
                    this.Cmp.codigo_afp.setValue('');//#156
				}
			},this);
			
			//#144
			this.Cmp.id_funcionario_planilla.on('select',function(c,r,i){
				
				if(this.Cmp.id_periodo.getValue()=='' || this.Cmp.id_gestion.getValue()=='' || this.Cmp.id_tipo_planilla.getValue()=='' || this.Cmp.id_tipo_contrato.getValue()==''  ){
					alert("Es necesario que los campos Tipo Planilla, Gestion y Periodo tengan datos");
				}
				
				//this.Cmp.id_funcionario_planilla.store.baseParams.id_tipo_planilla = this.Cmp.id_tipo_planilla.getValue();
				//this.Cmp.id_funcionario_planilla.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue();
				this.Cmp.id_funcionario_planilla.store.baseParams={
					id_tipo_planilla:this.Cmp.id_tipo_planilla.getValue(),
					id_periodo:this.Cmp.id_periodo.getValue(),
					id_gestion:this.Cmp.id_gestion.getValue(),
					id_tipo_contrato:this.Cmp.id_tipo_contrato.getValue(),
				}
				
				this.Cmp.id_funcionario_planilla.modificado = true;
			},this);
			
			
			
		}, successTipoPlani:function(resp){ //#107
			            Phx.CP.loadingHide();
			            
			            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			            this.Cmp.id_funcionario_planilla.reset();//#144
			            if(reg.total>0){ 
			            	
				            this.Cmp.id_gestion.setValue(reg.datos['0'].id_gestion);
				            this.Cmp.id_gestion.setRawValue(reg.datos['0'].gestion);
				            this.Cmp.id_gestion.store.baseParams.gestion_min = reg.datos['0'].min_gestion;
				            this.Cmp.id_gestion.modificado=true;
				            if (this.Cmp.periodicidad.getValue() != 'anual') {
				            	this.Cmp.id_periodo.setValue(reg.datos['0'].id_periodo);
				            	this.Cmp.id_periodo.setRawValue(reg.datos['0'].periodo);
				            	//#107
				            	this.Cmp.id_periodo.store.baseParams.id_gestion = reg.datos['0'].id_gestion;
								this.Cmp.id_periodo.modificado = true;
				            	
				            	//#144
								this.Cmp.id_funcionario_planilla.store.baseParams.id_tipo_planilla= this.Cmp.id_tipo_planilla.getValue(); //#144
				            	this.Cmp.id_funcionario_planilla.store.baseParams.id_gestion =reg.datos['0'].id_gestion; //#144
				            	this.Cmp.id_funcionario_planilla.store.baseParams.id_periodo=reg.datos['0'].id_periodo; //#144
				            	this.Cmp.id_funcionario_planilla.modificardo=true;
				            	
				            	
				            	
				            }
			            }else{
			            	this.Cmp.id_gestion.store.baseParams.gestion_min = '2000';
				            this.Cmp.id_gestion.modificado=true;
			            }
			            
			            
			           }
     				,
		tipo : 'reporte',
		clsSubmit : 'bprint'
})
</script>