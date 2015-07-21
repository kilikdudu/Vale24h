var args = arguments[0] || {};

var ticket = args.ticket.id ? args.ticket : null;

$.prom = _.extend({}, $.prom, {
    transform : function() {
        return formatar(this);
    }
});

$.prom.set(args.ticket.promocao);

var vwInfoTicket = null;

if(ticket != null){
	MontaInfoTicket();	
}

function formatar(model) {
 	try{
		var prom = model.toJSON();
		if(prom.limitada){
			prom.qtdeDisponivel = (prom.qtdeTickets - prom.qtdeTicketsUsados) + " tickets disponíveis !";
		}else{
			prom.qtdeDisponivel = "Promoção ilimitada !";
		}
		$.btnPegaLiberaTicket.setTitle("Curti !");
		prom.lblValidade = "Válido até: " + Alloy.Globals.format.toDiaMesAno(prom.validade);
	    return prom;
	}
	catch(e){
		Alloy.Globals.onError(e.message, "formatar", "app/controllers/AprovacaoPagamento/DadosProcesso.js");
	}   
}

function MontaInfoTicket(){
	$.scrlMestre.remove($.lblNumTickets);
	$.scrlMestre.remove($.lblValidadeGeral);
	retiraBotoes();
	configuraBtnPegaLibera(false);
	vwInfoTicket = Alloy.createController("Promocao/InfoTicket", {voucher: ticket.voucher, 
		validade: ticket.validade, adquirido: ticket.dataAquisicao}).getView();
	$.scrlMestre.add(vwInfoTicket);	
	colocaBotoes();
}

function DesmontaInfoTicket(){
	retiraBotoes();
	$.scrlMestre.add($.lblNumTickets);
	$.scrlMestre.add($.lblValidadeGeral);
	configuraBtnPegaLibera(true);
	$.scrlMestre.remove(vwInfoTicket);
	colocaBotoes();
}

function configuraBtnPegaLibera(pega){
	if(pega){
		var sty = $.createStyle({
			classes: ["CustomButton"],
			apiName: 'Button',
			width: "90%",
			textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER,
			title: "Pegue um ticket !"
		});
		$.btnPegaLiberaTicket.applyProperties(sty);
	}else{
		$.btnPegaLiberaTicket.setTitle("Liberar ticket");
		$.btnPegaLiberaTicket.setBackgroundColor("#ff2828");
		$.btnPegaLiberaTicket.setBackgroundSelectedColor("#f95a5a");
	}
}

function retiraBotoes(){
	$.scrlMestre.remove($.btnVerMapa);
	$.scrlMestre.remove($.btnPegaLiberaTicket);
}
function colocaBotoes(){
	$.scrlMestre.add($.btnPegaLiberaTicket);
	$.scrlMestre.add($.btnVerMapa);
}

$.init = function(e){
	Alloy.Globals.configWindow($.winDetalhesPromocao, $);
	$.minhaTopBar.iniciar($.prom.get("nomeEmpresa"));
};


/*function montarImagens(loja_id, post){
	var imagensView = Alloy.createController("Promocao/ScrollableImgPromocao", {altura: 150, loja_id: loja_id, idPost: post}).getView();
	$.boxScrlImages.add(imagensView);
}*/

function pegaLiberaTicket(e){
	if(ticket != null){
		liberaTicket(e);
	}else{
		pegaTicket(e);
	}
}

function pegaTicket(e){
	var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
		callback: sucessPegaTicket,
		error: failPegaTicket,
		url:  Alloy.Globals.MainDomain + "api/ticket/pegaTicket", 
		metodo: "POST", 
		timeout: 120000
	});
	if(ws){
		ws.adicionaParametro({promocaoId: $.prom.get("idPromocao"), clienteId: Alloy.Globals.Cliente.at(0).get("id")});
		ws.NovoEnvia();
	}
}

function failPegaTicket(e){
	Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao tentar obter as informações da promocao.");
}

function sucessPegaTicket(e){
	var res = e.at(0).toJSON();
	if(res.sucesso){
		Alloy.Globals.Alerta("Parabéns !", "Você conseguiu adquirir um ticket !");
		ticket = res.dados;
		MontaInfoTicket();
	}else{
		Alloy.Globals.Alerta("Falhou", res.mensagem);
	}
}

function liberaTicket(e){
	var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
		callback: sucessLiberaTicket,
		error: failLiberaTicket,
		url:  Alloy.Globals.MainDomain + "api/ticket/liberaTicket", 
		metodo: "POST", 
		timeout: 120000
	});
	if(ws){
		ws.adicionaParametro({idTicket:  ticket.id});
		ws.NovoEnvia();
	}
}

function failLiberaTicket(e){
	Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao tentar obter as informações da promocao.");
}

function sucessLiberaTicket(e){
	var res = e.at(0).toJSON();
	if(res.sucesso){
		Alloy.Globals.Alerta("Parabéns !", "Você liberou este ticket !");
		ticket.status = 3;	
		$.prom.set(res.dados);
		alteraTicket();
		DesmontaInfoTicket();
	}else{
		Alloy.Globals.Alerta("Falhou", res.mensagem);
	}
}


function verMapa(e){
	var mapa = Alloy.createController("Promocao/PromocaoMapa", {nome_loja: $.prom.get("nomeLoja"), latitude: $.prom.get("latitude"), longitude: $.prom.get("longitude")});
	Alloy.Globals.Transicao.proximo(mapa, mapa.init, {});
}

function alteraTicket(){
	Ti.App.fireEvent("alteraTicket", {ticket: ticket});
}
