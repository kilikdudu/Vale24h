var args = arguments[0] || {};

var btnFiltrar = null;

var categorias = Alloy.createCollection("Categoria");

var listaCategorias= Alloy.createWidget("GUI", "PopUpList");

$.init = function(){
	try{
		Alloy.Globals.configWindow($.winPrincipal, $);
		$.minhaTopBar.iniciar("Vale24h");
		btnFiltrar = $.minhaTopBar.addRightButtom("/images/categoria.png", filtro);
		$.minhaTopBar.enableFilter($);
		listaCategorias.init("Categorias", categorias, ["id"], "descricao", setCategoria);
	}
	catch(e){
		Alloy.Globals.onError(e.message, "init", "app/controllers/AprovacaoPagamento/DetalhesProcessoDePagamento.js");
	} 
};

function filtro(e){
	var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
		callback: sucessFiltro,
		error: failFiltro,
		url:  Alloy.Globals.MainDomain + "api/categorias/getCategorias", 
		metodo: "POST", 
		timeout: 120000,
		colecao: categorias
	});
	if(ws){
		ws.NovoEnvia();
	}
}

function sucessFiltro(e){
	categorias.trigger("change");
	listaCategorias.show();
}

function failFiltro(e){
	Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao obter as categorias, tente novamente mais tarde.");
}

function setCategoria(texto, chave){
	$.trigger("categoria", {id: chave, descricao: texto});
}


$.winPrincipal.addEventListener("open", function(e){
	var Posts = Alloy.createController("Promocao/ListaPromocoes", {pai: $});
	var MeusTickets = Alloy.createController("MeusTickets/ListaTickets", {pai: $});
	$.minhaScrollable.init([Posts.getView(), MeusTickets.getView()], ["Promoções", "Tickets"], {cacheSize: 3});
});
