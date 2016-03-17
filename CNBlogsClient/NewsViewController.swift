//
//  NewsViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import SDWebImage

enum NewsTableType: Int{
    case PopNewsTable = 0, RecentNewsTable, CommendNewsTable
}


class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newsModel: NewsViewModel = NewsViewModel()
    
    @IBOutlet weak var newsListTableView: UITableView!
    @IBOutlet weak var recentNewsBtnStateView: UIView!
    @IBOutlet weak var popNewsBtnStateView: UIView!
    @IBOutlet weak var commendNewsBtnStateView: UIView!
    
    var currentTableType: NewsTableType = .PopNewsTable;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newsModel = NewsViewModel(newsVC: self)
        // 加载下拉刷新
        self.setTableHeadRefreshing()
        self.beginTableHeadRefreshing()
        
        self.switchNewTypeWithBtnView(NewsTableType.PopNewsTable)
        
        //添加这行代码
        self.newsListTableView.rowHeight = UITableViewAutomaticDimension
        self.newsListTableView.estimatedRowHeight = 44
        
        
        
        // 新增手势操作
        let leftSwipeGR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeGesture:"))
        leftSwipeGR.direction = .Left
        
        let rightSwipeGR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeGesture:"))
        rightSwipeGR.direction = .Right;
        
        self.view.addGestureRecognizer(leftSwipeGR)
        self.view.addGestureRecognizer(rightSwipeGR)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeGesture(sender: UISwipeGestureRecognizer) {
//        let direction = sender.direction;
        
        switch (sender.direction) {
        case UISwipeGestureRecognizerDirection.Left:
            if ((self.currentTableType.rawValue - 1) >= 0) {
                self.switchNewTypeWithBtnView(NewsTableType(rawValue: self.currentTableType.rawValue - 1)!)
            }
        case UISwipeGestureRecognizerDirection.Right:
            if ((self.currentTableType.rawValue + 1) < 3) {
                self.switchNewTypeWithBtnView(NewsTableType(rawValue: self.currentTableType.rawValue + 1)!)
            }
        default:
            print("news")
        }
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath:NSIndexPath = newsListTableView.indexPathForSelectedRow!

        if (segue.identifier!).characters.elementsEqual("NewsListWithImageToDetail".characters) || (segue.identifier!).characters.elementsEqual("NewsListWithoutImageToDetail".characters) {
            let newsDetailVC: OnlineInfoDetailViewController = segue.destinationViewController as! OnlineInfoDetailViewController
            newsDetailVC.onlineInfoDetailVM = self.newsModel.newsDetailViewModelForIndexPath(indexPath.row, vc: newsDetailVC)
        }
    }
    
    // MARK: - 切换表格视图
    // 切换新闻列表按钮 操作
    @IBAction func gainRecentNews(sender: AnyObject) {
        self.switchNewTypeWithBtnView(NewsTableType.RecentNewsTable)
    }
    
    @IBAction func gainPopNews(sender: AnyObject) {
        self.switchNewTypeWithBtnView(NewsTableType.PopNewsTable)
    }
    
    @IBAction func gainCommendNews(sender: AnyObject) {
        self.switchNewTypeWithBtnView(NewsTableType.CommendNewsTable)
    }
    
    // 切换三个按钮的指示图
    func switchNewTypeWithBtnView(btnIndex: NewsTableType) {
        self.recentNewsBtnStateView.hidden  = true
        self.popNewsBtnStateView.hidden     = true
        self.commendNewsBtnStateView.hidden = true
        self.currentTableType = btnIndex;
        
        switch btnIndex {
        case .PopNewsTable:
            self.popNewsBtnStateView.hidden = false
            self.newsModel.gainPopNews()
        case .RecentNewsTable:
            self.recentNewsBtnStateView.hidden = false
            self.newsModel.gainRecentNews()
        case .CommendNewsTable:
            self.commendNewsBtnStateView.hidden = false
            self.newsModel.gainCommendNews()
        }
    }

    // MARK: - 打开菜单
    @IBAction func showMenu(sender: AnyObject) {
        self.frostedViewController.presentMenuViewController()
    }
    
    
    // MARK: - 下拉刷新
    /**
    设置下拉刷新
    */
    func setTableHeadRefreshing() {
        // 添加传统的下拉刷新
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.newsListTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.newsModel.setHeadRefresh(true)
            self.loadNewNews()
        }
    }

    /**
    开始下拉刷新
    */
    func beginTableHeadRefreshing() {
        self.newsListTableView.legendHeader.beginRefreshing()
    }
    
    /**
    刷新完成后需要结束下拉刷新状态 : 一般在 加载数据完之后使用
    */
    func endTableHeadRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.newsListTableView.header.endRefreshing()
    }
    
    /**
    添加上拉刷新
    */
    func setTableFooterRefreshing() {
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.newsListTableView.addLegendFooterWithRefreshingBlock{ () -> Void in
            self.newsModel.setHeadRefresh(false)
            self.loadNewNews()
        }
    }
    
    /**
    开始上拉刷新
    */
    func beginTableFooterRefreshing() {
        self.newsListTableView.legendFooter.beginRefreshing()
    }
    
    /**
    结束上拉刷新
    */
    func endTableFooterRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.newsListTableView.footer.endRefreshing()
    }
    
    /**
    移除上拉刷新
    */
    func removeFooterRefreshing() {
        self.newsListTableView.removeFooter()
    }
    
    /**
    加载新数据
    */
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
        return self.newsModel.gainOnlineNewsCount()
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
        cell.authorLabel.text      = news.author
        cell.publishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
        
        // 获取标题图片
        weak var weakCell = cell
        let url: NSURL = NSURL(string: news.iconURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
//        let url: NSURL = NSURL(string: news.iconURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        cell.onlineImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "tableCellDefaultImage")) {
            (image, error, SDImageCacheType, url) -> Void in
            weakCell!.onlineImageView.image = image
            news.iconInfo = image
        }
    }
    
    func configurationNoImageCellOfIndex(cell: OnlineInfoWithoutImageTableViewCell, news: OnlineNews) {
        cell.titleLabel.text       = news.title
        cell.summaryLabel.text     = news.summary
        cell.authorLabel.text      = news.author
        cell.publishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
    }
    
    /**
    网络操作失败时，弹出topAlert指示
    */
    func gainNewsInfoFailure() {
        TopAlert().createFailureTopAlert("获取新闻失败", parentView: self.view)
    }
}
