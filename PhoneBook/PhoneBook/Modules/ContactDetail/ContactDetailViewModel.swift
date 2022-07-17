//
//  ContactDetailViewModel.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import Foundation
import RxSwift
import RxCocoa

class ContactDetailViewModel {
    var image: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var firstName: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var lastName: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var phone: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var email: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var notes: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    var isInEditingMode: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isContactValid: Observable<Bool> {
        Observable.combineLatest(self.firstName, self.lastName, self.phone, self.email, self.notes, self.isInEditingMode) { name, lastname, phone, email, notes, isInEditingMode in
            guard isInEditingMode else { return true }
            
            return(
                (name != nil && !(name?.isEmpty ?? false)) &&
                (phone != nil && !(phone?.isEmpty ?? false)) &&
                (email != nil && !(email?.isEmpty ?? false)) &&
                (notes != nil && !(notes?.isEmpty ?? false))
            )
        }
    }
    
    private lazy var bag = DisposeBag()
    private var contactID: String?

    
    func setupDataModel(contact: ContactModel) {
        self.firstName.accept(contact.firstName)
        self.lastName.accept(contact.lastName)
        self.phone.accept(contact.phone)
        self.email.accept(contact.email)
        self.notes.accept(contact.notes)
        self.contactID = contact._id
    }
    
    func updateContact(onSuccess: @escaping ((ContactModel)->())) {
        guard let contactID = contactID else { return }

        let contact = ContactModel(_id: contactID,
                                   firstName: self.firstName.value,
                                   lastName: self.lastName.value,
                                   phone: self.phone.value,
                                   email: self.email.value,
                                   notes: self.notes.value,
                                   images: [self.image.value])
        
        let agent = NetworkAgent()
        let router = UpdateContactAPIRouter(requestBody: contact)
        UpdateContactAPIRouter.path = "contacts/\(contactID)"
        
        agent.request(router).subscribe(on: MainScheduler.instance).subscribe(onNext: { model in
            guard let contact = model else { return }
            onSuccess(contact)
            
        }, onError: { error in
            print(error)
        })
        .disposed(by: self.bag)
    }
    
    func addNewContact(onSuccess: @escaping ((ContactModel)->())) {
        let contact = ContactModel(_id: contactID,
                                   firstName: self.firstName.value,
                                   lastName: self.lastName.value,
                                   phone: self.phone.value,
                                   email: self.email.value,
                                   notes: self.notes.value,
                                   images: [self.image.value])
        
        let agent = NetworkAgent()
        let router = AddContactAPIRouter(requestBody: contact)
        
        agent.request(router).subscribe(on: MainScheduler.instance).subscribe(onNext: { model in
            guard let contact = model else { return }
            onSuccess(contact)
            
        }, onError: { error in
            print(error)
        })
        .disposed(by: self.bag)
    }
    
    func deleteContact(onSuccess: @escaping (String)->()) {
        guard let contactID = contactID else { return }

        let agent = NetworkAgent()
        let router = DeleteContactAPIRouter()
        DeleteContactAPIRouter.path = "contacts/\(contactID)"
        
        agent.request(router).subscribe(on: MainScheduler.instance).subscribe(onNext: { model in
            onSuccess(model?.result?.first ?? "")
        }, onError: { error in
            print(error)
        })
        .disposed(by: self.bag)
    }
}
