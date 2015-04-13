import Foundation
import RWFramework

struct Stream {
  var streamURL = ""
  var streamID = 0

  init(json: JSON) {
    streamURL = json["stream_url"].string ?? ""
    streamID = json["stream_id"].int ?? 0
  }
}