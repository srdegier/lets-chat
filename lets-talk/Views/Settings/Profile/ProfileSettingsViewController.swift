//
//  ProfileViewController.swift
//  lets-talk
//
//  Created by Stefan de Gier on 05/06/2023.
//

import UIKit

class ProfileSettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ageErrorLabel: UILabel!
    
    var saveButton: UIBarButtonItem!
    
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "About You" // change this dynamicly
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        self.navigationItem.rightBarButtonItem = saveButton
        self.saveButton.isEnabled = false
        
        self.nameTextField.delegate = self
        self.ageTextField.delegate = self
        addDoneButtonOnNumpad(textField: self.ageTextField)

    }
    
    @objc private func didTapSaveButton() {
        let errorMessages = self.viewModel.validateFields()
        if errorMessages.isEmpty {
            //self.viewModel.saveProfile()
            self.saveButton.isEnabled = false
            //reset error fields if needed
            self.nameErrorLabel.isHidden = true
            self.ageErrorLabel.isHidden = true
        } else {
            for (fieldName, errorMessage) in errorMessages {
                switch fieldName {
                case "name":
                    nameErrorLabel.isHidden = false
                    nameErrorLabel.text = errorMessage
                case "age":
                    ageErrorLabel.isHidden = false
                    ageErrorLabel.text = errorMessage
                default:
                    break
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.nameTextField, let name = textField.text {
            print(name)
            self.viewModel.profile?.name = name
        } else if textField == self.ageTextField, let ageString = textField.text, let age = Int(ageString) {
            self.viewModel.profile?.age = Int64(age)
        }
        self.saveButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        let keypadToolbar = UIToolbar()
        
        keypadToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: textField, action: #selector(UITextField.resignFirstResponder))
        ]
        
        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar
    }
    
}
