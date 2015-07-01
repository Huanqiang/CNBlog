//
//  OnlineNews.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

class OnlineNews: OnlineInformation {
   
    override func offlineInfo() -> Bool {
        // 1、将 NewsInfo 的标题图片存储
        if self.hasIcon {
            self.saveIconToDisk()
        }
        // 2、将 NewsInfo 信息（新闻、博客）中的所有的图片超链接全部修改为磁盘连接
        self.replaceContentImageUrl()
        // 3、创建离线新闻类
        var offlineNews: OfflineNews = OfflineNews(onlineInfo: self)
        offlineNews.setInfoContent(self.content)
        
        if offlineNews.saveOfflineInfo() {
            return true
        }else {
            return false
        }
    }

    override func gainContentNetworkOperation() ->NetworkOperation {
        return NetworkOperationWithNewsContext()
    }
    
    override func gainCNBlogAPIOption() ->CNBlogAPIOption {
        return CNBlogAPIOption.newsContext
    }
}
