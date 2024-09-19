from ..original.pubcat import PubCat
from .citidx import CitIdx

service PublicationIndex {
  embed PubCat as pc
  embed CitIdx as ci
  inputPort ip {
    location: "local"
    protocol: sodep
    aggregates: pc,ci
  }
  main { linkIn( Exit ) }
}