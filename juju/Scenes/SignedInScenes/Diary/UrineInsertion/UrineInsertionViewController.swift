//
//  UrineInsertionViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol UrineInsertionViewControllerDelegate: AnyObject {

    func urineInsertionViewControllerWantsToAddUrineLoss(_ controller: UrineInsertionViewController,
                                                         urineLoss: UrineLoss)
}

final class UrineInsertionViewController: UIViewController {

    public static let title = ""
    private let urineInsertionView = UrineInsertionView()
    private let losses: [UrineLoss] = [.low, .moderate, .high]

    weak var delegate: UrineInsertionViewControllerDelegate?

    init() {

        super.init(nibName: nil, bundle: nil)
        self.urineInsertionView.delegate = self
        self.urineInsertionView.popoverDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        self.view = self.urineInsertionView
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {

        self.dismiss(animated: false, completion: nil)
        super.viewWillDisappear(animated)
    }
}

extension UrineInsertionViewController {

    private func setupViews() {

        let firstRadioTitle = "Perda \(losses[0].destription)"
        let secondRatioTitle = "Perda \(losses[1].destription)"
        let thirdRatioTitle = "Perda \(losses[2].destription)"

        let titles = [firstRadioTitle, secondRatioTitle, thirdRatioTitle]

        let radioConfiguration = RadioButtonGroupConfiguration(titles: titles,
                                                               selectedIndex: 0)
        let buttonsConfiguration = DualActionButtonsConfiguration(primaryTitle: "confirmar",
                                                                  secondaryTitle: "voltar")
        let title = "Informe a quantidade de urina que perdeu"
        
        let urineViewConfiguration = UrineInsertionViewConfiguration(title: title,
                                                                     radioGroup: radioConfiguration,
                                                                     actionButtons: buttonsConfiguration)
        self.urineInsertionView.configure(with: .build(urineViewConfiguration))
    }

    private func close() {

        self.dismiss(animated: false, completion: nil)
    }
}

extension UrineInsertionViewController: UrineInsertionViewDelegate {

    func urineInsertionViewDidTapBack(_ view: UrineInsertionView) {

        self.close()
    }

    func urineInsertionViewDidChoose(_ view: UrineInsertionView, index: Int) {

        self.close()
        self.delegate?.urineInsertionViewControllerWantsToAddUrineLoss(self,
                                                                 urineLoss: self.losses[index])
    }
}

extension UrineInsertionViewController: PopoverViewDelegate {

    func popoverViewWasTappedOutsideContentView(_ view: PopoverView) {

        self.close()
    }
}
