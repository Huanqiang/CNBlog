//
//  CoreDataOperation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/5.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import CoreData

class CoreDataOperation: NSObject {
    var managedObjectContext: NSManagedObjectContext!
    
    override init() {
        super.init()
        self.managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    // MARK: - 对于资讯信息的CoreData 操作
    /**
    保存 离线数据（新闻 和 博客）
    
    - parameter offlineInfo: 需要被离线的数据
    
    - returns: 离线成功返回true， 否则返回false
    */
    func insertOfflineInfo(offlineInfo: OfflineInformation) -> Bool {
        let isSuccessWithInsertNewsBase = self.insertOnlineBaseInfo(offlineInfo)
        let isSuccessWithInsertNewsContent = self.insertOnlineInfoContent(offlineInfo)
        
        if isSuccessWithInsertNewsBase && isSuccessWithInsertNewsContent {
            return true
        }else {
            return false
        }
    }
    
    /**
    保存 离线信息的 基本信息
    
    - parameter offlineInfo: 需要被离线的数据
    
    - returns: 离线成功返回true， 否则返回false
    */
    func insertOnlineBaseInfo(offlineInfo: OfflineInformation) -> Bool { return true }
    
    /**
    保存 离线信息的 主内容
    
    - parameter offlineInfo: 需要被离线的数据
    
    - returns: 离线成功返回true， 否则返回false
    */
    func insertOnlineInfoContent(offlineInfo: OfflineInformation) -> Bool { return true }
    
    /**
    删除离线数据
    
    - parameter offlineInfo: 需要被删除的离线数据
    
    - returns: 删除成功返回true， 否则返回false
    */
    func deleteOfflineInfo(offlineInfo: OfflineInformation) -> Bool { return true }
    
    
    /**
    获取 数据（新闻、博客）列表
    
    - returns: 数组
    */
    func gainOfflineBaseInfos() -> [OfflineInformation] {
       return []
    }
    
    func gainOfflineContentInfo(newsId: String) -> OfflineInformation {
        return OfflineInformation()
    }
    
    
    // MARK: - 博主信息 CoreData操作
    /**
    保存一个 博主（关注人）
    
    - parameter blogger: 博主信息
    
    - returns: 保存成功与否，成功true，失败false
    */
    func insertAttentioners(blogger: Blogger) -> Bool { return true }
    
    /**
    获取所有的关注人
    
    - returns: 关注人列表
    */
    func gainAttentioners() -> [Blogger] { return [] }
    
    // MARK: - ******** 基本数据操作 **********
    func gainNewEntity(entityName: String) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.managedObjectContext)
    }
    
    func gainAppointEntityDescription(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.managedObjectContext)!
    }
    
    //查询操作
    func gainAppointInfo(entity: NSEntityDescription, sortDescriptors: [NSSortDescriptor], predicates: [NSPredicate] ) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        // 设置排序条件
        if !sortDescriptors.isEmpty || sortDescriptors.count != 0 {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        // 设置查询条件
        if !predicates.isEmpty || predicates.count != 0 {
            for predicate: NSPredicate in predicates {
                fetchRequest.predicate = predicate
            }
        }
        
//        var errorInfo:NSError?
        // 取结果集
        let resultArr = (try! self.managedObjectContext.executeFetchRequest(fetchRequest)) as! [NSManagedObject]
        
        return resultArr
    }
    
    // 查询数据库有没有这条信息（新闻，博客）
    func isExistWithInfoId(entity: NSEntityDescription, infoId: String, infoType: String) -> Bool {
        let predicateWithID: NSPredicate = NSPredicate(format: "\(infoType)Id = %@", infoId)
        let searchResult = self.gainAppointInfo(entity, sortDescriptors: [], predicates: [predicateWithID])
        if searchResult.isEmpty || searchResult.count == 0 {
            return false
        }else {
            return true
        }
    }
    
    // 排序操作
    /**
    通过升序的方式，创建一个属性的排序操作
    
    - parameter sortAttribute: 属性名称
    
    - returns: 排序操作
    */
    func createSortDescriptorByAscend(sortAttribute: String) -> NSSortDescriptor {
        return NSSortDescriptor(key: sortAttribute, ascending: true)
    }
    
    /**
    通过降序的方式，创建一个属性的排序操作
    
    - parameter sortAttribute: 属性名称
    
    - returns: 排序操作
    */
    func createSortDescriptorByUnAscend(sortAttribute: String) -> NSSortDescriptor {
        return NSSortDescriptor(key: sortAttribute, ascending: false)
    }
}

