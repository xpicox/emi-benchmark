from ...original.pubcat import PubCat,PubCatInterface

type APIKey { key: string }

interface extender APIKeyExtender {
RequestResponse:
  *( APIKey )( void ) throws NotAuthorised
}

service PubCatWithAPIKey {
  embed PubCat as pc
  inputPort ip {
		// location: "local://PubCatWithAPIKey"
    // location: "auto:json:paramentric-external:file:../locations.json"
    // location: "local"
		location: "socket://localhost:8081"
    protocol: http {
			format = "json"
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
    aggregates: pc with APIKeyExtender
  }
  courier ip {
    [ interface PubCatInterface( req )( res ) {
        if( req.key == "valid-key" ) {
          forward( req )( res )
        } else {
          throw( NotAuthorised )
        }
      } ]
  }
  main { linkIn( Exit ) }
}