from ...original.pubcat import PubCat,PubCatInterface
from ...ad-hoc.internal.pubcat import PubCatWithAPIKeyInterface

service PubCatWithAPIKey {
  execution: concurrent
  embed PubCat as pc
  inputPort ip {
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