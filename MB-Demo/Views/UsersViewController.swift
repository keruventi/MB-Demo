//
//  UsersViewController.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import UIKit

class UsersViewController: UIViewController {
    private var viewModel = UsersViewModel()
    private var tableView: UITableView!
    private var isLoadingMoreItems = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationStyle()
        setupTableView()
        setupBindings()
        viewModel.fetchUsers()
    }
    
    private func setupNavigationStyle() {
        navigationItem.title = "Github Users"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear        
        tableView.contentInsetAdjustmentBehavior = .always
        view.addSubview(tableView)
    }
    
    private func setupBindings() {
        viewModel.onUsersFetched = { [weak self] in
            self?.isLoadingMoreItems = false
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { error in
            self.isLoadingMoreItems = false
            DispatchQueue.main.async {
                self.showError(error)
            }
        }
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .destructive, handler: { action in
            self.viewModel.fetchUsers()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user)
        
        viewModel.fetchImage(from:  user.avatarUrl) { image in
            DispatchQueue.main.async {
                cell.avatarImageView.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]       
        let userDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        userDetailVC.userId = user.userId
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
}

extension UsersViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if  !isLoadingMoreItems,
            let lastItemId = viewModel.users.last?.id,
            indexPaths.contains(where: { $0.row >= viewModel.users.count - 1 }) {
            self.isLoadingMoreItems = true
            viewModel.fetchUsers(from: lastItemId)
        }
    }
}
