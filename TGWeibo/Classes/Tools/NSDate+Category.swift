//
//  NSDate+Category.swift
//  TGWeibo
//
//  Created by Theodore Guo on 2/2/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

extension NSDate {
    class func dateWithStr(time: String) -> NSDate {
        // 1. Convert time string from serve to NSDate
        // 1.1 Create formatter
        let formatter = NSDateFormatter()
        // 1.2 Set date format
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        // 1.3 Set time zone
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 1.4 Convert string to formatted date without time zone
        let createdDate = formatter.dateFromString(time)!
        
        return createdDate
    }
    
    /**
     just now: within 1 min
     x min ago: within 1 hour
     x hour ago: the very day
     yesterday HH:mm: yesterday
     MM-dd HH:mm: within 1 year
     yyyy-MM-dd HH:mm: 1 year or earlier before
     */
    var descDate:String {
        let calendar = NSCalendar.currentCalendar()
        
        // 1. Judge it's today or not
        if calendar.isDateInToday(self)
        {
            // 1.0 Get time interval between current one to system (sec)
            let since = Int(NSDate().timeIntervalSinceDate(self))
//            print("since = \(since)")
            // 1.1 Judge it's just now or not
            if since < 60
            {
                return "just now"
            }
            // 1.2 Judge it's x min ago or not
            if since < 60 * 60
            {
                return "\(since/60) min ago"
            }            
            // 1.3 Judge it's x hour ago or not
            return "\(since / (60 * 60)) hour ago"
        }
        
        // 2. Judge it's yesterday or not
        var formatterStr = "HH:mm"
        if calendar.isDateInYesterday(self) {
            // yesterday HH:mm
            formatterStr =  "yesterday " +  formatterStr
        } else {
            // 3. Dispose the date that is within 1 year
            formatterStr = "MM-dd " + formatterStr
            
            // 4. Dispose the date that is 1 year or earlier before
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if comps.year >= 1 {
                formatterStr = "yyyy-" + formatterStr
            }
        }
        
        // 5. Convert NSDate to string based on formatter
        // 5.1 Create formatter
        let formatter = NSDateFormatter()
        // 5.2 Set date formatter
        formatter.dateFormat = formatterStr
        // 5.3 Set time zone
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 5.4 Format
        return formatter.stringFromDate(self)
    }
}
