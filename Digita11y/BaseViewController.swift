import UIKit
import Foundation
class BaseViewController: UIViewController {
    var rwData: RWData?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let to = segue.destinationViewController as? BaseViewController {
            to.rwData = self.rwData
        }
    }

    //TODO move to UIScrollView extension or class
    //TODO add subViewLayout method too
    //TODO refactor to allow passing button subclass as param

    func createCenteredTagButtonsForScroll(total: Int, scroll: UIScrollView) -> [UIButton]{

        var button  = UIButtonTag(type: UIButtonType.System)
        var buttons : [UIButton] = []

        for (_, item) in scroll.subviews.enumerate(){
            item.removeFromSuperview()
        }

        for index in 0..<total {
            button = UIButtonTag(type: UIButtonType.System)
            let indexFloat = CGFloat(index)
            let frame = CGRect(
                x: button.buttonMarginX,
                y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                width: button.buttonWidth,
                height: button.buttonHeight )
            button.frame = frame
            button.titleLabel?.numberOfLines = 0
            buttons.append(button as UIButton)
            scroll.addSubview(button)
        }

        scroll.contentSize.width = button.buttonWidth
        scroll.contentSize.height = (button.buttonHeight + button.buttonMarginY) * CGFloat(total)
        
        return buttons
        
    }

    //presumes a centered scroll bound
    func createTagButtonsForScroll(total: Int, scroll: UIScrollView) -> [UIButton]{

        var button  = UIButtonTag(type: UIButtonType.System)
        var buttons : [UIButton] = []

        for (_, item) in scroll.subviews.enumerate(){
            item.removeFromSuperview()
        }
        let newContentOffsetX = (button.buttonWidth - scroll.bounds.size.width) / 2
        debugPrint("new content offset \(newContentOffsetX)")

        for index in 0..<total {
            button = UIButtonTag(type: UIButtonType.System)
            let indexFloat = CGFloat(index)
            let frame = CGRect(
                x: button.buttonMarginX - newContentOffsetX,
                y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                width: button.buttonWidth,
                height: button.buttonHeight )
            button.frame = frame
            button.titleLabel?.numberOfLines = 0
            buttons.append(button as UIButton)
            scroll.addSubview(button)
        }

        scroll.contentSize.width = button.buttonWidth
        scroll.contentSize.height = (button.buttonHeight + button.buttonMarginY) * CGFloat(total)

        return buttons

    }

    func createButtonsForScroll(total: Int, scroll: UIScrollView) -> [UIButton]{
        var button  = UIButtonBorder(type: UIButtonType.System)
        var buttons : [UIButton] = []

        for (_, item) in scroll.subviews.enumerate(){
            item.removeFromSuperview()
        }

        for index in 0..<total {
            button = UIButtonBorder(type: UIButtonType.System)
            let indexFloat = CGFloat(index)
            let frame = CGRect(
                x: button.buttonMarginX,
                y: indexFloat * (button.buttonMarginY + button.buttonHeight),
                width: button.buttonWidth,
                height: button.buttonHeight )
            button.frame = frame
            button.titleLabel?.numberOfLines = 0

            button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
            buttons.append(button as UIButton)
            scroll.addSubview(button)
        }

        scroll.contentSize.width = button.buttonWidth + CGFloat(2)
        scroll.contentSize.height = (button.buttonHeight + button.buttonMarginY) * CGFloat(total)

        return buttons
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Move focus to title for VoiceOver
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.navigationItem.titleView);
    }

    //TODOsoon move focus to title on viewWillAppear
}
