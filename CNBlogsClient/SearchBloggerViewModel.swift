//
//  SearchBloggerViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class SearchBloggerViewModel: NSObject {
    var isBloggerSelf = true // 判断当前搜索的是博主自己还是关注人
    var bloggerSearchResult: [Blogger] = []
    let networkOPeration: NetworkOperation = NetworkOperationWithSearchBlogger()
    var searchBloggerVC: SearchBloggerViewController!
    
    override init() {
    }
    
    init(isBloggerSelf: Bool, searchBloggerVC: SearchBloggerViewController) {
        self.isBloggerSelf = isBloggerSelf
        self.searchBloggerVC = searchBloggerVC
    }
    
    func gainBloggerFromNetwork(bloggerKey: String) {
        weak var weakSelf = self
        networkOPeration.gainInfomationFromNetwork(CNBlogAPIOption.searchOption, parameters: [bloggerKey]) { (onlineInfo) -> Void in
            weakSelf!.searchBloggerVC.endWaitBloggersContent()
            if (onlineInfo != nil) {
                weakSelf!.bloggerSearchResult = []
                self.setBloggersType(weakSelf!, bloggers: onlineInfo as! [Blogger])
                
                weakSelf!.searchBloggerVC.reloadBloggerTableView()
            }else {
                // 网络操作失败
                weakSelf!.searchBloggerVC.gainBloggersFailure()
            }
        }
    }
    
    
    func setBloggersType(weakSelf: SearchBloggerViewModel, bloggers: [Blogger]) {
        if weakSelf.isBloggerSelf {
            for blogger in bloggers {
                weakSelf.bloggerSearchResult.append(BloggerOwned(blogger: blogger))
            }
        }else {
            for blogger in bloggers {
                weakSelf.bloggerSearchResult.append(BloggerAttentioner(blogger: blogger))
            }
        }
    }
    
    // MARK: - table数据操作
    func gainBloggerSearchResultCount() ->Int {
        return bloggerSearchResult.isEmpty ? 0 : bloggerSearchResult.count
    }
    
    func gainBloggerAtIndex(index: Int) -> Blogger {
        return bloggerSearchResult[index]
    }
    
    
    
    
    
    
    
    
}
