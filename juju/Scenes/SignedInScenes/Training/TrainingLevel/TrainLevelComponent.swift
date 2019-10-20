//
//  TrainLevelComponent.swift
//  juju
//
//  Created by Antonio Portela on 15/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainLevelComponentSelectionDelegate: AnyObject {
    
    func shouldSelectComponent(_ component: TrainLevelComponent) -> Bool
    func shouldDeselectComponent(_ component: TrainLevelComponent) -> Bool
    func trainLevelComponentWasSelected(_ component: TrainLevelComponent)
    func trainLevelComponentWasUnselected(_ component: TrainLevelComponent)
}

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
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let contentStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twelve
        return stack
    }()
    
    // MARK: Properties
    private (set) var level: TrainingLevel
    weak var delegate: TrainLevelComponentSelectionDelegate?
    
    private (set) var isSelected = false {
        
        didSet {
            
            self.handleState()
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
        
        self.levelLabel.setContentHuggingPriority(.required, for: .vertical)
        self.backgroundColor = Styling.Colors.white
        self.levelLabel.text = self.level.title.capitalized
        
        self.layer.cornerRadius = Constants.cornerRadius
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
        self.addGestureRecognizer(tapGesture)
        
        self.handleState()
    }
}

extension TrainLevelComponent {
    
    private func handleState() {
        
        self.setImageForSelected(self.isSelected)
        self.setShadowForSelected(self.isSelected)
        self.setLabelColor(self.isSelected)
        
        self.backgroundColor = isSelected ? Styling.Colors.white
                                          : Styling.Colors.rosyPink
    }
    
    private func setImageForSelected(_ selected: Bool) {
        
        switch self.level {
            
        case .easy:
            
            self.levelImage.image = selected ? Resources.Images.easyLevelIconSelected
                                             : Resources.Images.easyLevelIconUnselected
            
        case .medium:
            
            self.levelImage.image = selected ? Resources.Images.mediumLevelIconSelected
                                             : Resources.Images.mediumLevelIconUnselected
            
        case .hard:
            
            self.levelImage.image = selected ? Resources.Images.hardLevelIconSelected
                                             : Resources.Images.hardLevelIconUnselected
        }
    }
    
    private func setShadowForSelected(_ selected: Bool) {
        
        if selected {
            
            self.addShadow(color: Styling.Colors.duskyPink,
                           opacity: 1,
                           radius: 10,
                           offset: CGSize(width: 0, height: 4))
            
        } else {
            
            self.addShadow(color: .clear,
                           opacity: 0,
                           radius: 0,
                           offset: .zero)
        }
    }
    
    private func setLabelColor(_ selected: Bool) {
        
        self.levelLabel.textColor = selected ? Styling.Colors.charcoalGrey : Styling.Colors.white
    }
}

extension TrainLevelComponent {

    @objc
    private func viewWasTapped() {
        
        self.handleTap()
    }
    
    private func handleTap() {
        
        guard let delegate = self.delegate else { return }
        
        if self.isSelected, delegate.shouldDeselectComponent(self) {
            
            self.isSelected.toggle()
            delegate.trainLevelComponentWasUnselected(self)
            return
        }
        
        if self.isSelected == false, delegate.shouldSelectComponent(self) {
            
            self.isSelected.toggle()
            delegate.trainLevelComponentWasSelected(self)
            return
        }
    }
}

extension TrainLevelComponent: ViewConfiguration {
    
    enum States {
        
        case selected
        case unselected
    }
    
    func configure(with state: TrainLevelComponent.States) {
        
        switch state {
            
        case .selected:
            
            self.isSelected = true
            
        case .unselected:
            
            self.isSelected = false
        }
    }
}

extension TrainLevelComponent {
    
    struct Constants {
        
        static let imageWidth: Float = 55.9
        static let imageHeight: Float = 40.5
        static let cornerRadius: CGFloat = 6.0
    }
}
