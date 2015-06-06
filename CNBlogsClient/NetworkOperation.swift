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
    func gainInfomationFromNetwork(menuOption: CNBlogAPIOption, parameters: [String], completionHandler: (onlineInfo : [OnlineInformation]?) -> Void) {
        // 获取网络操作数据
//        weak var weakSelf: NetworkOperation? = self
        // 1、Url拼凑
        var urling: String = self.gainURLString(menuOption, parameters: parameters)
        Alamofire.request(.GET, urling)
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

class NetworkOperationWithBlog: NetworkOperation {
    //    <#properties and methods#>
}

class NetworkOperationWithMyBlog: NetworkOperation {
    //    <#properties and methods#>
}

class NetworkOperationWithSearchBlogger: NetworkOperation {
    //    <#properties and methods#>
}


//API：/news/hot/10
//A.	最近新闻
//API：http://wcf.open.cnblogs.com/news/recent/10
//B.	推荐新闻
//API：http://wcf.open.cnblogs.com/news/recommend/paged/1/5
////http://wcf.open.cnblogs.com/news/item/199054

//API：http://wcf.open.cnblogs.com/blog/sitehome/recent/5
//A.	两天内推荐博客
//API：http://wcf.open.cnblogs.com/blog/48HoursTopViewPosts/5
//B.	十天推荐排行
//API：http://wcf.open.cnblogs.com/blog/TenDaysTopDiggPosts/5
// http://wcf.open.cnblogs.com/blog/post/body/3535626


//API：http://wcf.open.cnblogs.com/blog/bloggers/search?t=博主名
//http://wcf.open.cnblogs.com/blog/u/{Blogapp}/posts/1/5





