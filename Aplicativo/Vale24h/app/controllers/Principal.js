var args = arguments[0] || {};



$.init = function(){
	try{
		Alloy.Globals.configWindow($.winPrincipal, $);
	}
	catch(e){
		Alloy.Globals.onError(e.message, "init", "app/controllers/AprovacaoPagamento/DetalhesProcessoDePagamento.js");
	} 
};

$.winPrincipal.addEventListener("open", function(e){
	var Posts = Alloy.createController("Promocao/ListaPromocoes");
	var DadosPessoa = Alloy.createController("DadosPessoa");
	var MeusTickets = Alloy.createController("MeusTickets/ListaTickets");
	$.minhaScrollable.init([DadosPessoa.getView(), Posts.getView(), MeusTickets.getView()], ["Perfil", "Promoções", "Tickets"], {cacheSize: 3});
	$.minhaScrollable.setViewIndex(1);
});
