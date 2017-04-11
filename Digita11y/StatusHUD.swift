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
    
    var s: String?
    
    override open func viewWillAppear(_ animated: Bool) {
        self.box?.layer.cornerRadius = 7.0;
        self.label?.text = s
    }
    
    open func show(string s: String = "") {
        if let kw = UIApplication.shared.windows.last {
            self.s = s
            kw.addSubview(self.view)
        }
    }
    
    open func hide() {
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
