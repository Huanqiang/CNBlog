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
let CacheFolderName = "Cache"

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
    
    let folder: FolderOperation = FolderOperation()
    
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
    
    // MARK: - 数据离线操作
    /**
    将图片存储至磁盘
    
    :param: img 图片
    
    :returns: 图片的磁盘路径
    */
    func saveImage(img: UIImage, imgName: String) -> String {
        let iconData = UIImagePNGRepresentation(img)
        let localIconPath = folder.saveImageToFolder(NewsIconFolderName, imageData: iconData, imageName: imgName)
        return localIconPath
    }
    
    /**
    保存标题图片
    */
    func saveIconToDisk() {
        //创建文件夹
        folder.createFolderWhenNon(NewsIconFolderName)
        self.iconPath = self.saveImage(self.iconInfo, imgName: "\(self.id).png")
    }
    
    /**
    将内容的图片全部存储
    
    :returns: 返回一个图片的网页链接和磁盘链接组成的字典<网页链接, 磁盘链接>
    */
    func saveContentImage() ->Dictionary<String, String> {
        //创建文件夹
        folder.createFolderWhenNon(NewsIconFolderName)
        // 获取缓存文件
        // 获取信息（新闻、博客）中的所有的图片链接
        var htmlParse: HTMLParserForInformation = HTMLParserForInformation()
        let imgTags = htmlParse.gainImaTagFromHTMLInfo(self.content)
        
        // 循环链接数组，将连接对应的图片存储至磁盘的指定文件夹，并将原连接和磁盘链接存到 imgTagDic 字典中
        var imgTagDic: Dictionary<String, String> = Dictionary<String, String>()
        for imgTag in imgTags {
            let img = folder.gainImageFromFolder(CacheFolderName, imageName: imgTag.lastPathComponent)
            imgTagDic[imgTag] = self.saveImage(img, imgName: imgTag.lastPathComponent)
        }
        return imgTagDic
    }
    
    /**
    修改信息（新闻、博客）中的所有的图片链接全部修改为磁盘连接，并将图片存储
    */
    func replaceContentImageUrl() {
        var htmlParse: HTMLParserForInformation = HTMLParserForInformation()
        // 修改信息（新闻、博客）中的所有的图片链接, 并存储
        self.setContent(htmlParse.replaceImaTagWithHTMLInfo(self.content, newImgTag: self.saveContentImage()))
    }
}
