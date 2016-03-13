//
//  EmptyViewSet.swift
//  TestDNZ
//
//  Created by 子叶 on 15/7/31.
//  Copyright (c) 2015年 子叶. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EmptyViewSet: NSObject, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    /// 空白页中心图片（主图片）
    var emptyImgName: String     = ""
    /// 空白页中心主标题（位于主图片下面）
    var emptyTitle: String       = ""
    /// 空白页详细描述
    var emptyDescription: String = ""
    /// 空白页背景颜色
    var emptyBgColor: UIColor    = UIColor.whiteColor()
    /// 空白页背景图片
    var emptyBgImgName: String   = ""
    /// 空白页可执行按钮
    var emptyButtonName: String  = ""
    /// 空白页按钮的方法
    var emtpyBtnFunc: (Void) -> Void = {}
    
    
    // MARK: - 设置空白页信息
    /**
    设置空白页中心图片（主图片）
    
    - parameter img: 主图片名称
    */
    func setEmptyViewImg(imgName: String) {
        self.emptyImgName = imgName
    }
    
    /**
    设置空白页中心主标题（位于主图片下面）
    
    - parameter title: 主标题内容
    */
    func setEmptyViewTitle(title: String) {
        self.emptyTitle = title
    }
    
    /**
    设置空白页详细描述
    
    - parameter description: 详细描述内容
    */
    func setEmptyViewDescription(description: String) {
        self.emptyDescription = description
    }
    
    /**
    设置空白页背景颜色
    
    - parameter bgColor: 背景颜色
    */
    func setEmptyViewBgColor(bgColor: UIColor) {
        self.emptyBgColor = bgColor
    }
    
    /**
    设置空白页背景图片
    
    - parameter bgImg: 背景图片
    */
    func setEmptyViewByImg(bgImgName: String) {
        self.emptyBgImgName = bgImgName
    }
    
    /**
    设置空白页按钮信息
    
    - parameter btnName: 按钮名称
    - parameter btnFunc: 按钮的方法
    */
    func setEmptyBtn(btnName: String, btnFunc: (Void -> Void)) {
        self.emptyButtonName = btnName
        self.emtpyBtnFunc    = btnFunc
    }
    
    
    
    // MARK: - 设置空白页的 DataSource
   
    // 设置图片
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: self.emptyImgName)
    }
    
    // 设置标题
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = self.emptyTitle
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    // 设置详细描述
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text: String = self.emptyDescription
        let paragaraph = NSMutableParagraphStyle()
        paragaraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragaraph.alignment = NSTextAlignment.Center
        
        let attributtes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(15.0),
            NSForegroundColorAttributeName: UIColor(red: 159/255.0, green: 159/255.0, blue: 159/255.0, alpha: 1),
            NSParagraphStyleAttributeName: paragaraph
        ]
        return NSAttributedString(string: text, attributes: attributtes)
    }
    
    // 设置按钮
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let attributtes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(17.0),
            NSForegroundColorAttributeName: UIColor(red: 0, green: 0.396, blue: 0.682, alpha: 1)
        ]
        return NSAttributedString(string: self.emptyButtonName, attributes: attributtes)
    }
    
    // 设置背景色
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return self.emptyBgColor
    }
    
    
    // MARK: - 设置空白页的 Delegate
    // 设置按钮操作
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        // 自己所设置的按钮操作
        emtpyBtnFunc()
    }
}
