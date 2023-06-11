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
    
    var selectedPersonalityRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "About" // change this dynamically
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
        self.saveButton.isEnabled = false
        
        self.avatarMessageView.messageBubbleView.messageType = .receiver;
        self.avatarMessageView.avatarMessageText = ""
        
        self.languagePickerView.tag = 1
        self.languagePickerView.delegate = self
        self.languagePickerView.dataSource = self
        self.languageTextField.inputView = self.languagePickerView
        
        self.personalityPickerView.tag = 2
        self.personalityPickerView.delegate = self
        self.personalityPickerView.dataSource = self
        self.personalityTextView.inputView = self.personalityPickerView
        self.personalityOptionalTextView.inputView = self.personalityPickerView
                
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
    
    //MARK: Update View Method
        
    private func updateView() {
        self.avatarMessageView.avatarMessageText = self.viewModel.introductionMessage
        self.navigationItem.title = "About \(String(describing: self.viewModel.nameText))"
        self.nameTextField.text = self.viewModel.buddy?.name
        //TODO: Make proper computed property for getting rawvalue and capitalizedSentence
        self.languageTextField.text = self.viewModel.buddy?.language.rawValue.capitalizedSentence
        self.personalityTextView.text = self.viewModel.buddy?.personality.rawValue.capitalizedSentence
        self.personalityOptionalTextView.text = self.viewModel.buddy?.personalityOptional?.rawValue.capitalizedSentence
    }
    
    
    //MARK: Methods
    
    @IBAction func textFieldShouldReturn(_ sender: UITextField) {
        self.saveButton.isEnabled = true
        self.viewModel.buddy?.name = self.nameTextField.text!
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
            personalityOptionalTextView,
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
            return LanguageType.allValues.count
        case 2:
            return PersonalityType.allValues.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return LanguageType.allValues[row].rawValue.capitalizedSentence
        case 2:
            return PersonalityType.allValues[row].rawValue.capitalizedSentence
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.saveButton.isEnabled = true
        switch pickerView.tag {
        case 1:
            self.languageTextField.text = LanguageType.allValues[row].rawValue.capitalizedSentence
            self.viewModel.buddy?.language = LanguageType.allValues[row]
            self.languageTextField.resignFirstResponder()
            
        case 2:
            if self.personalityTextView.isFirstResponder {
                self.selectedPersonalityRow = row
                self.personalityTextView.text = PersonalityType.allValues[row].rawValue.capitalizedSentence
                self.viewModel.buddy?.personality = PersonalityType.allValues[row]
                self.personalityTextView.resignFirstResponder()
            } else if self.personalityOptionalTextView.isFirstResponder {
                self.selectedPersonalityRow = row
                self.personalityOptionalTextView.text = PersonalityType.allValues[row].rawValue.capitalizedSentence
                self.viewModel.buddy?.personalityOptional = PersonalityType.allValues[row]
                self.personalityOptionalTextView.resignFirstResponder()
            }
        default:
            return
        }
        self.updateView()
    }
}
