//
//  AvatarViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 05/06/2023.
//

import UIKit

class BuddySettingsViewController: UIViewController {

    private let viewModel = BuddyViewModel()
    
    var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var avatarMessageView: AvatarMessageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var languageErrorLabel: UILabel!
    var languagePickerView = UIPickerView()
    
    @IBOutlet weak var personalityTextView: UITextField!
    @IBOutlet weak var personalityOptionalTextView: UITextField!
    @IBOutlet weak var personalityErrorLabel: UILabel!
    var personalityPickerView = UIPickerView()
    
    
    @IBOutlet weak var behaviourTextView: UITextField!
    @IBOutlet weak var behaviourOptionalTextView: UITextField!
    @IBOutlet weak var behaviourErrorLabel: UILabel!
    var behaviourPickerView = UIPickerView()
    
    var selectedPersonalityRow: Int?
    var selectedBehaviourRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "About" // change this dynamically
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
        self.saveButton.isEnabled = false
        
        self.avatarMessageView.messageBubbleView.messageType = .receiver;
        self.avatarMessageView.avatarMessageText = ""
        
        self.personalityPickerView.tag = 1
        self.personalityPickerView.delegate = self
        self.personalityPickerView.dataSource = self
        self.personalityTextView.inputView = self.personalityPickerView
        self.personalityOptionalTextView.inputView = self.personalityPickerView
        
        self.languagePickerView.tag = 2
        self.languagePickerView.delegate = self
        self.languagePickerView.dataSource = self
        self.languageTextField.inputView = self.languagePickerView
        
        self.behaviourPickerView.tag = 3
        self.behaviourPickerView.delegate = self
        self.behaviourPickerView.dataSource = self
        self.behaviourTextView.inputView = self.behaviourPickerView
        self.behaviourOptionalTextView.inputView = self.behaviourPickerView
        
        // Register for keyboard and pickerview notifications
        self.registerForKeyboardNotifications()
        self.registerForPickerViewNotifications()
        
        self.updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.avatarMessageView.revealAnimation() {
            self.avatarMessageView.slideAvatarViewAnimation() {
                self.avatarMessageView.revealMessageAnimation()
            }
        }
    }
    
    private func updateView() {
        self.avatarMessageView.avatarMessageText = self.viewModel.introductionMessage
        self.navigationItem.title = "About \(String(describing: self.viewModel.nameText))"
    }
    
    @IBAction func textFieldShouldReturn(_ sender: UITextField) {
        self.saveButton.isEnabled = true
        self.viewModel.name = self.nameTextField.text
        self.updateView()
    }
    
    @objc private func didTapSaveButton() {
        let errorMessages = self.viewModel.validateFields()
        if errorMessages.isEmpty {
            self.viewModel.updateBuddy()
            self.saveButton.isEnabled = false
            //reset error fields if needed
            self.nameErrorLabel.isHidden = true
            self.languageErrorLabel.isHidden = true
            self.personalityErrorLabel.isHidden = true
            self.behaviourErrorLabel.isHidden = true
        } else {
            for (fieldName, errorMessage) in errorMessages {
                switch fieldName {
                case "name":
                    nameErrorLabel.isHidden = false
                    nameErrorLabel.text = errorMessage
                case "language":
                    languageErrorLabel.isHidden = false
                    languageErrorLabel.text = errorMessage
                case "personality":
                    personalityErrorLabel.isHidden = false
                    personalityErrorLabel.text = errorMessage
                case "behaviour":
                    behaviourErrorLabel.isHidden = false
                    behaviourErrorLabel.text = errorMessage
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Keyboard and PickerView Notifications
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func registerForPickerViewNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(pickerViewWillShow(notification:)), name: NSNotification.Name("UIPickerViewWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pickerViewWillHide(notification:)), name: NSNotification.Name("UIPickerViewWillHideNotification"), object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let activeTextField = findActiveTextField() {
            adjustScrollViewContentOffset(for: activeTextField, notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func pickerViewWillShow(notification: NSNotification) {
        if let activeTextField = findActiveTextField() {
            adjustScrollViewContentOffset(for: activeTextField, notification: notification)
        }
    }
    
    @objc func pickerViewWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    // this can be more effiecent
    private func findActiveTextField() -> UITextField? {
        let textFields: [UITextField] = [
            nameTextField,
            languageTextField,
            personalityTextView,
            behaviourTextView,
            personalityOptionalTextView,
            behaviourOptionalTextView
        ]
        
        return textFields.first { $0.isFirstResponder }
    }

    private func adjustScrollViewContentOffset(for textField: UITextField, notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var visibleRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if !visibleRect.contains(textField.frame.origin) {
            let scrollPoint = CGPoint(x: 0.0, y: textField.frame.origin.y - keyboardSize.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
}

// TODO: Do preparing data in the viewmodel lol

extension BuddySettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.viewModel.personalityTypes.count + 1
        case 2:
            return self.viewModel.languageTypes.count
        case 3:
            return self.viewModel.behaviourTypes.count + 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            if row == 0 {
                return ""
            } else {
                return self.viewModel.personalityTypes[row - 1]
            }
        case 2:
            return self.viewModel.languageTypes[row]
        case 3:
            if row == 0 {
                return ""
            } else {
                return self.viewModel.behaviourTypes[row - 1]
            }
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.saveButton.isEnabled = true
        switch pickerView.tag {
        case 1:
            if self.personalityTextView.isFirstResponder {
                self.selectedPersonalityRow = row - 1
                if row == 0 {
                    self.personalityTextView.text = ""
                } else {
                    self.personalityTextView.text = self.viewModel.personalityTypes[row - 1]
                }
                self.viewModel.personality = self.viewModel.personalityTypes[row - 1]
                self.personalityTextView.resignFirstResponder()
            } else if self.personalityOptionalTextView.isFirstResponder {
                self.selectedPersonalityRow = row - 1
                if row == 0 {
                    self.personalityOptionalTextView.text = ""
                } else {
                    self.personalityOptionalTextView.text = self.viewModel.personalityTypes[row - 1]
                }
                self.viewModel.personalityOptional = self.viewModel.personalityTypes[row - 1]
                self.personalityOptionalTextView.resignFirstResponder()
            }
        case 2:
            self.languageTextField.text = self.viewModel.languageTypes[row]
            self.viewModel.language = self.viewModel.languageTypes[row]
            self.languageTextField.resignFirstResponder()
        case 3:
            if self.behaviourTextView.isFirstResponder {
                self.selectedBehaviourRow = row - 1
                if row == 0 {
                    self.behaviourTextView.text = ""
                } else {
                    self.behaviourTextView.text = self.viewModel.behaviourTypes[row - 1]
                }
                self.viewModel.behaviour = self.viewModel.behaviourTypes[row - 1]
                self.behaviourTextView.resignFirstResponder()
            } else if self.behaviourOptionalTextView.isFirstResponder {
                self.selectedBehaviourRow = row - 1
                if row == 0 {
                    self.behaviourOptionalTextView.text = ""
                } else {
                    self.behaviourOptionalTextView.text = self.viewModel.behaviourTypes[row - 1]
                }
                self.viewModel.behaviourOptional = self.viewModel.behaviourTypes[row - 1]
                self.behaviourOptionalTextView.resignFirstResponder()
            }
        default:
            return
        }
        self.updateView()
    }
}
