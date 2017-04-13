//
//  StatusHUD.swift
//  Digita11y
//
//  Created by Joe Zobkiw on 4/10/17.
//  Copyright © 2017 Roundware. All rights reserved.
//
/*
    let hud = StatusHUD.create()?.show(string: "This is a major test")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { // 3 seconds
        hud?.hide()
    }
*/

import Foundation
import UIKit

open class StatusHUD: UIViewController {
    
    @IBOutlet weak var box: UIView?
    @IBOutlet weak var label: UILabel?
    
    let dtMinimumShowTimeInterval = DispatchTimeInterval.milliseconds(500)  // minimum time the hud should be displayed
    let dtMaximumShowTimeInterval = DispatchTimeInterval.seconds(5)         // maximum time the hud should be displayed
    
    var s: String = ""
    var dtMinimumShowTime: DispatchTime = DispatchTime.now()
    var maximumShowTimeTask: DispatchWorkItem? = nil
    
    override open func viewWillAppear(_ animated: Bool) {
        self.box?.layer.cornerRadius = 7.0;
        self.label?.text = self.s
    }
    
    open func show(string s: String = "") {
        // already visible, update text only
        if (self.view.superview != nil) {
            self.s = s
            self.label?.text = self.s
            return;
        }
        
        // show hud
        if let kw = UIApplication.shared.windows.last {
            
            // pre-calculate minimum show time for the hud
            self.dtMinimumShowTime = DispatchTime.now() + self.dtMinimumShowTimeInterval
            
            // pre-calculate the maximum show time for the hud
            self.maximumShowTimeTask = DispatchWorkItem { self._hide() }

            // schedule the maximum show task
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.dtMaximumShowTimeInterval, execute: self.maximumShowTimeTask!)

            self.s = s
            kw.addSubview(self.view)
        }
    }
    
    open func hide() {
        // already hidden, do nothing
        if (self.view.superview == nil) {
            return
        }

        // if the maximum task has already been cancelled then we are already in the hide method (it may have been called twice in a row)
        if (self.maximumShowTimeTask?.isCancelled)! {
            return
        }

        // cancel maximum show time task
        self.maximumShowTimeTask?.cancel()

        // queue the removal of the view from superview
        DispatchQueue.main.asyncAfter(deadline: self.dtMinimumShowTime) {
            self._hide()
        }
    }
    
    func _hide() {
        self.view.removeFromSuperview()
    }
}

extension StatusHUD {
    class func create() -> StatusHUD? {
        let storyboard = UIStoryboard(name: "StatusHUD", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StatusHUD")
        return controller as? StatusHUD
    }
}
