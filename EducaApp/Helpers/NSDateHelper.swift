//
//  NSDateHelper.swift
//  EducaApp
//
//  Created by Alonso on 11/10/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

extension NSDate {
  
  func getNumberOfDays() -> Int {
    return Int(self.timeIntervalSince1970 / 86400.0)
  }
  
  func yearsFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
  }
  
  func monthsFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
  }
  
  func weeksFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
  }
  
  func daysFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
  }
  
  func hoursFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
  }
  
  func minutesFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
  }
  
  func secondsFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
  }
  
  func offsetFrom(date:NSDate) -> String {
    if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
    if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
    if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
    if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
    if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
    if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
    if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
    return ""
  }
  
  class func getDiffDate(date: NSDate) -> String {
    let currentDate = NSDate()
    let seconds = currentDate.secondsFrom(date)
    let minutes = currentDate.minutesFrom(date)
    let hours = currentDate.hoursFrom(date)
    let days = currentDate.daysFrom(date)
    let months = currentDate.monthsFrom(date)
    let years = currentDate.yearsFrom(date)
    if seconds < 60 {
      return seconds == 1 ? "Hace \(seconds) segundo." : "Hace \(seconds) segundos."
    } else if minutes < 60 {
      return minutes == 1 ? "Hace \(minutes) minuto." : "Hace \(minutes) minutos."
    } else if hours < 24 {
      return hours == 1 ? "Hace \(hours) hora." : "Hace \(hours) horas."
    } else if days <= 31 {
      return days == 1 ? "Hace \(days) día." : "Hace \(days) días."
    } else if months < 12 {
      return months == 1 ? "Hace \(months) mes." : "Hace \(months) meses."
    } else {
      return years == 1 ? "Hace \(years) año." : "Hace \(years) años."
    }
  }
  
}