//
//  ViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit

class DiaryListViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            DiaryListCell.self,
            forCellWithReuseIdentifier: DiaryListCell.identifier
        )
        
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = Date().month()
        return label
    }()
    
    private let monthButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let tintColor = UIColor(named: "AccentColor") ?? .black
        let image = UIImage(systemName: "chevron.down.circle.fill")?
            .withConfiguration(symbolConfiguration)
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let mockDatas: [Diary] = Diary.mockDatas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        monthButton.addTarget(
            self,
            action: #selector(didTapMonthButton),
            for: .touchUpInside
        )
        
        configureUI()
    }
}

private extension DiaryListViewController {
    @objc func didTapMonthButton() {
    }
}

extension DiaryListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return mockDatas.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DiaryListCell.identifier,
            for: indexPath
        ) as? DiaryListCell else {
            return UICollectionViewCell()
        }
        
        let item = mockDatas[indexPath.row]
        cell.setUpDatas(to: item)
        return cell
    }
}

extension DiaryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.width / 2)
    }
}

private extension DiaryListViewController {
    func configureUI() {
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [collectionView].forEach(view.addSubview)
    }
    
    func configureNavigationBar() {
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, monthButton])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 6
        titleStackView.frame.size.width = titleLabel.frame.width + monthButton.frame.width
        titleStackView.frame.size.height = max(titleLabel.frame.height, monthButton.frame.height)
        navigationItem.titleView = titleStackView
        
        let presentAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            let controller = DiaryWriteViewController()
            self.present(controller, animated: true)
        }
        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: presentAction)
        addButton.tintColor = UIColor(named: "AccentColor")
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}
