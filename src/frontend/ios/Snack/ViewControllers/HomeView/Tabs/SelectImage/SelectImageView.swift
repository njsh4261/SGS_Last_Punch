//
//  SelectImageView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/19.
//

import UIKit

class SelectImageView: UIViewController {
    // MARK: - Properties
    private var images: [UIImage] = []
    var completionHandler: ((Int, UIImage) -> (Int, UIImage))?

    // MARK: - UI
    @IBOutlet private var collectionView: UICollectionView!

    override func viewDidLoad() {

        super.viewDidLoad()
        title = "이미지 선택"

        collectionView.register(UINib(nibName: "SelectImageCell", bundle: nil), forCellWithReuseIdentifier: "SelectImageCell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(actionDismiss))

        loadMedia()
    }

    // MARK: - Load methods
    func loadMedia() {

        for i in 1...24 {
            let image = UIImage(named: "\(i)")!
            images.append(image)
        }

        collectionView.reloadData()
    }

    // MARK: - User actions
    func actionPhoto(_ index: Int, _ image: UIImage) {
        _ = completionHandler?(index, image)
        dismiss(animated: true)
    }
    
    @objc func actionDismiss() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionView DataSource
extension SelectImageView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCell", for: indexPath) as! SelectImageCell

        let image = images[indexPath.item]
        cell.bindData(image)

        return cell
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension SelectImageView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: screenWidth/2, height: screenWidth/2)
    }
}

// MARK: - UICollection ViewDelegate
extension SelectImageView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: true)
        
        let image = images[indexPath.item]
        actionPhoto(indexPath.item + 1, image)
    }
}
