//
//  OfflineInfoViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/13.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class OfflineInfoViewModel: NSObject {
    
    var offlineVC: OfflineInfoViewController!
    
    // 数据型 变量
    var newsElementLists: [OfflineInformation] = []
    
    override init() {
        super.init()
    }
    
    init(offlineVC: OfflineInfoViewController) {
        super.init()
        self.offlineVC = offlineVC
        self.newsElementLists = OfflineNews().gainOfflineBaseInfo()
        
        // 在获取数据后刷新操作
        self.reloadTabeleView()
    }
    
    
    func reloadTabeleView() {
        self.offlineVC.reloadTabeleView()
    }
    
    func offlineAtIndex(index: Int) -> OfflineNews{
        return self.newsElementLists[index] as! OfflineNews
    }
    
    func gainNewsElementListsCount() -> Int {
        return self.newsElementLists.count
    }
}
