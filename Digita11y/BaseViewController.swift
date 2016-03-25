import UIKit
import Foundation
class BaseViewController: UIViewController {
    var rwData: RWData?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let to = segue.destinationViewController as? BaseViewController {
            to.rwData = self.rwData
        }
    }
    
    
    //TODO not quite there
    func createButtonsForStack(total: Int, stack: UIStackView) -> [UIButton]{
        var button  = UIButtonBorder(type: UIButtonType.System)
        var buttons : [UIButton] = []
        for index in 0..<total {
            button = UIButtonBorder(type: UIButtonType.System)
            let indexFloat = CGFloat(index)
            let frame = CGRect(
                x: button.buttonMarginX,
                y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                width: button.buttonWidth,
                height: button.buttonHeight )
            button.frame = frame
            buttons.append(button as UIButton)
            stack.addSubview(button)
        }
        return buttons
    }
    
    //TODO move to UIScrollView extension or class
    //TODO add subViewLayout method too
    func createButtonsForScroll(total: Int, scroll: UIScrollView) -> [UIButton]{
        var button  = UIButtonBorder(type: UIButtonType.System)
        var buttons : [UIButton] = []
        for index in 0..<total {
            button = UIButtonBorder(type: UIButtonType.System)
            let indexFloat = CGFloat(index)
            let frame = CGRect(
                x: button.buttonMarginX,
                y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                width: button.buttonWidth,
                height: button.buttonHeight )
            button.frame = frame
            buttons.append(button as UIButton)
            scroll.addSubview(button)
        }
        scroll.contentSize.width = button.buttonWidth + CGFloat(2)
        scroll.contentSize.height = (button.buttonHeight + button.buttonMarginY) * CGFloat(total)
        return buttons
    }
}
