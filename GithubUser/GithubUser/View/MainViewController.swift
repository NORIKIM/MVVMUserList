//
//  MainViewController.swift
//  GithubUser
//
//  Created by 김지나 on 2023/08/05.
//

import UIKit
import SnapKit
import Then

fileprivate enum PagingState {
    case normal
    case paging
}

class MainViewController: UIViewController {
    lazy var userListVM = { UserListVM() }()
    private var pagingState: PagingState = .paging
    
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
    var indicator = UIActivityIndicatorView().then {
        $0.color = .orange
        $0.hidesWhenStopped = true
        $0.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setUI()
        setConstraints()
        
        searchBar.delegate = self
        
        reload(keyword: "q")
    }
    
    func setUI() {
        self.view.addSubview(searchBar)
        self.view.addSubview(userTB)
        self.view.addSubview(noResultView)
        self.view.addSubview(indicator)
        
        noResultView.isHidden = true
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
        
        indicator.snp.makeConstraints {
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.centerY.equalTo(self.view.snp.centerY)
        }
    }
    
    func reload(keyword: String) {
        indicator.startAnimating()
        
        userListVM.requestUser(keyword: keyword) { isSuccess in
            DispatchQueue.main.async {
                if isSuccess != nil && isSuccess == true {
                    self.noResultView.isHidden = true
                    self.userTB.delegate = self
                    self.userTB.dataSource = self
                    self.userTB.reloadData()
                    self.indicator.stopAnimating()
                } else {
                    self.noResultView.isHidden = false
                    self.indicator.stopAnimating()
                }
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
            if pagingState == .paging {
                loadMore()
            }
        }
    }
    
    func loadMore() {
        let isLastPage = userListVM.isLastPage()
        
        if !isLastPage {
            let userCount = userListVM.getUsers().count
            pagingState = .normal
            indicator.startAnimating()
            
            userListVM.requestReloadUser {isSuccess in
                if isSuccess != nil {
                    self.pagingState = .paging
                    var indexPaths = [IndexPath]()
                    
                    for row in userCount ... userCount + 29 {
                        let indexPath = IndexPath(row: row, section: 0)
                        indexPaths.append(indexPath)
                    }
                    
                    DispatchQueue.main.async {
                        self.userTB.beginUpdates()
                        self.userTB.insertRows(at: indexPaths, with: .automatic)
                        self.userTB.endUpdates()
                        self.indicator.stopAnimating()
                    }
                    
                }
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
            reload(keyword: searchKeyword)
        }
    }
}

// MARK: - TableView ---------------------------------------------------------------------------------------------------------------------------------------------------
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
            let users = userListVM.getUsers()
            return users.count
//        }
//        if section == 1 && pagingState == .paging {
//            return 1
//        }
//
//        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let section = indexPath.section
        
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: UserCell.id, for: indexPath) as? UserCell else { return UITableViewCell() }
        let users = userListVM.getUsers()
        let CellVM = userListVM.getUser(at: indexPath)
        userCell.userCellVM = CellVM
        
        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let users = userListVM.getUsers()
        let url = users[index].url
        
        if let githubURL = URL(string: url), UIApplication.shared.canOpenURL(githubURL) {
            UIApplication.shared.open(githubURL)
        }
    }
}
