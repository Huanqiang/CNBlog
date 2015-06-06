//
//  NewsDetailViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/4.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    //数据变量
    var newsDetailModel: NewsDetailViewModel = NewsDetailViewModel()

    // 控件变量
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsPublishTimeLabel: UILabel!
    @IBOutlet weak var newsContextTextView: UITextView!
    @IBOutlet weak var newsOfflineBarBtn: UIBarButtonItem!
    @IBOutlet weak var newsContentWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //  设置标题、作者、发表时间
        newsTitleLabel.text       = newsDetailModel.newsInfo.title
        newsAuthorLabel.text      = newsDetailModel.newsInfo.author
        newsPublishTimeLabel.text = newsDetailModel.newsInfo.publishTime.dateToStringByBaseFormat()
        
        self.newsDetailModel.gainNewsListFromNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 网络操作的界面操作
    /**
    开始 等待网络数据时的 指示器
    */
    func waitOfflineNewsContent() {
        self.pleaseWait()
    }
    
    /**
    结束 等待网络数据时的 指示器
    */
    func endWaitOfflineNewsContent() {
        self.clearAllNotice()
    }
    
    /**
    网络操作操作时的操作
    */
    func gainNewsInfoSuccess() {
        self.newsContentWebView.loadHTMLString(self.newsDetailModel.newsInfo.content, baseURL: nil)
    }
    
    /**
    网络操作失败时，弹出topAlert指示
    */
    func gainNewsInfoFailure() {
        TopAlert().createFailureTopAlert("获取新闻失败", parentView: self.view)
    }

    // MARK: - 数据离线
    @IBAction func newsOffline(sender: AnyObject) {
        self.newsDetailModel.newsOffline()
    }
    
    /**
    新闻离线成功时的提示
    */
    func offlineNewsSuccess() {
        TopAlert().createBaseTopAlert(MozAlertTypeSuccess, alertInfo: "离线成功", parentView: self.view)
    }
}
