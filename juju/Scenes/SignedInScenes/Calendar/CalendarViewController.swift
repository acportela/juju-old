//
//  CalendarViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 15/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    private let calendarView = CalendarView()
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = self.calendarView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureNavigation()
        self.calendarView.configure(with: .build)
        self.calendarView.reload()
    }
    
    private func configureNavigation() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Diário"
        
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
}
