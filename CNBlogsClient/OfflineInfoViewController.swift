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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.offlineInfoModel = OfflineInfoViewModel(offlineVC: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - 获取数据操作
    @IBAction func gainOfflineNews(sender: AnyObject) {
    }
    
    
    @IBAction func gainOfflineBlog(sender: AnyObject) {
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
        return self.offlineInfoModel.gainNewsElementListsCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let news: OfflineNews = self.offlineInfoModel.offlineAtIndex(indexPath.row)
        if news.hasIcon {
            var cell:InfoWithImageTableViewCell? = tableView.dequeueReusableCellWithIdentifier("OfflineInfoWithImageCell") as? InfoWithImageTableViewCell
            
            self.configurationImageCellOfIndex(cell!, news: news)
            
            return cell!
        }else {
            var cell:InfoWithoutImageTableViewCell? = tableView.dequeueReusableCellWithIdentifier("OfflineInfoWithoutImageCell") as? InfoWithoutImageTableViewCell
            
            self.configurationNoImageCellOfIndex(cell!, news: news)
            
            return cell!
        }
    }
    
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - 私有函数
    func configurationImageCellOfIndex(cell: InfoWithImageTableViewCell, news: OfflineNews) {
        cell.infoTitleLabel.text       = news.title
        cell.infoSummaryLabel.text     = news.summary
        cell.infoAuathorLabel.text     = news.author
        cell.infoPublishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
        
        cell.infoImageView.image = FolderOperation().gainImageFromFolder(CacheFolderName, imageName: news.iconPath.lastPathComponent)
    }
    
    func configurationNoImageCellOfIndex(cell: InfoWithoutImageTableViewCell, news: OfflineNews) {
        cell.infoTitleLabel.text       = news.title
        cell.infoSummaryLabel.text     = news.summary
        cell.infoAuathorLabel.text     = news.author
        cell.infoPublishTimeLabel.text = news.publishTime.dateToStringByBaseFormat()
    }
    
    
}
