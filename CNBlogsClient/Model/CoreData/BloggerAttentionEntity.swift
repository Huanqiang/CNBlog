//
//  BloggerAttentionEntity.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import Foundation
import CoreData

@objc(BloggerAttentionEntity)
class BloggerAttentionEntity: NSManagedObject {

    @NSManaged var bloggerId: String
    @NSManaged var bloggerName: String
    @NSManaged var bloggerIconPath: String
    @NSManaged var bloggerArticleCount: NSNumber

}
