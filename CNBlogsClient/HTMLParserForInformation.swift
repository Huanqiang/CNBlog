//
//  HTMLParserForInformation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/10.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class HTMLParserForInformation: NSObject {
    
    /**
    替换 Img 标签
    
    :param: htmlInfo  HTML信息
    :param: newImgTag 由<旧标签，新标签>组成的字典
    
    :returns: 替换后的HTML
    */
    func replaceImaTagWithHTMLInfo(htmlInfo: String, newImgTag: Dictionary<String, String>) ->String {
        var newHtmlInfo: String = htmlInfo
        
        
        // 先替换 url
        for (priImg, nowImg) in newImgTag {
            newHtmlInfo = newHtmlInfo.stringByReplacingOccurrencesOfString(priImg, withString: nowImg, options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        // 再设置图片的大小
        var error: NSError?
        var parseInfo = HTMLParser(html: self.addHtmlBodyTag(newHtmlInfo), error: &error)
        var bodyNode = parseInfo.body
        if let inputNodes = bodyNode?.findChildTags("img") {
            for node in inputNodes {
                let imageWidth = node.getAttributeNamed("width")
                if equal(imageWidth, "") {
                    let imgUrl = node.getAttributeNamed("src")
                    newHtmlInfo = newHtmlInfo.stringByReplacingOccurrencesOfString(imgUrl + "\"", withString: self.replaceImageFrame(imgUrl), options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
            }
        }
        
        
        
        return newHtmlInfo
    }
    
    // 能过获取图片原本宽高（尺寸）
    func gainImageFrame(image: UIImage) {
        var imageSource: CGImageRef = image.CGImage
        var height = CGImageGetHeight(imageSource)
        var width = CGImageGetWidth(imageSource)
    }
    
    
    
    func replaceImageFrame(imgUrl: String) -> String {
        let img = UIImage(contentsOfFile: imgUrl)
        let size = img!.originalFrame()
        return imgUrl + "\" width=\"\(size.width)\" height=\"\(size.height)\""
    }
    
    /**
    从 HTML信息中获取 iam 标签的图片超链接
    
    :param: htmlInfo HTML信息
    
    :returns: iam 标签的图片超链接 数组
    */
    func gainImaTagFromHTMLInfo(htmlInfo: String) ->[String] {
        var imageSrcList: [String] = []
        
        var error: NSError?
        var parseInfo = HTMLParser(html: self.addHtmlBodyTag(htmlInfo), error: &error)
        var bodyNode = parseInfo.body
        if let inputNodes = bodyNode?.findChildTags("img") {
            for node in inputNodes {
                imageSrcList.append(node.getAttributeNamed("src"))
            }
        }
        return imageSrcList
    }
    
    /**
    向html信息内添加 <body>标签
    
    :param: htmlInfo html信息
    
    :returns: 添加<body>标签后的html信息
    */
    func addHtmlBodyTag(htmlInfo: String) -> String {
        return "<body>" + htmlInfo + "</body>"
    }
}
