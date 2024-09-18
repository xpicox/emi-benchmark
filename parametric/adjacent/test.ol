from console import Console
from string-utils import StringUtils
from runtime import Runtime
from ...ad-hoc.internal.pubcat import PubCatWithAPIKeyInterface

service Test {
  outputPort pc {
    // location: "auto:json:paramentric-external:file:../locations.json"
		location: "socket://localhost:8081"
		protocol: http {
			format = "json"
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
  /** Embedding does not set up the extended interface properly
  embed PubCatWithAPIKey
  A workaround is to embed the service at runtime */

  init {
    dependencies[0] << { service = "PubCatWithAPIKey" filepath = "pubcat.ol" }
    println@c( "---- EMBEDDING DEPENDENCIES ----" )()
    for( service in dependencies ) {
      print@c( "Embedding " + service.service + "[" + service.filepath + "]: " )()
      loadEmbeddedService@rt( service )()
      println@c( "done!" )()
    }
  }
  
  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pc( { authorId = "123" key = "valid-key"} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
    install( NotAuthorised => println@c( "Received NotAuthorised" )() )
    print@c( "Sending invalid key: " )()
    getAuthorPubs@pc( { authorId = "0" key = ""} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}
