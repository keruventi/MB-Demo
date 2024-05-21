//
//  UserDetailViewController.swift
//  MB-Demo
//
//  Created by Karnakar Eruventi on 5/19/24.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var errorStackView: UIStackView!
    @IBOutlet weak var profileStackView: UIStackView!
    
    private var viewModel = UserDetailViewModel()
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        if let userId {
            viewModel.fetchUserDetail(for: userId)
        }
    }
    
    private func setupUI() {
        errorStackView.isHidden = true
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.borderWidth = 1.0
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.cornerRadius = 75
        avatarImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOpacity = 0.4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 6
        cardView.backgroundColor = .white
        
        nameLabel.text = ""
        bioLabel.text = ""
    }
    
    private func setupBindings() {
        viewModel.onUserDetailFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.profileStackView.isHidden = true
                self?.cardView.isHidden = true
                self?.errorStackView.isHidden = false
            }
        }
    }
    
    private func updateUI() {
        guard let userDetail = viewModel.userDetail else { return }
        
        loadAvatarImage(from: userDetail.avatarUrl)
        nameLabel.text = userDetail.name
        bioLabel.text = userDetail.bioText
        userNameLabel.text = userDetail.userName
        locationLabel.text = userDetail.location
        followersLabel.text = userDetail.followersCount
        statusLabel.text = userDetail.lastActiveAt
    }
    
    private func loadAvatarImage(from url: String) {
        viewModel.fetchImage(from: url) { image in
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
}

