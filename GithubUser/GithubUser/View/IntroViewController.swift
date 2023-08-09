//
//  IntroViewController.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/06.
//

import UIKit
import SnapKit
import Then

class IntroViewController: UIViewController {    
    let titleLB = UILabel().then {
        $0.text = "iOS 개발 부문_지원자 김지나"
        $0.textAlignment = .center
    }
    let signInBTN = UIButton().then {
        $0.setTitle("Sign In", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setUI()
        setConstraints()
    }

    func setUI() {
        self.view.addSubview(titleLB)
        self.view.addSubview(signInBTN)
    }
    
    func setConstraints() {
        titleLB.snp.makeConstraints {
            $0.width.equalTo(self.view)
            $0.height.equalTo(70)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        signInBTN.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(70)
            $0.top.equalTo(titleLB.snp.bottom)
            $0.centerX.equalTo(titleLB.snp.centerX)
        }
    }
    
    @objc func signIn(_ sender: UIButton) {
        OAuthVM.shared.connnectGithub()
    }
}
