//
//  ExtensionUIKit.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ***********   UIKit Extension ************

extension UITableView {
    func clearTableFooterView() {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        self.tableFooterView = view
    }
}


extension UIImage {
    
    func originalFrame() -> CGSize {
        let imageSouce = self.CGImage!
        return CGSizeMake(CGFloat(CGImageGetWidth(imageSouce)), CGFloat(CGImageGetHeight(imageSouce)))
    }
    
}

// MARK: - ***********   Foundation Extension ************

extension String {
    func stringToDateWithDateFormat(dateFormatStrring: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormatStrring
        return dateFormatter.dateFromString(self)!
    }
    
    /**
    判断手机号码是否符合正则表达式的要求
    
    - returns: 符合返回 ture，不符合返回 false
    */
    func validateMobile() -> Bool {
        let mobileStr = "^((145|147)|(15[^4])|(17[6-8])|((13|18)[0-9]))\\d{8}$"
        let cateMobileStr: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileStr)
        if cateMobileStr.evaluateWithObject(self) == true {
            return true
        }else {
            return false
        }
    }
    
    /**
    转到商店进行评分
    */
    func gotoGrade() {
        let str = NSString(string: "itms-apps://itunes.apple.com/app/id\(self)")
        self.openURL()
    }
    
    /**
    在浏览器中打开链接
    */
    func openURL() {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: self)!) {
            UIApplication.sharedApplication().openURL(NSURL(string: self)!)
        }
    }

}

let oneDayTimeInterval: NSTimeInterval = 86400

extension NSDate {

    /**
    NSDate 转换成的 字符串，返回形如 2015年6月4日的格式，同时如果是昨天，今天就返回昨天，今天
    
    - returns: 形如 2015年6月4日 的格式，同时如果是昨天，今天就返回昨天，今天
    */
    func dateToStringByBaseFormat() -> String {
        let now:NSDate = NSDate()
//        let yesterday: NSDate = NSDate()
        
        let time: NSTimeInterval = now.timeIntervalSinceDate(self)
        if  time < oneDayTimeInterval / 2 {
            return "今天下午"
        }else if time > oneDayTimeInterval / 2 && time < oneDayTimeInterval {
            return "今天上午"
        }else if time > oneDayTimeInterval && time < oneDayTimeInterval * 2 {
            return "昨天"
        }else {
            return self.dateToStringWithDateFormat("yyyy年MM月dd日")
        }
    }
    
    /**
    NSDate 转换成相应的 字符串
    
    - parameter dateFormatStrring: 要转化的时间戳格式
    
    - returns: 符合格式的 NSString
    */
    func dateToStringWithDateFormat(dateFormatStrring: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormatStrring
        return dateFormatter.stringFromDate(self)
    }
    
    /**
    得到昨天的此时此刻
    
    - returns: 返回昨天的日期数据
    */
    class func gainYesterdayDate() -> NSDate {
        return NSDate(timeIntervalSinceNow: -3600 * 24)
    }
    
    /**
    得到明天的此时此刻
    
    - returns: 返回明天的日期数据
    */
    class func gainTomorrowDate() -> NSDate {
        return NSDate(timeIntervalSinceNow: 3600 * 24)
    }
    
    /**
    得到 X 天后的此时此刻
    
    - parameter day: 天数
    
    - returns: 得到 X 天后的日期数据
    */
    class func gainSomeDayDate(day: Double) -> NSDate {
        return NSDate(timeIntervalSinceNow: 3600 * 24 * day)
    }
}