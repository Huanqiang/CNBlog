//
//  NewsDetailViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/4.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class NewsDetailViewModel: NSObject {
    var newsInfo: OnlineNews = OnlineNews()
    var newsDetailVC: NewsDetailViewController!
    
    override init() {
        super.init()
    }
    
    init(newsInfo: OnlineNews, newsDetailVC: NewsDetailViewController) {
        self.newsInfo = newsInfo
        self.newsDetailVC = newsDetailVC
    }
    
    // MARK: - 网络操作
    func gainNewsListFromNetwork() {
        var networkOperation = NetworkOperationWithNewsContext()
        self.newsDetailVC.waitOfflineNewsContent()
        // 防止 闭包循环， 使用weak
        weak var weakSelf: NewsDetailViewModel? = self
        networkOperation.gainInfomationFromNetwork(CNBlogAPIOption.newsContext, parameters: [self.newsInfo.id]) { (onlineInfo) -> Void in
            self.newsDetailVC.endWaitOfflineNewsContent()
            
            if (onlineInfo != nil && onlineInfo?.count != 0) {
                weakSelf!.newsInfo.content = (onlineInfo![0] as! OnlineNews).content
                weakSelf!.newsDetailVC.gainNewsInfoSuccess()
            }else {
                weakSelf!.newsDetailVC.gainNewsInfoFailure()
            }
        }
    }
    
    
    // MARK: - 数据离线
    func newsOffline() {
        // 1、将 NewsInfo 的标题图片存储
        newsInfo.saveIconToDisk()
        // 2、创建离线新闻类
        var offlineNews: OfflineInformation = OfflineNews(onlineInfo: newsInfo)
        offlineNews.setNewsContent(newsInfo.content)
        
        if offlineNews.saveOfflineInfo() {
            self.newsDetailVC.offlineNewsSuccess()
        }
    }
    
}
