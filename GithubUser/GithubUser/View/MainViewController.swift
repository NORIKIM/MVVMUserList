//
//  MainViewController.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    lazy var userListVM = { UserListVM() }()
    var isPaging = false // 현재 페이징 중인지
    var isReload = false // 새로운 검색어로 로드 하는 중인지
    
    var searchBar = UISearchBar().then {
        $0.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        $0.setImage(UIImage(), for: .clear, state: .normal)
    }
    var userTB = UITableView().then {
        $0.separatorStyle = .none
        $0.register(UserCell.self, forCellReuseIdentifier: UserCell.id)
    }
    var noResultView = UIImageView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "no_result")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setUI()
        setConstraints()
        
        searchBar.delegate = self
        userTB.delegate = self
        userTB.dataSource = self
        
        initViewModel(keyword: "Q")
    }
    
    func setUI() {
        self.view.addSubview(searchBar)
        self.view.addSubview(userTB)
        self.view.addSubview(noResultView)
        
        noResultView.isHidden = true
//        userListVM.delegate = self
    }
    
    func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(self.view.snp.left)
            $0.right.equalTo(self.view.snp.right)
        }
        
        userTB.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.left.equalTo(self.view.snp.left).offset(20)
            $0.bottom.equalTo(self.view.snp.bottom)
            $0.right.equalTo(self.view.snp.right).offset(-20)
        }
        
        noResultView.snp.makeConstraints {
            $0.top.equalTo(userTB.snp.top)
            $0.leading.equalTo(userTB.snp.leading)
            $0.trailing.equalTo(userTB.snp.trailing)
            $0.bottom.equalTo(userTB.snp.bottom)
        }
        
    }
    
    func initViewModel(keyword: String) {
        userListVM.requestUser(keyword: keyword)
        
        userListVM.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.userTB.reloadData()
                self?.isReload = false
            }
        }
    }
}

// MARK: - ScrollView ---------------------------------------------------------------------------------------------------------------------------------------------------
extension MainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if isPaging == false && isReload == false {
                loadMore()
            }
        }
    }
    
    func loadMore() {
        isPaging = true
        userListVM.requestUser(keyword: nil)
        userListVM.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.isPaging = false
                self?.userTB.reloadData()
                
            }
        }
    }
}

// MARK: - SearchBar ---------------------------------------------------------------------------------------------------------------------------------------------------
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let searchKeyword = searchBar.text ?? ""
        if searchKeyword != "" {
            isReload = true
            initViewModel(keyword: searchKeyword)
        }
    }
}

// MARK: - TableView ---------------------------------------------------------------------------------------------------------------------------------------------------
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userListVM.userCellVMs.count
        }
        if section == 1 && isPaging {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: UserCell.id, for: indexPath) as? UserCell else { return UITableViewCell() }
        let CellVM = userListVM.getCellViewModel(at: indexPath)
        userCell.userCellVM = CellVM
        
        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let user = userListVM.userCellVMs
        let url = user[index].url
        
        if let githubURL = URL(string: url), UIApplication.shared.canOpenURL(githubURL) {
            UIApplication.shared.open(githubURL)
        }
    }
}
