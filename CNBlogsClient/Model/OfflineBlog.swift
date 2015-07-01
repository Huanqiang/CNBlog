//
//  OfflineBlog.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

class OfflineBlog: OfflineInformation {
    override init() {
        super.init()
        
        self.coreDataOperation = CoreDataOperationWithBlog()
    }
    
    override init(onlineInfo: OnlineInformation) {
        super.init(onlineInfo: onlineInfo)
        
        self.coreDataOperation = CoreDataOperationWithBlog()
    }
    
    init(offlineInfo: OfflineBlogBaseInfoEntity) {
        super.init()
        self.id          = offlineInfo.blogId
        self.title       = offlineInfo.blogTitle
        self.summary     = offlineInfo.blogSummary
        self.author      = offlineInfo.blogAuthor
        self.publishTime = offlineInfo.blogPublishTime
        
        self.coreDataOperation = CoreDataOperationWithBlog()
    }
    
    init(offlineContent: OfflineBlogContentEntity) {
        super.init()
        self.content = offlineContent.blogContent
        
        self.coreDataOperation = CoreDataOperationWithBlog()
    }
}
