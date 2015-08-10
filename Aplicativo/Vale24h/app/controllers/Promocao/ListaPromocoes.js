/**
 * @class controllers.Boletos
 * Lista boletos.
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
var args = arguments[0] || {};

var limite = 10;



var listaInfinita = Alloy.createWidget("Util", "ListaInfinita", {colecao: $.promocoes, lista: $.listaPromocoes, 
	refreshCallback: getPromocoes, limite: limite});


function myRefresher(e) {
	listaInfinita.myRefresher();	
}


function sucesso(){
	try{
		$.promocoes.trigger("change");
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
		getPromocoes({semLoader: false, limite: limite, cursor: 0});	
	}
	catch(e){
		Alloy.Globals.onError(e.message, "open", "app/controllers/Medicao/ListaMedicao.js");
	}
};


function getPromocoes(parans){
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
			url:  Alloy.Globals.MainDomain + "api/promocao/getPromocoes", 
			metodo: "POST", 
			timeout: 120000,
			colecao: cursor==0?$.promocoes:undefined,
			semLoader: semLoader
		});
		if(ws){
			ws.adicionaParametro({limite: limit, cursor: cursor, clientId: Alloy.Globals.Cliente.at(0).get("id")});
			ws.NovoEnvia();
		}
	}
	catch(e){
		Alloy.Globals.onError(e.message, "getContratosMedicao", "app/controllers/Medicao/ListaMedicao.js");
	}
}


function formatar(model){
	try{
		var pro = model.toJSON();
		pro.inicio = "Iniciada em " + Alloy.Globals.format.toDiaMesAno(pro.inicio);
		if(pro.limitada){
			pro.qtdeTickets = "Tickets disponíveis: " + (parseInt(pro.qtdeTickets) - parseInt(pro.qtdeTicketsUsados)) + ".";	
			pro.validade = "Válido até: " + Alloy.Globals.format.toDiaMesAno(pro.validade) + ".";
			pro.descPegaTicket = "Pegar";
			pro.imgPega = "/images/ticket.png";	
			pro.imgList = "/images/ticketList.png";
		}else{
			pro.qtdeTickets = pro.qtdeTicketsUsados + " curtidas.";	
			pro.validade = "Válido até: " + Alloy.Globals.format.toDiaMesAno(pro.validade) + ".";
			pro.descPegaTicket = "Curtir";	
			pro.imgPega = "/images/like.png";
			pro.imgList = "/images/like.png";
		}
		
		return pro;	
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



function pegaTicket(e){
	function confirmaPegaTicket(res){
		if(!res.value){return;}
		var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
			callback: sucessPegaTicket,
			error: failPegaTicket,
			url:  Alloy.Globals.MainDomain + "api/ticket/pegaTicket", 
			metodo: "POST", 
			timeout: 120000
		});
		if(ws){
			ws.adicionaParametro({promocaoId: e.source.dados.promocaoId, clienteId: Alloy.Globals.Cliente.at(0).get("id")});
			ws.NovoEnvia();
		}
	}
	if(e.source.dados.limitada){
		var alerta = Alloy.createWidget("GUI", "Mensagem");
		alerta.init("Atenção", "Gostaria de pegar este ticket ?\nApós pegar este ticket não será possível adquirir outro a menos que este seja liberado ou usado.", true);
		alerta.show({callback: confirmaPegaTicket});
	}else{
		confirmaPegaTicket({value: true});
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
		apagaPromocaoLista(res.dados.promocao.idPromocao);
		Ti.App.fireEvent("novoTicket");
	}else{
		Alloy.Globals.Alerta("Falhou", res.mensagem);
	}
}

function apagaPromocaoLista(promocaoId){
	var md = $.promocoes.where({idPromocao: promocaoId})[0];
	$.promocoes.remove(md);
	listaInfinita.reiniciarContainer({checaFim: false});
}

function verMapa(e){
	var mapa = Alloy.createController("Promocao/PromocaoMapa", {nome_loja: e.source.dados.nomeLoja, latitude: e.source.dados.latitude, longitude: e.source.dados.longitude});
	Alloy.Globals.Transicao.proximo(mapa, mapa.init, {});
}

//Inicio o processo;
iniciar();
