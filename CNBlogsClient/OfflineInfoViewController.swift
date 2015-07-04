//
//  OfflineInfoViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/13.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class OfflineInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var OfflineNewsBtn: UIButton!
    @IBOutlet weak var OfflineBlogBtn: UIButton!
    @IBOutlet weak var OfflineNewsBtnView: UIView!
    @IBOutlet weak var OfflineBlogBtnView: UIView!
    @IBOutlet weak var OfflineInfoTableView: UITableView!
    
    var offlineInfoModel: OfflineInfoViewModel = OfflineInfoViewModel()
    var isNewsView: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.OfflineInfoTableView.rowHeight = UITableViewAutomaticDimension
        self.OfflineInfoTableView.estimatedRowHeight = 44
        
        // 设置提示线
        self.OfflineBlogBtnView.hidden = true
        self.OfflineNewsBtnView.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        if !self.offlineInfoModel.gainIsToDetail() {
            self.offlineInfoModel = OfflineInfoViewModel(isNewsView: self.gainIsNewsView(), offlineVC: self)
        }
        
        // 每次重新回到这个页面后都设置为 false，以便从别的页（即非详细视图）回来的时候重新对页面进行加载
        self.offlineInfoModel.setToDetail(false)
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
        let index = self.OfflineInfoTableView.indexPathForSelectedRow()!.row
        if equal(segue.identifier!, "OfflineInfoListWithImageToDetail") || equal(segue.identifier!, "OfflineInfoListWithoutImageToDetail") {
            self.offlineInfoModel.setToDetail(true)
            var offlineDetailInfoVC = segue.destinationViewController as! OfflineInfoDetailViewController
            offlineDetailInfoVC.offlineDetailInfoModel = self.offlineInfoModel.offlineInfoDetailViewModelForIndexPath(index, vc: offlineDetailInfoVC)
        }
    }


    // MARK: - 打开菜单
    @IBAction func showMenu(sender: AnyObject) {
        self.frostedViewController.presentMenuViewController()
    }
    
    // MARK: - 获取数据操作
    @IBAction func gainOfflineNews(sender: AnyObject) {
        self.setIsNewsTableView(true)
        self.offlineInfoModel.gainNewsElementLists()
        // 设置提示线
        self.OfflineBlogBtnView.hidden = true
        self.OfflineNewsBtnView.hidden = false
    }
    
    
    @IBAction func gainOfflineBlog(sender: AnyObject) {
        self.setIsNewsTableView(false)
        self.offlineInfoModel.gainBlogElementLists()
        // 设置提示线
        self.OfflineBlogBtnView.hidden = false
        self.OfflineNewsBtnView.hidden = true
    }
    
    
    // 刷新tableView
    func reloadTabeleView() {
        self.OfflineInfoTableView.reloadData()
    }
    
    // MARK: - TableView 操作
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offlineInfoModel.gainOfflineInfoElementListsCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let news: OfflineInformation = self.offlineInfoModel.offlineAtIndex(indexPath.row)
        var cell: UITableViewCell?
        
        if news.hasIcon {
            cell = tableView.dequeueReusableCellWithIdentifier("OfflineInfoWithImageCell") as? OfflineInfoWithImageTableViewCell
            
            self.configurationImageCellOfIndex(cell as! OfflineInfoWithImageTableViewCell, news: news)
        }else {
            cell = tableView.dequeueReusableCellWithIdentifier("OfflineInfoWithoutImageCell") as? OfflineInfoWithoutImageTableViewCell
            
            self.configurationNoImageCellOfIndex(cell as! OfflineInfoWithoutImageTableViewCell, news: news)
        }
        
        return cell!
    }
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - 私有函数
    func configurationImageCellOfIndex(cell: OfflineInfoWithImageTableViewCell, news: OfflineInformation) {
        cell.infoTitleLabel.text       = news.title
        cell.infoSummaryLabel.text     = news.summary
        cell.infoAuathorLabel.text     = news.author
        cell.infoPublishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
        
        cell.infoImageView.image = FolderOperation().gainImageFromFolder(NewsIconFolderName, imageName: news.iconPath.lastPathComponent)
    }
    
    func configurationNoImageCellOfIndex(cell: OfflineInfoWithoutImageTableViewCell, news: OfflineInformation) {
        cell.infoTitleLabel.text       = news.title
        cell.infoSummaryLabel.text     = news.summary
        cell.infoAuathorLabel.text     = news.author
        cell.infoPublishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
    }
    
    /**
    用以判断当前视图是不是新闻视图
    
    :param: isNews true为新闻视图，false为博客视图
    */
    func setIsNewsTableView(isNews: Bool) {
        self.isNewsView = isNews
    }
    
    func gainIsNewsView() -> Bool {
        return self.isNewsView
    }
}
