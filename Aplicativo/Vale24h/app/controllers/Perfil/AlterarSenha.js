var args = arguments[0] || {};

$.init = function(){
	try{
		Alloy.Globals.configWindow($.winCadastro, $);
		$.minhaTopBar.iniciar("Alterar senha");
	}
	catch(e){
		Alloy.Globals.onError(e.message, "init", "app/controllers/Boletos.js");
	}
};

function atualizar(){
	Alloy.Globals.carregando();
}
