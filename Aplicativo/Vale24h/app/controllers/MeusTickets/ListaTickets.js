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
		tic.lblVoucher = "Código: " + tic.voucher + ".";	
		tic.lblValidade = "Válido até: " + Alloy.Globals.format.toDiaMesAno(tic.validade) + ".";	
		
		//Verificar remendo !
		tic.lblImagemEmpresa = tic.promocao.imagemEmpresa;
		tic.lblNomeEmpresa = tic.promocao.nomeEmpresa;
		tic.lblUrlImagem = tic.promocao.urlImagem;
		tic.lblDescricao = tic.promocao.descricao;
		return tic;	
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
		var detalhes = Alloy.createController("Promocao/DetalhesPromocao", {ticket: $.tickets.where({id: e.row.ticketId})[0].toJSON()});
		Alloy.Globals.Transicao.proximo(detalhes, detalhes.init, {});
	}
	catch(e){
		Alloy.Globals.onError(e.message, "detalhar", "app/controllers/Boletos.js");
	}
}

//Inicio o processo;
iniciar();

