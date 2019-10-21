//
//  CalendarCoordinator.swift
//  juju
//
//  Created by Antonio Rodrigues on 16/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

class CalendarCoordinator: Coordinator {
    
    private let navigation: UINavigationController
    private let diaryService: TrainingDiaryServiceProtocol
    private let user: ClientUser
    
    init(rootNavigation: UINavigationController,
         diaryService: TrainingDiaryServiceProtocol,
         user: ClientUser) {
        
        self.diaryService = diaryService
        self.navigation = rootNavigation
        self.user = user
    }
    
    func start() {
        
        self.configureNavigation()
        self.startCalendar()
    }
    
    private func configureNavigation() {
        
        self.navigation.configureOpaqueStyle()
    }
    
    private func startCalendar() {
        
        let calendarViewController = CalendarViewController(diaryService: self.diaryService,
                                                            user: self.user)
        
        self.navigation.pushViewController(calendarViewController, animated: false)
    }
}
