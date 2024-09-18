type AuthorRequest { authorId: string }
type ConfRequest { confId: string }
type Publications { publications*: Publication }
type Publication: undefined

interface PubCatInterface {
  RequestResponse:
    getAuthorPubs( AuthorRequest )( Publications ),
    getConfPubs( ConfRequest )( Publications )
}

constants {
	AuthorId = "101/0317",
  PubsCount = 5
}

service PubCat {
  execution: concurrent
	inputPort ip {
		location: "local"
    protocol: sodep
		interfaces: PubCatInterface
	}

  init {
    pubs -> authors.(AuthorId).publications
    for(i=0, i < PubsCount, i++) {
      pubs[i] << {
        title = "Title " + i
        authors[0] = "Fst. Author "+i
        authors[1] = "Snd. Author "+i
        year = 2024 - PubsCount + i
      }
    }
    undef(pubs)
  }

  main {
    [ getAuthorPubs( request )( response ) {
        response << authors.(AuthorId)
      } ]
    [ getConfPubs( request )( response ) { response = void } ]
  }
}
// TEST
from console import Console
from string-utils import StringUtils

service Test {
  embed PubCat as pc
  embed Console as c
  embed StringUtils as su

  main {
    println@c( "---- SERVICE START ----" )()
    getAuthorPubs@pc( { authorId = "" } )( res )
    valueToPrettyString@su( res )( pretty )
    println@c( pretty )()
  }
}