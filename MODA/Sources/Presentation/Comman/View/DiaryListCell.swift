//
//  DiaryListCell.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

final class DiaryListCell: UITableViewCell {
    private let diaryContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIConstants.Colors.secondaryColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIConstants.Colors.accentColor
        label.textAlignment = .center
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 48)
        label.textAlignment = .center
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIConstants.Images.star, for: .normal)
        button.setImage(UIConstants.Images.starFill, for: .selected)
        return button
    }()
    
    private(set) var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIConstants.Images.trash, for: .normal)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 8
        return stackView
    }()
    
    private let onChangeLike: (Bool) -> Void
    private let onDeleteItem: () -> Void
    private let cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    let data: AnyObserver<Diary>
    var item: Diary?
    let toggleLike: Observable<Bool>
    let deleteItem: Observable<Void>
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let onData = PublishSubject<Diary>()
        let toggleLikeButton = PublishSubject<Bool>()
        let tappedDeleteButton = PublishSubject<Void>()
        
        data = onData.asObserver()
        
        onChangeLike = { toggleLikeButton.onNext($0) }
        onDeleteItem = { tappedDeleteButton.onNext(()) }
        
        toggleLike = toggleLikeButton
        deleteItem = tappedDeleteButton
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .white
        
        configureUI()
        binding()
        
        onData.observe(on: MainScheduler.instance)
            .subscribe(onNext: { diary in
                self.createdDateLabel.text = "\(diary.createdDay) 일"
                self.conditionLabel.text = diary.condition.description
                self.contentLabel.text = diary.content
                self.starButton.isSelected = diary.isLike
                self.item = diary
            })
            .disposed(by: cellDisposeBag)
    }
    
    required init?(coder: NSCoder) {
        let onData = PublishSubject<Diary>()
        let toggleLikeButton = PublishSubject<Bool>()
        let tappedDeleteButton = PublishSubject<Void>()
        
        data = onData.asObserver()
        
        onChangeLike = { toggleLikeButton.onNext($0) }
        onDeleteItem = { tappedDeleteButton.onNext(()) }
        
        toggleLike = toggleLikeButton
        deleteItem = tappedDeleteButton
        
        super.init(coder: coder)
        
        configureUI()
        binding()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        )
        
        diaryContentView.frame = diaryContentView.frame.inset(
            by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func binding() {
        starButton.addTarget(self, action: #selector(didTapStarButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    @objc func didTapStarButton(_ selector: UIButton) {
        let isLike = selector.isSelected
        selector.isSelected.toggle()
        onChangeLike(!isLike)
    }
    
    @objc func didTapDeleteButton(_ selector: UIButton) {
        onDeleteItem()
    }
}

// MARK: - UI 구성 관련 코드
private extension DiaryListCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [createdDateLabel, conditionLabel, dividerView, contentLabel]
            .forEach(diaryContentView.addSubview)
        
        [starButton, deleteButton].forEach(buttonStackView.addArrangedSubview)
        
        [buttonStackView, diaryContentView]
            .forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(12)
        }
        
        diaryContentView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(deleteButton.snp.bottom).offset(12)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        createdDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(50).priority(.high)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalTo(createdDateLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(createdDateLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(createdDateLabel.snp.top)
            $0.leading.equalTo(createdDateLabel.snp.trailing).offset(12)
            $0.bottom.equalTo(conditionLabel.snp.bottom)
            $0.width.equalTo(1)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.top)
            $0.bottom.lessThanOrEqualTo(dividerView.snp.bottom)
            $0.leading.equalTo(dividerView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}
