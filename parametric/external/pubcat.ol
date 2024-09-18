from ...original.pubcat import PubCatInterface

type APIKey { key: string }

interface extender APIKeyExtender {
RequestResponse:
  *( APIKey )( void ) throws NotAuthorised
}

service PubCatWithAPIKey {
  outputPort pc {
		location: "socket://localhost:8080"
		protocol: http {
			format = "json"
			osc << {
				getAuthorPubs << {
					alias = "/author/{authorId}"
					method = "get"
				}
				getConfPubs << {
					alias = "/conf/{confId}"
					method = "get"
				}
			}
		}
    interfaces: PubCatInterface
  }
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