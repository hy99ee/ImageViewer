//
//  PopUpView.swift
//  ImageViewerStoryboard
//
//  Created by Hy99ee on 27.12.2021.
//
import UIKit
import SwiftEntryKit

class PopUpView: UILabel {
    
    private let textMessage:String
    
    
    init(with textMessage:String) {
        self.textMessage = textMessage
        super.init(frame: UIScreen.main.bounds)
        setupTextOnLabel()
//        addSubview(Text(error))
//        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupTextOnLabel(){
        numberOfLines = 0
        backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        text = textMessage
        textColor = .white
        font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

