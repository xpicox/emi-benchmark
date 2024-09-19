from console import Console
from string-utils import StringUtils
from .pubcat import PubCat

service Test {
  embed PubCat as pc
  embed Console as c
  embed StringUtils as su

  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pc( { authorId = "0" key = "valid-key"} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
    install( NotAuthorised => println@c( "Received NotAuthorised" )() )
    println@c( "Sending invalid key" )()
    getAuthorPubs@pc( { authorId = "0" key = ""} )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}
