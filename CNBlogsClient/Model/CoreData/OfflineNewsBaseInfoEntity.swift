//
//  OfflineNewsBaseInfoEntity.swift
//  
//
//  Created by 王焕强 on 15/6/18.
//
//

import Foundation
import CoreData

@objc(OfflineNewsBaseInfoEntity)
class OfflineNewsBaseInfoEntity: NSManagedObject {

    @NSManaged var newsAuthor: String
    @NSManaged var newsHasIcon: NSNumber
    @NSManaged var newsIconPath: String
    @NSManaged var newsId: String
    @NSManaged var newsPublishTime: NSDate
    @NSManaged var newsSummary: String
    @NSManaged var newsTitle: String
    @NSManaged var newsOfflineTime: NSDate

}
