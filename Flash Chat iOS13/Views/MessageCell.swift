//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Sergey on 2/20/23.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var MessageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MessageBubble.layer.cornerRadius = MessageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
