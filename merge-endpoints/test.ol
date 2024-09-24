from console import Console
from string-utils import StringUtils
from time import Time
from .pub-index import PublicationIndex
// from .http import PublicationIndex

service Test {
  embed Console as c
  embed StringUtils as su
  embed Time as t
  embed PublicationIndex as pi

  main {
    sleep@t(500)()
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pi( { authorId = "0" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
    getCitingPubs@pi( { pubId = "0" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}