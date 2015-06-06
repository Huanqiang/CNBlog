//
//  NewsTableViewCell.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/1.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

// news list Element 带图片
class NewsWithImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSummaryLabel: UILabel!
    @IBOutlet weak var newsAuathorLabel: UILabel!
    @IBOutlet weak var newsPublishTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func estimatedCellHeight() -> Float {
        return 100.0;
    }
    
}

// news list Element 不带图片
class NewsWithoutImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSummaryLabel: UILabel!
    @IBOutlet weak var newsAuathorLabel: UILabel!
    @IBOutlet weak var newsPublishTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func estimatedCellHeight() -> Float {
        return 90.0;
    }
    
}