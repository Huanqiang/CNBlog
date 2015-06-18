//
//  OfflineNews.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

class OfflineNews: OfflineInformation {
    override init() {
        super.init()
        
        self.coreDataOperation = CoreDataOperationWithNews()
    }

    override init(onlineInfo: OnlineInformation) {
        super.init(onlineInfo: onlineInfo)
        
        self.coreDataOperation = CoreDataOperationWithNews()
    }
    
    init(offlineInfo: OfflineNewsBaseInfoEntity) {
        super.init()
        self.id          = offlineInfo.newsId
        self.title       = offlineInfo.newsTitle
        self.summary     = offlineInfo.newsSummary
        self.author      = offlineInfo.newsAuthor
        self.publishTime = offlineInfo.newsPublishTime
        self.iconPath    = offlineInfo.newsIconPath
        self.hasIcon     = offlineInfo.newsHasIcon.boolValue
        
        self.coreDataOperation = CoreDataOperationWithNews()
    }
    
    init(offlineContent: OfflineNewsContentEntity) {
        super.init()
        self.content = offlineContent.newsContent
        
        self.coreDataOperation = CoreDataOperationWithNews()
    }
}
