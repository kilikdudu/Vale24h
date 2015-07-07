var args = arguments[0] || {};

var nome_loja = args.nome_loja;
var latitude = args.latitude;
var longitude = args.longitude;

$.mapview.region = {
	latitude: latitude,
    longitude: longitude,
    latitudeDelta: 0.01,
    longitudeDelta: 0.01
};


$.appcHQ.latitude = latitude;
$.appcHQ.longitude = longitude;
$.appcHQ.title = "Vale24h";
$.appcHQ.subtitle = nome_loja;
$.appcHQ.pincolor = Alloy.Globals.Map.ANNOTATION_RED;

$.init = function(e){
	Alloy.Globals.configWindow($.winMapaPromocao, $);
	$.minhaTopBar.iniciar("Locais de venda");
};
function report(evt) {
    Ti.API.info("Annotation " + evt.title + " clicked, id: " + evt.annotation.myid);
}