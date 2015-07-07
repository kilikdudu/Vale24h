var args = arguments[0] || {};

var ticket = args.ticket;

$.prom = _.extend({}, $.prom, {
    transform : function() {
        return formatar(this);
    }
});

$.prom.set(ticket.promocao);

if(ticket.voucher != null){
	MontaInfoTicket();	
}

function formatar(model) {
 	try{
		var prom = model.toJSON();
		prom.qtdeDisponivel = (prom.qtdeTickets - prom.qtdeTicketsUsados) + " tickets disponíveis !";
		prom.lblValidade = "Válido até: " + Alloy.Globals.format.NetDateTimeToDiaMesAno(prom.validade);
	    return prom;
	}
	catch(e){
		Alloy.Globals.onError(e.message, "formatar", "app/controllers/AprovacaoPagamento/DadosProcesso.js");
	}   
}

function MontaInfoTicket(){
	$.scrlMestre.remove($.btnPegaTicket);
	$.scrlMestre.remove($.lblNumTickets);
	$.scrlMestre.remove($.lblValidadeGeral);
	$.scrlMestre.remove($.btnVerMapa);
	var vwInfoTicket = Alloy.createController("Promocao/InfoTicket", {voucher: ticket.voucher, 
		validade: Alloy.Globals.format.NetDateTimeToDiaMesAno(ticket.validade), adquirido: Alloy.Globals.format.NetDateTimeToDiaMesAno(ticket.dataAquisicao)}).getView();
	$.scrlMestre.add(vwInfoTicket);	
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

function pegaTicket(promocaoId){
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
		$.lblNumTickets.setText("Você já possuí este ticket !");
		Alloy.Globals.Alerta("Parabéns !", "Você conseguiu adquirir um ticket !");
		ticket = res.dados;
		MontaInfoTicket();
	}else{
		$.lblNumTickets.setText("Você não conseguiu adquirir este ticket !");
		Alloy.Globals.Alerta("Falhou", res.mensagem);
	}
	$.scrlMestre.remove($.btnPegaTicket);
}

function verMapa(e){
	var mapa = Alloy.createController("Promocao/PromocaoMapa", {nome_loja: $.prom.get("nomeLoja"), latitude: $.prom.get("latitude"), longitude: $.prom.get("longitude")});
	Alloy.Globals.Transicao.proximo(mapa, mapa.init, {});
}
