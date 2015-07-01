//
//  NewsViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/1.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class NewsViewModel: NSObject {
    // 操作型 变量
    var networkOperation: NetworkOperation = NetworkOperation()
    var newsVC: NewsViewController!
    
    // 数据型 变量
    /// newsElementLists 是专门给TableView使用的，其他三个再加载后要将数据传给 newsElementLists
    var newsElementLists: [OnlineInformation]        = []
    var recentNewsElementLists: [OnlineInformation]  = []
    var popNewsElementLists: [OnlineInformation]     = []
    var commendNewsElementLists: [OnlineInformation] = []
    
    override init() {
        super.init()
    }
    
    init(newsVC: NewsViewController) {
        super.init()
        self.newsVC = newsVC
    }
    
    // MARK: - 网络操作
    func gainNewsListFromNetwork() {
        networkOperation = NetworkOperationWithNews()
        // 防止 闭包循环， 使用weak
        weak var weakSelf: NewsViewModel? = self
        networkOperation.gainInfomationFromNetwork(CNBlogAPIOption.recentNews, parameters: ["15"]) { (onlineInfo) -> Void in
            if (onlineInfo != nil) {
                weakSelf!.newsElementLists = onlineInfo as! [OnlineInformation]
                weakSelf!.newsVC.reloadTabeleView()
            }else {
                weakSelf!.newsVC.gainNewsInfoFailure()
            }
            // 结束刷新
            weakSelf!.newsVC.endTableRefreshing()
        }
    }
    
    
    
    
    
    // MARK: - 数据传递
    func gainOnlineNewsAtIndexPath(index: Int) -> OnlineNews {
        return newsElementLists[index] as! OnlineNews
    }
    
    // MARK: - 界面数据传递
    func newsDetailViewModelForIndexPath(index: Int, vc: OnlineInfoDetailViewController) -> OnlineInfoDetailViewModel {
        return OnlineInfoDetailViewModel(onlineInfo: self.gainOnlineNewsAtIndexPath(index), onlineDetailVC: vc)
    }
    
}
