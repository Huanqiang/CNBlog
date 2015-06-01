//
//  OfflineInformation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

class OfflineInformation: NSObject {
    var id: String          = ""       // Id
    var title: String       = ""       // 标题
    var summary: String     = ""       // 摘要
    var author: String      = ""       // 作者
    var content: String     = ""       // 内容
    var publishTime: NSDate = NSDate() // 发布时间
    var iconPath: String    = ""       // 标题图片 本地路径
    var hasIcon: Bool       = false    // 是否有标题图片
    
    
    
    init(let oId:String, let oTitle:String, let oSummary:String, let oAuthor:String, let oPublishDate:NSDate, let oIconPath:String) {
        super.init()
        self.id = oId
        self.title = oTitle
        self.summary = oSummary
        self.author = oAuthor
        self.publishTime = oPublishDate
        self.iconPath = oIconPath
    }
    
    // MARK: - 基本信息设置
    
    /**
    设置资讯内容
    
    :param: oContent 资讯内容
    */
    func setContent(let oContent:String) {
        self.content = oContent;
    }
    
    
    // MARK: - 获取离线内容
    // 在获取时，则按照需求从各个表获取所需的信息，分别有两个表，第一个基本信息表，第二个内容表（id + 内容）
    
}
