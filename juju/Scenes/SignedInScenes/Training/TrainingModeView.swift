//
//  TrainingModeView.swift
//  juju
//
//  Created by Antonio Portela on 13/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

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
    
    let slowTrain = JujuButton(title: "Treino Lento", theme: .secondary)
    let fastTrain = JujuButton(title: "Treino Rápido", theme: .secondary)
    
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
}

extension TrainingModeView {
    
    struct Constants {
        
        static let buttonWidth = 173
        static let buttonHeight = 48
    }
}
