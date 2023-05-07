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
    
    var viewModel = DashboardViewModel(dashboardComponentTypes: [.chat, .solutions])
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Let's Talk"
        self.navigationItem.backButtonTitle = "Back"
        
        self.dashboardCollectionView.delegate = self
        self.dashboardCollectionView.dataSource = self
        
        self.avatarMessageView.messageBubbleView.messageType = .receiver
        self.avatarMessageView.avatarMessageText = self.viewModel.avatarMessage

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.avatarMessageView.startAnimation()
    }

}

// MARK: - Table View Data Source

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dashboardCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NavigationCollectionViewCell
        cell?.navigationTitleLabel.text = viewModel.titleForIndexPath(indexPath)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dashboardComponentType = viewModel.messageComponentTypeForIndexPath(indexPath)
        var vc: UIViewController?
        
        switch dashboardComponentType {
        case .chat:
            vc = ViewControllerFactory.chatViewController()
        case .solutions:
            vc = ViewControllerFactory.solutionsViewController()
        case .none:
            print("none, throw error")
        }
        guard let vc = vc else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
