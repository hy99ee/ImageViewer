//
//  ImagesCollectionViewController.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 23.12.2021.
//

import Foundation
import UIKit
import RealmSwift

class ImagesCollectionViewController: UICollectionViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var realm = try! Realm()
    
    private var imagesModel:[UnsplashPhoto?] = []
    private var images:Results<UnsplashPhotoObject>!
    
    private var selectedImages = [UIImage]()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeImageButtonTapped))
    }()
    
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        images = realm.objects(UnsplashPhotoObject.self)
        imagesModel = images.map({ UnsplashPhoto(managedObject: $0)})
        self.collectionView.reloadData()
        self.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view = GradientView(frame: view.frame, isBackground: true)
        
//        view.addSubview(GradientView(frame: view.frame, isBackground: true))
//        self.images.append(fetchedImages)


        
        
        images = realm.objects(UnsplashPhotoObject.self)
        imagesModel = images.map({ UnsplashPhoto(managedObject: $0)})
        self.collectionView.reloadData()
        self.refresh()

        
        undateNavButtonsState()
        collectionView.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func undateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        undateNavButtonsState()
    }
    
    // MARK: - NavigationItems action
    
    @objc private func removeImageButtonTapped() {
        let indexPaths = collectionView!.indexPathsForSelectedItems!
        let indexes = indexPaths.map { item in
            item.item
        }
        var newImages = [UnsplashPhotoObject]()
        for (index, image) in images!.enumerated() {
            if indexes.contains(index) {
                newImages.append(image)
            }
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(newImages)
        }
        
        self.collectionView!.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.collectionView!.deleteItems(at: indexPaths)

        }, completion: nil)
        print(#function)
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        print(#function)
        
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Favorites"
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.4374157488, green: 0.4473936558, blue: 0.7460577488, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItems = [addBarButtonItem]
    }
    

    
    // MARK: - UICollecionViewDataSource, UICollecionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if images != nil {
            let count = images.count
            return count
        }
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseId, for: indexPath) as! ImageCell
        let unsplashPhoto = images[indexPath.item]
        cell.unsplashPhoto = UnsplashPhoto(managedObject: unsplashPhoto)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        undateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        guard let image = cell.photoImageView.image else { return }
            selectedImages.append(image)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        undateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

//// MARK: - UISearchBarDelegate
//
//extension ImagesCollectionViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//
//    }
//}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(image.height) * widthPerItem / CGFloat(image.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
