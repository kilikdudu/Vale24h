/**
 * @class controllers.Boletos
 * Lista boletos.
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
var args = arguments[0] || {};

/**
 * @event sucesso
 * Conseguiu obter os boletos do WebService.
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
function callbackOk(e){
	try{
		var alerta = Alloy.createWidget("GUI", "Mensagem");
		alerta.init("Sucesso", "Cadastro realizado. usuário id: " + e.users[0].id);
		alerta.show({callback: voltar});
	}
	catch(e){
		Alloy.Globals.onError(e.message, "sucesso", "app/controllers/Cadastro.js");
	}
}

var callbackNaoOK = function(e){
	try{
		Alloy.Globals.Alerta("Erro ao tentar cadastrar", e.message);
	}
	catch(e){
		Alloy.Globals.onError(e.message, "callbackNaoOK", "app/controllers/index.js");
	}
};

function voltar(){
	try{
		var login = Alloy.createController("index");
	}
	catch(e){
		Alloy.Globals.onError(e.message, "voltar", "app/controllers/Cadastro.js");
	}
}

/**
 * @method init
 * Construtor da classe.
 * @alteracao 21/01/2015 176562 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
$.init = function(){
	try{
		Alloy.Globals.configWindow($.winCadastro, $);
		$.minhaTopBar.iniciar("Cadastro");
		$.nome.init({nome: "*Nome"});
		$.sobrenome.init({nome: "*Sobrenome"});
		$.login.init({nome: "*Login"});
		$.senha.init({nome: "*Senha"});
		$.senhaRep.init({nome: "*Senha novamente"});
		$.senha.novoNome.passwordMask = true;
		$.senhaRep.novoNome.passwordMask = true;	
	}
	catch(e){
		Alloy.Globals.onError(e.message, "init", "app/controllers/Boletos.js");
	}
};

function validar(){
	try{
		var check = Alloy.createWidget("GUI", "Mensagem");
		if($.nome.getInputValue() == ""){
			check.init("Alerta", "Informe o seu nome.");
			check.show({callback: $.nome.selecionar});
			return false;
		}
		if($.sobrenome.getInputValue() == ""){
			check.init("Alerta", "Informe o sobrenome.");
			check.show({callback: $.sobrenome.selecionar});
			return false;
		}
		if($.login.getInputValue() == ""){
			check.init("Alerta", "Informe o login.");
			check.show({callback: $.login.selecionar});
			return false;
		}
		if($.senha.getInputValue() == ""){
			check.init("Alerta", "Preencha a senha.");
			check.show({callback: $.senha.selecionar});
			return false;
		}
		if($.senhaRep.getInputValue() == ""){
			check.init("Alerta", "Preencha a senha novamente.");
			check.show({callback: $.senhaRep.selecionar});
			return false;
		}
		if($.senhaRep.getInputValue() != $.senha.getInputValue()){
			check.init("Alerta", "As senhas devem ser iguais.");
			$.senhaRep.setInputValue("");
			check.show({callback: $.senhaRep.selecionar});
			return false;
		}
		return true;
	}
	catch(e){
		Alloy.Globals.onError(e.message, "checkLogin", "app/widgets/Login/controllers/login.js");
	}
}

function cadastro(){
	if(validar()){
		requestCadastro();
	}
}

function requestCadastro(){
	try{
		// example assumes you have a set of text fields named username, password, etc.
		Alloy.Globals.Cloud.Users.create({
		    username: $.login.getInputValue(),
		    password: $.senha.getInputValue(),
		    password_confirmation: $.senhaRep.getInputValue(),
		    first_name: $.nome.getInputValue(),
		    last_name: $.sobrenome.getInputValue()
		}, function (e) {
			if (e.success) {
			 	callbackOk(e);
		    } else {
		 		callbackNaoOK(e);
		    }
		});
	}
	catch(e){
		Alloy.Globals.onError(e.message, "requestCadastro", "app/controllers/Cadastro.js");
	}
}
