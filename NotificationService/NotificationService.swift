//
//  NotificationService.swift
//  NotificationService
//
//  Created by Nattapong Unaregul on 6/23/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UserNotifications
import MobileCoreServices

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        let semaphore = DispatchSemaphore(value: 0)
        let fmURL: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.tyler")!
        //        print("fmURL:\(fmURL)")
        if let bestAttemptContent = bestAttemptContent {
            print("userInfo:\(bestAttemptContent.userInfo)")
            if let attachmentString = bestAttemptContent.userInfo["mediaUrl"] as? String,
                let attachmentUrl = URL(string: attachmentString){
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let attachmentDownloadTask = session.downloadTask(with: attachmentUrl, completionHandler: { (url, response, error) in
                    if let error = error {
                        print("Error downloading attachment: \(error.localizedDescription)")
                    } else if let url = url {
                        let attachment = try! UNNotificationAttachment(identifier: attachmentString, url: url
                            , options: [UNNotificationAttachmentOptionsTypeHintKey : kUTTypePNG])
                        let data = NSData(contentsOf: url)!
                        var urllocalToWrite: URL? = nil
                        urllocalToWrite = fmURL.appendingPathComponent("customAttachmentPic").appendingPathExtension("jpg")
                        //                        print("urllocalToWrite:\(urllocalToWrite)")
                        data.write(to: urllocalToWrite!, atomically: true)
                        bestAttemptContent.attachments = [attachment]
                        semaphore.signal()
                    }
                    bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
                    contentHandler(bestAttemptContent)
                })
                attachmentDownloadTask.resume()
                semaphore.wait()
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
