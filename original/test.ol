from console import Console
from runtime import Runtime
from string-utils import StringUtils
from time import Time
from .pubcat import PubCatInterface

service Test {
  outputPort pc {
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
    interfaces: PubCatInterface
  }
  embed Console as c
  embed StringUtils as su
  embed Runtime as rt
  embed Time as time
  
  init {
    dependencies[0] << { service = "PubCat" filepath = "http.ol" }
    println@c( "---- EMBEDDING DEPENDENCIES ----" )()
    for( service in dependencies ) {
      print@c( "Embedding " + service.service + "[" + service.filepath + "]: " )()
      loadEmbeddedService@rt( service )()
      for(i=0,i<3,i++){sleep@time(200)();print@c(". ")()}
      sleep@time(200)()
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
