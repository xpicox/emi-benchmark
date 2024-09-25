/* This example is a showcase on how the Jolie language could be extended to
  allow Parametric/Internal implementation strategies. The current sintactical
  limitations do not allow to:
  - Extend the interface of an inputPort without aggregation
  - Use courier on an inputPort without aggregation
*/

from ...original.pubcat import PubCatInterface

type APIKey { key: string }

interface extender APIKeyExtender {
RequestResponse:
  *( APIKey )( void ) throws NotAuthorised
}

service PubCat {
  execution: concurrent
	inputPort ip {
		location: "local"
    protocol: sodep
    // Unsupported:
		interfaces: PubCatInterface with APIKeyExtender
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
  // Unsuported:
  courier ip {
    [ interface PubCatInterface( req )( res ) {
        if( req.key == "valid-key" ) {
          forward( req )( res )
        } else {
          throw( NotAuthorised )
        }
      } ]
  }

  main {
    [ getAuthorPubs( request )( response ) {
        response << authors.(AuthorId)
      } ]
    [ getConfPubs( request )( response ) { response = void } ]
  }
}