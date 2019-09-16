//
//  TrainLevelComponent.swift
//  juju
//
//  Created by Antonio Portela on 15/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class TrainLevelComponent: UIView {
    
    // MARK: Views
    private let levelImage: UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let levelLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Gilroy.regular(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    let contentStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twelve
        return stack
    }()
    
    // MARK: Properties
    let level: TrainingLevel
    
    var selected = false {
        didSet {
            self.handleState(selected: self.selected)
        }
    }
    
    // MARK: Lifecycle
    init(level: TrainingLevel, frame: CGRect = .zero) {
        
        self.level = level
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension TrainLevelComponent: ViewCoding {
    
    func addSubViews() {
        
        self.contentStack.addArrangedSubview(self.levelImage)
        self.contentStack.addArrangedSubview(self.levelLabel)
        self.addSubview(contentStack)
    }
    
    func setupConstraints() {
        
        self.contentStack.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
        
        self.levelImage.snp.makeConstraints { make in
            
            make.width.equalTo(Constants.imageWidth)
            make.height.equalTo(Constants.imageHeight)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.white
        self.levelLabel.text = self.level.title.uppercasedFirst
        
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
        self.addGestureRecognizer(tapGesture)
        
        self.setImage()
        self.setShadow()
    }
}

extension TrainLevelComponent {
    
    private func setImage() {
        
        switch self.level {
            
        case .easy:
            
            self.levelImage.image = Resources.Images.easyLevelIcon
            
        case .medium:
            
            self.levelImage.image = Resources.Images.mediumLevelIcon
            
        case .hard:
            
            self.levelImage.image = Resources.Images.hardLevelIcon
        }
    }
    
    private func setShadow() {
        
        self.layer.shadowColor = Styling.Colors.charcoalGrey.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
    }
}

extension TrainLevelComponent {

    @objc
    private func viewWasTapped() {
        
        self.selected.toggle()
    }
    
    private func handleState(selected: Bool) {
        
        self.backgroundColor = selected ? Styling.Colors.charcoalGrey.withAlphaComponent(0.5)
                                        : Styling.Colors.white
    }
}

extension TrainLevelComponent {
    
    struct Constants {
        
        static let imageWidth: Float = 55.9
        static let imageHeight: Float = 40.5
        static let cornerRadius: CGFloat = 6.0
    }
}
