//
//  OnlineInfoDetailViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/4.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class OnlineInfoDetailViewModel: NSObject {
    var onlineInfo: OnlineInformation = OnlineInformation()
    var onlineDetailVC: OnlineInfoDetailViewController!
    
    override init() {
        super.init()
    }
    
    init(onlineInfo: OnlineInformation, onlineDetailVC: OnlineInfoDetailViewController) {
        self.onlineInfo = onlineInfo
        self.onlineDetailVC = onlineDetailVC
    }
    
    // MARK: - 网络操作
    func gainOnlineInfoListFromNetwork() {        
        self.onlineDetailVC.waitOfflineOnlineInfoContent()
        // 防止 闭包循环， 使用weak
        weak var weakSelf: OnlineInfoDetailViewModel? = self
        self.onlineInfo.gainOnlineInfoContentFromNetwork { (onlineInfo) -> Void in
            self.onlineDetailVC.endWaitOfflineOnlineInfoContent()
            // 数据处理
            if (onlineInfo != nil && onlineInfo?.count != 0) {
                weakSelf!.onlineInfo.content = (onlineInfo![0] as! OnlineInformation).content
                weakSelf!.onlineDetailVC.gainOnlineInfoInfoSuccess()
            }else {
                weakSelf!.onlineDetailVC.showGainOnlineInfoInfoFailure()
            }
        }
    }
    
    
    // MARK: - 数据离线
    func infoOffline() {
        // 资源离线
        if onlineInfo.offlineInfo() {
            // 显示成功指示器
            self.onlineDetailVC.showOfflineOnlineInfoSuccess()
        }
    }
}
