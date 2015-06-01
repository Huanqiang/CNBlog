//
//  OfflineBlogContentEntity.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import Foundation
import CoreData

class OfflineBlogContentEntity: NSManagedObject {

    @NSManaged var blogId: String
    @NSManaged var blogContent: String

}
