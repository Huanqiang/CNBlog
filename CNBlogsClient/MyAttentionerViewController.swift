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
    
    @IBOutlet weak var myAttentionerTableView: UITableView!
    var myAttentionerVM: MyAttentionerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myAttentionerVM = MyAttentionerViewModel()
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
            let searchVC: SearchBloggerViewController = segue.destinationViewController as! SearchBloggerViewController
            searchVC.searchBloggerVM = myAttentionerVM.newsSearchBloggerViewModel(searchVC)
        }
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
        cell.bloggerIconImageView.image = UIImage(contentsOfFile: blogger.bloggerIconPath)        
    }
}
