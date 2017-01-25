import UIKit
import Foundation
class BaseViewController: UIViewController {
    var rwData: RWData?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let to = segue.destination as? BaseViewController {
            to.rwData = self.rwData
        }
    }

    //TODO move to UIScrollView extension or class
    //TODO add subViewLayout method too
    //TODO refactor to allow passing button subclass as param

    func createCenteredTagButtonsForScroll(_ total: Int, scroll: UIScrollView) -> [UIButton]{

        var button  = UIButtonTag(type: UIButtonType.system)
        var buttons : [UIButton] = []

        for (_, item) in scroll.subviews.enumerated(){
            item.removeFromSuperview()
        }

        for index in 0..<total {
            button = UIButtonTag(type: UIButtonType.system)
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
    func createTagButtonsForScroll(_ total: Int, scroll: UIScrollView) -> [UIButton]{

        var button  = UIButtonTag(type: UIButtonType.system)
        var buttons : [UIButton] = []

        for (_, item) in scroll.subviews.enumerated(){
            item.removeFromSuperview()
        }
        let newContentOffsetX = (button.buttonWidth - scroll.bounds.size.width) / 2
//        debugPrint("new content offset \(newContentOffsetX)")

        for index in 0..<total {
            button = UIButtonTag(type: UIButtonType.system)
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

    func createButtonsForScroll(_ titles: [String], scroll: UIScrollView) -> [UIButton]{
        var button  = UIButtonBorder(type: UIButtonType.system)
        var buttons : [UIButton] = []
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0

        for (_, item) in scroll.subviews.enumerated(){
            item.removeFromSuperview()
        }

        for (index, title) in titles.enumerated() {
            button = UIButtonBorder(type: UIButtonType.system)
            button.setTitle(title, for: UIControlState())
            let frame = CGRect(
                x: button.buttonMarginX,
                y: height,
                width: button.buttonWidth,
                height: button.buttonHeight )
            width = max(width, button.buttonWidth)
            height = height + button.buttonMarginY + button.buttonHeight
            button.frame = frame
            buttons.append(button as UIButton)
            scroll.addSubview(button)
        }
        
        scroll.contentSize.width = width
        scroll.contentSize.height = height
        return buttons
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Move focus to title for VoiceOver
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.navigationItem.titleView);
    }

    //TODOsoon move focus to title on viewWillAppear
}
