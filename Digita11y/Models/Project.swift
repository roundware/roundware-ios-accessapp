import Foundation
import RWFramework

enum MediaType {
  case None
  case Text
  case Photo
  case Audio
}
struct Project {
  var projectDescription = ""
  var volume = 0
  var project = 0
  var assetID = 0
  var mediaType = MediaType.None
  var tagIDs: [Int] = []
  var fileURL = NSURL()

  init(json: JSON) {
    projectDescription = json["description"].string ?? ""
    volume = json["volume"].int ?? 0
    project = json["project"].int ?? 0
    assetID = json["asset_d"].int ?? 0

    if json["media_type"].string == "text" {
      mediaType = .Text
    } else if json["media_type"].string == "photo" {
      mediaType = .Photo
    } else if json["media_type"].string == "audio" {
      mediaType = .Audio
    } else {
      debugPrintln(json["media_type"].string)
    }

    tagIDs = json["tag_ids"].array?.map { $0.int ?? 0 } ?? []
    var strURL = RWFrameworkConfig.getConfigValueAsString("base_url") + (json["file"].string ?? "")
    fileURL = NSURL(string: strURL) ?? NSURL()
  }
}

//{
//  "description" : "",
//  "volume" : 1,
//  "audio_length_in_seconds" : null,
//  "file" : "\/rwmedia\/20150312-164018-190.txt",
//  "project" : 2,
//  "asset_id" : 58,
//  "filename" : "20150312-164018-190.txt",
//  "longitude" : -122.0312186,
//  "submitted" : true,
//  "latitude" : 37.33233141,
//  "weight" : 50,
//  "media_type" : "text",
//  "tag_ids" : [
//
//  ],
//  "language" : "en",
//  "created" : "2015-03-12T16:40:18",
//  "session_id" : 190,
//  "loc_description" : [
//
//  ]
//}