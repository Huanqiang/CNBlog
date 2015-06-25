//
//  BloggerAttentionEntity.swift
//  
//
//  Created by 王焕强 on 15/6/25.
//
//

import Foundation
import CoreData

@objc(BloggerAttentionEntity)
class BloggerAttentionEntity: NSManagedObject {

    @NSManaged var bloggerArticleCount: NSNumber
    @NSManaged var bloggerIconPath: String
    @NSManaged var bloggerId: String
    @NSManaged var bloggerName: String
    @NSManaged var bloggerUpdatedTime: NSDate

}
