//
//  NetworkOperation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/2.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import Alamofire

// 网络操作 API
enum CNBlogAPIOption {
    case recentNews
    case popNews
    case commendNews
    case newsContext
    
    case homePageBlog
    case twoDaysPopBlog
    case tenDaysPopBlog
    case blogsContext
    
    case myBlogOption
    case searchOption
}

let CNBlogMainUrl = "http://wcf.open.cnblogs.com"

class NetworkOperation: NSObject {

    /**
    开始进行网络操作
    
    :param: menuOption        接口 enum选项（选择哪一个接口）
    :param: parameters        URL参数数组
    :param: completionHandler 网络结果操作闭包
    */
    func gainInfomationFromNetwork(menuOption: CNBlogAPIOption, parameters: [String], completionHandler: (onlineInfo : [AnyObject]?) -> Void) {
        // 获取网络操作数据
        // 1、Url拼凑
        var urlString: String = self.gainURLString(menuOption, parameters: parameters)
        Alamofire.request(.GET, urlString)
            .responseString { (_, _, string, _) in
                // 解析XML
                var xmlInfoData = string?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
                if (xmlInfoData != nil) {
                    let xmlOperation = self.createXmlOpertion()
                    // 执行操作 completionHandler()
                    completionHandler(onlineInfo: xmlOperation.gainXmlInfoLists(xmlInfoData!))
                }else {
                    // 返回nil， 表示网络操作失败
                    completionHandler(onlineInfo: nil)
                }
        }
    }
    
    /**
    处理并获取相应的API信息
    
    :param: menuOption 接口 enum选项（选择哪一个接口）
    :param: parameters URL参数数组
    
    :returns: 返回相应的API的URL字符串
    */
    func gainURLString(menuOption: CNBlogAPIOption, parameters: [String]) -> String {
        return ""
    }
    
    
    /**
    产生一个XMLOperation
    
    :returns: 返回一个XMLOperation
    */
    func createXmlOpertion() -> XMLOperation {
        return XMLOperation()
    }
}

// News 网络操作
class NetworkOperationWithNews: NetworkOperation {
    override func gainURLString(menuOption: CNBlogAPIOption, parameters: [String]) -> String {
        var urlString = CNBlogMainUrl + "/news"
        
        switch menuOption {
        case CNBlogAPIOption.recentNews:
            urlString += "/recent"
        case CNBlogAPIOption.popNews:
            urlString += "/hot"
        case CNBlogAPIOption.commendNews:
            urlString += "/recommend/paged"
        default:
            println("")
        }
        
        for parameter in parameters {
            urlString += "/\(parameter)"
        }
        
        return urlString
    }
    
    override func createXmlOpertion() -> XMLOperation {
        return NewsXmlOperation()
    }
}

// NewsContext 网络操作
class NetworkOperationWithNewsContext: NetworkOperation {
    override func gainURLString(menuOption: CNBlogAPIOption, parameters: [String]) -> String {
        var urlString = CNBlogMainUrl + "/news" + "/item"
        for parameter in parameters {
            urlString += "/\(parameter)"
        }
        return urlString
    }
    
    override func createXmlOpertion() -> XMLOperation {
        return NewsContentXmlOperation()
    }
}

// 获取 博客 的网络类
class NetworkOperationWithBlog: NetworkOperation {
    override func gainURLString(menuOption: CNBlogAPIOption, parameters: [String]) -> String {
        var urlString = CNBlogMainUrl + "/news"
        
        switch menuOption {
        case CNBlogAPIOption.recentNews:
            urlString += "/sitehome/recent"
        case CNBlogAPIOption.popNews:
            urlString += "/48HoursTopViewPosts"
        case CNBlogAPIOption.commendNews:
            urlString += "/TenDaysTopDiggPosts"
        default:
            println("")
        }
        
        for parameter in parameters {
            urlString += "/\(parameter)"
        }
        return urlString
    }
    
    override func createXmlOpertion() -> XMLOperation {
        return BlogXmlOperation()
    }
}

class NetworkOperationWithBlogContext: NetworkOperation {
    override func gainURLString(menuOption: CNBlogAPIOption, parameters: [String]) -> String {
        var urlString = CNBlogMainUrl + "/blog/post/body"
        for parameter in parameters {
            urlString += "/\(parameter)"
        }
        return urlString
    }
    
    override func createXmlOpertion() -> XMLOperation {
        return BlogContentXmlOperation()
    }
}

// 获取 博主的博客操作类  blog/u/{Blogapp}/posts/1/5
class NetworkOperationWithBlogListOfBlogger: NetworkOperation {
    override func gainURLString(menuOption: CNBlogAPIOption, parameters: [String]) -> String {
        var urlString = CNBlogMainUrl + "/blog/u" + "/{\(parameters[0])}" + "/posts" + "/{\(parameters[1])}" + "/{\(parameters[2])}"
        return urlString
    }
    
    override func createXmlOpertion() -> XMLOperation {
        return BlogXmlOperation()
    }
}


// 搜索博主 网络类
class NetworkOperationWithSearchBlogger: NetworkOperation {
    override func gainURLString(menuOption: CNBlogAPIOption, parameters: [String]) -> String {
        var urlString = CNBlogMainUrl + "/blog/bloggers/search?t=\(parameters[0])"
        return urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
    
    override func createXmlOpertion() -> XMLOperation {
        return SearchBloggerXmlOperation()
    }
}

