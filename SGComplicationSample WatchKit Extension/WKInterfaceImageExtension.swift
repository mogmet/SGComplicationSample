//
//  WKInterfaceImageExtension.swift
//  SGComplicationSample
//
//  Created by mogmet on 2016/02/27.
//  Copyright © 2016年 mogmet. All rights reserved.
//

import WatchKit

public extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { data, response, error in
            if (data != nil && error == nil) {
                let image = UIImage(data: data!, scale: scale)
                dispatch_async(dispatch_get_main_queue()) {
                    self.setImage(image)
                }
            }
        }.resume()
        return self
    }
}