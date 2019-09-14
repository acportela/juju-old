//
//  TrainingModeView.swift
//  juju
//
//  Created by Antonio Portela on 13/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol TrainingModeViewDelegate: AnyObject {
    
    func trainingModeViewDidTapSlowTrain(_ view: TrainingModeView)
    func trainingModeViewDidTapFastTrain(_ view: TrainingModeView)
}

final class TrainingModeView: UIView {
    
    // MARK: Views
    private let topBackground: UIView = {
        
        let view = UIView()
        view.backgroundColor = Styling.Colors.softPink
        return view
    }()
   
    private let bottomBackground: UIView = {
        
        let view = UIView()
        view.backgroundColor = Styling.Colors.softPinkTwo
        return view
    }()
    
    private let slowTrain = JujuButton(title: TrainingMode.slow.title, theme: .secondary)
    private let fastTrain = JujuButton(title: TrainingMode.fast.title, theme: .secondary)
    
    // MARK: Properties
    weak var delegate: TrainingModeViewDelegate?
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension TrainingModeView: ViewCoding {
    
    func addSubViews() {
     
        self.topBackground.addSubview(self.slowTrain)
        self.bottomBackground.addSubview(self.fastTrain)
        self.addSubview(self.topBackground)
        self.addSubview(self.bottomBackground)
    }
    
    func setupConstraints() {
        
        self.topBackground.snp.makeConstraints { make in
            
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.bottomBackground.snp.makeConstraints { make in
            
            make.top.equalTo(self.snp.centerY)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.slowTrain.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
        }
        
        self.fastTrain.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    func configureViews() {
        
        let slowTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSlowTrain))
        let fastTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFastTrain))
        self.topBackground.addGestureRecognizer(slowTapGesture)
        self.bottomBackground.addGestureRecognizer(fastTapGesture)
        
        self.slowTrain.onTapAction = {
            self.didTapSlowTrain()
        }
        
        self.fastTrain.onTapAction = {
            self.didTapFastTrain()
        }
    }
}

extension TrainingModeView {
    
    @objc
    private func didTapSlowTrain() {
        
        self.delegate?.trainingModeViewDidTapSlowTrain(self)
    }
    
    @objc
    private func didTapFastTrain() {
        
        self.delegate?.trainingModeViewDidTapFastTrain(self)
    }
}

extension TrainingModeView {
    
    struct Constants {
        
        static let buttonWidth = 173
        static let buttonHeight = 48
    }
}
