//
//  ViewController.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    var searchBar = UISearchBar().then {_ in
        
    }
    var userList = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
//        $0.register(MyCell.self, forCellReuseIdentifier: "myCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUI()
        setConstraints()
        
        searchBar.delegate = self
        userList.delegate = self
        userList.dataSource = self
    }

    func setUI() {
        self.view.addSubview(searchBar)
        self.view.addSubview(userList)
    }
    
    func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top).offset(0)
            $0.left.equalTo(self.view.snp.left).offset(0)
            $0.right.equalTo(self.view.snp.right).offset(0)
        }
        
        userList.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.left.equalTo(self.view.snp.left).offset(20)
            $0.right.equalTo(self.view.snp.right).offset(20)
        }
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
