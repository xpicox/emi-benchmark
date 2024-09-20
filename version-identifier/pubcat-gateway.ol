from ..original.pubcat import PubCatInterface
from ..ad-hoc.internal.pubcat import PubCatWithAPIKeyInterface

service PubCatGateway {
  outputPort pcv1 {
    location: "socket://localhost:8080"
		protocol: http {
			format = "json"
      compression = false
			osc << {
				getAuthorPubs << {
					alias = "/author/{authorId}"
					method = "get"
				}
				getConfPubs << {
					alias = "/conf/{confId}"
					method = "get"
				}
			}
		}
    interfaces: PubCatInterface
  }
  outputPort pcv2 {
    location: "socket://localhost:8081"
		protocol: http {
			format = "json"
      compression = false
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
  inputPort ip {
    location: "socket://localhost:8082"
    protocol: sodep
    redirects: v1 => pcv1, v2 => pcv2
  }
  main {linkIn( Exit )}
}
