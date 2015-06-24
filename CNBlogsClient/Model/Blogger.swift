//
//  Blogger.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/30.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit

class Blogger: NSObject {
    var bloggerId: String          = ""        // 博主Id
    var bloggerName: String        = ""        // 博主名称
    var bloggerIconURL: String     = ""        // 博主头像网络URL
    var bloggerIconPath: String    = ""        // 博主头像本地路径
    var bloggerArticleCount: Int   = 0         // 博主文章数量
    var bloggerUpdatedTime: NSDate = NSDate()  // 博主最后活跃时间
    var bloggerIconInfo: UIImage   = UIImage() // 博主头像image
    
    override init() {
    }
    
    init(bId:String, bName: String) {
        super.init()
        self.bloggerId = bId;
        self.bloggerName = bName;
    }
    
    
    func saveBlogger() {
        
    }
}



// 使用者
class BloggerOwned: Blogger {
    var bloggerAttentionIds: [String] = []
    var bloggerAttentions: [BloggerAttentioner] = []
    
    init(bId: String, bName: String, bAttentionsId:[String]) {
        super.init(bId: bId, bName: bName)
        self.bloggerAttentionIds = bAttentionsId
    }
    
    // MARK: - 被关注博主的操作
    /**
    获取被关注博主的信息
    */
    func gainBloggerAttentions() {
        // 通过循环 bloggerAttentionIds 在数据库里获取 被关注博主
    }
    
    /**
    添加被关注的博主
    
    :param: bloggerId 被关注的博主的ID
    */
    func addBloggerAttentionIds(bloggerId: String) {
        bloggerAttentionIds.append(bloggerId)
        
        // 进行数据库的添加
        
    }
    
    /**
    删除 被关注的博主
    
    :param: bloggerId 被关注的博主的ID
    */
    func removeBloggerAttentionIds(bloggerId: String) {
        for var index = 0; index < bloggerAttentionIds.count; index++ {
            if bloggerId == bloggerAttentionIds[index] {
                bloggerAttentionIds.removeAtIndex(index)
                break;
            }
        }
        
        // 进行 数据库的删除
        
        //
    }
    
}

// 被关注的博主类
class BloggerAttentioner: Blogger {
    init(bloggerEntity: BloggerAttentionEntity) {
        super.init()
        self.bloggerName         = bloggerEntity.bloggerName
        self.bloggerId           = bloggerEntity.bloggerId
        self.bloggerIconPath     = bloggerEntity.bloggerIconPath
        self.bloggerArticleCount = bloggerEntity.bloggerArticleCount.integerValue
    }
    
    
}