//
//  SearchBloggerViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class SearchBloggerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var bloggerSearchBar: UISearchBar!
    @IBOutlet weak var bloggerTableView: UITableView!
    var searchBloggerVM: SearchBloggerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bloggerSearchBar.becomeFirstResponder() 
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
    
    // MARK: - TableView 操作
    func reloadBloggerTableView() {
        self.bloggerTableView.reloadData()
    }
    
    // MARK: - TableViewDataSource And Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBloggerVM.gainBloggerSearchResultCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: BloggerTableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchBloggerCell") as! BloggerTableViewCell
        
        self.configurationCellOfIndex(cell, index: indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.sureBloggerType(self.searchBloggerVM.gainBloggerAtIndex(indexPath.row))
    }
    
    // 弹出对话框提示是否保存当前博主
    func sureBloggerType(blogger: Blogger) {
        var msg = ""
        if self.searchBloggerVM.isBloggerSelf {
            msg = "您确定 \(blogger.bloggerName) 为自己的博客？"
        }else {
            msg = "您确定 \(blogger.bloggerName) 为关注人？"
        }
        
        var alertView: UIAlertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        var sureAction: UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            if blogger.saveBlogger() {
                self.setBloggersSuccess()
            }
        }
        alertView.addAction(sureAction)
        var cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(cancelAction)
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    // MARK: - SearchDelegate 操作
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.waitBloggersContent()
        searchBar.resignFirstResponder()
        self.searchBlogger(searchBar.text)
    }
    
    
    
    
    func searchBlogger(bloggerName: String) {
        self.searchBloggerVM.gainBloggerFromNetwork(bloggerName)
    }
    
    // MARK: - 私有函数
    func configurationCellOfIndex(cell: BloggerTableViewCell, index: Int) {
        var blogger: Blogger = searchBloggerVM.gainBloggerAtIndex(index)
        
        cell.bloggerArticleCountLabel.text = "\(blogger.bloggerArticleCount)"
        cell.bloggerNameLabel.text = blogger.bloggerName
        cell.bloggerUpdateTimeLabel.text = blogger.bloggerUpdatedTime.dateToStringByBaseFormat()
        
        weak var weakCell = cell
        let url: NSURL = NSURL(string: blogger.bloggerIconURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        cell.bloggerIconImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "userIcon")) { (image, error, SDImageCacheType, url) -> Void in
            if (image != nil) {
                weakCell!.bloggerIconImageView.image = image
                blogger.bloggerIconInfo = image
            }
            
        }
    }
    
    /**
    网络操作失败时，弹出topAlert指示
    */
    func gainBloggersFailure() {
        TopAlert().createFailureTopAlert("搜索失败", parentView: self.view)
    }
    
    /**
    设置博主为自己或者关注人成功，弹出的topAlert指示
    */
    func setBloggersSuccess() {
        TopAlert().createSuccessTopAlert("设置成功", parentView: self.view)
    }
    
    // MARK: - 网络操作的界面操作
    /**
    开始 等待网络数据时的 指示器
    */
    func waitBloggersContent() {
        self.pleaseWait()
    }
    
    /**
    结束 等待网络数据时的 指示器
    */
    func endWaitBloggersContent() {
        self.clearAllNotice()
    }

}
