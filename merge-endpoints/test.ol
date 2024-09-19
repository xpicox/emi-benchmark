from console import Console
from string-utils import StringUtils
from .pub-index import PublicationIndex

service Test {
  embed Console as c
  embed StringUtils as su
  embed PublicationIndex as pi


  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pi( { authorId = "0" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
    getCitingPubs@pi( { pubId = "0" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}