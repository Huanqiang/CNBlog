//
//  BlogOfBloggerViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/26.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class BlogOfBloggerViewModel: NSObject {
    
    var blogVC: BlogOfBloggerViewController!
    var blogLists: [OnlineInformation] = []
    var blogPage: Int = 1
    var blogger: Blogger!
    var isHeadRefresh: Bool = true
    var isBloggerSelf: Bool = true
    var isBlogerSelfLogin: Bool = true
    
    
    override init() {
        self.isBloggerSelf = true
    }
    
    /**
    给博主自己（软件使用者）使用的初始化
    
    - parameter blogVC: BlogOfBloggerViewController界面类
    
    - returns: 一个博主自己的博客VM
    */
    init(blogVC: BlogOfBloggerViewController) {
        super.init()
        self.blogVC        = blogVC
        self.isBloggerSelf = true
        // 获取博主信息
        self.gainBloggerSelfInfo()
    }
    
    func gainBloggerSelfInfo() {
        var bloggerSelf: Blogger = BloggerOwned()
        if bloggerSelf.isLoginSelf() {
            bloggerSelf = bloggerSelf.gainBloggerSelfInfo()
            isBlogerSelfLogin = true
        }else {
            isBlogerSelfLogin = false
        }
        blogger = bloggerSelf
    }
    
    /**
    给博主关注人使用的初始化
    
    - parameter attentioner: 当前的关注人类
    - parameter blogVC:      BlogOfBloggerViewController界面类
    
    - returns: 一个关注人的博客VM
    */
    init(attentioner: Blogger, blogVC: BlogOfBloggerViewController) {
        self.blogger       = attentioner
        self.blogVC        = blogVC
        self.isBloggerSelf = false
    }
    
    
    // MARK: - ************  操作 *************
    
    // 网络操作网络操作获取数据
    func gainBlogFormNetWork() {
        let networkOperation: NetworkOperation = NetworkOperationWithBlogListOfBlogger()
        let parameters = self.setParameters()
        
        weak var weakSelf = self
        networkOperation.gainInfomationFromNetwork(CNBlogAPIOption.myBlogOption, parameters: parameters) { (onlineInfo) -> Void in
            if (onlineInfo != nil) {
                // 先清楚一次上拉刷新，在加载一次
                self.blogVC.blogTableView.removeFooter()
                self.blogVC.setTableFooterRefreshing()
                
                // 为上拉和下拉分别设置数据
                self.addNewBlog(weakSelf!, onlineInfo: onlineInfo as! [OnlineInformation])
                weakSelf!.blogVC.reloadTabeleView()
            }else {
                weakSelf!.blogVC.gainNewsInfoFailure()
            }
            // 结束刷新
            if self.isHeadRefresh {
                weakSelf!.blogVC.endTableHeadRefreshing()
            }else {
                weakSelf!.blogVC.endTableFooterRefreshing()
            }
        }
    }
    
    // 分别为上拉和下拉刷新设置 参数
    func setParameters() ->[String] {
        if self.isHeadRefresh {
            return [self.blogger.bloggerId, "1", "10"]
        }else {
            return [self.blogger.bloggerId, "\(++blogPage)", "10"]
        }
    }
    
    // 为上拉和下拉分别设置数据
    func addNewBlog(weakSelf: BlogOfBloggerViewModel,onlineInfo: [OnlineInformation]) {
        if self.isHeadRefresh {
            weakSelf.blogLists = onlineInfo
        }else {
            for onlineBlog in onlineInfo {
                weakSelf.blogLists.append(onlineBlog)
            }
        }
    }
    
    /**
    设置当前刷新是上拉刷新还是下拉属性，默认下拉
    
    - parameter isHeadRefresh: 刷新的类型，true为下拉刷新，false为上拉刷新
    */
    func setHeadRefresh(isHeadRefresh: Bool) {
        self.isHeadRefresh = isHeadRefresh
    }
    
    
    
    // Mark: - 数据操作
    /**
    获取根据博主的名称设置的VC的名称
    
    - returns: VC的名称
    */
    func gainVCName() ->String {
        if self.isBloggerSelf {
            return "我的博客"
        }
        return "\(self.blogger.bloggerName)的博客"
    }
    
    func gainBlogListsCount() -> Int {
        return self.blogLists.count
    }
    
    func gainBlogAtIndex(index: Int) -> OnlineInformation {
        return self.blogLists[index]
    }
    
    func newBlogDetailVM(index: Int, vc: OnlineInfoDetailViewController) -> OnlineInfoDetailViewModel {
        return OnlineInfoDetailViewModel(onlineInfo: self.gainBlogAtIndex(index), onlineDetailVC: vc)
    }
    
    // 设置关注人页面的空白页
    func setEmptyViewInfo() {
        // 设置 空白页信息
//        self.blogVC.EmptyViewInfo.setEmptyViewDescription("")
        self.blogVC.EmptyViewInfo.setEmptyViewImg("noSetSelf")
        self.blogVC.EmptyViewInfo.setEmptyViewTitle("Who Am I?")
        self.blogVC.EmptyViewInfo.setEmptyBtn("点击设置自己博客") {
            // 跳转搜索界面
            let searchVC: SearchBloggerViewController = self.blogVC.storyboard?.instantiateViewControllerWithIdentifier("SearchBloggerViewController") as! SearchBloggerViewController
            searchVC.searchBloggerVM = SearchBloggerViewModel(isBloggerSelf: true, searchBloggerVC: searchVC)
            self.blogVC.navigationController?.pushViewController(searchVC, animated: true)

        }
    }
}
