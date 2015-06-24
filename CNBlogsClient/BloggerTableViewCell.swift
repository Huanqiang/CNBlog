//
//  BloggerTableViewCell.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/24.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class BloggerTableViewCell: UITableViewCell {

    @IBOutlet weak var bloggerIconImageView: UIImageView!
    @IBOutlet weak var bloggerNameLabel: UILabel!
    @IBOutlet weak var bloggerArticleCountLabel: UILabel!
    @IBOutlet weak var bloggerUpdateTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
