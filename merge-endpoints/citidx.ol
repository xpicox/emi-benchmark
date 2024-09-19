type CitationRequest { pubId: string }
type Publications { publications*: undefined }

interface CitIdxInterface {
  RequestResponse:
    getCitingPubs( CitationRequest )( Publications )
}

constants {
	PUBLICATION_ID = "key-1010317",
  PUBS_COUNT = 2
}

service CitIdx {
  inputPort ip {
    location: "local"
    protocol: sodep
    interfaces: CitIdxInterface
  }
  init {
    pubs -> publications.(PUBLICATION_ID).publications
    for(i=0, i < PUBS_COUNT, i++) {
      pubs[i] << {
        title = "Title " + i
        authors[0] = "Fst. Author "+i
        authors[1] = "Snd. Author "+i
        key = "key-" + i
        year = 2024 - PubsCount + i
      }
    }
    undef(pubs)
  }

  main {
    [ getCitingPubs( request )( response ) {
        response << publications.(PUBLICATION_ID)
      } ]
  }
}