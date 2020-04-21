<?php
/**
*@package pXP
*@file gen-Licencia.php
*@author  (admin)
*@date 07-03-2019 13:53:18
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 ISSUE      AUTOR       FECHA        DESCRIPCION
#114        EGS         16/04/2020  agregando parametros para Combo de Funcionario en licencia
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.LicenciaReq={
	require:'../../../sis_planillas/vista/licencia/LicenciaBase.php',
	requireclase:'Phx.vista.LicenciaBase',
	title:'Solicitud Licencia',
	nombreVista: 'LicenciaReq',
	constructor:function(config){
		this.maestro=config.maestro;
		console.log('maestro',Phx.CP.config_ini.id_funcionario);
    	//llama al constructor de la clase padre
		Phx.vista.LicenciaReq.superclass.constructor.call(this,config);
		this.finCons = true;
		this.init();
		this.iniciarEventos();
		this.load({params:{start:0, limit:this.tam_pag, nombreVista:this.nombreVista ,id_funcionario:Phx.CP.config_ini.id_funcionario ,estado:'borrador' }});
		
		this.addButton('ant_estado',
						{argument: {estado: 'anterior'},
						text:'Anterior',
		                grupo:[0,2],
						iconCls: 'batras',
						disabled:true,
						handler:this.antEstado,
						tooltip: '<b>Pasar al Anterior Estado</b>'
						});
		this.addButton('sig_estado',
						{ text:'Siguiente',
						grupo:[0,2], 
						iconCls: 'badelante', 
						disabled: true, 
						handler: this.sigEstado, 
						tooltip: '<b>Pasar al Siguiente Estado</b>'
						});
	},
	bnewGroups: [0],    
    beditGroups: [0],
    bdelGroups:  [0],
    bsaveGroups: [],
    bactGroups:  [0,1,2,3,4],
    btestGroups: [0],
    bexcelGroups: [0,1,2,3,4],
    
    gruposBarraTareas:[	{name:'borrador',title:'<H1 align="center"><i class="fa fa-eye"></i>Borrador</h1>',grupo:0,height:0},
    					{name:'vobo',title:'<H1 align="center"><i class="fa fa-eye"></i> Visto Bueno</h1>',grupo:1,height:0},
    					{name:'finalizado',title:'<H1 align="center"><i class="fa fa-eye"></i>Finalizado</h1>',grupo:1,height:0}                     
                       ],
    actualizarSegunTab: function(name, indice){
        if(this.finCons) {        	 
             //this.store.baseParams.nombre_estado= name; 
             this.store.baseParams.estado= name;
             this.store.baseParams.nombreVista = this.nombreVista ; 
             this.store.baseParams.id_funcionario = Phx.CP.config_ini.id_funcionario ;                                                     
             this.load({params:{start:0, limit:this.tam_pag}});
        }
    },	
	preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        Phx.vista.LicenciaReq.superclass.preparaMenu.call(this,n);
        this.getBoton('diagrama_gantt').enable();
		this.getBoton('btnChequeoDocumentosWf').enable();

         if (data.estado == 'borrador') {
         	this.getBoton('ant_estado').disable();
    		this.getBoton('sig_estado').enable();

         }; 
         if(data.estado == ('vobo' ||'finalizado' )){
         	this.getBoton('ant_estado').disable();
    		this.getBoton('sig_estado').disable();
         };

         

       	
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.LicenciaReq.superclass.liberaMenu.call(this);
        if(tb){
			this.getBoton('btnChequeoDocumentosWf').disable();          
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('ant_estado').disable();
    		this.getBoton('sig_estado').disable();  
        }
       return tb
    },
    iniciarEventos:function () {
	    let v_fecha = new Date();
        v_fecha = Ext.util.Format.date(v_fecha,'d/m/Y');
        this.Cmp.id_funcionario.store.baseParams.fecha = v_fecha;
    }

	}
</script>
		
		