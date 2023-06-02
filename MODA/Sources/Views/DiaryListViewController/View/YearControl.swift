//
//  YearControl.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

protocol YearControlDelegate: AnyObject {
    func yearControl(
        control: YearControl,
        didTapNext button: UIButton
    )
    
    func yearControl(
        control: YearControl,
        didTapPrevious button: UIButton
    )
}

final class YearControl: UIStackView {
    weak var delegate: YearControlDelegate?
    
    /// UI Property
    private(set) var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = Date().toString("yyyy년")
        return label
    }()
    
    private(set) var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    /// Data Property
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAppearance()
        bindings()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAppearance()
        bindings()
    }
    
    private func configureAppearance() {
        self.distribution = .equalCentering
        self.axis = .horizontal
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        [minusButton, yearLabel, plusButton].forEach(addArrangedSubview)
    }
    
    private func bindings() {
        plusButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                delegate?.yearControl(control: self, didTapNext: plusButton)
            }
            .disposed(by: disposeBag)
        
        minusButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                delegate?.yearControl(control: self, didTapPrevious: minusButton)
            }
            .disposed(by: disposeBag)
    }
}
