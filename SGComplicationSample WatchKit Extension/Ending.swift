//
//  Ending.swift
//  SGComplicationSample
//
//  Created by mogmet on 2016/02/27.
//  Copyright © 2016年 mogmet. All rights reserved.
//

import Foundation

class Ending {
    let time:NSDate
    let title:String
    let thumbnailURL:String
    
    init(time: NSDate, title: String, thumbnailURL: String) {
        self.time = time
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
}