
from console import Console
from string-utils import StringUtils
from ..embeddable.main import PubCat as PubCatImpl

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
service Test {
  embed PubCat as pc
  embed Console as c
  embed StringUtils as su

  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pc( { authorId = "" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}
*/