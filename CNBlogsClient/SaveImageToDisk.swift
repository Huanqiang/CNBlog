//
//  SaveImageToDisk.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/7/16.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class SaveImageToDisk: NSObject {
    
    let folder: FolderOperation = FolderOperation()
    var imgFolderName: String = ""
    
    init(imgFolderName: String) {
        self.imgFolderName = imgFolderName
        //创建文件夹
        folder.createFolderWhenNon(self.imgFolderName)
    }
    
    /**
    保存标题图片
    */
    func saveIamgeToDisk(image: UIImage, imgName: String) -> String {
        return self.saveImage(image, imgName: imgName)
    }
    
    /**
    将图片存储至磁盘
    
    :param: img 图片
    
    :returns: 图片的磁盘路径
    */
    func saveImage(img: UIImage, imgName: String) -> String {
        let localIconPath = folder.saveImageToFolder(self.imgFolderName, image: img, imageName: imgName)
        return localIconPath
    }
    
    
}
