from console import Console
from string-utils import StringUtils
from runtime import Runtime
from .http import PubCatWithAPIKeyInterface

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
					statusCodes.NotAuthorised = 401
					outHeaders.Authorization = "key"
				}
				getConfPubs << {
					alias = "/conf/{confId}"
					method = "get"
					statusCodes.NotAuthorised = 401
					outHeaders.Authorization = "key"
				}
			}
		}
    interfaces: PubCatWithAPIKeyInterface
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
    getAuthorPubs@pc( { authorId = "0" key = "valid-key" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}