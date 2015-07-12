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
			ws.adicionaParametro({limite: limit, cursor: cursor});
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
		}else{
			pro.qtdeTickets = "Tickets ilimitados até o fim da promoção !";	
			pro.validade = "Válido até: " + Alloy.Globals.format.toDiaMesAno(pro.validade) + ".";	
		}
		
		return pro;	
	}
	catch(e){
		Alloy.Globals.onError(e.message, "formatar", "app/controllers/Boletos.js");
	}
}


function detalhar(e){
	try{
		if(e.row.tipo == "atualizar"){
			listaInfinita.mostrarMais();
			return;
		}
		infoTicketCliente( e.row.post_id);
	}
	catch(e){
		Alloy.Globals.onError(e.message, "detalhar", "app/controllers/Boletos.js");
	}
}


function infoTicketCliente(promocaoId){
	var ws = Alloy.createWidget("WebService").iniciarHttpRequest({
		callback: sucessInfoTicketCliente,
		error: failInfoTicketCliente,
		url:  Alloy.Globals.MainDomain + "api/ticket/getInfoTicket", 
		metodo: "POST", 
		timeout: 120000
	});
	if(ws){
		ws.adicionaParametro({promocaoId: promocaoId, clienteId: Alloy.Globals.Cliente.at(0).get("id")});
		ws.NovoEnvia();
	}
}

function failInfoTicketCliente(e){
	Alloy.Globals.Alerta("Erro", "Ocorreu um erro ao tentar obter as informações da promocao.");
}

function sucessInfoTicketCliente(e){
	var detalhes = Alloy.createController("Promocao/DetalhesPromocao", {ticket: e.at(0).toJSON()});
	Alloy.Globals.Transicao.proximo(detalhes, detalhes.init, {});
}

//Inicio o processo;
iniciar();

