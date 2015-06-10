//
//  OfflineNewsBaseInfoEntity.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import Foundation
import CoreData

@objc(OfflineNewsBaseInfoEntity)
class OfflineNewsBaseInfoEntity: NSManagedObject {

    @NSManaged var newsPublishTime: NSDate
    @NSManaged var newsAuthor: String
    @NSManaged var newsHasIcon: NSNumber
    @NSManaged var newsIconPath: String
    @NSManaged var newsId: String
    @NSManaged var newsSummary: String
    @NSManaged var newsTitle: String

}