class CoreDataOperationWithNews: CoreDataOperation {
    
    // MARK - ******** 保存离线数据 *********
    override func insertOnlineBaseInfo(offlineInfo: OfflineInformation) -> Bool {
        // 先判断数据库里有没有这条数据，有的话直接返回真
        if self.isExistWithInfoId(self.gainAppointEntityDescription("OfflineNewsBaseInfoEntity"), infoId: offlineInfo.id, infoType: "news") {
            return true
        }
        
        let newsEntity: OfflineNewsBaseInfoEntity = self.gainNewEntity("OfflineNewsBaseInfoEntity") as! OfflineNewsBaseInfoEntity
        
        newsEntity.newsAuthor      = offlineInfo.author
        newsEntity.newsHasIcon     = offlineInfo.hasIcon
        newsEntity.newsIconPath    = offlineInfo.iconPath
        newsEntity.newsId          = offlineInfo.id
        newsEntity.newsPublishTime = offlineInfo.publishTime
        newsEntity.newsSummary     = offlineInfo.summary
        newsEntity.newsTitle       = offlineInfo.title
        newsEntity.newsOfflineTime = NSDate()
        
        do {
            try self.managedObjectContext.save()
            return true
        } catch _ {
            return false
        }
    }
    
    override func insertOnlineInfoContent(offlineInfo: OfflineInformation) -> Bool {
        if self.isExistWithInfoId(self.gainAppointEntityDescription("OfflineNewsContentEntity"), infoId: offlineInfo.id, infoType: "news") {
            return true
        }
        
        let newsEntity: OfflineNewsContentEntity = self.gainNewEntity("OfflineNewsContentEntity") as! OfflineNewsContentEntity
        
        newsEntity.newsId      = offlineInfo.id
        newsEntity.newsContent = offlineInfo.content
        
        do {
            try self.managedObjectContext.save()
            return true
        } catch _ {
            return false
        }
    }
    
    // ********** 删除离线数据 **********
    
    
    
    
    // MARK - ********** 获取离线数据 **********
    override func gainOfflineBaseInfos() -> [OfflineInformation] {
        let offlineNewsBaseInfo: NSEntityDescription = self.gainAppointEntityDescription("OfflineNewsBaseInfoEntity")
        let sortByDate = self.createSortDescriptorByUnAscend("newsOfflineTime")
        let searchResult = self.gainAppointInfo(offlineNewsBaseInfo, sortDescriptors: [sortByDate], predicates: [])
        var offlineInfoResults:[OfflineNews] = []
        
        for offlineNewsResult in searchResult {
            offlineInfoResults.append(OfflineNews(offlineInfo: offlineNewsResult as! OfflineNewsBaseInfoEntity))
        }
        
        return offlineInfoResults
    }
    
    override func gainOfflineContentInfo(newsId: String) -> OfflineInformation {
        let offlineNewsContent: NSEntityDescription = self.gainAppointEntityDescription("OfflineNewsContentEntity")
        let predicateWithID: NSPredicate = NSPredicate(format: "newsId = %@", newsId)
        let searchResult = self.gainAppointInfo(offlineNewsContent, sortDescriptors: [], predicates: [predicateWithID])
        
        return OfflineNews(offlineContent: searchResult[0] as! OfflineNewsContentEntity)
    }
}

class CoreDataOperationWithBlog: CoreDataOperation {
    // MARK - ******** 保存离线数据 *********
    override func insertOnlineBaseInfo(offlineInfo: OfflineInformation) -> Bool {
        // 先判断数据库里有没有这条数据，有的话直接返回真
        if self.isExistWithInfoId(self.gainAppointEntityDescription("OfflineBlogBaseInfoEntity"), infoId: offlineInfo.id, infoType: "blog") {
            return true
        }
        
        let blogEntity: OfflineBlogBaseInfoEntity = self.gainNewEntity("OfflineBlogBaseInfoEntity") as! OfflineBlogBaseInfoEntity
        
        blogEntity.blogAuthor      = offlineInfo.author
        blogEntity.blogIconPath    = offlineInfo.iconPath
        blogEntity.blogId          = offlineInfo.id
        blogEntity.blogPublishTime = offlineInfo.publishTime
        blogEntity.blogSummary     = offlineInfo.summary
        blogEntity.blogTitle       = offlineInfo.title
        blogEntity.blogOfflineTime = NSDate()
        
        do {
            try self.managedObjectContext.save()
            return true
        } catch _ {
            return false
        }
    }
    
