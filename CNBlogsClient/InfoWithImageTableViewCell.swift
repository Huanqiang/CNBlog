//
//  InfoWithImageTableViewCell.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/13.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class InfoWithImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoSummaryLabel: UILabel!
    @IBOutlet weak var infoAuathorLabel: UILabel!
    @IBOutlet weak var infoPublishTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoImageView.layer.masksToBounds = true
        infoImageView.layer.cornerRadius = 10
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
