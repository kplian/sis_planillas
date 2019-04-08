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
Phx.vista.Licencia={
	require:'../../../sis_planillas/vista/licencia/LicenciaBase.php',
	requireclase:'Phx.vista.LicenciaBase',
	title:'Licencia',
	nombreVista: 'Licencia',
	constructor:function(config){
		this.maestro=config.maestro;
		console.log('maestro',this.maestro.id_funcionario);
		this.Atributos[this.getIndAtributo('id_funcionario')].valorInicial = this.maestro.id_funcionario;
    	//llama al constructor de la clase padre
		Phx.vista.Licencia.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista , id_funcionario:this.maestro.id_funcionario}});
		
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
	preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        Phx.vista.Licencia.superclass.preparaMenu.call(this,n);
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
        var tb = Phx.vista.Licencia.superclass.liberaMenu.call(this);
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
		
		