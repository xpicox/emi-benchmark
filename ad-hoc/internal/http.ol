from .pubcat import PubCat as PubCatImpl, PubCatWithAPIKeyInterface

service PubCat {
  embed PubCatImpl as pc
	inputPort ip {
		location: "socket://localhost:8080"
    protocol: http {
			format = "json"
      compression = flase
			osc << {
				getAuthorPubs << {
					template = "/author/{authorId}"
					method = "get"
					statusCodes.NotAuthorised = 401
					inHeaders.Authorization = "key"
				}
				getConfPubs << {
					template = "/conf/{confId}"
					method = "get"
					statusCodes.NotAuthorised = 401
					inHeaders.Authorization = "key"
				}
			}
    }
		aggregates: pc
	}

  main { linkIn( Exit ) }
}

 
// http -p HBhb get localhost:8080/author/123 'Authorization:valid-key'
/*
*/