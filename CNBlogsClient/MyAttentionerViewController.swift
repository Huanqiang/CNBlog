//
//  MyAttentionerViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import SDWebImage

class MyAttentionerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var EmptyViewInfo: EmptyViewSet!
    @IBOutlet weak var myAttentionerTableView: UITableView!
    var myAttentionerVM: MyAttentionerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myAttentionerVM = MyAttentionerViewModel(myAttentionerVC: self)
        // 空界面视图 设置
        myAttentionerVM.setEmptyViewInfo()
        self.myAttentionerTableView.tableFooterView = UIView.new()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.myAttentionerVM.gainAttentioners()
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
        
        if equal(segue.identifier!, "ChangeBloggerAttentioner") {
            // 跳转 搜索关注人 界面
            let searchVC: SearchBloggerViewController = segue.destinationViewController as! SearchBloggerViewController
            searchVC.searchBloggerVM = myAttentionerVM.newsSearchBloggerViewModel(searchVC)
        }else if equal(segue.identifier!, "AttentionerToHisBlog") {
            // 跳转 博主关注人/博主 博客列表
            let indexPath = self.myAttentionerTableView.indexPathForSelectedRow()
            let attentionerBlogg: BlogOfBloggerViewController = segue.destinationViewController as! BlogOfBloggerViewController
            attentionerBlogg.blogVM = myAttentionerVM.newBlogOfAttentionerViewModel(indexPath!.row, vc: attentionerBlogg)
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
        self.myAttentionerTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.loadNewNews()
        }
        
        self.beginTableRefreshing()
    }
    
    // 开始刷新
    func beginTableRefreshing() {
        self.myAttentionerTableView.legendHeader.beginRefreshing()
    }
    
    // 刷新完成后需要结束刷新状态 : 一般在 加载数据完之后使用
    func endTableRefreshing() {
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.myAttentionerTableView.header.endRefreshing()
    }
    
    // 加载新数据
    func loadNewNews() {
//        myAttentionerVM.gainNewsListFromNetwork()
    }
    
    func reloadTabeleView() {
        self.myAttentionerTableView.reloadData()
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAttentionerVM.gainAttentionerCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: BloggerTableViewCell = tableView.dequeueReusableCellWithIdentifier("BloggerAttentionerCell") as! BloggerTableViewCell
        
        self.configurationCellOfIndex(cell, index: indexPath.row)
        
        return cell
    }
    
    
    
    // MARK: - 私有函数
    func configurationCellOfIndex(cell: BloggerTableViewCell, index: Int) {
        let blogger: Blogger = myAttentionerVM.gainTheAttentionerAtIndex(index)
        
        cell.bloggerArticleCountLabel.text = "\(blogger.bloggerArticleCount)"
        cell.bloggerNameLabel.text = blogger.bloggerName
        cell.bloggerUpdateTimeLabel.text = blogger.bloggerUpdatedTime.dateToStringByBaseFormat()
        cell.bloggerIconImageView.image = blogger.gainIconFromDick()
    }
}
