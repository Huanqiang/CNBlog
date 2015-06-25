//
//  XMLOperation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/2.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import AEXML

let CNBlogDateFormatForApi = "yyyy-MM-dd'T'HH:mm:sszzz"

class XMLOperation: NSObject {
    var xmlElements: [AnyObject] = []
    
    /**
    解析完整 API的 XML 信息（处理 XML 入口）
    
    :param: xmlData 网络操作的NSData数据
    
    :returns: OnlineInformation 数组
    */
    func gainXmlInfoLists(xmlData: NSData) -> [AnyObject] {
        xmlElements = []
        
        var error: NSError?
        if let xmlDoc = AEXMLDocument(xmlData: xmlData, error: &error) {
            self.gainXmlDoc(xmlDoc)
        }
        
        return xmlElements
    }
    
    /**
    开始处理处理整个 XML 格式
    
    :param: xmlDoc XML 信息
    */
    func gainXmlDoc(xmlDoc: AEXMLDocument) { }
    
    /**
    获取单个 OnlineInformation 的信息
    
    :param: newsList 单个XMl信息组
    
    :returns: 单个 OnlineInformation 的信息
    */
    func gainNewsElement(newsList: AEXMLElement) -> OnlineInformation {
        return OnlineInformation()
    }
    
    /**
    获取单个的博主信息
    
    :param: newsList 单个XML信息组
    
    :returns: 单个的博主信息
    */
    func gainBloggerElement(newsList: AEXMLElement) -> Blogger {
        return Blogger()
    }
}

// 新闻解析类
class NewsXmlOperation: XMLOperation {
    
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root["entry"].all
        for newsList in newsLists! {
            xmlElements.append(self.gainNewsElement(newsList))
        }
    }

    override func gainNewsElement(newsList: AEXMLElement) -> OnlineInformation {
        var onlineInfo: OnlineNews = OnlineNews()
        
        onlineInfo.id      = newsList["id"].stringValue
        onlineInfo.title   = newsList["title"].stringValue
        onlineInfo.summary = newsList["summary"].stringValue
        onlineInfo.diggs   = newsList["diggs"].stringValue.toInt()!
        onlineInfo.views   = newsList["views"].stringValue.toInt()!
        if equal(newsList["topicIcon"].stringValue, "") {
            onlineInfo.hasIcon = false
        }else {
            onlineInfo.hasIcon = true
            onlineInfo.iconURL = newsList["topicIcon"].stringValue
        }
        onlineInfo.author  = newsList["sourceName"].stringValue
        
        let dateStr: String = newsList["published"].stringValue
        onlineInfo.publishTime =  dateStr.stringToDateWithDateFormat(CNBlogDateFormatForApi)

        return onlineInfo
    }
}

class NewsContentXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root["Content"].all
        for newsList in newsLists! {
            xmlElements.append(self.gainNewsElement(newsList))
        }
    }
    
    override func gainNewsElement(newsList: AEXMLElement) -> OnlineInformation {
        var onlineInfo: OnlineInformation = OnlineNews()
        onlineInfo.content = newsList.stringValue
        return onlineInfo
    }
}

// 博客解析类
class BlogXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root["entry"].all
        for newsList in newsLists! {
            xmlElements.append(self.gainNewsElement(newsList))
        }
    }
    
    override func gainNewsElement(newsList: AEXMLElement) -> OnlineInformation {
        var onlineInfo: OnlineBlog = OnlineBlog()
        onlineInfo.id          = newsList["id"].stringValue
        onlineInfo.title       = newsList["title"].stringValue
        onlineInfo.summary     = newsList["summary"].stringValue
        onlineInfo.diggs       = newsList["diggs"].stringValue.toInt()!
        onlineInfo.views       = newsList["views"].stringValue.toInt()!
        onlineInfo.authorUrl   = newsList["author"]["uri"].stringValue
        onlineInfo.author      = newsList["author"]["name"].stringValue

        let dateStr: String    = newsList["published"].stringValue
        onlineInfo.publishTime = dateStr.stringToDateWithDateFormat(CNBlogDateFormatForApi)
        
        return onlineInfo
    }
}

class BlogContentXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root.all
        for newsList in newsLists! {
            xmlElements.append(self.gainNewsElement(newsList))
        }
    }
    
    override func gainNewsElement(newsList: AEXMLElement) -> OnlineInformation {
        var onlineInfo: OnlineInformation = OnlineNews()
        onlineInfo.content = newsList.stringValue
        return onlineInfo
    }
}


// 搜索博主网络操作 解析类
class SearchBloggerXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root["entry"].all
        for newsList in newsLists! {
            xmlElements.append(self.gainBloggerElement(newsList))
        }
    }
    
    override func gainBloggerElement(newsList: AEXMLElement) -> Blogger {
        var blogger: Blogger = Blogger()
        blogger.bloggerId           = newsList["blogapp"].stringValue
        blogger.bloggerIconURL      = newsList["avatar"].stringValue
        blogger.bloggerName         = newsList["title"].stringValue
        blogger.bloggerArticleCount = newsList["postcount"].stringValue.toInt()!

        let dateStr: String         = newsList["updated"].stringValue
        blogger.bloggerUpdatedTime  = dateStr.stringToDateWithDateFormat(CNBlogDateFormatForApi)
        return blogger
    }
}
