<?php
/**
*@package pXP
*@file gen-Licencia.php
*@author  (admin)
*@date 07-03-2019 13:53:18
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.LicenciaVobo={
	require:'../../../sis_planillas/vista/licencia/LicenciaBase.php',
	requireclase:'Phx.vista.LicenciaBase',
	title:'Licencia VoBo',
	nombreVista: 'LicenciaVobo',
	constructor:function(config){
		this.maestro=config.maestro;
		console.log('maestro',this.maestro);
    	//llama al constructor de la clase padre
		Phx.vista.LicenciaVobo.superclass.constructor.call(this,config);
		this.init();
		this.finCons = true;
		this.load({params:{start:0, limit:this.tam_pag ,estado:'vobo',nombreVista: this.nombreVista,id_funcionario:Phx.CP.config_ini.id_funcionario}});
		
		this.addButton('ant_estado',
						{argument: {estado: 'anterior'},
						text:'Anterior',
		                grupo:[0,1,2],
						iconCls: 'batras',
						disabled:true,
						handler:this.antEstado,
						tooltip: '<b>Pasar al Anterior Estado</b>'
						});
		this.addButton('sig_estado',
						{ text:'Siguiente',
						grupo:[0,1,2], 
						iconCls: 'badelante', 
						disabled: true, 
						handler: this.sigEstado, 
						tooltip: '<b>Pasar al Siguiente Estado</b>'
						});
	},
	bnewGroups: [],    
    beditGroups: [],
    bdelGroups:  [],
    bsaveGroups: [],
    bactGroups:  [0,1,2,3,4],
    btestGroups: [0],
    bexcelGroups: [0,1,2,3,4],
    
    gruposBarraTareas:[	{name:'vobo',title:'<H1 align="center"><i class="fa fa-eye"></i> Visto Bueno</h1>',grupo:0,height:0},
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
        Phx.vista.LicenciaVobo.superclass.preparaMenu.call(this,n);
        this.getBoton('diagrama_gantt').enable();
		this.getBoton('btnChequeoDocumentosWf').enable();

         if (data.estado == 'borrador') {
         	this.getBoton('ant_estado').disable();
    		this.getBoton('sig_estado').enable();	

         }else{
         	this.getBoton('sig_estado').enable();
   	        this.getBoton('ant_estado').enable();	
	
         }; 
         if(data.estado == 'finalizado'){
         	this.getBoton('ant_estado').enable();
    		this.getBoton('sig_estado').disable();		
         };
         

       	
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.LicenciaVobo.superclass.liberaMenu.call(this);
        if(tb){
			this.getBoton('btnChequeoDocumentosWf').disable();          
            this.getBoton('diagrama_gantt').disable();
 			this.getBoton('ant_estado').disable();
    		this.getBoton('sig_estado').disable();	            
        }
       return tb
    },

	}
</script>
		
		