//
//  InterfaceController.swift
//  SGComplicationSample WatchKit Extension
//
//  Created by mogmet on 2016/02/27.
//  Copyright © 2016年 mogmet. All rights reserved.
//

import WatchKit
import ClockKit
import Foundation


class InterfaceController: WKInterfaceController {
    private var ending: Ending?
    private let dateFormatter = NSDateFormatter()
    @IBOutlet var thumbImage: WKInterfaceImage!
    @IBOutlet var endingDateLabel: WKInterfaceLabel!
    @IBOutlet var endingTitleLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.dateFormatter.locale = NSLocale(localeIdentifier: "ja")
        self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.reloadView()
    }

    /**
    Complicationから来た日付から表示を変える
    
    :param: userInfo
    */
    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
        super.handleUserActivity(userInfo)
        let tapDate = userInfo?[CLKLaunchedTimelineEntryDateKey] as? NSDate ?? NSDate()
        self.ending = WorldLine.endings.filter { $0.time.isEqualToDate(tapDate) }.first
        self.reloadView()
    }
    
    /**
     描画再更新
     */
    func reloadView() {
        let title = self.ending?.title ?? "Welcome"
        let time = self.ending?.time ?? NSDate()
        let imageURL = self.ending?.thumbnailURL ?? ""
        self.endingTitleLabel.setText(title)
        self.endingDateLabel.setText(self.dateFormatter.stringFromDate(time))
        self.thumbImage.setImageWithUrl(imageURL)
    }
    
}
