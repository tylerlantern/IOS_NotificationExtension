//
//  PayloadNotificationViewModel.swift
//  DemoPushNotification
//
//  Created by Nattapong Unaregul on 6/23/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import Foundation
import UIKit
class PayloadNotificationViewModel : NSObject {
    
    
    //    userInfo:Optional({
    //    alert =     {
    //    body = "5 to 1";
    //    title = Hahaha;
    //    };
    //    "content-available" = 1;
    //    "mutable-content" = 1;
    //    })
    init (userData : [AnyHashable : Any]? ,  data : NSData? ){
        super.init()
        self.userData = userData
        self.data = data
    }
    fileprivate var userData : [AnyHashable : Any]?
    fileprivate var data : NSData?
    var title : String {
        get {
            if let data = userData
                , let aps = data["aps"] as? [AnyHashable:Any]
                , let alert = aps["alert"] as? [AnyHashable:Any]
                , let title = alert["title"] as? String
            {
                return title
            }
            return ""
        }
    }
    var body : String {
        get {
            if let data = userData
                , let aps = data["aps"] as? [AnyHashable:Any]
                , let alert = aps["alert"] as? [AnyHashable:Any]
                , let title = alert["body"] as? String
            {
                return title
            }
            return ""
        }
    }
    var attachedImage : UIImage? {
        get {
            return data == nil ? nil : UIImage(data: data! as Data)
        }
    }
}
