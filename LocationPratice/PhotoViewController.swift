//
//  ViewController.swift
//  LocationPratice
//
//  Created by 권우석 on 2/3/25.
//

import UIKit
import PhotosUI
import SnapKit



final class PhotoViewController: UIViewController {
    
    var delegate: PhotoViewControllerDelegate?
    
    lazy var photoCV = UICollectionView(frame: .zero, collectionViewLayout: createPhotoCollectionView())
    private var images: [UIImage] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCV()
    }
    
    private func createPhotoCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = (UIScreen.main.bounds.width - 30) / 2
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        view.addSubview(photoCV)
        
        photoCV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    func addButtonTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // NumberOflines이랑 비슷하구만
        configuration.mode = .default
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true )
    }
    
    func setupCV() {
        photoCV.delegate = self
        photoCV.dataSource = self
        photoCV.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.id)
    }
    
}


extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.id, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }
    
    //delegate로 이미지 전달  -> 다시 정리 해보기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.item]
        delegate?.imageReceived(self, image: selectedImage)
        //WeatherViewController.imageReceived(<#T##self: WeatherViewController##WeatherViewController#>) 이걸 딜리게이트로 표현한건지?
    }
}


extension PhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for i in 0..<results.count {
            let selectedImage = results[i]
            
            if selectedImage.itemProvider.canLoadObject(ofClass: UIImage.self) {
                selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.images.append(image)
                        }
                        self.photoCV.reloadData()
                    }
                }
            }
        }
        dismiss(animated: true)
        
    }
}


