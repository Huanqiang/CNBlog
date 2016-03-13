//
//  OpenSourceLicenseViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import DTCoreText

class OpenSourceLicenseViewController: UIViewController, DTAttributedTextContentViewDelegate {

    @IBOutlet weak var OpenSourceLicenseTextView: DTAttributedTextView!
    
    var openSourceLicenseVM: OpenSourceLicenseViewModel! = OpenSourceLicenseViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showOpenSourceLicenseContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - 加载离线资讯主内容
    func showOpenSourceLicenseContent() {
        let htmlData:NSData = self.openSourceLicenseVM.gainOpenSourceLicenseContent()
        let attributedString: NSAttributedString = NSAttributedString(HTMLData: htmlData, documentAttributes: nil)
        
        self.OpenSourceLicenseTextView.attributedString = attributedString;
        self.OpenSourceLicenseTextView.textDelegate = self
        self.OpenSourceLicenseTextView.shouldDrawImages = false
        self.OpenSourceLicenseTextView.shouldDrawLinks = false
        self.OpenSourceLicenseTextView.contentInset = UIEdgeInsetsMake(5, 10, 10, 10);
    }

    // MARK: - DTAttributedTextContentViewDelegate
    /**
    用来 跳转超链接
    */
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForLink url: NSURL!, identifier: String!, frame: CGRect) -> UIView! {
        let linkButton: DTLinkButton = DTLinkButton(frame: frame)
        linkButton.URL = url
        
        // get image with normal link text
        let normalImage: UIImage = attributedTextContentView.contentImageWithBounds(frame, options: DTCoreTextLayoutFrameDrawingOptions.Default)
        linkButton.setImage(normalImage, forState: UIControlState.Normal)
        
        // get image for highlighted link text
        let highlightImage: UIImage = attributedTextContentView.contentImageWithBounds(frame, options: DTCoreTextLayoutFrameDrawingOptions.DrawLinksHighlighted)
        linkButton.setImage(highlightImage, forState: UIControlState.Highlighted)
        
        linkButton.addTarget(self, action: "linkButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        return linkButton
    }
    
    @IBAction func linkButtonClicked(sender: DTLinkButton) {
        sender.URL.absoluteString.openURL()
    }
}
