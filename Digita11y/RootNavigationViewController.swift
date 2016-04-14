//
//  RootNavigationViewController.swift
//  Digita11y
//
//  Created by Christopher Reed on 3/12/16.
//  Copyright © 2016 Roundware. All rights reserved.
//

import Foundation
import UIKit
import RWFramework
import Crashlytics
import SwiftyJSON
import CoreLocation


class RootNavigationViewController: UINavigationController, UINavigationControllerDelegate, RWFrameworkProtocol {
    static var once: dispatch_once_t = 0

    var rwData: RWData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //TODO set correct appearance
        //TODO attach delegate for endpoint switcher (and make view)
        super.viewWillAppear(animated)
        if let vc = self.topViewController as? BaseViewController{
            vc.rwData = self.rwData
        }
    }
    
    // MARK: - RWFrameworkProtocol
    
    func rwUpdateStatus(message: String) {
        debugPrint(message)
        CLSNSLogv(message, getVaList([]))
    }
    
    func rwPostUsersFailure(error: NSError?) {
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
    func rwPostSessionsFailure(error: NSError?){
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }

    func rwGetProjectsIdTagsSuccess(data: NSData?) {
        let json = JSON(data: data!)
        self.rwData?.tags = json["tags"].array?.map { Tag(json: $0) } ?? []
    }
    
    func rwGetProjectsIdTagsFailure(error: NSError?) {
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
    func rwGetProjectsIdUIGroupsSuccess(data: NSData?) {
        let json = JSON(data: data!)
        self.rwData?.uiGroups = json["ui_groups"].array?.map { UIGroup(json: $0) } ?? []
    }
    
    func rwGetProjectsIdUIGroupsFailure(error: NSError?) {
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
    
    func rwGetAssetsSuccess(data: NSData?) {
        let json = JSON(data: data!)
        debugPrint("assets json received")
        self.rwData?.assets = json.array?.map { Asset(json: $0) } ?? []
        dump(self.rwData?.assets)
    }
    
    func rwGetAssetsFailure(error: NSError?) {
        debugPrint(error?.localizedDescription)
        CLSNSLogv((error?.localizedDescription)!, getVaList([]))
    }
}