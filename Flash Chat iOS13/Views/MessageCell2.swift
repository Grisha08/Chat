//
//  MessageCell2.swift
//  Flash Chat iOS13
//
//  Created by Grisha Borodavka on 04/01/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell2: UITableViewCell {

    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var messageBubble2: UIView!
    @IBOutlet weak var leftImageView2: UIImageView!
 
    
    @IBOutlet weak var rightImageView2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble2.layer.cornerRadius = messageBubble2.frame.size.height / 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
