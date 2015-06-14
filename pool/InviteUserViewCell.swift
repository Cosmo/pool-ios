//
//  InviteUserViewCell.swift
//  
//
//  Created by Devran Uenal on 13.06.15.
//
//

import UIKit

class InviteUserViewCell: UITableViewCell {
    var photoImageView: UIImageView
    var titleLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.photoImageView = UIImageView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.photoImageView.backgroundColor = UIColor.orangeColor()
        self.contentView.addSubview(self.photoImageView)
        self.contentView.addSubview(self.titleLabel)
        
        self.photoImageView.layer.cornerRadius = 15.0
        self.photoImageView.clipsToBounds = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.photoImageView.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        self.titleLabel.frame = CGRect(x: 40, y: 0, width: 200, height: 40)
    }

}
