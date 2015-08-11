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
    var isToDetail: Bool = false
    
    
    override init() {
        super.init()
    }
    
    init(offlineVC: OfflineInfoViewController) {
        self.offlineVC = offlineVC
    }
    
    
    init(isNewsView: Bool, offlineVC: OfflineInfoViewController) {
        super.init()
        self.offlineVC = offlineVC
        if isNewsView {
            self.gainNewsElementLists()
        }else {
            self.gainBlogElementLists()
        }
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
    
    
    
    /**
    设置是不是进入资讯详细信息页面
    
    :param: isDetail 设置是不是即将进入详细试图，true为是，否则为不是
    */
    func setToDetail(isDetail: Bool) {
        self.isToDetail = isDetail
    }
    
    
    /**
    用于表示之前是不是进入了详细视图
    
    :returns: true为是，否则为不是
    */
    func gainIsToDetail() -> Bool {
        return self.isToDetail
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
    
    // 设置关注人页面的空白页
    func setEmptyViewInfo() {
        // 设置 空白页信息
        self.offlineVC.emptySetInfo.setEmptyViewDescription("还没有离线文章哟，赶紧在『新闻』和『博客』页添加吧（『新闻』/『博客』->『离线』）")
        self.offlineVC.emptySetInfo.setEmptyViewImg("newsError")
        self.offlineVC.emptySetInfo.setEmptyViewTitle("还没有离线的文章！")
    }
}
