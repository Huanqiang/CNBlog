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
   
    override init() {
        
    }
    
    
    func gainAttentioners() {
        
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
    
}
