/**
 * @class widgets.GUI.TabsView
 * Switcher personalizado.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação. 
 */
var args = arguments[0] || {};


var camada = Alloy.createWidget("GUI", "Camada", {load: true}).getView();

$.getView().add(camada);

if(args.loja_id){
	Alloy.Globals.Cloud.PhotoCollections.search({
		user_id: args.loja_id},
		function (e) {
		    if (e.success) {
		        for (var i = 0; i < e.collections.length; i++) {
		            if (e.collections[i].custom_fields['[ACS_Post]post_id'][0] === args.idPost) {
		            	Alloy.Globals.Cloud.PhotoCollections.showPhotos({
						    page: 1,
						    per_page: 5,
						    collection_id: e.collections[i].id
						}, function (e) {
						    if (e.success) {
					            for (var i = 0; i < e.photos.length; i++) {
					                var photo = e.photos[i];
					                var image = Ti.UI.createImageView({
					                	image: photo.urls.original,
					                	height: "100%"
					                });
					                images.push(image);
					        	}
					        	iniciar();
								$.getView().remove(camada);
						    } else {
						        alert('Error:\n' +args.altura
						            ((e.error && e.message) || JSON.stringify(e)));
						    }
						});
						break;
		            };
		        }
		    } else {
		        alert('Error:\n' +
		            ((e.error && e.message) || JSON.stringify(e)));
    		}
    	}
    );
}

/**
 * @property {Array} pages Páginas contidas no paging control. 
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
var images = [];
/**
 * @property {Number} indiceAtual Indice da página atual. 
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
var indiceAtual = null;
/**
 * @property {Number} numberOfPage Quantidade de páginas na scrollable view. 
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
var numberOfPages = null;

/**
 * @method init
 * Construtor da classe 
 * @param {Array} views Views que deverão ficar contidas na scrollable view.
 * @param {Array} titulos Vetor de títulos das abas.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
function iniciar(){
	$.boxTabsView.setViews(images);
	preenchePaggingControl(images.length);
};


/**
 * @method preenchePaggingControl
 * Monta o pagging controll.
 * @private
 * @param {Object} titulos Vetor de títulos das abas.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
function preenchePaggingControl(tamanho){
	numberOfPages = tamanho;
	//Obtenho a largura da label.
	var largura = 100/numberOfPages;
	for (var i = 0; i < numberOfPages; i++) {
		var marcador = Ti.UI.createView({
			width: 10,
			height: 10,
			borderRadius: 20,
			backgroundColor: "gray",
			right: 2
		});
		// Store a reference to this view
		images[i].marcador = marcador;
		// Add it to the container
		$.pagingControl.add(marcador);
	}
	
	ativaAba(images[$.boxTabsView.getCurrentPage()]);
	indiceAtual = $.boxTabsView.getCurrentPage();
	$.boxTabsView.addEventListener("scroll", onScroll);
	$.boxTabsView.addEventListener("postlayout", onPostLayout);
}

/**
 * @method desativaAba
 * Desativa a página do pagging controll.
 * @private
 * @param {Object} page Página do pagging controll.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
function desativaAba(page){
	page.marcador.setBackgroundColor("gray");
}

/**
 * @method ativaAba
 * Ativa a página do pagging controll.
 * @private
 * @param {Object} page Página do pagging controll.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
function ativaAba(page){
	page.marcador.setBackgroundColor("white");
}

/**
 * @event onScroll
 * Quando a página atual é alterada.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
function onScroll(event){
	//Testo se o evento tem como pai a scrollable view ou uma ScrollView. Caso seja uma ScrollView eu invoco o método {onPostLayout}.
	if(event.currentPage){
		if(indiceAtual == event.currentPage){return;}
		for (var i = 0; i < numberOfPages; i++) {
			desativaAba(images[i]);
		}
		ativaAba(images[event.currentPage]);
		indiceAtual = event.currentPage;
	}
	else{
		onPostLayout(null);
	}
};

/**
 * @event onPostLayout
 * Quando a página atual avisa que está pronta.
 * @alteracao 05/03/2015 180419 Projeto Carlos Eduardo Santos Alves Domingos
 * Criação.
 */
function onPostLayout(event) {
	if(indiceAtual == $.boxTabsView.getCurrentPage()){return;}
 	for (var i = 0; i < numberOfPages; i++) {
 		desativaAba(images[i]);
	}
	ativaAba(images[$.boxTabsView.getCurrentPage()]);
	indiceAtual = $.boxTabsView.getCurrentPage();
};