    override func insertOnlineInfoContent(offlineInfo: OfflineInformation) -> Bool {
        if self.isExistWithInfoId(self.gainAppointEntityDescription("OfflineBlogContentEntity"), infoId: offlineInfo.id, infoType: "blog") {
            return true
        }
        
        let blogEntity: OfflineBlogContentEntity = self.gainNewEntity("OfflineBlogContentEntity") as! OfflineBlogContentEntity
        
        blogEntity.blogId      = offlineInfo.id
        blogEntity.blogContent = offlineInfo.content
        
        do {
            try self.managedObjectContext.save()
            return true
        } catch _ {
            return false
        }
    }
    // ********** 删除离线数据 **********
    
    
    
    
    // MARK - ********** 获取离线数据 **********
    override func gainOfflineBaseInfos() -> [OfflineInformation] {
        let offlineNewsBaseInfo: NSEntityDescription = self.gainAppointEntityDescription("OfflineBlogBaseInfoEntity")
        let sortByDate = self.createSortDescriptorByUnAscend("blogOfflineTime")
        let searchResult = self.gainAppointInfo(offlineNewsBaseInfo, sortDescriptors: [sortByDate], predicates: [])
        var offlineInfoResults:[OfflineBlog] = []
        
        for offlineNewsResult in searchResult {
            offlineInfoResults.append(OfflineBlog(offlineInfo: offlineNewsResult as! OfflineBlogBaseInfoEntity))
        }
        
        return offlineInfoResults
    }
    
    override func gainOfflineContentInfo(newsId: String) -> OfflineInformation {
        let offlineNewsContent: NSEntityDescription = self.gainAppointEntityDescription("OfflineBlogContentEntity")
        let predicateWithID: NSPredicate = NSPredicate(format: "blogId = %@", newsId)
        let searchResult = self.gainAppointInfo(offlineNewsContent, sortDescriptors: [], predicates: [predicateWithID])
        
        return OfflineBlog(offlineContent: searchResult[0] as! OfflineBlogContentEntity)
    }
}

//MARK: - 博主关注人CoreData操作类
class CoreDataOperationWithBlogger: CoreDataOperation {
    
    // MARK: 保存一个博主关注人
    override func insertAttentioners(blogger: Blogger) -> Bool {
        if self.isExistWithInfoId(self.gainAppointEntityDescription("BloggerAttentionEntity"), infoId: blogger.bloggerId, infoType: "blogger") {
            return true
        }
        
        let bloggerEntity: BloggerAttentionEntity = self.gainNewEntity("BloggerAttentionEntity") as! BloggerAttentionEntity
        
        bloggerEntity.bloggerId           = blogger.bloggerId
        bloggerEntity.bloggerIconPath     = blogger.bloggerIconPath
        bloggerEntity.bloggerArticleCount = blogger.bloggerArticleCount
        bloggerEntity.bloggerName         = blogger.bloggerName
        bloggerEntity.bloggerUpdatedTime  = blogger.bloggerUpdatedTime
        
        do {
            try self.managedObjectContext.save()
            return true
        } catch _ {
            return false
        }
    }
    
    // MARK - 获取博主关注人信息列表
    override func gainAttentioners() -> [Blogger] {
        let bloggerED: NSEntityDescription = self.gainAppointEntityDescription("BloggerAttentionEntity")
        let sortById = self.createSortDescriptorByUnAscend("bloggerId")
        let searchResult = self.gainAppointInfo(bloggerED, sortDescriptors: [sortById], predicates: [])
        var bloggers:[Blogger] = []
        
        for blogger in searchResult {
            bloggers.append(BloggerAttentioner(bloggerEntity: blogger as! BloggerAttentionEntity))
        }
        
        return bloggers
    }
}


