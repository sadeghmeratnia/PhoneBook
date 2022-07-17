//
//  ContactsLitViewModel.swift
//  PhoneBook
//
//  Created by Sadegh on 7/16/22.
//

import Foundation
import RxSwift
import RxCocoa

class ContactsLitViewModel {
    let model = BehaviorRelay<[ContactModel]>(value: [])
    let bag = DisposeBag()
    
    func getContacts() {
        let agent = NetworkAgent()
        let router = ContactsListAPIRouter()
        
        agent.request(router).subscribe(on: MainScheduler.instance).subscribe(onNext: { model in
            self.model.accept(model ?? [])
        }, onError: { _ in })
        .disposed(by: self.bag)
    }
}
