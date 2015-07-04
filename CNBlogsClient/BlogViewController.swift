//
//  BlogViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/1.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import SDWebImage

class BlogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var blogVM: BlogViewModel = BlogViewModel()
    
    @IBOutlet weak var homeBlogBtnView: UIView!
    @IBOutlet weak var commandBlogBtnView: UIView!
    @IBOutlet weak var blogTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        blogVM = BlogViewModel(blogVC: self)
        // 加载下拉刷新
        self.setTableHeadRefreshing()
        self.beginTableHeadRefreshing()
        self.setTableFooterRefreshing()
        
        self.switchNewTypeWithBtnView(1)
        
        //添加这行代码
        self.blogTableView.rowHeight = UITableViewAutomaticDimension
        self.blogTableView.estimatedRowHeight = 44
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
        if equal(segue.identifier!, "blogToDetail") {
            let indexPath = self.blogTableView.indexPathForSelectedRow()
            var blogDetailVC: OnlineInfoDetailViewController = segue.destinationViewController as! OnlineInfoDetailViewController
            blogDetailVC.onlineInfoDetailVM = self.blogVM.newBlogDetailVM(indexPath!.row, vc: blogDetailVC)
        }
    }
    
    // MARK: - 打开菜单
    @IBAction func showMenu(sender: AnyObject) {
        self.frostedViewController.presentMenuViewController()
    }
    
    // 按钮操作
    @IBAction func gainHomeBlog(sender: AnyObject) {
        self.switchNewTypeWithBtnView(1)
        self.blogVM.gainHomeBlog()
    }
    
    
    @IBAction func gainTwoDayTopBlog(sender: AnyObject) {
        self.switchNewTypeWithBtnView(2)
        self.blogVM.gainTwoDayTopViewPostsBlog()
    }
    
    // 切换三个按钮的指示图
    func switchNewTypeWithBtnView(btnIndex: Int) {
        self.homeBlogBtnView.hidden    = true
        self.commandBlogBtnView.hidden = true
        
        switch btnIndex {
        case 1: self.homeBlogBtnView.hidden     = false
        case 2: self.commandBlogBtnView.hidden  = false
        default: println("")
        }
    }
    
    // MARK: - 下拉刷新
    /**
    设置下拉刷新
    */
    func setTableHeadRefreshing() {
        // 添加传统的下拉刷新
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.blogTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.blogVM.setHeadRefresh(true)
            self.loadNewBlog()
        }
    }
    
    /**
    开始下拉刷新
    */
    func beginTableHeadRefreshing() {
        self.blogTableView.legendHeader.beginRefreshing()
    }
    
    /**
    刷新完成后需要结束下拉刷新状态 : 一般在 加载数据完之后使用
    */
    func endTableHeadRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.blogTableView.header.endRefreshing()
    }
    
    /**
    添加上拉刷新
    */
    func setTableFooterRefreshing() {
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.blogTableView.addLegendFooterWithRefreshingBlock{ () -> Void in
            self.blogVM.setHeadRefresh(false)
            self.loadNewBlog()
        }
    }
    
    /**
    开始上拉刷新
    */
    func beginTableFooterRefreshing() {
        self.blogTableView.legendFooter.beginRefreshing()
    }
    
    /**
    结束上拉刷新
    */
    func endTableFooterRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.blogTableView.footer.endRefreshing()
    }
    
    /**
    移除上拉刷新
    */
    func removeFooterRefreshing() {
        self.blogTableView.removeFooter()
    }
    
    /**
    加载新数据
    */
    func loadNewBlog() {
        self.blogVM.gainBlogListFromNetwork()
    }
    
    func reloadTabeleView() {
        self.blogTableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogVM.gainOnlineNewsCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let news: OnlineBlog = self.blogVM.gainOnlineBlogAtIndexPath(indexPath.row)
        var cell: OnlineInfoWithoutImageTableViewCell = tableView.dequeueReusableCellWithIdentifier("BlogTableViewCell") as! OnlineInfoWithoutImageTableViewCell
        
        self.configurationNoImageCellOfIndex(cell as OnlineInfoWithoutImageTableViewCell, news: news)
        
        return cell
    }
    
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //MARK: - 私有方法
    // 设置内容
    
    func configurationNoImageCellOfIndex(cell: OnlineInfoWithoutImageTableViewCell, news: OnlineBlog) {
        cell.titleLabel.text       = news.title
        cell.summaryLabel.text     = news.summary
        cell.authorLabel.text      = news.author
        cell.publishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
    }
    
    /**
    网络操作失败时，弹出topAlert指示
    */
    func gainBlogInfoFailure() {
        TopAlert().createFailureTopAlert("获取博客失败", parentView: self.view)
    }
}
