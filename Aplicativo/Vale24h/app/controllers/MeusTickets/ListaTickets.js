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
		tic.mostraMapa = 140;
		tic.mostraLibera = 140;
		tic.mostraValidade = Titanium.UI.SIZE;
		
		if(tic.promocao.limitada){
			tic.limitada = true;
			tic.mostraVoucher = Ti.UI.SIZE;	
			tic.lblQtdeTickets = (tic.promocao.qtdeTickets - tic.promocao.qtdeTicketsUsados) + " tickets restantes.";
			tic.imgList = "/images/ticketList.png";
			switch(tic.status){
				case 0: //Em aberto
					tic.lblVoucher = "Ticket: " + tic.voucher;
					tic.colorVoucher = Alloy.Globals.MainColor;
					tic.imgTicket = "/images/ticket.png";
					tic.descLiberaTicket = "Liberar ticket";
					tic.imgLibera = "/images/x.png";
					break;
				case 1: //Utilizado
					tic.lblVoucher = "Ticket utilizado !";
					tic.colorVoucher = Alloy.Globals.MainColor;
					tic.imgTicket = "/images/ticket.png";
					tic.mostraLibera = "0";
					tic.mostraValidade = 0;
					break;
				case 2: //Expirado
					tic.lblVoucher = "Ticket expirado.";
					tic.colorVoucher = "#ee3624";
					tic.imgTicket = "/images/ticket_red.png";
					tic.mostraLibera = "0";
					break;
				case 3: //Desistiu
					tic.lblVoucher = "Você desistiu desse ticket.";
					tic.colorVoucher = "#ee3624";
					tic.imgTicket = "/images/ticket_red.png";
					tic.descLiberaTicket = "Pegar";
					tic.imgLibera = "/images/ticket.png";
					tic.mostraValidade = 0;
					break;		
			}
			
		}else{
			tic.limitada = false;
			tic.mostraVoucher = 0;	
			tic.lblQtdeTickets = tic.promocao.qtdeTicketsUsados + " curtidas.";
			tic.descLiberaTicket = "Descurtir";
			tic.imgLibera = "/images/dislike.png";
			tic.imgList = "/images/like.png";
		}
		
		//Verificar remendo !
		tic.idPromocao = tic.promocao.idPromocao;
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

function ticketLiberaRenova(e){
	if(e.source.dados.status == 3  && e.source.dados.limitada ){
		renovaTicket(e);
	}
	else if(e.source.dados.status == 0 || !e.source.dados.limitada){
		liberaTicket(e);
	}
}

function liberaTicket(e){
	function confirmaLiberaTicket(){
		var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
			callback: sucessLiberaTicket,
			error: failLiberaTicket,
			url:  Alloy.Globals.MainDomain + "api/ticket/liberaTicket", 
			metodo: "POST", 
			timeout: 120000
		});
		if(ws){
			ws.adicionaParametro({idTicket:  e.source.dados.ticketId});
			ws.NovoEnvia();
		}
	}
	if(e.source.dados.limitada){
		var alerta = Alloy.createWidget("GUI", "Mensagem");
		alerta.init("Atenção", "Gostaria de liberar este ticket ?\nApós liberar este ticket, você só poderá pegar este ticket novamente após 24 horas.", true);
		alerta.show({callback: confirmaLiberaTicket});
	}else{
		confirmaLiberaTicket();
	}
}

function failLiberaTicket(e){
	Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao tentar liberar o ticket.");
}

function sucessLiberaTicket(e){
	var res = e.at(0).toJSON();
	if(res.sucesso){
		if(res.dados.promocao.limitada){
			Alloy.Globals.Alerta("Alerta", "Você liberou este ticket !");
			setTicketLista(res.dados);
		}else{
			apagaPromocaoLista(res.dados.id);
		}
	}else{
		Alloy.Globals.Alerta("Falhou", res.mensagem);
	}
}

function renovaTicket(e){
	function confirmaRenovaTicket(){
		var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
			callback: sucessRenovaTicket,
			error: failRenovaTicket,
			url:  Alloy.Globals.MainDomain + "api/ticket/renovaTicket", 
			metodo: "POST", 
			timeout: 120000
		});
		if(ws){
			ws.adicionaParametro({clienteId:  Alloy.Globals.Cliente.at(0).get("id"), promocaoId: e.source.dados.promocaoId});
			ws.NovoEnvia();
		}
	}
	var alerta = Alloy.createWidget("GUI", "Mensagem");
	alerta.init("Atenção", "Gostaria de renovar este ticket ?\nApós renovar este ticket não será possível adquirir outro, a menos que este seja liberado ou usado.", true);
	alerta.show({callback: confirmaRenovaTicket});
}

function failRenovaTicket(e){
	Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao tentar renovar o ticket.");
}

function sucessRenovaTicket(e){
	var res = e.at(0).toJSON();
	if(res.sucesso){
		Alloy.Globals.Alerta("Parabéns !", "Você renovou este ticket !");
		setTicketLista(res.dados);
	}else{
		Alloy.Globals.Alerta("Falhou", res.mensagem);
	}
}

function apagaPromocaoLista(ticketId){
	Ti.API.info("id: " + ticketId);
	var md = $.tickets.where({id: ticketId})[0];
	$.tickets.remove(md);
	listaInfinita.reiniciarContainer({checaFim: false});
}

function verMapa(e){
	var mapa = Alloy.createController("Promocao/PromocaoMapa", {nome_loja: e.source.dados.nomeLoja, latitude: e.source.dados.latitude, longitude: e.source.dados.longitude});
	Alloy.Globals.Transicao.proximo(mapa, mapa.init, {});
}

function setTicketLista(info){
	var ticket = $.tickets.where({id: info.id})[0];
	ticket.set(info);
}

//Inicio o processo;
iniciar();

Ti.App.addEventListener("novoTicket", iniciar);
