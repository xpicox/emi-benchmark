from console import Console
from string-utils import StringUtils
from time import Time
from .pubcat import PubCatWithAPIKey

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
  embed Time as time
  embed PubCatWithAPIKey

  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pc( { authorId = "0" key = "valid-key"} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
    install( NotAuthorised => println@c( "Invalid Key" )() )
    getAuthorPubs@pc( { authorId = "0" key = ""} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}
