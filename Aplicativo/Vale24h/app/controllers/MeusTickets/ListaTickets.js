/**
 * @class controllers.Boletos
 * Lista boletos.
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
var args = arguments[0] || {};

var limite = 10;



var listaInfinita = Alloy.createWidget("Util", "ListaInfinita", {colecao: $.tickets, lista: $.listaTickets, 
	refreshCallback: getTickets, limite: limite});


function myRefresher(e) {
	listaInfinita.myRefresher();	
}


function sucesso(){
	try{
		$.tickets.trigger("change");
		$.ptr.hide();
		listaInfinita.reiniciarContainer();
		/*if($.promocoes.length == 0){
			$.minhaListaMedicoes.setOpacity(0);
			$.lblEmpty.setOpacity(1);
		}
		else{
			$.lblEmpty.setOpacity(0);
			$.minhaListaMedicoes.setOpacity(1);
		}*/
	}
	catch(e){
		Alloy.Globals.onError(e.message, "sucesso", "app/controllers/Medicao/ListaMedicao.js");
	}
}

function adicionarRegistros(ret){
	listaInfinita.adicionarRegistros(ret.toJSON());
}


function iniciar(){
	try{
		getTickets({semLoader: false, limite: limite, cursor: 0});	
	}
	catch(e){
		Alloy.Globals.onError(e.message, "open", "app/controllers/Medicao/ListaMedicao.js");
	}
};


function getTickets(parans){
	try{
		var limit = parans.limite;
		var semLoader = parans.semLoader;
		var cursor = parans.cursor;
		if(cursor > 0){
			listaInfinita.iniciarLoader();
		}
		var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
			callback: cursor==0?sucesso:adicionarRegistros,
			error: function(e){Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao obter as promoções, tente novamente mais tarde.");},
			url:  Alloy.Globals.MainDomain + "api/ticket/getMeusTickets", 
			metodo: "POST", 
			timeout: 120000,
			colecao: cursor==0?$.tickets:undefined,
			semLoader: semLoader
		});
		if(ws){
			ws.adicionaParametro({clienteId: Alloy.Globals.Cliente.at(0).get("id"), limite: limit, cursor: cursor});
			ws.NovoEnvia();
		}
	}
	catch(e){
		Alloy.Globals.onError(e.message, "getContratosMedicao", "app/controllers/Medicao/ListaMedicao.js");
	}
}


function formatar(model){
	try{
		var tic = model.toJSON();
		tic.lblAdquirido = "Adquirido em " + Alloy.Globals.format.toDiaMesAno(tic.dataAquisicao);
		var dataValidade = Alloy.Globals.format.generateCustomData(tic.validade, "");
		tic.lblValidade = "Válido até: " + dataValidade.Dia + "/" + dataValidade.Mes + "/" + dataValidade.Ano + " as " + dataValidade.Hora + ":" + dataValidade.Minuto + ":" + dataValidade.Segundo;	
		
		if(tic.promocao.limitada){
			tic.limitada = true;
			tic.mostraVoucher = Ti.UI.SIZE;
			tic.lblVoucher = "Código: " + tic.voucher;	
			tic.lblQtdeTickets = tic.promocao.qtdeTicketsUsados + " pessoas também pegaram este ticket.";
			tic.descLiberaTicket = "Liberar ticket";
		}else{
			tic.limitada = false;
			tic.mostraVoucher = 0;	
			tic.lblQtdeTickets = tic.promocao.qtdeTicketsUsados + " pessoas também curtiram essa promoção.";
			tic.descLiberaTicket = "Descurtir";
		}
		
		//Verificar remendo !
		tic.lblImagemEmpresa = tic.promocao.imagemEmpresa;
		tic.lblNomeEmpresa = tic.promocao.nomeEmpresa;
		tic.lblUrlImagem = tic.promocao.urlImagem;
		tic.lblDescricao = tic.promocao.descricao;
		tic.latitude = tic.promocao.latitude;
		tic.longitude = tic.promocao.longitude;
		return tic;	
	}
	catch(e){
		Alloy.Globals.onError(e.message, "formatar", "app/controllers/Boletos.js");
	}
}


function verMais(e){
	try{
		if(e.row.tipo == "atualizar"){
			listaInfinita.mostrarMais();
		}
		return;
	}
	catch(e){
		Alloy.Globals.onError(e.message, "detalhar", "app/controllers/Boletos.js");
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
		ws.adicionaParametro({idTicket:  e.source.ticketId});
		ws.NovoEnvia();
	}
}

function failLiberaTicket(e){
	Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao tentar obter as informações da promocao.");
}

function sucessLiberaTicket(e){
	var res = e.at(0).toJSON();
	if(res.sucesso){
		if(res.dados.promocao.limitada){
			Alloy.Globals.Alerta("Parabéns !", "Você liberou este ticket !");
		}else{
			apagaPromocaoLista(res.dados.id);
		}
	}else{
		Alloy.Globals.Alerta("Falhou", res.mensagem);
	}
}

function apagaPromocaoLista(ticketId){
	var md = $.tickets.where({id: ticketId})[0];
	$.tickets.remove(md);
	//listaInfinita.reiniciarContainer();
}

function verMapa(e){
	var mapa = Alloy.createController("Promocao/PromocaoMapa", {nome_loja: e.source.nomeLoja, latitude: e.source.latitude, longitude: e.source.longitude});
	Alloy.Globals.Transicao.proximo(mapa, mapa.init, {});
}

//Inicio o processo;
iniciar();

Ti.App.addEventListener("novoTicket", iniciar);
