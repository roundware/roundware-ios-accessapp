import UIKit

func delay(dt: Double, operation:() -> ()) {
  let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(dt * Double(NSEC_PER_SEC)))
  dispatch_after(delayTime, dispatch_get_main_queue()) {
    operation()
  }
}