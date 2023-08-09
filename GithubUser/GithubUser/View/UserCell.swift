//
//  UserCell.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import UIKit
import Then
import SnapKit

class UserCell: UITableViewCell {
    static let id = "UserCell"
    var userCellVM: UserCellVM? {
        didSet {
            avatarImgView.image = userCellVM?.avatarImg
            loginLB.text = userCellVM?.login
            urlLB.text = userCellVM?.url
        }
    }
    var avatarImgView = UIImageView().then {_ in}
    var loginLB = UILabel().then {
        $0.textColor = .black
    }
    var urlLB = UILabel().then {
        $0.textColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError(ErrorMessage.userCellInitializeFail)
    }

    func setUI() {
        // cell
        backgroundColor = .white
        
        // avatarImgView
        let height = self.contentView.frame.height
        let size = height - 4
        avatarImgView.layer.cornerRadius = size / 2
        avatarImgView.clipsToBounds = true
        self.addSubview(avatarImgView)
        
        // loginLB
        self.addSubview(loginLB)
        
        // urlLB
        self.addSubview(urlLB)
    }
    
    func setConstraints() {
        let height = self.contentView.frame.height
        let size = height - 4
        
        avatarImgView.snp.makeConstraints {
            $0.width.equalTo(size)
            $0.height.equalTo(size)
            $0.leading.equalTo(self.snp.leading).offset(4)
            $0.centerY.equalTo(self.snp.centerY)
        }
        
        loginLB.snp.makeConstraints {
            $0.top.equalTo(avatarImgView.snp.top)
            $0.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(size / 2)
        }
        
        urlLB.snp.makeConstraints {
            $0.top.equalTo(loginLB.snp.bottom)
            $0.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(size / 2)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImgView.image = nil
        loginLB.text = nil
        urlLB.text = nil
    }

}
