//
//  UserListCell.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import UIKit
import Then
import SnapKit

class UserListCell: UITableViewCell {

    var photoImg = UIImageView().then {_ in
        
    }
    var nameLB = UILabel().then {_ in
        
    }
    var urlLB = UILabel().then {_ in
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
