//
//  DashboardController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 19/04/2023.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var avatarMessageView: AvatarMessageView!
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var viewModel = DashboardViewModel()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Let's Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backButtonTitle = "Back"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingsButton))

        self.dashboardCollectionView.delegate = self
        self.dashboardCollectionView.dataSource = self
        
        self.avatarMessageView.messageBubbleView.messageType = .receiver
        self.avatarMessageView.avatarMessageText = self.viewModel.avatarMessage

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.avatarMessageView.revealAnimation() {
            self.avatarMessageView.slideAvatarViewAnimation() {
                self.avatarMessageView.revealMessageAnimation()
            }
        }
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        SQLiteDatabaseManager.shared.deleteDatabase()
    }
    
    @objc func didTapSettingsButton() {
        guard let vc = ViewControllerFactory.settingsViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - Table View Data Source

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dashboardCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NavigationCollectionViewCell
        cell?.navigationTitleLabel.text = viewModel.dashboardComponentOptionForIndexPath(indexPath)?.title
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dashboardComponentOption = viewModel.dashboardComponentOptionForIndexPath(indexPath),
              let viewController = dashboardComponentOption.viewControllerType.viewController
        else {
            print("No valid ViewController")
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
