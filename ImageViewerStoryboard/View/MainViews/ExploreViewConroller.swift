//
//  ExploreViewConroller.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 24.12.2021.
//

import UIKit
import SwiftEntryKit
import RxSwift
import RxCocoa


final class ExploreViewConroller: UIViewController {
    
    var viewModel:ExploreViewModel!
    private var descriptionImageView:DescriptionImageView!
    private let imageView = ImageView()
    private var scrollView: UIScrollView!
    private var isHidden = false
    private let bag = DisposeBag()
    private let timerLabel = UILabel()
    private var _navigationsButtonsIsHidden:Bool = true
    private lazy var favoriteMark: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(favoriteMarkPressed))
    }()
    private var navigationsButtonsIsHidden:Bool{
        set{
            if newValue{
                navigationItem.rightBarButtonItem = nil
                navigationItem.leftBarButtonItem = nil
            }
            else{
                navigationItem.rightBarButtonItem = favoriteMark
                navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: timerLabel)
            }
            _navigationsButtonsIsHidden = newValue
        }
        get{
            return _navigationsButtonsIsHidden
        }
    }

    
    // MARK: - View Life Cycle

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
            
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = view.bounds.size
        scrollView.addSubview(imageView)
        descriptionImageView = DescriptionImageView()
        descriptionImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)

        scrollView.addSubview(descriptionImageView)
        view.addSubview(scrollView)
            
        imageView.heightImage.asObservable().subscribe(onNext: { [weak self] height in
            self?.descriptionImageView.frame = CGRect(x: 0, y: height + 10, width: (self?.view?.bounds.width ?? 0), height: 100)
            
        }).disposed(by: bag)

        
        timerLabelPosition()
        
        viewModel.unsplashPhoto.asObservable().subscribe(onNext: { [weak self] unsplashPhoto in
            guard let self = self else {return}
            if let error = unsplashPhoto.error {
                self.showError(error)
                self.navigationsButtonsIsHidden = true
            }
            else{
                self.navigationsButtonsIsHidden = false
            }
            self.imageView.unsplashPhoto = unsplashPhoto.data
            self.descriptionImageView.unsplashPhoto = unsplashPhoto.data
            
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: bag)
        viewModel.timer?.timerCount.asObservable().subscribe { [weak self] timerCount in
            self?.updateTimerLabel(timerCount: timerCount.element ?? 0)
        }.disposed(by: bag)
        
    }
    
    
    private func updateTimerLabel(timerCount:Int){
        timerLabel.text = String(timerCount)
    }
    
    
    // MARK: - Buttons actions

    @objc func favoriteMarkPressed() {
        viewModel.writeToDatabaseService()
        navigationsButtonsIsHidden = true
        
    }
    
    private func showError(_ error:ImageError){
        if !self.isHidden {
        SwiftEntryKit.display(entry: PopUpView(with: error), using: EKAttributes.topToast)
        }
    }
}




// MARK: - Setup UI elements position
extension ExploreViewConroller {
    
    private func timerLabelPosition(){
        timerLabel.text = "0"
        timerLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        timerLabel.textColor = .systemBlue
        timerLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timerLabel.textAlignment = .left
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: timerLabel)
        
    }
}
