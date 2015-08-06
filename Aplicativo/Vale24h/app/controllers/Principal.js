var args = arguments[0] || {};



$.init = function(){
	try{
		Alloy.Globals.configWindow($.winPrincipal, $);
		$.minhaTopBar.iniciar("Vale24h");
	}
	catch(e){
		Alloy.Globals.onError(e.message, "init", "app/controllers/AprovacaoPagamento/DetalhesProcessoDePagamento.js");
	} 
};

$.winPrincipal.addEventListener("open", function(e){
	var Posts = Alloy.createController("Promocao/ListaPromocoes");
	var MeusTickets = Alloy.createController("MeusTickets/ListaTickets");
	$.minhaScrollable.init([Posts.getView(), MeusTickets.getView()], ["Promoções", "Tickets"], {cacheSize: 3});
});
