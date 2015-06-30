//
//  BlogOfBloggerViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class BlogOfBloggerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var blogVM: BlogOfBloggerViewModel!
    @IBOutlet weak var blogTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.blogVM.gainVCName()
        self.setTableHeadRefreshing()
        
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
        if equal(segue.identifier!, "BloggerInfoListWithoutImageToDetail") {
            
        }
    }

    
    
    // MARK: - 打开菜单
    @IBAction func showMenu(sender: AnyObject) {
        self.frostedViewController.presentMenuViewController()
    }
    
    
    // MARK: - 刷新操作 设置
    
    // 下拉刷新
    func setTableHeadRefreshing() {
        // 添加传统的下拉刷新
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.blogTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.blogVM.isHeadRefresh = true
            self.loadNewNews()
        }
        
        self.beginTableHeadRefreshing()
    }
    
    // 设置上拉刷新
    func setTableFooterRefreshing() {
        self.blogTableView.addLegendFooterWithRefreshingBlock { () -> Void in
            self.blogVM.isHeadRefresh = false
            self.loadNewNews()
        }
    }
    
    // 开始下拉刷新
    func beginTableHeadRefreshing() {
        self.blogTableView.legendHeader.beginRefreshing()
    }
    
    // 开始上拉刷新
    func beginTableFooterRefreshing() {
        self.blogTableView.legendFooter.beginRefreshing()
    }
    
    // 下拉刷新完成后需要结束刷新状态 : 一般在 加载数据完之后使用
    func endTableFooterRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.blogTableView.footer.endRefreshing()
    }
    
    // 上拉刷新完成后需要结束刷新状态 : 一般在 加载数据完之后使用
    func endTableHeadRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.blogTableView.header.endRefreshing()
    }
    
    // 加载新数据
    func loadNewNews() {
        blogVM.gainBlogFormNetWork()
    }
    
    func reloadTabeleView() {
        self.blogTableView.reloadData()
    }

    // MARK: - TableView Delegate 和 DataSource 操作
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogVM.gainBlogListsCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: OnlineInfoWithoutImageTableViewCell = tableView.dequeueReusableCellWithIdentifier("BlogOfBloggerTableViewCell") as! OnlineInfoWithoutImageTableViewCell
        
        let blog: OnlineInformation = self.blogVM.gainBlogAtIndex(indexPath.row)
        self.configurationNoImageCellOfIndex(cell, onlineInfo: blog)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    // MARK: - 私有函数
    func configurationNoImageCellOfIndex(cell: OnlineInfoWithoutImageTableViewCell, onlineInfo: OnlineInformation) {
        cell.titleLabel.text       = onlineInfo.title
        cell.summaryLabel.text     = onlineInfo.summary
        cell.publishTimeLabel.text = onlineInfo.publishTime.dateToStringByBaseFormat()
    }
    
    /**
    网络操作失败时，弹出topAlert指示
    */
    func gainNewsInfoFailure() {
        TopAlert().createFailureTopAlert("获取新闻失败", parentView: self.view)
    }
}
