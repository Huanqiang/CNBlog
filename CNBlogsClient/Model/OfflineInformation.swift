//
//  OfflineInformation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

// 数据离线类：主要进行数据的存储与读取

class OfflineInformation: NSObject {
    var id: String          = ""       // Id
    var title: String       = ""       // 标题
    var summary: String     = ""       // 摘要
    var author: String      = ""       // 作者
    var content: String     = ""       // 内容
    var publishTime: NSDate = NSDate() // 发布时间
    var iconPath: String    = ""       // 标题图片 本地路径
    var hasIcon: Bool       = false    // 是否有标题图片
    
    var coreDataOperation: CoreDataOperation!
    
    override init() {
        super.init()
    }
    
    init(onlineInfo: OnlineInformation) {
        self.id          = onlineInfo.id
        self.title       = onlineInfo.title
        self.summary     = onlineInfo.summary
        self.author      = onlineInfo.author
        self.publishTime = onlineInfo.publishTime
        self.iconPath    = onlineInfo.iconPath
        self.hasIcon     = onlineInfo.hasIcon
    }
    
    init(let oId:String, let oTitle:String, let oSummary:String, let oAuthor:String, let oPublishDate:NSDate, let oIconPath:String) {
        super.init()
        self.id          = oId
        self.title       = oTitle
        self.summary     = oSummary
        self.author      = oAuthor
        self.publishTime = oPublishDate
        self.iconPath    = oIconPath
    }
    
    // MARK: - 基本信息设置
    
    /**
    设置资讯内容
    
    :param: oContent 资讯内容
    */
    func setInfoContent(oContent:String) {
        self.content = oContent;
    }
    
    // MARK: - 存储 离线内容
    // 在存储时要注意，存为两个表，第一个表存基本信息，第一个表存 id+内容
    func saveOfflineInfo() -> Bool {
        return coreDataOperation.insertOfflineInfo(self)
    }
    
    // MARK: - 删除 离线数据
    func deleteOfflineInfo() -> Bool { return true}
    
    // MARK: - 读取 离线数据
    // 在获取时，则按照需求从各个表获取所需的信息，分别有两个表，第一个基本信息表，第二个内容表（id + 内容）
    func gainOfflineBaseInfo() -> [OfflineInformation] {
        return coreDataOperation.gainOfflineBaseInfos()
    }
    
    func gainOfflineContent() {
        self.content = coreDataOperation.gainOfflineContentInfo(self.id).content
    }
}
