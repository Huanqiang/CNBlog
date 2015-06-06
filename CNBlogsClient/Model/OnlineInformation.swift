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

let NewsIconFolderName = "NewsFolder"

class OnlineInformation: NSObject {
    var id: String          = ""        // Id
    var title: String       = ""        // 标题
    var summary: String     = ""        // 摘要
    var author: String      = ""        // 作者
    var diggs: Int          = 0         // 推荐指数
    var views: Int          = 0         // 阅读数
    var iconURL: String     = ""        // 标题图片 URL
    var content: String     = ""        // 内容
    var publishTime: NSDate = NSDate()  // 发布时间
    var iconInfo: UIImage   = UIImage() // 存放标题图片
    var iconPath: String    = ""        // 标题图片 本地路径
    var hasIcon: Bool       = false     // 是否有标题图片
    
    override init() {
        super.init()
    }
    
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
    保存标题图片
    */
    func saveIconToDisk() {
        //创建文件夹
        let folder: FolderOperation = FolderOperation()
        if !folder.isExitsWithTheFolder(NewsIconFolderName) {
            folder.createFolderInDocuments(NewsIconFolderName)
        }

        let iconData = UIImagePNGRepresentation(self.iconInfo)
        let localIconPath = folder.saveImageToFolder(NewsIconFolderName, imageData: iconData, imageName: self.id)
        self.iconPath = localIconPath
    }
}
