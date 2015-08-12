/**
 * @class widgets.GUI.Topbar
 * Barra no topo do App.
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação. 
 */
var args = arguments[0] || {};

var inputSearch = null;
var searchBar = null;
var semaforo = false;

var tamanhoBotao = 32;
var gapDireitaBotao = 10;
var boxBuscar = {};

/**
 * @method iniciar
 * Construtor da classe. Altera o título e caso exista uma janela anterior, a barra substitui o ícone de lista para o ícone voltar.
 * Adiciona também o evento de swipe na lateral esquerda da tela. 
 * @param {Object} titulo
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação. 
 */
$.iniciar = function(titulo){
	try{
		if(Alloy.Globals.currentWindow()){
			if(Alloy.Globals.currentWindow()._previousWin){
				$.boxListaServico.setBackgroundImage("/images/voltar.png");	
			}
		}
		$.titulo.text = titulo;
		
		var camadaTeste = Ti.UI.createView({
			zIndex: 10,
			width: 25,
			left: 0,
			height: Ti.UI.FILL,
			top: 50
		});
		
		camadaTeste.addEventListener("swipe", function(e){
			if(e.direction === 'right'){
				$.boxListaServico.fireEvent("click", {source: $.boxListaServico});
			}
		});
		
		Alloy.Globals.currentWindow().add(camadaTeste);
	}
	catch(e){
		Alloy.Globals.onError(e.message, "iniciar", "app/widgets/GUI/controllers/Topbar.js");
	}
};

/**
 * @method addRightButtom
 * Adiciona um botão no canto superior direito da tela.
 * @param {String} icon Url do icone.
 * @param {Function} callback Função executada quando se clica no botão.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação. 
 */
$.addRightButtom = function(icon, callback){
	var btnRight = Ti.UI.createButton({
		right: gapDireitaBotao + ($.boxBotoes.children.length * (tamanhoBotao + gapDireitaBotao)),
		width: tamanhoBotao,
		height: tamanhoBotao,
		backgroundColor: 'transparent',
		backgroundImage: icon,
		backgroundSelectedColor: Alloy.Globals.MainColorLight
	});
	btnRight.addEventListener("click", callback);
	$.boxBotoes.add(btnRight);
	return btnRight;
};

/**
 * @method enableSmartFilter
 * Ativa o filtro inteligente para a lista.
 * @param {Ti.UI.TableView} tableView Tabela a ser filtrada.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação. 
 */
$.enableFilter = function(tableView){
	
	var btnBuscar = $.addRightButtom("/images/lupa_white.png", callback);
	montarSearchBar({view: tableView});
	function callback(e){
		$.boxBotoes.remove(btnBuscar);
		$.titulo.visible = false;
		$.boxTopBar.add(boxBuscar);
	}
	boxBuscar.addEventListener("fechar", function(e){
		$.boxTopBar.remove(boxBuscar);
		$.boxBotoes.add(btnBuscar);
		$.titulo.visible = true;
	});
};

function montarSearchBar(parans){
	var sField = Ti.UI.createTextField({
		color: "white",
		backgroundColor: "transparent",
		enableReturnKey: true,
		returnKeyType: Titanium.UI.RETURNKEY_SEARCH,
		font: {fontSize: 18},
		hintText: "Buscar...",
		left: 26,
		right: 26,
		top: 0,
		height: 40
	});
	var btnLimpar = Ti.UI.createButton({
		backgroundColor: 'transparent',
		backgroundImage: "/images/x_white.png",
		visible: false,
		enabled: false,
		height: 20,
		width: 20,
		right: 4,
		backgroundSelectedColor: Alloy.Globals.MainColorLight
	});
	btnLimpar.addEventListener("click", function(e){
		sField.value = "";
	});
	
	var btnFechar = Ti.UI.createButton({
		width: 20,
		height: 20,
		left: 4,
		backgroundImage: "/images/lupa_white.png",
		backgroundColor: "transparent",
		backgroundSelectedColor: Alloy.Globals.MainColorLight
	});
	
	btnFechar.addEventListener("click", function(e){
		boxBuscar.fireEvent("fechar", {});
	});
	
	var linha = Ti.UI.createView({
		backgroundColor: "white",
		height: 1,
		left: 0,
		right: 0,
		bottom: 0
	});
	
	sField.addEventListener("change", function(e){
		if(e.value.length > 0){
			btnLimpar.enabled = true;
			btnLimpar.visible = true;
		}
		parans.view.fireEvent("buscarchange", {texto: e.value});
	});
	sField.addEventListener("return", function(e){
		parans.view.fireEvent("buscar", {texto: e.value});
		sField.blur();
	});
	
	boxBuscar = Ti.UI.createView({
		height: tamanhoBotao,
		left: 50,
		right: gapDireitaBotao + (($.boxBotoes.children.length - 1) * (tamanhoBotao + gapDireitaBotao))
	});
	boxBuscar.add(sField);
	boxBuscar.add(btnLimpar);
	boxBuscar.add(btnFechar);
	boxBuscar.add(linha);
}

/**
 * @event click_boxListaServico
 * Disparado ao se clicar no ícone de lista. Caso exista uma janela anterior, esta janela será fechada e a anterior será aberta.
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação. 
 */
$.boxListaServico.addEventListener("click", function(e){
	if(Alloy.Globals.currentWindow()._previousWin){
		Alloy.createWidget("Util", "Transicao").anterior();
	}
	else{
		Alloy.Globals.ListaServicos.abrir();
	}
});
