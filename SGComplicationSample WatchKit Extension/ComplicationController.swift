//
//  ComplicationController.swift
//  SGComplicationSample WatchKit Extension
//
//  Created by mogmet on 2016/02/27.
//  Copyright © 2016年 mogmet. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: -60*60*24))
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    // Call the handler with the current timeline entry
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        guard let ending = WorldLine.endings.first,
            modularTemplate = self.templateForComplication(complication, ending: ending) else {
                handler(nil)
                return
        }
        let timelineEntry = CLKComplicationTimelineEntry(date: ending.time, complicationTemplate: modularTemplate)
        handler(timelineEntry)
    }
    
    /**
     過去のタイムラインをセットする
     
     - parameter complication:
     - parameter date:
     - parameter limit:
     - parameter handler:
     */
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        let entries = WorldLine.endings.reduce([], combine: {(var entries: [CLKComplicationTimelineEntry], ending: Ending) -> [CLKComplicationTimelineEntry] in
            guard let template = self.templateForComplication(complication, ending: ending)
                where entries.count < limit else {
                    return entries
            }
            if ending.time.compare(date) == NSComparisonResult.OrderedAscending {
                let entry = CLKComplicationTimelineEntry(date: ending.time, complicationTemplate: template)
                entries.append(entry)
            }
            return entries
        })
        handler(entries)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(templateForComplication(complication, ending: Ending(time: NSDate(), title: "Welcome to the Beta World!", thumbnailURL: "")))
    }
    
    // MARK: - private method
    
    /**
    complication要素を生成
    
    - parameter complication:
    - parameter ending:
    
    - returns:
    */
    private func templateForComplication(complication: CLKComplication, ending: Ending) -> CLKComplicationTemplate? {
        var modularTemplate:CLKComplicationTemplate?
        let title = ending.title
        switch complication.family {
            case .ModularLarge:
                let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
                modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: title, shortText: title, accessibilityLabel: title)
                modularLargeTemplate.headerTextProvider = CLKTimeTextProvider(date: ending.time)
                modularTemplate = modularLargeTemplate
            default:
                return modularTemplate
        }
        return modularTemplate
    }
}
