//
//  OnlineBlog.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

class OnlineBlog: OnlineInformation {
    var authorUrl: String   = ""  // 作者URL
    
    override func offlineInfo() -> Bool {
        // 1、将 NewsInfo 信息（新闻、博客）中的所有的图片超链接全部修改为磁盘连接
        self.replaceContentImageUrl()
        // 2、创建离线新闻类
        let offlineBlog: OfflineBlog = OfflineBlog(onlineInfo: self)
        offlineBlog.setInfoContent(self.content)
        
        if offlineBlog.saveOfflineInfo() {
            return true
        }else {
            return false
        }
    }
    
    override func gainContentNetworkOperation() ->NetworkOperation {
        return NetworkOperationWithBlogContext()
    }
    
    override func gainCNBlogAPIOption() ->CNBlogAPIOption {
        return CNBlogAPIOption.blogsContext
    }
}
