//
//  ViewController.swift
//  DemoPushNotification
//
//  Created by Nattapong Unaregul on 6/23/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
class ViewController: UIViewController {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myBody: UILabel!
    var payloadNotificationViewModel : PayloadNotificationViewModel? {
        didSet {
            if let payload = payloadNotificationViewModel {
                myTitle.text = payload.title
                myBody.text = payload.body
                myImage.image = payload.attachedImage
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

