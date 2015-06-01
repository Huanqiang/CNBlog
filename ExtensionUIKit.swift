//
//  ExtensionUIKit.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func clearTableFooterView() {
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        self.tableFooterView = view
    }
}