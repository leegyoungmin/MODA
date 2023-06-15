//
//  NoticeSettingViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

protocol NoticeSettingDelegate: AnyObject {
    func noticeSettingView(
        controller: NoticeSettingViewController,
        didTapSave time: (hour: Int, minute: Int)
    )
}

final class NoticeSettingViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "setting_time"~
        label.textColor = UIConstants.Colors.accentColor
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel.withAlphaComponent(0.4)
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "time_notice"~
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("confirm"~, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = UIConstants.Colors.accentColor?.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let timePicker = UITimePicker()
    
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0
    
    weak var delegate: NoticeSettingDelegate?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        timePicker.timeDelegate = self
        
        saveButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                delegate?.noticeSettingView(
                    controller: self,
                    didTapSave: (selectedHour, selectedMinute)
                )
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension NoticeSettingViewController: TimePickerDelegate {
    func timePicker(picker: UITimePicker, didSelectedTime time: (hour: Int, minute: Int)) {
        selectedHour = time.hour
        selectedMinute = time.minute
    }
}

private extension NoticeSettingViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel, explainLabel, timePicker, saveButton].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        explainLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        timePicker.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(explainLabel.snp.bottom).offset(16)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5).priority(.high)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.equalTo(timePicker.snp.leading)
            $0.top.equalTo(timePicker.snp.bottom).offset(16)
            $0.trailing.equalTo(timePicker.snp.trailing)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
