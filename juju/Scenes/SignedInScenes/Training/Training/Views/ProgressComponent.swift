//
//  ProgressComponent.swift
//  juju
//
//  Created by Antonio Portela on 12/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class ProgressComponent: UIView {
    
    // MARK: Views
    private let title: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Hoje"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.bold(ofSize: Styling.FontSize.eighteen)
        return label
    }()
    
    private let repetitionsLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .right
        label.text = .empty
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let seriesLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.text = .empty
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let progressBarBackground: UIView = {
        
        let view = UIView()
        view.backgroundColor = Styling.Colors.lightPeriwinkle
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let progressBarCompleted: UIView = {
        
        let view = UIView()
        view.backgroundColor = Styling.Colors.rosyPink
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let superiorComponentsStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .fillEqually
        stack.spacing = Styling.Spacing.eight
        return stack
    }()
    
    // MARK: Properties
    private var completedBarWidthConstraint: Constraint?

    private var repetitionsProgress: RepetitionsProgress = .empty {
        
        didSet {
            
            self.updateProgressOffset()
            self.updateRepetitionsLabel()
        }
    }
    
    private var series: Int = 0 {
        didSet {
            self.updateSeriesLabel()
        }
    }
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension ProgressComponent: ViewCoding {
    
    func addSubViews() {
        
        self.superiorComponentsStack.addArrangedSubview(self.seriesLabel)
        self.superiorComponentsStack.addArrangedSubview(self.title)
        self.superiorComponentsStack.addArrangedSubview(self.repetitionsLabel)
        self.addSubview(self.superiorComponentsStack)
        
        self.addSubview(self.progressBarBackground)
        self.addSubview(self.progressBarCompleted)
    }
    
    func setupConstraints() {
        
        self.superiorComponentsStack.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        self.progressBarBackground.snp.makeConstraints { make in
            
            make.height.equalTo(Constants.progressBarsHeight)
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.superiorComponentsStack.snp.bottom).offset(Styling.Spacing.eight)
        }
        
        self.progressBarCompleted.snp.makeConstraints { make in
            
            self.completedBarWidthConstraint = make.width.equalTo(0).constraint
            make.height.equalTo(Constants.progressBarsHeight)
            make.left.bottom.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = .clear
    }
}

extension ProgressComponent: ViewConfiguration {
    
    enum States {
        
        case initial(progress: RepetitionsProgress, series: Int)
        case incrementRepetition(progress: RepetitionsProgress)
    }
    
    func configure(with state: ProgressComponent.States) {
        
        switch state {
            
        case .initial(let progress, let series):
            
            self.series = series
            self.repetitionsProgress = progress
            
        case .incrementRepetition(let repetitionProgress):
            
            self.repetitionsProgress = repetitionProgress
        }
    }
    
    private func updateProgressOffset() {
        
        let newRatio = CGFloat(self.repetitionsProgress.current) / CGFloat(self.repetitionsProgress.total)
        
        let ratio = newRatio <= 1 ? newRatio : 1
        
        let offset = self.progressBarBackground.frame.width * ratio
        
        UIView.animate(withDuration: Constants.progressBarFillDuration) {
            
            self.completedBarWidthConstraint?.update(offset: offset)
        }
    }
    
    private func updateSeriesLabel() {
        
        self.seriesLabel.text = "Séries: \(self.series)"
    }
    
    private func updateRepetitionsLabel() {
        
        self.repetitionsLabel.text = "Repetições: \(self.repetitionsProgress.current)/\(self.repetitionsProgress.total)"
    }
}

extension ProgressComponent {
    
    struct Constants {
        
        static let cornerRadius: CGFloat = 7
        static let progressBarsHeight = 13
        static let progressBarFillDuration: Double = 1
    }
}
