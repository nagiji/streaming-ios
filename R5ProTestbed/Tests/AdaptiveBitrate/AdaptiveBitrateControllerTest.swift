//
//  AdaptiveBitrateControllerTest.swift
//  R5ProTestbed
//
//  Created by Andy Zupko on 12/16/15.
//  Copyright © 2015 Infrared5. All rights reserved.
//

import UIKit
import R5Streaming

@objc(AdaptiveBitrateControllerTest)
class AdaptiveBitrateControllerTest: BaseTest {
    
    var controller : R5AdaptiveBitrateController? = nil

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        setupDefaultR5VideoViewController()
        
        // Set up the configuration
        let config = getConfig()
        // Set up the connection and stream
        let connection = R5Connection(config: config)
        
        setupPublisher(connection: connection!)
        // show preview and debug info
        
        self.currentView!.attach(publishStream!)
        
        //The Adaptive bitrate controller!
        controller = R5AdaptiveBitrateController()
        controller?.attach(to: self.publishStream!)
        controller?.requiresVideo = Testbed.getParameter(param: "video_on") as! Bool
        
        self.publishStream!.publish(Testbed.getParameter(param: "stream1") as! String, type: R5RecordTypeLive)
        
    }
    
    override func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        super.onR5StreamStatus(stream, withStatus: statusCode, withMessage: msg)
        if (Int(statusCode) == Int(r5_status_buffer_flush_start.rawValue)) {
            NotificationCenter.default.post(Notification(name: Notification.Name("BufferFlushStart")))
        }
        else if (Int(statusCode) == Int(r5_status_buffer_flush_empty.rawValue)) {
            NotificationCenter.default.post(Notification(name: Notification.Name("BufferFlushComplete")))
        }
    }
    
    override func closeTest() {
        
        if (controller != nil) {
            controller?.close();
        }
        
        super.closeTest()
        
    }

}
