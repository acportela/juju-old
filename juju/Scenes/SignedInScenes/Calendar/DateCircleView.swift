//
//  DateCircleView.swift
//  juju
//
//  Created by Antonio Rodrigues on 15/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

final class DateCircleView: JTACDayCell {
    
    // MARK: Views
    private let title: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.white
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.sixteen)
        return label
    }()
    
    private let circle: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.dateSmallCircle
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let drop: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.urineDrop
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension DateCircleView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.circle)
        self.addSubview(self.title)
        self.addSubview(self.drop)
    }
    
    func setupConstraints() {
        
        self.circle.snp.makeConstraints { make in
            
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Constants.circleHeight)
        }
        
        self.title.snp.makeConstraints { make in
            
            make.center.equalTo(self.circle)
        }
        
        self.drop.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(Constants.dropWidth)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = .clear
        self.setEmpty()
    }
    
    private func setEmpty() {
        
        self.circle.alpha = 0
        self.drop.alpha = 0
    }
    
    private func setCirlcleOnly() {
        
        self.circle.alpha = 1
        self.drop.alpha = 0
    }
    
    private func setCircleAndDrop() {
        
        self.circle.alpha = 1
        self.drop.alpha = 1
    }
}

extension DateCircleView: ViewConfiguration {
    
    enum States {
        
        case empty
        case circle
        case circleAndDrop
        case setText(String)
    }
    
    func configure(with state: DateCircleView.States) {
    
        switch state {
            
        case .empty:
            
            self.setEmpty()
            
        case .circle:
            
            setCirlcleOnly()
            
        case .circleAndDrop:
            
            self.setCircleAndDrop()
            
        case .setText(let text):
            
            self.title.text = text
            
        }
    }
}

extension DateCircleView {
    
    struct Constants {
        
        static let cellWidth = 32
        static let circleHeight = 32
        static let dropWidth = 12
        static let dateCellItendifier = "DateCircleView"
    }
}
