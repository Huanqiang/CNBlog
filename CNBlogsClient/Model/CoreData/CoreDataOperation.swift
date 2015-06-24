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
    
    :param: offlineInfo 需要被离线的数据
    
    :returns: 离线成功返回true， 否则返回false
    */
    func insertOfflineInfo(offlineInfo: OfflineInformation) -> Bool { return true }
    
    /**
    删除离线数据
    
    :param: offlineInfo 需要被删除的离线数据
    
    :returns: 删除成功返回true， 否则返回false
    */
    func deleteOfflineInfo(offlineInfo: OfflineInformation) -> Bool { return true }
    
    
    /**
    获取 数据（新闻、博客）列表
    
    :returns: 数组
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
    
    :param: blogger 博主信息
    
    :returns: 保存成功与否，成功true，失败false
    */
    func insertAttentioners(blogger: Blogger) -> Bool { return true }
    
    /**
    获取所有的关注人
    
    :returns: 关注人列表
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
        var fetchRequest: NSFetchRequest = NSFetchRequest()
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
        
        var errorInfo:NSError?
        // 取结果集
        var resultArr = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &errorInfo) as! [NSManagedObject]
        
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
    
    :param: sortAttribute 属性名称
    
    :returns: 排序操作
    */
    func createSortDescriptorByAscend(sortAttribute: String) -> NSSortDescriptor {
        return NSSortDescriptor(key: sortAttribute, ascending: true)
    }
    
    /**
    通过降序的方式，创建一个属性的排序操作
    
    :param: sortAttribute 属性名称
    
    :returns: 排序操作
    */
    func createSortDescriptorByUnAscend(sortAttribute: String) -> NSSortDescriptor {
        return NSSortDescriptor(key: sortAttribute, ascending: false)
    }
}

class CoreDataOperationWithNews: CoreDataOperation {
    
    // MARK - ******** 保存离线数据 *********
    override func insertOfflineInfo(offlineInfo: OfflineInformation) -> Bool {
        let newsInfo: OfflineNews = offlineInfo as! OfflineNews
        let isSuccessWithInsertNewsBase = self.insertNewsBaseInfo(newsInfo)
        let isSuccessWithInsertNewsContent = self.insertNewsContent(newsInfo)
        
        if isSuccessWithInsertNewsBase && isSuccessWithInsertNewsContent {
            return true
        }else {
            return false
        }
    }
    
    func insertNewsBaseInfo(newsInfo: OfflineNews) -> Bool {
        // 先判断数据库里有没有这条数据，有的话直接返回真
        if self.isExistWithInfoId(self.gainAppointEntityDescription("OfflineNewsBaseInfoEntity"), infoId: newsInfo.id, infoType: "news") {
            return true
        }
        
        var newsEntity: OfflineNewsBaseInfoEntity = self.gainNewEntity("OfflineNewsBaseInfoEntity") as! OfflineNewsBaseInfoEntity
        
        newsEntity.newsAuthor      = newsInfo.author
        newsEntity.newsHasIcon     = newsInfo.hasIcon
        newsEntity.newsIconPath    = newsInfo.iconPath
        newsEntity.newsId          = newsInfo.id
        newsEntity.newsPublishTime = newsInfo.publishTime
        newsEntity.newsSummary     = newsInfo.summary
        newsEntity.newsTitle       = newsInfo.title
        newsEntity.newsOfflineTime = NSDate()
        
        return self.managedObjectContext.save(nil)
    }
    
    func insertNewsContent(newsInfo: OfflineNews) -> Bool {
        if self.isExistWithInfoId(self.gainAppointEntityDescription("OfflineNewsContentEntity"), infoId: newsInfo.id, infoType: "news") {
            return true
        }
        
        var newsEntity: OfflineNewsContentEntity = self.gainNewEntity("OfflineNewsContentEntity") as! OfflineNewsContentEntity
        
        newsEntity.newsId      = newsInfo.id
        newsEntity.newsContent = newsInfo.content
        
        return self.managedObjectContext.save(nil)
    }
    
    // ********** 删除离线数据 **********
    
    
    
    
    // MARK - ********** 获取离线数据 **********
    override func gainOfflineBaseInfos() -> [OfflineInformation] {
        var offlineNewsBaseInfo: NSEntityDescription = self.gainAppointEntityDescription("OfflineNewsBaseInfoEntity")
        let sortByDate = self.createSortDescriptorByUnAscend("newsOfflineTime")
        let searchResult = self.gainAppointInfo(offlineNewsBaseInfo, sortDescriptors: [sortByDate], predicates: [])
        var offlineInfoResults:[OfflineNews] = []
        
        for offlineNewsResult in searchResult {
            offlineInfoResults.append(OfflineNews(offlineInfo: offlineNewsResult as! OfflineNewsBaseInfoEntity))
        }
        
        return offlineInfoResults
    }
    
    override func gainOfflineContentInfo(newsId: String) -> OfflineInformation {
        var offlineNewsContent: NSEntityDescription = self.gainAppointEntityDescription("OfflineNewsContentEntity")
        let predicateWithID: NSPredicate = NSPredicate(format: "newsId = %@", newsId)
        let searchResult = self.gainAppointInfo(offlineNewsContent, sortDescriptors: [], predicates: [predicateWithID])
        
        return OfflineNews(offlineContent: searchResult[0] as! OfflineNewsContentEntity)
    }
}

class CoreDataOperationWithBlog: CoreDataOperation {
    
}

//MARK: - 博主关注人CoreData操作类
class CoreDataOperationWithBlogger: CoreDataOperation {
    
    // MARK: 保存一个博主关注人
    override func insertAttentioners(blogger: Blogger) -> Bool {
        if self.isExistWithInfoId(self.gainAppointEntityDescription("BloggerAttentionEntity"), infoId: blogger.bloggerId, infoType: "bloggerId") {
            return true
        }
        
        var bloggerEntity: BloggerAttentionEntity = self.gainNewEntity("BloggerAttentionEntity") as! BloggerAttentionEntity
        
        bloggerEntity.bloggerId           = blogger.bloggerId
        bloggerEntity.bloggerIconPath     = blogger.bloggerIconPath
        bloggerEntity.bloggerArticleCount = blogger.bloggerArticleCount
        bloggerEntity.bloggerName         = blogger.bloggerName
        
        return self.managedObjectContext.save(nil)
    }
    
    // MARK - 获取博主关注人信息列表
    override func gainAttentioners() -> [Blogger] {
        var bloggerED: NSEntityDescription = self.gainAppointEntityDescription("BloggerAttentionEntity")
        let sortById = self.createSortDescriptorByUnAscend("bloggerId")
        let searchResult = self.gainAppointInfo(bloggerED, sortDescriptors: [sortById], predicates: [])
        var bloggers:[Blogger] = []
        
        for blogger in searchResult {
            bloggers.append(BloggerAttentioner(bloggerEntity: blogger as! BloggerAttentionEntity))
        }
        
        return bloggers
    }
}


