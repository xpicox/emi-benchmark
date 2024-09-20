from console import Console
from string-utils import StringUtils
from runtime import Runtime
from time import Time
from ...ad-hoc.internal.pubcat import PubCatWithAPIKeyInterface

service Test {
  outputPort pc {
		location: "socket://localhost:8081"
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
  embed Time as time

  init {
    dependencies[0] << { service = "PubCat" filepath = "../../original/http.ol" }
    dependencies[1] << { service = "PubCatWithAPIKey" filepath = "pubcat.ol" }
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
    getAuthorPubs@pc( { authorId = "0" key = "valid-key"} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
    install( NotAuthorised => println@c( "Received NotAuthorised" )() )
    print@c( "Sending invalid key: " )()
    getAuthorPubs@pc( { authorId = "0" key = ""} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}
