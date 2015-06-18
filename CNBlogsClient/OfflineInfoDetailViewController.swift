//
//  OfflineInfoDetailViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/17.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import DTCoreText

class OfflineInfoDetailViewController: UIViewController, DTLazyImageViewDelegate, DTAttributedTextContentViewDelegate {

    @IBOutlet weak var offlineInfoTitleLabel: UILabel!
    @IBOutlet weak var offlineInfoAuthorLabel: UILabel!
    @IBOutlet weak var offlineInfoPublishTimeLabel: UILabel!
    @IBOutlet weak var offlineInfoContentTextView: DTAttributedTextView!
    
    
    var offlineDetailInfoModel: OfflineInfoDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.offlineInfoTitleLabel.text       = self.offlineDetailInfoModel.offlineInfo.title
        self.offlineInfoAuthorLabel.text      = self.offlineDetailInfoModel.offlineInfo.author
        self.offlineInfoPublishTimeLabel.text = self.offlineDetailInfoModel.offlineInfo.publishTime.dateToStringByBaseFormat()
        
        self.offlineDetailInfoModel.gainOfflineInfoContent()
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
    
    // MARK: - 加载离线资讯主内容
    func showOfflineInfoContent() {
        let htmlData:NSData = self.offlineDetailInfoModel.offlineInfo.content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        var attributedString: NSAttributedString = NSAttributedString(HTMLData: htmlData, options: self.setAttributedOption() as [NSObject : AnyObject], documentAttributes: nil)
        
        self.offlineInfoContentTextView.attributedString = attributedString;
        self.offlineInfoContentTextView.textDelegate = self
        self.offlineInfoContentTextView.shouldDrawImages = false
        self.offlineInfoContentTextView.shouldDrawLinks = false
        self.offlineInfoContentTextView.contentInset = UIEdgeInsetsMake(5, 10, 10, 10);
        
        self.offlineInfoContentTextView.relayoutText()
    }
    
    // 主要用于设置 图片的最大尺寸
    func setAttributedOption() -> NSMutableDictionary {
        let maxImageSize: CGSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0)
        let options: NSMutableDictionary = NSMutableDictionary(objectsAndKeys: NSNumber(float: 1.0), NSTextSizeMultiplierDocumentOption, NSValue(CGSize: maxImageSize), DTMaxImageSize)
        
        return options
    }
    
    // MARK: - DTAttributedTextContentViewDelegate
    /**
    用来 跳转超链接
    */
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForLink url: NSURL!, identifier: String!, frame: CGRect) -> UIView! {
        var linkButton: DTLinkButton = DTLinkButton(frame: frame)
        linkButton.URL = url
        
        // get image with normal link text
        var normalImage: UIImage = attributedTextContentView.contentImageWithBounds(frame, options: DTCoreTextLayoutFrameDrawingOptions.Default)
        linkButton.setImage(normalImage, forState: UIControlState.Normal)
        
        // get image for highlighted link text
        var highlightImage: UIImage = attributedTextContentView.contentImageWithBounds(frame, options: DTCoreTextLayoutFrameDrawingOptions.DrawLinksHighlighted)
        linkButton.setImage(highlightImage, forState: UIControlState.Highlighted)
        
        linkButton.addTarget(self, action: "linkButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        return linkButton
    }
    
    @IBAction func linkButtonClicked(sender: DTLinkButton) {
        UIApplication.sharedApplication().openURL(sender.URL)
    }
    
    /**
    加载 html 中的图片
    */
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttachment attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment.isKindOfClass(DTImageTextAttachment.self) {
            var dtImageView: DTLazyImageView = DTLazyImageView(frame: frame)
            // 从本地加载图片
            dtImageView.image = FolderOperation().gainImageFromFolder(NewsIconFolderName, imageName: attachment.contentURL.lastPathComponent!)
            // url for deferred loading
            dtImageView.url = attachment.contentURL
            return dtImageView
        }
        return nil
    }
}
