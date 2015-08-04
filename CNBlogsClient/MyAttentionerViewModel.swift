//
//  MyAttentionerViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class MyAttentionerViewModel: NSObject {
    
    var attentioners: [Blogger] = []
    var myAttentionerVC: MyAttentionerViewController!
   
    init(myAttentionerVC: MyAttentionerViewController) {
        self.myAttentionerVC = myAttentionerVC
    }
    
    /**
    获取关注人数组
    */
    func gainAttentioners() {
        attentioners = BloggerAttentioner().gainBloggerAttentioners()
        if !attentioners.isEmpty {
            self.myAttentionerVC.reloadTabeleView()
        }
    }
    
    // MARK: - 数据操作
    /**
    获取 关注人数量
    
    :returns: 关注人数量
    */
    func gainAttentionerCount() ->Int {
        return attentioners.count
    }
    
    /**
    获取指定关注人
    
    :param: index 被指定的关注人序号
    
    :returns: 被指定的关注人信息
    */
    func gainTheAttentionerAtIndex(index: Int) -> Blogger {
        return attentioners[index]
    }
    
    
    // MARK: - 界面数据传递
    func newsSearchBloggerViewModel(vc: SearchBloggerViewController) -> SearchBloggerViewModel {
        return SearchBloggerViewModel(isBloggerSelf: false, searchBloggerVC: vc)
    }
    
    func newBlogOfAttentionerViewModel(index: Int,vc: BlogOfBloggerViewController) ->BlogOfBloggerViewModel {
        return BlogOfBloggerViewModel(attentioner: self.gainTheAttentionerAtIndex(index), blogVC: vc)
    }
    
    // 设置关注人页面的空白页
    func setEmptyViewInfo() {
        // 设置 空白页信息
        self.myAttentionerVC.EmptyViewInfo.setEmptyViewDescription("没有关注的博主怎么能提高自己！！赶紧点击左上角的搜索按钮，来搜索你的关注博主吧！")
        self.myAttentionerVC.EmptyViewInfo.setEmptyViewImg("noAttentioner")
        self.myAttentionerVC.EmptyViewInfo.setEmptyViewTitle("居然还没有关注的博主")
    }
}
