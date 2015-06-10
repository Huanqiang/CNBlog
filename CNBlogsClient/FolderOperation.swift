//
//  FolderOperation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/5.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

/**
*  在Documents文件夹下的操作子文件夹
*/
class FolderOperation: NSObject {
   
    func gainDocumentPath() -> String {
        return NSHomeDirectory().stringByAppendingPathComponent("Documents")
    }
    
    func gainFolderPath(folderName: String) -> String {
        return self.gainDocumentPath().stringByAppendingPathComponent(folderName)
    }
    
    // *********** 文件操作 **********
    /**
    保存图片
    
    :param: folderName 文件夹名称
    :param: imageData  图片数据
    :param: imageName  图片名
    
    :returns: 图片路径
    */
    func saveImageToFolder(folderName: String, imageData: NSData, imageName: String) -> String{
        let folderPath: String = self.gainFolderPath(folderName)
        let imagePath: String = folderPath.stringByAppendingString("/\(imageName).png")
        var fileManager: NSFileManager = NSFileManager.defaultManager()
        //把刚刚图片转换的data对象保存至沙盒中
        fileManager.createFileAtPath(imagePath, contents: imageData, attributes: nil)
        return imagePath
    }
    
    
    // ***********  文件夹操作 *********
    /**
    创建指定文件夹(单层）
    
    :param: folderName 文件夹名称
    */
    func createFolderInDocuments(folderName: String) {
        let path: String = self.gainFolderPath(folderName)
        let bo = NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
        assert(bo, "创建文件夹失败")
    }

    
    /**
    判断在Documents文件夹下是否存在指定文件夹
    
    :param: folderName 文件夹名称
    
    :returns: 存在返回ture；不存在返回false
    */
    func isExitsWithTheFolder(folderName: String) -> Bool {
        let path: String = self.gainFolderPath(folderName)
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }

    /**
    删除指定文件夹下的所有文件
    
    :param: folderName 文件夹名称
    */
    func removeFileInTheFolder(folderName: String) {
        let path: String = self.gainFolderPath(folderName)
        
        var fileManager: NSFileManager = NSFileManager.defaultManager()
        let contents: NSArray = fileManager.contentsOfDirectoryAtPath(path, error: nil)!
        var enumerator: NSEnumerator = contents.objectEnumerator()
        
        var fileName: AnyObject? = enumerator.nextObject()
        while ((fileName) != nil) {
            fileManager.removeItemAtPath(path.stringByAppendingPathComponent(fileName as! String), error: nil)
            fileName = enumerator.nextObject()
        }
    }

}
