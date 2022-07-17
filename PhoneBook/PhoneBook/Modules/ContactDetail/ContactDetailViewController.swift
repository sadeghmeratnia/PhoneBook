//
//  ContactDetailViewController.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import UIKit
import RxSwift
import RxCocoa

class ContactDetailViewController: BaseViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var contactNameLabel: UILabel!
    @IBOutlet private weak var contactNameTextField: UITextField!
    @IBOutlet private weak var contactLastNameLabel: UILabel!
    @IBOutlet private weak var contactLastNameTextField: UITextField!
    @IBOutlet private weak var contactPhoneLabel: UILabel!
    @IBOutlet private weak var contactPhoneTextField: UITextField!
    @IBOutlet private weak var contactEmailLabel: UILabel!
    @IBOutlet private weak var contactEmailTextField: UITextField!
    @IBOutlet private weak var contactNoteLabel: UILabel!
    @IBOutlet private weak var contactNoteTextField: UITextView!
    
    private var viewModel: ContactDetailViewModel = ContactDetailViewModel()
    private lazy var disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBindings()
        self.setupView()
    }
    
    private func setupBindings() {
        self.contactNameTextField.rx.text.orEmpty.bind(to: self.viewModel.firstName).disposed(by: self.disposebag)
        self.contactLastNameTextField.rx.text.orEmpty.bind(to: self.viewModel.lastName).disposed(by: self.disposebag)
        self.contactPhoneTextField.rx.text.orEmpty.bind(to: self.viewModel.phone).disposed(by: self.disposebag)
        self.contactEmailTextField.rx.text.orEmpty.bind(to: self.viewModel.email).disposed(by: self.disposebag)
        self.contactNoteTextField.rx.text.orEmpty.bind(to: self.viewModel.notes).disposed(by: self.disposebag)
        self.addPhotoButton.rx.tap.subscribe(on: MainScheduler.instance).subscribe(onNext: {
            self.onAddPhotoTap()
        })
        .disposed(by: self.disposebag)
        
        self.viewModel.isInEditingMode.bind(to: self.contactNameTextField.rx.isUserInteractionEnabled).disposed(by: self.disposebag)
        self.viewModel.isInEditingMode.bind(to: self.contactLastNameTextField.rx.isUserInteractionEnabled).disposed(by: self.disposebag)
        self.viewModel.isInEditingMode.bind(to: self.contactPhoneTextField.rx.isUserInteractionEnabled).disposed(by: self.disposebag)
        self.viewModel.isInEditingMode.bind(to: self.contactEmailTextField.rx.isUserInteractionEnabled).disposed(by: self.disposebag)
        self.viewModel.isInEditingMode.bind(to: self.contactNoteTextField.rx.isUserInteractionEnabled).disposed(by: self.disposebag)
    }
    
    private func setupView() {
        self.contactNameLabel.font = UIFont.sansMedium(16)
        self.contactLastNameLabel.font = UIFont.sansMedium(16)
        self.contactPhoneLabel.font = UIFont.sansMedium(16)
        self.contactEmailLabel.font = UIFont.sansMedium(16)
        self.contactNoteLabel.font = UIFont.sansMedium(16)
        self.addPhotoButton.titleLabel?.font = UIFont.sansMedium(16)
        self.imageView.layer.cornerRadius = (self.imageView.frame.width / 2)
        
        self.contactNameLabel.text = "contact.name".localize
        self.contactLastNameLabel.text = "contact.lastname".localize
        self.contactPhoneLabel.text = "contact.phone".localize
        self.contactEmailLabel.text = "contact.email".localize
        self.contactNoteLabel.text = "contact.note".localize
        
        let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        self.imageView.image = placeholder ?? UIImage()
        
        self.contactNoteTextField.layer.cornerRadius = 12
        self.setupModelUpdatingMode()
    }
    
    private func setupModelUpdatingMode() {
        guard
            let coordinator = self.coordinator as? ContactDetailCoordinator,
            let contact = coordinator.contact
        else {
            self.setupViewAddingMode()
            return
        }
    
        self.viewModel.setupDataModel(contact: contact)
        
        let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        self.imageView.setImage(url: self.viewModel.image.value ?? "", placeholder: placeholder ?? UIImage())
        self.contactNameTextField.text = self.viewModel.firstName.value
        self.contactLastNameTextField.text = self.viewModel.lastName.value
        self.contactPhoneTextField.text = self.viewModel.phone.value
        self.contactEmailTextField.text = self.viewModel.email.value
        self.contactNoteTextField.text = self.viewModel.notes.value
        
        self.updateTextField(false)
        self.setupNavBarInEditingMode()
    }
    
    private func setupViewAddingMode() {
        self.viewModel.isInEditingMode.accept(true)
        self.navigationItem.title = "contact.add".localize
        
        let button = UIButton()
        button.setTitle("contact.add".localize, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        self.viewModel.isContactValid.subscribe(onNext: { isEnabled in
            button.setTitleColor(isEnabled ? .systemBlue: .gray, for: .normal)
            button.isEnabled = isEnabled
        })
        .disposed(by: self.disposebag)
        
        button.rx.tap.subscribe(onNext: {
            self.viewModel.addNewContact(onSuccess: { self.popToParent($0) })
        })
        .disposed(by: self.disposebag)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func setupNavBarInEditingMode() {
        self.navigationItem.title = self.viewModel.firstName.value
        
        let editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 28))
        self.setupEditButton(button: editButton)
        let editBarButton = UIBarButtonItem(customView: editButton)
        
        let deletButton = UIButton()
        self.setupDeleteButton(button: deletButton)
        let deleteBarButton = UIBarButtonItem(customView: deletButton)
        
        self.navigationItem.setRightBarButtonItems([editBarButton, deleteBarButton], animated: true)
    }
    
    private func setupEditButton(button: UIButton) {
        button.setTitle("contact.edit".localize, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        self.viewModel.isContactValid.subscribe(onNext: { isEnabled in
            button.setTitleColor(isEnabled ? .systemBlue: .gray, for: .normal)
            button.isEnabled = isEnabled
        })
        .disposed(by: self.disposebag)
        
        button.rx.tap.subscribe(on: MainScheduler.instance).subscribe(onNext: {
            if self.viewModel.isInEditingMode.value {
                self.viewModel.updateContact(onSuccess: { self.popToParent($0) })
            } else {
                self.onEditButtonTap()
            }
        })
        .disposed(by: self.disposebag)
    }
    
    private func setupDeleteButton(button: UIButton) {
        button.setTitle("contact.delete".localize, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.rx.tap.subscribe(on: MainScheduler.instance).subscribe(onNext: {
            self.viewModel.deleteContact(onSuccess: { contactID in
                (self.coordinator as? ContactDetailCoordinator)?.popToRootView(contactID)
            })
        })
        .disposed(by: self.disposebag)
    }
    
    private func onEditButtonTap() {
        self.viewModel.isInEditingMode.accept(!self.viewModel.isInEditingMode.value)
        self.updateTextField(true)
        
        let item = self.navigationItem.rightBarButtonItem
        if let button = item?.customView as? UIButton {
            button.setTitle("contact.save".localize, for: .normal)
        }
    }
    
    private func popToParent(_ contact: ContactModel) {
        (self.coordinator as? ContactDetailCoordinator)?.coordinateToContactList(contact)
    }
    
    private func updateTextField(_ isUserInteractionAvailable: Bool) {
        self.contactNameTextField.backgroundColor = isUserInteractionAvailable ? .white: .lightGray.withAlphaComponent(0.3)
        self.contactLastNameTextField.backgroundColor = isUserInteractionAvailable ? .white: .lightGray.withAlphaComponent(0.3)
        self.contactPhoneTextField.backgroundColor = isUserInteractionAvailable ? .white: .lightGray.withAlphaComponent(0.3)
        self.contactEmailTextField.backgroundColor = isUserInteractionAvailable ? .white: .lightGray.withAlphaComponent(0.3)
        self.contactNoteTextField.backgroundColor = isUserInteractionAvailable ? .white: .lightGray.withAlphaComponent(0.3)
    }
    
    private func onAddPhotoTap() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ContactDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        let imageData: Data? = image.jpegData(compressionQuality: 0.5)
        let base64 = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        print(base64)
    
        self.imageView.image = image
        self.viewModel.image.accept(base64)
        
        dismiss(animated:true, completion: nil)
    }
}
