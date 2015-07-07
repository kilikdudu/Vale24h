exports.definition = {
	config: {
		columns: {
		    "sessionId": "string",
		    "id": "String"
		},
		adapter: {
			type: "sql",
			collection_name: "Cliente",
			idAttribute: 'id'
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