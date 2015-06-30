//
//  Blogger.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

let BloggerIconFolderName = "BloggerIcon"

class Blogger: NSObject {
    var bloggerId: String          = ""        // 博主Id
    var bloggerName: String        = ""        // 博主名称
    var bloggerIconURL: String     = ""        // 博主头像网络URL
    var bloggerIconPath: String    = ""        // 博主头像本地路径
    var bloggerArticleCount: Int   = 0         // 博主文章数量
    var bloggerUpdatedTime: NSDate = NSDate()  // 博主最后活跃时间
    var bloggerIconInfo: UIImage   = UIImage() // 博主头像image
    
    let folder: FolderOperation = FolderOperation()
    
    override init() {
    }
    
    init(bId:String, bName: String) {
        super.init()
        self.bloggerId = bId;
        self.bloggerName = bName;
    }
    
    init(blogger: Blogger) {
        self.bloggerName         = blogger.bloggerName
        self.bloggerId           = blogger.bloggerId
        self.bloggerIconURL      = blogger.bloggerIconURL
        self.bloggerArticleCount = blogger.bloggerArticleCount
        self.bloggerUpdatedTime  = blogger.bloggerUpdatedTime
    }
    
    /**
    将图片存储至磁盘
    
    :param: img 图片
    
    :returns: 图片的名称
    */
    func saveImage(img: UIImage, imgName: String) -> String {
        let localIconPath = folder.saveImageToFolder(BloggerIconFolderName, image: img, imageName: imgName)
        return imgName
    }
    
    /**
    保存当前博主的头像
    */
    func saveIconToDisk() {
        //创建文件夹
        folder.createFolderWhenNon(BloggerIconFolderName)
        self.bloggerIconPath = self.saveImage(self.bloggerIconInfo, imgName: "\(self.bloggerId).png")
    }
    
    /**
    从磁盘获取当前博主的头像
    
    :returns: 当前博主的头像
    */
    func gainIconFromDick() -> UIImage {
        return folder.gainImageFromFolder(BloggerIconFolderName, imageName: self.bloggerIconPath)
    }
    
    /**
    保存博主状态
    */
    func saveBlogger() ->Bool { return true }
    

    /**
    获取博主自己的信息
    
    :returns: 博主自己的信息
    */
    func gainBloggerSelfInfo() -> Blogger {
        return Blogger()
    }
    
    /**
    判断博主自己是否登录
    
    :returns: 登录返回True，否则返回False
    */
    func isLoginSelf() ->Bool {
        return true
    }
    
    /**
    获取所有的博主的关注人
    
    :returns: 博主的关注人数组
    */
    func gainBloggerAttentioners() -> [Blogger] {
        return []
    }
    
}



// 使用者
class BloggerOwned: Blogger {
    let loginTool: LogInToolClass = LogInToolClass.shareInstance() as! LogInToolClass
    
    override init() {
        super.init()
    }
    
    override init(blogger: Blogger) {
        super.init(blogger: blogger)
    }
    
    override func saveBlogger() -> Bool {
        // 将博主信息保存至配置文件
        self.saveBloggerID()
        self.saveBloggerName()
        self.saveBloggerIconPath()
        self.saveBloggerArticleCount()
        self.saveBloggerUpdatedTime()
        self.saveLoginCookie()
        
        return true
    }
    
    override func gainBloggerSelfInfo() -> Blogger {
        var bloggerSelf: BloggerOwned   = BloggerOwned()
        bloggerSelf.bloggerArticleCount = self.gainBloggerArticleCount()
        bloggerSelf.bloggerIconPath     = self.gainBloggerIconPath()
        bloggerSelf.bloggerId           = self.gainBloggerID()
        bloggerSelf.bloggerName         = self.gainBloggerName()
        bloggerSelf.bloggerUpdatedTime  = self.gainBloggerUpdatedTime()
        
        return bloggerSelf
    }
    
    
    // MARK: - 博主数据基础操作
    // 保存
    func saveBloggerID() {
        loginTool.saveUserInfo(self.bloggerId, andInfoType: "bloggerId")
    }
    
    func saveBloggerName() {
        loginTool.saveUserInfo(self.bloggerName, andInfoType: "bloggerName")
    }
    
    func saveBloggerIconPath() {
        loginTool.saveUserInfo(self.bloggerIconPath, andInfoType: "bloggerIconPath")
    }
    
    func saveBloggerArticleCount() {
        loginTool.saveUserInfo("\(self.bloggerArticleCount)", andInfoType: "bloggerArticleCount")
    }
    
    func saveBloggerUpdatedTime() {
        loginTool.saveUserInfo(self.bloggerUpdatedTime.dateToStringWithDateFormat(CNBlogDateFormatForApi), andInfoType: "bloggerUpdatedTime")
    }
    
    func saveLoginCookie() {
        loginTool.saveCookie(true)
    }
    
    
    // 获取
    func gainBloggerID() -> String {
        return loginTool.getUserInfo("bloggerId")
    }
    
    func gainBloggerName() -> String {
        return loginTool.getUserInfo("bloggerName")
    }
    
    func gainBloggerIconPath() -> String {
        return loginTool.getUserInfo("bloggerIconPath")
    }
    
    func gainBloggerArticleCount() -> Int {
        return (loginTool.getUserInfo("bloggerArticleCount") as String).toInt()!
    }
    
    func gainBloggerUpdatedTime() -> NSDate {
        return loginTool.getUserInfo("bloggerUpdatedTime").stringToDateWithDateFormat(CNBlogDateFormatForApi)
    }
    
    override func isLoginSelf() ->Bool {
        return loginTool.isCookie()
    }
}

// 被关注的博主类
class BloggerAttentioner: Blogger {
    
    override init() {
        super.init()
    }
    
    init(bloggerEntity: BloggerAttentionEntity) {
        super.init()
        self.bloggerName         = bloggerEntity.bloggerName
        self.bloggerId           = bloggerEntity.bloggerId
        self.bloggerIconPath     = bloggerEntity.bloggerIconPath
        self.bloggerArticleCount = bloggerEntity.bloggerArticleCount.integerValue
        self.bloggerUpdatedTime  = bloggerEntity.bloggerUpdatedTime
    }
    
    override init(blogger: Blogger) {
        super.init(blogger: blogger)
    }

    // MARK:- 关注人操作
    override func saveBlogger() -> Bool {
        // 存储照片
        self.saveIconToDisk()
        
        // 存到 CoreData 之中
        var coreDataOperation: CoreDataOperation = CoreDataOperationWithBlogger()
        return coreDataOperation.insertAttentioners(self)
    }
    
    override func gainBloggerAttentioners() -> [Blogger] {
        var coreDataOperation: CoreDataOperation = CoreDataOperationWithBlogger()
        return coreDataOperation.gainAttentioners()
    }
    
}