//
//  SavedDiaryViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit

final class SavedDiaryViewController: UIViewController {
    private let savedDiaryListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SavedDiaryCell.self,
            forCellWithReuseIdentifier: SavedDiaryCell.identifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    private let mockDatas: [Diary] = Diary.mockDatas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        savedDiaryListView.dataSource = self
        savedDiaryListView.delegate = self
    }
}

extension SavedDiaryViewController: UICollectionViewDataSource {
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
            withReuseIdentifier: SavedDiaryCell.identifier,
            for: indexPath
        ) as? SavedDiaryCell else {
            return UICollectionViewCell()
        }
        
        let item = mockDatas[indexPath.row]
        cell.setUpData(to: item)
        
        return cell
    }
}

extension SavedDiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height * 0.4)
    }
}

private extension SavedDiaryViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [savedDiaryListView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        savedDiaryListView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
