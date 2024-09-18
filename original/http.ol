from .pubcat import PubCat as PubCatImpl

service PubCat {
  embed PubCatImpl as pc
	inputPort ip {
		location: "socket://localhost:8080"
		protocol: http {
			format = "json"
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

// TEST
from .pubcat import PubCatInterface
from console import Console
from string-utils import StringUtils

service Test {
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
  embed Console as c
  embed StringUtils as su

  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pc( { authorId = "" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}
