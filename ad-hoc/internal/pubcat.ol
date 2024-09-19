type AuthorRequest { authorId: string key: string }
type ConfRequest { confId: string key: string }
type Publications { publications*: Publication }
type Publication: undefined

interface PubCatWithAPIKeyInterface {
  RequestResponse:
    getAuthorPubs( AuthorRequest )( Publications ) throws NotAuthorised,
    getConfPubs( ConfRequest )( Publications ) throws NotAuthorised
}

constants {
	AuthorId = "101/0317",
  PubsCount = 2
}

service PubCat {
  execution: concurrent
	inputPort ip {
		location: "local"
    protocol: sodep
		interfaces: PubCatWithAPIKeyInterface
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
        if( request.key != "valid-key" ) {
          throw( NotAuthorised )
        }
        response << authors.(AuthorId)
      } ]
    [ getConfPubs( request )( response ) {
        if( request.key != "valid-key" ) {
          throw( NotAuthorised )
        }
        response << authors.(AuthorId)
      } ]
  }
}