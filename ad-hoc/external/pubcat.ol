from ...original.pubcat import PubCatInterface
from ...ad-hoc.internal.pubcat import PubCatWithAPIKeyInterface

type APIKey { key: string }

interface extender APIKeyExtender {
RequestResponse:
  *( APIKey )( void ) throws NotAuthorised
}

service PubCatWithAPIKey {
  execution: concurrent
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
    interfaces: PubCatWithAPIKeyInterface
  }
  main {
    [ getAuthorPubs( request )( response ) {
        if( request.key != "valid-key" ) {
          throw( NotAuthorised )
        }
        undef( request.key )
        getAuthorPubs@pc( request )( response )
      } ]
    [ getConfPubs( request )( response ) {
        if( request.key != "valid-key" ) {
          throw( NotAuthorised )
        }
        undef( request.key )
        getConfPubs@pc( request )( response )
      } ]
  }
}
