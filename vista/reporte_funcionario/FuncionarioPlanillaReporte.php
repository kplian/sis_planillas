<?php
/**
*@package pXP
*@file FuncionarioPlanillaReporte.php
*@author KPLIAN (admin)
*@date 14-02-2011
*@description  Vista para registrar los datos de un funcionario
 * 
    HISTORIAL DE MODIFICACIONES:  
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION  
  #16            04/07/2019        	  EGS                 creacion
*/ 

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FuncionarioPlanillaReporte=function(config){



	this.Atributos=[
	       	{
	       		// configuracion del componente
	       		config:{
	       			labelSeparator:'',
	       			inputType:'hidden',
	       			name: 'id_funcionario'
	       		}, 
	       		type:'Field',
	       		form:true  
	       		
	       	},

	       	{
	       		config:{
	       			fieldLabel: "Código",
	       			gwidth: 120,
	       			name: 'codigo',
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
			    filters:{pfiltro:'rfu.codigo',type:'string'},
				bottom_filter : true,
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			fieldLabel: "C.I.",
	       			gwidth: 120,
	       			name: 'ci',
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.ci',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       {
	       		config:{
	       			name: 'desc_funcionario1',
	       			fieldLabel: "Nombre Completo 1",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.desc_funcionario1',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	      {
	       		config:{
	       			name: 'desc_funcionario2',
	       			fieldLabel: "Nombre Completo 2",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.desc_funcionario2',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	 {
	       		config:{
	       			name: 'num_doc',
	       			fieldLabel: "Numero Documento",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'NumberField',
				filters:{pfiltro:'rfu.num_doc',type:'numeric'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       		       	
	       	{
	       		config:{
	       			name: 'fecha_asignacion',
	       			fieldLabel: "Fecha de Asignacion",
	       			gwidth: 120,	       			
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			format:'d/m/Y',
	       			anchor:'100%',
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
	       			name: 'fecha_finalizacion',
	       			fieldLabel: "Fecha de Finalizacion",
	       			gwidth: 120,	       			
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			format:'d/m/Y',
	       			anchor:'100%',
	       			renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
				},
	       		type:'DateField',
				filters:{pfiltro:'rfu.fecha_finalizacion',type:'date'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	 {
	       		config:{
	       			name: 'codigo_cargo',
	       			fieldLabel: "Codigo Cargo",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.codigo_cargo',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'nombre_cargo',
	       			fieldLabel: "Nombre Cargo",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		id_grupo:0,
				filters:{pfiltro:'rfu.nombre_cargo',type:'string'},
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'observaciones_finalizacion',
	       			fieldLabel: "Observacion Finalizacion",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		id_grupo:0,
				filters:{pfiltro:'rfu.observaciones_finalizacion',type:'string'},
	       		grid:true,
	       		form:true
	       	},
	         {
	       		config:{
	       			name: 'nro_documento_asignacion',
	       			fieldLabel: "Nro. Doc. Asignacion",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		id_grupo:0,
				filters:{pfiltro:'rfu.nro_documento_asignacion',type:'string'},
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'fecha_documento_asignacion',
	       			fieldLabel: "Fecha Doc. Asignacion",
	       			gwidth: 120,	       			
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			format:'d/m/Y',
	       			anchor:'100%',
	       			renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
				},
	       		type:'DateField',
	       		filters:{type:'date'},
				filters:{pfiltro:'rfu.fecha_documento_asignacion',type:'date'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'tipo',
	       			fieldLabel: "Tipo",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.tipo',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'text',
	       			fieldLabel: "Text",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.text',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'nombre_lugar',
	       			fieldLabel: "Nombre Lugar",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		id_grupo:0,
				filters:{pfiltro:'rfu.nombre_lugar',type:'string'},
	       		grid:true,
	       		form:true
	       	},
	       {
	       		config:{
	       			name: 'codigo_gerencia',
	       			fieldLabel: "Codigo Gerencia",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.codigo_gerencia',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'nombre_unidad_gerencia',
	       			fieldLabel: "Nombre Uni. Gerencia",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.nombre_unidad_gerencia',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'codigo_uo_pre',
	       			fieldLabel: "Codigo Uo Pre.",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.codigo_uo_pre',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'nombre_uo_pre',
	       			fieldLabel: "Nombre Uo. Pre",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.nombre_uo_pre',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       {
	       		config:{
	       			name: 'codigo_uo_centro',
	       			fieldLabel: "Codigo Uo Centro",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.codigo_uo_centro',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       {
	       		config:{
	       			name: 'nombre_uo_centro',
	       			fieldLabel: "Nombre Uo Centro",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.nombre_uo_centro',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'firma',
	       			fieldLabel: "Firma",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.firma',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'interno',
	       			fieldLabel: "Interno",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		id_grupo:0,
				filters:{pfiltro:'rfu.interno',type:'string'},
	       		grid:true,
	       		form:true
	       	},
	       	{
				config:{
					name: 'id_biometrico',
					fieldLabel: 'ID Biométrico',
					allowBlank: true,
					anchor: '100%',
					disabled: true,
					style: 'color: blue; background-color: yellow;',
					gwidth: 100,
					maxLength:15
				},
				type:'NumberField',
				filters:{pfiltro:'rfu.id_biometrico',type:'numeric'},
				grid:true,
				form:true
			},
	       	{	
	       		config:{
	       			fieldLabel: "Correo Empresarial",
	       			gwidth: 120,
	       			name: 'email_empresa',
	       			allowBlank:true,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.email_empresa',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'telefono_ofi',
	       			fieldLabel: "Telf. Oficina",
	       			gwidth: 120,
	       			allowBlank:true,	
	       			maxLength:50,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.telefono_ofi',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'codigo_rciva',
	       			fieldLabel: "Codigo Rc-Iva",
	       			gwidth: 120,
	       			allowBlank:true,	
	       			maxLength:50,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.codigo_rciva',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'profesion',
	       			fieldLabel: "Profesion",
	       			gwidth: 120,
	       			allowBlank:true,	
	       			maxLength:50,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.profesion',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'nombre_afp',
	       			fieldLabel: "Nombre Afp",
	       			gwidth: 120,
	       			allowBlank:true,	
	       			maxLength:50,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.nombre_afp',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       {
	       		config:{
	       			name: 'nro_afp',
	       			fieldLabel: "Nro Afp",
	       			gwidth: 120,
	       			allowBlank:true,	
	       			maxLength:50,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.nro_afp',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       {
	       		config:{
	       			name: 'tipo_jubilado',
	       			fieldLabel: "Tipo Jubilado",
	       			gwidth: 120,
	       			allowBlank:true,	
	       			maxLength:50,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.tipo_jubilado',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
				config:{
					name: 'edad',
					fieldLabel: 'Edad',
					allowBlank: true,
					anchor: '100%',
					disabled: true,
					style: 'color: blue; background-color: yellow;',
					gwidth: 100,
					maxLength:15
				},
				type:'NumberField',
				filters:{pfiltro:'rfu.edad',type:'numeric'},
				grid:true,
				form:true
			},
				       	
	       	{
	       		config:{
	       			fieldLabel: "Carnet Discapacitado",
	       			gwidth: 120,
	       			name: 'carnet_discapacitado',
	       			allowBlank:true,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%',
					hidden:true
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.carnet_discapacitado',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			fieldLabel: "Celular Personal",
	       			gwidth: 120,
	       			name: 'celular_personal',
	       			allowBlank:true,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%',
					hidden:true
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.celular_personal',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},	
	       {
	       		config:{
	       			fieldLabel: "Correo Personal",
	       			gwidth: 120,
	       			name: 'correo_personal',
	       			allowBlank:true,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%',
					hidden:true
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.correo_personal',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},		       		       	
	       	{
	       		config:{
	       			name:'estado_civil',
	       			fieldLabel:'Estado Civil',
	       			allowBlank:true,
	       			emptyText:'Estado...',
	       			
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',	       		    
	       		    store:['soltero','casado','divorciado','viudo']
	       		    
	       		},
	       		type:'ComboBox',
				filters:{pfiltro:'rfu.estado_civil',type:'string'},
	       		id_grupo:0,
	       		grid:true,	       		
	       		form:true
	       	},
	       	 {
	       		config:{
	       			fieldLabel: "Expedido",
	       			gwidth: 120,
	       			name: 'expedicion',
	       			allowBlank:true,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%',
					hidden:true
	       		},
	       		type:'TextField',
	       		id_grupo:0,
				filters:{pfiltro:'rfu.expedicion',type:'string'},
	       		grid:true,
	       		form:true
	       	},	
	       	
	       	{
	       		config:{
	       			name:'genero',
	       			fieldLabel:'Genero',
	       			allowBlank:true,
	       			emptyText:'Genero...',
	       			
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',	       		    
	       		    store:['masculino','femenino']
	       		    
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		filters:{	
	       		         type: 'list',
	       				 options: ['masculino','femenino']
	       		 	},
	       		grid:true,       		
	       		form:true
	       	},
	       {
	       		config:{
	       			fieldLabel: "Direccion",
	       			gwidth: 120,
	       			name: 'direccion',
	       			allowBlank:true,	
	       			maxLength:100,
	       			minLength:1,
	       			anchor:'100%',
					hidden:true
	       		},
	       		type:'TextField',
				filters:{pfiltro:'rfu.direccion',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},	
	       	
	       	
	       	{
	       		config:{
	       			fieldLabel: "Fecha de Nacimiento",
	       			gwidth: 120,
	       			name: 'fecha_nacimiento',
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			format:'d/m/Y',
	       			anchor:'100%',
	       			renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
				},
	       		type:'DateField',
				filters:{pfiltro:'rfu.fecha_nacimiento',type:'date'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	        {
	       		config:{
	       			name: 'ano_nacimiento',
	       			fieldLabel: "Año Nacimiento",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'NumberField',
				filters:{pfiltro:'rfu.ano_nacimiento',type:'numeric'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'mes_nacimiento',
	       			fieldLabel: "Mes Nacimiento",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		filters:{pfiltro:'rfu.mes_nacimiento',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'codigo_tipo_contrato',
	       			fieldLabel: "Cod Tip Contr",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		filters:{pfiltro:'rfu.codigo_tipo_contrato',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'nombre_tipo_contrato',
	       			fieldLabel: "Tip Contr",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		filters:{pfiltro:'rfu.nombre_tipo_contrato',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	{
	       		config:{
	       			name: 'tipo_asignacion',
	       			fieldLabel: "Tipo Asign",
	       			gwidth: 200,	       			
	       			allowBlank:false,	
	       			maxLength:150,
	       			minLength:1,
	       			anchor:'100%'
	       		},
	       		type:'TextField',
	       		filters:{pfiltro:'rfu.tipo_asignacion',type:'string'},
	       		id_grupo:0,
	       		grid:true,
	       		form:true
	       	},
	       	
	       	{
	       		config:{
	       			name:'estado_reg',
	       			fieldLabel:'Estado',
	       			allowBlank:false,
	       			emptyText:'Estado...',
	       			
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    valueField: 'estado_reg',
	       		   // displayField: 'descestilo',
	       		    store:['activo','inactivo']
	       		    
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		filters:{	
	       		         type: 'list',
	       		         pfiltro:'FUNCIO.estado_reg',
	       				 dataIndex: 'size',
	       				 options: ['activo','inactivo'],	
	       		 	},
	       		grid:true,
	       		form:true
	       	},
       	
	       	];
	 
	 
     	this.initButtons=[this.cmbGestion, this.cmbPeriodo];       	
	
	    Phx.vista.FuncionarioPlanillaReporte.superclass.constructor.call(this,config);
		this.maestro = config.data;
		this.init();
		this.getParamCookies();
		
		
	}

	Ext.extend(Phx.vista.FuncionarioPlanillaReporte,Phx.gridInterfaz,{
			savePltGrid: true, 
		    applyPltGrid: true, 
		    bottom_filter: true,
		    egrid: false,
		    tipoStore: 'GroupingStore',//GroupingStore o JsonStore #24
		    remoteGroup: true,
		    groupField: 'codigo_uo_centro',
		    viewGrid: new Ext.grid.GroupingView({
		            forceFit:false,
		            //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
		        }), //#24
		    
		    
			title:'Funcionarios',
			///ActSave:'../../sis_organigrama/control/Funcionario/guardarFuncionario',
			//ActDel:'../../sis_organigrama/control/Funcionario/eliminarFuncionario',
			ActList:'../../sis_planillas/control/FuncionarioPlanillaReporte/listarFuncionarioPlanillaReporte',
			id_store:'id_funcionario',
			fields: [
		         {name:'id_funcionario',type: 'numeric'},
		         {name:'ci', type: 'string'},
		         {name:'codigo', type: 'string'},
		         {name:'desc_funcionario1', type: 'string'},
		         {name:'desc_funcionario2', type: 'string'},
		         {name:'num_doc',type: 'numeric'},
		         {name:'fecha_asignacion',type: 'date', dateFormat:'Y-m-d'},
		         {name:'fecha_finalizacion',type: 'date', dateFormat:'Y-m-d'},                                                                       
		         {name:'id_cargo',type: 'numeric'},
		         {name:'codigo_cargo', type: 'string'},
		         {name:'nombre_cargo', type: 'string'},
		         {name:'observaciones_finalizacion', type: 'string'},
		         {name:'nro_documento_asignacion', type: 'string'},
		         {name:'fecha_documento_asignacion',type: 'date', dateFormat:'Y-m-d'},
		         {name:'tipo', type: 'string'},
		         {name:'text', type: 'string'},                             
		         {name:'id_uo_funcionario',type: 'numeric'},
		         {name:'id_uo',type: 'numeric'},
		         {name:'nombre_lugar', type: 'string'},
		         {name:'codigo_gerencia', type: 'string'},
		         {name:'nombre_unidad_gerencia', type: 'string'},
		         {name:'codigo_uo_pre', type: 'string'},
		         {name:'nombre_uo_pre', type: 'string'},
		         {name:'codigo_uo_centro', type: 'string'},
		         {name:'nombre_uo_centro', type: 'string'},
		         {name:'firma', type: 'string'},
		         {name:'interno', type: 'string'},
		         {name:'id_biometrico',type: 'numeric'},
		         {name:'email_empresa', type: 'string'},
		         {name:'telefono_ofi', type: 'string'},
		         {name:'codigo_rciva', type: 'string'},
		         {name:'profesion', type: 'string'},
		         {name:'id_afp',type: 'numeric'},
		         {name:'nombre_afp', type: 'string'},
		         {name:'nro_afp', type: 'string'},
		         {name:'tipo_jubilado', type: 'string'},
		         {name:'edad',type: 'numeric'},
		         {name:'carnet_discapacitado', type: 'string'},
		         {name:'celular_personal', type: 'string'},
		         {name:'correo_personal', type: 'string'},
		         {name:'estado_civil', type: 'string'},
		         {name:'expedicion', type: 'string'},
		         {name:'genero', type: 'string'},
		         {name:'direccion', type: 'string'},
		         {name:'fecha_nacimiento',type: 'date', dateFormat:'Y-m-d'},
		         {name:'ano_nacimiento',type: 'numeric'},
		         {name:'mes_nacimiento', type: 'string'},
		         {name:'estado_reg', type: 'string'},
		         {name:'fecha_reg',type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		         {name:'fecha_mod',type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		         {name:'id_usuario_reg',type: 'numeric'},
		         {name:'id_usuario_mod',type: 'numeric'},
		         'uo_centro_orden','nombre_tipo_contrato','codigo_tipo_contrato','tipo_asignacion'
			],
			sortInfo:{
				field: 'id_funcionario',
				direction: 'ASC'
			},
		
			bnew:false,
			bedit:false,
			bdel:false,
			bsave:false,
			fwidth: 500,
			fheight: 480,
			
			iniciarEventos: function (){
					var me = this;	
					
					this.cmbGestion.on('select', function(combo, record, index){
						    this.cmbPeriodo.enable();
						    this.cmbPeriodo.reset();
						    this.store.removeAll();
						    me.store.baseParams.id_gestion = this.cmbGestion.getValue();
						    this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
						    this.cmbPeriodo.modificado = true;						    
						    Ext.state.Manager.set( this.grid.stateId+'_id_gestion', this.cmbGestion.getValue() );//grava en cookies la gestion
						    
				        },this);
					        
		        	this.cmbPeriodo.on('select', function( combo, record, index){						
						Ext.state.Manager.set(this.grid.stateId+'_id_periodo', this.cmbPeriodo.getValue());//grava en cookies el periodo
						me.store.baseParams.id_periodo = this.cmbPeriodo.getValue();	
						this.capturaFiltros();						
		        	},this);

		            
		        	
		   },
		   
		   
		   getParamCookies:function(){
					 var p_id_gestion = Ext.state.Manager.getProvider().get(this.grid.stateId+'_id_gestion');
					 var p_id_periodo = Ext.state.Manager.getProvider().get(this.grid.stateId+'_id_periodo');
					 var me = this;
					 
					 	     			       
				     if(p_id_gestion && p_id_periodo){
				             
				             this.cmbGestion.store.load({params:{start:0,limit:this.tam_pag, },
			                                   callback : function (r) { 
			                                                 this.cmbGestion.setValue(p_id_gestion)
			                                                 me.store.baseParams.id_gestion = p_id_gestion;
			                                                 this.cmbPeriodo.store.load({params:{start:0,limit:this.tam_pag},
								                                   callback : function (r) { 
								                                        this.cmbPeriodo.setValue(p_id_periodo);
								                                        me.store.baseParams.id_periodo = p_id_periodo;	    
								                                       	this.cmbPeriodo.enable();
								                                        this.capturaFiltros();
								                                        this.iniciarEventos();                
								                                    }, scope : this
								                                }); 
			                                             }, 
			                                    scope : this
			                                });
			                 this.cmbPeriodo.store.baseParams.id_gestion = p_id_gestion;               
			                 
			                               
	                                
	               }
	               else{	               	
	              	   this.iniciarEventos();
	               }
	       
			},
			
		   setHeaderRep: function(params){		
				var selectPltValue = this.cmbPltGrid.getValue();
				if(selectPltValue){		   
					params.titulo = this.cmbPltGrid.getStore().getById(selectPltValue).data.nombre;
				}				
				params.titulo2 =   this.cmbPeriodo.getRawValue()  + ' ' + this.cmbGestion.getRawValue();
				return  params;	
			},
		
			
			redireccionUrl : function(url) {				
				 window.location.assign(url);
			},
			
			capturaFiltros:function(combo, record, index){
		        this.desbloquearOrdenamientoGrid();
		        if(this.validarFiltros()){
		        	this.store.baseParams.id_gestion = this.cmbGestion.getValue();
			        this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();	        
			        this.load(); 
		        }
		        
		    },
		    
			reload: function(p) {
			     var SelMod = this.sm;	    
			     SelMod.fireEvent('rowdeselect',SelMod); //RAC 06/06/2017 para que libere menu antes de acualizar
			     //tiene el filtro aplicado 
			     if(this.gfilter){
				     if(!this.gfilter.getFilterData()[0]){
				    	this.getBoton('act').setIconClass('bact') ;
				    }
			     }	 
			   
				if(!this.store.lastOptions){
					this.store.lastOptions = {};
				}
				this.store.lastOptions.scope = this;
				this.store.lastOptions.callback = function(r,opt,suc){
					if(suc){
						if(SelMod.hasSelection()){
							SelMod.fireEvent('rowselect',SelMod);
						}
						else
						{    
							SelMod.fireEvent('rowdeselect',SelMod);
						    
						}				
					}
				}		
				this.capturaFiltros();
		    },
		    
		    
		    validarFiltros:function(){		    	
		        if(this.cmbGestion.validate() && this.cmbPeriodo.validate()){
		            this.desbloquearOrdenamientoGrid();
		            return true;
		        }
		        else{
		            this.bloquearOrdenamientoGrid();
		            return false;
		        }
		        
		        
		    },
			
			preparaMenu:function()
		    {	
		        Phx.vista.FuncionarioPlanillaReporte.superclass.preparaMenu.call(this);
		    },
		    liberaMenu:function()
		    {	
		        Phx.vista.FuncionarioPlanillaReporte.superclass.liberaMenu.call(this);
		    },
			
			
			cmbGestion: new Ext.form.ComboBox({
						fieldLabel: 'Gestion',
						allowBlank: false,
						emptyText:'Gestion...',
						blankText: 'Año',
						store:new Ext.data.JsonStore(
						{
							url: '../../sis_parametros/control/Gestion/listarGestion',
							id: 'id_gestion',
							root: 'datos',
							sortInfo:{
								field: 'gestion',
								direction: 'DESC'
							},
							totalProperty: 'total',
							fields: ['id_gestion','gestion'],
							// turn on remote sorting
							remoteSort: true,
							baseParams:{par_filtro:'gestion'}
						}),
						valueField: 'id_gestion',
						triggerAction: 'all',
						displayField: 'gestion',
					    hiddenName: 'id_gestion',
		    			mode:'remote',
						pageSize:50,
						queryDelay:500,
						listWidth:'280',
						width:80
					}),
			
			
		     cmbPeriodo: new Ext.form.ComboBox({
						fieldLabel: 'Periodo',
						allowBlank: false,
						blankText : 'Mes',
						emptyText:'Periodo...',
						store:new Ext.data.JsonStore(
						{
							url: '../../sis_parametros/control/Periodo/listarPeriodo',
							id: 'id_periodo',
							root: 'datos',
							sortInfo:{
								field: 'periodo',
								direction: 'ASC'
							},
							totalProperty: 'total',
							fields: ['id_periodo','periodo','id_gestion','literal'],
							// turn on remote sorting
							remoteSort: true,
							baseParams:{par_filtro:'gestion'}
						}),
						valueField: 'id_periodo',
						triggerAction: 'all',
						displayField: 'literal',
					    hiddenName: 'id_periodo',
		    			mode:'remote',
						pageSize:50,
						disabled: true,
						queryDelay:500,
						listWidth:'280',
						width:80
					}),
			

		  
		 
})
</script>
