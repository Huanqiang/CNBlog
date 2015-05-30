//
//  OnlineInformation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

/*
类说明： 本类为从网上获取的资讯类（新闻或者博客），在获取列表的时候创建，在获取内容的时候添加内容即可
*/

class OnlineInformation: NSObject {
    var id: String          = ""       // Id
    var title: String       = ""       // 标题
    var summary: String     = ""       // 摘要
    var author: String      = ""       // 作者
    var diggs: Int          = 0        // 推荐指数
    var views: Int          = 0        // 阅读数
    var iconURL: String     = ""       // 标题图片 URL
    var content: String     = ""       // 内容
    var publishTime: NSDate = NSDate() // 发布时间
    var iconPath: String    = ""       // 标题图片 本地路径
    
    init(let oId:String, let oTitle:String, let oSummary:String, let oAuthor:String, let oPublishDate:NSDate, let oDiggs:Int, let oViews:Int, let oIconURL:String) {
        super.init()
        self.id          = oId;
        self.title       = oTitle;
        self.summary     = oSummary;
        self.publishTime = oPublishDate;
        self.author      = oAuthor;
        self.diggs       = oDiggs;
        self.views       = oViews;
        self.iconURL     = oIconURL;
    }
    
    // MARK: - 基本信息设置
    
    /**
    设置资讯内容
    
    :param: oContent 资讯内容
    */
    func setContent(let oContent: String) {
        self.content = oContent;
    }
    
    /**
    设置标题图片的本地路径
    
    :param: localIconPath 标题图片的本地路径
    */
    func setIconPath(let localIconPath: String) {
        self.iconPath = localIconPath;
    }
    
    
    // MARK: - 进行离线数据的存储
    // 在存储时要注意，存为两个表，第一个表存基本信息，第一个表存 id+内容
}
