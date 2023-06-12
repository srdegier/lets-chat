//
//  ChatSettingsViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 05/06/2023.
//

import UIKit

class HistorySettingsViewController: UIViewController {
    
    let viewModel = HistoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat History" // change this dynamicly
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        let alert = UIAlertController(title: "Deleting chat history",
                                      message: "Are you sure you want to delete your chat history?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { _ in self.deleteChat() }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { _ in print("Cancel tap") }))
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteChat() {
        self.viewModel.deleteChat()
        let alert = UIAlertController(title: "Success",
                                      message: "Your chat history has been deleted",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
}
