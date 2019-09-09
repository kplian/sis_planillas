<?php
/**
 *@package pXP
 *@file    ItemEntRec.php
 *@author  RCM
 *@date    07/08/2013
 *@description Reporte Material Entregado/Recibido
 #ISSUE                FECHA                AUTOR               DESCRIPCION
 #30    ETR            30/07/2019           MZM                 Creacion 
 * 
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.GenerarReporteFuncionario = Ext.extend(Phx.frmInterfaz, {
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
				name: 'tipo_reporte',
				fieldLabel: 'Tipo de Reporte',
				allowBlank:false,
				emptyText:'Tipo...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
	       		width: 400,	
				gwidth: 250,
				store:[
				/*['lista_empleados','1:Lista Alfabetica Empleados']
				,['lista_codigo','2:Lista Cod. Empleado']
				,['directorio_emp','3:Directorio Empleados']
				,['directorio_emp_group','4:Directorio Empleados por cargo']
				,['empleado_centro','5:Empleado x Centro']
				,['empleado_distrito','6:Empleado x Distrito']
				,*/['empleado_edad','7:Clasificacion del personal-Edad']
				,['empleado_antiguedad','8:Antiguedad de los empleados']
				,['nomina_salario','9:Nomina Salarios BC']
				,['nomina_salario1','10:Nomina Salarios CT']
				,['no_sindicato','11:Nomina Personal no Sindicalizado']
				//,['bono_empleado','12:Bonos asignados a los empleados']
				,['planilla_tributaria','13:Planilla Tributaria']
				,['nacimiento_mes','*14:Fecha Nac x Mes']
				,['nacimiento_ano','*15:Fecha Nac x Año']
				,['reserva_beneficios2','16:Beneficios Sociales - Resumen']
				,['reserva_beneficios3','17:Beneficios Sociales - Detalle']
				,['reserva_beneficios','18:Beneficios Sociales - 1 Mes']
				
				,['aporte_afp','19:Aporte AFP - Personal Vigente']
				,['personal_ret','21:Personal Retirado']
				,['personal_inc','22:Personal Incorporado']
				,['curva_salarial','25:Curva Salarial']
				,['aporte_cacsel','26:Aporte Porcentual CACSEL']
				,['aporte_sindicato','27:Aporte Porcentual Sindicato']
				,['dependientes','34:Nomina Dependientes']
				,['dependientes_edad','35:Grupo Familiar']
				,['fondo_solidario','36:Aporte AFP - Fondo Solidario']
				]
			},
				type:'ComboBox',				
				id_grupo:0,
				grid:true
		},	{
			config: {
				name: 'id_tipo_contrato',
				fieldLabel: 'Tipo Contrato',
				allowBlank: true,
				emptyText: 'Dejar en blanco para todos...',
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
	       			name: 'fecha',
	       			fieldLabel: "A fecha",
	       			gwidth: 120,	       			
	       			allowBlank:false,	
	       			maxLength:100,
	       			minLength:1,
	       			format:'d/m/Y',
	       			anchor:'80%',
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
	       			minLength:1,
	       			anchor:'50%'
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
	       			minLength:1,
	       			anchor:'50%'
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
	   			config:{
	   				name : 'id_gestion',
	   				origen : 'GESTION',
	   				fieldLabel : 'Gestion',
	   				allowBlank : false,
	   				gdisplayField : 'gestion',//mapea al store del grid
	   				gwidth : 100,
		   			renderer : function (value, p, record){return String.format('{0}', record.data['gestion']);}
	       	     },
	   			type : 'ComboRec',
	   			id_grupo : 0,
	   			filters : {	
			        pfiltro : 'ges.gestion',
					type : 'numeric'
				},
	   		   
	   			grid : true,
	   			form : true,
                bottom_filter : true
	   }
		],
		title : 'Generar Reporte',
		ActSave : '../../sis_planillas/control/FuncionarioReporte/listarFuncionarioReporte',
		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte</b>',
		constructor : function(config) {
			Phx.vista.GenerarReporteFuncionario.superclass.constructor.call(this, config);
			this.init();
			
			this.ocultarComponente(this.Cmp.rango_fin);
			this.ocultarComponente(this.Cmp.rango_inicio);
			this.ocultarComponente(this.Cmp.id_afp);
			this.ocultarComponente(this.Cmp.fecha);
			this.ocultarComponente(this.Cmp.id_gestion);
			this.ocultarComponente(this.Cmp.id_tipo_contrato);
			
			this.Cmp.tipo_reporte.on('select',function(c) {
				this.ocultarComponente(this.Cmp.id_afp);
				this.Cmp.id_afp.allowBlank=true;
				this.Cmp.id_afp.setValue('');
				
				this.ocultarComponente(this.Cmp.id_gestion);
				this.Cmp.id_gestion.allowBlank=true;
				this.Cmp.id_gestion.setValue('');
				this.Cmp.id_tipo_contrato.allowBlank=true;
				
				this.mostrarComponente(this.Cmp.fecha);
				this.Cmp.fecha.allowBlank=false;
				if (c.value=='empleado_edad' || c.value=='empleado_antiguedad' || c.value=='dependientes_edad'){
					
					this.mostrarComponente(this.Cmp.rango_fin);
					this.mostrarComponente(this.Cmp.rango_inicio);
					this.Cmp.rango_inicio.allowBlank=false;
					this.Cmp.rango_fin.allowBlank=false;
					
					this.ocultarComponente(this.Cmp.id_tipo_contrato);
					
					
				}else{  
					this.ocultarComponente(this.Cmp.rango_fin);
					this.ocultarComponente(this.Cmp.rango_inicio);
					this.Cmp.rango_inicio.allowBlank=true;
					this.Cmp.rango_fin.allowBlank=true;
					
					this.mostrarComponente(this.Cmp.id_tipo_contrato);
					
					if (c.value=='aporte_afp' || c.value=='fondo_solidario'){
						this.mostrarComponente(this.Cmp.id_afp);
						this.Cmp.id_afp.allowBlank=false;
					
					}
					
					if(c.value=='personal_ret' || c.value=='personal_inc'){
						this.mostrarComponente(this.Cmp.id_gestion);
						this.Cmp.id_gestion.allowBlank=false;
						
						
						this.ocultarComponente(this.Cmp.fecha);
						this.Cmp.fecha.allowBlank=true;
						this.Cmp.fecha.setValue('');
					}
					
					
				}
				
				
			},this);
			
			
			
			
		},
		tipo : 'reporte',
		clsSubmit : 'bprint',
		
	

})
</script>