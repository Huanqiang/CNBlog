//
//  OfflineBlogBaseInfoEntity.swift
//  
//
//  Created by 王焕强 on 15/6/18.
//
//

import Foundation
import CoreData

@objc(OfflineBlogBaseInfoEntity)
class OfflineBlogBaseInfoEntity: NSManagedObject {

    @NSManaged var blogAuthor: String
    @NSManaged var blogHasIcon: NSNumber
    @NSManaged var blogIconPath: String
    @NSManaged var blogId: String
    @NSManaged var blogPublishTime: NSDate
    @NSManaged var blogSummary: String
    @NSManaged var blogTitle: String
    @NSManaged var blogOfflineTime: NSDate

}
