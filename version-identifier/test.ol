from console import Console
from runtime import Runtime
from string-utils import StringUtils
from time import Time
from ..original.pubcat import PubCatInterface
from ..ad-hoc.internal.pubcat import PubCatWithAPIKeyInterface

service Test {
  outputPort pcv1 {
		location: "socket://localhost:8082/!/v1"
    protocol: sodep
    interfaces: PubCatInterface
  }
  outputPort pcv2 {
		location: "socket://localhost:8082/!/v2"
    protocol: sodep
    interfaces: PubCatWithAPIKeyInterface
  }
  embed Console as c
  embed StringUtils as su
  embed Runtime as rt
  embed Time as time

  init {
    dependencies[0] << { service = "PubCat" filepath = "../original/http.ol" }
    dependencies[1] << { service = "PubCatGateway" filepath = "pubcat-gateway.ol" }
    dependencies[2] << { service = "PubCatWithAPIKey" filepath = "../ad-hoc/external/pubcat.ol" }
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
    getAuthorPubs@pcv1( { authorId = "0"} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
    getAuthorPubs@pcv2( { authorId = "0" key = "valid-key"} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}