//
//  OfflineInfoDetailViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/17.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class OfflineInfoDetailViewModel: NSObject {
    var offlineInfo: OfflineInformation!
    var offlineDetailVC: OfflineInfoDetailViewController!
    
    init(offlineInfo: OfflineInformation, vc: OfflineInfoDetailViewController) {
        super.init()
        self.offlineInfo = offlineInfo
        self.offlineDetailVC = vc
    }
    
    
    // MARK: - 从本地数据库加载资讯主内容
    func gainOfflineInfoContent() {
        self.offlineInfo.gainOfflineContent()
        self.offlineDetailVC.showOfflineInfoContent()
    }
}
