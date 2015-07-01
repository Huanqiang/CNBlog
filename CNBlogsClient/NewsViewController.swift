//
//  NewsViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import SDWebImage

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newsModel: NewsViewModel = NewsViewModel()
    
    @IBOutlet weak var newsListTableView: UITableView!
    @IBOutlet weak var recentNewsBtnStateView: UIView!
    @IBOutlet weak var popNewsBtnStateView: UIView!
    @IBOutlet weak var commendNewsBtnStateView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newsModel = NewsViewModel(newsVC: self)
        // 加载下拉刷新
        self.setTableRefreshing()
        
        //添加这行代码
        self.newsListTableView.rowHeight = UITableViewAutomaticDimension
        self.newsListTableView.estimatedRowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var indexPath:NSIndexPath = newsListTableView.indexPathForSelectedRow()!

        if equal(segue.identifier!, "NewsListWithImageToDetail") || equal(segue.identifier!, "NewsListWithoutImageToDetail") {
            var newsDetailVC: OnlineInfoDetailViewController = segue.destinationViewController as! OnlineInfoDetailViewController
            newsDetailVC.onlineInfoDetailVM = self.newsModel.newsDetailViewModelForIndexPath(indexPath.row, vc: newsDetailVC)
        }
    }


    // MARK: - 打开菜单
    @IBAction func showMenu(sender: AnyObject) {
        self.frostedViewController.presentMenuViewController()
    }
    
    
    // MARK: - 下拉刷新
    func setTableRefreshing() {
        // 添加传统的下拉刷新
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.newsListTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.loadNewNews()
        }
        
        self.beginTableRefreshing()
    }

    // 开始刷新
    func beginTableRefreshing() {
        self.newsListTableView.legendHeader.beginRefreshing()
    }
    
    // 刷新完成后需要结束刷新状态 : 一般在 加载数据完之后使用
    func endTableRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.newsListTableView.header.endRefreshing()
    }
    
    // 加载新数据
    func loadNewNews() {
        newsModel.gainNewsListFromNetwork()
    }
    
    func reloadTabeleView() {
        self.newsListTableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.newsElementLists.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let news: OnlineNews = self.newsModel.gainOnlineNewsAtIndexPath(indexPath.row)
        var cell: UITableViewCell?
        
        if news.hasIcon {
            cell = tableView.dequeueReusableCellWithIdentifier("NewsCellWithImage") as? OnlineInfoWithImageTableViewCell
            
            self.configurationImageCellOfIndex(cell as! OnlineInfoWithImageTableViewCell, news: news)
        }else {
            cell = tableView.dequeueReusableCellWithIdentifier("NewsCellWithoutImage") as? OnlineInfoWithoutImageTableViewCell
            
            self.configurationNoImageCellOfIndex(cell as! OnlineInfoWithoutImageTableViewCell, news: news)
        }
        
        return cell!
    }
    
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: - 私有方法
    // 设置内容
    func configurationImageCellOfIndex(cell: OnlineInfoWithImageTableViewCell, news: OnlineNews) {
        cell.titleLabel.text       = news.title
        cell.summaryLabel.text     = news.summary
        cell.authorLabel.text     = news.author
        cell.publishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
        
        // 获取标题图片
        weak var weakCell = cell
        let url: NSURL = NSURL(string: news.iconURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        cell.onlineImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "tableCellDefaultImage")) {
            (image, error, SDImageCacheType, url) -> Void in
            weakCell!.onlineImageView.image = image
            news.iconInfo = image
        }
    }
    
    func configurationNoImageCellOfIndex(cell: OnlineInfoWithoutImageTableViewCell, news: OnlineNews) {
        cell.titleLabel.text       = news.title
        cell.summaryLabel.text     = news.summary
        cell.authorLabel.text     = news.author
        cell.publishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
    }
    
    /**
    网络操作失败时，弹出topAlert指示
    */
    func gainNewsInfoFailure() {
        TopAlert().createFailureTopAlert("获取新闻失败", parentView: self.view)
    }
}
