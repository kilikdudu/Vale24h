exports.definition = {
	config: {
		columns: {
	        "idPromocao" : "int", 
	        "descricao" : "string", 
	        "titulo" : "string", 
	        "urlImagem" : "string", 
	        "validade" : "Date", 
	        "inicio" : "Date", 
	        "qtdeTickets" : "int", 
	        "qtdeTicketsUsados" : "int", 
	        "empresa_id" : "string", 
	        "nomeEmpresa" : "string", 
	        "imagemEmpresa" : "string", 
	        "latitude" : "string", 
	        "longitude" : "string",
	        "limitada": "bool" 
		},
		adapter: {
			type: "properties",
			collection_name: "Promocao",
			idAttribute: "idPromocao"
		}
	},
	extendModel: function(Model) {
		_.extend(Model.prototype, {
			// extended functions and properties go here
		});

		return Model;
	},
	extendCollection: function(Collection) {
		_.extend(Collection.prototype, {
			// extended functions and properties go here
			
		});

		return Collection;
	}
};