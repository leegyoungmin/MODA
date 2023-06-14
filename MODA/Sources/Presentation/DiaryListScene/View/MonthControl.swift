//
//  MonthControl.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

protocol MonthControlDelegate: AnyObject {
    func monthControl(control: MonthControl, didTapMonth month: Int)
}

final class MonthControl: UIStackView {
    weak var delegate: MonthControlDelegate?
    
    /// UI Property
    private var buttons: [[UIButton]] = Array(repeating: [UIButton](), count: 3)
    
    /// Data Property
    private(set) var selectedMonth = PublishSubject<Int>()
    private var disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAppearance()
        configureButtons()
        configureHierarchy()
        
        bindings()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAppearance()
        configureButtons()
        configureHierarchy()
        
        bindings()
    }
    
    /// Binding Method
    private func bindings() {
        selectedMonth
            .subscribe { [weak self] event in
                guard let self = self, let index = event.element else { return }
                
                let column = index % 4, row = index / 4
                
                self.setButtonsBackgroundColor(row, column)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    @objc func didTapMonthButton(_ selector: UIButton) {
        delegate?.monthControl(control: self, didTapMonth: selector.tag)
    }
}

// MARK: UI 설정 관련 메서드
private extension MonthControl {
    private func configureAppearance() {
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 16
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.layer.cornerRadius = 12
    }
    
    private func setButtonsBackgroundColor(_ row: Int, _ col: Int) {
        let targetButton = buttons[row][col]
        
        for rowIndex in 0..<buttons.count {
            let count = buttons[row].count
            
            for colIndex in 0..<count {
                if colIndex != col || rowIndex != row {
                    let button = self.buttons[rowIndex][colIndex]
                    button.backgroundColor = UIConstants.Colors.secondaryColor
                    button.setTitleColor(.secondaryLabel, for: .normal)
                    button.titleLabel?.font = .systemFont(ofSize: 16)
                }
            }
        }
        
        
        targetButton.backgroundColor = UIConstants.Colors.accentColor
        targetButton.setTitleColor(UIColor.white, for: .normal)
        targetButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    }
    
    private func configureButtons() {
        for month in 0..<12 {
            let button = UIButton()
            button.setTitle("\(month + 1)", for: .normal)
            button.setTitleColor(.secondaryLabel, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.layer.backgroundColor = UIConstants.Colors.secondaryColor?.cgColor
            button.layer.cornerRadius = 8
            button.tag = month
            
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            
            button.addTarget(self, action: #selector(didTapMonthButton), for: .touchUpInside)
            
            buttons[month / 4].append(button)
        }
    }
    
    private func configureStackView() -> [UIStackView] {
        var stackViews = [UIStackView]()
        
        for _ in 0..<3 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 32
            stackView.isLayoutMarginsRelativeArrangement = false
            
            stackViews.append(stackView)
        }
        
        return stackViews
    }
    
    func configureHierarchy() {
        let stackViews = configureStackView()
        
        buttons.enumerated().forEach { buttonInfo in
            buttonInfo.element.forEach { button in
                stackViews[buttonInfo.offset].addArrangedSubview(button)
            }
        }
        
        stackViews.forEach(self.addArrangedSubview)
    }
}
