//
//  SettingsViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 03/06/2023.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView! {
        didSet {
            self.settingsTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingOption")
        }
    }
    
    private var viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        
        self.navigationItem.title = "Settings"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // if there are any updates for the "About buddy"
        self.viewModel.getBuddyName()
        self.settingsTableView.reloadData()
    }
        
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.viewModel.titleForHeaderSection(section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingOption", for: indexPath) as? SettingTableViewCell else {
            fatalError("Unable to dequeue SettingTableViewCell")
        }

        guard let settingOption = self.viewModel.settingOptionForIndexPath(indexPath) else {
            fatalError("Unable to get setting option for index path")
        }

        let title = settingOption.title
        let icon = settingOption.icon
        let iconBackgroundColor = settingOption.iconBackgroundColor

        cell.configure(with: title, icon: icon, iconBackgroundColor: iconBackgroundColor)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dashboardComponentOption = self.viewModel.settingOptionForIndexPath(indexPath),
              let viewController = dashboardComponentOption.viewControllerType.viewController
        else {
            print("No valid ViewController")
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
