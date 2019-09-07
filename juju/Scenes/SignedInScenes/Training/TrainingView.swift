//
//  TrainingView.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class TrainingView: UIView {

    // MARK: Views
    
    private let instructions: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = Constants.numberOfLines
        label.text = "Aqui é onde você pratica o exercício de relaxamento e contração do períneo"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let footerButton = TrainingFooterButton()
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension TrainingView: ViewCoding {
    
    func addSubViews() {
        
    }
    
    func setupConstraints() {
       
    }
    
    func configureViews() {
        
    }
}

extension TrainingView: ViewConfiguration {
    
    enum States {
    case initial(TrainingConfiguration)
    case inProgress(TrainingConfiguration, DailyGoal)
    }
    
    func configure(with state: TrainingView.States) {
        
        switch state {
        case .initial(let configuration):
            
            let footerConfig = TrainingFooterButtonConfiguration(title: "Começar",
                                                                 subtitle: "nível \(configuration.level.lowercased())")
            self.footerButton.configure(with: .initial(footerConfig))
            self.footerButton.isHidden = false
            
            self.instructions.isHidden = false
            
        case .inProgress:
            
            self.instructions.isHidden = true
        }
    }
}

extension TrainingView {
    
    struct Constants {
        
        static let numberOfLines = 0
    }
}
