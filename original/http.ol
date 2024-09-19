from .pubcat import PubCat as PubCatImpl

service PubCat {
  embed PubCatImpl as pc
	inputPort ip {
		location: "socket://localhost:8080"
		protocol: http {
			format = "json"
      compression = false
			osc << {
				getAuthorPubs << {
					template = "/author/{authorId}"
					method = "get"
				}
				getConfPubs << {
					template = "/conf/{confId}"
					method = "get"
				}
			}
		}
		aggregates: pc
	}

  main { linkIn( Exit ) }
}