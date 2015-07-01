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
    
    
    override init() {
        
    }
    
    /**
    给博主自己（软件使用者）使用的初始化
    
    :param: blogVC BlogOfBloggerViewController界面类
    
    :returns: 一个博主自己的博客VM
    */
    init(blogVC: BlogOfBloggerViewController) {
        self.blogVC = blogVC
    }
    
    /**
    给博主关注人使用的初始化
    
    :param: attentioner 当前的关注人类
    :param: blogVC      BlogOfBloggerViewController界面类
    
    :returns: 一个关注人的博客VM
    */
    init(attentioner: Blogger, blogVC: BlogOfBloggerViewController) {
        self.blogger = attentioner
        self.blogVC  = blogVC
    }
    
    
    // MARK: - ************  操作 *************
    
    // 网络操作网络操作获取数据
    func gainBlogFormNetWork() {
        var networkOperation: NetworkOperation = NetworkOperationWithBlogListOfBlogger()
        var parameters = self.setParameters()
        
        weak var weakSelf = self
        networkOperation.gainInfomationFromNetwork(CNBlogAPIOption.myBlogOption, parameters: parameters) { (onlineInfo) -> Void in
            if (onlineInfo != nil) {
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
            return [self.blogger.bloggerId, "\(blogPage++)", "10"]
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
    
    
    
    // Mark: - 数据操作
    /**
    获取根据博主的名称设置的VC的名称
    
    :returns: VC的名称
    */
    func gainVCName() ->String {
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
    
    
}
