//
//  EditProfileViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit
import YPImagePicker
import Kingfisher

protocol EditProfileViewProtocol: AnyObject {
    func getUploadImageResult(result: ResultEnum)
    func getUserInfoResult(user: User)
    func getSignOutResult(result: ResultEnum)
}

final class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var picker: YPImagePicker?
    var user: User? = nil
    var avatarImage: UIImage? = nil
    
    var presenter: EditProfilePresenterProtocol?
    lazy var contentView: EditProfileViewLogic = EditProfileView()
    var bioCell: EditCell?
    var profileCell: EditProfileCell?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        delegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
        getUserInfoFromDefaults()
    }
    
    // MARK: - Delegates
    
    private func delegates() {
        contentView.getEditTableView().delegate = self
        contentView.getEditTableView().dataSource = self
    }
    
    // MARK: - Requests
    
    private func uploadAvatarImage(image: UIImage) {
        presenter?.uploadAvatarImage(image: image)
    }
    
    private func signOut() {
        presenter?.singOut()
    }
    
    private func saveUser(user: User) {
        presenter?.saveUser(user: user)
    }
    
    private func getUserInfoFromDefaults() {
        presenter?.getUserInfoFromDefaults()
    }
    
    
    // MARK: - UI Actions
    
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Edit Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func pickAvatarImage() {
        var config = YPImagePickerConfiguration()
        config.showsCrop = .none
        config.screens = [.library, .photo]
        config.startOnScreen = YPPickerScreen.library
        picker = YPImagePicker(configuration: config)
        picker?.imagePickerDelegate = self
        picker?.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.profileCell?.setupPhoto(image: photo.image)
                self.uploadAvatarImage(image: photo.image)
            } else {
                print("no photo error")
            }
            picker?.dismiss(animated: true, completion: nil)
        }
        present(picker!, animated: true, completion: nil)
    }
    
    private func configure() {
        
    }
    
}

// MARK: - EditProfileCellDelegate

extension EditProfileViewController: EditProfileCellDelegate {
    func addImageTapped() {
        pickAvatarImage()
    }
}


// MARK: - EditProfileViewProtocol

extension EditProfileViewController: EditProfileViewProtocol {
    
    func getUploadImageResult(result: ResultEnum) {
        switch result {
        case .success(let url):
            if var user = UserSettings.shared.currentUser {
                user.userAvatar = url as? String ?? ""
                saveUser(user: user)
            }
        case .error:
            print("upload error")
        }
    }
    
    func getSignOutResult(result: ResultEnum) {
        switch result {
        case .success:
            presenter?.navigateToLogin()
        case .error:
            print("sign out ERROR")
        }
    }
    
    func getUserInfoResult(user: User) {
        self.user = user
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        
        case profileCell?.usernameTF:
            if textField.text != "" {
                if var user = UserSettings.shared.currentUser {
                    user.username = textField.text
                    saveUser(user: user)
                }
            }
            textField.resignFirstResponder()
            return false
            
        case bioCell?.bioTF:
            if textField.text != "" {
                if var user = UserSettings.shared.currentUser {
                    user.userBio = textField.text!
                    saveUser(user: user)
                }
            }
            textField.resignFirstResponder()
            return false
            
        default:
            return true
        }
    }
}

// MARK: - Cell Helpers

extension EditProfileViewController {
    private func profileCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        profileCell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.cellID,
                                                    for: indexPath) as? EditProfileCell
        profileCell?.selectionStyle = .none
        profileCell?.usernameTF.delegate = self
        profileCell?.delegate = self
        if let user = user {
            profileCell?.setupData(user: user)
        }
        return profileCell ?? UITableViewCell()
    }
    
    private func bioCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        bioCell = tableView.dequeueReusableCell(withIdentifier: EditCell.cellID,
                                                for: indexPath) as? EditCell
        
        bioCell?.selectionStyle = .none
        bioCell?.bioTF.isHidden = false
        bioCell?.bioTF.delegate = self
        if let user = user {
            bioCell?.setupData(user: user)
        }
        return bioCell ?? UITableViewCell()
    }
    
    private func usernameCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditCell.cellID,
                                                       for: indexPath) as? EditCell else {return UITableViewCell()}
        cell.accessoryType = .disclosureIndicator
        cell.usernameLabel.isHidden = false
        cell.usernameResultLabel.isHidden = false
        if let user = user {
            cell.setupData(user: user)
        }
        return cell
    }
    
    private func changeEmailCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditCell.cellID,
                                                       for: indexPath) as? EditCell else {return UITableViewCell()}
        cell.accessoryType = .disclosureIndicator
        cell.changeEmailLabel.isHidden = false
        cell.changeEmailResultLabel.isHidden = false
        if let user = user {
            cell.setupData(user: user)
        }
        return cell
    }
    
    private func addButtonCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: EditCell.cellID,
                                                             for: indexPath) as? EditCell else {return UITableViewCell()}
        buttonCell.buttonLabel.isHidden = false
        buttonCell.buttonLabel.text = "Add Account"
        buttonCell.buttonLabel.textColor = .systemBlue
        return buttonCell
    }
    
    private func logOutCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: EditCell.cellID,
                                                             for: indexPath) as? EditCell else {return UITableViewCell()}
        buttonCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        buttonCell.buttonLabel.isHidden = false
        buttonCell.buttonLabel.text = "Log Out"
        buttonCell.buttonLabel.textColor = .red
        return buttonCell
    }
}

// MARK: - UITableViewDel|DS

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).section {
        
        case 0:
            return profileCell(tableView: tableView, cellForRowAt: indexPath)
            
        case 1:
            return bioCell(tableView: tableView, cellForRowAt: indexPath)
            
        case 2:
            
            switch (indexPath as NSIndexPath).row {
            case 0:
                return usernameCell(tableView: tableView, cellForRowAt: indexPath)
                
            case 1:
                return changeEmailCell(tableView: tableView, cellForRowAt: indexPath)
                
            default:
                return UITableViewCell()
            }
            
            
        case 3:
            return addButtonCell(tableView: tableView, cellForRowAt: indexPath)
            
        case 4:
            return logOutCell(tableView: tableView, cellForRowAt: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            print("Profile")
            
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("Favorote")
                
            default:
                print("no section")
            }
            
        case 2:
            
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("Notifications and sounds")
                
            case 1:
                print("privacy")
                
            default:
                print("no section")
            }
            
        case 3:
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("add account")
                
            default:
                print("no section")
            }
            
        case 4:
            switch (indexPath as NSIndexPath).row {
            case 0:
                signOut()
                
            default:
                print("no section")
            }
            
        default:
            print("no section")
        }
    }
    
    // Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 60
        case 2:
            return 70
        case 3:
            return 35
        case 4:
            return 70
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath as NSIndexPath).section == 0 ? 138 : 50
    }
}

// MARK: - YPImagePickerDelegate
extension EditProfileViewController: YPImagePickerDelegate {
    func noPhotos() {
        
    }
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
}


