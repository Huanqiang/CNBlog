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
    var offlineInfoElementLists: [OfflineInformation] = []
    
    override init() {
        super.init()
    }
    
    init(offlineVC: OfflineInfoViewController) {
        super.init()
        self.offlineVC = offlineVC
        self.gainNewsElementLists()
    }
    
    // MARK: - 获取数据
    func gainNewsElementLists() {
        self.offlineInfoElementLists = OfflineNews().gainOfflineBaseInfo()
        // 在获取数据后刷新操作
        self.reloadTabeleView()
    }
    
    func gainBlogElementLists() {
        self.offlineInfoElementLists = OfflineBlog().gainOfflineBaseInfo()
        // 在获取数据后刷新操作
        self.reloadTabeleView()
    }    
    
    
    // MARK: - 界面数据
    func reloadTabeleView() {
        self.offlineVC.reloadTabeleView()
    }
    
    func offlineAtIndex(index: Int) -> OfflineInformation {
        return self.offlineInfoElementLists[index]
    }
    
    func gainOfflineInfoElementListsCount() -> Int {
        return self.offlineInfoElementLists.count
    }
    
    // MARK: - 界面数据传递
    func offlineInfoDetailViewModelForIndexPath(index: Int, vc: OfflineInfoDetailViewController) -> OfflineInfoDetailViewModel {
        return OfflineInfoDetailViewModel(offlineInfo: self.offlineAtIndex(index), vc: vc)
    }
    
}
