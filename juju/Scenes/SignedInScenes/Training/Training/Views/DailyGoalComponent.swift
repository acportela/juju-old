//
//  DailyGoalComponent.swift
//  juju
//
//  Created by Antonio Portela on 12/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class DailyGoalComponent: UIView {
    
    // MARK: Views
    private let title: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Meta Diária"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.sixteen)
        return label
    }()
    
    private let progressLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .right
        label.text = "0/0"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.twelve)
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
    
    // MARK: Properties
    private var completedBarWidthConstraint: Constraint?

    private var progress: Progress = .empty {
        
        didSet {
            
            self.updateProgressOffset()
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

extension DailyGoalComponent: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.title)
        self.addSubview(self.progressLabel)
        self.addSubview(self.progressBarBackground)
        self.addSubview(self.progressBarCompleted)
    }
    
    func setupConstraints() {
        
        self.title.snp.makeConstraints { make in
            
            make.centerX.top.equalToSuperview()
        }
        
        self.progressLabel.snp.makeConstraints { make in
            
            make.right.equalToSuperview()
            make.centerY.equalTo(self.title.snp.centerY)
        }
        
        self.progressBarBackground.snp.makeConstraints { make in
            
            make.height.equalTo(Constants.progressBarsHeight)
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.title.snp.bottom).offset(Styling.Spacing.eight)
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

extension DailyGoalComponent: ViewConfiguration {
    
    struct Progress {
        
        var current: Int
        var total: Int
        
        static let empty = Progress(current: 0, total: 0)
    }
    
    enum States {
        
        case set(current: Int, total: Int)
    }
    
    func configure(with state: DailyGoalComponent.States) {
        
        switch state {
            
        case .set(let current, let total):
            
            self.progressLabel.text = "\(current)/\(total)"
            self.progress = Progress(current: current, total: total)

        }
    }
    
    func updateProgressOffset() {
        
        let newRatio = CGFloat(self.progress.current) / CGFloat(self.progress.total)
        
        let ratio = newRatio <= 1 ? newRatio : 1
        
        let offset = self.progressBarBackground.frame.width * ratio
        
        UIView.animate(withDuration: Constants.progressBarFillDuration) {
            
            self.completedBarWidthConstraint?.update(offset: offset)
        }
    }
}

extension DailyGoalComponent {
    
    struct Constants {
        
        static let cornerRadius: CGFloat = 7
        static let progressBarsHeight = 13
        static let progressBarFillDuration: Double = 1
    }
}
