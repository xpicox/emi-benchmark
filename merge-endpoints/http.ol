from .pub-index import PublicationIndex as Impl

service PublicationIndex {
  embed Impl as i
  inputPort ip {
    location: "local"
    protocol: http {
			format = "json"
      compression = false
			osc << {
				getAuthorPubs << {
					template = "/author/{authorId}"
					method = "get"
				}
				getConfPubs << {
					template = "/conf/{confId}"
					method = "get"
				}
        getCitingPubs << {
          template = "/citations/{pubId}"
          method = "get"
        }
			}
		}
    aggregates: i
  }
  main { linkIn( Exit ) }
}