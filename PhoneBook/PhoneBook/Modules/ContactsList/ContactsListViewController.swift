//
//  ContactsListViewController.swift
//  PhoneBook
//
//  Created by Sadegh on 7/15/22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class ContactsListViewController: BaseViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    var viewModel: ContactsLitViewModel = ContactsLitViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var cellNibName = "ContactsListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupBindings()
        self.viewModel.getContacts()
        self.setupNavBar()
        self.tableView.register(UINib(nibName: self.cellNibName, bundle: nil), forCellReuseIdentifier: self.cellNibName)
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "contacts".localize
        
        let button = UIButton()
        button.setTitle("contact.add".localize, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.rx.tap.subscribe(onNext: {
            self.onAddButtontap()
        })
        .disposed(by: self.disposeBag)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func setupBindings() {
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        self.viewModel.model.bind(to: self.tableView.rx.items) { [weak self] (_, row, item) -> UITableViewCell in
            guard
                let self = self,
                let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellNibName) as? ContactsListCell
            else { return UITableViewCell() }
            
            cell.setupView(contact: item)
            cell.accessoryType = .detailButton
            
            return cell
        }
        .disposed(by: self.disposeBag)
    }
    
    private func onAddButtontap() {
        (self.coordinator as? ContactsListCoordinator)?.coordinateToDetail()
    }
}

extension ContactsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        (self.coordinator as? ContactsListCoordinator)?.coordinateToDetail(contact: self.viewModel.model.value[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
