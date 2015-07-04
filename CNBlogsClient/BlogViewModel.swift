//
//  BlogViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/1.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class BlogViewModel: NSObject {
    
    var blogVC: BlogViewController!
    var networkOperation: NetworkOperation = NetworkOperation()
    
    /// blogElementLists 是专门给TableView使用的，其他两个再加载后要将数据传给 blogElementLists
    var blogElementLists: [OnlineInformation]        = []
    var homeBlogElementLists: [OnlineInformation]    = []
    var twoDayBlogElementLists: [OnlineInformation] = []
//    var commendBlogElementLists: [OnlineInformation] = []
    /// 判断当前是哪一类新闻数据
    var blogType: CNBlogAPIOption                    = CNBlogAPIOption.homePageBlog
    /// 判断当前是上拉刷新还是下拉刷新
    var isHeadRefresh: Bool                          = true
    /// 当前最新新闻下拉页号（下拉刷新才使用）
    var homeblogPage: Int                            = 1
    /// 当前推荐新闻下拉页号（下拉刷新才使用）
    var commendBlogPage: Int                         = 1
    
    
    override init() {
    }
    
    init(blogVC: BlogViewController) {
        self.blogVC = blogVC
    }
    
    
    // MARK: 从网络获取数据
    
    func gainBlogListFromNetwork() {
        networkOperation = NetworkOperationWithBlog()
        // 防止 闭包循环， 使用weak
        weak var weakSelf: BlogViewModel? = self
        networkOperation.gainInfomationFromNetwork(blogType, parameters: self.setParameters()) {
            (onlineInfo) -> Void in
            if (onlineInfo != nil) {
                weakSelf!.addNewNews(weakSelf!, onlineInfo: onlineInfo as! [OnlineInformation])
                weakSelf!.blogVC.reloadTabeleView()
            }else {
                weakSelf!.blogVC.gainBlogInfoFailure()
            }
            
            // 结束刷新
            if weakSelf!.isHeadRefresh {
                weakSelf!.blogVC.endTableHeadRefreshing()
            }else {
                weakSelf!.blogVC.endTableFooterRefreshing()
            }
            
        }
    }
    
    /**
    为表格设置新的数据
    
    :param: weakSelf   weak化后的self
    :param: onlineInfo 新数据
    */
    func addNewNews(weakSelf: BlogViewModel,onlineInfo: [OnlineInformation]) {
        // 将值赋值给当前刷新的操作项的数据数组
        if weakSelf.isHeadRefresh {
            switch self.blogType {
            case CNBlogAPIOption.homePageBlog: weakSelf.homeBlogElementLists   = onlineInfo
            case CNBlogAPIOption.twoDayTopViewPosts: weakSelf.twoDayBlogElementLists = onlineInfo
            default: println()
            }
        }else {
            if self.blogType == CNBlogAPIOption.homePageBlog {
                for onlineNews in onlineInfo {
                    weakSelf.homeBlogElementLists.append(onlineNews)
                }
            }
        }
        
        // 为表格数据赋值
        switch self.blogType {
        case CNBlogAPIOption.homePageBlog: weakSelf.blogElementLists = weakSelf.homeBlogElementLists
        case CNBlogAPIOption.twoDayTopViewPosts: weakSelf.blogElementLists  = weakSelf.twoDayBlogElementLists
        default: println()
        }
    }
    
    /**
    分别为上拉和下拉刷新设置 参数
    
    :returns: 参数
    */
    func setParameters() ->[String] {
        if self.isHeadRefresh {
            if self.blogType == CNBlogAPIOption.twoDayTopViewPosts {
                return ["25"]
            }
            return ["1", "20"]
        }else {
            if self.blogType == CNBlogAPIOption.homePageBlog {
                return ["\(++homeblogPage)", "15"]
            }else{
                return ["\(++commendBlogPage)", "15"]
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
    
    
    
    func gainHomeBlog() {
        blogType = CNBlogAPIOption.homePageBlog
        // 添加上拉刷新
        self.blogVC.setTableFooterRefreshing()
        // 数据刷新
        self.gainDataForNewsElementLists(self.homeBlogElementLists)
    }
    
    
    func gainTwoDayTopViewPostsBlog() {
        blogType = CNBlogAPIOption.twoDayTopViewPosts
        // 移除上拉刷新
        self.blogVC.removeFooterRefreshing()
        // 数据刷新
        self.gainDataForNewsElementLists(self.twoDayBlogElementLists)
    }
    
    /**
    为当前表格设置数据
    
    :param: newsList 需要被填入的数据
    */
    func gainDataForNewsElementLists(blogList: [OnlineInformation]) {
        // 判断当前表格是否有数据，没有的话网络获取，有的话直接刷新表格
        if blogList.count == 0 {
            self.gainBlogListFromNetwork()
        }else {
            blogElementLists = blogList
            self.blogVC.reloadTabeleView()
        }
    }
    
    
    
    
    
    // MARK: - 为试图（表格等控件）传送数据
    
    func gainOnlineNewsCount() -> Int {
        return self.blogElementLists.count
    }
    
    func gainOnlineBlogAtIndexPath(index: Int) -> OnlineBlog {
        return self.blogElementLists[index] as! OnlineBlog
    }
    
    func newBlogDetailVM(index: Int, vc: OnlineInfoDetailViewController) -> OnlineInfoDetailViewModel {
        return OnlineInfoDetailViewModel(onlineInfo: self.gainOnlineBlogAtIndexPath(index), onlineDetailVC: vc)
    }
}
