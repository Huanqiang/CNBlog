//
//  OfflineBlogBaseInfoEntity.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import Foundation
import CoreData

@objc(OfflineBlogBaseInfoEntity)
class OfflineBlogBaseInfoEntity: NSManagedObject {

    @NSManaged var blogId: String
    @NSManaged var blogTitle: String
    @NSManaged var blogSummary: String
    @NSManaged var blogIconPath: String
    @NSManaged var blogAuthor: String
    @NSManaged var blogHasIcon: NSNumber
    @NSManaged var blogPublishTime: NSDate

}
