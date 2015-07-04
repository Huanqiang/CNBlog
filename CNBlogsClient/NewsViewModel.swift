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
    /// 判断当前是哪一类新闻数据
    var newsType: CNBlogAPIOption                    = CNBlogAPIOption.popNews
    /// 判断当前是上拉刷新还是下拉刷新
    var isHeadRefresh: Bool                          = true
    /// 当前最新新闻下拉页号（下拉刷新才使用）
    var recentNewsPage: Int                          = 1
    /// 当前推荐新闻下拉页号（下拉刷新才使用）
    var commendNewsPage: Int                         = 1
    
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
        networkOperation.gainInfomationFromNetwork(newsType, parameters: self.setParameters()) {
            (onlineInfo) -> Void in
            if (onlineInfo != nil) {
                weakSelf?.addNewNews(weakSelf!, onlineInfo: onlineInfo as! [OnlineInformation])
                weakSelf!.newsVC.reloadTabeleView()
            }else {
                weakSelf!.newsVC.gainNewsInfoFailure()
            }
            
            // 结束刷新
            if weakSelf!.isHeadRefresh {
                weakSelf!.newsVC.endTableHeadRefreshing()
            }else {
                weakSelf!.newsVC.endTableFooterRefreshing()
            }
            
        }
    }    
    
    // 设置当前新闻的类型
    func gainRecentNews() {
        newsType = CNBlogAPIOption.recentNews
        // 移除上拉刷新
        self.newsVC.removeFooterRefreshing()
        // 添加上拉刷新
        self.newsVC.setTableFooterRefreshing()
        // 数据刷新
        self.gainDataForNewsElementLists(self.recentNewsElementLists)
    }
    
    func gainPopNews() {
        newsType = CNBlogAPIOption.popNews
        // 移除上拉刷新
        self.newsVC.removeFooterRefreshing()
        // 数据刷新
        self.gainDataForNewsElementLists(self.popNewsElementLists)
    }
    
    func gainCommendNews() {
        newsType = CNBlogAPIOption.commendNews
        // 移除上拉刷新
        self.newsVC.removeFooterRefreshing()
        // 添加上拉刷新
        self.newsVC.setTableFooterRefreshing()
        // 数据刷新
        self.gainDataForNewsElementLists(self.commendNewsElementLists)
    }
    
    /**
    为当前表格设置数据
    
    :param: newsList 需要被填入的数据
    */
    func gainDataForNewsElementLists(newsList: [OnlineInformation]) {
        // 判断当前表格是否有数据，没有的话网络获取，有的话直接刷新表格
        if newsList.count == 0 {
            self.gainNewsListFromNetwork()
        }else {
            newsElementLists = newsList
            self.newsVC.reloadTabeleView()
        }
    }
    
    /**
    为表格设置新的数据
    
    :param: weakSelf   weak化后的self
    :param: onlineInfo 新数据
    */
    func addNewNews(weakSelf: NewsViewModel,onlineInfo: [OnlineInformation]) {
        // 将值赋值给当前刷新的操作项的数据数组
        if weakSelf.isHeadRefresh {
            switch self.newsType {
            case CNBlogAPIOption.recentNews: weakSelf.recentNewsElementLists   = onlineInfo
            case CNBlogAPIOption.popNews: weakSelf.popNewsElementLists         = onlineInfo
            case CNBlogAPIOption.commendNews: weakSelf.commendNewsElementLists = onlineInfo
            default: println()
            }
        }else {
            if self.newsType == CNBlogAPIOption.recentNews {
                for onlineNews in onlineInfo {
                    weakSelf.recentNewsElementLists.append(onlineNews)
                }
            }else if self.newsType == CNBlogAPIOption.commendNews {
                for onlineNews in onlineInfo {
                    weakSelf.commendNewsElementLists.append(onlineNews)
                }
            }
            
        }
        
        // 为表格数据赋值
        switch self.newsType {
        case CNBlogAPIOption.recentNews: weakSelf.newsElementLists  = weakSelf.recentNewsElementLists
        case CNBlogAPIOption.popNews: weakSelf.newsElementLists     = weakSelf.popNewsElementLists
        case CNBlogAPIOption.commendNews: weakSelf.newsElementLists = weakSelf.commendNewsElementLists
        default: println()
        }
    }
    
    
    /**
    分别为上拉和下拉刷新设置 参数
    
    :returns: 参数
    */
    func setParameters() ->[String] {
        if self.isHeadRefresh {
            if newsType == CNBlogAPIOption.popNews {
                return ["25"]
            }
            return ["1", "20"]
        }else {
            if self.newsType == CNBlogAPIOption.recentNews {
                return ["\(++recentNewsPage)", "15"]
            }else{
                return ["\(++commendNewsPage)", "15"]
            }
        }
    }
    
    /**
    设置当前刷新是上拉刷新还是下拉属性，默认下拉
    
    :param: isHeadRefresh 刷新的类型，true为下拉刷新，false为上拉刷新
    */
    func setHeadRefresh(isHeadRefresh: Bool) {
        self.isHeadRefresh = isHeadRefresh
    }
    
    
    // MARK: - 数据传递
    func gainOnlineNewsCount() ->Int {
        return newsElementLists.count
    }
    
    func gainOnlineNewsAtIndexPath(index: Int) -> OnlineNews {
        return newsElementLists[index] as! OnlineNews
    }
    
    // MARK: - 界面数据传递
    func newsDetailViewModelForIndexPath(index: Int, vc: OnlineInfoDetailViewController) -> OnlineInfoDetailViewModel {
        return OnlineInfoDetailViewModel(onlineInfo: self.gainOnlineNewsAtIndexPath(index), onlineDetailVC: vc)
    }
    
}
