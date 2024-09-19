from console import Console
from runtime import Runtime
from string-utils import StringUtils
from .pubcat import PubCatInterface

service Test {
  outputPort pc {
		location: "socket://localhost:8080"
		protocol: http {
			format = "json"
      compression = false
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
  embed Runtime as rt
  
  init {
    dependencies[0] << { service = "PubCat" filepath = "http.ol" }
    println@c( "---- EMBEDDING DEPENDENCIES ----" )()
    for( service in dependencies ) {
      print@c( "Embedding " + service.service + "[" + service.filepath + "]: " )()
      loadEmbeddedService@rt( service )()
      println@c( "done!" )()
    }
  }

  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pc( { authorId = "0" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}
