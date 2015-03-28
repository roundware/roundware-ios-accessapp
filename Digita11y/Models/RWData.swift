import Foundation
import RWFramework

class RWData: RWFrameworkProtocol {
  var rwf: RWFramework

  init() {
    rwf = RWFramework.sharedInstance
    rwf.addDelegate(self)
    rwf.start()
  }

  func rwUpdateStatus(message: String) {
    //debugPrintln(message)
  }

  func rwPostUsersFailure(error: NSError?) {
    debugPrintln(error)
  }

  func rwPostSessionsSuccess() {
  }

  func rwGetProjectsIdTagsSuccess(data: NSData?) {
    let json = JSON(data: data!)
    var speak = json["speak"].array?.map { TagGroup(json: $0) } ?? []
    var listen = json["listen"].array?.map { TagGroup(json: $0) } ?? []
    debugPrintln(speak)
    debugPrintln(listen)
  }

  func rwGetProjectsIdTagsFailure(error: NSError?) {
    debugPrintln(error)
  }
}