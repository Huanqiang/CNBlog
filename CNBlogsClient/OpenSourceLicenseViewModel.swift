//
//  OpenSourceLicenseViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class OpenSourceLicenseViewModel: NSObject {

    func gainOpenSourceLicenseContent() -> NSData {
        let htmlStr: String = NSBundle.mainBundle().pathForResource("Thanks", ofType: "htm")!
        return NSData(contentsOfFile: htmlStr)!
    }
}
